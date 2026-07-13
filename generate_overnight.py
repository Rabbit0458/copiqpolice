#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
CoPiQ Police — Générateur autonome 9M+ questions de culture générale
Exécution overnight sans intervention humaine requise.
20 workers parallèles · DeepSeek API · Supabase REST
"""

# ──────────────────────────────────────────────────────────────────────────────
# 0. AUTO-INSTALL DÉPENDANCES
# ──────────────────────────────────────────────────────────────────────────────
import sys, subprocess, os

def _install(*pkgs):
    for p in pkgs:
        mod = p.split("==")[0].replace("-", "_")
        try:
            __import__(mod)
        except ImportError:
            print(f"[SETUP] Installation de {p}…")
            subprocess.check_call(
                [sys.executable, "-m", "pip", "install", p,
                 "--break-system-packages", "-q"],
                stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL,
            )

_install("aiohttp", "supabase")

# ──────────────────────────────────────────────────────────────────────────────
# 1. IMPORTS
# ──────────────────────────────────────────────────────────────────────────────
import asyncio, aiohttp, json, logging, time, random, re
from datetime import datetime
from pathlib import Path

# ──────────────────────────────────────────────────────────────────────────────
# 2. CONFIGURATION
# ──────────────────────────────────────────────────────────────────────────────
SUPABASE_URL  = "https://nuoonagnkhbeeymtvrcn.supabase.co"
SUPABASE_KEY  = (
    "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9."
    "eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im51b29uYWdua2hiZWV5bXR2cmNuIiwicm9sZSI6"
    "InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc1NjA2MTQ0NSwiZXhwIjoyMDcxNjM3NDQ1fQ."
    "m601M1RYcIwZYGW95jRr1TTawZ3W3W5TZM5GiFI0uh4"
)
DEEPSEEK_KEY  = "sk-90ae169a0ffa4ec78313c9742677b042"
ANTHROPIC_KEY = (
    "sk-ant-api03-dyXyLSMFDPqwpPmqVIx3TSWbuLCqnzH_vo4k6Fy2f4_DgjD_"
    "kzLvnapUs4jT-_LpYi6rx0dmrz07B3yhfRz9tg-5b5PCwAA"
)
OPENAI_KEY    = (
    "sk-proj-nGJRGhPUHxcFg-Ut2Tn5ajr6Gq8xFBD3qx19f1Q5n2Vh_HOGbRa3d3wspAxWPPTpuHx1a-"
    "jKbtT3BlbkFJGzfPI5kw4d8R8KAZOOAgMjd0GSX8FEia4N72KHtGdXsewltnDyb3aYBerCEvB8U7pl8yW826EA"
)

BATCH_GEN    = 100    # questions par appel IA
BATCH_INS    = 500    # lignes par INSERT Supabase
WORKERS      = 20     # workers async parallèles
LOG_FILE     = Path(__file__).parent / "generation_log.txt"
CKPT_FILE    = Path(__file__).parent / "generation_checkpoint.json"

# ──────────────────────────────────────────────────────────────────────────────
# 3. LOGGING
# ──────────────────────────────────────────────────────────────────────────────
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s │ %(levelname)-8s │ %(message)s",
    datefmt="%H:%M:%S",
    handlers=[
        logging.FileHandler(LOG_FILE, encoding="utf-8", mode="a"),
        logging.StreamHandler(sys.stdout),
    ],
)
log = logging.getLogger("copiq")

# ──────────────────────────────────────────────────────────────────────────────
# 4. CATÉGORIES ET THÈMES
# ──────────────────────────────────────────────────────────────────────────────
CATEGORIES = [
    {
        "category": "Culture générale — Police (culture pro)",
        "module":   "Culture générale",
        "target":   2_000_000,
        "themes": [
            "Organisation et structure de la Police Nationale française (DGPN, DCPJ, DCSP, DCCRS, PP)",
            "Les grades policiers : gardien de la paix, brigadier, brigadier-chef, capitaine, commissaire",
            "Le Code de déontologie de la police nationale : principes fondamentaux et obligations",
            "Les missions de la police nationale : ordre public, police judiciaire, renseignement",
            "La police judiciaire vs police administrative : pouvoirs et différences essentielles",
            "La garde à vue : durée légale, droits du gardé à vue, rôle de l'OPJ",
            "Le RAID (Recherche, Assistance, Intervention, Dissuasion) : missions et interventions",
            "La BRI (Brigade de Recherche et d'Intervention) : rôle et histoire",
            "La BAC (Brigade Anti-Criminalité) : organisation et missions quotidiennes",
            "La BSPP (Brigade de Sapeurs-Pompiers de Paris) et sa relation avec la police",
            "Histoire de la police française : de la lieutenance générale de police (1667) à nos jours",
            "La police de proximité : concept, mise en œuvre, résultats",
            "Technologies policières : FAED, FNAEG, STIC, vidéosurveillance, reconnaissance faciale",
            "La coopération policière européenne : Europol, Schengen, mandat d'arrêt européen",
            "Interpol : organisation, notices rouges, coopération internationale",
            "Le statut général des fonctionnaires de police : droits, obligations, carrière",
            "Le secret professionnel et l'obligation de réserve des policiers",
            "La responsabilité pénale et disciplinaire des fonctionnaires de police",
            "L'usage légal de la force et la légitime défense en contexte policier",
            "Police nationale vs Gendarmerie nationale : compétences territoriales et missions",
            "La Police Municipale : attributions, limites, coopération avec la PN",
            "Armement et équipements réglementaires : pistolet SIG Sauer SP2022, LBD, bâton",
            "Numéros d'urgence : 17 (police), 15 (SAMU), 18 (pompiers), 112 (urgences EU)",
            "Le contrôle d'identité : conditions légales, procédure, textes applicables",
            "La flagrance : définition juridique, pouvoirs du policier en flagrant délit",
            "La perquisition : mandat judiciaire, conditions, procédure légale",
            "L'Officier de Police Judiciaire (OPJ) : pouvoirs, responsabilités, diplôme",
            "La Police Technique et Scientifique (PTS) : IJ, empreintes, balistique, criminalistique",
            "Lutte antiterroriste en France : DGSI, UCLAT, état d'urgence, loi SILT",
            "La cybercriminalité et l'OCLCTIC (Office Central de Lutte contre la Cybercriminalité)",
            "Les violences conjugales et intrafamiliales : protocoles policiers, EVVI",
            "La protection des mineurs : UAPED, brigades spécialisées, procédures adaptées",
            "Drogues et stupéfiants : cadre légal, saisies, missions de la douane vs police",
            "Crime organisé : OCRB, OCRTIS, cartels, réseaux mafieux opérant en France",
            "Les grandes affaires criminelles françaises résolues : méthodes et enseignements",
            "Statistiques criminelles françaises : indicateurs, tendances, sources (ONDRP, SSMSI)",
            "La Police aux Frontières (PAF) : missions, organisation, coopération Frontex",
            "Le Renseignement Territorial (RT) et la surveillance des milieux radicalisés",
            "La médiation policière et la police communautaire",
            "Le concours de gardien de la paix : épreuves, coefficients, programme",
            "Le concours de brigadier et d'officier de police : voies d'accès",
            "L'ENSP (École Nationale Supérieure de Police) et l'ENSOP",
            "Les droits syndicaux dans la police nationale",
            "L'IGPN (Inspection Générale de la Police Nationale) : rôle et enquêtes",
            "La question de la violence policière : cadre légal, contrôles, réformes",
            "Le rapport policier / procureur de la République",
            "La permanence judiciaire et le parquet de nuit",
            "Les UPJ (Unités de Prévention et de Justice) pour les mineurs délinquants",
            "La réforme de la police nationale 2023 : restructuration, directions, objectifs",
            "Le budget de la police nationale : effectifs, financement, équipements",
        ],
    },
    {
        "category": "Culture générale — Sport",
        "module":   "Culture générale",
        "target":   1_000_000,
        "themes": [
            "Football : Coupe du Monde FIFA (vainqueurs depuis 1930, records, anecdotes)",
            "Football : Ligue 1 française (clubs, records, champions historiques)",
            "Football : Champions League UEFA (vainqueurs, records, grands matchs)",
            "Football : équipe de France (joueurs légendaires, Zidane, Platini, palmarès)",
            "Football : règles du jeu, arbitrage, VAR, hors-jeu",
            "Rugby : Coupe du Monde (vainqueurs, palmarès, records)",
            "Rugby : Top 14 (clubs, champions, joueurs emblématiques)",
            "Rugby : équipe de France de rugby et ses figures historiques",
            "Tennis : Roland-Garros (vainqueurs, records, courts emblématiques)",
            "Tennis : Wimbledon (palmarès, grands moments, gazon)",
            "Tennis : US Open et Australian Open (champions, records)",
            "Tennis : Federer, Nadal, Djokovic, Borg, McEnroe (carrières et titres)",
            "Cyclisme : Tour de France (vainqueurs depuis 1903, maillots, records)",
            "Cyclisme : Giro, Vuelta, Paris-Roubaix, classiques belges",
            "Athlétisme : records du monde (100m, marathon, saut, lancer)",
            "Jeux Olympiques d'été : histoire (Athènes 1896), villes, champions français",
            "Jeux Olympiques d'hiver : histoire, disciplines, médailles françaises",
            "Basketball NBA : champions, MVP, records (Jordan, LeBron, Kobe)",
            "Basketball : Pro A, équipe de France, Evan Fournier, Tony Parker",
            "Natation : records du monde, Phelps, Manaudou, Thorpe",
            "Formule 1 : champions du monde (Schumacher, Hamilton, Verstappen, Prost)",
            "Handball : équipe de France et ses titres mondiaux et olympiques",
            "Judo : champions français aux JO (Riner, Pareto), règles, grades",
            "Boxe : champions du monde historiques (Ali, Tyson, Mayweather)",
            "Sports d'hiver : ski alpin (Killy, Girardelli, Shiffrin), biathlon, curling",
            "Golf : majeurs (Masters, Open, US Open), champions (Woods, Nicklaus)",
            "Natation synchronisée, plongeon, water-polo",
            "Sports féminins français : football féminin, handball féminin, basket féminin",
            "Histoire du sport français depuis 1900 : grandes étapes",
            "Les stades français iconiques : Parc des Princes, Stade de France, Vélodrome",
            "Escrime française : champions olympiques, règles",
            "Taekwondo, karaté, lutte aux JO : règles et champions",
            "Volleyball et beach-volley : compétitions mondiales, équipes françaises",
            "Équitation et sports équestres aux JO",
            "L'histoire des JO de Paris 1900, 1924 et 2024",
            "Les sportifs français les plus médaillés aux JO de l'histoire",
        ],
    },
    {
        "category": "Culture générale — Sciences",
        "module":   "Culture générale",
        "target":   1_000_000,
        "themes": [
            "Physique : lois de Newton (inertie, F=ma, action-réaction)",
            "Physique : relativité restreinte et générale d'Einstein (E=mc², courbure de l'espace-temps)",
            "Physique : mécanique quantique (dualité onde-corpuscule, principe d'incertitude)",
            "Physique : électromagnétisme (lois de Maxwell, champ électrique, induction)",
            "Physique : thermodynamique (lois, entropie, machines thermiques)",
            "Chimie : tableau périodique des éléments (groupes, périodes, propriétés)",
            "Chimie : liaisons chimiques (covalente, ionique, hydrogène, Van der Waals)",
            "Chimie : réactions chimiques (oxydoréduction, acide-base, équilibres)",
            "Biologie : la cellule eucaryote et procaryote (organites, membrane, noyau)",
            "Biologie : l'ADN, ARN et la synthèse des protéines (transcription, traduction)",
            "Biologie : la division cellulaire (mitose, méiose, cycle cellulaire)",
            "Biologie : l'évolution darwinienne (sélection naturelle, mutation, spéciation)",
            "Biologie : la génétique mendélienne (lois de Mendel, dominance, récessivité)",
            "Biologie : les écosystèmes (chaînes alimentaires, biodiversité, biomes)",
            "Astronomie : le système solaire (planètes, caractéristiques, distances)",
            "Astronomie : le Soleil (structure, énergie, vent solaire, éclipses)",
            "Astronomie : les étoiles (classification, cycle de vie, supernova, trous noirs)",
            "Astronomie : la Voie Lactée et les galaxies (types, distances)",
            "Astronomie : l'univers (Big Bang, expansion, matière noire)",
            "Mathématiques : nombres premiers, théorème de Pythagore, théorème de Thalès",
            "Mathématiques : fonctions, dérivées, intégrales (notions fondamentales)",
            "Mathématiques : probabilités et statistiques",
            "Informatique : histoire des ordinateurs (Turing, von Neumann, premiers PC)",
            "Informatique : algorithmes, langage de programmation, systèmes d'exploitation",
            "Informatique : Internet (TCP/IP, HTTP, DNS, création du Web)",
            "Intelligence artificielle : machine learning, réseaux de neurones, deep learning",
            "Géologie : tectonique des plaques, volcanisme, séismes",
            "Géologie : formation des roches (magmatiques, sédimentaires, métamorphiques)",
            "Climatologie : effet de serre, réchauffement climatique, El Niño",
            "Botanique : photosynthèse, classification des végétaux, plantes endémiques",
            "Zoologie : classification animale (vertébrés, invertébrés, insectes, mammifères)",
            "Médecine : grandes découvertes (vaccins Pasteur, pénicilline Fleming, ADN Watson-Crick)",
            "Médecine : système immunitaire, anticorps, vaccins, auto-immunité",
            "Prix Nobel de sciences : grands lauréats et leurs découvertes",
            "Grands scientifiques : Newton, Einstein, Curie, Darwin, Pasteur, Hawking",
            "Inventions majeures : imprimerie, électricité, moteur à vapeur, Internet",
            "Énergies : fossiles (pétrole, charbon), nucléaire, renouvelables (solaire, éolien)",
            "Nanotechnologies : définition, applications médicales et industrielles",
            "La conquête spatiale : Apollo, ISS, rover Mars, projets Artemis",
            "Biochimie : enzymes, vitamines, hormones, métabolisme",
        ],
    },
    {
        "category": "Droit",
        "module":   "Culture générale",
        "target":   1_000_000,
        "themes": [
            "La Constitution française du 4 octobre 1958 : articles fondamentaux, Ve République",
            "La Déclaration des Droits de l'Homme et du Citoyen du 26 août 1789",
            "Le Préambule de la Constitution de 1946 et les droits économiques et sociaux",
            "Droit pénal : distinction crime, délit, contravention, peines associées",
            "Code pénal : infractions contre les personnes (meurtre, homicide, viol, violence)",
            "Code pénal : infractions contre les biens (vol, escroquerie, abus de confiance, recel)",
            "Code pénal : infractions contre l'État (trahison, terrorisme, corruption)",
            "Code de procédure pénale : enquête préliminaire et procédures en flagrance",
            "Code de procédure pénale : l'instruction judiciaire (juge d'instruction, ordonnances)",
            "Code de procédure pénale : la phase de jugement (débats, délibéré, condamnation)",
            "Les peines en droit français : emprisonnement, amende, travail d'intérêt général, sursis",
            "La prescription pénale : délais selon la nature des infractions, imprescriptibilité",
            "La légitime défense : conditions cumulatives, excès de légitime défense",
            "L'état de nécessité : définition et exemples jurisprudentiels",
            "La responsabilité pénale : éléments constitutifs (légal, matériel, moral)",
            "Les circonstances aggravantes et atténuantes en droit pénal français",
            "Le droit civil : les contrats (formation, validité, exécution, résolution)",
            "Le droit de la famille : mariage, PACS, union libre, divorce, filiation",
            "Droit des successions : héritiers réservataires, quotité disponible, testament",
            "Droit de la propriété : acquisition, preuve, servitudes, expropriation",
            "Droit de la responsabilité civile délictuelle : faute, dommage, lien de causalité",
            "Droit administratif : les actes administratifs unilatéraux (arrêté, décret, circulaire)",
            "Droit administratif : le recours pour excès de pouvoir (REP)",
            "Les juridictions judiciaires en France : TJ, CA, Cour de cassation",
            "Les juridictions administratives : TA, CAA, Conseil d'État",
            "Le Conseil Constitutionnel : composition, saisine, QPC",
            "La Cour Européenne des Droits de l'Homme (CEDH) : saisine, arrêts, effets",
            "Les libertés fondamentales : liberté d'expression, liberté de la presse",
            "La présomption d'innocence : principe constitutionnel et conventionnel",
            "Le droit au procès équitable (article 6 CEDH)",
            "Non bis in idem, in dubio pro reo, nulla poena sine lege : principes fondamentaux",
            "Droit du travail : contrat de travail (CDI, CDD), licenciement, droits des salariés",
            "Droit de la protection sociale : Sécurité Sociale, retraite, chômage (UNEDIC)",
            "Droit européen : primauté, effet direct, directives et règlements",
            "La Charte des droits fondamentaux de l'UE",
            "Droit de la propriété intellectuelle : brevet, marque, droit d'auteur, droits voisins",
            "Le droit à l'image et la protection de la vie privée (RGPD, loi Informatique et Libertés)",
            "La laïcité en droit français : loi 1905, neutralité de l'État",
            "Droit international public : traités, organisations internationales, immunités diplomatiques",
            "Les droits fondamentaux des détenus en droit français",
        ],
    },
    {
        "category": "Geographie",
        "module":   "Culture générale",
        "target":   1_000_000,
        "themes": [
            "Capitales d'Europe : pays de l'UE et leurs capitales, populations, langues officielles",
            "Capitales d'Afrique subsaharienne : pays, capitales, populations estimées",
            "Capitales d'Afrique du Nord et du Moyen-Orient",
            "Capitales d'Asie du Sud et du Sud-Est (Inde, Pakistan, Bangladesh, Vietnam, Thaïlande)",
            "Capitales d'Asie centrale et orientale (Chine, Japon, Corée, Kazakhstan)",
            "Capitales d'Amérique du Nord et d'Amérique Centrale",
            "Capitales d'Amérique du Sud : pays, capitales, fleuve Amazone, Andes",
            "Capitales d'Océanie et des îles du Pacifique",
            "Superficies des pays du monde : les 30 plus grands États par superficie",
            "Populations mondiales : pays les plus peuplés, densités, évolution démographique",
            "Les plus grands fleuves du monde : Nil, Amazone, Yangtsé, Mississippi, Congo",
            "Les plus hautes montagnes : Everest, K2, Kangchenjunga, Mont-Blanc, Kilimandjaro",
            "Les déserts du monde : Sahara, Gobi, Atacama, Namib, Arabia",
            "Les océans et mers : Pacifique, Atlantique, Indien, Arctique, Austral — superficies, profondeurs",
            "Les plus grandes îles du monde : Groenland, Nouvelle-Guinée, Bornéo, Madagascar",
            "Les pays sans accès à la mer (landlocked countries) dans le monde",
            "Les fuseaux horaires : méridiens, UTC, GMT, décalages",
            "Géographie physique de la France : massifs, plaines, bassins, littoral",
            "Les fleuves français : Loire, Rhône, Seine, Garonne, Rhin — longueurs, bassins versants",
            "Les régions françaises depuis 2016 : 13 régions métropolitaines, chefs-lieux",
            "Les départements français : numéros, préfectures, arrondissements",
            "Les DOM-ROM-COM français : statuts, populations, localisation",
            "Géographie économique mondiale : PIB nominal et PPP des principales économies",
            "Les ressources naturelles par région : pétrole, gaz, charbon, minerais",
            "Les pays membres de l'Union Européenne : 27 États, adhésions successives",
            "Les pays membres de l'OTAN : 32 membres, historique des adhésions",
            "Les détroits et canaux stratégiques : Gibraltar, Ormuz, Suez, Panama, Malacca",
            "Les zones sismiques et ceintures volcaniques mondiales",
            "Géographie humaine : grandes métropoles mondiales (Tokyo, Delhi, Shanghai, Paris)",
            "Les frontières naturelles et leurs enjeux géopolitiques",
            "La géographie des pôles : Arctique, Antarctique, enjeux climatiques et politiques",
            "Les pays frontaliers de la France (8 pays) et leurs caractéristiques",
            "Géographie du Proche et Moyen-Orient : États, frontières, ressources pétrolières",
            "Géographie de l'Afrique : grandes régions, désertification, lac Victoria, fleuve Congo",
            "La géographie des conflits : zones de tension, États faillis",
            "Les chaînes de montagnes : Alpes, Pyrénées, Himalaya, Andes, Rocheuses — sommets clés",
            "Les lacs du monde : Caspienne, Supérieur, Victoria, Baïkal",
            "Les pays les plus densément peuplés et les moins densément peuplés",
            "Géographie climatique : zones tropicales, tempérées, polaires",
            "Les routes commerciales maritimes et le commerce mondial",
        ],
    },
    {
        "category": "Histoire",
        "module":   "Culture générale",
        "target":   1_000_000,
        "themes": [
            "La Préhistoire : Homo sapiens, Homo erectus, néolithique, premières civilisations",
            "Égypte ancienne : pharaons, dynasties, pyramides, hiéroglyphes, déchiffrement",
            "La Grèce antique : cités-États, démocratie athénienne, guerres médiques, culture",
            "Rome antique : République romaine, empereurs, conquêtes, chute de l'Empire",
            "Le Moyen Âge : Mérovingiens (Clovis), Carolingiens (Charlemagne), Capétiens",
            "Les Croisades : causes, principales croisades (1096–1291), effets",
            "La Guerre de Cent Ans (1337-1453) : causes, batailles (Azincourt, Orléans), fin",
            "Jeanne d'Arc : vie, libération d'Orléans (1429), procès et bûcher (1431), réhabilitation",
            "La Renaissance italienne et française : humanisme, arts, Érasme, Machiavel",
            "Les guerres de religion en France (1562-1598) : catholicisme vs protestantisme, Édit de Nantes",
            "La monarchie absolue : Richelieu, Louis XIII, Louis XIV et Versailles",
            "Louis XIV et le Roi-Soleil : règne, guerres, révocation de l'Édit de Nantes",
            "Le siècle des Lumières : Voltaire, Rousseau, Montesquieu, Diderot, Encyclopédie",
            "La Révolution française de 1789 : causes économiques, sociales et politiques",
            "La Révolution française : prise de la Bastille, DDHC, abolition des privilèges",
            "La Convention nationale : Terreur (Robespierre), Thermidor, Directoire",
            "Napoléon Bonaparte : ascension (coup d'État 18 Brumaire), Consulat, Empire",
            "Napoléon : batailles majeures (Austerlitz, Iéna, Waterloo), Code civil, institutions",
            "La Restauration (1814-1830) : Louis XVIII, Charles X, libertés constitutionnelles",
            "La Monarchie de Juillet (1830-1848) : Louis-Philippe, essor industriel",
            "La IIe République et le Second Empire de Napoléon III (1848-1870)",
            "La Commune de Paris (1871) : causes, épisodes, répression, bilan",
            "La IIIe République : affaire Dreyfus, loi 1901, loi 1905 sur la laïcité",
            "La Première Guerre Mondiale : assassinat de François-Ferdinand, alliances, tranchées",
            "La Grande Guerre : batailles de Verdun, de la Marne, armistice du 11 novembre 1918",
            "Le traité de Versailles (1919) : conditions, réparations, création SDN",
            "L'entre-deux-guerres : crise de 1929, montée des fascismes (Italie, Allemagne)",
            "La Seconde Guerre Mondiale : invasion de la Pologne (1939), Blitzkrieg, chute de la France",
            "L'occupation de la France (1940-1944) : zones occupée/libre, Vichy, collaboration",
            "La Résistance française : de Gaulle à Londres, Jean Moulin, CNR, réseaux",
            "La Shoah en France : Vel d'Hiv (1942), déportations, rôle de Vichy, mémoire",
            "La Libération (juin-août 1944) : Débarquement de Normandie, libération de Paris",
            "La IVe République (1946-1958) : instabilité gouvernementale, décolonisation, Algérie",
            "La Guerre d'Algérie (1954-1962) : FLN, OAS, accords d'Évian, indépendance",
            "La Ve République : fondation par de Gaulle, institutions, Constitution de 1958",
            "Mai 68 : causes, événements (grèves, barricades), conséquences sociales et culturelles",
            "La France de 1969 à 1995 : Pompidou, Giscard d'Estaing, Mitterrand, cohabitations",
            "La chute du mur de Berlin (1989) et la réunification allemande",
            "La construction européenne depuis 1957 : traités, élargissements, monnaie unique",
            "La France de 1995 à nos jours : Chirac, Sarkozy, Hollande, Macron, réformes",
        ],
    },
    {
        "category": "Humanites",
        "module":   "Culture générale",
        "target":   1_000_000,
        "themes": [
            "Les 13 régions métropolitaines françaises (depuis 2016) : superficie, population, chef-lieu",
            "Les 101 départements français : numéros, noms, préfectures principales",
            "Les villes françaises les plus peuplées : Paris, Marseille, Lyon, Toulouse, populations",
            "L'économie française : PIB, secteurs (agriculture, industrie, services), dette publique",
            "Les grandes entreprises françaises et le CAC 40 : secteurs, chiffres d'affaires",
            "Les présidents de la Ve République : de Gaulle, Pompidou, Giscard, Mitterrand, Chirac, Sarkozy, Hollande, Macron",
            "Les Premiers ministres français marquants et leurs politiques",
            "Les symboles de la République : Marianne, drapeau tricolore, Marseillaise, devise, Bastille",
            "La langue française : histoire, Académie française, francophonie mondiale",
            "La gastronomie française : plats régionaux emblématiques, AOP, vins de France",
            "La littérature française classique : Molière, Racine, Corneille, Hugo, Balzac, Flaubert",
            "La littérature française moderne : Sartre, Camus, Beauvoir, Proust, Céline",
            "La culture française : musées (Louvre, Orsay, Pompidou), patrimoine UNESCO en France",
            "Le cinéma français : réalisateurs majeurs (Truffaut, Godard, Audiard), César",
            "La musique française : Piaf, Brel, Brassens, Gainsbourg, Souchon, variété actuelle",
            "La bande dessinée franco-belge : Hergé, Goscinny, Uderzo, Morris, Franquin",
            "Les langues régionales de France : breton, basque, alsacien, occitan, corse",
            "Les grandes universités françaises et les Grandes Écoles (ENS, Polytechnique, ENA/INSP)",
            "Le système éducatif français : école, collège, lycée, baccalauréat, supérieur",
            "Le système de santé français : hôpital public, sécu, médecine générale",
            "Les médias français : TF1, France 2, Le Monde, Le Figaro, BFM TV",
            "La démographie française : taux de natalité, mortalité, espérance de vie, immigration",
            "La France d'Outre-mer : Guadeloupe, Martinique, Réunion, Guyane, Nouvelle-Calédonie",
            "Les fleuves français et leurs bassins versants : Loire (le plus long), Seine, Rhône, Garonne",
            "Le relief français : Mont-Blanc (4810 m), Massif Central, Vosges, Jura, Pyrénées",
            "Le tourisme en France : 1er pays touristique mondial, sites les plus visités",
            "La France et l'Union Européenne : contributions, influence, présidences",
            "La politique étrangère de la France : siège permanent au CS ONU, Force de frappe nucléaire",
            "Les fêtes et traditions françaises : 14 juillet, Noël, Épiphanie, Mardi Gras",
            "L'architecture française : Eiffel, Haussmann, châteaux de la Loire, cathédrales gothiques",
            "La mode française et l'industrie du luxe : LVMH, Chanel, Dior, Hermès, Cartier",
            "La philosophie française : Descartes, Pascal, Voltaire, Rousseau, Sartre, Derrida",
            "L'art français : impressionnisme (Monet, Renoir), surréalisme (Dalí), contemporain",
            "La religion en France : catholicisme, islam, protestantisme, judaïsme, laïcité",
            "Les grandes villes françaises en dehors de Paris : histoire et spécificités",
        ],
    },
    {
        "category": "Cinéma",
        "module":   "Culture générale",
        "target":   1_000_000,
        "themes": [
            "Histoire du cinéma : frères Lumière (1895), Le Voyage dans la Lune (Méliès), cinéma muet",
            "La Nouvelle Vague française (1958-1968) : Godard, Truffaut, Chabrol, Rohmer, Varda",
            "Acteurs français légendaires : Jean Gabin, Gérard Depardieu, Jean-Paul Belmondo, Alain Delon",
            "Actrices françaises : Catherine Deneuve, Isabelle Huppert, Juliette Binoche, Sophie Marceau",
            "Réalisateurs français contemporains : Luc Besson, Jacques Audiard, François Ozon, Xavier Dolan",
            "Le Festival de Cannes : Palme d'Or (vainqueurs depuis 1955), histoire, cérémonies",
            "Les Césars du cinéma : créés en 1976, grands films récompensés, polémiques",
            "Les Oscars : palmarès historique, films français oscarisés, records",
            "Le cinéma américain classique : Golden Age Hollywood, studios Warner, MGM, Paramount",
            "Stanley Kubrick : 2001 l'Odyssée de l'Espace, Shining, Full Metal Jacket",
            "Steven Spielberg : E.T., Les Dents de la Mer, Schindler's List, Indiana Jones",
            "Martin Scorsese : Taxi Driver, Les Affranchis, Goodfellas, The Irishman",
            "Francis Ford Coppola : Le Parrain (trilogie), Apocalypse Now",
            "Alfred Hitchcock : Psychose, Les Oiseaux, Sueurs Froides, La Mort aux trousses",
            "Charlie Chaplin : Le Kid, Les Temps Modernes, Le Dictateur",
            "Orson Welles : Citizen Kane — souvent élu meilleur film de l'histoire",
            "La franchise James Bond : 25 films, tous les acteurs (Connery, Moore, Craig…)",
            "La saga Star Wars (1977-2019) : personnages, univers, réalisateurs",
            "Les films Marvel (MCU) : personnages principaux, Avengers, box-office mondial",
            "Le cinéma d'animation : Walt Disney, Pixar (Toy Story, Finding Nemo), Studio Ghibli (Miyazaki)",
            "Le cinéma d'horreur : Dracula, L'Exorciste, Halloween, Paranormal Activity",
            "Le cinéma de science-fiction : Metropolis, Blade Runner, Matrix, Interstellar",
            "Le box-office mondial : films les plus rentables (Avatar, Titanic, Avengers: Endgame)",
            "Kurosawa Akira : Les 7 Samouraïs, Rashomon (influence sur le cinéma occidental)",
            "Ingmar Bergman : Le Septième Sceau, Persona, cinéma suédois",
            "Vittorio De Sica, Rossellini : néoréalisme italien (Ladri di biciclette)",
            "Pedro Almodóvar : Tout sur ma mère, Volver, cinéma espagnol",
            "Bong Joon-Ho : Parasite (Palme d'Or + Oscar 2019-2020) — cinéma coréen",
            "La musique de film : John Williams (Star Wars, Indiana Jones), Ennio Morricone, Hans Zimmer",
            "Les films sur la Seconde Guerre Mondiale : La Liste de Schindler, La Grande Évasion",
            "Le western : Sergio Leone, John Ford, Clint Eastwood",
            "Les films de guerre français : La Grande Illusion (Renoir), Un long dimanche de fiançailles",
            "Les séries télévisées mondiales : Breaking Bad, Game of Thrones, The Wire",
            "Les techniques cinématographiques : plan-séquence, montage alterné, profondeur de champ",
            "Les remakes et adaptations littéraires au cinéma",
        ],
    },
    {
        "category": "Culture générale — Arts (Musique)",
        "module":   "Culture générale",
        "target":   1_000_000,
        "themes": [
            "Musique baroque (1600-1750) : Jean-Sébastien Bach (Toccata, Passions), Vivaldi (Quatre Saisons), Haendel",
            "Classicisme musical (1750-1820) : Mozart (Don Giovanni, Requiem, symphonies), Haydn",
            "Ludwig van Beethoven : vie, symphonies (5e, 9e), surdité, place dans l'histoire",
            "Romantisme musical (XIXe) : Chopin, Schubert, Brahms, Liszt, Mendelssohn",
            "Opéra romantique : Wagner (L'Anneau du Nibelung), Verdi (La Traviata, Rigoletto), Puccini",
            "Debussy et l'impressionnisme musical français (La Mer, Clair de lune)",
            "Maurice Ravel : Boléro, Ma Mère l'Oye, Concerto pour la main gauche",
            "Musique du XXe siècle : Stravinski (Sacre du Printemps), Bartók, Schoenberg (atonalisme)",
            "Musique contemporaine : minimalism (Philip Glass), Boulez, Berio",
            "Le jazz : origines (Nouvelle-Orléans), Louis Armstrong, Duke Ellington, Miles Davis",
            "Le jazz moderne : John Coltrane, Thelonious Monk, Charlie Parker, Keith Jarrett",
            "Blues et soul : Robert Johnson, BB King, Ray Charles, Aretha Franklin",
            "Rock'n'roll : Elvis Presley, Chuck Berry, Bill Haley — genèse dans les années 1950",
            "Les Beatles : histoire (1960-1970), membres, albums majeurs (Abbey Road, Sgt. Pepper)",
            "The Rolling Stones : histoire, albums cultes (Exile on Main St.), Mick Jagger",
            "Led Zeppelin : albums mythiques, Jimmy Page, Robert Plant",
            "Pink Floyd : The Dark Side of the Moon, The Wall — concept albums",
            "Bob Dylan : Nobel de littérature 2016, Blowin' in the Wind, folk-rock",
            "Queen : Bohemian Rhapsody, Freddie Mercury, Live Aid 1985",
            "Michael Jackson : Thriller (album le plus vendu), moonwalk, pop mondiale",
            "Madonna : carrière (30 ans), albums (Like a Virgin, Ray of Light), fashion icon",
            "La variété française : Édith Piaf (La Vie en Rose), Jacques Brel, Georges Brassens, Léo Ferré",
            "Serge Gainsbourg : Je t'aime moi non plus, Histoire de Melody Nelson, Je suis venu te dire",
            "Claude François, Johnny Hallyday, Michel Sardou : variété française des 60-80",
            "Jean-Jacques Goldman, Alain Souchon, Francis Cabrel : chanson française contemporaine",
            "Daft Punk : duo électro français (Random Access Memories, Get Lucky, Around the World)",
            "Le rap français : NTM, IAM, MC Solaar — origines et culture années 90",
            "Rap français contemporain : Booba, Jul, Orelsan, PNL, Nekfeu, Damso",
            "Rap américain : Public Enemy, Notorious B.I.G., Tupac, Jay-Z, Eminem, Kendrick Lamar",
            "Reggae : Bob Marley (No Woman No Cry, One Love), Peter Tosh, Ska, Dancehall",
            "Musique électronique : Kraftwerk, Aphex Twin, Chemical Brothers, David Guetta",
            "Musique latine : bossa nova (Jobim), salsa, tango argentin, flamenco espagnol",
            "Les instruments de musique : familles (cordes, vents, percussions), orchestration",
            "Les Grammy Awards : créés en 1959, catégories, artistes les plus récompensés",
            "Les albums les plus vendus de l'histoire (Thriller, Back in Black, The Dark Side of the Moon)",
            "Les festivals de musique : Glastonbury, Coachella, Hellfest, Rock en Seine, Eurockéennes",
        ],
    },
    {
        "category": "Culture générale — Santé (prévention)",
        "module":   "Culture générale",
        "target":   1_000_000,
        "themes": [
            "Le système cardiovasculaire : cœur, artères, veines, capillaires, circulation sanguine",
            "Le système nerveux : cerveau, moelle épinière, neurones, synapse, influx nerveux",
            "Le système respiratoire : poumons, bronches, alvéoles, échanges gazeux O2/CO2",
            "Le système digestif : de la bouche au côlon (estomac, intestin grêle, foie, pancréas)",
            "Le système osseux et musculaire : 206 os, muscles striés, articulations, tendons",
            "Le sang : globules rouges, blancs, plaquettes, groupes sanguins (ABO, Rhésus)",
            "Le système immunitaire : immunité innée, adaptative, anticorps, vaccins, lymphocytes",
            "L'ADN et la génétique : chromosomes (46 chez l'humain), gènes, mutations, maladies génétiques",
            "Les maladies cardiovasculaires : infarctus du myocarde (causes, symptômes, prévention)",
            "L'accident vasculaire cérébral (AVC) : symptômes FAST, urgence, séquelles",
            "L'hypertension artérielle : valeurs normales, risques, traitement",
            "Le cancer : types principaux (poumon, sein, côlon), facteurs de risque, traitements",
            "Le diabète de type 1 et 2 : mécanismes, glycémie, insuline, complications",
            "Les maladies respiratoires : asthme, BPCO, pneumonie, tuberculose",
            "Les maladies infectieuses : bactérioses vs viroses, mode de transmission, prévention",
            "Les vaccins : histoire (Jenner, Pasteur), vaccins obligatoires en France, ARNm",
            "La nutrition : macronutriments (glucides, lipides, protéines), vitamines, minéraux",
            "L'obésité : IMC, causes, conséquences sur la santé, prévention",
            "Le tabagisme : effets du tabac, maladies liées, aide au sevrage",
            "L'alcoolisme : effets sur les organes, dépendance, sevrage",
            "Les drogues illicites : cannabis, cocaïne, héroïne — effets et risques sanitaires",
            "La santé mentale : dépression, anxiété, trouble bipolaire, schizophrénie",
            "Le suicide : prévalence en France, facteurs de risque, prévention",
            "Les premiers secours PSC1 : gestes qui sauvent, PLS, hémorragie, étouffement",
            "La réanimation cardio-pulmonaire (RCP) et l'usage du défibrillateur (DAE)",
            "Le système de santé français : hôpital public, médecin traitant, remboursements SS",
            "La Sécurité Sociale française : financement (cotisations), prestations (maladie, maternité)",
            "Les médicaments : prescription, génériques, automédication, pharmacovigilance",
            "La grossesse : suivi prénatal, accouchement, post-partum, allaitement",
            "Les maladies chroniques : arthrite, sclérose en plaques, maladie de Parkinson, Alzheimer",
            "L'épidémie de COVID-19 : origines, transmission, variants, vaccins, impact",
            "Les grandes épidémies historiques : grippe espagnole (1918), SIDA, Ebola",
            "L'OMS (Organisation Mondiale de la Santé) : rôle, financement, crises",
            "Les troubles du comportement alimentaire (TCA) : anorexie, boulimie",
            "La santé au travail : risques professionnels, TMS, burn-out, maladies professionnelles",
            "La santé environnementale : pollution de l'air, perturbateurs endocriniens, pesticides",
            "La prévention du cancer : dépistages recommandés (mammographie, coloscopie, frottis)",
            "Les soins palliatifs et la fin de vie en France : loi Leonetti-Claeys",
            "La santé des seniors : maladies liées au vieillissement, dépendance, EHPAD",
            "La médecine du sport : blessures courantes, dopage, suivi des athlètes",
        ],
    },
    {
        "category": "Culture générale — Mythologie",
        "module":   "Culture générale",
        "target":   1_000_000,
        "themes": [
            "Mythologie grecque : les 12 dieux olympiens (Zeus, Héra, Athéna, Apollon, Artémis, Hermès, etc.)",
            "Mythologie grecque : les Titans (Cronos, Rhéa, Prométhée, Atlas) et la Titanomachie",
            "Mythologie grecque : Héraclès (Hercule) — les 12 travaux, vie et mort",
            "Mythologie grecque : Achille — talon d'Achille, Iliade, mort devant Troie",
            "Mythologie grecque : Ulysse (Odysseus) — l'Odyssée, Cyclope, Sirènes, Circé",
            "Mythologie grecque : Persée — Méduse, Pégase, Andromède",
            "Mythologie grecque : Thésée — le Minotaure et le Labyrinthe",
            "Mythologie grecque : la Guerre de Troie (Iliade) — Hélène, Paris, Agamemnon",
            "Mythologie grecque : Œdipe — la tragédie, Sophocle, complexe d'Œdipe",
            "Mythologie grecque : Orphée et Eurydice — les Enfers, Hadès et Perséphone",
            "Mythologie grecque : les créatures (Méduse, Minotaure, Sirènes, Sphinx, Cyclopes, Harpies)",
            "Mythologie grecque : Prométhée, Épiméthée, Pandore et la boîte",
            "Mythologie grecque : Jason et les Argonautes, la Toison d'Or",
            "Mythologie romaine : correspondances avec les dieux grecs (Jupiter/Zeus, Mars/Arès, etc.)",
            "Mythologie romaine : Romulus et Rémus, fondation de Rome, la louve",
            "Mythologie romaine : dieux spécifiques (Janus, Vesta, Lares, Pénates)",
            "Mythologie nordique : Odin (le père des dieux), Valhalla, corbeaux Hugin et Munin",
            "Mythologie nordique : Thor (le marteau Mjöllnir), Loki (le dieu rusé), Freya (déesse amour)",
            "Mythologie nordique : le Ragnarök (fin du monde), Yggdrasil (l'arbre-monde)",
            "Mythologie nordique : les Valkyries, les Ases, les Vanes",
            "Mythologie égyptienne : Rê/Rà (dieu soleil), Osiris, Isis, Horus, Seth",
            "Mythologie égyptienne : Anubis (dieu des morts), la momification, le Livre des Morts",
            "Mythologie égyptienne : les pharaons divins, la vie après la mort, jugement d'Osiris",
            "Mythologie mésopotamienne : Gilgamesh (première épopée écrite), Ishtar, Marduk",
            "Mythologie celtique : druides, Dagda, Lug, Morrigan, Brigid",
            "Mythologie celtique : la légende arthurienne (Merlin, Avalon, Excalibur)",
            "Mythologie japonaise : Amaterasu (déesse du Soleil), Susanoo (tempête), Tsukuyomi (Lune)",
            "Mythologie hindoue : Brahma (créateur), Vishnu (protecteur), Shiva (destructeur), Krishna",
            "Mythologie aztèque : Quetzalcoatl (serpent plumé), Huitzilopochtli (guerre), sacrifices humains",
            "Mythologie maya : Kukulkan, Popol Vuh, création du monde, jeu de balle",
            "Mythologie chinoise : le Dragon impérial, Guanyin (déesse de la miséricorde), Jade Empereur",
            "Les animaux mythologiques : dragon, griffon, licorne, phénix, basilic",
            "La mythologie dans les constellations : Orion, Cassiopée, Hercule, les Pléiades",
            "La mythologie et la psychologie : archétypes junguiens, inconscient collectif",
            "Mythes fondateurs de la civilisation : déluge universel (Noé, Gilgamesh, Deucalion)",
        ],
    },
    {
        "category": "Actualité internationale — ONU",
        "module":   "Culture générale",
        "target":   250_000,
        "themes": [
            "L'ONU : création (1945), organes principaux (CS, AG, Secrétariat), membres, siège",
            "Le Conseil de Sécurité de l'ONU : 5 membres permanents, veto, résolutions",
            "Les agences spécialisées ONU : UNESCO, OMS, FAO, PNUD, UNICEF, HCR",
            "La Cour Internationale de Justice (CIJ) : composition, compétence, affaires célèbres",
            "Les opérations de maintien de la paix de l'ONU (Casques bleus)",
            "Les Objectifs de Développement Durable (ODD) de l'ONU à l'horizon 2030",
            "Les Secrétaires généraux de l'ONU depuis 1945",
        ],
    },
    {
        "category": "Actualité internationale — UE",
        "module":   "Culture générale",
        "target":   100_000,
        "themes": [
            "L'actualité récente de l'Union Européenne",
            "Le Brexit : référendum 2016, négociations, accord final, conséquences pour l'UE",
            "Les élections européennes : fonctionnement, résultats, groupes politiques au PE",
        ],
    },
    {
        "category": "Actualité internationale — Conflits",
        "module":   "Culture générale",
        "target":   100_000,
        "themes": [
            "Les conflits géopolitiques contemporains et leurs origines historiques",
            "Les organisations internationales de sécurité collective : OTAN, UA, ASEAN, CEDEAO",
            "La géopolitique des grandes puissances : tensions USA-Chine, Russie-OTAN",
        ],
    },
    {
        "category": "Actualité internationale — Grandes puissances",
        "module":   "Culture générale",
        "target":   100_000,
        "themes": [
            "Les États-Unis : système politique, économie (1ère économie mondiale), société",
            "La Chine : système politique (PC chinois), puissance économique, Belt & Road Initiative",
            "La Russie : régime poutinien, politique étrangère, ressources naturelles",
            "L'Inde : plus grande démocratie, puissance nucléaire, économie en croissance",
            "Les BRICS (Brésil, Russie, Inde, Chine, Afrique du Sud) et le renouveau multipolaire",
        ],
    },
    {
        "category": "Société française — Laïcité",
        "module":   "Culture générale",
        "target":   80_000,
        "themes": [
            "La laïcité française : loi du 9 décembre 1905 (séparation Église-État)",
            "La laïcité à l'école publique et dans la fonction publique",
            "Les débats contemporains sur la laïcité : voile, signes religieux, «islamo-gauchisme»",
        ],
    },
    {
        "category": "Société française — Égalité",
        "module":   "Culture générale",
        "target":   80_000,
        "themes": [
            "L'égalité femmes-hommes en France : lois, inégalités salariales, parité politique",
            "La lutte contre les discriminations raciales et ethniques en droit français",
            "Les droits LGBTQ+ en France : dépénalisation 1981, PACS 1999, mariage pour tous 2013",
        ],
    },
    {
        "category": "Société française — Immigration",
        "module":   "Culture générale",
        "target":   80_000,
        "themes": [
            "L'immigration en France : histoire (1880-2020), nationalités, intégration, chiffres",
            "Le droit d'asile en France et en Europe : conditions, procédure OFPRA, Dublin III",
            "La politique d'immigration française : loi Darmanin 2023, débats politiques",
        ],
    },
    {
        "category": "Société française — Démographie",
        "module":   "Culture générale",
        "target":   80_000,
        "themes": [
            "La démographie française : 68M habitants (2023), structure par âge, baby-boom",
            "La natalité et la politique familiale française (quotient familial, allocations)",
            "L'urbanisation française : métropolisation, désertification rurale, ZRR",
        ],
    },
    {
        "category": "Grands débats contemporains — Écologie",
        "module":   "Culture générale",
        "target":   150_000,
        "themes": [
            "Le changement climatique : GIEC, réchauffement +1,5°C, conséquences, accords de Paris",
            "La biodiversité : 6e extinction de masse, espèces en danger, COP15 Kunming-Montréal",
            "Les COP climatiques : de Kyoto (1997) à Paris (2015) à Glasgow (2021) et Dubaï (2023)",
            "La transition énergétique : mix énergétique, hydrogène vert, stockage d'énergie",
            "Les mouvements écologistes : Fridays for Future, Extinction Rebellion, Greta Thunberg",
        ],
    },
    {
        "category": "Grands débats contemporains — Énergie",
        "module":   "Culture générale",
        "target":   80_000,
        "themes": [
            "L'énergie nucléaire en France : 56 réacteurs, EPR Flamanville, débat sortie du nucléaire",
            "Les énergies renouvelables : éolien, solaire, hydroélectrique — part dans le mix énergétique mondial",
            "La crise énergétique 2021-2022 : flambée des prix du gaz, tension Russie-Europe",
        ],
    },
    {
        "category": "Grands débats contemporains — Intelligence artificielle",
        "module":   "Culture générale",
        "target":   120_000,
        "themes": [
            "L'intelligence artificielle : définition, IA étroite vs IA générale, histoire depuis Turing",
            "Le machine learning et le deep learning : réseaux de neurones, ChatGPT, GPT-4",
            "Les enjeux éthiques de l'IA : biais algorithmiques, emploi, surveillance de masse",
            "Le règlement européen sur l'IA (AI Act 2024) : catégories de risques, interdictions",
            "Les acteurs mondiaux de l'IA : OpenAI, Google DeepMind, Anthropic, Meta AI, Mistral",
        ],
    },
    {
        "category": "Institutions européennes — UE",
        "module":   "Culture générale",
        "target":   400_000,
        "themes": [
            "Le Parlement européen : 720 membres élus au suffrage universel, pouvoirs législatifs",
            "La Commission européenne : 27 commissaires, rôle d'initiative législative, présidente",
            "Le Conseil de l'Union Européenne (Conseil des ministres) : fonctionnement, vote",
            "Le Conseil européen : chefs d'État, décisions stratégiques, président",
            "La Cour de Justice de l'Union Européenne (CJUE) : arrêts fondateurs, rôle",
            "La Banque Centrale Européenne (BCE) : siège à Francfort, taux directeurs, inflation",
            "L'euro : création (1999 scripturalement, 2002 billets), zone euro 20 pays (2023)",
            "L'espace Schengen : 27 pays, libre circulation, contrôles aux frontières extérieures",
            "Les politiques communes de l'UE : PAC, fonds structurels, politique de cohésion",
            "Le budget de l'UE 2021-2027 : 1074 Md€, plan de relance Next Generation EU",
            "La Charte des droits fondamentaux de l'UE (2000, force juridique 2009)",
        ],
    },
    {
        "category": "Institutions européennes — Construction européenne",
        "module":   "Culture générale",
        "target":   300_000,
        "themes": [
            "La CECA (1951) et le traité de Rome (1957) : naissance de la CEE à 6 membres",
            "Les pères fondateurs de l'Europe : Schuman, Monnet, Adenauer, De Gasperi, Spaak",
            "Le traité de Maastricht (1992) : Union Européenne, 3 piliers, monnaie unique",
            "Le traité d'Amsterdam (1997) et de Nice (2001) : élargissement, institutions",
            "Le traité de Lisbonne (2007) : réforme institutionnelle, personnalité juridique UE",
            "Les élargissements successifs de la CEE/UE : de 6 (1957) à 27 (2013) membres",
            "Le Brexit (2016-2020) : référendum, négociations, accord de retrait, trade deal",
        ],
    },
    {
        "category": "Fonction publique — France",
        "module":   "Culture générale",
        "target":   300_000,
        "themes": [
            "La fonction publique française : 3 versants (État, territoriale, hospitalière), 5,7M d'agents",
            "Le statut général des fonctionnaires : loi du 13 juillet 1983, principes fondamentaux",
            "Les droits des fonctionnaires : liberté d'opinion, syndicalisme, droit de grève, formation",
            "Les obligations des fonctionnaires : obéissance hiérarchique, neutralité, discrétion",
            "Les concours de la FP : catégories A (encadrement), B (application), C (exécution)",
            "La rémunération dans la FP : grilles indiciaires, primes, NBI, RIFSEEP",
            "La retraite des fonctionnaires : régime spécial, CNRACL, réforme des retraites 2023",
            "La mobilité et les détachements dans la fonction publique",
        ],
    },
    {
        "category": "Culture générale — Sécurité routière",
        "module":   "Culture générale",
        "target":   500_000,
        "themes": [
            "Les panneaux de signalisation : panneaux de danger (triangulaires), d'interdiction (ronds rouges)",
            "Les panneaux d'obligation, de direction, d'information et de service",
            "Les limitations de vitesse en France : 50 km/h (ville), 80 km/h (route), 130 km/h (autoroute)",
            "L'alcool au volant : taux légaux (0,5 g/L ou 0,2 g/L pour jeunes permis), sanctions pénales",
            "Les stupéfiants au volant : test salivaire, sanctions, retrait de permis",
            "Le permis à points : 12 points (6 en probatoire), infractions entraînant un retrait",
            "Les infractions routières : contraventions (classes 1 à 5), délits, crimes routiers",
            "La priorité à droite : règle, exceptions (routes prioritaires, ronds-points)",
            "Les intersections et les règles de priorité : cédez-le-passage, stop, rond-point",
            "La signalisation lumineuse : feux tricolores, feux clignotants, feux de chantier",
            "Les distances de sécurité : calcul, temps de réaction (1 à 2 secondes), distance d'arrêt",
            "La ceinture de sécurité : obligation (toutes places), exceptions, sanctions",
            "Les équipements obligatoires : gilet fluorescent, triangle, extincteur (poids lourds)",
            "Les véhicules d'urgence : sirène et gyrophare, comportement du conducteur",
            "Les autoroutes : voies, limitations, distances de sécurité, péages, aires",
            "La conduite accompagnée (AAC) : à partir de 15 ans, accompagnateur, km minimum",
            "Le permis probatoire : 6 points, acquisition progressive, délais de reconstitution",
            "Les catégories de permis de conduire : A, A1, A2, B, B1, BE, C, D, etc.",
            "Les deux-roues motorisés : règles spécifiques, équipements obligatoires (casque, gants)",
            "Les cyclistes et les règles du code de la route (piste cyclable, double sens, éclairage)",
            "Les piétons : règles de priorité, passages cloués, feux pour piétons",
            "L'assurance auto : responsabilité civile obligatoire, franchise, garanties optionnelles",
            "Les accidents de la route en France : bilan annuel, causes principales, tendances",
            "La fatigue au volant : signes d'alerte, pause toutes les 2h/200 km recommandée",
            "Le contrôle technique : obligation, fréquence (2 ans), critères de contre-visite",
        ],
    },
]

# ──────────────────────────────────────────────────────────────────────────────
# 5. CHECKPOINT
# ──────────────────────────────────────────────────────────────────────────────
def load_checkpoint() -> dict:
    if CKPT_FILE.exists():
        with open(CKPT_FILE, encoding="utf-8") as f:
            return json.load(f)
    return {}

def save_checkpoint(ckpt: dict):
    with open(CKPT_FILE, "w", encoding="utf-8") as f:
        json.dump(ckpt, f, indent=2, ensure_ascii=False)

# ──────────────────────────────────────────────────────────────────────────────
# 6. COMPTEUR SUPABASE
# ──────────────────────────────────────────────────────────────────────────────
async def get_count(session: aiohttp.ClientSession, category: str) -> int:
    url = f"{SUPABASE_URL}/rest/v1/quiz_questions?select=id&category=eq.{category}"
    headers = {
        "apikey": SUPABASE_KEY,
        "Authorization": f"Bearer {SUPABASE_KEY}",
        "Prefer": "count=exact",
        "Range": "0-0",
    }
    try:
        async with session.get(url, headers=headers) as r:
            cr = r.headers.get("Content-Range", "*/0")
            total = int(cr.split("/")[-1])
            return total
    except Exception:
        return 0

# ──────────────────────────────────────────────────────────────────────────────
# 7. INSERT SUPABASE
# ──────────────────────────────────────────────────────────────────────────────
async def insert_rows(session: aiohttp.ClientSession, rows: list[dict]) -> int:
    if not rows:
        return 0
    url = f"{SUPABASE_URL}/rest/v1/quiz_questions"
    headers = {
        "apikey": SUPABASE_KEY,
        "Authorization": f"Bearer {SUPABASE_KEY}",
        "Content-Type": "application/json",
        "Prefer": "return=minimal",
    }
    for attempt in range(5):
        try:
            async with session.post(url, headers=headers, json=rows) as r:
                if r.status in (200, 201):
                    return len(rows)
                body = await r.text()
                log.warning(f"INSERT status {r.status}: {body[:200]}")
                await asyncio.sleep(2 ** attempt)
        except Exception as e:
            log.warning(f"INSERT error (attempt {attempt+1}): {e}")
            await asyncio.sleep(2 ** attempt)
    return 0

# ──────────────────────────────────────────────────────────────────────────────
# 8. GÉNÉRATION DEEPSEEK
# ──────────────────────────────────────────────────────────────────────────────
OPENAI_API_URL = "https://api.openai.com/v1/chat/completions"

SYSTEM_PROMPT = (
    "Tu es un expert en culture générale française, spécialisé dans la préparation "
    "aux concours de la Police Nationale et aux examens civiques. Tu génères des questions "
    "de QCM rigoureuses, variées, factuellement exactes, avec des explications pédagogiques détaillées."
)

def build_prompt(category: str, theme: str, count: int, call_index: int) -> str:
    return (
        f"Génère exactement {count} questions de culture générale UNIQUES et VARIÉES "
        f"sur le thème : « {theme} ».\n"
        f"Catégorie cible : « {category} ».\n"
        f"Appel numéro {call_index} — génère des questions DIFFÉRENTES des fois précédentes.\n\n"
        f"RÈGLES IMPÉRATIVES :\n"
        f"1. Retourne UNIQUEMENT un tableau JSON valide, sans aucun texte avant ni après.\n"
        f"2. Chaque objet JSON doit avoir EXACTEMENT ces clés : question, options, answer, explanation, difficulty, sub.\n"
        f"3. « options » est un tableau de 4 chaînes distinctes.\n"
        f"4. « answer » est IDENTIQUE à l'un des 4 éléments de « options ».\n"
        f"5. « explanation » : 2 à 4 phrases factuelles, date/source si pertinent.\n"
        f"6. « difficulty » : exactement « Facile », « Moyen » ou « Difficile ».\n"
        f"7. « sub » : sous-thème court (3 à 6 mots).\n"
        f"8. Toutes les réponses doivent être EXACTES et VÉRIFIABLES.\n"
        f"9. Distribution souhaitée : 35% Facile, 40% Moyen, 25% Difficile.\n"
        f"10. Questions VARIÉES dans leur formulation.\n\n"
        f"Format attendu (tableau JSON direct, rien d'autre) :\n"
        f'[{{"question":"...","options":["A","B","C","D"],"answer":"A","explanation":"...","difficulty":"Facile","sub":"..."}},...]'
    )

def parse_questions(raw: str, category: str, module: str) -> list[dict]:
    """Extrait et valide les questions du JSON retourné par l'API."""
    # Extraire le JSON du texte (parfois l'IA ajoute du texte autour)
    match = re.search(r'\[.*\]', raw, re.DOTALL)
    if not match:
        return []
    try:
        items = json.loads(match.group())
    except json.JSONDecodeError:
        # Tentative de nettoyage
        try:
            clean = re.sub(r'[\x00-\x1f\x7f]', ' ', match.group())
            items = json.loads(clean)
        except Exception:
            return []

    valid = []
    for item in items:
        if not isinstance(item, dict):
            continue
        q   = str(item.get("question", "")).strip()
        opt = item.get("options", [])
        ans = str(item.get("answer", "")).strip()
        exp = str(item.get("explanation", "")).strip()
        dif = str(item.get("difficulty", "Moyen")).strip()
        sub = str(item.get("sub", "")).strip()

        if not q or not isinstance(opt, list) or len(opt) != 4:
            continue
        opt = [str(o).strip() for o in opt]
        if ans not in opt:
            # Tenter de trouver par index
            if ans.isdigit() and 0 <= int(ans) - 1 < 4:
                ans = opt[int(ans) - 1]
            else:
                continue
        if dif not in ("Facile", "Moyen", "Difficile"):
            dif = "Moyen"
        if not exp:
            exp = f"La réponse correcte est : {ans}."

        valid.append({
            "module":      module,
            "category":    category,
            "difficulty":  dif,
            "question":    q[:1000],
            "options":     opt,
            "answer":      ans[:500],
            "explanation": exp[:2000],
            "sub":         sub[:100] if sub else None,
        })
    return valid


