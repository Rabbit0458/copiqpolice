import {
  access,
  cp,
  mkdir,
  readFile,
  rename,
  rm,
  stat,
  writeFile,
} from "node:fs/promises"
import { constants } from "node:fs"
import { dirname, join, resolve } from "node:path"
import { fileURLToPath } from "node:url"

const scriptDir = dirname(fileURLToPath(import.meta.url))
const projectDir = resolve(scriptDir, "..")
const workspaceDir = resolve(projectDir, "..")
const sourceDir = join(projectDir, "out")
const targetDir = join(workspaceDir, "fae16dc1")
const stagedDir = join(workspaceDir, ".fae16dc1-next")
const backupDir = join(workspaceDir, ".fae16dc1-backup")
const hostingConfig = join(projectDir, "deploy", ".htaccess")
const requiredRoutes = [
  "index.html",
  "404.html",
  "admin/index.html",
  "login/index.html",
  "signup/index.html",
  "auth/callback/index.html",
]

async function exists(path) {
  try {
    await access(path, constants.F_OK)
    return true
  } catch {
    return false
  }
}

async function assertFile(root, relativePath) {
  const path = join(root, relativePath)
  const info = await stat(path).catch(() => null)
  if (!info?.isFile() || info.size === 0) {
    throw new Error(`Export incomplet : ${relativePath} est absent ou vide.`)
  }
}

async function assertDirectory(root, relativePath) {
  const info = await stat(join(root, relativePath)).catch(() => null)
  if (!info?.isDirectory()) {
    throw new Error(`Export incomplet : le dossier ${relativePath} est absent.`)
  }
}

async function runtimeConfig() {
  const previousPath = join(targetDir, "copiq-config.js")
  if (await exists(previousPath)) {
    const previous = await readFile(previousPath, "utf8")
    if (!previous.includes("VOTRE_URL_SUPABASE_ICI")) return previous
  }

  const url = process.env.COPIQ_SUPABASE_URL
  const anonKey = process.env.COPIQ_SUPABASE_ANON_KEY
  const siteUrl = process.env.COPIQ_SITE_URL ?? "https://copiq.fr"
  if (url && anonKey) {
    return `window.COPIQ_CONFIG = ${JSON.stringify({
      SUPABASE_URL: url,
      SUPABASE_ANON_KEY: anonKey,
      SITE_URL: siteUrl,
    }, null, 2)};\n`
  }

  // Dans ce mono-dépôt, l'application Flutter reste la source de vérité.
  // Les deux valeurs ci-dessous sont publiques par nature (URL + clé anon) :
  // aucune clé service_role ou clé Stripe n'est copiée dans l'export.
  const flutterMain = join(workspaceDir, "lib", "main.dart")
  if (await exists(flutterMain)) {
    const dart = await readFile(flutterMain, "utf8")
    const flutterUrl = dart.match(/kSupabaseUrl\s*=\s*['"]([^'"]+)['"]/s)?.[1]
    const flutterAnonKey = dart.match(/kSupabaseAnonKey\s*=\s*['"]([^'"]+)['"]/s)?.[1]
    if (flutterUrl && flutterAnonKey) {
      return `window.COPIQ_CONFIG = ${JSON.stringify({
        SUPABASE_URL: flutterUrl,
        SUPABASE_ANON_KEY: flutterAnonKey,
        SITE_URL: siteUrl,
      }, null, 2)};\n`
    }
  }

  return readFile(join(projectDir, "public", "copiq-config.js"), "utf8")
}

async function main() {
  if (!(await exists(sourceDir))) {
    throw new Error("Le dossier copiq-web/out est absent. Lance d'abord la compilation Next.js.")
  }
  for (const route of requiredRoutes) await assertFile(sourceDir, route)
  await assertDirectory(sourceDir, "_next")

  const config = await runtimeConfig()
  await rm(stagedDir, { recursive: true, force: true })
  await rm(backupDir, { recursive: true, force: true })
  await mkdir(stagedDir, { recursive: true })
  await cp(sourceDir, stagedDir, { recursive: true, force: true })
  await cp(hostingConfig, join(stagedDir, ".htaccess"), { force: true })
  await writeFile(join(stagedDir, "copiq-config.js"), config, "utf8")
  await writeFile(
    join(stagedDir, "deployment-manifest.json"),
    `${JSON.stringify({
      product: "COP’IQ",
      generatedAt: new Date().toISOString(),
      source: "copiq-web/out",
      uploadFolder: "fae16dc1",
      verifiedRoutes: requiredRoutes.map((route) => `/${route.replace(/index\.html$/, "")}`),
    }, null, 2)}\n`,
    "utf8",
  )

  for (const route of requiredRoutes) await assertFile(stagedDir, route)
  await assertFile(stagedDir, ".htaccess")
  await assertFile(stagedDir, "copiq-config.js")
  await assertFile(stagedDir, "deployment-manifest.json")

  if (await exists(targetDir)) await rename(targetDir, backupDir)
  try {
    await rename(stagedDir, targetDir)
    await rm(backupDir, { recursive: true, force: true })
  } catch (error) {
    if (await exists(backupDir)) await rename(backupDir, targetDir)
    throw error
  }

  console.log("\n✓ fae16dc1 est à jour et prêt à être envoyé chez l'hébergeur.")
  console.log(`✓ ${requiredRoutes.length} routes critiques vérifiées, dont /admin/.`)
  if (config.includes("VOTRE_URL_SUPABASE_ICI")) {
    console.warn("⚠ copiq-config.js contient encore les valeurs Supabase de démonstration.")
  } else {
    console.log("✓ Configuration Supabase de production conservée.")
  }
}

main().catch((error) => {
  console.error(`\nPublication annulée : ${error.message}`)
  process.exitCode = 1
})
