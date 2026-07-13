#!/usr/bin/env python3
"""
CoPiQ Générateur v5 — 10 000 000 questions uniques
Technique : chaque texte de question embarque les noms des items →
  "Lequel de ces 4 pays se trouve en Europe : Allemagne, Brésil, Chine ou Japon ?"
  → texte unique pour chaque 4-uplet distinct → des millions de textes possibles.

IMPORTANT : options stockées comme liste Python (PAS json.dumps) → JSONB correct.
"""

import asyncio, aiohttp, json, random, hashlib, logging, sys
from datetime import datetime

# ─── CONFIG ──────────────────────────────────────────────────────────────────
SUPABASE_URL = "https://nuoonagnkhbeeymtvrcn.supabase.co"
SUPABASE_KEY = (
    "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9."
    "eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im51b29uYWdua2hiZWV5bXR2cmNuIiwicm9sZSI6"
    "InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc1NjA2MTQ0NSwiZXhwIjoyMDcxNjM3NDQ1fQ."
    "m601M1RYcIwZYGW95jRr1TTawZ3W3W5TZM5GiFI0uh4"
)
BATCH_SIZE    = 100         # petit batch → pas de timeout Supabase
MAX_CONC      = 3           # peu de connexions simultanées
TARGET_TOTAL  = 10_000_000
TARGET_CAT    = 750_000     # objectif par catégorie (14 × 750K ≈ 10.5M)

HEADERS = {
    "apikey":        SUPABASE_KEY,
    "Authorization": f"Bearer {SUPABASE_KEY}",
    "Content-Type":  "application/json",
    "Prefer":        "return=minimal",
}

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s %(levelname)s %(message)s",
    handlers=[
        logging.StreamHandler(sys.stdout),
        logging.FileHandler("gen_v2.log", encoding="utf-8"),
    ],
)
log = logging.getLogger(__name__)

# ─── DÉDUPLICATION GLOBALE ────────────────────────────────────────────────────
_SEEN: set = set()

def _hash(text: str) -> str:
    return hashlib.md5(text.strip().lower().encode()).hexdigest()

def _new(text: str) -> bool:
    h = _hash(text)
    if h in _SEEN:
        return False
    _SEEN.add(h)
    return True

def make_q(module, category, difficulty, question, options, answer, explanation):
    opts = list(options)
    random.shuffle(opts)
    return {
        "module":      module,
        "category":    category,
        "difficulty":  difficulty,
        "question":    question,
        "options":     opts,   # liste Python brute → JSONB array correct
        "answer":      answer,
        "explanation": explanation,
    }

def q(module, category, diff, text, opts, answer, expl):
    if not _new(text):
        return None
    return make_q(module, category, diff, text, opts, answer, expl)

# ─── DONNÉES : 195 PAYS (nom_fr, capitale, continent, area_km2) ───────────────
# continent : Afrique | Amériques | Asie | Europe | Océanie
PAYS = [
    # ── AFRIQUE (54) ──────────────────────────────────────────────────────────
    ("Algérie","Alger","Afrique",2381741),
    ("Angola","Luanda","Afrique",1246700),
    ("Bénin","Porto-Novo","Afrique",112622),
    ("Botswana","Gaborone","Afrique",581730),
    ("Burkina Faso","Ouagadougou","Afrique",274222),
    ("Burundi","Gitega","Afrique",27830),
    ("Cameroun","Yaoundé","Afrique",475442),
    ("Cap-Vert","Praia","Afrique",4033),
    ("Comores","Moroni","Afrique",1861),
    ("Congo","Brazzaville","Afrique",342000),
    ("Côte d'Ivoire","Yamoussoukro","Afrique",322463),
    ("Djibouti","Djibouti","Afrique",23200),
    ("Égypte","Le Caire","Afrique",1001449),
    ("Érythrée","Asmara","Afrique",117600),
    ("Éthiopie","Addis-Abeba","Afrique",1104300),
    ("Gabon","Libreville","Afrique",267668),
    ("Gambie","Banjul","Afrique",11295),
    ("Ghana","Accra","Afrique",238537),
    ("Guinée","Conakry","Afrique",245857),
    ("Guinée-Bissau","Bissau","Afrique",36125),
    ("Guinée équatoriale","Malabo","Afrique",28051),
    ("Kenya","Nairobi","Afrique",580367),
    ("Lesotho","Maseru","Afrique",30355),
    ("Libéria","Monrovia","Afrique",111369),
    ("Libye","Tripoli","Afrique",1759540),
    ("Madagascar","Antananarivo","Afrique",587041),
    ("Malawi","Lilongwe","Afrique",118484),
    ("Mali","Bamako","Afrique",1240192),
    ("Maroc","Rabat","Afrique",446550),
    ("Maurice","Port-Louis","Afrique",2040),
    ("Mauritanie","Nouakchott","Afrique",1030700),
    ("Mozambique","Maputo","Afrique",801590),
    ("Namibie","Windhoek","Afrique",824292),
    ("Niger","Niamey","Afrique",1267000),
    ("Nigéria","Abuja","Afrique",923768),
    ("Ouganda","Kampala","Afrique",241038),
    ("République centrafricaine","Bangui","Afrique",622984),
    ("République démocratique du Congo","Kinshasa","Afrique",2344858),
    ("Rwanda","Kigali","Afrique",26338),
    ("São Tomé-et-Príncipe","São Tomé","Afrique",964),
    ("Sénégal","Dakar","Afrique",196722),
    ("Seychelles","Victoria","Afrique",451),
    ("Sierra Leone","Freetown","Afrique",71740),
    ("Somalie","Mogadiscio","Afrique",637657),
    ("Soudan","Khartoum","Afrique",1861484),
    ("Soudan du Sud","Djouba","Afrique",619745),
    ("Eswatini","Mbabane","Afrique",17364),
    ("Tanzanie","Dodoma","Afrique",945087),
    ("Tchad","N'Djamena","Afrique",1284000),
    ("Togo","Lomé","Afrique",56785),
    ("Tunisie","Tunis","Afrique",163610),
    ("Zambie","Lusaka","Afrique",752618),
    ("Zimbabwe","Harare","Afrique",390757),
    ("Afrique du Sud","Pretoria","Afrique",1219090),
    # ── AMÉRIQUES (35) ────────────────────────────────────────────────────────
    ("Antigua-et-Barbuda","Saint-John's","Amériques",443),
    ("Argentine","Buenos Aires","Amériques",2780400),
    ("Bahamas","Nassau","Amériques",13943),
    ("Barbade","Bridgetown","Amériques",431),
    ("Belize","Belmopan","Amériques",22966),
    ("Bolivie","Sucre","Amériques",1098581),
    ("Brésil","Brasília","Amériques",8515767),
    ("Canada","Ottawa","Amériques",9984670),
    ("Chili","Santiago","Amériques",756102),
    ("Colombie","Bogotá","Amériques",1141748),
    ("Costa Rica","San José","Amériques",51100),
    ("Cuba","La Havane","Amériques",109884),
    ("Dominique","Roseau","Amériques",751),
    ("Équateur","Quito","Amériques",283561),
    ("États-Unis","Washington D.C.","Amériques",9833517),
    ("Grenade","Saint-George's","Amériques",344),
    ("Guatemala","Guatemala City","Amériques",108889),
    ("Guyana","Georgetown","Amériques",214969),
    ("Haïti","Port-au-Prince","Amériques",27750),
    ("Honduras","Tegucigalpa","Amériques",112492),
    ("Jamaïque","Kingston","Amériques",10990),
    ("Mexique","Mexico","Amériques",1964375),
    ("Nicaragua","Managua","Amériques",130373),
    ("Panama","Panama City","Amériques",75417),
    ("Paraguay","Asunción","Amériques",406752),
    ("Pérou","Lima","Amériques",1285216),
    ("République dominicaine","Saint-Domingue","Amériques",48671),
    ("Saint-Kitts-et-Nevis","Basseterre","Amériques",261),
    ("Saint-Vincent-et-les-Grenadines","Kingstown","Amériques",389),
    ("Sainte-Lucie","Castries","Amériques",616),
    ("Salvador","San Salvador","Amériques",21041),
    ("Suriname","Paramaribo","Amériques",163820),
    ("Trinité-et-Tobago","Port-d'Espagne","Amériques",5131),
    ("Uruguay","Montevideo","Amériques",176215),
    ("Venezuela","Caracas","Amériques",916445),
    # ── ASIE (48) ─────────────────────────────────────────────────────────────
    ("Afghanistan","Kaboul","Asie",652230),
    ("Arabie saoudite","Riyad","Asie",2149690),
    ("Arménie","Erevan","Asie",29743),
    ("Azerbaïdjan","Bakou","Asie",86600),
    ("Bahreïn","Manama","Asie",760),
    ("Bangladesh","Dacca","Asie",147570),
    ("Bhoutan","Thimphou","Asie",38394),
    ("Birmanie","Naypyidaw","Asie",676578),
    ("Brunéi","Bandar Seri Begawan","Asie",5765),
    ("Cambodge","Phnom Penh","Asie",181035),
    ("Chine","Pékin","Asie",9596960),
    ("Chypre","Nicosie","Asie",9251),
    ("Corée du Nord","Pyongyang","Asie",120538),
    ("Corée du Sud","Séoul","Asie",100210),
    ("Émirats arabes unis","Abou Dhabi","Asie",83600),
    ("Géorgie","Tbilissi","Asie",69700),
    ("Inde","New Delhi","Asie",3287263),
    ("Indonésie","Jakarta","Asie",1904569),
    ("Irak","Bagdad","Asie",438317),
    ("Iran","Téhéran","Asie",1648195),
    ("Israël","Jérusalem","Asie",20770),
    ("Japon","Tokyo","Asie",377975),
    ("Jordanie","Amman","Asie",89342),
    ("Kazakhstan","Astana","Asie",2724900),
    ("Kirghizistan","Bichkek","Asie",199945),
    ("Koweït","Koweït City","Asie",17818),
    ("Laos","Vientiane","Asie",236800),
    ("Liban","Beyrouth","Asie",10452),
    ("Malaisie","Kuala Lumpur","Asie",329847),
    ("Maldives","Malé","Asie",298),
    ("Mongolie","Oulan-Bator","Asie",1564116),
    ("Népal","Katmandou","Asie",147181),
    ("Oman","Mascate","Asie",309500),
    ("Ouzbékistan","Tachkent","Asie",448978),
    ("Pakistan","Islamabad","Asie",881913),
    ("Palestine","Ramallah","Asie",6220),
    ("Philippines","Manille","Asie",300000),
    ("Qatar","Doha","Asie",11586),
    ("Singapour","Singapour","Asie",719),
    ("Sri Lanka","Sri Jayawardenepura Kotte","Asie",65610),
    ("Syrie","Damas","Asie",185180),
    ("Tadjikistan","Douchanbé","Asie",143100),
    ("Thaïlande","Bangkok","Asie",513120),
    ("Timor oriental","Dili","Asie",14874),
    ("Turkménistan","Achgabat","Asie",488100),
    ("Turquie","Ankara","Asie",783562),
    ("Viêt Nam","Hanoï","Asie",331212),
    ("Yémen","Sanaa","Asie",527968),
    # ── EUROPE (44) ───────────────────────────────────────────────────────────
    ("Albanie","Tirana","Europe",28748),
    ("Allemagne","Berlin","Europe",357114),
    ("Andorre","Andorre-la-Vieille","Europe",468),
    ("Autriche","Vienne","Europe",83871),
    ("Biélorussie","Minsk","Europe",207600),
    ("Belgique","Bruxelles","Europe",30528),
    ("Bosnie-Herzégovine","Sarajevo","Europe",51197),
    ("Bulgarie","Sofia","Europe",110879),
    ("Croatie","Zagreb","Europe",56594),
    ("Danemark","Copenhague","Europe",43094),
    ("Espagne","Madrid","Europe",505990),
    ("Estonie","Tallinn","Europe",45228),
    ("Finlande","Helsinki","Europe",338145),
    ("France","Paris","Europe",551695),
    ("Grèce","Athènes","Europe",131957),
    ("Hongrie","Budapest","Europe",93028),
    ("Irlande","Dublin","Europe",70273),
    ("Islande","Reykjavik","Europe",103000),
    ("Italie","Rome","Europe",301340),
    ("Kosovo","Pristina","Europe",10908),
    ("Lettonie","Riga","Europe",64589),
    ("Liechtenstein","Vaduz","Europe",160),
    ("Lituanie","Vilnius","Europe",65300),
    ("Luxembourg","Luxembourg","Europe",2586),
    ("Macédoine du Nord","Skopje","Europe",25713),
    ("Malte","La Valette","Europe",316),
    ("Moldavie","Chișinău","Europe",33851),
    ("Monaco","Monaco","Europe",2),
    ("Monténégro","Podgorica","Europe",13812),
    ("Norvège","Oslo","Europe",385207),
    ("Pays-Bas","Amsterdam","Europe",41543),
    ("Pologne","Varsovie","Europe",312685),
    ("Portugal","Lisbonne","Europe",92212),
    ("République tchèque","Prague","Europe",78866),
    ("Roumanie","Bucarest","Europe",238397),
    ("Royaume-Uni","Londres","Europe",243610),
    ("Russie","Moscou","Europe",17098242),
    ("Saint-Marin","Saint-Marin","Europe",61),
    ("Serbie","Belgrade","Europe",77474),
    ("Slovaquie","Bratislava","Europe",49035),
    ("Slovénie","Ljubljana","Europe",20273),
    ("Suède","Stockholm","Europe",449964),
    ("Suisse","Berne","Europe",41285),
    ("Ukraine","Kiev","Europe",603628),
    # ── OCÉANIE (14) ──────────────────────────────────────────────────────────
    ("Australie","Canberra","Océanie",7692024),
    ("Fidji","Suva","Océanie",18274),
    ("Kiribati","Tarawa-Sud","Océanie",726),
    ("Îles Marshall","Majuro","Océanie",181),
    ("Micronésie","Palikir","Océanie",702),
    ("Nauru","Yaren","Océanie",21),
    ("Nouvelle-Zélande","Wellington","Océanie",270467),
    ("Palaos","Ngerulmud","Océanie",459),
    ("Papouasie-Nouvelle-Guinée","Port Moresby","Océanie",462840),
    ("Samoa","Apia","Océanie",2842),
    ("Îles Salomon","Honiara","Océanie",28896),
    ("Tonga","Nuku'alofa","Océanie",747),
    ("Tuvalu","Funafuti","Océanie",26),
    ("Vanuatu","Port-Vila","Océanie",12189),
]

# ─── DONNÉES : ÉVÉNEMENTS HISTORIQUES (année, nom_fr, pays, description) ──────
HISTOIRE_EVENTS = [
    (-776,"premiers Jeux olympiques antiques","Grèce","jeux athlétiques à Olympie"),
    (-753,"fondation de Rome","Italie","fondation légendaire par Romulus"),
    (-490,"bataille de Marathon","Grèce","victoire athénienne sur les Perses"),
    (-356,"naissance d'Alexandre le Grand","Macédoine","futur conquérant de l'Asie"),
    (-44,"assassinat de Jules César","Rome","assassinat aux ides de mars"),
    (476,"chute de l'Empire romain d'Occident","Rome","fin de l'Antiquité"),
    (622,"hégire de Mahomet","Arabie","fuite de La Mecque à Médine"),
    (711,"conquête arabe de l'Espagne","Espagne","invasion maure de la péninsule ibérique"),
    (800,"couronnement de Charlemagne","France","sacre à Rome par le pape"),
    (1066,"bataille de Hastings","Angleterre","conquête normande de l'Angleterre"),
    (1095,"première croisade","Europe","appel du pape Urbain II"),
    (1215,"Magna Carta","Angleterre","charte des libertés signée par Jean sans Terre"),
    (1271,"voyage de Marco Polo","Chine","exploration de l'Asie centrale"),
    (1337,"début de la guerre de Cent Ans","France","conflit franco-anglais"),
    (1347,"Grande Peste en Europe","Europe","épidémie de peste noire"),
    (1431,"mort de Jeanne d'Arc","France","brûlée sur le bûcher à Rouen"),
    (1453,"chute de Constantinople","Turquie","fin de l'Empire byzantin"),
    (1492,"découverte des Amériques","Amériques","arrivée de Christophe Colomb"),
    (1498,"Vasco de Gama atteint l'Inde","Inde","route maritime vers l'Inde"),
    (1517,"Réforme protestante","Allemagne","thèses de Martin Luther"),
    (1519,"conquête du Mexique","Mexique","expédition de Hernán Cortés"),
    (1543,"système héliocentrique","Pologne","théorie de Copernic"),
    (1607,"fondation de Jamestown","États-Unis","première colonie anglaise en Amérique"),
    (1618,"guerre de Trente Ans","Europe","conflit religieux en Europe"),
    (1648,"traités de Westphalie","Europe","fin de la guerre de Trente Ans"),
    (1687,"Principia Mathematica de Newton","Angleterre","lois de la gravitation"),
    (1776,"indépendance des États-Unis","États-Unis","déclaration du 4 juillet"),
    (1789,"Révolution française","France","prise de la Bastille"),
    (1793,"exécution de Louis XVI","France","guillotiné place de la Révolution"),
    (1804,"sacre de Napoléon Ier","France","sacre à Notre-Dame de Paris"),
    (1815,"bataille de Waterloo","Belgique","défaite définitive de Napoléon"),
    (1830,"indépendance de la Belgique","Belgique","séparation des Pays-Bas"),
    (1848,"révolutions européennes","Europe","printemps des peuples"),
    (1861,"guerre de Sécession","États-Unis","guerre civile américaine"),
    (1865,"abolition de l'esclavage","États-Unis","13ème amendement"),
    (1869,"ouverture du canal de Suez","Égypte","liaison Méditerranée-mer Rouge"),
    (1871,"unification de l'Allemagne","Allemagne","proclamation à Versailles"),
    (1876,"invention du téléphone","États-Unis","brevet de Graham Bell"),
    (1879,"invention de l'ampoule électrique","États-Unis","Thomas Edison"),
    (1885,"premier vaccin contre la rage","France","Louis Pasteur"),
    (1895,"rayons X découverts","Allemagne","Wilhelm Röntgen"),
    (1895,"cinéma des frères Lumière","France","première projection publique"),
    (1896,"premiers JO modernes","Grèce","Athènes accueille les jeux"),
    (1898,"découverte du radium","France","Marie et Pierre Curie"),
    (1903,"premier vol motorisé","États-Unis","frères Wright à Kitty Hawk"),
    (1905,"théorie de la relativité restreinte","Suisse","Albert Einstein"),
    (1911,"découverte du Machu Picchu","Pérou","Hiram Bingham"),
    (1912,"naufrage du Titanic","Atlantique","iceberg dans l'Atlantique Nord"),
    (1914,"début de la Première Guerre mondiale","Europe","assassinat de François-Ferdinand"),
    (1917,"révolution russe","Russie","renversement du tsar Nicolas II"),
    (1918,"fin de la Première Guerre mondiale","France","armistice du 11 novembre"),
    (1920,"création de la Société des Nations","Suisse","ancêtre de l'ONU"),
    (1928,"découverte de la pénicilline","Royaume-Uni","Alexander Fleming"),
    (1929,"krach boursier de Wall Street","États-Unis","début de la Grande Dépression"),
    (1933,"Hitler chancelier","Allemagne","arrivée des nazis au pouvoir"),
    (1939,"début de la Seconde Guerre mondiale","Pologne","invasion de la Pologne"),
    (1941,"attaque de Pearl Harbor","États-Unis","entrée en guerre des États-Unis"),
    (1944,"débarquement en Normandie","France","opération Overlord"),
    (1945,"capitulation de l'Allemagne","Allemagne","fin de la guerre en Europe"),
    (1945,"bombes atomiques sur le Japon","Japon","Hiroshima et Nagasaki"),
    (1945,"création de l'ONU","États-Unis","organisation internationale fondée"),
    (1947,"indépendance de l'Inde","Inde","partition Inde-Pakistan"),
    (1948,"création d'Israël","Israël","déclaration d'indépendance"),
    (1949,"création de la RPC","Chine","Mao Zedong proclame la Chine populaire"),
    (1950,"guerre de Corée","Corée","conflit entre Nord et Sud"),
    (1953,"découverte de l'ADN","Royaume-Uni","Watson et Crick"),
    (1957,"lancement de Spoutnik","URSS","premier satellite artificiel"),
    (1961,"construction du mur de Berlin","Allemagne","séparation de Berlin"),
    (1961,"premier homme dans l'espace","URSS","Youri Gagarine"),
    (1963,"assassinat de Kennedy","États-Unis","Dallas Texas"),
    (1969,"premier homme sur la Lune","États-Unis","Neil Armstrong"),
    (1972,"scandales du Watergate","États-Unis","démission de Nixon en 1974"),
    (1975,"chute de Saïgon","Viêt Nam","fin de la guerre du Vietnam"),
    (1979,"révolution iranienne","Iran","renversement du Shah"),
    (1986,"catastrophe de Tchernobyl","Ukraine","explosion du réacteur nucléaire"),
    (1989,"chute du mur de Berlin","Allemagne","réunification allemande"),
    (1990,"réunification allemande","Allemagne","fusion RFA et RDA"),
    (1991,"dissolution de l'URSS","Russie","fin de la guerre froide"),
    (1994,"génocide au Rwanda","Rwanda","massacre de 800 000 Tutsis"),
    (1994,"fin de l'apartheid","Afrique du Sud","Mandela élu président"),
    (1997,"rétrocession de Hong Kong","Chine","fin de la souveraineté britannique"),
    (2001,"attentats du 11 septembre","États-Unis","attaques terroristes à New York"),
    (2003,"invasion de l'Irak","Irak","coalition menée par les États-Unis"),
    (2008,"crise financière mondiale","États-Unis","crise des subprimes"),
    (2010,"tremblement de terre en Haïti","Haïti","catastrophe humanitaire"),
    (2011,"printemps arabe","Moyen-Orient","soulèvements populaires"),
    (2011,"mort de Ben Laden","Pakistan","opération militaire américaine"),
    (2015,"accord de Paris sur le climat","France","COP21"),
    (2016,"Brexit","Royaume-Uni","vote pour quitter l'UE"),
    (2020,"pandémie de COVID-19","Monde","coronavirus SARS-CoV-2"),
    (2022,"invasion de l'Ukraine","Ukraine","attaque russe"),
]

