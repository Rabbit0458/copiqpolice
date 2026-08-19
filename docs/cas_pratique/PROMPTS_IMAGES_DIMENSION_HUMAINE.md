# 🎨 Prompts images — Module DIMENSION HUMAINE (GPX Scolarité)

> **But** : générer les **12 visuels manquants** référencés par `GpxSchoolProgram.dimensionHumaine`
> dans `lib/features/home/home_page_gpx_school.dart` (lignes ~5805-5935).
> Aucun fichier Dart à modifier : les chemins `assets/images/*.jpeg` sont déjà câblés.

---

## ⚙️ Paramètres communs à TOUS les prompts

| Paramètre | Valeur |
|---|---|
| **Format final** | `1500 × 1100 px`, JPEG, qualité 85 |
| **Ratio à générer** | `4:3` (puis recadrage/redimension en 1500×1100) |
| **Midjourney** | `--ar 4:3 --style raw --stylize 150 --q 2` |
| **DALL·E 3 / Firefly / Flux** | ajouter *"photorealistic editorial photograph, 4:3"* |
| **Texte dans l'image** | ❌ interdit (aucun mot, logo, sigle, plaque) |
| **Uniformes** | ❌ pas d'uniforme de police française identifiable, pas d'écusson, pas de képi |

### 🎯 Suffixe de style — à coller à la fin de CHAQUE prompt

```
photographie éditoriale réaliste, appareil plein format 50mm, lumière naturelle douce,
faible profondeur de champ, colorimétrie sobre et légèrement désaturée, tons bleutés froids
en accord avec un bleu #1147D9, ambiance professionnelle française contemporaine,
cadrage horizontal 4:3, sans texte, sans logo, sans filigrane, sans uniforme identifiable
```

### 🚫 Prompt négatif — à coller à la fin de CHAQUE prompt

```
--no texte, lettres, mots, logo, filigrane, watermark, uniforme de police, écusson, arme,
sang, visage déformé, mains déformées, six doigts, rendu cartoon, illustration 3D,
couleurs saturées, HDR agressif, collage, bordure, cadre
```

### 🔒 Règle appliquée aux 4 sujets sensibles

Sujets **S3-2 (violences intrafamiliales)**, **AC6 (conduites suicidaires)**, **ADH4 (violences sexuelles et sexistes)**, **ADH6 (confrontation à la mort)** :
traitement **symbolique / abstrait** uniquement — jamais de victime reconnaissable, jamais de scène de violence, jamais d'acte représenté. Objets, mains, lumière, silhouettes hors-champ ou floues.

---

# 📸 LES 12 PROMPTS

---

## Image 1 — `dh1_fonctionnement.jpeg`
**Module** : DH1 — Le fonctionnement intellectuel et émotionnel dans l'intervention
**Route** : `/gpx/dimension_humaine/communication/dh1_fonctionnement`

**Prompt FR**
```
Gros plan sur le visage d'une femme adulte de profil, concentrée, regard tourné vers une fenêtre
lumineuse hors-champ, expression de réflexion calme et maîtrisée. Arrière-plan de bureau moderne
très flou en bokeh bleuté. Sensation de sang-froid et d'analyse mentale en cours.
+ [suffixe de style] + [prompt négatif]
```

**Prompt EN**
```
Close-up profile portrait of a focused adult woman looking toward an off-frame bright window,
calm and controlled thinking expression, modern office background heavily blurred into blue bokeh,
conveying composure and mental analysis
```

---

## Image 2 — `dh3_strategies_public.jpeg`
**Module** : DH3 — Les stratégies de communication adaptées avec le public
**Route** : `/gpx/dimension_humaine/communication/dh3_strategies_public`

**Prompt FR**
```
Un homme adulte en tenue civile sobre, debout dans une rue piétonne européenne, en train de parler
posément à deux passants ; posture ouverte, paume de main tournée vers le haut, léger sourire
rassurant. Vue de trois quarts, distance moyenne. Lumière de fin d'après-midi, arrière-plan urbain
flou. Sensation de dialogue apaisé et de désamorçage.
+ [suffixe de style] + [prompt négatif]
```

