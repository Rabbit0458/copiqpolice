import assert from "node:assert/strict";
import test from "node:test";
import {
  activeCourseTemplates,
  blocksFromTemplate,
  moveArrayItem,
} from "../src/app/admin/actif/active-content-templates.ts";

test("les six modèles demandés sont disponibles et composés", () => {
  assert.deepEqual(
    activeCourseTemplates.map((template) => template.id),
    [
      "simple",
      "legal_sheet",
      "code_article",
      "circular",
      "procedure",
      "complete",
    ],
  );
  assert.ok(
    activeCourseTemplates.every((template) => template.blocks.length > 0),
  );
});

test("un modèle est cloné avant modification", () => {
  const first = blocksFromTemplate("complete");
  const second = blocksFromTemplate("complete");
  first[0].text = "Texte modifié";
  assert.notEqual(second[0].text, first[0].text);
});

test("le déplacement des blocs respecte les limites", () => {
  assert.deepEqual(moveArrayItem(["a", "b", "c"], 0, 2), ["b", "c", "a"]);
  assert.deepEqual(moveArrayItem(["a", "b"], 0, 5), ["a", "b"]);
});