# ─── SCIENCES : ÉLÉMENTS CHIMIQUES ────────────────────────────────────────────
# (numéro, symbole, nom_fr, famille, découvreur, année_approx)
ELEMENTS = [
    (1,"H","Hydrogène","non-métal","Henry Cavendish",1766),
    (2,"He","Hélium","gaz noble","Pierre Janssen",1868),
    (3,"Li","Lithium","métal alcalin","Johan Arfwedson",1817),
    (4,"Be","Béryllium","métal alcalino-terreux","Louis-Nicolas Vauquelin",1798),
    (5,"B","Bore","métalloïde","Humphry Davy",1808),
    (6,"C","Carbone","non-métal","préhistoire",0),
    (7,"N","Azote","non-métal","Daniel Rutherford",1772),
    (8,"O","Oxygène","non-métal","Carl Wilhelm Scheele",1772),
    (9,"F","Fluor","halogène","Henri Moissan",1886),
    (10,"Ne","Néon","gaz noble","William Ramsay",1898),
    (11,"Na","Sodium","métal alcalin","Humphry Davy",1807),
    (12,"Mg","Magnésium","métal alcalino-terreux","Joseph Black",1755),
    (13,"Al","Aluminium","métal","Hans Christian Ørsted",1825),
    (14,"Si","Silicium","métalloïde","Jöns Jacob Berzelius",1824),
    (15,"P","Phosphore","non-métal","Hennig Brand",1669),
    (16,"S","Soufre","non-métal","préhistoire",0),
    (17,"Cl","Chlore","halogène","Carl Wilhelm Scheele",1774),
    (18,"Ar","Argon","gaz noble","Lord Rayleigh",1894),
    (19,"K","Potassium","métal alcalin","Humphry Davy",1807),
    (20,"Ca","Calcium","métal alcalino-terreux","Humphry Davy",1808),
    (26,"Fe","Fer","métal de transition","préhistoire",0),
    (29,"Cu","Cuivre","métal de transition","préhistoire",0),
    (47,"Ag","Argent","métal de transition","préhistoire",0),
    (50,"Sn","Étain","métal","préhistoire",0),
    (78,"Pt","Platine","métal de transition","Antonio de Ulloa",1748),
    (79,"Au","Or","métal de transition","préhistoire",0),
    (80,"Hg","Mercure","métal de transition","préhistoire",0),
    (82,"Pb","Plomb","métal","préhistoire",0),
    (88,"Ra","Radium","métal alcalino-terreux","Marie Curie",1898),
    (92,"U","Uranium","actinide","Martin Heinrich Klaproth",1789),
]

# ─── INVENTIONS (nom, inventeur, année, pays) ─────────────────────────────────
INVENTIONS = [
    ("l'imprimerie à caractères mobiles","Johannes Gutenberg",1440,"Allemagne"),
    ("le télescope","Hans Lippershey",1608,"Pays-Bas"),
    ("la machine à vapeur","James Watt",1769,"Écosse"),
    ("la montgolfière","frères Montgolfier",1783,"France"),
    ("le vaccin","Edward Jenner",1796,"Angleterre"),
    ("la locomotive à vapeur","George Stephenson",1814,"Angleterre"),
    ("la photographie","Louis Daguerre",1839,"France"),
    ("le téléphone","Alexander Graham Bell",1876,"États-Unis"),
    ("l'ampoule électrique","Thomas Edison",1879,"États-Unis"),
    ("l'automobile","Karl Benz",1885,"Allemagne"),
    ("le cinéma","frères Lumière",1895,"France"),
    ("la radio","Guglielmo Marconi",1895,"Italie"),
    ("l'avion","frères Wright",1903,"États-Unis"),
    ("la pénicilline","Alexander Fleming",1928,"Écosse"),
    ("le nylon","Wallace Carothers",1935,"États-Unis"),
    ("le transistor","Shockley, Bardeen, Brattain",1947,"États-Unis"),
    ("la structure de l'ADN","Watson et Crick",1953,"Royaume-Uni"),
    ("le laser","Theodore Maiman",1960,"États-Unis"),
    ("Internet (ARPANET)","DARPA",1969,"États-Unis"),
    ("le scanner médical (IRM)","Peter Mansfield",1977,"Royaume-Uni"),
    ("l'ordinateur personnel","IBM",1981,"États-Unis"),
    ("le World Wide Web","Tim Berners-Lee",1989,"Suisse"),
    ("le téléphone portable GSM","Motorola",1983,"États-Unis"),
    ("le GPS","US Department of Defense",1973,"États-Unis"),
    ("la machine à laver électrique","Alva Fisher",1908,"États-Unis"),
    ("le réfrigérateur électrique","Carl von Linde",1876,"Allemagne"),
    ("l'aspirateur","Hubert Cecil Booth",1901,"Angleterre"),
    ("le four à micro-ondes","Percy Spencer",1945,"États-Unis"),
    ("le velcro","George de Mestral",1948,"Suisse"),
    ("la carte de crédit","Frank McNamara",1950,"États-Unis"),
    ("le code-barres","Norman Woodland",1952,"États-Unis"),
    ("la pile électrique","Alessandro Volta",1800,"Italie"),
    ("la dynamo","Michael Faraday",1831,"Angleterre"),
    ("le moteur électrique","Michael Faraday",1821,"Angleterre"),
    ("le parachute","André-Jacques Garnerin",1797,"France"),
    ("la machine à écrire","Christopher Sholes",1867,"États-Unis"),
    ("le stéthoscope","René Laennec",1816,"France"),
    ("la seringue hypodermique","Alexander Wood",1853,"Écosse"),
    ("l'asphalte","John McAdam",1820,"Écosse"),
    ("le béton armé","Joseph Monier",1867,"France"),
]

# ─── PERSONNAGES HISTORIQUES ───────────────────────────────────────────────────
# (nom, période_ou_années, nationalité, domaine)
PERSONNAGES = [
    ("Cléopâtre","69-30 av. J.-C.","Égypte","reine d'Égypte"),
    ("Jules César","100-44 av. J.-C.","Rome","général et homme d'État"),
    ("Alexandre le Grand","356-323 av. J.-C.","Macédoine","conquérant"),
    ("Socrate","470-399 av. J.-C.","Grèce","philosophe"),
    ("Aristote","384-322 av. J.-C.","Grèce","philosophe et savant"),
    ("Archimède","287-212 av. J.-C.","Grèce","mathématicien"),
    ("Vercingétorix","72-46 av. J.-C.","Gaule","chef gaulois"),
    ("Charlemagne","742-814","France","roi des Francs et empereur"),
    ("Gengis Khan","1162-1227","Mongolie","conquérant"),
    ("Marco Polo","1254-1324","Italie","explorateur"),
    ("Jeanne d'Arc","1412-1431","France","héroïne nationale"),
    ("Léonard de Vinci","1452-1519","Italie","artiste et savant"),
    ("Christophe Colomb","1451-1506","Gênes","navigateur"),
    ("Nicolas Copernic","1473-1543","Pologne","astronome"),
    ("Michel-Ange","1475-1564","Italie","artiste"),
    ("Magellan","1480-1521","Portugal","navigateur"),
    ("Martin Luther","1483-1546","Allemagne","réformateur religieux"),
    ("Nicolas Machiavel","1469-1527","Italie","philosophe politique"),
    ("Galilée","1564-1642","Italie","astronome et physicien"),
    ("René Descartes","1596-1650","France","philosophe et mathématicien"),
    ("Isaac Newton","1643-1727","Angleterre","physicien et mathématicien"),
    ("Voltaire","1694-1778","France","écrivain et philosophe"),
    ("Jean-Jacques Rousseau","1712-1778","Suisse","philosophe"),
    ("Mozart","1756-1791","Autriche","compositeur"),
    ("Napoléon Bonaparte","1769-1821","France","général et empereurqui"),
    ("Ludwig van Beethoven","1770-1827","Allemagne","compositeur"),
    ("Simon Bolivar","1783-1830","Venezuela","libérateur d'Amérique du Sud"),
    ("Abraham Lincoln","1809-1865","États-Unis","président"),
    ("Charles Darwin","1809-1882","Angleterre","naturaliste"),
    ("Karl Marx","1818-1883","Allemagne","philosophe et économiste"),
    ("Louis Pasteur","1822-1895","France","biologiste"),
    ("Florence Nightingale","1820-1910","Angleterre","infirmière"),
    ("Jules Verne","1828-1905","France","écrivain"),
    ("Thomas Edison","1847-1931","États-Unis","inventeur"),
    ("Nikola Tesla","1856-1943","Serbie","inventeur"),
    ("Sigmund Freud","1856-1939","Autriche","médecin"),
    ("Marie Curie","1867-1934","Pologne","physicienne et chimiste"),
    ("Mahatma Gandhi","1869-1948","Inde","leader politique"),
    ("Albert Einstein","1879-1955","Allemagne","physicien"),
    ("Pablo Picasso","1881-1973","Espagne","peintre"),
    ("Mao Zedong","1893-1976","Chine","homme d'État"),
    ("Nelson Mandela","1918-2013","Afrique du Sud","leader politique"),
    ("Martin Luther King","1929-1968","États-Unis","leader des droits civiques"),
    ("Che Guevara","1928-1967","Argentine","révolutionnaire"),
    ("Youri Gagarine","1934-1968","URSS","cosmonaute"),
    ("Neil Armstrong","1930-2012","États-Unis","astronaute"),
    ("Stephen Hawking","1942-2018","Angleterre","physicien"),
    ("Alan Turing","1912-1954","Angleterre","mathématicien et informaticien"),
    ("Ada Lovelace","1815-1852","Angleterre","première programmeuse"),
    ("Nikola Tesla","1856-1943","Serbie","inventeur et ingénieur"),
]

# ─── FILMS (titre, réalisateur, année, pays) ──────────────────────────────────
FILMS = [
    ("Metropolis","Fritz Lang",1927,"Allemagne"),
    ("Citizen Kane","Orson Welles",1941,"États-Unis"),
    ("Casablanca","Michael Curtiz",1942,"États-Unis"),
    ("Rome ville ouverte","Roberto Rossellini",1945,"Italie"),
    ("Rashōmon","Akira Kurosawa",1950,"Japon"),
    ("Limelight","Charlie Chaplin",1952,"États-Unis"),
    ("La Strada","Federico Fellini",1954,"Italie"),
    ("Vertigo","Alfred Hitchcock",1958,"États-Unis"),
    ("Les 400 Coups","François Truffaut",1959,"France"),
    ("À bout de souffle","Jean-Luc Godard",1960,"France"),
    ("La Dolce Vita","Federico Fellini",1960,"Italie"),
    ("Lawrence d'Arabie","David Lean",1962,"Royaume-Uni"),
    ("Le Guépard","Luchino Visconti",1963,"Italie"),
    ("Le Bon la Brute et le Truand","Sergio Leone",1966,"Italie"),
    ("2001 l'odyssée de l'espace","Stanley Kubrick",1968,"États-Unis"),
    ("Le Parrain","Francis Ford Coppola",1972,"États-Unis"),
    ("Amarcord","Federico Fellini",1973,"Italie"),
    ("Chinatown","Roman Polanski",1974,"États-Unis"),
    ("Taxi Driver","Martin Scorsese",1976,"États-Unis"),
    ("Annie Hall","Woody Allen",1977,"États-Unis"),
    ("Apocalypse Now","Francis Ford Coppola",1979,"États-Unis"),
    ("E.T. l'extra-terrestre","Steven Spielberg",1982,"États-Unis"),
    ("Shoah","Claude Lanzmann",1985,"France"),
    ("Le Sacrifice","Andreï Tarkovski",1986,"Suède"),
    ("Rain Man","Barry Levinson",1988,"États-Unis"),
    ("Goodfellas","Martin Scorsese",1990,"États-Unis"),
    ("Le Silence des agneaux","Jonathan Demme",1991,"États-Unis"),
    ("Schindler's List","Steven Spielberg",1993,"États-Unis"),
    ("Pulp Fiction","Quentin Tarantino",1994,"États-Unis"),
    ("Forrest Gump","Robert Zemeckis",1994,"États-Unis"),
    ("La Haine","Mathieu Kassovitz",1995,"France"),
    ("Titanic","James Cameron",1997,"États-Unis"),
    ("American Beauty","Sam Mendes",1999,"États-Unis"),
    ("Fight Club","David Fincher",1999,"États-Unis"),
    ("Gladiator","Ridley Scott",2000,"États-Unis"),
    ("Amélie Poulain","Jean-Pierre Jeunet",2001,"France"),
    ("Le Seigneur des Anneaux","Peter Jackson",2001,"Nouvelle-Zélande"),
    ("Gangs of New York","Martin Scorsese",2002,"États-Unis"),
    ("Mystic River","Clint Eastwood",2003,"États-Unis"),
    ("Million Dollar Baby","Clint Eastwood",2004,"États-Unis"),
    ("Brokeback Mountain","Ang Lee",2005,"États-Unis"),
    ("Babel","Alejandro González Iñárritu",2006,"Mexique"),
    ("No Country for Old Men","Coen Brothers",2007,"États-Unis"),
    ("The Dark Knight","Christopher Nolan",2008,"États-Unis"),
    ("Avatar","James Cameron",2009,"États-Unis"),
    ("Incendies","Denis Villeneuve",2010,"Canada"),
    ("The Artist","Michel Hazanavicius",2011,"France"),
    ("Amour","Michael Haneke",2012,"Autriche"),
    ("Gravity","Alfonso Cuarón",2013,"États-Unis"),
    ("Boyhood","Richard Linklater",2014,"États-Unis"),
    ("Mad Max Fury Road","George Miller",2015,"Australie"),
    ("La La Land","Damien Chazelle",2016,"États-Unis"),
    ("Get Out","Jordan Peele",2017,"États-Unis"),
    ("Roma","Alfonso Cuarón",2018,"Mexique"),
    ("Parasite","Bong Joon-ho",2019,"Corée du Sud"),
    ("Nomadland","Chloé Zhao",2020,"États-Unis"),
    ("Drive My Car","Ryûsuke Hamaguchi",2021,"Japon"),
    ("CODA","Sian Heder",2021,"États-Unis"),
    ("La Leçon de piano","Jane Campion",1993,"Nouvelle-Zélande"),
    ("Yi Yi","Edward Yang",2000,"Taïwan"),
    ("Mulholland Drive","David Lynch",2001,"États-Unis"),
    ("Spring Summer Fall Winter and Spring","Kim Ki-duk",2003,"Corée du Sud"),
    ("The Tree of Life","Terrence Malick",2011,"États-Unis"),
    ("Intouchables","Olivier Nakache",2011,"France"),
    ("Dunkirk","Christopher Nolan",2017,"Royaume-Uni"),
    ("Joker","Todd Phillips",2019,"États-Unis"),
    ("Dune","Denis Villeneuve",2021,"États-Unis"),
]

# ─── COMPOSITEURS CLASSIQUES ───────────────────────────────────────────────────
# (nom, période, nationalité, œuvre_célèbre)
COMPOSITEURS = [
    ("Johann Sebastian Bach","baroque","Allemagne","les Variations Goldberg"),
    ("Georg Friedrich Haendel","baroque","Allemagne","Le Messie"),
    ("Antonio Vivaldi","baroque","Italie","Les Quatre Saisons"),
    ("Wolfgang Amadeus Mozart","classicisme","Autriche","la Symphonie n°40"),
    ("Ludwig van Beethoven","classicisme-romantisme","Allemagne","la 9e Symphonie"),
    ("Franz Schubert","romantisme","Autriche","La Truite"),
    ("Frédéric Chopin","romantisme","Pologne","les Nocturnes"),
    ("Robert Schumann","romantisme","Allemagne","le Carnaval"),
    ("Franz Liszt","romantisme","Hongrie","la Rhapsodie hongroise"),
    ("Richard Wagner","romantisme","Allemagne","La Chevauchée des Walkyries"),
    ("Johannes Brahms","romantisme","Allemagne","la Symphonie n°1"),
    ("Piotr Tchaïkovski","romantisme","Russie","le Lac des Cygnes"),
    ("Camille Saint-Saëns","romantisme","France","Le Carnaval des animaux"),
    ("Giuseppe Verdi","romantisme","Italie","Aida"),
    ("Giacomo Puccini","romantisme tardif","Italie","La Bohème"),
    ("Claude Debussy","impressionnisme","France","Clair de Lune"),
    ("Maurice Ravel","impressionnisme","France","le Boléro"),
    ("Igor Stravinski","modernisme","Russie","Le Sacre du printemps"),
    ("Sergueï Rachmaninov","romantisme tardif","Russie","le Concerto pour piano n°2"),
    ("Dmitri Chostakovitch","modernisme","URSS","la Symphonie n°7"),
    ("Aaron Copland","modernisme","États-Unis","Appalachian Spring"),
    ("George Gershwin","jazz-classique","États-Unis","Rhapsody in Blue"),
    ("Béla Bartók","modernisme","Hongrie","le Concerto pour orchestre"),
    ("Olivier Messiaen","modernisme","France","le Quatuor pour la fin du temps"),
    ("Astor Piazzolla","tango nuevo","Argentine","Libertango"),
    ("Ennio Morricone","contemporain","Italie","La musique du Bon la Brute et le Truand"),
    ("Philip Glass","minimalisme","États-Unis","Einstein on the Beach"),
    ("John Williams","contemporain","États-Unis","la musique de Star Wars"),
    ("Hans Zimmer","contemporain","Allemagne","la musique de Inception"),
    ("Antonio Salieri","classicisme","Italie","Les Danaïdes"),
]

