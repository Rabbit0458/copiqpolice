# 🚀 RESUME HERE — Reprise de session (mode CODING)

> **À LIRE EN PREMIER À CHAQUE NOUVELLE SESSION.**
> Le projet est passé en **mode codage**. Toute la spec est figée dans les fichiers de référence. Ta seule mission : **avancer dans `PROGRESSION_CODE.md`**.

---

## ⚡ TL;DR — Que faire dès le démarrage

1. Ouvrir `docs/cas_pratique/PROGRESSION_CODE.md`
2. Trouver la **première tâche non cochée** (ligne `- [ ] CODE-XXX —`)
3. **L'exécuter intégralement** sans demander quoi que ce soit à Kaïs
4. La marquer `- [x] (YYYY-MM-DD)` une fois terminée
5. Mettre à jour `07_STATE.json` : `last_completed_task`, `next_task`, `completed` counter
6. Enchaîner avec la suivante tant qu'il reste des tokens
7. Si la limite arrive → finir proprement la tâche en cours, la marquer `- [~]`, puis stop

**Aucune question à Kaïs.** Carte blanche dans le cadre des specs. Si vraiment bloqué : marquer `- [!]` dans `PROGRESSION_CODE.md` et passer à la suivante.

---

## 📂 Fichiers de référence (specs figées)

| Fichier                              | Quand le consulter                                         |
|--------------------------------------|------------------------------------------------------------|
| **PROGRESSION_CODE.md**              | **Toujours** — liste des 50 tâches de code                 |
| 07_STATE.json                        | Au démarrage pour voir `next_task`                         |
| 01_MASTER_PLAN.md                    | Pour rappel stratégique (rarement nécessaire)              |
| 03_SCHEMA.sql                        | Pour les tâches CODE-001 à CODE-008 (migrations)           |
| 04_CORRECTION_ENGINE_SPEC.md         | Pour les tâches CODE-019 à CODE-028 (moteur)               |
| 05_DESIGN_SYSTEM.md                  | Pour les tâches CODE-029 à CODE-040 (UI)                   |
| 06_ADMIN_PANEL_SPEC.md               | Phase admin (ultérieure)                                    |
| 09_TEST_PLAN.md                      | Pour CODE-049 (tests)                                       |
| 10_API_SURFACE.md                    | Pour les tâches CODE-010 à CODE-018 (modèles + repo)       |
| fixtures/example_case_complete.json  | Format JSON cible pour la migration legacy (CODE-046)      |

---

## 🧭 État global

- **Phase actuelle** : `phase_A_database`
- **Prochaine tâche** : `CODE-001` — Créer le dossier `supabase/migrations/` et la migration initiale (extensions)
- **Complétées** : 0 / 50

---

## 🛡️ Règles strictes

1. **Ne pas inventer une spec** — toujours se référer aux fichiers `.md` / `.sql` / `.json`
2. **Ne pas changer la palette** : `#1147D9` (light) / `#000B36` (dark), Montserrat
3. **Dark / Light mode obligatoire** sur chaque nouvelle page
4. **Pas de breaking change** dans `lib/` sans noter la décision dans `decisions_log` de `07_STATE.json`
5. **Pas d'exécution SQL sur Supabase** — laisser les migrations dans `supabase/migrations/`, Kaïs les exécutera
6. **Marquer la tâche `- [x]` UNIQUEMENT** quand le code compile (`flutter analyze` 0 issue sur les fichiers touchés)
7. **Toujours mettre à jour `07_STATE.json`** après une tâche (next_task + completed counter)

---

## 🚨 Si tu es vraiment bloqué

Ne devine pas. Marque la tâche `- [!]` dans `PROGRESSION_CODE.md`, complète le tableau "BLOCAGES & NOTES" en bas du fichier, mets à jour `blockers` dans `07_STATE.json`, et passe à la suivante.

Kaïs débloquera quand il sera dispo.