async def generate_batch(
    session: aiohttp.ClientSession,
    category: str,
    module: str,
    theme: str,
    call_index: int,
) -> list[dict]:
    prompt = build_prompt(category, theme, BATCH_GEN, call_index)
    payload = {
        "model": "gpt-4o-mini",
        "max_tokens": 8000,
        "messages": [
            {"role": "system", "content": SYSTEM_PROMPT},
            {"role": "user",   "content": prompt},
        ],
    }
    headers = {
        "Authorization": f"Bearer {OPENAI_KEY}",
        "Content-Type":  "application/json",
    }
    for attempt in range(5):
        try:
            async with session.post(
                OPENAI_API_URL, headers=headers, json=payload,
                timeout=aiohttp.ClientTimeout(total=120)
            ) as r:
                if r.status == 200:
                    data = await r.json()
                    raw  = data["choices"][0]["message"]["content"]
                    rows = parse_questions(raw, category, module)
                    return rows
                elif r.status == 429:
                    retry_after = int(r.headers.get("retry-after", 30))
                    log.warning(f"Rate limit OpenAI, attente {retry_after}s…")
                    await asyncio.sleep(retry_after)
                else:
                    body = await r.text()
                    log.warning(f"OpenAI {r.status}: {body[:300]}")
                    await asyncio.sleep(5 * (attempt + 1))
        except asyncio.TimeoutError:
            log.warning(f"Timeout OpenAI (attempt {attempt+1})")
            await asyncio.sleep(10)
        except Exception as e:
            log.warning(f"OpenAI error (attempt {attempt+1}): {e}")
            await asyncio.sleep(5)
    return []