**Prompt EN**
```
Adult man in plain civilian clothes standing in a European pedestrian street, calmly talking to two
passers-by, open posture, upturned palm, reassuring slight smile, three-quarter medium shot,
late afternoon light, blurred urban background, mood of de-escalation and calm dialogue
```

---

## Image 3 — `dh4_coordination.jpeg`
**Module** : DH4 — La coordination au sein des équipes de police
**Route** : `/gpx/dimension_humaine/communication/dh4_coordination_equipes`

**Prompt FR**
```
Quatre adultes en tenue de travail neutre et sombre réunis debout en cercle autour d'une table haute,
vus légèrement en plongée, en train de se coordonner avant une intervention ; l'un désigne un plan
posé sur la table. Visages partiellement hors-champ ou de dos, attention portée sur les gestes et la
cohésion du groupe. Salle de briefing sobre, lumière zénithale douce.
+ [suffixe de style] + [prompt négatif]
```

**Prompt EN**
```
Four adults in neutral dark workwear gathered standing in a circle around a high table, slight high
angle, coordinating before an operation, one pointing at a plan on the table, faces partly out of
frame or from behind, focus on gestures and group cohesion, plain briefing room, soft overhead light
```

---

## Image 4 — `adh2_posture_victime.jpeg`
**Module** : ADH2 — La posture professionnelle adaptée face à une victime
**Route** : `/gpx/dimension_humaine/communication/adh2_posture_victime`

**Prompt FR**
```
Deux personnes assises face à face dans une pièce claire et neutre ; au premier plan de dos et flou,
une personne dont on ne voit que l'épaule et la nuque ; en face, nette, une femme adulte penchée
légèrement en avant, mains posées à plat sur les genoux, écoute attentive et bienveillante.
Distance respectueuse entre les deux. Grande fenêtre en arrière-plan, lumière naturelle diffuse.
+ [suffixe de style] + [prompt négatif]
```

**Prompt EN**
```
Two people seated facing each other in a bright neutral room, foreground person seen from behind and
out of focus showing only shoulder and back of head, in front and sharp an adult woman leaning
slightly forward, hands flat on knees, attentive caring listening, respectful distance between them,
large window background, diffuse natural light
```

---

## Image 5 — `s3_2_violences_intrafamiliales.jpeg` 🔒 *sensible — symbolique*
**Module** : S3-2 — L'intervention auprès de victimes de violences intrafamiliales
**Route** : `/gpx/dimension_humaine/communication/s3_2_violences_intrafamiliales`

**Prompt FR**
```
Intérieur d'un salon familial modeste, vide de toute présence humaine, photographié depuis
l'encadrement d'une porte entrouverte. Un canapé, une table basse, un jouet d'enfant posé seul sur
le tapis. Lumière froide de fin de journée traversant un rideau. Atmosphère silencieuse et suspendue,
tension retenue, sans aucune personne visible, sans aucun désordre violent.
+ [suffixe de style] + [prompt négatif]
```

**Prompt EN**
```
Interior of a modest family living room, completely empty of people, photographed from a half-open
doorway, sofa, coffee table, a single child toy left on the rug, cold late-day light through a
curtain, silent suspended atmosphere, restrained tension, no person visible, no violent mess
```

---

## Image 6 — `dh2_stress.jpeg`
**Module** : DH2 — Le stress
**Route** : `/gpx/dimension_humaine/stress/dh2_stress`

**Prompt FR**
```
Un homme adulte assis seul sur un banc dans un couloir vitré, coudes sur les genoux, mains jointes
devant le visage, regard baissé, moment de décompression après une journée intense. Contre-jour
bleuté d'une baie vitrée, silhouette partiellement en ombre. Aucune détresse extrême : fatigue et
récupération.
+ [suffixe de style] + [prompt négatif]
```

**Prompt EN**
```
Adult man sitting alone on a bench in a glazed corridor, elbows on knees, hands clasped in front of
his face, eyes down, decompression moment after an intense day, blue backlight from a glass wall,
partially shadowed silhouette, fatigue and recovery rather than extreme distress
```