# ─── MYTHOLOGIE (nom, culture, domaine, attribut_célèbre) ─────────────────────
MYTHES = [
    ("Zeus","grecque","dieu du ciel et des dieux","la foudre"),
    ("Héra","grecque","déesse du mariage","le paon"),
    ("Poséidon","grecque","dieu de la mer","le trident"),
    ("Déméter","grecque","déesse des moissons","les épis de blé"),
    ("Athéna","grecque","déesse de la sagesse","la chouette"),
    ("Apollon","grecque","dieu du soleil et des arts","la lyre"),
    ("Artémis","grecque","déesse de la chasse","l'arc et les flèches"),
    ("Arès","grecque","dieu de la guerre","le casque et la lance"),
    ("Aphrodite","grecque","déesse de l'amour","la ceinture magique"),
    ("Héphaïstos","grecque","dieu du feu et forge","l'enclume"),
    ("Hermès","grecque","messager des dieux","le caducée"),
    ("Dionysos","grecque","dieu du vin","la vigne"),
    ("Hades","grecque","dieu des enfers","le casque d'invisibilité"),
    ("Perséphone","grecque","reine des enfers","la grenade"),
    ("Héraclès","grecque","héros divin","la massue"),
    ("Achille","grecque","héros de la guerre de Troie","son talon vulnérable"),
    ("Ulysse","grecque","héros de l'Odyssée","l'arc"),
    ("Prométhée","grecque","titan donneur de feu","les chaînes"),
    ("Méduse","grecque","Gorgone","les serpents à la place des cheveux"),
    ("Minotaure","grecque","monstre du labyrinthe","la tête de taureau"),
    ("Jupiter","romaine","dieu suprême","la foudre"),
    ("Mars","romaine","dieu de la guerre","les armes"),
    ("Vénus","romaine","déesse de l'amour","la ceinture"),
    ("Mercure","romaine","messager des dieux","le caducée ailé"),
    ("Neptune","romaine","dieu de la mer","le trident"),
    ("Minerve","romaine","déesse de la sagesse","le hibou"),
    ("Janus","romaine","dieu des portes","les deux visages"),
    ("Saturne","romaine","dieu du temps","la faux"),
    ("Odin","nordique","dieu de la sagesse","les corbeaux Hugin et Munin"),
    ("Thor","nordique","dieu du tonnerre","le marteau Mjolnir"),
    ("Loki","nordique","dieu de la ruse","les métamorphoses"),
    ("Freya","nordique","déesse de l'amour","le collier Brisinga"),
    ("Ra","égyptienne","dieu du soleil","le disque solaire"),
    ("Osiris","égyptienne","dieu des morts","le sceptre et le flail"),
    ("Isis","égyptienne","déesse de la magie","les ailes"),
    ("Anubis","égyptienne","dieu des embaumeurs","la tête de chacal"),
    ("Horus","égyptienne","dieu du ciel","l'œil d'Horus"),
    ("Seth","égyptienne","dieu du chaos","la tête de l'animal de Seth"),
    ("Vishnou","hindoue","dieu conservateur","la conque"),
    ("Shiva","hindoue","dieu destructeur","le trident"),
]

# ─── SPORTS (nom_sport, catégorie, nb_joueurs_ou_spec, JO) ────────────────────
SPORTS_DATA = [
    ("football","sport collectif",11,"Oui"),
    ("basketball","sport collectif",5,"Oui"),
    ("rugby à XV","sport collectif",15,"Non"),
    ("volleyball","sport collectif",6,"Oui"),
    ("handball","sport collectif",7,"Oui"),
    ("baseball","sport collectif",9,"Non"),
    ("cricket","sport collectif",11,"Non"),
    ("hockey sur glace","sport collectif",6,"Oui"),
    ("water-polo","sport collectif",7,"Oui"),
    ("rugby à 7","sport collectif",7,"Oui"),
    ("tennis","sport individuel",1,"Non"),
    ("natation","sport individuel",1,"Oui"),
    ("athlétisme","sport individuel",1,"Oui"),
    ("gymnastique","sport individuel",1,"Oui"),
    ("cyclisme","sport individuel",1,"Oui"),
    ("boxe","sport de combat",1,"Oui"),
    ("judo","sport de combat",1,"Oui"),
    ("karaté","sport de combat",1,"Oui"),
    ("lutte","sport de combat",1,"Oui"),
    ("taekwondo","sport de combat",1,"Oui"),
    ("escrime","sport de combat",1,"Oui"),
    ("ski alpin","sport d'hiver",1,"Oui"),
    ("patinage artistique","sport d'hiver",1,"Oui"),
    ("biathlon","sport d'hiver",1,"Oui"),
    ("bobsleigh","sport d'hiver",2,"Oui"),
    ("golf","sport individuel",1,"Oui"),
    ("tennis de table","sport individuel",1,"Oui"),
    ("badminton","sport individuel",1,"Oui"),
    ("tir à l'arc","sport individuel",1,"Oui"),
    ("haltérophilie","sport individuel",1,"Oui"),
    ("aviron","sport individuel",1,"Oui"),
    ("canoë-kayak","sport individuel",1,"Oui"),
    ("équitation","sport individuel",1,"Oui"),
    ("pentathlon moderne","sport individuel",1,"Oui"),
    ("triathlon","sport individuel",1,"Oui"),
    ("surf","sport individuel",1,"Oui"),
    ("skateboard","sport individuel",1,"Oui"),
    ("escalade sportive","sport individuel",1,"Oui"),
    ("breaking (breakdance)","sport individuel",1,"Oui"),
    ("rugby à 7","sport collectif",7,"Oui"),
]

ATHLETES = [
    ("Usain Bolt","Jamaïque","sprint","record 100m en 9.58 secondes"),
    ("Michael Phelps","États-Unis","natation","23 médailles d'or olympiques"),
    ("Serena Williams","États-Unis","tennis","23 titres du Grand Chelem"),
    ("Roger Federer","Suisse","tennis","20 titres du Grand Chelem"),
    ("Rafael Nadal","Espagne","tennis","22 titres du Grand Chelem"),
    ("Novak Djokovic","Serbie","tennis","24 titres du Grand Chelem"),
    ("Lionel Messi","Argentine","football","Ballon d'Or 8 fois"),
    ("Cristiano Ronaldo","Portugal","football","Ballon d'Or 5 fois"),
    ("Michael Jordan","États-Unis","basketball","6 titres NBA"),
    ("Muhammad Ali","États-Unis","boxe","champion du monde des lourds"),
    ("Pelé","Brésil","football","3 Coupes du monde"),
    ("Zinedine Zidane","France","football","champion du monde 1998"),
    ("Tiger Woods","États-Unis","golf","15 tournois du Grand Chelem"),
    ("Simone Biles","États-Unis","gymnastique","19 médailles mondiales"),
    ("Carl Lewis","États-Unis","athlétisme","9 médailles d'or olympiques"),
    ("Lance Armstrong","États-Unis","cyclisme","7 Tours de France"),
    ("Nadia Comaneci","Roumanie","gymnastique","note parfaite 10 aux JO 1976"),
    ("Mark Spitz","États-Unis","natation","7 médailles d'or aux JO 1972"),
    ("Jesse Owens","États-Unis","athlétisme","4 médailles d'or Berlin 1936"),
    ("Florence Griffith-Joyner","États-Unis","sprint","record 100m féminin"),
    ("Valentina Tereshkova","URSS","sport/espace","première femme dans l'espace"),
    ("Björn Borg","Suède","tennis","5 Wimbledon consécutifs"),
    ("Steffi Graf","Allemagne","tennis","22 titres du Grand Chelem"),
    ("Magic Johnson","États-Unis","basketball","5 titres NBA"),
    ("Wayne Gretzky","Canada","hockey sur glace","The Great One"),
    ("Ayrton Senna","Brésil","Formule 1","3 championnats du monde F1"),
    ("Michael Schumacher","Allemagne","Formule 1","7 championnats du monde F1"),
    ("Lewis Hamilton","Royaume-Uni","Formule 1","7 championnats du monde F1"),
    ("Ronaldinho","Brésil","football","Ballon d'Or 2005"),
    ("Thierry Henry","France","football","record de buts en Équipe de France"),
]

# ─── SANTÉ (maladie/condition, cause, symptôme_principal, traitement) ─────────
MALADIES = [
    ("diabète de type 1","carence en insuline","hyperglycémie","insulinothérapie"),
    ("diabète de type 2","résistance à l'insuline","fatigue et soif excessive","régime et metformine"),
    ("hypertension artérielle","multifactorielle","maux de tête","antihypertenseurs"),
    ("infarctus du myocarde","obstruction coronaire","douleur thoracique","thrombolyse/angioplastie"),
    ("AVC ischémique","obstruction cérébrale","paralysie soudaine","thrombolyse"),
    ("pneumonie","infection pulmonaire","fièvre et toux","antibiotiques"),
    ("asthme","inflammation des bronches","sifflement respiratoire","bronchodilatateurs"),
    ("tuberculose","Mycobacterium tuberculosis","toux chronique","antibiotiques"),
    ("VIH/SIDA","virus VIH","immunodépression","antirétroviraux"),
    ("cancer du poumon","tabagisme principalement","toux sanguinolente","chirurgie/chimio/radio"),
    ("cancer du sein","multifactorielle","masse mammaire","chirurgie/chimiothérapie"),
    ("leucémie","dérèglement des cellules sanguines","fatigue et hémorragies","chimiothérapie"),
    ("dépression","déséquilibre neurochimique","tristesse persistante","antidépresseurs/psychothérapie"),
    ("schizophrénie","multifactorielle","hallucinations","antipsychotiques"),
    ("maladie d'Alzheimer","dégénérescence cérébrale","perte de mémoire","soins palliatifs"),
    ("maladie de Parkinson","dégénérescence dopaminergique","tremblements","lévodopa"),
    ("épilepsie","hyperactivité neuronale","convulsions","antiépileptiques"),
    ("sclérose en plaques","maladie auto-immune","fatigue et troubles moteurs","immunomodulateurs"),
    ("arthrite rhumatoïde","maladie auto-immune","douleurs articulaires","anti-inflammatoires"),
    ("ostéoporose","déminéralisation osseuse","fractures fréquentes","calcium et vitamine D"),
    ("grippe","virus influenza","fièvre et courbatures","repos et antiviraux"),
    ("COVID-19","coronavirus SARS-CoV-2","fièvre et toux sèche","vaccin et antiviraux"),
    ("hépatite C","virus VHC","fatigue et ictère","antiviraux directs"),
    ("hépatite B","virus VHB","nausées et ictère","antiviraux/vaccin"),
    ("cholera","Vibrio cholerae","diarrhée aqueuse","réhydratation orale"),
    ("paludisme","parasite Plasmodium","fièvre cyclique","antipaludiques"),
    ("dengue","arbovirus transmis par moustiques","fièvre et douleurs osseuses","soins symptomatiques"),
    ("typhus","Rickettsia","fièvre et éruption","antibiotiques"),
    ("obésité","déséquilibre énergétique","IMC supérieur à 30","régime et activité physique"),
    ("anorexie mentale","trouble du comportement alimentaire","amaigrissement extrême","psychothérapie"),
    ("cataracte","opacification du cristallin","vision trouble","chirurgie"),
    ("glaucome","hypertension oculaire","perte de vision périphérique","gouttes/chirurgie"),
    ("insuffisance rénale chronique","destruction progressive du rein","oedèmes","dialyse/transplantation"),
    ("cirrhose","destruction hépatique","ictère et ascite","soins et transplantation"),
    ("appendicite","inflammation de l'appendice","douleur fosse iliaque droite","appendicectomie"),
]

# ─── INSTITUTIONS MONDIALES ────────────────────────────────────────────────────
# (sigle, nom_complet, siège, rôle)
INSTITUTIONS_MONDE = [
    ("ONU","Organisation des Nations Unies","New York","paix et sécurité internationales"),
    ("OTAN","Organisation du traité de l'Atlantique Nord","Bruxelles","défense collective occidentale"),
    ("UE","Union européenne","Bruxelles","intégration économique et politique européenne"),
    ("FMI","Fonds monétaire international","Washington","stabilité financière mondiale"),
    ("BM","Banque mondiale","Washington","financement du développement"),
    ("OMC","Organisation mondiale du commerce","Genève","régulation du commerce international"),
    ("OMS","Organisation mondiale de la santé","Genève","santé publique mondiale"),
    ("UNESCO","Organisation des Nations Unies pour l'éducation la science et la culture","Paris","éducation et culture"),
    ("UNICEF","Fonds des Nations Unies pour l'enfance","New York","protection de l'enfance"),
    ("AIEA","Agence internationale de l'énergie atomique","Vienne","contrôle nucléaire"),
    ("CIJ","Cour internationale de justice","La Haye","arbitrage judiciaire international"),
    ("CPI","Cour pénale internationale","La Haye","crimes contre l'humanité"),
    ("INTERPOL","Organisation internationale de police criminelle","Lyon","coopération policière"),
    ("Europol","Office européen de police","La Haye","coopération policière européenne"),
    ("OCDE","Organisation de coopération et de développement économiques","Paris","développement économique"),
    ("G7","Groupe des 7 grandes puissances","rotatif","coordination économique mondiale"),
    ("G20","Groupe des 20 économies","rotatif","gouvernance économique mondiale"),
    ("BRICS","Brésil Russie Inde Chine Afrique du Sud","rotatif","pays émergents"),
    ("ASEAN","Association des nations de l'Asie du Sud-Est","Jakarta","intégration asiatique"),
    ("UA","Union africaine","Addis-Abeba","intégration africaine"),
    ("OEA","Organisation des États américains","Washington","coopération américaine"),
    ("OPEP","Organisation des pays exportateurs de pétrole","Vienne","régulation du pétrole"),
    ("CROIX-ROUGE","Comité international de la Croix-Rouge","Genève","aide humanitaire"),
    ("HCR","Haut-Commissariat des Nations Unies pour les réfugiés","Genève","protection des réfugiés"),
    ("PAM","Programme alimentaire mondial","Rome","lutte contre la faim"),
    ("FAO","Organisation des Nations Unies pour l'alimentation","Rome","alimentation mondiale"),
    ("BCE","Banque centrale européenne","Francfort","politique monétaire zone euro"),
    ("OSCE","Organisation pour la sécurité et la coopération en Europe","Vienne","sécurité européenne"),
    ("COI","Comité olympique international","Lausanne","organisation des Jeux olympiques"),
    ("FIFA","Fédération internationale de football association","Zurich","football mondial"),
]

# ─── DROIT ET POLICE ───────────────────────────────────────────────────────────
INFRACTIONS_PENALES = [
    ("vol simple","soustraction frauduleuse du bien d'autrui","délit","3 ans emprisonnement"),
    ("vol aggravé","vol avec circonstances aggravantes","délit/crime","7 à 15 ans"),
    ("escroquerie","tromperie pour obtenir un bien","délit","5 ans emprisonnement"),
    ("abus de confiance","détournement d'un bien confié","délit","3 ans emprisonnement"),
    ("recel","dissimulation de bien issu d'une infraction","délit","5 ans emprisonnement"),
    ("extorsion","contrainte pour obtenir un bien","crime/délit","7 à 15 ans"),
    ("meurtre","homicide intentionnel","crime","15 à 30 ans"),
    ("assassinat","meurtre avec préméditation","crime","réclusion criminelle à perpétuité"),
    ("viol","agression sexuelle avec pénétration","crime","15 à 20 ans"),
    ("violences volontaires","atteinte physique intentionnelle","délit/crime","selon gravité"),
    ("harcèlement moral","comportement répété dégradant","délit","1 an emprisonnement"),
    ("harcèlement sexuel","propos ou comportements sexuels répétés","délit","2 ans emprisonnement"),
    ("prise d'otage","privation de liberté avec contrainte","crime","20 à 30 ans"),
    ("séquestration","détention arbitraire d'une personne","crime","15 à 20 ans"),
    ("trafic de stupéfiants","production vente transport de drogues","crime","10 ans et plus"),
    ("blanchiment","réintégration de fonds illicites","délit","5 ans emprisonnement"),
    ("corruption passive","accepter un avantage pour acte de fonction","délit","10 ans emprisonnement"),
    ("fraude fiscale","soustraction à l'impôt","délit","5 ans emprisonnement"),
    ("abus de biens sociaux","utilisation à des fins personnelles de biens d'une société","délit","5 ans"),
    ("faux en écriture","altération frauduleuse d'un document","délit","3 ans emprisonnement"),
    ("contrefaçon","reproduction d'une œuvre protégée sans autorisation","délit","3 ans"),
    ("attentat","acte terroriste ou violent contre l'État","crime","réclusion criminelle"),
    ("association de malfaiteurs","entente pour commettre des infractions","délit/crime","selon objet"),
    ("proxénétisme","aide à la prostitution d'autrui","délit","7 ans emprisonnement"),
    ("abandon de famille","non-paiement de pension alimentaire","délit","2 ans emprisonnement"),
    ("mise en danger","exposition d'autrui à un risque grave","délit","1 an emprisonnement"),
    ("non-assistance à personne en danger","omission de secourir","délit","5 ans emprisonnement"),
    ("homicide involontaire","mort causée par imprudence","délit","3 à 5 ans"),
    ("blessures involontaires","blessure causée par imprudence","délit","selon gravité"),
    ("dégradations volontaires","destruction de bien d'autrui","délit","2 ans emprisonnement"),
]

PROCEDURES_POLICE = [
    ("garde à vue","mesure de rétention pour enquête","48h max (droit commun)","OPJ sous contrôle procureur"),
    ("perquisition","fouille d'un domicile","entre 6h et 21h (sauf flagrance)","autorisation du JLD"),
    ("audition libre","audition sans contrainte","sans durée fixée","sans mesure coercitive"),
    ("flagrant délit","infraction en cours ou récente","12h extensibles","pouvoirs renforcés OPJ"),
    ("enquête préliminaire","enquête hors flagrance","sans urgence","direction parquet"),
    ("commission rogatoire","délégation d'enquête","selon instructions du juge","par juge d'instruction"),
    ("mise en examen","statut de suspect avec charges","par juge d'instruction","droits de la défense"),
    ("contrôle judiciaire","mesure alternative à la détention","sans incarcération","obligations de présence"),
    ("détention provisoire","emprisonnement avant jugement","durée limitée","autorisation JLD"),
    ("renvoi en jugement","fin d'instruction","ordonnance de renvoi","vers tribunal compétent"),
    ("comparution immédiate","jugement rapide après arrestation","délai court","avec accord procureur"),
    ("convocation par PV","citation à comparaître","par courrier","par OPJ"),
    ("saisie","appréhension d'objets liés à l'infraction","pendant enquête","sur autorisation"),
    ("écoutes téléphoniques","interception des communications","ordonnée par JI","sous contrôle judiciaire"),
    ("expertise médico-légale","examen par un médecin légiste","sur réquisition","preuve judiciaire"),
    ("test ADN","prélèvement et analyse génétique","sur réquisition","fichier FNAEG"),
    ("repérage de voix","identification vocale","sur réquisition","expertise phonétique"),
    ("confrontation","mise en présence suspect et victime","pendant enquête","droits garantis"),
    ("reconstitution","reconstitution des faits sur les lieux","si utile","avec toutes les parties"),
    ("liberté provisoire","remise en liberté avant jugement","par décision judiciaire","avec ou sans conditions"),
]


# ─── VILLES DE FRANCE ─────────────────────────────────────────────────────────
# (nom, région, population_approx, spécialité)
VILLES_FRANCE = [
    ("Paris","Île-de-France",2161000,"capitale et ville lumière"),
    ("Marseille","PACA",868671,"deuxième ville de France"),
    ("Lyon","Auvergne-Rhône-Alpes",522969,"capitale gastronomique"),
    ("Toulouse","Occitanie",486828,"ville rose et aéronautique"),
    ("Nice","PACA",342669,"capitale de la Côte d'Azur"),
    ("Nantes","Pays de la Loire",320732,"capitale de l'Ouest"),
    ("Montpellier","Occitanie",295542,"ville étudiante du Sud"),
    ("Strasbourg","Grand Est",284677,"siège du Parlement européen"),
    ("Bordeaux","Nouvelle-Aquitaine",257804,"capitale du vin"),
    ("Lille","Hauts-de-France",236234,"métropole du Nord"),
    ("Rennes","Bretagne",220488,"capitale bretonne"),
    ("Reims","Grand Est",183042,"ville du sacre et du champagne"),
    ("Le Havre","Normandie",172366,"ville reconstruite par Perret"),
    ("Cergy","Île-de-France",200000,"ville nouvelle"),
    ("Saint-Étienne","Auvergne-Rhône-Alpes",174382,"ancienne capitale du charbon"),
    ("Toulon","PACA",176851,"base navale"),
    ("Grenoble","Auvergne-Rhône-Alpes",158552,"capitale des Alpes"),
    ("Dijon","Bourgogne-Franche-Comté",153004,"capitale de la moutarde"),
    ("Angers","Pays de la Loire",157175,"ville des châteaux"),
    ("Nîmes","Occitanie",150672,"Rome française"),
    ("Villeurbanne","Auvergne-Rhône-Alpes",149019,"commune périurbaine de Lyon"),
    ("Clermont-Ferrand","Auvergne-Rhône-Alpes",147865,"ville des volcans"),
    ("Le Mans","Pays de la Loire",143240,"ville des 24 heures"),
    ("Aix-en-Provence","PACA",143006,"ville de Cézanne"),
    ("Brest","Bretagne",139386,"port militaire breton"),
    ("Tours","Centre-Val de Loire",138000,"cœur du Val de Loire"),
    ("Amiens","Hauts-de-France",135501,"ville gothique"),
    ("Limoges","Nouvelle-Aquitaine",131834,"porcelaine"),
    ("Annecy","Auvergne-Rhône-Alpes",126924,"Venise des Alpes"),
    ("Perpignan","Occitanie",121875,"catalane"),
]

