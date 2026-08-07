import assert from "node:assert/strict"
import test from "node:test"
import {
  blockingIssues,
  extractCourseMedia,
  validateCourse,
  validateCourseMedia,
  validateQuiz,
} from "../src/lib/admin/content-validation.ts"

test("une fiche complète est publiable", () => {
  const issues = validateCourse({
    title: "Responsabilité pénale",
    subtitle: "Les éléments constitutifs et les causes d’irresponsabilité",
    body: "# Principes\n\nLa responsabilité pénale repose sur un élément légal, un élément matériel et un élément moral. Cette fiche présente les conditions à vérifier et les exceptions applicables.",
    keyPoints: ["Identifier les trois éléments"],
    legalRefs: ["Code pénal, articles 121-1 et suivants"],
    color: "#1147D9",
  })

  assert.equal(blockingIssues(issues).length, 0)
})

test("les médias Markdown accessibles et sécurisés sont acceptés", () => {
  const markdown = "![Schéma de la procédure](https://cdn.copiq.fr/cours/procedure.webp)"

  assert.deepEqual(extractCourseMedia(markdown), [{
    alt: "Schéma de la procédure",
    source: "https://cdn.copiq.fr/cours/procedure.webp",
    index: 0,
  }])
  assert.equal(blockingIssues(validateCourseMedia(markdown)).length, 0)
})

test("les médias sans description, non sécurisés ou incompatibles sont bloqués", () => {
  const markdown = [
    "![](https://cdn.copiq.fr/cours/schema.png)",
    "![Photo](http://cdn.copiq.fr/cours/photo.jpg)",
    "![Document](https://cdn.copiq.fr/cours/support.pdf)",
  ].join("\n")

  assert.deepEqual(blockingIssues(validateCourseMedia(markdown)).map((issue) => issue.code), [
    "course-media-alt-1",
    "course-media-source-2",
    "course-media-format-3",
  ])
})

test("une fiche vide reste détectée comme non publiable", () => {
  const blockers = blockingIssues(validateCourse({
    title: "",
    body: "",
    keyPoints: [],
    legalRefs: [],
    color: "bleu",
  }))

  assert.deepEqual(blockers.map((issue) => issue.code), [
    "course-title",
    "course-body",
    "course-color",
  ])
})

test("une question complète est activable", () => {
  const issues = validateQuiz({
    question: "Quel élément caractérise l’intention de commettre l’infraction ?",
    options: ["L’élément légal", "L’élément matériel", "L’élément moral"],
    answer: "L’élément moral",
    category: "Droit pénal général",
    explanation: "L’élément moral traduit l’intention ou, lorsque le texte le prévoit, la faute non intentionnelle.",
    legalRef: "Code pénal, art. 121-3",
  })

  assert.equal(blockingIssues(issues).length, 0)
})

test("les doublons et la bonne réponse absente bloquent l’activation", () => {
  const blockers = blockingIssues(validateQuiz({
    question: "Quelle proposition est correcte ?",
    options: ["Réponse A", "réponse a", "Réponse B"],
    answer: "Réponse C",
    explanation: "",
  }))

  assert.deepEqual(blockers.map((issue) => issue.code), [
    "quiz-duplicates",
    "quiz-answer",
    "quiz-explanation",
  ])
})