# ──────────────────────────────────────────────────────────────────────────────
# 9. WORKER
# ──────────────────────────────────────────────────────────────────────────────
async def worker(
    wid: int,
    queue: asyncio.Queue,
    session: aiohttp.ClientSession,
    counter: dict,
    lock: asyncio.Lock,
):
    while True:
        task = await queue.get()
        if task is None:
            queue.task_done()
            break
        cat_info, theme, call_idx = task
        category = cat_info["category"]
        module   = cat_info["module"]
        target   = cat_info["target"]

        rows = await generate_batch(session, category, module, theme, call_idx)
        if rows:
            inserted = await insert_rows(session, rows)
            async with lock:
                counter[category] = counter.get(category, 0) + inserted
                total_so_far = counter[category]
            if total_so_far % 10_000 < BATCH_GEN:
                log.info(
                    f"[W{wid:02d}] {category[:40]:<40} "
                    f"{total_so_far:>8,} / {target:>8,} "
                    f"({100*total_so_far/target:.1f}%)"
                )
        queue.task_done()

# ──────────────────────────────────────────────────────────────────────────────
# 10. ORCHESTRATEUR PRINCIPAL
# ──────────────────────────────────────────────────────────────────────────────
async def main():
    log.info("=" * 70)
    log.info("  CoPiQ — Génération overnight 9M+ questions  DÉBUT")
    log.info(f"  {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
    log.info("=" * 70)

    ckpt    = load_checkpoint()
    counter = {c["category"]: ckpt.get(c["category"], 0) for c in CATEGORIES}

    conn  = aiohttp.TCPConnector(limit=WORKERS + 10, ssl=False)
    timeout = aiohttp.ClientTimeout(total=120)

    async with aiohttp.ClientSession(connector=conn, timeout=timeout) as session:

        # Vérifier comptes actuels en DB
        log.info("Vérification des comptes actuels en base de données…")
        for cat in CATEGORIES:
            real_count = await get_count(session, cat["category"])
            if real_count > counter[cat["category"]]:
                counter[cat["category"]] = real_count
            log.info(
                f"  {cat['category'][:45]:<45} {counter[cat['category']]:>8,} / {cat['target']:>8,}"
            )

        # Construire la file de tâches
        queue = asyncio.Queue()
        lock  = asyncio.Lock()

        for cat in CATEGORIES:
            category = cat["category"]
            target   = cat["target"]
            themes   = cat["themes"]
            needed   = max(0, target - counter[category])

            if needed <= 0:
                log.info(f"DÉJÀ COMPLET : {category}")
                continue

            calls_needed = (needed // BATCH_GEN) + 1
            log.info(
                f"  Planification {category[:40]:<40} "
                f"→ {calls_needed:,} appels API nécessaires"
            )

            for i in range(calls_needed):
                theme = themes[i % len(themes)]
                await queue.put((cat, theme, i + 1))

        # Sentinel pour arrêter les workers
        for _ in range(WORKERS):
            await queue.put(None)

        # Lancer les workers
        tasks = [
            asyncio.create_task(worker(i, queue, session, counter, lock))
            for i in range(WORKERS)
        ]

        # Checkpoint périodique toutes les 60s
        async def periodic_checkpoint():
            while not all(t.done() for t in tasks):
                await asyncio.sleep(60)
                async with lock:
                    save_checkpoint(counter)
                    total = sum(counter.values())
                    log.info(f"[CKPT] Total inséré : {total:,} questions")

        ckpt_task = asyncio.create_task(periodic_checkpoint())

        await asyncio.gather(*tasks)
        ckpt_task.cancel()
        save_checkpoint(counter)

    # Rapport final
    log.info("=" * 70)
    log.info("  GÉNÉRATION TERMINÉE — RAPPORT FINAL")
    log.info("=" * 70)
    grand_total = 0
    for cat in CATEGORIES:
        c = cat["category"]
        n = counter.get(c, 0)
        t = cat["target"]
        pct = 100 * n / t if t > 0 else 100
        status = "✓" if n >= t else "⚠"
        log.info(f"  {status} {c[:45]:<45} {n:>9,} / {t:>9,}  ({pct:.1f}%)")
        grand_total += n
    log.info(f"\n  TOTAL GÉNÉRAL : {grand_total:,} questions insérées en base")
    log.info(f"  Fin : {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
    log.info("=" * 70)

# ──────────────────────────────────────────────────────────────────────────────
# 11. POINT D'ENTRÉE
# ──────────────────────────────────────────────────────────────────────────────
if __name__ == "__main__":
    asyncio.run(main())