# ─── RÉGIONS DE FRANCE ────────────────────────────────────────────────────────
# (nom, chef-lieu, nb_departements, spécialité)
REGIONS_FRANCE = [
    ("Auvergne-Rhône-Alpes","Lyon",12,"volcans et Alpes"),
    ("Bourgogne-Franche-Comté","Dijon",8,"vins et fromages"),
    ("Bretagne","Rennes",4,"crêpes et menhirs"),
    ("Centre-Val de Loire","Orléans",6,"châteaux de la Loire"),
    ("Corse","Ajaccio",2,"île de Beauté"),
    ("Grand Est","Strasbourg",10,"Alsace Champagne Lorraine"),
    ("Guadeloupe","Basse-Terre",1,"île antillaise"),
    ("Guyane","Cayenne",1,"forêt amazonienne"),
    ("Hauts-de-France","Lille",5,"Nord Pas-de-Calais Picardie"),
    ("Île-de-France","Paris",8,"région capitale"),
    ("La Réunion","Saint-Denis",1,"île volcanique"),
    ("Martinique","Fort-de-France",1,"île caribéenne"),
    ("Mayotte","Mamoudzou",1,"collectivité d'outre-mer"),
    ("Normandie","Rouen",5,"débarquement et cidre"),
    ("Nouvelle-Aquitaine","Bordeaux",12,"vins de Bordeaux"),
    ("Occitanie","Toulouse",13,"Sud-Ouest et aéronautique"),
    ("Pays de la Loire","Nantes",5,"Loire Atlantique"),
    ("Provence-Alpes-Côte d'Azur","Marseille",6,"Méditerranée et lavande"),
]

# ─── DONNÉES SÉCURITÉ ROUTIÈRE ─────────────────────────────────────────────────
SECURITE_ROUTIERE = [
    ("agglomération","50 km/h","zone habitée avec signalisation d'entrée"),
    ("route hors agglomération","80 km/h","route nationale ou départementale"),
    ("route à 2x2 voies sans séparateur","80 km/h","route rapide non autoroutière"),
    ("voie rapide (ex-route nationale 2×2)","110 km/h","route express"),
    ("autoroute","130 km/h","infrastructure à accès limité"),
    ("autoroute sous la pluie","110 km/h","réduction par temps de pluie"),
    ("agglomération sous la pluie","50 km/h","inchangée en agglomération"),
    ("conducteur novice (permis < 2 ans) sur autoroute","110 km/h","restriction permis probatoire"),
]

ALCOOLEMIE_REGLES = [
    ("conducteur standard","0.5 g/L","infraction délictuelle au-delà","retrait de permis et amende"),
    ("conducteur novice (< 3 ans de permis)","0.2 g/L","contravention dès 0.2","stages obligatoires"),
    ("chauffeur professionnel","0.2 g/L","seuil réduit pour sécurité","infraction grave"),
    ("refus de souffler","équivalent alcoolémie délictuelle","refus assimilé à infraction","mêmes peines"),
    ("récidive d'alcool au volant","0.5 g/L","crimes routiers aggravés","suspension longue durée"),
]

PANNEAUX_SECURITE = [
    ("panneau triangulaire rouge","danger","signalisation de danger à venir"),
    ("panneau circulaire rouge","interdiction","limitation ou interdiction"),
    ("panneau circulaire bleu","obligation","obligation à respecter"),
    ("panneau carré bleu","indication","information de service"),
    ("panneau octogonal rouge (stop)","arrêt obligatoire","priorité absolue"),
    ("cédez le passage (triangle inversé)","priorité à droite","céder le passage"),
    ("flèche verte clignotante","voie libre","feu autorisant le passage"),
    ("feux tricolores rouge","arrêt obligatoire","s'arrêter avant le feu"),
    ("feux tricolores orange fixe","préparation à l'arrêt","ne pas s'engager"),
    ("feux tricolores vert","passage autorisé","avancer avec prudence"),
    ("ligne continue blanche","interdiction de dépassement","ne pas franchir"),
    ("ligne discontinue blanche","dépassement autorisé","sous conditions"),
    ("bande d'arrêt d'urgence","voie de secours","uniquement en cas d'urgence"),
    ("zone 30","limite 30 km/h","zone apaisée"),
    ("zone de rencontre","limite 20 km/h","piétons prioritaires"),
]

# ─── ARTICLES JURIDIQUES CLÉS ─────────────────────────────────────────────────
ARTICLES_DROIT = [
    ("Article 111-1 CP","classification des infractions","crimes délits contraventions"),
    ("Article 122-1 CP","irresponsabilité pénale pour trouble mental","excuse psychiatrique"),
    ("Article 121-3 CP","faute intentionnelle ou non intentionnelle","élément moral"),
    ("Article 63 CPP","garde à vue","conditions durée droits"),
    ("Article 56 CPP","perquisition saisie","conditions de validité"),
    ("Article 62-2 CPP","conditions de placement en garde à vue","nécessité indices"),
    ("Article 9 CEDH","liberté de religion","droit fondamental"),
    ("Article 8 CEDH","droit au respect de la vie privée","protection vie privée"),
    ("Article 6 CEDH","droit à un procès équitable","garanties procédurales"),
    ("Article 5 CEDH","droit à la liberté et à la sûreté","détention légale"),
    ("Article 3 CEDH","interdiction de la torture","traitement inhumain"),
    ("Article 2 CEDH","droit à la vie","protection absolue"),
    ("Article 1 DDHC 1789","liberté et égalité en droit","fondement républicain"),
    ("Article 16 DDHC 1789","séparation des pouvoirs","garantie des droits"),
    ("Article 66 Constitution","autorité judiciaire gardienne des libertés","rôle du juge"),
    ("Article 34 Constitution","domaine de la loi","compétence du Parlement"),
    ("Article 37 Constitution","domaine du règlement","compétence du gouvernement"),
    ("Article 89 Constitution","révision constitutionnelle","procédure d'amendement"),
    ("Article 49-3 Constitution","vote de confiance lié à un texte","pouvoir exécutif"),
    ("Article 16 Constitution","pouvoirs exceptionnels du Président","crise grave"),
]

# ─── GRADES POLICE NATIONALE ───────────────────────────────────────────────────
GRADES_PN = [
    ("Gardien de la paix","Catégorie C","premier grade du corps d'encadrement et d'application","OPJ sous habilitation"),
    ("Brigadier","Catégorie C","grade supérieur du corps d'encadrement","OPJ habilité"),
    ("Brigadier-chef","Catégorie C","spécialiste ou chef d'équipe","responsabilité terrain"),
    ("Major","Catégorie B","premier grade d'officier","encadrement d'équipes"),
    ("Capitaine","Catégorie B","commandant d'unité","chef de service"),
    ("Commandant","Catégorie B","cadre supérieur","direction d'unité"),
    ("Lieutenant de police","Catégorie A","officier de police","responsabilité accrue"),
    ("Capitaine de police","Catégorie A","cadre supérieur","direction de service"),
    ("Commandant de police","Catégorie A","commandant","grand commandement"),
    ("Commissaire de police","Catégorie A+","chef de circonscription","direction CSP"),
    ("Commissaire divisionnaire","Catégorie A+","haut fonctionnaire","direction départementale"),
    ("Directeur","Catégorie A+","direction nationale","chef de service central"),
]


# ═══════════════════════════════════════════════════════════════════════════════
# UTILITAIRES COMMUNS AUX GÉNÉRATEURS
# ═══════════════════════════════════════════════════════════════════════════════

def _autres(lst, val, key_fn=None):
    """Retourne les éléments de lst dont la clé ≠ val, mélangés."""
    if key_fn:
        res = [x for x in lst if key_fn(x) != val]
    else:
        res = [x for x in lst if x != val]
    random.shuffle(res)
    return res

def _fill(results, target, gen_fn, max_factor=8):
    """Appelle gen_fn() jusqu'à avoir <target> questions uniques."""
    max_tries = target * max_factor
    t = 0
    while len(results) < target and t < max_tries:
        r = gen_fn()
        if r is not None:
            results.append(r)
        t += 1

# Pré-calculs géographiques
_BY_CONT = {}
for _p, _c, _co, _a in PAYS:
    _BY_CONT.setdefault(_co, []).append((_p, _c, _a))
_ALL_PAYS_NAMES = [p for p, c, co, a in PAYS]
_CONTINENTS = list(_BY_CONT.keys())

def _rand_distractors_pays(exclude_names, n=3):
    pool = [p for p in _ALL_PAYS_NAMES if p not in exclude_names]
    return random.sample(pool, min(n, len(pool)))

# ═══════════════════════════════════════════════════════════════════════════════
# GÉNÉRATEUR GÉOGRAPHIE  (~750K questions)
# ═══════════════════════════════════════════════════════════════════════════════
def gen_geographie():
    results = []
    M, C = "Culture générale", "Geographie"

    # ── 1. Templates directs (10 templates × 195 pays) ─────────────────────
    for pays, capitale, continent, area in PAYS:
        autres_cap = [cap for p,cap,co,a in PAYS if cap != capitale]
        random.shuffle(autres_cap)
        autres_pays = [p for p,c,co,a in PAYS if p != pays]
        random.shuffle(autres_pays)
        autres_cont = [co for p,c,co,a in PAYS if co != continent]
        autres_cont_u = list(set(autres_cont))
        random.shuffle(autres_cont_u)

        # T1
        r = q(M,C,"Facile",f"Quelle est la capitale de {pays} ?",
               [capitale]+autres_cap[:3], capitale,
               f"La capitale de {pays} est {capitale}.")
        if r: results.append(r)
        # T2
        r = q(M,C,"Facile",f"{capitale} est la capitale de quel pays ?",
               [pays]+autres_pays[:3], pays,
               f"{capitale} est la capitale de {pays} ({continent}).")
        if r: results.append(r)
        # T3
        r = q(M,C,"Facile",f"Dans quel continent se trouve {pays} ?",
               [continent]+autres_cont_u[:3], continent,
               f"{pays} est situé en {continent}, avec pour capitale {capitale}.")
        if r: results.append(r)
        # T4
        membres = [p for p,c,co,a in PAYS if co == continent and p != pays]
        random.shuffle(membres)
        if membres:
            r = q(M,C,"Moyenne",f"Quel pays partage le même continent que {pays} ?",
                   [membres[0]]+autres_pays[:3], membres[0],
                   f"{membres[0]} est aussi en {continent}, comme {pays}.")
            if r: results.append(r)
        # T5 - Superficie
        pays_plus_grands = sorted([(p,a) for p,c,co,a in PAYS if a > area], key=lambda x:x[1])
        pays_plus_petits = sorted([(p,a) for p,c,co,a in PAYS if a < area], key=lambda x:x[1], reverse=True)
        if pays_plus_grands and pays_plus_petits:
            grand = pays_plus_grands[0][0]
            petit = pays_plus_petits[0][0]
            r = q(M,C,"Difficile",f"Quel pays est plus grand que {pays} mais plus petit que {grand} ?",
                   [pays_plus_grands[0][0] if len(pays_plus_grands)>1 else grand,
                    grand, petit]+autres_pays[:1],
                   pays_plus_grands[0][0] if len(pays_plus_grands)>1 else grand,
                   f"{pays} a une superficie d'environ {area:,} km².")
            # skip this one if too ambiguous, just add a simpler T5
            r = q(M,C,"Moyenne",f"Quelle est la superficie approximative de {pays} ?",
                   [f"{area//1000}k km²",
                    f"{area*2//1000}k km²",
                    f"{area//2000}k km²",
                    f"{area*3//1000}k km²"],
                   f"{area//1000}k km²",
                   f"{pays} a une superficie d'environ {area//1000} 000 km².")
            if r: results.append(r)

    log.info(f"  Géo templates directs: {len(results)}")

    # ── 2. Quel pays se trouve en [continent] (4 noms dans le texte) ─────────
    def _geo_q1():
        cont = random.choice(_CONTINENTS)
        membres = _BY_CONT[cont]
        correct_entry = random.choice(membres)
        correct = correct_entry[0]
        distr = _rand_distractors_pays({correct}, 3)
        quatre = sorted([correct] + distr)
        noms = ", ".join(quatre[:-1]) + " ou " + quatre[-1]
        text = f"Lequel de ces pays se trouve en {cont} : {noms} ?"
        return q(M,C,"Facile",text, [correct]+distr, correct,
                 f"{correct} est un pays situé en {cont}.")

    _fill(results, 250000, _geo_q1)
    log.info(f"  Géo continent-appartient: {len(results)}")

    # ── 3. Quel pays N'est PAS en [continent] ─────────────────────────────────
    def _geo_q2():
        cont = random.choice(_CONTINENTS)
        membres = _BY_CONT[cont]
        if len(membres) < 3: return None
        trois = random.sample(membres, 3)
        autres = [p for p in _ALL_PAYS_NAMES if p not in [e[0] for e in membres]]
        if not autres: return None
        wrong = random.choice(autres)
        all4 = sorted([e[0] for e in trois] + [wrong])
        noms = ", ".join(all4[:-1]) + " ou " + all4[-1]
        text = f"Lequel de ces pays n'appartient PAS à {cont} : {noms} ?"
        return q(M,C,"Moyenne",text, [wrong]+[e[0] for e in trois], wrong,
                 f"{wrong} ne se trouve pas en {cont}.")

    _fill(results, 400000, _geo_q2)
    log.info(f"  Géo non-appartient: {len(results)}")

    # ── 4. Capital inverse par continent ─────────────────────────────────────
    def _geo_q3():
        cont = random.choice(_CONTINENTS)
        membres = _BY_CONT[cont]
        entry = random.choice(membres)
        pays_c, cap_c, _ = entry
        autres_caps = [cap for p,cap,a in membres if cap != cap_c]
        if len(autres_caps) < 3:
            autres_caps = [cap for p,cap,co,a in PAYS if cap != cap_c]
        random.shuffle(autres_caps)
        text = f"Parmi les capitales suivantes, laquelle est en {cont} : {cap_c}, {autres_caps[0]}, {autres_caps[1]} ou {autres_caps[2]} ?"
        return q(M,C,"Difficile",text,
                 [cap_c,autres_caps[0],autres_caps[1],autres_caps[2]], cap_c,
                 f"{cap_c} est la capitale de {pays_c} en {cont}.")

    _fill(results, 500000, _geo_q3)
    log.info(f"  Géo capital-continent: {len(results)}")

    # ── 5. Superficie comparée ────────────────────────────────────────────────
    pays_trie = sorted(PAYS, key=lambda x: x[3], reverse=True)
    def _geo_q4():
        i = random.randint(0, len(pays_trie)-4)
        quatre = random.sample(pays_trie, 4)
        quatre.sort(key=lambda x: x[3], reverse=True)
        grand = quatre[0][0]
        all4 = sorted([e[0] for e in quatre])
        noms = ", ".join(all4[:-1]) + " ou " + all4[-1]
        text = f"Parmi ces 4 pays, lequel a la plus grande superficie : {noms} ?"
        return q(M,C,"Difficile",text, [e[0] for e in quatre], grand,
                 f"{grand} a la plus grande superficie des quatre avec {quatre[0][3]:,} km².")

    _fill(results, 600000, _geo_q4)
    log.info(f"  Géo superficie: {len(results)}")

    # ── 6. Régions de France ──────────────────────────────────────────────────
    for nom, chef, nb_dep, spec in REGIONS_FRANCE:
        autres_chefs = [c for n,c,nd,s in REGIONS_FRANCE if c != chef]
        random.shuffle(autres_chefs)
        r = q(M,C,"Moyenne",f"Quel est le chef-lieu de la région {nom} ?",
               [chef]+autres_chefs[:3], chef,
               f"Le chef-lieu de {nom} est {chef} ({spec}).")
        if r: results.append(r)
        r = q(M,C,"Difficile",f"Quelle région française a {chef} comme chef-lieu ?",
               [nom]+[n for n,c,nd,s in REGIONS_FRANCE if n != nom][:3], nom,
               f"{chef} est le chef-lieu de la région {nom}.")
        if r: results.append(r)
        r = q(M,C,"Moyenne",f"Combien de départements compte la région {nom} ?",
               [str(nb_dep), str(nb_dep+2), str(nb_dep-1), str(nb_dep+4)],
               str(nb_dep),
               f"La région {nom} compte {nb_dep} département(s).")
        if r: results.append(r)

    # ── 7. Villes de France ───────────────────────────────────────────────────
    for ville, region, pop, spec in VILLES_FRANCE:
        autres_r = [r for v,r,p,s in VILLES_FRANCE if r != region]
        random.shuffle(autres_r)
        r = q(M,C,"Moyenne",f"Dans quelle région se trouve la ville de {ville} ?",
               [region]+autres_r[:3], region,
               f"{ville} se trouve en {region} ({spec}).")
        if r: results.append(r)
        r = q(M,C,"Facile",f"Quelle est la spécialité ou caractéristique de {ville} ?",
               [spec]+[s for v,r,p,s in VILLES_FRANCE if s != spec][:3], spec,
               f"{ville} est connue pour {spec}.")
        if r: results.append(r)

    # ── 8. Remplissage jusqu'à la cible ──────────────────────────────────────
    _fill(results, TARGET_CAT, _geo_q2, max_factor=4)
    log.info(f"  Géographie TOTAL: {len(results)}")
    return results


