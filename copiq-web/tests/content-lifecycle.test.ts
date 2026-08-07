import assert from "node:assert/strict"
import test from "node:test"
import { lifecycleError, publicationStatusOf, toIsoDateTime, toLocalDateTime } from "../src/lib/admin/content-lifecycle.ts"

test("les anciens booléens restent compatibles", () => {
  assert.equal(publicationStatusOf({ is_published: true }), "published")
  assert.equal(publicationStatusOf({ is_active: false }), "draft")
})

test("un état éditorial explicite reste prioritaire", () => {
  assert.equal(publicationStatusOf({ publication_status: "archived", is_published: true }), "archived")
  assert.equal(publicationStatusOf({ publication_status: "scheduled" }), "scheduled")
})

test("une planification exige une date future", () => {
  assert.ok(lifecycleError("scheduled", ""))
  assert.ok(lifecycleError("scheduled", "2000-01-01T08:00"))
  assert.equal(lifecycleError("scheduled", "2999-01-01T08:00"), null)
  assert.equal(lifecycleError("draft", ""), null)
})

test("les dates de formulaire sont converties sans perdre l'instant", () => {
  const iso = toIsoDateTime("2030-03-12T14:30")
  assert.ok(iso)
  assert.equal(toIsoDateTime(toLocalDateTime(iso)), iso)
})
