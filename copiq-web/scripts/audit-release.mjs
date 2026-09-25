import { readFile, readdir, stat } from "node:fs/promises"
import { extname, join, relative, resolve } from "node:path"

const root = resolve(import.meta.dirname, "..")
const out = join(root, "out")
const failures = []
const warnings = []

async function walk(directory) {
  const entries = await readdir(directory, { withFileTypes: true })
  const nested = await Promise.all(entries.map(async (entry) => {
    const path = join(directory, entry.name)
    return entry.isDirectory() ? walk(path) : [path]
  }))
  return nested.flat()
}

function fail(message) { failures.push(message) }
function warn(message) { warnings.push(message) }

async function isFile(path) { return (await stat(path).catch(() => null))?.isFile() ?? false }

function staticTarget(pathname) {
  const clean = decodeURIComponent(pathname.split(/[?#]/)[0]).replace(/^\/+/, "")
  if (!clean) return join(out, "index.html")
  if (extname(clean)) return join(out, clean)
  return join(out, clean, "index.html")
}

const files = await walk(out)
const htmlFiles = files.filter((path) => path.endsWith(".html"))
const textFiles = files.filter((path) => /\.(?:html|js|mjs|css|json|txt|xml)$/i.test(path))

const criticalPages = [
  "index.html", "404.html", "privacy/index.html", "cgu/index.html",
  "mentions-legales/index.html", "contact/index.html", "tarifs/index.html",
  "robots.txt", "sitemap.xml", "admin/index.html",
  "admin/statistiques/index.html", "admin/exploitation/index.html", "admin/pilotage-avance/index.html", "admin/demo/index.html",
]
for (const route of criticalPages) if (!(await isFile(join(out, route)))) fail(`Fichier critique absent : ${route}`)

for (const path of textFiles) {
  const content = await readFile(path, "utf8")
  const name = relative(out, path)
  const secretPatterns = [
    [/SUPABASE_SERVICE_ROLE(?:_KEY)?\s*[:=]/i, "clé Supabase privilégiée"],
    [/\bsk_(?:live|test)_[A-Za-z0-9]{16,}\b/, "clé secrète Stripe"],
    [/-----BEGIN (?:RSA |EC |OPENSSH )?PRIVATE KEY-----/, "clé privée"],
  ]
  for (const [pattern, label] of secretPatterns) if (pattern.test(content)) fail(`${label} détectée dans ${name}`)
}

for (const path of htmlFiles) {
  const html = await readFile(path, "utf8")
  const name = relative(out, path)
  if (/https?:\/\/localhost(?::\d+)?/i.test(html)) fail(`URL locale publiée dans ${name}`)
  if (!/<title>[^<]{3,}<\/title>/i.test(html)) fail(`Titre HTML absent : ${name}`)
  if (!/<meta[^>]+name=["']description["'][^>]+content=["'][^"']{20,}/i.test(html) && !/<meta[^>]+content=["'][^"']{20,}["'][^>]+name=["']description["']/i.test(html)) warn(`Meta description à contrôler : ${name}`)
  for (const image of html.matchAll(/<img\b[^>]*>/gi)) if (!/\balt=(?:["'][^"']*["']|[^\s>]+)/i.test(image[0])) fail(`Image sans attribut alt : ${name}`)
  for (const match of html.matchAll(/\bhref=["']([^"']+)["']/gi)) {
    const href = match[1]
    if (!href.startsWith("/") || href.startsWith("//") || href.startsWith("/api/")) continue
    if (!(await isFile(staticTarget(href)))) fail(`Lien interne cassé dans ${name} : ${href}`)
  }
}

const homeHtml = await readFile(join(out, "index.html"), "utf8")
const appIconUrl = "https://nuoonagnkhbeeymtvrcn.supabase.co/storage/v1/object/public/assets/app_icon.png"
if (!homeHtml.includes(appIconUrl)) fail("Le favicon COP'IQ public est absent de la page d'accueil")
if (!homeHtml.includes('property="og:image"')) fail("L'image Open Graph globale est absente")

for (const article of htmlFiles.filter((path) => relative(out, path).startsWith("blog/") && relative(out, path) !== "blog/index.html")) {
  const html = await readFile(article, "utf8")
  const name = relative(out, article)
  if (!html.includes('property="og:image"')) fail(`Image Open Graph absente de l'article : ${name}`)
  if (!/<img\b[^>]+src=["'][^"']+supabase\.co\/storage\/v1\/object\/public\/assets\//i.test(html)) {
    fail(`Image éditoriale Supabase absente de l'article : ${name}`)
  }
}

const jsFiles = files.filter((path) => /\.(?:js|mjs)$/i.test(path))
let totalJs = 0
let largest = { path: "", size: 0 }
for (const path of jsFiles) {
  const size = (await stat(path)).size
  totalJs += size
  if (size > largest.size) largest = { path, size }
}
if (largest.size > 1_200_000) fail(`Bundle JavaScript individuel trop lourd : ${relative(out, largest.path)} (${Math.round(largest.size / 1024)} Ko)`)
if (totalJs > 12_000_000) warn(`Poids JavaScript total élevé : ${Math.round(totalJs / 1024 / 1024)} Mo`)

console.log(`Audit de livraison : ${htmlFiles.length} pages HTML, ${jsFiles.length} bundles JavaScript.`)
console.log(`Plus gros bundle : ${relative(out, largest.path)} · ${Math.round(largest.size / 1024)} Ko.`)
for (const message of warnings) console.warn(`AVERTISSEMENT : ${message}`)
if (failures.length) {
  for (const message of failures) console.error(`ERREUR : ${message}`)
  throw new Error(`${failures.length} contrôle(s) bloquant(s) ont échoué.`)
}
console.log("Audit validé : pages critiques, secrets, SEO, images et liens internes contrôlés.")
