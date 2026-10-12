# Compatibilite apres mise a jour des dependances - 10 octobre 2026

## Causes et correctifs

- Google Fonts 9 migre vers material_ui et fournit un autre type TextTheme que
  celui utilise dans les themes actuels. Version 8.2.1 epinglee : aucun changement
  massif des ecrans ni de leur rendu. Ce correctif commun concerne les quatre
  parcours GPX/PA, scolarite/examens.
- flutter_lints 6 introduisait de nombreuses nouvelles recommandations de style.
  Retour aux regles 4 existantes ; aucune desactivation supplementaire des erreurs.
- Le script tool/wire_scolarite_remote_text.dart importait analyzer sans le
  declarer. Ajout comme dependance de developpement et adaptation du noeud AST
  des valeurs par defaut a FormalParameterDefaultClause.
- Les autres mises a jour de dependances sont conservees. L'override Android
  permission_handler_android reste en place.

## Verification

Premiere analyse : 2921 signalements melant erreurs, avertissements et informations.
Apres restauration des versions compatibles : trois signalements, dont une erreur
dans le script de maintenance, ensuite corrigee.

Analyse finale complete : **0 erreur, 1 avertissement, 1 information**.
Restent un Future retourne sans await dans un try de cp_user_notes_service.dart
et un import relatif dans ad_policy_test.dart. La commande retourne encore 1
a cause de l'avertissement ; elle n'est pas declaree entierement verte.

Suite Flutter complete apres correction des dependances : **210 reussites, 2 echecs**.
Les deux echecs correspondent a ceux de l'audit precedent : test des chemins des
25 planches de grades sous Windows et debordement a 320 px avec texte agrandi
dans continue_preparation_panel. Ils ne sont pas declares resolus ici.

La compilation Android et les achats sur appareil restent a verifier avant
diffusion. Ne pas executer de mise a jour majeure globale avant la validation
du bundle ; Google Fonts 9 necessite une migration distincte des themes.