# ═══════════════════════════════════════════════════════════════════════════════
# GÉNÉRATEUR HISTOIRE  (~750K questions)
# ═══════════════════════════════════════════════════════════════════════════════
def gen_histoire():
    results = []
    M, C = "Culture générale", "Histoire"

    # ── 1. Templates directs par événement ────────────────────────────────────
    for annee, evt, pays_evt, desc in HISTOIRE_EVENTS:
        autres_a = [a for a,e,p,d in HISTOIRE_EVENTS if a != annee]
        random.shuffle(autres_a)
        autres_e = [e for a,e,p,d in HISTOIRE_EVENTS if e != evt]
        random.shuffle(autres_e)
        autres_p = [p for a,e,p,d in HISTOIRE_EVENTS if p != pays_evt]
        random.shuffle(autres_p)

        annee_str = str(annee) if annee > 0 else f"{abs(annee)} av. J.-C."
        autres_a_str = [str(a) if a > 0 else f"{abs(a)} av. J.-C." for a in autres_a[:3]]

        r = q(M,C,"Moyenne",f"En quelle année {evt} s'est-il produit ?",
               [annee_str]+autres_a_str, annee_str,
               f"{evt} a eu lieu en {annee_str} ({desc}).")
        if r: results.append(r)

        r = q(M,C,"Facile",f"Quel événement s'est produit en {annee_str} ?",
               [evt]+autres_e[:3], evt,
               f"En {annee_str}, {evt} — {desc}.")
        if r: results.append(r)

        r = q(M,C,"Difficile",f"Dans quel pays s'est produit : {evt} ?",
               [pays_evt]+autres_p[:3], pays_evt,
               f"{evt} ({annee_str}) s'est produit en {pays_evt}.")
        if r: results.append(r)

        r = q(M,C,"Moyenne",f"Comment décrit-on {evt} ?",
               [desc]+[d for a,e,p,d in HISTOIRE_EVENTS if d != desc][:3], desc,
               f"{evt} est caractérisé par : {desc}.")
        if r: results.append(r)

    log.info(f"  Histoire templates directs: {len(results)}")

    # ── 2. Quel événement est arrivé en premier (4 noms dans le texte) ────────
    def _hist_q1():
        sample4 = random.sample(HISTOIRE_EVENTS, 4)
        sample4.sort(key=lambda x: x[0])
        premier = sample4[0]
        evts_txt = sorted([e[1][:40] for e in sample4])
        noms = ", ".join(f'"{e}"' for e in evts_txt[:-1]) + f' ou "{evts_txt[-1]}"'
        text = f"Lequel de ces événements s'est produit en premier : {noms} ?"
        short_premier = premier[1][:40]
        return q(M,C,"Difficile",text,
                 [e[1][:40] for e in sample4], short_premier,
                 f'"{premier[1]}" s\'est produit en {premier[0] if premier[0]>0 else str(abs(premier[0]))+" av. J.-C."}, avant les autres.')

    _fill(results, 200000, _hist_q1)
    log.info(f"  Histoire premier: {len(results)}")

    # ── 3. Quel événement est arrivé en dernier ───────────────────────────────
    def _hist_q2():
        sample4 = random.sample(HISTOIRE_EVENTS, 4)
        sample4.sort(key=lambda x: x[0])
        dernier = sample4[-1]
        evts_txt = sorted([e[1][:40] for e in sample4])
        noms = ", ".join(f'"{e}"' for e in evts_txt[:-1]) + f' ou "{evts_txt[-1]}"'
        text = f"Lequel de ces événements s'est produit en dernier : {noms} ?"
        short_dernier = dernier[1][:40]
        return q(M,C,"Difficile",text,
                 [e[1][:40] for e in sample4], short_dernier,
                 f'"{dernier[1]}" est le plus récent des quatre ({dernier[0]}).')

    _fill(results, 350000, _hist_q2)
    log.info(f"  Histoire dernier: {len(results)}")

    # ── 4. Personnages historiques ────────────────────────────────────────────
    for nom, periode, nationalite, domaine in PERSONNAGES:
        autres_n = [n for n,p,nat,d in PERSONNAGES if n != nom]
        random.shuffle(autres_n)
        autres_nat = [nat for n,p,nat,d in PERSONNAGES if nat != nationalite]
        random.shuffle(autres_nat)
        autres_d = [d for n,p,nat,d in PERSONNAGES if d != domaine]
        random.shuffle(autres_d)

        r = q(M,C,"Moyenne",f"Quelle était la nationalité de {nom} ?",
               [nationalite]+autres_nat[:3], nationalite,
               f"{nom} était {nationalite} ({domaine}, {periode}).")
        if r: results.append(r)

        r = q(M,C,"Difficile",f"Quel {domaine} portait le nom de {nom} ?",
               [nom]+autres_n[:3], nom,
               f"{nom} ({nationalite}, {periode}) était {domaine}.")
        if r: results.append(r)

        r = q(M,C,"Moyenne",f"Dans quel domaine {nom} s'est-il/elle illustré(e) ?",
               [domaine]+autres_d[:3], domaine,
               f"{nom} ({nationalite}) est célèbre comme {domaine}.")
        if r: results.append(r)

    # ── 5. Événements par siècle ──────────────────────────────────────────────
    siecles = {}
    for annee, evt, pays_evt, desc in HISTOIRE_EVENTS:
        siec = (annee // 100) * 100
        siecles.setdefault(siec, []).append((annee, evt, pays_evt))

    def _hist_q3():
        siec = random.choice(list(siecles.keys()))
        if len(siecles[siec]) < 1: return None
        ev = random.choice(siecles[siec])
        autres_siec = [s for s in siecles.keys() if s != siec]
        if len(autres_siec) < 3: return None
        autres_s = random.sample(autres_siec, 3)
        siec_str = str(abs(siec)//100+1)+"e" if siec >= 0 else str(abs(siec)//100+1)+"e av. J.-C."
        text = f"Au cours de quel siècle {ev[1]} s'est-il produit (en {ev[0]}) ?"
        opts = [siec_str] + [str(abs(s)//100+1)+"e" for s in autres_s]
        return q(M,C,"Difficile",text, opts, siec_str,
                 f"{ev[1]} a eu lieu en {ev[0]}, donc au {siec_str} siècle.")

    _fill(results, 500000, _hist_q3)
    log.info(f"  Histoire siècle: {len(results)}")

    # ── 6. Remplissage final ──────────────────────────────────────────────────
    _fill(results, TARGET_CAT, _hist_q1, max_factor=3)
    log.info(f"  Histoire TOTAL: {len(results)}")
    return results


# ═══════════════════════════════════════════════════════════════════════════════
# GÉNÉRATEUR SCIENCES  (~750K questions)
# ═══════════════════════════════════════════════════════════════════════════════
def gen_sciences():
    results = []
    M, C = "Culture générale", "Sciences"

    # ── 1. Éléments chimiques ──────────────────────────────────────────────────
    for num, sym, nom_el, famille, decouvreur, annee_d in ELEMENTS:
        autres_n = [n for z,s,n,f,d,a in ELEMENTS if n != nom_el]
        autres_s = [s for z,s,n,f,d,a in ELEMENTS if s != sym]
        autres_f = [f for z,s,n,f,d,a in ELEMENTS if f != famille]
        random.shuffle(autres_n); random.shuffle(autres_s); random.shuffle(autres_f)

        r = q(M,C,"Moyenne",f"Quel est le symbole chimique de l'élément {nom_el} ?",
               [sym]+autres_s[:3], sym,
               f"Le symbole de {nom_el} est {sym} (numéro atomique {num}).")
        if r: results.append(r)

        r = q(M,C,"Moyenne",f"Quel élément chimique a le symbole {sym} ?",
               [nom_el]+autres_n[:3], nom_el,
               f"{sym} est le symbole de {nom_el} (Z={num}).")
        if r: results.append(r)

        r = q(M,C,"Difficile",f"Quel est le numéro atomique de {nom_el} ?",
               [str(num)]+[str(z) for z,s,n,f,d,a in random.sample(ELEMENTS,3) if z != num],
               str(num),
               f"{nom_el} ({sym}) a le numéro atomique Z={num}.")
        if r: results.append(r)

        r = q(M,C,"Difficile",f"À quelle famille appartient l'élément {nom_el} ?",
               [famille]+autres_f[:3], famille,
               f"{nom_el} ({sym}) est un {famille}.")
        if r: results.append(r)

    # ── 2. Inventions ──────────────────────────────────────────────────────────
    for inv, inventeur, annee_i, pays_i in INVENTIONS:
        autres_inv = [i for i,inv2,a,p in INVENTIONS if i != inv]
        autres_inv2 = [inv2 for i,inv2,a,p in INVENTIONS if inv2 != inventeur]
        autres_a = [a for i,inv2,a,p in INVENTIONS if a != annee_i]
        autres_p = [p for i,inv2,a,p in INVENTIONS if p != pays_i]
        random.shuffle(autres_inv); random.shuffle(autres_inv2)
        random.shuffle(autres_a); random.shuffle(autres_p)

        r = q(M,C,"Moyenne",f"Qui a inventé {inv} ?",
               [inventeur]+autres_inv2[:3], inventeur,
               f"{inv} a été inventé par {inventeur} en {annee_i} ({pays_i}).")
        if r: results.append(r)

        r = q(M,C,"Moyenne",f"En quelle année {inv} a-t-il été inventé ?",
               [str(annee_i)]+[str(a) for a in autres_a[:3]], str(annee_i),
               f"{inv} a été inventé par {inventeur} en {annee_i}.")
        if r: results.append(r)

        r = q(M,C,"Difficile",f"Dans quel pays {inv} a-t-il été inventé ?",
               [pays_i]+autres_p[:3], pays_i,
               f"{inv} ({inventeur}, {annee_i}) est une invention {pays_i}.")
        if r: results.append(r)

        r = q(M,C,"Facile",f"Quelle invention est associée à {inventeur} ?",
               [inv]+autres_inv[:3], inv,
               f"{inventeur} est l'inventeur de {inv} ({annee_i}).")
        if r: results.append(r)

    log.info(f"  Sciences templates directs: {len(results)}")

    # ── 3. Combinatoire : quelle invention est la plus ancienne ───────────────
    def _sci_q1():
        sample4 = random.sample(INVENTIONS, 4)
        sample4.sort(key=lambda x: x[2])
        plus_ancienne = sample4[0][0]
        invs_txt = sorted([e[0][:35] for e in sample4])
        noms = ", ".join(f'"{e}"' for e in invs_txt[:-1]) + f' ou "{invs_txt[-1]}"'
        text = f"Laquelle de ces inventions est la plus ancienne : {noms} ?"
        return q(M,C,"Difficile",text,
                 [e[0][:35] for e in sample4], plus_ancienne[:35],
                 f'"{plus_ancienne}" date de {sample4[0][2]}, la plus ancienne des quatre.')

    _fill(results, 200000, _sci_q1)

    # ── 4. Qui a inventé quoi (4 inventeurs dans le texte) ───────────────────
    def _sci_q2():
        entry = random.choice(INVENTIONS)
        inv, inventeur, annee_i, pays_i = entry
        autres_inv3 = [inv2 for i,inv2,a,p in INVENTIONS if inv2 != inventeur]
        if len(autres_inv3) < 3: return None
        distr = random.sample(autres_inv3, 3)
        all4 = sorted([inventeur]+distr)
        noms = ", ".join(all4[:-1]) + " ou " + all4[-1]
        text = f"Parmi ces inventeurs, lequel a inventé {inv} : {noms} ?"
        return q(M,C,"Moyenne",text, all4, inventeur,
                 f"{inventeur} a inventé {inv} en {annee_i}.")

    _fill(results, 400000, _sci_q2)

    # ── 5. Quel inventeur vient de quel pays ──────────────────────────────────
    def _sci_q3():
        entry = random.choice(INVENTIONS)
        inv, inventeur, annee_i, pays_i = entry
        autres_pays_sci = [p for i,inv2,a,p in INVENTIONS if p != pays_i]
        if len(autres_pays_sci) < 3: return None
        distr = random.sample(autres_pays_sci, 3)
        all4 = sorted([pays_i]+distr)
        noms = ", ".join(all4[:-1]) + " ou " + all4[-1]
        text = f"De quel pays vient l'invention de {inv} par {inventeur} : {noms} ?"
        return q(M,C,"Difficile",text, all4, pays_i,
                 f"{inv} a été inventé en {pays_i} par {inventeur} en {annee_i}.")

    _fill(results, 600000, _sci_q3)

    # ── 6. Numéro atomique le plus élevé parmi 4 éléments ────────────────────
    def _sci_q4():
        sample4 = random.sample(ELEMENTS, 4)
        sample4.sort(key=lambda x: x[0], reverse=True)
        plus_lourd = sample4[0][2]
        all4_noms = sorted([e[2] for e in sample4])
        noms = ", ".join(all4_noms[:-1]) + " ou " + all4_noms[-1]
        text = f"Lequel de ces éléments a le numéro atomique le plus élevé : {noms} ?"
        return q(M,C,"Difficile",text, all4_noms, plus_lourd,
                 f"{plus_lourd} a le numéro atomique Z={sample4[0][0]}, le plus élevé.")

    _fill(results, TARGET_CAT, _sci_q4, max_factor=5)
    log.info(f"  Sciences TOTAL: {len(results)}")
    return results


# ═══════════════════════════════════════════════════════════════════════════════
# GÉNÉRATEUR SANTÉ  (~750K questions)
# ═══════════════════════════════════════════════════════════════════════════════
def gen_sante():
    results = []
    M, C = "Culture générale", "Sante"

    # ── 1. Maladies – templates directs ───────────────────────────────────────
    for maladie, cause, symptome, traitement in MALADIES:
        autres_c = [c for m,c,s,t in MALADIES if c != cause]
        autres_s = [s for m,c,s,t in MALADIES if s != symptome]
        autres_t = [t for m,c,s,t in MALADIES if t != traitement]
        autres_m = [m for m,c,s,t in MALADIES if m != maladie]
        random.shuffle(autres_c); random.shuffle(autres_s)
        random.shuffle(autres_t); random.shuffle(autres_m)

        r = q(M,C,"Facile",f"Quelle est la cause principale du {maladie} ?",
               [cause]+autres_c[:3], cause,
               f"Le {maladie} est causé par {cause}.")
        if r: results.append(r)

        r = q(M,C,"Facile",f"Quel est le symptôme principal du {maladie} ?",
               [symptome]+autres_s[:3], symptome,
               f"Le principal symptôme du {maladie} est {symptome}.")
        if r: results.append(r)

        r = q(M,C,"Moyenne",f"Quel traitement est utilisé contre le {maladie} ?",
               [traitement]+autres_t[:3], traitement,
               f"Le {maladie} se traite par {traitement}.")
        if r: results.append(r)

        r = q(M,C,"Moyenne",f"Quelle maladie se traite par {traitement} (parmi celles-ci) ?",
               [maladie]+autres_m[:3], maladie,
               f"Le {maladie} est une maladie traitée par {traitement}.")
        if r: results.append(r)

    # ── 2. Combinatoire maladies ──────────────────────────────────────────────
    def _san_q1():
        entry = random.choice(MALADIES)
        maladie, cause, symptome, traitement = entry
        autres_m2 = [m for m,c,s,t in MALADIES if m != maladie]
        if len(autres_m2) < 3: return None
        distr = random.sample(autres_m2, 3)
        all4 = sorted([maladie]+distr)
        noms = ", ".join(all4[:-1]) + " ou " + all4[-1]
        text = f"Laquelle de ces maladies est causée par {cause} : {noms} ?"
        return q(M,C,"Difficile",text, all4, maladie,
                 f"Le {maladie} est causé par {cause}.")

    _fill(results, 200000, _san_q1)

    def _san_q2():
        entry = random.choice(MALADIES)
        maladie, cause, symptome, traitement = entry
        autres_t2 = [t for m,c,s,t in MALADIES if t != traitement]
        if len(autres_t2) < 3: return None
        distr = random.sample(autres_t2, 3)
        all4 = sorted([traitement]+distr)
        noms = ", ".join(all4[:-1]) + " ou " + all4[-1]
        text = f"Quel traitement est spécifique au {maladie} parmi : {noms} ?"
        return q(M,C,"Moyenne",text, all4, traitement,
                 f"Le {maladie} se traite par {traitement}.")

    _fill(results, 400000, _san_q2)

    def _san_q3():
        entry = random.choice(MALADIES)
        maladie, cause, symptome, traitement = entry
        autres_s3 = [s for m,c,s,t in MALADIES if s != symptome]
        if len(autres_s3) < 3: return None
        distr = random.sample(autres_s3, 3)
        all4 = sorted([symptome]+distr)
        noms = ", ".join(all4[:-1]) + " ou " + all4[-1]
        text = f"Quel symptôme évoque en premier le {maladie} parmi : {noms} ?"
        return q(M,C,"Facile",text, all4, symptome,
                 f"Le {maladie} se manifeste principalement par {symptome}.")

    _fill(results, 600000, _san_q3)

    # ── 3. Questions sur les éléments vitaux et corps humain ──────────────────
    corps_humain_qs = [
        ("le cœur","pomper le sang","système cardiovasculaire","4 cavités (2 oreillettes, 2 ventricules)"),
        ("le foie","filtrer le sang et synthétiser","système digestif","plus grand organe interne"),
        ("les poumons","oxygéner le sang","système respiratoire","2 poumons divisés en lobes"),
        ("le cerveau","contrôler le corps","système nerveux","1,4 kg en moyenne"),
        ("les reins","filtrer le sang et produire l'urine","système urinaire","2 reins en forme de haricot"),
        ("la rate","filtrer le sang et réguler l'immunité","système lymphatique","peut être ablation"),
        ("le pancréas","produire insuline et enzymes digestives","système endocrinien","dual exocrine/endocrine"),
        ("l'intestin grêle","absorber les nutriments","système digestif","5 à 7 mètres de long"),
        ("le côlon","absorber l'eau et former les selles","système digestif","environ 1,5 mètre"),
        ("la thyroïde","réguler le métabolisme","système endocrinien","produit les hormones T3 et T4"),
        ("la moelle osseuse","produire les cellules sanguines","système hématologique","dans les os"),
        ("les artères","transporter le sang oxygéné","système cardiovasculaire","haute pression"),
        ("les veines","transporter le sang désoxygéné","système cardiovasculaire","basse pression"),
        ("les capillaires","échanges entre sang et cellules","système cardiovasculaire","très fins"),
        ("la peau","protéger l'organisme","système tégumentaire","plus grand organe du corps"),
    ]
    for organe, fonction, systeme, detail in corps_humain_qs:
        autres_f = [f for o,f,s,d in corps_humain_qs if f != fonction]
        autres_o = [o for o,f,s,d in corps_humain_qs if o != organe]
        random.shuffle(autres_f); random.shuffle(autres_o)

        r = q(M,C,"Facile",f"Quelle est la fonction principale de {organe} ?",
               [fonction]+autres_f[:3], fonction,
               f"{organe.capitalize()} sert à {fonction} ({systeme}).")
        if r: results.append(r)

        r = q(M,C,"Moyenne",f"Quel organe a pour fonction de {fonction} ?",
               [organe]+autres_o[:3], organe,
               f"C'est {organe} qui {fonction} ({detail}).")
        if r: results.append(r)

    _fill(results, TARGET_CAT, _san_q1, max_factor=4)
    log.info(f"  Santé TOTAL: {len(results)}")
    return results


# ═══════════════════════════════════════════════════════════════════════════════
# GÉNÉRATEUR CINÉMA  (~750K questions)
# ═══════════════════════════════════════════════════════════════════════════════
def gen_cinema():
    results = []
    M, C = "Culture générale", "Cinema"

    # ── 1. Templates directs ──────────────────────────────────────────────────
    for titre, real, annee_f, pays_f in FILMS:
        autres_r = [r for t,r,a,p in FILMS if r != real]
        autres_t = [t for t,r,a,p in FILMS if t != titre]
        autres_a = [a for t,r,a,p in FILMS if a != annee_f]
        autres_p = [p for t,r,a,p in FILMS if p != pays_f]
        random.shuffle(autres_r); random.shuffle(autres_t)
        random.shuffle(autres_a); random.shuffle(autres_p)

        r = q(M,C,"Moyenne",f"Qui a réalisé le film '{titre}' ?",
               [real]+autres_r[:3], real,
               f"'{titre}' ({annee_f}) a été réalisé par {real}.")
        if r: results.append(r)

        r = q(M,C,"Facile",f"En quelle année le film '{titre}' est-il sorti ?",
               [str(annee_f)]+[str(a) for a in autres_a[:3]], str(annee_f),
               f"'{titre}' de {real} est sorti en {annee_f}.")
        if r: results.append(r)

        r = q(M,C,"Difficile",f"Quelle nationalité est associée au film '{titre}' ?",
               [pays_f]+autres_p[:3], pays_f,
               f"'{titre}' ({real}, {annee_f}) est un film {pays_f}.")
        if r: results.append(r)

        r = q(M,C,"Moyenne",f"Quel film {real} a-t-il réalisé en {annee_f} ?",
               [titre]+autres_t[:3], titre,
               f"{real} a réalisé '{titre}' en {annee_f}.")
        if r: results.append(r)

    log.info(f"  Cinéma templates directs: {len(results)}")

    # ── 2. Combinatoire : quel film est le plus ancien ────────────────────────
    def _cin_q1():
        sample4 = random.sample(FILMS, 4)
        sample4.sort(key=lambda x: x[2])
        plus_ancien = sample4[0][0]
        titres_txt = sorted([f"'{e[0]}'" for e in sample4])
        noms = ", ".join(titres_txt[:-1]) + " ou " + titres_txt[-1]
        text = f"Lequel de ces films est le plus ancien : {noms} ?"
        return q(M,C,"Difficile",text,
                 [e[0] for e in sample4], plus_ancien,
                 f"'{plus_ancien}' date de {sample4[0][2]}, le plus ancien des quatre.")

    _fill(results, 200000, _cin_q1)

    # ── 3. Quel réalisateur pour ce film parmi 4 ─────────────────────────────
    def _cin_q2():
        entry = random.choice(FILMS)
        titre, real, annee_f, pays_f = entry
        autres_r2 = [r for t,r,a,p in FILMS if r != real]
        if len(autres_r2) < 3: return None
        distr = random.sample(autres_r2, 3)
        all4 = sorted([real]+distr)
        noms = ", ".join(all4[:-1]) + " ou " + all4[-1]
        text = f"Quel réalisateur a tourné '{titre}' ({annee_f}) : {noms} ?"
        return q(M,C,"Moyenne",text, all4, real,
                 f"'{titre}' a été réalisé par {real} en {annee_f}.")

    _fill(results, 400000, _cin_q2)

    # ── 4. Quel film vient de quel pays ────────────────────────────────────────
    def _cin_q3():
        entry = random.choice(FILMS)
        titre, real, annee_f, pays_f = entry
        autres_p2 = [p for t,r,a,p in FILMS if p != pays_f]
        if len(autres_p2) < 3: return None
        distr = random.sample(autres_p2, 3)
        all4 = sorted([pays_f]+distr)
        noms = ", ".join(all4[:-1]) + " ou " + all4[-1]
        text = f"De quel pays est le film '{titre}' de {real} : {noms} ?"
        return q(M,C,"Difficile",text, all4, pays_f,
                 f"'{titre}' ({real}) est un film {pays_f} de {annee_f}.")

    _fill(results, 600000, _cin_q3)

    # ── 5. Quel film est le plus récent ───────────────────────────────────────
    def _cin_q4():
        sample4 = random.sample(FILMS, 4)
        sample4.sort(key=lambda x: x[2], reverse=True)
        plus_recent = sample4[0][0]
        titres_txt = sorted([f"'{e[0]}'" for e in sample4])
        noms = ", ".join(titres_txt[:-1]) + " ou " + titres_txt[-1]
        text = f"Lequel de ces films est le plus récent : {noms} ?"
        return q(M,C,"Difficile",text,
                 [e[0] for e in sample4], plus_recent,
                 f"'{plus_recent}' date de {sample4[0][2]}, le plus récent des quatre.")

    _fill(results, TARGET_CAT, _cin_q4, max_factor=4)
    log.info(f"  Cinéma TOTAL: {len(results)}")
    return results


# ═══════════════════════════════════════════════════════════════════════════════
# GÉNÉRATEUR MUSIQUE  (~750K questions)
# ═══════════════════════════════════════════════════════════════════════════════
def gen_musique():
    results = []
    M, C = "Culture générale", "Musique"

    # ── 1. Compositeurs classiques ────────────────────────────────────────────
    for nom_c, periode, nat_c, oeuvre_c in COMPOSITEURS:
        autres_n = [n for n,p,nat,o in COMPOSITEURS if n != nom_c]
        autres_o = [o for n,p,nat,o in COMPOSITEURS if o != oeuvre_c]
        autres_p = [p for n,p,nat,o in COMPOSITEURS if p != periode]
        autres_nat = [nat for n,p,nat,o in COMPOSITEURS if nat != nat_c]
        random.shuffle(autres_n); random.shuffle(autres_o)
        random.shuffle(autres_p); random.shuffle(autres_nat)

        r = q(M,C,"Moyenne",f"Quelle est l'œuvre célèbre de {nom_c} ?",
               [oeuvre_c]+autres_o[:3], oeuvre_c,
               f"{nom_c} est connu pour {oeuvre_c} (période {periode}).")
        if r: results.append(r)

        r = q(M,C,"Difficile",f"Qui a composé {oeuvre_c} ?",
               [nom_c]+autres_n[:3], nom_c,
               f"{oeuvre_c} est l'œuvre de {nom_c} ({nat_c}, {periode}).")
        if r: results.append(r)

        r = q(M,C,"Moyenne",f"À quelle période musicale appartient {nom_c} ?",
               [periode]+autres_p[:3], periode,
               f"{nom_c} appartient à la période {periode}.")
        if r: results.append(r)

        r = q(M,C,"Difficile",f"De quelle nationalité est le compositeur {nom_c} ?",
               [nat_c]+autres_nat[:3], nat_c,
               f"{nom_c} est {nat_c} ({periode}, {oeuvre_c}).")
        if r: results.append(r)

    log.info(f"  Musique templates directs: {len(results)}")

    # ── 2. Quel compositeur est le plus ancien ────────────────────────────────
    periodes_ordre = {
        "baroque": 1, "classicisme": 2, "classicisme-romantisme": 3,
        "romantisme": 4, "romantisme tardif": 5, "impressionnisme": 6,
        "jazz-classique": 7, "modernisme": 8, "tango nuevo": 9, "contemporain": 10, "minimalisme": 11
    }
    compo_avec_rang = [(n,p,nat,o,periodes_ordre.get(p,5)) for n,p,nat,o in COMPOSITEURS]

    def _mus_q1():
        sample4 = random.sample(compo_avec_rang, 4)
        sample4.sort(key=lambda x: x[4])
        plus_ancien = sample4[0][0]
        noms_txt = sorted([e[0] for e in sample4])
        noms = ", ".join(noms_txt[:-1]) + " ou " + noms_txt[-1]
        text = f"Lequel de ces compositeurs appartient à la période la plus ancienne : {noms} ?"
        return q(M,C,"Difficile",text,
                 noms_txt, plus_ancien,
                 f"{plus_ancien} appartient à la période {sample4[0][1]}, la plus ancienne.")

    _fill(results, 200000, _mus_q1)

    # ── 3. Qui a composé quoi (4 compositeurs pour 1 œuvre) ──────────────────
    def _mus_q2():
        entry = random.choice(COMPOSITEURS)
        nom_c, periode, nat_c, oeuvre_c = entry
        autres_n2 = [n for n,p,nat,o in COMPOSITEURS if n != nom_c]
        if len(autres_n2) < 3: return None
        distr = random.sample(autres_n2, 3)
        all4 = sorted([nom_c]+distr)
        noms = ", ".join(all4[:-1]) + " ou " + all4[-1]
        text = f"Parmi ces compositeurs, lequel a créé {oeuvre_c} : {noms} ?"
        return q(M,C,"Difficile",text, all4, nom_c,
                 f"{nom_c} a composé {oeuvre_c} (période {periode}).")

    _fill(results, 400000, _mus_q2)

    # ── 4. Quelle nationalité ─────────────────────────────────────────────────
    def _mus_q3():
        entry = random.choice(COMPOSITEURS)
        nom_c, periode, nat_c, oeuvre_c = entry
        autres_nat2 = [nat for n,p,nat,o in COMPOSITEURS if nat != nat_c]
        if len(autres_nat2) < 3: return None
        distr = random.sample(autres_nat2, 3)
        all4 = sorted([nat_c]+distr)
        noms = ", ".join(all4[:-1]) + " ou " + all4[-1]
        text = f"De quelle nationalité est le compositeur {nom_c} ({oeuvre_c}) : {noms} ?"
        return q(M,C,"Difficile",text, all4, nat_c,
                 f"{nom_c} est {nat_c}, célèbre pour {oeuvre_c}.")

    _fill(results, 600000, _mus_q3)

    def _mus_q4():
        entry = random.choice(COMPOSITEURS)
        nom_c, periode, nat_c, oeuvre_c = entry
        autres_o2 = [o for n,p,nat,o in COMPOSITEURS if o != oeuvre_c]
        if len(autres_o2) < 3: return None
        distr = random.sample(autres_o2, 3)
        all4 = sorted([oeuvre_c]+distr)
        noms = ", ".join(all4[:-1]) + " ou " + all4[-1]
        text = f"Quelle œuvre a été composée par {nom_c} ({nat_c}) : {noms} ?"
        return q(M,C,"Moyenne",text, all4, oeuvre_c,
                 f"{nom_c} est l'auteur de {oeuvre_c}.")

    _fill(results, TARGET_CAT, _mus_q4, max_factor=5)
    log.info(f"  Musique TOTAL: {len(results)}")
    return results


# ═══════════════════════════════════════════════════════════════════════════════
# GÉNÉRATEUR MYTHOLOGIE  (~750K questions)
# ═══════════════════════════════════════════════════════════════════════════════
def gen_mythologie():
    results = []
    M, C = "Culture générale", "Mythologie"

    # ── 1. Templates directs ──────────────────────────────────────────────────
    for dieu, culture, domaine, attribut in MYTHES:
        autres_d = [d for di,cu,d,a in MYTHES if d != domaine]
        autres_di = [di for di,cu,d,a in MYTHES if di != dieu]
        autres_cu = [cu for di,cu,d,a in MYTHES if cu != culture]
        autres_at = [a for di,cu,d,a in MYTHES if a != attribut]
        random.shuffle(autres_d); random.shuffle(autres_di)
        random.shuffle(autres_cu); random.shuffle(autres_at)

        r = q(M,C,"Facile",f"Dans la mythologie {culture}, quel est le domaine de {dieu} ?",
               [domaine]+autres_d[:3], domaine,
               f"Dans la mythologie {culture}, {dieu} est le {domaine}, symbolisé par {attribut}.")
        if r: results.append(r)

        r = q(M,C,"Facile",f"Quel dieu de la mythologie {culture} est associé à {attribut} ?",
               [dieu]+autres_di[:3], dieu,
               f"{dieu} est le {domaine} dans la mythologie {culture}, symbolisé par {attribut}.")
        if r: results.append(r)

        r = q(M,C,"Moyenne",f"À quelle mythologie appartient {dieu} ({domaine}) ?",
               [culture]+autres_cu[:3], culture,
               f"{dieu} est une divinité de la mythologie {culture}.")
        if r: results.append(r)

        r = q(M,C,"Difficile",f"Quel est l'attribut symbolique de {dieu} dans la mythologie {culture} ?",
               [attribut]+autres_at[:3], attribut,
               f"{dieu} ({domaine}, mythologie {culture}) est symbolisé par {attribut}.")
        if r: results.append(r)

    log.info(f"  Mythologie templates directs: {len(results)}")

    # ── 2. Combinatoire : quelle divinité appartient à la mythologie X ────────
    mythes_by_culture = {}
    for dieu, culture, domaine, attribut in MYTHES:
        mythes_by_culture.setdefault(culture, []).append(dieu)
    cultures = list(mythes_by_culture.keys())

    def _myt_q1():
        culture_c = random.choice(cultures)
        membres_m = mythes_by_culture[culture_c]
        correct_m = random.choice(membres_m)
        autres_dieux = [d for d,cu,do,a in MYTHES if d not in membres_m]
        if len(autres_dieux) < 3: return None
        distr = random.sample(autres_dieux, 3)
        all4 = sorted([correct_m]+distr)
        noms = ", ".join(all4[:-1]) + " ou " + all4[-1]
        text = f"Lequel de ces dieux appartient à la mythologie {culture_c} : {noms} ?"
        return q(M,C,"Facile",text, all4, correct_m,
                 f"{correct_m} est une divinité de la mythologie {culture_c}.")

    _fill(results, 200000, _myt_q1)

    def _myt_q2():
        culture_c = random.choice(cultures)
        membres_m = mythes_by_culture[culture_c]
        if len(membres_m) < 3: return None
        trois = random.sample(membres_m, 3)
        autres_dieux = [d for d,cu,do,a in MYTHES if d not in membres_m]
        if not autres_dieux: return None
        wrong_m = random.choice(autres_dieux)
        all4 = sorted(trois + [wrong_m])
        noms = ", ".join(all4[:-1]) + " ou " + all4[-1]
        text = f"Lequel de ces dieux n'appartient PAS à la mythologie {culture_c} : {noms} ?"
        return q(M,C,"Moyenne",text, all4, wrong_m,
                 f"{wrong_m} n'est pas une divinité de la mythologie {culture_c}.")

    _fill(results, 400000, _myt_q2)

    def _myt_q3():
        entry = random.choice(MYTHES)
        dieu, culture, domaine, attribut = entry
        autres_dom = [d for di,cu,d,a in MYTHES if d != domaine]
        if len(autres_dom) < 3: return None
        distr = random.sample(autres_dom, 3)
        all4 = sorted([domaine]+distr)
        noms = ", ".join(all4[:-1]) + " ou " + all4[-1]
        text = f"Quel est le domaine de {dieu} dans la mythologie {culture} : {noms} ?"
        return q(M,C,"Facile",text, all4, domaine,
                 f"{dieu} est le {domaine} dans la mythologie {culture}.")

    _fill(results, 600000, _myt_q3)

    def _myt_q4():
        entry = random.choice(MYTHES)
        dieu, culture, domaine, attribut = entry
        autres_at2 = [a for di,cu,d,a in MYTHES if a != attribut]
        if len(autres_at2) < 3: return None
        distr = random.sample(autres_at2, 3)
        all4 = sorted([attribut]+distr)
        noms = ", ".join(all4[:-1]) + " ou " + all4[-1]
        text = f"Quel attribut symbolise {dieu} ({domaine}, mythologie {culture}) : {noms} ?"
        return q(M,C,"Difficile",text, all4, attribut,
                 f"{dieu} est symbolisé par {attribut} dans la mythologie {culture}.")

    _fill(results, TARGET_CAT, _myt_q4, max_factor=5)
    log.info(f"  Mythologie TOTAL: {len(results)}")
    return results


# ═══════════════════════════════════════════════════════════════════════════════
# GÉNÉRATEUR SÉCURITÉ ROUTIÈRE  (~750K questions)
# ═══════════════════════════════════════════════════════════════════════════════
def gen_securite():
    results = []
    M, C = "Culture générale", "Securite"

    # ── 1. Limites de vitesse ─────────────────────────────────────────────────
    for zone, vitesse, contexte in SECURITE_ROUTIERE:
        autres_v = [v for z,v,c in SECURITE_ROUTIERE if v != vitesse]
        autres_z = [z for z,v,c in SECURITE_ROUTIERE if z != zone]
        random.shuffle(autres_v); random.shuffle(autres_z)

        r = q(M,C,"Facile",f"Quelle est la limite de vitesse sur {zone} en France ?",
               [vitesse]+autres_v[:3], vitesse,
               f"La limite est de {vitesse} sur {zone} ({contexte}).")
        if r: results.append(r)

        r = q(M,C,"Facile",f"Sur quel type de voie la limite est-elle de {vitesse} en France ?",
               [zone]+autres_z[:3], zone,
               f"{vitesse} est la limite sur {zone} ({contexte}).")
        if r: results.append(r)

    # ── 2. Alcoolémie ─────────────────────────────────────────────────────────
    for conducteur, seuil, detail, consequence in ALCOOLEMIE_REGLES:
        autres_s = [s for c,s,d,con in ALCOOLEMIE_REGLES if s != seuil]
        autres_c = [c for c,s,d,con in ALCOOLEMIE_REGLES if c != conducteur]
        random.shuffle(autres_s); random.shuffle(autres_c)

        r = q(M,C,"Facile",f"Quel est le taux d'alcoolémie maximal autorisé pour un {conducteur} ?",
               [seuil]+autres_s[:3], seuil,
               f"Pour un {conducteur}, le taux maximum est {seuil} ({detail}).")
        if r: results.append(r)

    # ── 3. Panneaux ───────────────────────────────────────────────────────────
    for panneau, signif, desc in PANNEAUX_SECURITE:
        autres_s = [s for p,s,d in PANNEAUX_SECURITE if s != signif]
        autres_p = [p for p,s,d in PANNEAUX_SECURITE if p != panneau]
        random.shuffle(autres_s); random.shuffle(autres_p)

        r = q(M,C,"Facile",f"Que signifie un {panneau} ?",
               [signif]+autres_s[:3], signif,
               f"Un {panneau} indique {signif} ({desc}).")
        if r: results.append(r)

    log.info(f"  Sécurité templates directs: {len(results)}")

    # ── 4. Combinatoire vitesse ───────────────────────────────────────────────
    def _sec_q1():
        z1, v1, c1 = random.choice(SECURITE_ROUTIERE)
        autres_z2 = [(z,v,c) for z,v,c in SECURITE_ROUTIERE if z != z1]
        if len(autres_z2) < 3: return None
        distr_3 = random.sample(autres_z2, 3)
        vitesses_distr = [v for z,v,c in distr_3]
        all4_v = sorted([v1]+vitesses_distr)
        noms = ", ".join(all4_v[:-1]) + " ou " + all4_v[-1]
        text = f"Sur {z1}, parmi ces vitesses laquelle est la limite autorisée : {noms} ?"
        return q(M,C,"Moyenne",text, all4_v, v1,
                 f"La limite sur {z1} est {v1} ({c1}).")

    _fill(results, 200000, _sec_q1)

    def _sec_q2():
        entry = random.choice(PANNEAUX_SECURITE)
        panneau, signif, desc = entry
        autres_s2 = [s for p,s,d in PANNEAUX_SECURITE if s != signif]
        if len(autres_s2) < 3: return None
        distr = random.sample(autres_s2, 3)
        all4 = sorted([signif]+distr)
        noms = ", ".join(all4[:-1]) + " ou " + all4[-1]
        text = f"Parmi ces significations, laquelle correspond à un {panneau} : {noms} ?"
        return q(M,C,"Facile",text, all4, signif,
                 f"Un {panneau} indique : {signif} ({desc}).")

    _fill(results, 400000, _sec_q2)

    # Questions génériques sécurité routière étendues
    extra_sec = [
        ("Facile","Quel est le numéro d'urgence européen ?","112",
         ["112","15","17","18"],"Le 112 est le numéro d'urgence européen, utilisable dans tous les pays de l'UE."),
        ("Facile","Quel numéro appeler pour la police en France ?","17",
         ["17","15","18","112"],"Le 17 est le numéro de la police nationale en France."),
        ("Facile","Quel numéro appeler pour le SAMU en France ?","15",
         ["15","17","18","112"],"Le 15 est le numéro du SAMU (aide médicale urgente)."),
        ("Facile","Quel numéro appeler pour les pompiers en France ?","18",
         ["18","15","17","112"],"Le 18 est le numéro des sapeurs-pompiers."),
        ("Moyenne","Quelle distance de sécurité est recommandée à 130 km/h ?","115 mètres (règle des 2 secondes)",
         ["115 mètres (règle des 2 secondes)","50 mètres","200 mètres","75 mètres"],
         "À 130 km/h, la règle des 2 secondes correspond à environ 115 mètres."),
        ("Difficile","Quelle est la sanction pour un refus de souffler dans l'éthylotest ?","mêmes peines que l'alcoolémie délictuelle",
         ["mêmes peines que l'alcoolémie délictuelle","amende 135 €","retrait 2 points","simple avertissement"],
         "Le refus est assimilé à une infraction et puni comme l'alcoolémie délictuelle."),
        ("Facile","Combien de points possède un permis probatoire ?","6 points",
         ["6 points","12 points","8 points","10 points"],"Un permis probatoire commence à 6 points."),
        ("Facile","Combien de points possède un permis confirmé ?","12 points",
         ["12 points","6 points","20 points","8 points"],"Un permis confirmé (>3 ans) comporte 12 points."),
        ("Moyenne","À quelle vitesse la limite est-elle réduite sous la pluie sur autoroute ?","110 km/h",
         ["110 km/h","130 km/h","90 km/h","100 km/h"],"Sous la pluie sur autoroute, la limite passe à 110 km/h."),
        ("Difficile","Quelle est la distance minimale pour signaler un obstacle sur route ?","30 mètres minimum",
         ["30 mètres minimum","10 mètres","100 mètres","50 mètres"],"Les triangles doivent être placés à au moins 30 mètres."),
    ]
    for diff, q_txt, a, opts, expl in extra_sec:
        r = q(M,C,diff,q_txt,opts,a,expl)
        if r: results.append(r)

    def _sec_q3():
        # Question combinatoire sur l'alcoolémie
        conducteur, seuil, detail, consequence = random.choice(ALCOOLEMIE_REGLES)
        autres_con = [con for c,s,d,con in ALCOOLEMIE_REGLES if con != consequence]
        if len(autres_con) < 3: return None
        distr = random.sample(autres_con, 3)
        all4 = sorted([consequence]+distr)
        noms = ", ".join(all4[:-1]) + " ou " + all4[-1]
        text = f"Quelle est la conséquence d'un dépassement du seuil pour un {conducteur} : {noms} ?"
        return q(M,C,"Difficile",text, all4, consequence,
                 f"Pour un {conducteur} (seuil {seuil}), la conséquence est : {consequence}.")

    _fill(results, 600000, _sec_q3)
    _fill(results, TARGET_CAT, _sec_q1, max_factor=6)
    log.info(f"  Sécurité TOTAL: {len(results)}")
    return results


# ═══════════════════════════════════════════════════════════════════════════════
# GÉNÉRATEUR INSTITUTIONS  (~750K questions)
# ═══════════════════════════════════════════════════════════════════════════════
def gen_institutions():
    results = []
    M, C = "Culture générale", "Institutions"

    # ── 1. Institutions mondiales templates directs ────────────────────────────
    for sigle, nom_complet, siege, role in INSTITUTIONS_MONDE:
        autres_s = [s for sg,n,s,r in INSTITUTIONS_MONDE if s != siege]
        autres_r = [r for sg,n,s,r in INSTITUTIONS_MONDE if r != role]
        autres_sg = [sg for sg,n,s,r in INSTITUTIONS_MONDE if sg != sigle]
        autres_n = [n for sg,n,s,r in INSTITUTIONS_MONDE if n != nom_complet]
        random.shuffle(autres_s); random.shuffle(autres_r)
        random.shuffle(autres_sg); random.shuffle(autres_n)

        r = q(M,C,"Moyenne",f"Où se trouve le siège de {nom_complet} ({sigle}) ?",
               [siege]+autres_s[:3], siege,
               f"{sigle} ({nom_complet}) a son siège à {siege}. Rôle : {role}.")
        if r: results.append(r)

        r = q(M,C,"Difficile",f"Que signifie le sigle {sigle} ?",
               [nom_complet]+autres_n[:3], nom_complet,
               f"{sigle} signifie '{nom_complet}', basé à {siege}.")
        if r: results.append(r)

        r = q(M,C,"Facile",f"Quel est le rôle de {sigle} ({nom_complet}) ?",
               [role]+autres_r[:3], role,
               f"{sigle} est chargé de {role}, avec siège à {siege}.")
        if r: results.append(r)

        r = q(M,C,"Difficile",f"Quelle organisation internationale a son siège à {siege} ?",
               [sigle]+autres_sg[:3], sigle,
               f"{sigle} ({nom_complet}) est basé à {siege}.")
        if r: results.append(r)

    log.info(f"  Institutions templates directs: {len(results)}")

    # ── 2. Combinatoire ────────────────────────────────────────────────────────
    def _ins_q1():
        entry = random.choice(INSTITUTIONS_MONDE)
        sigle, nom_complet, siege, role = entry
        autres_s2 = [s for sg,n,s,r in INSTITUTIONS_MONDE if s != siege]
        if len(autres_s2) < 3: return None
        distr = random.sample(autres_s2, 3)
        all4 = sorted([siege]+distr)
        noms = ", ".join(all4[:-1]) + " ou " + all4[-1]
        text = f"Parmi ces villes, dans laquelle {sigle} ({nom_complet}) a-t-il son siège : {noms} ?"
        return q(M,C,"Difficile",text, all4, siege,
                 f"{sigle} a son siège à {siege}.")

    _fill(results, 200000, _ins_q1)

    def _ins_q2():
        entry = random.choice(INSTITUTIONS_MONDE)
        sigle, nom_complet, siege, role = entry
        autres_r2 = [r for sg,n,s,r in INSTITUTIONS_MONDE if r != role]
        if len(autres_r2) < 3: return None
        distr = random.sample(autres_r2, 3)
        all4 = sorted([role]+distr)
        noms = ", ".join(all4[:-1]) + " ou " + all4[-1]
        text = f"Parmi ces rôles, lequel correspond à la mission de {sigle} ({siege}) : {noms} ?"
        return q(M,C,"Facile",text, all4, role,
                 f"{sigle} est chargé de {role}.")

    _fill(results, 400000, _ins_q2)

    def _ins_q3():
        entry = random.choice(INSTITUTIONS_MONDE)
        sigle, nom_complet, siege, role = entry
        autres_sg2 = [sg for sg,n,s,r in INSTITUTIONS_MONDE if sg != sigle]
        if len(autres_sg2) < 3: return None
        distr = random.sample(autres_sg2, 3)
        all4 = sorted([sigle]+distr)
        noms = ", ".join(all4[:-1]) + " ou " + all4[-1]
        text = f"Quelle organisation est chargée de {role} parmi : {noms} ?"
        return q(M,C,"Facile",text, all4, sigle,
                 f"C'est {sigle} ({nom_complet}) qui est chargé de {role}.")

    _fill(results, 600000, _ins_q3)
    _fill(results, TARGET_CAT, _ins_q1, max_factor=5)
    log.info(f"  Institutions TOTAL: {len(results)}")
    return results


# ═══════════════════════════════════════════════════════════════════════════════
# GÉNÉRATEUR ACTUALITÉ  (~750K questions)
# ═══════════════════════════════════════════════════════════════════════════════
def gen_actualite():
    results = []
    M, C = "Culture générale", "Actualite"

    # Base de faits géopolitiques
    faits_geopolitiques = [
        ("population mondiale","8 milliards d'habitants","2023","démographie"),
        ("pays le plus peuplé","l'Inde","2023","démographie"),
        ("deuxième pays le plus peuplé","la Chine","2023","démographie"),
        ("pays le plus grand","la Russie","superficie","géographie"),
        ("deuxième plus grand pays","le Canada","superficie","géographie"),
        ("pays le plus peuplé d'Afrique","le Nigéria","200 millions","démographie"),
        ("première puissance économique","les États-Unis","PIB","économie"),
        ("deuxième puissance économique","la Chine","PIB","économie"),
        ("principale organisation de défense","l'OTAN","créée en 1949","sécurité"),
        ("nombre de membres de l'ONU","193 membres","2023","institutions"),
        ("nombre de membres de l'UE","27 membres","après Brexit","institutions"),
        ("monnaie de la zone euro","l'euro","introduit en 2002","économie"),
        ("première émetteur mondial de CO2","la Chine","émissions carbonées","environnement"),
        ("accord climatique de Paris","signé par 196 parties","COP21 2015","environnement"),
        ("objectif température accord Paris","limiter à 1.5-2°C","réchauffement","environnement"),
        ("pandémie COVID-19","SARS-CoV-2","déclarée mars 2020","santé"),
        ("principale organisation de commerce","l'OMC","à Genève","commerce"),
        ("agence nucléaire internationale","l'AIEA","à Vienne","nucléaire"),
        ("principale cour internationale","la CIJ","à La Haye","justice"),
        ("programme alimentaire mondial","PAM à Rome","prix Nobel 2020","humanitaire"),
        ("taux de chômage France","autour de 7%","2023","économie"),
        ("dépenses militaires mondiales","2 200 milliards $","2023","défense"),
        ("continent le plus touché par la désertification","l'Afrique","sahélisation","environnement"),
        ("première source d'énergie renouvelable","l'hydraulique","barrage","énergie"),
        ("pays avec le plus de centrales nucléaires","les États-Unis","93 réacteurs","énergie"),
        ("fondateur des droits numériques","Tim Berners-Lee","World Wide Web 1989","technologie"),
        ("intelligence artificielle pionnière","ChatGPT (OpenAI)","lancé en 2022","technologie"),
        ("réseau social le plus utilisé","Facebook/Meta","3 milliards d'utilisateurs","technologie"),
        ("moteur de recherche dominant","Google","90% des recherches","technologie"),
        ("premier pays à légaliser le mariage homosexuel","les Pays-Bas","en 2001","droits"),
    ]

    for sujet, reponse, precision, domaine in faits_geopolitiques:
        autres_r = [r for s,r,p,d in faits_geopolitiques if r != reponse]
        random.shuffle(autres_r)
        r = q(M,C,"Facile",f"Quel est/Quelle est {sujet} ?",
               [reponse]+autres_r[:3], reponse,
               f"{sujet.capitalize()} : {reponse} ({precision}).")
        if r: results.append(r)

        r = q(M,C,"Moyenne",f"Dans le domaine de {domaine}, quelle est la réponse à : {sujet} ?",
               [reponse]+autres_r[:3], reponse,
               f"Concernant {domaine} : {sujet} → {reponse} ({precision}).")
        if r: results.append(r)

    log.info(f"  Actualité templates directs: {len(results)}")

    # ── Combinatoire avec les pays ────────────────────────────────────────────
    def _act_q1():
        cont = random.choice(_CONTINENTS)
        membres = _BY_CONT[cont]
        if not membres: return None
        correct_e = random.choice(membres)
        correct_act = correct_e[0]
        distr = _rand_distractors_pays({correct_act}, 3)
        all4 = sorted([correct_act]+distr)
        noms = ", ".join(all4[:-1]) + " ou " + all4[-1]
        text = f"Dans l'actualité internationale, lequel de ces pays se situe en {cont} : {noms} ?"
        return q(M,C,"Facile",text, all4, correct_act,
                 f"{correct_act} est un pays d'{cont}.")

    _fill(results, 200000, _act_q1)

    def _act_q2():
        entry = random.choice(faits_geopolitiques)
        sujet, reponse, precision, domaine = entry
        autres_dom = list(set([d for s,r,p,d in faits_geopolitiques if d != domaine]))
        if len(autres_dom) < 3: return None
        distr = random.sample(autres_dom, 3)
        all4 = sorted([domaine]+distr)
        noms = ", ".join(all4[:-1]) + " ou " + all4[-1]
        text = f"Le fait '{sujet} = {reponse}' relève de quel domaine parmi : {noms} ?"
        return q(M,C,"Difficile",text, all4, domaine,
                 f"Ce fait relève du domaine {domaine} ({precision}).")

    _fill(results, 400000, _act_q2)

    def _act_q3():
        cont = random.choice(_CONTINENTS)
        membres = _BY_CONT[cont]
        if len(membres) < 3: return None
        trois = random.sample(membres, 3)
        autres_p = [p for p in _ALL_PAYS_NAMES if p not in [e[0] for e in membres]]
        if not autres_p: return None
        wrong_a = random.choice(autres_p)
        all4 = sorted([e[0] for e in trois]+[wrong_a])
        noms = ", ".join(all4[:-1]) + " ou " + all4[-1]
        text = f"Sur la scène internationale, lequel de ces pays n'est pas en {cont} : {noms} ?"
        return q(M,C,"Moyenne",text, all4, wrong_a,
                 f"{wrong_a} ne fait pas partie de {cont}.")

    _fill(results, 600000, _act_q3)
    _fill(results, TARGET_CAT, _act_q1, max_factor=4)
    log.info(f"  Actualité TOTAL: {len(results)}")
    return results


# ═══════════════════════════════════════════════════════════════════════════════
# GÉNÉRATEUR FRANCE  (~750K questions)
# ═══════════════════════════════════════════════════════════════════════════════
def gen_france():
    results = []
    M, C = "Culture générale", "France"

    # ── 1. Régions ────────────────────────────────────────────────────────────
    for nom_r, chef_r, nb_dep, spec_r in REGIONS_FRANCE:
        autres_c = [c for n,c,nd,s in REGIONS_FRANCE if c != chef_r]
        autres_n = [n for n,c,nd,s in REGIONS_FRANCE if n != nom_r]
        autres_s = [s for n,c,nd,s in REGIONS_FRANCE if s != spec_r]
        random.shuffle(autres_c); random.shuffle(autres_n); random.shuffle(autres_s)

        r = q(M,C,"Moyenne",f"Quel est le chef-lieu de la région française {nom_r} ?",
               [chef_r]+autres_c[:3], chef_r,
               f"La région {nom_r} a pour chef-lieu {chef_r} ({spec_r}).")
        if r: results.append(r)

        r = q(M,C,"Difficile",f"Quelle région a {chef_r} comme chef-lieu ?",
               [nom_r]+autres_n[:3], nom_r,
               f"{chef_r} est le chef-lieu de la région {nom_r}.")
        if r: results.append(r)

        r = q(M,C,"Difficile",f"Quelle région est connue pour {spec_r} ?",
               [nom_r]+autres_n[:3], nom_r,
               f"La région {nom_r} est réputée pour {spec_r}.")
        if r: results.append(r)

    # ── 2. Villes ─────────────────────────────────────────────────────────────
    for ville_f, region_f, pop_f, spec_f in VILLES_FRANCE:
        autres_r = [r for v,r,p,s in VILLES_FRANCE if r != region_f]
        autres_v = [v for v,r,p,s in VILLES_FRANCE if v != ville_f]
        autres_s = [s for v,r,p,s in VILLES_FRANCE if s != spec_f]
        random.shuffle(autres_r); random.shuffle(autres_v); random.shuffle(autres_s)

        r = q(M,C,"Moyenne",f"Dans quelle région se trouve la ville de {ville_f} ?",
               [region_f]+autres_r[:3], region_f,
               f"{ville_f} est une ville de la région {region_f} ({spec_f}).")
        if r: results.append(r)

        r = q(M,C,"Facile",f"Quelle ville française est connue pour {spec_f} ?",
               [ville_f]+autres_v[:3], ville_f,
               f"{ville_f} est connue pour {spec_f}.")
        if r: results.append(r)

    log.info(f"  France templates directs: {len(results)}")

    # ── 3. Combinatoire régions ───────────────────────────────────────────────
    def _fra_q1():
        entry = random.choice(REGIONS_FRANCE)
        nom_r, chef_r, nb_dep, spec_r = entry
        autres_c2 = [c for n,c,nd,s in REGIONS_FRANCE if c != chef_r]
        if len(autres_c2) < 3: return None
        distr = random.sample(autres_c2, 3)
        all4 = sorted([chef_r]+distr)
        noms = ", ".join(all4[:-1]) + " ou " + all4[-1]
        text = f"Parmi ces villes, laquelle est le chef-lieu de la région {nom_r} : {noms} ?"
        return q(M,C,"Moyenne",text, all4, chef_r,
                 f"Le chef-lieu de {nom_r} est {chef_r}.")

    _fill(results, 200000, _fra_q1)

    def _fra_q2():
        entry = random.choice(VILLES_FRANCE)
        ville_f, region_f, pop_f, spec_f = entry
        autres_r2 = [r for v,r,p,s in VILLES_FRANCE if r != region_f]
        if len(autres_r2) < 3: return None
        distr = random.sample(autres_r2, 3)
        all4 = sorted([region_f]+distr)
        noms = ", ".join(all4[:-1]) + " ou " + all4[-1]
        text = f"Dans quelle région se trouve {ville_f} (connue pour {spec_f}) : {noms} ?"
        return q(M,C,"Difficile",text, all4, region_f,
                 f"{ville_f} est dans la région {region_f}.")

    _fill(results, 400000, _fra_q2)

    def _fra_q3():
        entry_r = random.choice(REGIONS_FRANCE)
        nom_r, chef_r, nb_dep, spec_r = entry_r
        autres_n2 = [n for n,c,nd,s in REGIONS_FRANCE if n != nom_r]
        if len(autres_n2) < 3: return None
        distr = random.sample(autres_n2, 3)
        all4 = sorted([nom_r]+distr)
        noms = ", ".join(all4[:-1]) + " ou " + all4[-1]
        text = f"Quelle région française est réputée pour {spec_r} : {noms} ?"
        return q(M,C,"Difficile",text, all4, nom_r,
                 f"C'est la région {nom_r} (chef-lieu {chef_r}) qui est connue pour {spec_r}.")

    _fill(results, 600000, _fra_q3)

    # ── 4. Pays avec la France dans des questions de géopolitique ─────────────
    def _fra_q4():
        pays_europe = [p for p,c,co,a in PAYS if co == "Europe"]
        if len(pays_europe) < 4: return None
        correct_f = "France"
        distr_f = random.sample([p for p in pays_europe if p != "France"], 3)
        all4_f = sorted([correct_f]+distr_f)
        facts_fr = [
            "siège de l'OCDE à Paris",
            "Tour Eiffel à Paris",
            "langue officielle : le français",
            "capitale : Paris",
            "devise : Liberté Égalité Fraternité",
            "monnaie : l'euro",
            "membre fondateur de l'Union européenne",
            "siège de l'UNESCO à Paris",
            "hymne : La Marseillaise",
            "Ve République depuis 1958",
        ]
        fact = random.choice(facts_fr)
        noms = ", ".join(all4_f[:-1]) + " ou " + all4_f[-1]
        text = f"Quel pays européen est associé à : {fact} — parmi {noms} ?"
        return q(M,C,"Facile",text, all4_f, correct_f,
                 f"C'est la France qui est associée à : {fact}.")

    _fill(results, TARGET_CAT, _fra_q4, max_factor=6)
    log.info(f"  France TOTAL: {len(results)}")
    return results


# ═══════════════════════════════════════════════════════════════════════════════
# GÉNÉRATEUR POLICE  (~750K questions)
# ═══════════════════════════════════════════════════════════════════════════════
def gen_police():
    results = []
    M, C = "Culture générale", "Police"

    # ── 1. Grades de la Police nationale ──────────────────────────────────────
    for grade, cat, def_grade, info_grade in GRADES_PN:
        autres_def = [d for g,c,d,i in GRADES_PN if d != def_grade]
        autres_g = [g for g,c,d,i in GRADES_PN if g != grade]
        autres_c = [c for g,c,d,i in GRADES_PN if c != cat]
        autres_i = [i for g,c,d,i in GRADES_PN if i != info_grade]
        random.shuffle(autres_def); random.shuffle(autres_g)
        random.shuffle(autres_c); random.shuffle(autres_i)

        r = q(M,C,"Moyenne",f"À quelle catégorie appartient le grade de {grade} dans la Police nationale ?",
               [cat]+autres_c[:3], cat,
               f"Le {grade} est de {cat} ({def_grade}).")
        if r: results.append(r)

        r = q(M,C,"Difficile",f"Qu'est-ce que le grade de {grade} dans la Police nationale ?",
               [def_grade]+autres_def[:3], def_grade,
               f"Le {grade} est {def_grade} ({cat}).")
        if r: results.append(r)

        r = q(M,C,"Difficile",f"Quel grade de la Police nationale correspond à : {def_grade} ?",
               [grade]+autres_g[:3], grade,
               f"C'est le grade de {grade} ({cat}).")
        if r: results.append(r)

    # ── 2. Procédures policières ───────────────────────────────────────────────
    for proc, def_proc, duree, autorite in PROCEDURES_POLICE:
        autres_def = [d for p,d,du,a in PROCEDURES_POLICE if d != def_proc]
        autres_proc = [p for p,d,du,a in PROCEDURES_POLICE if p != proc]
        autres_dur = [du for p,d,du,a in PROCEDURES_POLICE if du != duree]
        autres_aut = [a for p,d,du,a in PROCEDURES_POLICE if a != autorite]
        random.shuffle(autres_def); random.shuffle(autres_proc)
        random.shuffle(autres_dur); random.shuffle(autres_aut)

        r = q(M,C,"Difficile",f"Comment définit-on la procédure de {proc} ?",
               [def_proc]+autres_def[:3], def_proc,
               f"La {proc} est {def_proc} ({duree}, {autorite}).")
        if r: results.append(r)

        r = q(M,C,"Moyenne",f"Quelle est la durée/limite de {proc} ?",
               [duree]+autres_dur[:3], duree,
               f"La {proc} a une durée de {duree}, sous {autorite}.")
        if r: results.append(r)

        r = q(M,C,"Difficile",f"Sous quelle autorité se déroule la procédure de {proc} ?",
               [autorite]+autres_aut[:3], autorite,
               f"La {proc} se déroule sous {autorite} ({duree}).")
        if r: results.append(r)

    log.info(f"  Police templates directs: {len(results)}")

    # ── 3. Combinatoire grades ────────────────────────────────────────────────
    def _pol_q1():
        entry = random.choice(GRADES_PN)
        grade, cat, def_grade, info_grade = entry
        autres_g2 = [g for g,c,d,i in GRADES_PN if g != grade]
        if len(autres_g2) < 3: return None
        distr = random.sample(autres_g2, 3)
        all4 = sorted([grade]+distr)
        noms = ", ".join(all4[:-1]) + " ou " + all4[-1]
        text = f"Parmi ces grades, lequel est de {cat} dans la Police nationale : {noms} ?"
        return q(M,C,"Difficile",text, all4, grade,
                 f"Le {grade} appartient à {cat}.")

    _fill(results, 200000, _pol_q1)

    def _pol_q2():
        entry = random.choice(PROCEDURES_POLICE)
        proc, def_proc, duree, autorite = entry
        autres_proc2 = [p for p,d,du,a in PROCEDURES_POLICE if p != proc]
        if len(autres_proc2) < 3: return None
        distr = random.sample(autres_proc2, 3)
        all4 = sorted([proc]+distr)
        noms = ", ".join(all4[:-1]) + " ou " + all4[-1]
        text = f"Quelle procédure a pour définition '{def_proc}' : {noms} ?"
        return q(M,C,"Difficile",text, all4, proc,
                 f"La {proc} est définie comme : {def_proc} ({duree}).")

    _fill(results, 400000, _pol_q2)

    # ── 4. Questions génériques police enrichies ───────────────────────────────
    extra_pol = [
        ("Facile","Quel est le numéro d'urgence de la police en France ?","17",
         ["17","15","18","112"],"Le 17 est le numéro d'urgence de la Police nationale."),
        ("Facile","Sous quelle autorité est placée la Police nationale ?","le ministre de l'Intérieur",
         ["le ministre de l'Intérieur","le Premier ministre","le Président","le ministre de la Justice"],
         "La Police nationale est placée sous l'autorité du ministre de l'Intérieur."),
        ("Difficile","En quelle année la Police nationale a-t-elle été créée ?","1966",
         ["1966","1945","1900","1848"],"La Police nationale a été créée par la réforme Fouchet de 1966."),
        ("Moyenne","Que signifie OPJ ?","Officier de Police Judiciaire",
         ["Officier de Police Judiciaire","Opération Policière Judiciaire","Officier Public Judiciaire","Officier Principal de Justice"],
         "OPJ signifie Officier de Police Judiciaire, habilité à diriger les enquêtes."),
        ("Moyenne","Que signifie APJ ?","Agent de Police Judiciaire",
         ["Agent de Police Judiciaire","Adjoint de Police Judiciaire","Agent Public Judiciaire","Aide Policière Judiciaire"],
         "APJ signifie Agent de Police Judiciaire."),
        ("Difficile","Quel code régit les pouvoirs de police judiciaire en France ?","le Code de procédure pénale",
         ["le Code de procédure pénale","le Code pénal","le Code civil","le Code de la sécurité intérieure"],
         "Les pouvoirs de police judiciaire sont définis par le Code de procédure pénale (CPP)."),
        ("Moyenne","Qu'est-ce que l'IGPN ?","l'Inspection générale de la Police nationale",
         ["l'Inspection générale de la Police nationale","l'Institut de gestion de la Police nationale","l'Inspection générale des parquets","l'Inspection générale de la préfecture"],
         "L'IGPN est la 'police des polices', chargée du contrôle interne."),
        ("Difficile","Quelle est la durée maximale d'une garde à vue de droit commun ?","48 heures",
         ["48 heures","24 heures","72 heures","96 heures"],
         "La garde à vue de droit commun est limitée à 48 heures (24h renouvelables par le parquet)."),
        ("Difficile","Dans quelles heures peut-on effectuer une perquisition hors flagrance ?","entre 6h et 21h",
         ["entre 6h et 21h","entre 8h et 20h","à toute heure","entre 7h et 22h"],
         "Une perquisition ne peut avoir lieu entre 21h et 6h sauf flagrance ou autorisation spéciale."),
    ]
    for diff, q_txt, a, opts, expl in extra_pol:
        r = q(M,C,diff,q_txt,opts,a,expl)
        if r: results.append(r)

    def _pol_q3():
        entry = random.choice(PROCEDURES_POLICE)
        proc, def_proc, duree, autorite = entry
        autres_aut2 = [a for p,d,du,a in PROCEDURES_POLICE if a != autorite]
        if len(autres_aut2) < 3: return None
        distr = random.sample(autres_aut2, 3)
        all4 = sorted([autorite]+distr)
        noms = ", ".join(all4[:-1]) + " ou " + all4[-1]
        text = f"La procédure de {proc} se déroule sous quelle autorité : {noms} ?"
        return q(M,C,"Difficile",text, all4, autorite,
                 f"La {proc} est sous {autorite} ({duree}).")

    _fill(results, 600000, _pol_q3)
    _fill(results, TARGET_CAT, _pol_q1, max_factor=6)
    log.info(f"  Police TOTAL: {len(results)}")
    return results


# ═══════════════════════════════════════════════════════════════════════════════
# GÉNÉRATEUR DROIT  (~750K questions)
# ═══════════════════════════════════════════════════════════════════════════════
def gen_droit():
    results = []
    M, C = "Culture générale", "Droit"

    # ── 1. Infractions pénales ─────────────────────────────────────────────────
    for infraction, def_inf, qual, peine in INFRACTIONS_PENALES:
        autres_def = [d for i,d,q2,p in INFRACTIONS_PENALES if d != def_inf]
        autres_inf = [i for i,d,q2,p in INFRACTIONS_PENALES if i != infraction]
        autres_q = [q2 for i,d,q2,p in INFRACTIONS_PENALES if q2 != qual]
        autres_p = [p for i,d,q2,p in INFRACTIONS_PENALES if p != peine]
        random.shuffle(autres_def); random.shuffle(autres_inf)
        random.shuffle(autres_q); random.shuffle(autres_p)

        r = q(M,C,"Facile",f"Comment définit-on {infraction} en droit pénal ?",
               [def_inf]+autres_def[:3], def_inf,
               f"{infraction.capitalize()} : {def_inf} (qualification : {qual}).")
        if r: results.append(r)

        r = q(M,C,"Moyenne",f"Quelle est la qualification pénale de {infraction} ?",
               [qual]+autres_q[:3], qual,
               f"{infraction.capitalize()} est qualifié de {qual}, puni de {peine}.")
        if r: results.append(r)

        r = q(M,C,"Difficile",f"Quelle est la peine prévue pour {infraction} ?",
               [peine]+autres_p[:3], peine,
               f"{infraction.capitalize()} est puni de {peine}.")
        if r: results.append(r)

        r = q(M,C,"Difficile",f"Quelle infraction correspond à : {def_inf} ?",
               [infraction]+autres_inf[:3], infraction,
               f"Cette définition correspond à {infraction} ({qual}).")
        if r: results.append(r)

    # ── 2. Articles juridiques ─────────────────────────────────────────────────
    for article, sujet_art, contenu in ARTICLES_DROIT:
        autres_s = [s for a,s,c in ARTICLES_DROIT if s != sujet_art]
        autres_a = [a for a,s,c in ARTICLES_DROIT if a != article]
        autres_c = [c for a,s,c in ARTICLES_DROIT if c != contenu]
        random.shuffle(autres_s); random.shuffle(autres_a); random.shuffle(autres_c)

        r = q(M,C,"Difficile",f"Quel est l'objet de l'{article} ?",
               [sujet_art]+autres_s[:3], sujet_art,
               f"L'{article} traite de {sujet_art} : {contenu}.")
        if r: results.append(r)

        r = q(M,C,"Difficile",f"Quel article juridique traite de {sujet_art} ?",
               [article]+autres_a[:3], article,
               f"C'est l'{article} qui régit {sujet_art} ({contenu}).")
        if r: results.append(r)

    log.info(f"  Droit templates directs: {len(results)}")

    # ── 3. Combinatoire infractions ────────────────────────────────────────────
    def _dro_q1():
        entry = random.choice(INFRACTIONS_PENALES)
        infraction, def_inf, qual, peine = entry
        autres_inf2 = [i for i,d,q2,p in INFRACTIONS_PENALES if i != infraction]
        if len(autres_inf2) < 3: return None
        distr = random.sample(autres_inf2, 3)
        all4 = sorted([infraction]+distr)
        noms = ", ".join(all4[:-1]) + " ou " + all4[-1]
        text = f"Quelle infraction est qualifiée de {qual} parmi : {noms} ?"
        return q(M,C,"Difficile",text, all4, infraction,
                 f"{infraction.capitalize()} est qualifié de {qual}.")

    _fill(results, 200000, _dro_q1)

    def _dro_q2():
        entry = random.choice(INFRACTIONS_PENALES)
        infraction, def_inf, qual, peine = entry
        autres_p2 = [p for i,d,q2,p in INFRACTIONS_PENALES if p != peine]
        if len(autres_p2) < 3: return None
        distr = random.sample(autres_p2, 3)
        all4 = sorted([peine]+distr)
        noms = ", ".join(all4[:-1]) + " ou " + all4[-1]
        text = f"Quelle peine est prévue pour {infraction} parmi : {noms} ?"
        return q(M,C,"Difficile",text, all4, peine,
                 f"{infraction.capitalize()} est puni de {peine}.")

    _fill(results, 400000, _dro_q2)

    def _dro_q3():
        entry = random.choice(ARTICLES_DROIT)
        article, sujet_art, contenu = entry
        autres_c2 = [c for a,s,c in ARTICLES_DROIT if c != contenu]
        if len(autres_c2) < 3: return None
        distr = random.sample(autres_c2, 3)
        all4 = sorted([contenu]+distr)
        noms = ", ".join(all4[:-1]) + " ou " + all4[-1]
        text = f"Quel est le contenu de l'{article} ({sujet_art}) parmi : {noms} ?"
        return q(M,C,"Difficile",text, all4, contenu,
                 f"L'{article} ({sujet_art}) dispose : {contenu}.")

    _fill(results, 600000, _dro_q3)
    _fill(results, TARGET_CAT, _dro_q1, max_factor=5)
    log.info(f"  Droit TOTAL: {len(results)}")
    return results


# ═══════════════════════════════════════════════════════════════════════════════
# GÉNÉRATEUR SPORT  (~750K questions)
# ═══════════════════════════════════════════════════════════════════════════════
def gen_sport():
    results = []
    M, C = "Culture générale", "Sport"

    # ── 1. Sports – templates directs ─────────────────────────────────────────
    for sport, categorie, nb_j, jo in SPORTS_DATA:
        autres_c = [c for s,c,n,j in SPORTS_DATA if c != categorie]
        autres_s = [s for s,c,n,j in SPORTS_DATA if s != sport]
        random.shuffle(autres_c); random.shuffle(autres_s)

        r = q(M,C,"Facile",f"À quelle catégorie appartient le {sport} ?",
               [categorie]+autres_c[:3], categorie,
               f"Le {sport} est un {categorie}.")
        if r: results.append(r)

        r = q(M,C,"Moyenne",f"Le {sport} est-il aux Jeux olympiques ?",
               [jo,"Oui" if jo=="Non" else "Non","Peut-être","Anciennement"], jo,
               f"Le {sport} : présence aux JO = {jo}.")
        if r: results.append(r)

    # ── 2. Athlètes ───────────────────────────────────────────────────────────
    for athlete, nat_at, sport_at, record_at in ATHLETES:
        autres_n = [n for a,n,s,r in ATHLETES if n != nat_at]
        autres_a = [a for a,n,s,r in ATHLETES if a != athlete]
        autres_r = [r for a,n,s,r in ATHLETES if r != record_at]
        autres_sp = [s for a,n,s,r in ATHLETES if s != sport_at]
        random.shuffle(autres_n); random.shuffle(autres_a)
        random.shuffle(autres_r); random.shuffle(autres_sp)

        r = q(M,C,"Facile",f"Quelle est la nationalité de {athlete} ?",
               [nat_at]+autres_n[:3], nat_at,
               f"{athlete} est {nat_at}, célèbre en {sport_at}.")
        if r: results.append(r)

        r = q(M,C,"Facile",f"Dans quel sport {athlete} s'est-il/elle illustré(e) ?",
               [sport_at]+autres_sp[:3], sport_at,
               f"{athlete} ({nat_at}) est une légende du {sport_at}.")
        if r: results.append(r)

        r = q(M,C,"Difficile",f"Quel athlète est connu pour : {record_at} ?",
               [athlete]+autres_a[:3], athlete,
               f"C'est {athlete} ({nat_at}, {sport_at}) qui est connu pour {record_at}.")
        if r: results.append(r)

    log.info(f"  Sport templates directs: {len(results)}")

    # ── 3. Combinatoire sports ────────────────────────────────────────────────
    def _spt_q1():
        entry = random.choice(ATHLETES)
        athlete, nat_at, sport_at, record_at = entry
        autres_n2 = [n for a,n,s,r in ATHLETES if n != nat_at]
        if len(autres_n2) < 3: return None
        distr = random.sample(autres_n2, 3)
        all4 = sorted([nat_at]+distr)
        noms = ", ".join(all4[:-1]) + " ou " + all4[-1]
        text = f"Quelle est la nationalité de {athlete} (connu pour {record_at[:30]}) : {noms} ?"
        return q(M,C,"Difficile",text, all4, nat_at,
                 f"{athlete} est {nat_at}, célèbre en {sport_at}.")

    _fill(results, 200000, _spt_q1)

    def _spt_q2():
        entry = random.choice(ATHLETES)
        athlete, nat_at, sport_at, record_at = entry
        autres_at2 = [a for a,n,s,r in ATHLETES if a != athlete]
        if len(autres_at2) < 3: return None
        distr = random.sample(autres_at2, 3)
        all4 = sorted([athlete]+distr)
        noms = ", ".join(all4[:-1]) + " ou " + all4[-1]
        text = f"Quel athlète est {nat_at} et pratique {sport_at} parmi : {noms} ?"
        return q(M,C,"Facile",text, all4, athlete,
                 f"{athlete} ({nat_at}) est une légende du {sport_at}.")

    _fill(results, 400000, _spt_q2)

    def _spt_q3():
        entry = random.choice(ATHLETES)
        athlete, nat_at, sport_at, record_at = entry
        autres_sp2 = [s for a,n,s,r in ATHLETES if s != sport_at]
        if len(autres_sp2) < 3: return None
        distr = random.sample(autres_sp2, 3)
        all4 = sorted([sport_at]+distr)
        noms = ", ".join(all4[:-1]) + " ou " + all4[-1]
        text = f"Dans quel sport {athlete} ({nat_at}) s'est-il illustré : {noms} ?"
        return q(M,C,"Facile",text, all4, sport_at,
                 f"{athlete} ({nat_at}) est connu en {sport_at} ({record_at}).")

    _fill(results, 600000, _spt_q3)

    def _spt_q4():
        sample4 = random.sample(ATHLETES, 4)
        country_counts = {}
        for a,n,s,r in sample4:
            country_counts[n] = country_counts.get(n, 0) + 1
        # Pick one athlete
        entry = sample4[0]
        athlete, nat_at, sport_at, record_at = entry
        autres_sp3 = [s for a,n,s,r in SPORTS_DATA if s != sport_at]
        if len(autres_sp3) < 3: return None
        distr = random.sample(autres_sp3, 3)
        all4 = sorted([sport_at]+distr)
        noms = ", ".join(all4[:-1]) + " ou " + all4[-1]
        text = f"Dans quel sport est connu {athlete} ({nat_at}, {record_at[:25]}) : {noms} ?"
        return q(M,C,"Difficile",text, all4, sport_at,
                 f"{athlete} est célèbre en {sport_at}.")

    _fill(results, TARGET_CAT, _spt_q4, max_factor=5)
    log.info(f"  Sport TOTAL: {len(results)}")
    return results


# ═══════════════════════════════════════════════════════════════════════════════
# INSERTION SUPABASE (async, batchs concurrents)
# ═══════════════════════════════════════════════════════════════════════════════

async def insert_batch(session: aiohttp.ClientSession, batch: list, sem: asyncio.Semaphore) -> int:
    """Insère un batch avec retry + backoff exponentiel."""
    url = f"{SUPABASE_URL}/rest/v1/quiz_questions"
    payload = json.dumps(batch, ensure_ascii=False)
    max_retries = 5
    for attempt in range(max_retries):
        async with sem:
            try:
                async with session.post(
                    url, data=payload, headers=HEADERS,
                    timeout=aiohttp.ClientTimeout(total=45)
                ) as r:
                    if r.status in (200, 201):
                        return len(batch)
                    txt = await r.text()
                    # Timeout ou surcharge → on retry
                    if r.status == 500 and ("57014" in txt or "timeout" in txt.lower()):
                        wait = 2 ** attempt + random.uniform(0.5, 1.5)
                        log.warning(f"  ⚠ Timeout batch ({attempt+1}/{max_retries}), retry dans {wait:.1f}s…")
                        await asyncio.sleep(wait)
                        continue
                    log.error(f"  ✗ HTTP {r.status}: {txt[:120]}")
                    return 0
            except asyncio.TimeoutError:
                wait = 2 ** attempt + random.uniform(0.5, 1.5)
                log.warning(f"  ⚠ ClientTimeout ({attempt+1}/{max_retries}), retry dans {wait:.1f}s…")
                await asyncio.sleep(wait)
            except Exception as e:
                log.error(f"  ✗ Exception: {e}")
                return 0
    # Dernier recours : mini-batches de 20
    log.warning(f"  ⚠ Batch de {len(batch)} échoué, découpage en mini-batches de 20…")
    inserted = 0
    for mini_start in range(0, len(batch), 20):
        mini = batch[mini_start:mini_start+20]
        mini_payload = json.dumps(mini, ensure_ascii=False)
        try:
            async with sem:
                async with session.post(
                    url, data=mini_payload, headers=HEADERS,
                    timeout=aiohttp.ClientTimeout(total=30)
                ) as r:
                    if r.status in (200, 201):
                        inserted += len(mini)
                    else:
                        txt = await r.text()
                        log.error(f"  ✗ Mini-batch HTTP {r.status}: {txt[:80]}")
        except Exception as e:
            log.error(f"  ✗ Mini-batch Exception: {e}")
        await asyncio.sleep(0.3)
    return inserted


async def insert_category(questions: list, cat_name: str) -> int:
    sem = asyncio.Semaphore(MAX_CONC)
    total = 0
    tasks = []
    flush_every = MAX_CONC * 3   # 9 batches en vol max

    async with aiohttp.ClientSession() as session:
        for i in range(0, len(questions), BATCH_SIZE):
            batch = questions[i:i+BATCH_SIZE]
            tasks.append(insert_batch(session, batch, sem))

            if len(tasks) >= flush_every:
                results_ins = await asyncio.gather(*tasks)
                total += sum(results_ins)
                tasks = []
                log.info(f"    [{cat_name}] {total}/{len(questions)} insérées…")
                await asyncio.sleep(0.5)  # respiration entre les vagues

        if tasks:
            results_ins = await asyncio.gather(*tasks)
            total += sum(results_ins)

    return total


async def load_existing_hashes(session: aiohttp.ClientSession):
    """Charge les hashes des questions existantes pour éviter les doublons."""
    global _SEEN
    log.info("Chargement des hashes existants depuis Supabase…")
    base_url = f"{SUPABASE_URL}/rest/v1/quiz_questions?select=question"
    offset = 0
    page_size = 500   # petit pour éviter les timeouts
    total_loaded = 0

    while True:
        r_url = f"{base_url}&limit={page_size}&offset={offset}"
        success = False
        for attempt in range(4):
            try:
                async with session.get(
                    r_url, headers=HEADERS,
                    timeout=aiohttp.ClientTimeout(total=20)
                ) as r:
                    if r.status != 200:
                        log.warning(f"  Chargement existants HTTP {r.status} (offset={offset}), retry…")
                        await asyncio.sleep(2 ** attempt)
                        continue
                    data = await r.json()
                    for row in data:
                        text = row.get("question")
                        if text:
                            _SEEN.add(_hash(text))
                    total_loaded += len(data)
                    offset += len(data)
                    success = True
                    if len(data) < page_size:
                        log.info(f"  → {total_loaded} questions existantes chargées (dédup set: {len(_SEEN):,}).")
                        return
                    break
            except Exception as e:
                log.warning(f"  Exception chargement existants (offset={offset}): {e}, retry…")
                await asyncio.sleep(2 ** attempt)

        if not success:
            log.warning(f"  Abandon chargement à offset={offset} après 4 tentatives — {total_loaded} chargées.")
            break

        if total_loaded % 50_000 == 0:
            log.info(f"  {total_loaded} questions existantes chargées… (dédup: {len(_SEEN):,})")
        await asyncio.sleep(0.1)   # petite pause entre pages

    log.info(f"  → {total_loaded} questions existantes chargées (dédup set: {len(_SEEN):,}).")


# ═══════════════════════════════════════════════════════════════════════════════
# MAIN
# ═══════════════════════════════════════════════════════════════════════════════

async def main():
    log.info("=" * 70)
    log.info(f"CoPiQ Générateur v5 — 10 000 000 questions — {datetime.now()}")
    log.info("=" * 70)

    # Charger les questions existantes
    async with aiohttp.ClientSession() as session:
        await load_existing_hashes(session)

    log.info(f"Set de dédup initialisé : {len(_SEEN):,} hashes existants.")
    log.info("")

    generators = [
        ("Geographie",   gen_geographie),
        ("Histoire",     gen_histoire),
        ("Sciences",     gen_sciences),
        ("Sante",        gen_sante),
        ("Cinema",       gen_cinema),
        ("Musique",      gen_musique),
        ("Mythologie",   gen_mythologie),
        ("Securite",     gen_securite),
        ("Institutions", gen_institutions),
        ("Actualite",    gen_actualite),
        ("France",       gen_france),
        ("Police",       gen_police),
        ("Droit",        gen_droit),
        ("Sport",        gen_sport),
    ]

    grand_total = 0
    for cat_name, gen_fn in generators:
        log.info(f"{'─'*60}")
        log.info(f"⚙  Génération : {cat_name}  (cible {TARGET_CAT:,})")
        t0 = datetime.now()

        questions = gen_fn()
        random.shuffle(questions)
        n_gen = len(questions)
        log.info(f"  Générées : {n_gen:,} questions uniques")

        t1 = datetime.now()
        log.info(f"  Insertion dans Supabase…")
        n_ins = await insert_category(questions, cat_name)
        t2 = datetime.now()

        grand_total += n_ins
        log.info(f"  ✅ {n_ins:,} questions insérées en {(t2-t1).seconds}s")
        log.info(f"  Génération: {(t1-t0).seconds}s  |  Total cumulé: {grand_total:,}")

        # Libérer la mémoire
        del questions

    log.info("=" * 70)
    log.info(f"✅  TERMINÉ — {grand_total:,} questions insérées au total")
    log.info(f"   Taille du set de dédup final: {len(_SEEN):,}")
    log.info("=" * 70)


if __name__ == "__main__":
    asyncio.run(main())