---

## Image 7 — `dh2_carnet_ressources.jpeg`
**Module** : DH2 — Le carnet des ressources
**Route** : `/gpx/dimension_humaine/stress/dh2_carnet_ressources`

**Prompt FR**
```
Vue de dessus rapprochée d'un carnet ouvert aux pages vierges posé sur une table en bois clair, un
stylo, une tasse de thé fumante et une paire de lunettes. Deux mains adultes tiennent le carnet en
bas du cadre. Lumière naturelle latérale douce, ambiance calme et introspective de fin de journée.
Pages strictement vierges, aucune écriture lisible.
+ [suffixe de style] + [prompt négatif]
```

**Prompt EN**
```
Close top-down view of an open notebook with strictly blank pages on a light wooden table, a pen, a
steaming cup of tea and a pair of glasses, two adult hands holding the notebook at the bottom of the
frame, soft side natural light, calm introspective end-of-day mood, no readable writing
```

---

## Image 8 — `adh9_agressivite.jpeg`
**Module** : ADH9 — Faire face à une situation d'agressivité
**Route** : `/gpx/dimension_humaine/stress/adh9_agressivite`

**Prompt FR**
```
Cadrage serré sur les mains et le buste d'un adulte en tenue civile sombre, paumes ouvertes levées à
hauteur de poitrine dans un geste d'apaisement et de mise à distance, face à une silhouette floue et
non identifiable au premier plan. Visages hors-champ. Rue le soir, lumière urbaine froide.
Tension maîtrisée, aucun contact physique, aucun geste violent.
+ [suffixe de style] + [prompt négatif]
```

**Prompt EN**
```
Tight framing on the hands and torso of an adult in dark civilian clothes, open palms raised at chest
height in a calming and distance-keeping gesture, facing a blurred unidentifiable silhouette in the
foreground, faces out of frame, evening street, cold urban light, controlled tension, no physical
contact, no violent gesture
```

---

## Image 9 — `ac6_suicide.jpeg` 🔒 *sensible — symbolique*
**Module** : AC6 — Les conduites suicidaires
**Route** : `/gpx/dimension_humaine/stress/ac6_conduites_suicidaires`

**Prompt FR**
```
Deux mains adultes qui se rejoignent au centre du cadre, l'une tenant fermement l'autre en signe de
soutien, sur fond sombre et neutre. Un rai de lumière chaude traverse le cadre par la gauche.
Métaphore visuelle du lien et du secours. Aucun visage, aucun objet, aucun contexte de lieu,
aucune allusion à un moyen ou à un acte.
+ [suffixe de style] + [prompt négatif]
```

**Prompt EN**
```
Two adult hands meeting at the center of the frame, one firmly holding the other in a gesture of
support, dark neutral background, a warm beam of light crossing from the left, visual metaphor of
connection and rescue, no faces, no objects, no location context, no reference to any means or act
```

> ⚠️ **Ne jamais** générer d'objet, de lieu en hauteur, de médicament ou de scène liée à un moyen.
> Cette image accompagne un module de formation : elle doit évoquer **l'aide**, pas le risque.

---

## Image 10 — `adh1_facultes_mentales.jpeg`
**Module** : ADH1 — L'intervention auprès de personnes ne jouissant pas de toutes leurs facultés mentales
**Route** : `/gpx/dimension_humaine/ethique/adh1_facultes_mentales`

**Prompt FR**
```
Un adulte accroupi à hauteur d'une personne âgée assise sur un banc public, vus de trois quarts
arrière pour préserver l'anonymat, main posée avec délicatesse sur l'avant-bras de la personne
assise. Parc urbain calme en arrière-plan très flou, lumière dorée rasante. Dignité, patience,
mise à niveau du regard. Aucun signe de contrainte, aucune détresse visible.
+ [suffixe de style] + [prompt négatif]
```

**Prompt EN**
```
An adult crouching down to the eye level of an elderly person seated on a public bench, seen from a
three-quarter rear angle preserving anonymity, hand gently placed on the seated person's forearm,
calm urban park heavily blurred in background, low golden light, dignity and patience, no restraint,
no visible distress
```

