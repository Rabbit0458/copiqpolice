# Arborescence de l'application → site

`src/data/app-tree.json` reproduit la navigation de l'app Flutter (decks, catégories, modules).

1. `parse_tree.py` lit l'inventaire (`progression/inventaire_app/01_homes_cartes.md` et `03_scolarite.md`) et produit `app_tree.json`.
2. `gen_web_tree.py` ajoute les correspondances base (cours, fragments, quiz), copie les images utilisées dans `public/app/img/` et écrit `src/data/app-tree.json`.

Les chemins en tête des scripts sont ceux de l'environnement de travail de Claude ; adapter si besoin.
Détails et état du chantier : `progression/CHANTIER_WEB.md`.
