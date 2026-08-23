import assert from "node:assert/strict"
import test from "node:test"
import {
  PSYCHOTECHNIQUE_TARGET_TABLES,
  normalizeReportKind,
  resolvePsychotechniqueTable,
  resolveReportTarget,
} from "../src/lib/admin/report-target-resolver.ts"

test("les huit catégories psychotechniques et l'alias PA sont en liste blanche", () => {
  assert.deepEqual(PSYCHOTECHNIQUE_TARGET_TABLES, {
    attention_visuelle: "tests_psyco_attention_visuelle",
    calcul_mental: "tests_psyco_calcul_mental",
    concentration: "tests_psyco_concentration",
    logique_verbale: "tests_psyco_logique_verbale",
    raisonnement_logique: "tests_psyco_raisonnement_logique",
    raisonnement_spatial: "tests_psyco_raisonnement_spatial",
    rotations_symetries: "tests_psyco_rotations_symetries",
    suite_logique: "tests_psyco_suite_logique",
    suites_logiques: "tests_psyco_suite_logique",
  })
})

test("une catégorie psychotechnique connue résout une table fixe", () => {
  const target = resolveReportTarget({ kind: "psy", category: "calcul_mental" })
  assert.equal(target?.reportTable, "tests_psycotechnique_report")
  assert.equal(target?.targetTable, "tests_psyco_calcul_mental")
  assert.equal(target?.targetIdColumn, "question_id")
  assert.equal(target?.editable, true)
})

test("les variantes suite_logique et suites_logiques ciblent la même table", () => {
  assert.equal(resolvePsychotechniqueTable("suite_logique"), "tests_psyco_suite_logique")
  assert.equal(resolvePsychotechniqueTable("suites_logiques"), "tests_psyco_suite_logique")
})

test("une catégorie inconnue ne peut ni être éditée ni supprimée", () => {
  const target = resolveReportTarget({ kind: "psy", category: "table_inventee" })
  assert.equal(target?.targetTable, null)
  assert.equal(target?.editable, false)
  assert.equal(target?.deletable, false)
})

test("les alias culture/cg sont normalisés sans changer la table cible", () => {
  assert.equal(normalizeReportKind("cg"), "culture")
  assert.equal(resolveReportTarget({ kind: "culture" })?.targetTable, "quiz_questions")
  assert.equal(resolveReportTarget({ kind: "cg" })?.targetTable, "quiz_questions")
})

test("un type de signalement inconnu est rejeté", () => {
  assert.equal(resolveReportTarget({ kind: "n_importe_quoi" }), null)
  assert.equal(resolveReportTarget({ kind: null }), null)
})

test("un report_question sans question_id reste volontairement non résolu", () => {
  const target = resolveReportTarget({ kind: "question" })
  assert.equal(target?.reportTable, "report_question")
  assert.equal(target?.targetTable, null)
  assert.equal(target?.editable, false)
  assert.equal(target?.deletable, false)
})