---

## Image 11 — `adh4_violences_sexuelles.jpeg` 🔒 *sensible — symbolique*
**Module** : ADH4 — Les violences sexuelles et sexistes
**Route** : `/gpx/dimension_humaine/ethique/adh4_violences_sexuelles_sexistes`

**Prompt FR**
```
Nature morte symbolique : une chaise vide en bois clair placée seule au centre d'une pièce sobre,
face à une fenêtre voilée d'un rideau blanc translucide. Un châle posé sur le dossier. Lumière
naturelle douce et froide, ombres longues au sol. Aucune personne, aucun corps, aucune allusion
explicite. Atmosphère de respect, de silence et d'écoute.
+ [suffixe de style] + [prompt négatif]
```

**Prompt EN**
```
Symbolic still life: a single empty light wooden chair in the center of a plain room facing a window
veiled with translucent white curtain, a shawl draped over the backrest, soft cold natural light,
long shadows on the floor, no person, no body, no explicit reference, atmosphere of respect, silence
and listening
```

---

## Image 12 — `adh6_confrontation_mort.jpeg` 🔒 *sensible — symbolique*
**Module** : ADH6 — La confrontation à la mort en situation professionnelle
**Route** : `/gpx/dimension_humaine/ethique/adh6_confrontation_mort`

**Prompt FR**
```
Silhouette d'un adulte de dos, immobile, debout devant une grande baie vitrée donnant sur un ciel
gris et bas en fin de journée. Cadrage large, personnage petit dans l'image, décentré à droite.
Intérieur neutre et vide. Sensation de recueillement, de gravité et de temps suspendu.
Aucun corps, aucun cercueil, aucune croix, aucun symbole religieux, aucune scène funéraire.
+ [suffixe de style] + [prompt négatif]
```

**Prompt EN**
```
Silhouette of an adult seen from behind, motionless, standing before a large glass window opening
onto a low grey end-of-day sky, wide framing with a small off-center figure on the right, neutral
empty interior, feeling of contemplation, gravity and suspended time, no body, no coffin, no cross,
no religious symbol, no funeral scene
```

---

# 📦 Après génération — procédure de mise en place

1. Récupérer les 12 fichiers générés (n'importe quel format : PNG, WEBP, JPEG).
2. Les déposer dans un dossier temporaire, par exemple `C:\Users\kaiso\Desktop\copiqpolice\_images_a_traiter\`.
3. Me demander : *« traite les images de Dimension Humaine »* — je m'occupe du renommage exact, du recadrage 4:3 et de l'export **JPEG 1500×1100 qualité 85** dans `assets/images/`.

Ou en manuel, avec ImageMagick :

```bash
magick source.png -resize 1500x1100^ -gravity center -extent 1500x1100 -quality 85 assets/images/dh1_fonctionnement.jpeg
```

## ✅ Checklist des 12 noms de fichiers attendus

- [ ] `assets/images/dh1_fonctionnement.jpeg`
- [ ] `assets/images/dh3_strategies_public.jpeg`
- [ ] `assets/images/dh4_coordination.jpeg`
- [ ] `assets/images/adh2_posture_victime.jpeg`
- [ ] `assets/images/s3_2_violences_intrafamiliales.jpeg`
- [ ] `assets/images/dh2_stress.jpeg`
- [ ] `assets/images/dh2_carnet_ressources.jpeg`
- [ ] `assets/images/adh9_agressivite.jpeg`
- [ ] `assets/images/ac6_suicide.jpeg`
- [ ] `assets/images/adh1_facultes_mentales.jpeg`
- [ ] `assets/images/adh4_violences_sexuelles.jpeg`
- [ ] `assets/images/adh6_confrontation_mort.jpeg`

> ℹ️ `assets/images/` est déjà déclaré en bloc dans `pubspec.yaml` — **aucune modification de `pubspec.yaml` n'est nécessaire**, il suffit de déposer les fichiers puis de relancer l'app (hot restart, pas hot reload).

---

*Document généré le 2026-08-18 — périmètre : module Dimension Humaine, GPX Scolarité.*
