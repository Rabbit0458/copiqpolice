"""
CoPiQ — Générateur de questions UNIQUE (v4)
- Catégories exactes correspondant aux _categoryNameDb Flutter
- Zéro doublon dans les textes de questions
- Templates × données = combinatoire réelle
"""

import asyncio
import aiohttp
import json
import random
import hashlib
import logging
from datetime import datetime

logging.basicConfig(level=logging.INFO, format='%(asctime)s | %(levelname)s | %(message)s')
log = logging.getLogger(__name__)

SUPABASE_URL = "https://nuoonagnkhbeeymtvrcn.supabase.co"
SUPABASE_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im51b29uYWdua2hiZWV5bXR2cmNuIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc1NjA2MTQ0NSwiZXhwIjoyMDcxNjM3NDQ1fQ.m601M1RYcIwZYGW95jRr1TTawZ3W3W5TZM5GiFI0uh4"
HEADERS = {"apikey": SUPABASE_KEY, "Authorization": f"Bearer {SUPABASE_KEY}", "Content-Type": "application/json", "Prefer": "return=minimal"}
BATCH_SIZE = 200

# ─────────────────────────────────────────────────────────────
# DONNÉES
# ─────────────────────────────────────────────────────────────

PAYS_CAPITALES = [
    ("France","Paris"),("Allemagne","Berlin"),("Espagne","Madrid"),("Italie","Rome"),
    ("Portugal","Lisbonne"),("Belgique","Bruxelles"),("Pays-Bas","Amsterdam"),
    ("Suisse","Berne"),("Autriche","Vienne"),("Pologne","Varsovie"),
    ("Suède","Stockholm"),("Norvège","Oslo"),("Danemark","Copenhague"),
    ("Finlande","Helsinki"),("Grèce","Athènes"),("Turquie","Ankara"),
    ("Russie","Moscou"),("Ukraine","Kiev"),("Roumanie","Bucarest"),
    ("Hongrie","Budapest"),("République tchèque","Prague"),("Slovaquie","Bratislava"),
    ("Croatie","Zagreb"),("Serbie","Belgrade"),("Bulgarie","Sofia"),
    ("Albanie","Tirana"),("Macédoine du Nord","Skopje"),("Bosnie","Sarajevo"),
    ("Monténégro","Podgorica"),("Kosovo","Pristina"),("Slovénie","Ljubljana"),
    ("Irlande","Dublin"),("Royaume-Uni","Londres"),("Écosse","Édimbourg"),
    ("États-Unis","Washington D.C."),("Canada","Ottawa"),("Mexique","Mexico"),
    ("Brésil","Brasilia"),("Argentine","Buenos Aires"),("Chili","Santiago"),
    ("Colombie","Bogotá"),("Pérou","Lima"),("Venezuela","Caracas"),
    ("Équateur","Quito"),("Bolivie","Sucre"),("Paraguay","Asunción"),
    ("Uruguay","Montevideo"),("Cuba","La Havane"),("Haïti","Port-au-Prince"),
    ("Jamaïque","Kingston"),("Chine","Pékin"),("Japon","Tokyo"),
    ("Corée du Sud","Séoul"),("Corée du Nord","Pyongyang"),("Inde","New Delhi"),
    ("Pakistan","Islamabad"),("Bangladesh","Dhaka"),("Sri Lanka","Colombo"),
    ("Thaïlande","Bangkok"),("Vietnam","Hanoï"),("Indonésie","Jakarta"),
    ("Philippines","Manille"),("Malaisie","Kuala Lumpur"),("Singapour","Singapour"),
    ("Australie","Canberra"),("Nouvelle-Zélande","Wellington"),("Égypte","Le Caire"),
    ("Maroc","Rabat"),("Algérie","Alger"),("Tunisie","Tunis"),("Libye","Tripoli"),
    ("Sénégal","Dakar"),("Mali","Bamako"),("Côte d'Ivoire","Yamoussoukro"),
    ("Ghana","Accra"),("Nigeria","Abuja"),("Cameroun","Yaoundé"),
    ("Congo","Brazzaville"),("Kenya","Nairobi"),("Éthiopie","Addis-Abeba"),
    ("Afrique du Sud","Pretoria"),("Zimbabwe","Harare"),("Mozambique","Maputo"),
    ("Madagascar","Antananarivo"),("Tanzanie","Dodoma"),("Ouganda","Kampala"),
    ("Arabie Saoudite","Riyad"),("Émirats arabes unis","Abou Dhabi"),
    ("Israël","Jérusalem"),("Iran","Téhéran"),("Irak","Bagdad"),
    ("Syrie","Damas"),("Jordanie","Amman"),("Liban","Beyrouth"),
    ("Afghanistan","Kaboul"),("Kazakhstan","Astana"),("Ouzbékistan","Tachkent"),
]

DEPARTEMENTS = [
    ("Ain","01","Bourg-en-Bresse"),("Aisne","02","Laon"),("Allier","03","Moulins"),
    ("Alpes-de-Haute-Provence","04","Digne-les-Bains"),("Hautes-Alpes","05","Gap"),
    ("Alpes-Maritimes","06","Nice"),("Ardèche","07","Privas"),("Ardennes","08","Charleville-Mézières"),
    ("Ariège","09","Foix"),("Aube","10","Troyes"),("Aude","11","Carcassonne"),
    ("Aveyron","12","Rodez"),("Bouches-du-Rhône","13","Marseille"),("Calvados","14","Caen"),
    ("Cantal","15","Aurillac"),("Charente","16","Angoulême"),("Charente-Maritime","17","La Rochelle"),
    ("Cher","18","Bourges"),("Corrèze","19","Tulle"),("Côte-d'Or","21","Dijon"),
    ("Côtes-d'Armor","22","Saint-Brieuc"),("Creuse","23","Guéret"),("Dordogne","24","Périgueux"),
    ("Doubs","25","Besançon"),("Drôme","26","Valence"),("Eure","27","Évreux"),
    ("Eure-et-Loir","28","Chartres"),("Finistère","29","Quimper"),("Gard","30","Nîmes"),
    ("Haute-Garonne","31","Toulouse"),("Gers","32","Auch"),("Gironde","33","Bordeaux"),
    ("Hérault","34","Montpellier"),("Ille-et-Vilaine","35","Rennes"),("Indre","36","Châteauroux"),
    ("Indre-et-Loire","37","Tours"),("Isère","38","Grenoble"),("Jura","39","Lons-le-Saunier"),
    ("Landes","40","Mont-de-Marsan"),("Loir-et-Cher","41","Blois"),("Loire","42","Saint-Étienne"),
    ("Haute-Loire","43","Le Puy-en-Velay"),("Loire-Atlantique","44","Nantes"),("Loiret","45","Orléans"),
    ("Lot","46","Cahors"),("Lot-et-Garonne","47","Agen"),("Lozère","48","Mende"),
    ("Maine-et-Loire","49","Angers"),("Manche","50","Saint-Lô"),("Marne","51","Châlons-en-Champagne"),
    ("Haute-Marne","52","Chaumont"),("Mayenne","53","Laval"),("Meurthe-et-Moselle","54","Nancy"),
    ("Meuse","55","Bar-le-Duc"),("Morbihan","56","Vannes"),("Moselle","57","Metz"),
    ("Nièvre","58","Nevers"),("Nord","59","Lille"),("Oise","60","Beauvais"),
    ("Orne","61","Alençon"),("Pas-de-Calais","62","Arras"),("Puy-de-Dôme","63","Clermont-Ferrand"),
    ("Pyrénées-Atlantiques","64","Pau"),("Hautes-Pyrénées","65","Tarbes"),
    ("Pyrénées-Orientales","66","Perpignan"),("Bas-Rhin","67","Strasbourg"),
    ("Haut-Rhin","68","Colmar"),("Rhône","69","Lyon"),("Haute-Saône","70","Vesoul"),
    ("Saône-et-Loire","71","Mâcon"),("Sarthe","72","Le Mans"),("Savoie","73","Chambéry"),
    ("Haute-Savoie","74","Annecy"),("Paris","75","Paris"),("Seine-Maritime","76","Rouen"),
    ("Seine-et-Marne","77","Melun"),("Yvelines","78","Versailles"),("Deux-Sèvres","79","Niort"),
    ("Somme","80","Amiens"),("Tarn","81","Albi"),("Tarn-et-Garonne","82","Montauban"),
    ("Var","83","Toulon"),("Vaucluse","84","Avignon"),("Vendée","85","La Roche-sur-Yon"),
    ("Vienne","86","Poitiers"),("Haute-Vienne","87","Limoges"),("Vosges","88","Épinal"),
    ("Yonne","89","Auxerre"),("Territoire de Belfort","90","Belfort"),
    ("Essonne","91","Évry-Courcouronnes"),("Hauts-de-Seine","92","Nanterre"),
    ("Seine-Saint-Denis","93","Bobigny"),("Val-de-Marne","94","Créteil"),
    ("Val-d'Oise","95","Cergy"),
]

ELEMENTS_CHIMIQUES = [
    ("Hydrogène","H","1"),("Hélium","He","2"),("Lithium","Li","3"),("Béryllium","Be","4"),
    ("Bore","B","5"),("Carbone","C","6"),("Azote","N","7"),("Oxygène","O","8"),
    ("Fluor","F","9"),("Néon","Ne","10"),("Sodium","Na","11"),("Magnésium","Mg","12"),
    ("Aluminium","Al","13"),("Silicium","Si","14"),("Phosphore","P","15"),("Soufre","S","16"),
    ("Chlore","Cl","17"),("Argon","Ar","18"),("Potassium","K","19"),("Calcium","Ca","20"),
    ("Fer","Fe","26"),("Cuivre","Cu","29"),("Zinc","Zn","30"),("Argent","Ag","47"),
    ("Étain","Sn","50"),("Or","Au","79"),("Mercure","Hg","80"),("Plomb","Pb","82"),
    ("Uranium","U","92"),("Plutonium","Pu","94"),
]

PRESIDENTS_FRANCE = [
    ("Charles de Gaulle","1959","1969","RPF/UNR"),
    ("Georges Pompidou","1969","1974","UDR"),
    ("Valéry Giscard d'Estaing","1974","1981","UDF"),
    ("François Mitterrand","1981","1995","PS"),
    ("Jacques Chirac","1995","2007","RPR/UMP"),
    ("Nicolas Sarkozy","2007","2012","UMP"),
    ("François Hollande","2012","2017","PS"),
    ("Emmanuel Macron","2017","2027","LREM/Renaissance"),
]

SPORTS_OLYMPIQUES = [
    ("100 mètres","athlétisme","sprint"),
    ("marathon","athlétisme","endurance"),
    ("natation","aquatique","nage libre"),
    ("cyclisme sur piste","cyclisme","vitesse"),
    ("judo","arts martiaux","combat"),
    ("lutte","arts martiaux","grappling"),
    ("boxe","combat","pugilat"),
    ("escrime","armes","duel"),
    ("aviron","aquatique","rame"),
    ("tir à l'arc","précision","tir"),
    ("gymnasique artistique","gym","acrobatie"),
    ("haltérophilie","force","haltères"),
    ("volleyball","collectif","ballon"),
    ("basket-ball","collectif","panier"),
    ("handball","collectif","but"),
    ("water-polo","aquatique","ballon"),
    ("tennis de table","raquette","ping-pong"),
    ("badminton","raquette","volant"),
    ("tennis","raquette","court"),
    ("hockey sur gazon","collectif","crosse"),
]

DIEUX_GRECS = [
    ("Zeus","roi des dieux","le tonnerre"),
    ("Héra","déesse du mariage","le paon"),
    ("Poséidon","dieu des mers","le trident"),
    ("Déméter","déesse des moissons","les épis de blé"),
    ("Athéna","déesse de la sagesse","la chouette"),
    ("Apollon","dieu du soleil","la lyre"),
    ("Artémis","déesse de la chasse","l'arc et les flèches"),
    ("Arès","dieu de la guerre","l'épée"),
    ("Aphrodite","déesse de l'amour","la rose"),
    ("Héphaïstos","dieu du feu","l'enclume"),
    ("Hermès","messager des dieux","le caducée"),
    ("Dionysos","dieu du vin","la vigne"),
    ("Hestia","déesse du foyer","la flamme"),
    ("Hades","dieu des Enfers","le casque d'invisibilité"),
    ("Perséphone","reine des Enfers","la grenade"),
    ("Éros","dieu de l'amour","l'arc doré"),
    ("Hypos","dieu du sommeil","les coquelicots"),
    ("Niké","déesse de la victoire","les ailes"),
    ("Tyché","déesse de la fortune","la roue"),
    ("Pan","dieu des bergers","la flûte"),
]

DIEUX_ROMAINS = [
    ("Jupiter","roi des dieux"),("Junon","reine des dieux"),("Neptune","dieu des mers"),
    ("Cérès","déesse des moissons"),("Minerve","déesse de la sagesse"),
    ("Mars","dieu de la guerre"),("Vénus","déesse de l'amour"),
    ("Vulcain","dieu du feu"),("Mercure","messager des dieux"),
    ("Bacchus","dieu du vin"),("Diane","déesse de la chasse"),
    ("Pluton","dieu des Enfers"),("Saturne","dieu du temps"),
]

PANNEAUX_ROUTIERS = [
    ("triangle rouge bordure","danger","signalisation de danger"),
    ("cercle rouge bordure","interdiction","signalisation d'interdiction"),
    ("cercle bleu","obligation","signalisation obligatoire"),
    ("panneau carré bleu","information","signalisation d'information"),
    ("flèche blanche sur fond bleu","direction","indication de direction"),
    ("croix rouge sur fond blanc","fin d'interdiction","levée d'interdiction"),
    ("panneau octogonal rouge","STOP","arrêt obligatoire"),
    ("triangle inversé rouge","CÉDEZ LE PASSAGE","priorité à droite"),
]

LOIS_FRANCE = [
    ("loi de 1905","séparation de l'Église et de l'État","laïcité"),
    ("loi du 29 juillet 1881","liberté de la presse","presse"),
    ("loi Badinter de 1981","abolition de la peine de mort","justice"),
    ("loi Veil de 1975","interruption volontaire de grossesse","santé"),
    ("loi du 13 juillet 1983","droits et obligations des fonctionnaires","fonction publique"),
    ("loi INFORMATIQUE ET LIBERTÉS de 1978","protection des données personnelles","CNIL"),
    ("loi du 10 juillet 1991","aide juridictionnelle","accès au droit"),
    ("loi Dalo de 2007","droit au logement opposable","logement"),
    ("loi Sarkozy de 2003","sécurité intérieure","police"),
    ("Code pénal de 1994","infractions et peines","droit pénal"),
]

INSTITUTIONS_UE = [
    ("Parlement européen","Strasbourg","représenter les citoyens"),
    ("Conseil de l'Union européenne","Bruxelles","représenter les États membres"),
    ("Commission européenne","Bruxelles","exécutif de l'UE"),
    ("Cour de justice de l'UE","Luxembourg","interpréter le droit européen"),
    ("Cour des comptes européenne","Luxembourg","contrôler les finances"),
    ("Banque centrale européenne","Francfort","politique monétaire"),
    ("Comité économique et social","Bruxelles","société civile"),
    ("Comité des régions","Bruxelles","autorités locales"),
    ("Médiateur européen","Strasbourg","protection des citoyens"),
]

CORPS_HUMAIN = [
    ("le foie","filtrer le sang","l'abdomen"),
    ("les poumons","respirer","la cage thoracique"),
    ("le cœur","pomper le sang","la cage thoracique"),
    ("les reins","filtrer l'urine","le bas du dos"),
    ("l'estomac","digérer les aliments","l'abdomen"),
    ("le pancréas","sécréter l'insuline","l'abdomen"),
    ("la rate","filtrer les globules rouges","l'abdomen gauche"),
    ("le cerveau","contrôler le corps","la boîte crânienne"),
    ("la moelle épinière","transmettre les nerfs","la colonne vertébrale"),
    ("le thymus","développer l'immunité","la cage thoracique"),
    ("les glandes surrénales","sécréter l'adrénaline","au-dessus des reins"),
    ("la thyroïde","réguler le métabolisme","le cou"),
    ("la vésicule biliaire","stocker la bile","l'abdomen droit"),
    ("l'appendice","rôle vestigial","l'abdomen bas droit"),
]

REALISATEURS = [
    ("Jean-Luc Godard","À bout de souffle","1960","France"),
    ("François Truffaut","Les Quatre Cents Coups","1959","France"),
    ("Claude Lelouch","Un homme et une femme","1966","France"),
    ("Louis Malle","Au revoir les enfants","1987","France"),
    ("Luc Besson","Le Grand Bleu","1988","France"),
    ("Roman Polanski","Le Pianiste","2002","Pologne"),
    ("Alfred Hitchcock","Psychose","1960","Royaume-Uni"),
    ("Steven Spielberg","Schindler's List","1993","États-Unis"),
    ("Martin Scorsese","Taxi Driver","1976","États-Unis"),
    ("Stanley Kubrick","2001 : L'Odyssée de l'espace","1968","États-Unis"),
    ("Quentin Tarantino","Pulp Fiction","1994","États-Unis"),
    ("Akira Kurosawa","Les Sept Samouraïs","1954","Japon"),
    ("Federico Fellini","La Dolce Vita","1960","Italie"),
    ("Ingmar Bergman","Le Septième Sceau","1957","Suède"),
    ("Pedro Almodóvar","Tout sur ma mère","1999","Espagne"),
]

COMPOSITEURS = [
    ("Wolfgang Amadeus Mozart","Autriche","XVIIIe siècle","La Flûte enchantée"),
    ("Ludwig van Beethoven","Allemagne","XVIIIe-XIXe siècle","La 9e Symphonie"),
    ("Johann Sebastian Bach","Allemagne","XVIIIe siècle","Les Variations Goldberg"),
    ("Frédéric Chopin","Pologne","XIXe siècle","Nocturnes"),
    ("Franz Schubert","Autriche","XIXe siècle","La Truite"),
    ("Claude Debussy","France","XIXe-XXe siècle","Clair de lune"),
    ("Maurice Ravel","France","XXe siècle","Boléro"),
    ("Hector Berlioz","France","XIXe siècle","Symphonie fantastique"),
    ("Georges Bizet","France","XIXe siècle","Carmen"),
    ("Erik Satie","France","XIXe-XXe siècle","Gymnopédies"),
    ("Franz Liszt","Hongrie","XIXe siècle","Rapsodie hongroise"),
    ("Pyotr Tchaïkovski","Russie","XIXe siècle","Le Lac des cygnes"),
    ("Richard Wagner","Allemagne","XIXe siècle","L'Anneau du Nibelung"),
    ("Giuseppe Verdi","Italie","XIXe siècle","Aïda"),
]

EVENEMENTS_HISTORIQUES = [
    ("1789","la Révolution française","France"),
    ("1804","le sacre de Napoléon","France"),
    ("1815","la défaite de Waterloo","Belgique"),
    ("1848","la Deuxième République","France"),
    ("1870","la défaite face à la Prusse","France"),
    ("1871","la Commune de Paris","France"),
    ("1905","la loi de séparation Église-État","France"),
    ("1914","le début de la Première Guerre mondiale","Europe"),
    ("1918","l'armistice de la Première Guerre mondiale","France"),
    ("1939","le début de la Seconde Guerre mondiale","Europe"),
    ("1944","le Débarquement en Normandie","France"),
    ("1945","la fin de la Seconde Guerre mondiale","Europe"),
    ("1958","la création de la Ve République","France"),
    ("1962","l'indépendance de l'Algérie","Algérie"),
    ("1968","les événements de Mai 68","France"),
    ("1981","l'abolition de la peine de mort","France"),
    ("1989","la chute du mur de Berlin","Allemagne"),
    ("1992","le traité de Maastricht","Union européenne"),
    ("2001","les attentats du 11 septembre","États-Unis"),
    ("2015","les attentats de Paris","France"),
    ("2020","la pandémie de Covid-19","Monde"),
]

STRUCTURES_POLICE = [
    ("DGPN","Direction générale de la Police nationale","coordination de la police"),
    ("DGSI","Direction générale de la Sécurité intérieure","renseignement intérieur"),
    ("SRPJ","Service régional de police judiciaire","enquêtes criminelles"),
    ("BAC","Brigade anti-criminalité","sécurité quotidienne"),
    ("BRI","Brigade de recherche et d'intervention","interventions spécialisées"),
    ("RAID","Recherche, assistance, intervention, dissuasion","unité d'élite"),
    ("OCLCO","Office central de lutte contre le crime organisé","crime organisé"),
    ("OCRTEH","Office central pour la répression de la traite des êtres humains","trafic humain"),
    ("OCLAESP","Office central de lutte contre les atteintes à l'environnement","environnement"),
    ("PTS","Police technique et scientifique","criminalistique"),
    ("SCIJ","Service central du renseignement territorial","renseignement local"),
    ("CRS","Compagnies républicaines de sécurité","maintien de l'ordre"),
    ("GIPN","Groupe d'intervention de la police nationale","interventions spéciales"),
    ("OCBC","Office central de lutte contre le trafic de biens culturels","patrimoine"),
    ("SDAT","Sous-direction anti-terroriste","terrorisme"),
]

GRADES_POLICE = [
    ("Gardien de la paix","premier grade de la police","catégorie C"),
    ("Brigadier","grade intermédiaire","catégorie C"),
    ("Brigadier-chef","grade de commandement terrain","catégorie C"),
    ("Major","officier adjoint","catégorie B"),
    ("Lieutenant","premier grade d'officier","catégorie B"),
    ("Capitaine","officier intermédiaire","catégorie B"),
    ("Commandant","officier supérieur","catégorie B"),
    ("Commissaire","grade de cadre","catégorie A"),
    ("Commissaire divisionnaire","cadre supérieur","catégorie A"),
    ("Directeur de service actif","grade le plus élevé","catégorie A"),
]

DROITS_FONDAMENTAUX = [
    ("droit à la vie","article 2 de la CEDH","protection de la vie humaine"),
    ("interdiction de la torture","article 3 de la CEDH","traitements inhumains"),
    ("droit à un procès équitable","article 6 de la CEDH","justice"),
    ("droit au respect de la vie privée","article 8 de la CEDH","vie privée"),
    ("liberté d'expression","article 10 de la CEDH","presse et opinion"),
    ("liberté de réunion","article 11 de la CEDH","manifestation"),
    ("droit à l'éducation","article 2 du protocole 1","enseignement"),
    ("droit à la propriété","article 1 du protocole 1","patrimoine"),
    ("droit de vote","article 3 du protocole 1","démocratie"),
    ("égalité devant la loi","article 14 de la CEDH","non-discrimination"),
]

INFRACTIONS = [
    ("contravention","la moins grave","amende"),
    ("délit","infraction intermédiaire","jusqu'à 10 ans de prison"),
    ("crime","la plus grave","réclusion criminelle"),
    ("récidive","infraction commise à nouveau","peines aggravées"),
    ("circonstance atténuante","réduit la peine","en faveur du prévenu"),
    ("circonstance aggravante","alourdit la peine","préméditation, vulnérabilité"),
    ("flagrant délit","infraction en cours","arrestation immédiate"),
    ("crime organisé","groupe criminel structuré","peines maximales"),
]

MONTAGNES_FRANCE = [
    ("Mont Blanc","4808","Alpes","le point culminant de France"),
    ("Barre des Écrins","4102","Alpes","massif des Écrins"),
    ("Grande Casse","3855","Alpes","plus haut sommet de Savoie hors Mont Blanc"),
    ("Mont Pelvoux","3946","Alpes","massif des Écrins"),
    ("Pic de Vignemale","3298","Pyrénées","point culminant des Pyrénées françaises"),
    ("Pic du Midi d'Ossau","2884","Pyrénées","symbole du Béarn"),
    ("Pic du Canigou","2784","Pyrénées","symbole de la Catalogne"),
    ("Puy de Dôme","1465","Massif Central","stratovolcan en Auvergne"),
    ("Plomb du Cantal","1855","Massif Central","point culminant du Cantal"),
    ("Mont Aigoual","1565","Cévennes","station météo emblématique"),
]

FLEUVES_FRANCE = [
    ("Loire","1012 km","Massif Central","Atlantique","le plus long fleuve de France"),
    ("Rhône","812 km","Alpes suisses","Méditerranée","traverse Lyon"),
    ("Seine","775 km","Bourgogne","Manche","traverse Paris"),
    ("Garonne","575 km","Espagne","Gironde","traverse Bordeaux"),
    ("Meuse","950 km","Langres","Mer du Nord","fleuve international"),
    ("Rhin","1233 km","Alpes suisses","Mer du Nord","frontière avec l'Allemagne"),
    ("Saône","480 km","Vosges","Rhône","se jette dans le Rhône à Lyon"),
]

VITAMINES = [
    ("vitamine A","la vision et la croissance","les carottes et foie"),
    ("vitamine B1","le métabolisme énergétique","les céréales complètes"),
    ("vitamine B12","la formation des globules rouges","la viande et poissons"),
    ("vitamine C","l'immunité et la cicatrisation","les agrumes"),
    ("vitamine D","l'absorption du calcium","l'exposition solaire"),
    ("vitamine E","protection des cellules","les huiles végétales"),
    ("vitamine K","la coagulation du sang","les légumes verts"),
    ("vitamine B9","la synthèse de l'ADN","les légumes verts et légumineuses"),
]

LIMITES_VITESSE = [
    ("agglomération","50 km/h","règle générale"),
    ("route hors agglomération","80 km/h","depuis 2018"),
    ("route à 2×2 voies","110 km/h","sans séparateur"),
    ("autoroute","130 km/h","temps sec"),
    ("autoroute par temps de pluie","110 km/h","visibilité réduite"),
    ("autoroute par brouillard","50 km/h","moins de 50m de visibilité"),
    ("voie verte","30 km/h","zone apaisée"),
]

PLANETES = [
    ("Mercure","88 jours","la plus proche du Soleil","0"),
    ("Vénus","225 jours","la plus chaude","0"),
    ("Terre","365 jours","la planète bleue","1"),
    ("Mars","687 jours","la planète rouge","2"),
    ("Jupiter","12 ans","la plus grande","95"),
    ("Saturne","29 ans","ses anneaux","146"),
    ("Uranus","84 ans","tourne sur le côté","27"),
    ("Neptune","165 ans","la plus éloignée","16"),
]

DROITS_AUTEUR = [
    ("durée de protection","70 ans après la mort de l'auteur","droit moral et patrimonial"),
    ("droit moral","inaliénable et imprescriptible","paternité de l'œuvre"),
    ("droit patrimonial","exploitation économique","reproduction et représentation"),
    ("domaine public","après expiration des droits","libre utilisation"),
    ("plagiat","reproduction sans autorisation","contrefaçon"),
    ("fair use","usage loyal","exceptions légales"),
]

NOTES_MUSIQUE = [
    ("do","C","grave"),("ré","D","grave-médium"),("mi","E","médium"),
    ("fa","F","médium"),("sol","G","médium-aigu"),("la","A","aigu"),("si","B","aigu"),
]

PEINES_PRINCIPALES = [
    ("emprisonnement","prison correctionnelle","délits"),
    ("réclusion criminelle","prison pour crimes","crimes"),
    ("amende","sanction pécuniaire","contraventions et délits"),
    ("travail d'intérêt général","travail non rémunéré","alternative"),
    ("peine de jours-amende","amende journalière","délits"),
    ("stage de citoyenneté","sensibilisation civique","jeunes"),
    ("confiscation","saisie de biens","complémentaire"),
    ("interdiction de territoire","expulsion","étrangers condamnés"),
]

SIGLES_POLICE = [
    ("OCLDI","Office central de lutte contre le travail illégal","travail illégal"),
    ("OCRGDF","Office central pour la répression de la grande délinquance financière","finances"),
    ("IGPN","Inspection générale de la Police nationale","contrôle interne"),
    ("OFPRA","Office français de protection des réfugiés et apatrides","asile"),
    ("FNVB","Fichier national des véhicules brûlés","automobiles"),
    ("TAJ","Traitement des antécédents judiciaires","casier judiciaire"),
    ("PNR","Passagers du Nom des Registres","aviation"),
    ("FIJAIS","Fichier judiciaire des auteurs d'infractions sexuelles","infractions sexuelles"),
]

MALADIES_PREVENTION = [
    ("diabète de type 2","hyperglycémie chronique","alimentation et exercice"),
    ("hypertension artérielle","pression sanguine élevée","sel, stress, sédentarité"),
    ("infarctus du myocarde","obstruction coronaire","tabac et cholestérol"),
    ("AVC","accident vasculaire cérébral","hypertension et tabac"),
    ("cancer du poumon","tumeur maligne","tabagisme"),
    ("obésité","IMC supérieur à 30","alimentation déséquilibrée"),
    ("dépression","trouble de l'humeur","isolement et stress"),
    ("ostéoporose","fragilité osseuse","manque de calcium"),
    ("asthme","inflammation des bronches","allergènes et pollution"),
]

GROUPES_SANGUINS = [
    ("A+","peut recevoir A+, A-, O+, O-","34% de la population"),
    ("A-","peut recevoir A-, O-","6% de la population"),
    ("B+","peut recevoir B+, B-, O+, O-","9% de la population"),
    ("B-","peut recevoir B-, O-","2% de la population"),
    ("AB+","donneur universel de plasma","3% de la population"),
    ("AB-","peut recevoir tous les groupes Rh-","1% de la population"),
    ("O+","peut recevoir O+, O-","38% de la population"),
    ("O-","donneur universel","7% de la population"),
]

ARTISTES_FRANCAIS = [
    ("Victor Hugo","écrivain","Les Misérables","XIXe siècle"),
    ("Marcel Proust","écrivain","À la recherche du temps perdu","XXe siècle"),
    ("Albert Camus","écrivain","L'Étranger","XXe siècle"),
    ("Simone de Beauvoir","philosophe","Le Deuxième Sexe","XXe siècle"),
    ("Molière","dramaturge","Le Misanthrope","XVIIe siècle"),
    ("Voltaire","philosophe","Candide","XVIIIe siècle"),
    ("Émile Zola","écrivain","Germinal","XIXe siècle"),
    ("Guy de Maupassant","écrivain","Boule de suif","XIXe siècle"),
    ("Stendhal","écrivain","Le Rouge et le Noir","XIXe siècle"),
    ("Gustave Flaubert","écrivain","Madame Bovary","XIXe siècle"),
    ("Jean Racine","dramaturge","Phèdre","XVIIe siècle"),
    ("Pierre Corneille","dramaturge","Le Cid","XVIIe siècle"),
    ("Charles Baudelaire","poète","Les Fleurs du Mal","XIXe siècle"),
    ("Arthur Rimbaud","poète","Une Saison en Enfer","XIXe siècle"),
    ("Paul Verlaine","poète","Poèmes saturniens","XIXe siècle"),
]

PEINTRES = [
    ("Claude Monet","impressionnisme","Nymphéas","France"),
    ("Pierre-Auguste Renoir","impressionnisme","Le Moulin de la Galette","France"),
    ("Paul Cézanne","post-impressionnisme","La Montagne Sainte-Victoire","France"),
    ("Pablo Picasso","cubisme","Guernica","Espagne"),
    ("Salvador Dalí","surréalisme","La Persistance de la mémoire","Espagne"),
    ("Léonard de Vinci","Renaissance","La Joconde","Italie"),
    ("Michel-Ange","Renaissance","La Chapelle Sixtine","Italie"),
    ("Raphaël","Renaissance","L'École d'Athènes","Italie"),
    ("Rembrandt","baroque","La Ronde de nuit","Pays-Bas"),
    ("Johannes Vermeer","baroque","La Jeune Fille à la perle","Pays-Bas"),
    ("Vincent van Gogh","post-impressionnisme","La Nuit étoilée","Pays-Bas"),
    ("Eugène Delacroix","romantisme","La Liberté guidant le peuple","France"),
]

RECORDS_ATHLETISME = [
    ("100m homme","Usain Bolt","9,58 secondes","2009"),
    ("100m femme","Florence Griffith-Joyner","10,49 secondes","1988"),
    ("marathon homme","Eliud Kipchoge","2h00'35\"","2023"),
    ("marathon femme","Tigst Assefa","2h11'53\"","2023"),
    ("saut en hauteur homme","Javier Sotomayor","2,45 m","1993"),
    ("saut en longueur homme","Mike Powell","8,95 m","1991"),
    ("lancer du poids homme","Ryan Crouser","23,56 m","2023"),
]

PAYS_UE = [
    ("Allemagne","1957","la plus grande économie","Berlin"),
    ("France","1957","membre fondateur","Paris"),
    ("Italie","1957","membre fondateur","Rome"),
    ("Belgique","1957","siège de la Commission","Bruxelles"),
    ("Pays-Bas","1957","membre fondateur","Amsterdam"),
    ("Luxembourg","1957","siège de la Cour de justice","Luxembourg"),
    ("Danemark","1973","a rejoint l'UE en 1973","Copenhague"),
    ("Irlande","1973","membre depuis 1973","Dublin"),
    ("Grèce","1981","membre depuis 1981","Athènes"),
    ("Espagne","1986","membre depuis 1986","Madrid"),
    ("Portugal","1986","membre depuis 1986","Lisbonne"),
    ("Autriche","1995","membre depuis 1995","Vienne"),
    ("Finlande","1995","membre depuis 1995","Helsinki"),
    ("Suède","1995","membre depuis 1995","Stockholm"),
    ("Pologne","2004","le plus grand des nouveaux membres","Varsovie"),
    ("Hongrie","2004","membre depuis 2004","Budapest"),
    ("République tchèque","2004","membre depuis 2004","Prague"),
    ("Roumanie","2007","membre depuis 2007","Bucarest"),
    ("Bulgarie","2007","membre depuis 2007","Sofia"),
    ("Croatie","2013","le dernier à rejoindre l'UE","Zagreb"),
]

# ─────────────────────────────────────────────────────────────
# GÉNÉRATEURS DE QUESTIONS UNIQUES
# ─────────────────────────────────────────────────────────────

def shuffle_wrong(correct, pool, n=3):
    wrong = [x for x in pool if x != correct]
    random.shuffle(wrong)
    return wrong[:n]

def make_q(module, category, difficulty, question, options, answer, explanation, sub=None):
    opts_copy = list(options)
    random.shuffle(opts_copy)
    return {
        "module": module,
        "category": category,
        "difficulty": difficulty,
        "question": question,
        "options": json.dumps(opts_copy, ensure_ascii=False),
        "answer": answer,
        "explanation": explanation,
        "sub": sub or "",
        "rand_key": random.random(),
    }

def gen_geographie():
    questions = []
    M, C = "Culture générale", "Geographie"

    for pays, capitale in PAYS_CAPITALES:
        autres_caps = [c for p, c in PAYS_CAPITALES if c != capitale]
        random.shuffle(autres_caps)
        questions.append(make_q(M, C, "Facile",
            f"Quelle est la capitale de {pays} ?",
            [capitale] + autres_caps[:3], capitale,
            f"La capitale de {pays} est {capitale}."))

        autres_pays = [p for p, c in PAYS_CAPITALES if p != pays]
        random.shuffle(autres_pays)
        questions.append(make_q(M, C, "Facile",
            f"De quel pays {capitale} est-elle la capitale ?",
            [pays] + autres_pays[:3], pays,
            f"{capitale} est la capitale de {pays}."))

    for dep, num, pref in DEPARTEMENTS:
        autres_pref = [p for d, n, p in DEPARTEMENTS if p != pref]
        random.shuffle(autres_pref)
        questions.append(make_q(M, C, "Moyenne",
            f"Quelle est la préfecture du département {dep} ({num}) ?",
            [pref] + autres_pref[:3], pref,
            f"La préfecture du département {dep} est {pref}."))

        autres_dep = [d for d, n, p in DEPARTEMENTS if d != dep]
        random.shuffle(autres_dep)
        questions.append(make_q(M, C, "Difficile",
            f"Dans quel département se trouve la ville de {pref} ?",
            [dep] + autres_dep[:3], dep,
            f"{pref} est la préfecture du département {dep} ({num})."))

        autres_num = [n for d, n, p in DEPARTEMENTS if n != num]
        random.shuffle(autres_num)
        questions.append(make_q(M, C, "Difficile",
            f"Quel est le numéro du département {dep} ?",
            [num] + autres_num[:3], num,
            f"Le département {dep} porte le numéro {num}."))

    for nom, alt, massif, desc in MONTAGNES_FRANCE:
        questions.append(make_q(M, C, "Moyenne",
            f"Dans quel massif se trouve {nom} ({alt} m) ?",
            [massif] + ["Jura","Vosges","Ardennes"], massif,
            f"{nom} ({alt} m) se trouve dans le massif du {massif}. {desc.capitalize()}."))
        questions.append(make_q(M, C, "Difficile",
            f"Quelle est l'altitude de {nom} ?",
            [f"{alt} m", f"{int(alt)+150} m", f"{int(alt)+300} m", f"{int(alt)-100} m"],
            f"{alt} m",
            f"{nom} culmine à {alt} mètres. {desc.capitalize()}."))

    for fl, longueur, source, embouchure, desc in FLEUVES_FRANCE:
        questions.append(make_q(M, C, "Facile",
            f"Dans quelle mer ou quel océan se jette le {fl} ?",
            [embouchure] + ["Mer Noire","Adriatique","Baltique"], embouchure,
            f"Le {fl} ({longueur}) se jette dans {embouchure}. {desc.capitalize()}."))
        questions.append(make_q(M, C, "Difficile",
            f"Quelle est la longueur approximative du {fl} ?",
            [longueur] + [f"{int(longueur.split()[0])+50} km", f"{int(longueur.split()[0])+100} km", f"{int(longueur.split()[0])-50} km"],
            longueur,
            f"Le {fl} mesure {longueur}. {desc.capitalize()}."))

    for pl, rev, desc, lunes in PLANETES:
        autres = [p for p, r, d, l in PLANETES if p != pl]
        random.shuffle(autres)
        questions.append(make_q(M, C, "Facile",
            f"Quelle planète est connue comme '{desc}' ?",
            [pl] + autres[:3], pl,
            f"{pl} est surnommée '{desc}'. Sa révolution dure {rev}."))
        questions.append(make_q(M, C, "Moyenne",
            f"Combien de lunes possède {pl} ?",
            [lunes] + ["0","1","3","12","79"][:3], lunes,
            f"{pl} possède {lunes} lune(s) connue(s)."))

    return questions


def gen_histoire():
    questions = []
    M, C = "Culture générale", "Histoire"

    for annee, evenement, lieu in EVENEMENTS_HISTORIQUES:
        autres_annees = [a for a, e, l in EVENEMENTS_HISTORIQUES if a != annee]
        random.shuffle(autres_annees)
        questions.append(make_q(M, C, "Moyenne",
            f"En quelle année a eu lieu {evenement} ?",
            [annee] + autres_annees[:3], annee,
            f"{evenement.capitalize()} a eu lieu en {annee} en {lieu}."))

        autres_ev = [e for a, e, l in EVENEMENTS_HISTORIQUES if e != evenement]
        random.shuffle(autres_ev)
        questions.append(make_q(M, C, "Difficile",
            f"Quel événement majeur a eu lieu en {annee} en {lieu} ?",
            [evenement] + autres_ev[:3], evenement,
            f"En {annee}, {lieu} a connu {evenement}."))

    for nom, debut, fin, parti in PRESIDENTS_FRANCE:
        autres_noms = [n for n, d, f, p in PRESIDENTS_FRANCE if n != nom]
        random.shuffle(autres_noms)
        questions.append(make_q(M, C, "Moyenne",
            f"Qui était président de la République française de {debut} à {fin} ?",
            [nom] + autres_noms[:3], nom,
            f"{nom} ({parti}) a été président de {debut} à {fin}."))

        autres_debut = [d for n, d, f, p in PRESIDENTS_FRANCE if n != nom]
        random.shuffle(autres_debut)
        questions.append(make_q(M, C, "Difficile",
            f"Quand {nom} a-t-il été élu président de la République ?",
            [debut] + autres_debut[:3], debut,
            f"{nom} a été élu président en {debut} et a exercé jusqu'en {fin}."))

    extra = [
        ("Difficile","Quelle est la date de la prise de la Bastille ?","14 juillet 1789",
         ["14 juillet 1789","4 août 1789","26 août 1789","21 septembre 1792"],
         "La Bastille a été prise le 14 juillet 1789, événement fondateur de la Révolution française."),
        ("Facile","Quel document a été adopté le 26 août 1789 ?","la Déclaration des droits de l'homme",
         ["la Déclaration des droits de l'homme","la Constitution","le Code civil","le Concordat"],
         "La Déclaration des droits de l'homme et du citoyen a été adoptée le 26 août 1789."),
        ("Moyenne","En quelle année Napoléon est-il exilé à Sainte-Hélène ?","1815",
         ["1815","1814","1821","1812"],
         "Napoléon est exilé à Sainte-Hélène en 1815, après sa défaite à Waterloo."),
        ("Moyenne","Quel général a lancé l'Appel du 18 juin 1940 ?","Charles de Gaulle",
         ["Charles de Gaulle","Philippe Pétain","Jean Moulin","Henri Giraud"],
         "Charles de Gaulle a lancé l'Appel du 18 juin 1940 depuis Londres."),
        ("Difficile","Combien de temps a duré la Terreur pendant la Révolution française ?",
         "environ 10 mois (1793-1794)",
         ["environ 10 mois (1793-1794)","environ 2 ans (1792-1794)","6 mois (1794)","3 ans (1791-1794)"],
         "La Terreur a duré environ 10 mois, de septembre 1793 à juillet 1794."),
        ("Facile","Quel roi a été guillotiné pendant la Révolution française ?","Louis XVI",
         ["Louis XVI","Louis XIV","Louis XVIII","Louis XV"],
         "Louis XVI a été guillotiné le 21 janvier 1793 place de la Révolution."),
        ("Difficile","En quelle année a été signé le traité de Versailles ?","1919",
         ["1919","1918","1920","1917"],
         "Le traité de Versailles a été signé le 28 juin 1919, mettant fin officiellement à la Première Guerre mondiale."),
        ("Moyenne","Quel événement a déclenché la Première Guerre mondiale ?",
         "l'assassinat de l'archiduc François-Ferdinand",
         ["l'assassinat de l'archiduc François-Ferdinand","l'invasion de la Belgique","la déclaration de guerre de l'Allemagne","la mobilisation de la Russie"],
         "La Première Guerre mondiale a été déclenchée par l'assassinat de l'archiduc François-Ferdinand à Sarajevo le 28 juin 1914."),
    ]
    for diff, q, a, opts, expl in extra:
        questions.append(make_q(M, C, diff, q, opts, a, expl))

    return questions


def gen_sciences():
    questions = []
    M, C = "Culture générale", "Sciences"

    for nom, symbole, numero in ELEMENTS_CHIMIQUES:
        autres_sym = [s for n, s, nu in ELEMENTS_CHIMIQUES if s != symbole]
        random.shuffle(autres_sym)
        questions.append(make_q(M, C, "Moyenne",
            f"Quel est le symbole chimique de {nom} ?",
            [symbole] + autres_sym[:3], symbole,
            f"Le symbole chimique de {nom} est {symbole} (numéro atomique {numero})."))

        autres_nom = [n for n, s, nu in ELEMENTS_CHIMIQUES if n != nom]
        random.shuffle(autres_nom)
        questions.append(make_q(M, C, "Difficile",
            f"À quel élément correspond le symbole chimique '{symbole}' ?",
            [nom] + autres_nom[:3], nom,
            f"Le symbole '{symbole}' correspond à {nom}, numéro atomique {numero}."))

        autres_num = [nu for n, s, nu in ELEMENTS_CHIMIQUES if nu != numero]
        random.shuffle(autres_num)
        questions.append(make_q(M, C, "Difficile",
            f"Quel est le numéro atomique de {nom} ?",
            [numero] + autres_num[:3], numero,
            f"{nom} ({symbole}) a le numéro atomique {numero}."))

    for pl, rev, desc, lunes in PLANETES:
        questions.append(make_q(M, C, "Facile",
            f"Combien de temps {pl} met-elle pour tourner autour du Soleil ?",
            [rev] + ["1 an","6 mois","50 ans","200 ans"][:3], rev,
            f"{pl} effectue une révolution autour du Soleil en {rev}."))

    for organe, fonction, localisation in CORPS_HUMAIN:
        autres_fonctions = [f for o, f, l in CORPS_HUMAIN if f != fonction]
        random.shuffle(autres_fonctions)
        questions.append(make_q(M, C, "Moyenne",
            f"Quel est le rôle principal de {organe} ?",
            [fonction] + autres_fonctions[:3], fonction,
            f"{organe.capitalize()} se trouve dans {localisation} et sa fonction est {fonction}."))

        autres_org = [o for o, f, l in CORPS_HUMAIN if o != organe]
        random.shuffle(autres_org)
        questions.append(make_q(M, C, "Facile",
            f"Quel organe se trouve dans {localisation} et permet de {fonction} ?",
            [organe] + autres_org[:3], organe,
            f"{organe.capitalize()} est l'organe situé dans {localisation} chargé de {fonction}."))

    extra = [
        ("Facile","Quelle est la formule chimique de l'eau ?","H₂O",
         ["H₂O","CO₂","NaCl","O₂"],"L'eau est composée de 2 atomes d'hydrogène et 1 atome d'oxygène : H₂O."),
        ("Facile","Quelle est la formule du dioxyde de carbone ?","CO₂",
         ["CO₂","H₂O","CH₄","NO₂"],"Le dioxyde de carbone (CO₂) est formé d'un carbone et deux oxygènes."),
        ("Moyenne","Quelle est la vitesse de la lumière dans le vide ?","299 792 458 m/s",
         ["299 792 458 m/s","150 000 000 m/s","3 000 000 m/s","1 080 000 km/h"],
         "La lumière se déplace à 299 792 458 mètres par seconde dans le vide."),
        ("Difficile","Quelle est la loi de Newton qui dit que F=ma ?","deuxième loi de Newton",
         ["deuxième loi de Newton","première loi de Newton","troisième loi de Newton","loi de Hooke"],
         "La deuxième loi de Newton énonce que la force F est égale à la masse m multipliée par l'accélération a."),
        ("Moyenne","Quel gaz représente environ 78% de l'atmosphère terrestre ?","l'azote",
         ["l'azote","l'oxygène","l'argon","le dioxyde de carbone"],
         "L'azote (N₂) représente environ 78% de l'atmosphère. L'oxygène en représente environ 21%."),
        ("Difficile","Quelle est la loi de la conservation de l'énergie ?",
         "l'énergie ne se crée ni ne se détruit, elle se transforme",
         ["l'énergie ne se crée ni ne se détruit, elle se transforme","l'énergie est toujours cinétique","la force est proportionnelle à la masse","la chaleur monte toujours"],
         "La loi de conservation de l'énergie dit que l'énergie totale d'un système isolé reste constante."),
        ("Facile","Quel est le symbole chimique de l'or ?","Au",
         ["Au","Or","Ag","Fe"],"L'or est noté 'Au' du latin 'aurum'."),
        ("Facile","Quelle planète est la plus grande du système solaire ?","Jupiter",
         ["Jupiter","Saturne","Neptune","Uranus"],"Jupiter est la plus grande planète du système solaire."),
        ("Moyenne","Quel est le point d'ébullition de l'eau à pression standard ?","100°C",
         ["100°C","90°C","80°C","120°C"],"L'eau bout à 100°C (373 K) à pression atmosphérique standard (1 atm)."),
    ]
    for diff, q, a, opts, expl in extra:
        questions.append(make_q(M, C, diff, q, opts, a, expl))

    for vit, role, source in VITAMINES:
        autres_roles = [r for v, r, s in VITAMINES if r != role]
        random.shuffle(autres_roles)
        questions.append(make_q(M, C, "Facile",
            f"Quel est le rôle principal de la {vit} ?",
            [role] + autres_roles[:3], role,
            f"La {vit} est essentielle pour {role}. On la trouve dans {source}."))

    return questions


def gen_sante():
    questions = []
    M, C = "Culture générale", "Sante"

    for maladie, definition, facteurs in MALADIES_PREVENTION:
        autres = [d for m, d, f in MALADIES_PREVENTION if m != maladie]
        random.shuffle(autres)
        questions.append(make_q(M, C, "Moyenne",
            f"Comment définit-on {maladie} ?",
            [definition] + autres[:3], definition,
            f"{maladie.capitalize()} se caractérise par {definition}. Facteurs de risque : {facteurs}."))

        questions.append(make_q(M, C, "Facile",
            f"Quels sont les principaux facteurs de risque de {maladie} ?",
            [facteurs] + [f for m, d, f in MALADIES_PREVENTION if m != maladie][:3],
            facteurs,
            f"Les principaux facteurs de risque de {maladie} sont : {facteurs}."))

    for organe, fonction, localisation in CORPS_HUMAIN:
        autres = [o for o, f, l in CORPS_HUMAIN if o != organe]
        random.shuffle(autres)
        questions.append(make_q(M, C, "Facile",
            f"Où se trouve {organe} dans le corps humain ?",
            [localisation] + ["la tête","le thorax","le bassin","le bras"][:3], localisation,
            f"{organe.capitalize()} est situé dans {localisation}."))

    for groupe, compatibilite, frequence in GROUPES_SANGUINS:
        autres_g = [g for g, c, f in GROUPES_SANGUINS if g != groupe]
        random.shuffle(autres_g)
        questions.append(make_q(M, C, "Difficile",
            f"Quelle est la fréquence du groupe sanguin {groupe} dans la population ?",
            [frequence] + [f for g, c, f in GROUPES_SANGUINS if g != groupe][:3],
            frequence,
            f"Le groupe sanguin {groupe} représente {frequence}."))

    for vit, role, source in VITAMINES:
        autres_src = [s for v, r, s in VITAMINES if s != source]
        random.shuffle(autres_src)
        questions.append(make_q(M, C, "Facile",
            f"Où trouve-t-on principalement la {vit} ?",
            [source] + autres_src[:3], source,
            f"La {vit} est présente dans {source}. Elle est essentielle pour {role}."))

    extra = [
        ("Facile","Quel est le numéro d'urgence médical en France ?","15 (SAMU)",
         ["15 (SAMU)","17 (Police)","18 (Pompiers)","112 (Europe)"],
         "Le 15 est le numéro du SAMU (Service d'Aide Médicale Urgente) en France."),
        ("Facile","Quelle est la fréquence de compression thoracique lors d'un massage cardiaque ?",
         "100 à 120 par minute",
         ["100 à 120 par minute","60 à 80 par minute","30 à 40 par minute","150 par minute"],
         "Les recommandations actuelles préconisent 100 à 120 compressions par minute lors d'un massage cardiaque."),
        ("Moyenne","Quelle position doit-on donner à une personne inconsciente qui respire ?",
         "Position Latérale de Sécurité (PLS)",
         ["Position Latérale de Sécurité (PLS)","Position allongée sur le dos","Position assise","Position semi-assise"],
         "La PLS (Position Latérale de Sécurité) permet d'éviter l'asphyxie chez une personne inconsciente."),
        ("Difficile","Quelle est la durée maximale avant laquelle un arrêt cardiaque devient irréversible sans réanimation ?",
         "environ 4 à 6 minutes",
         ["environ 4 à 6 minutes","environ 10 minutes","environ 1 minute","environ 15 minutes"],
         "Sans réanimation, les lésions cérébrales irréversibles apparaissent après 4 à 6 minutes d'arrêt cardiaque."),
        ("Moyenne","Que signifie l'acronyme IMC ?",
         "Indice de Masse Corporelle",
         ["Indice de Masse Corporelle","Indice Médical Cardio-vasculaire","Indicateur de Malnutrition Clinique","Indice Métabolique de Base"],
         "L'IMC (Indice de Masse Corporelle) se calcule : poids (kg) / taille² (m). Normal : 18,5-24,9."),
    ]
    for diff, q, a, opts, expl in extra:
        questions.append(make_q(M, C, diff, q, opts, a, expl))

    return questions


def gen_cinema():
    questions = []
    M, C = "Culture générale", "Cinema"

    for realisateur, film, annee, pays in REALISATEURS:
        autres_real = [r for r, f, a, p in REALISATEURS if r != realisateur]
        random.shuffle(autres_real)
        questions.append(make_q(M, C, "Moyenne",
            f"Qui a réalisé le film '{film}' ({annee}) ?",
            [realisateur] + autres_real[:3], realisateur,
            f"'{film}' ({annee}) est un film réalisé par {realisateur} ({pays})."))

        autres_films = [f for r, f, a, p in REALISATEURS if f != film]
        random.shuffle(autres_films)
        questions.append(make_q(M, C, "Difficile",
            f"Quel est le film le plus célèbre de {realisateur} parmi ceux cités ?",
            [film] + autres_films[:3], film,
            f"{realisateur} est notamment connu pour '{film}' ({annee})."))

        autres_annees = [a for r, f, a, p in REALISATEURS if a != annee]
        random.shuffle(autres_annees)
        questions.append(make_q(M, C, "Difficile",
            f"En quelle année a été tourné '{film}' de {realisateur} ?",
            [annee] + autres_annees[:3], annee,
            f"'{film}' de {realisateur} a été réalisé en {annee}."))

    extra = [
        ("Facile","Quel est le plus grand festival de cinéma français ?","Festival de Cannes",
         ["Festival de Cannes","Festival de Berlin","Festival de Venise","César"],
         "Le Festival de Cannes est le plus grand festival de cinéma au monde, créé en 1946."),
        ("Facile","Comment s'appelle la récompense suprême du Festival de Cannes ?","Palme d'Or",
         ["Palme d'Or","Oscar","César","Lion d'Or"],
         "La Palme d'Or est la récompense principale décernée au Festival de Cannes."),
        ("Facile","Comment s'appelle la récompense principale du cinéma américain ?","Oscar",
         ["Oscar","Golden Globe","César","Palme d'Or"],
         "Les Oscars (Academy Awards) sont décernés par l'Académie des arts et sciences du cinéma depuis 1929."),
        ("Facile","Quel réalisateur français est connu pour la saga 'Le Grand Bleu' et 'Léon' ?","Luc Besson",
         ["Luc Besson","Claude Lelouch","Jean-Luc Godard","François Truffaut"],
         "Luc Besson est un réalisateur français célèbre pour 'Le Grand Bleu' (1988) et 'Léon' (1994)."),
        ("Moyenne","Quel film de 1936 de Charlie Chaplin parodie le travail à la chaîne ?","Les Temps modernes",
         ["Les Temps modernes","Le Dictateur","La Ruée vers l'or","Le Kid"],
         "'Les Temps modernes' (1936) de Charlie Chaplin est une satire du travail industriel."),
        ("Difficile","Quel film a remporté la Palme d'Or à Cannes en 2019 ?","Parasite",
         ["Parasite","Une affaire de famille","Roma","La Vie d'Adèle"],
         "'Parasite' de Bong Joon-ho a remporté la Palme d'Or en 2019 et l'Oscar du meilleur film en 2020."),
        ("Facile","Dans quel film dit-on la réplique 'Je suis ton père' ?","Star Wars",
         ["Star Wars","Indiana Jones","Le Seigneur des anneaux","Jurassic Park"],
         "La réplique 'Luke, je suis ton père' est tirée de 'L'Empire contre-attaque' (Star Wars, 1980)."),
    ]
    for diff, q, a, opts, expl in extra:
        questions.append(make_q(M, C, diff, q, opts, a, expl))

    for peintre, mouvement, oeuvre, pays in PEINTRES:
        autres_m = [m for p, m, o, pa in PEINTRES if m != mouvement]
        random.shuffle(autres_m)
        questions.append(make_q(M, C, "Difficile",
            f"Quel mouvement artistique représente {peintre} ?",
            [mouvement] + autres_m[:3], mouvement,
            f"{peintre} est un représentant du {mouvement}. Œuvre majeure : '{oeuvre}'."))

    return questions


def gen_musique():
    questions = []
    M, C = "Culture générale", "Musique"

    for comp, pays, siecle, oeuvre in COMPOSITEURS:
        autres_c = [c for c, p, s, o in COMPOSITEURS if c != comp]
        random.shuffle(autres_c)
        questions.append(make_q(M, C, "Moyenne",
            f"Qui a composé '{oeuvre}' ?",
            [comp] + autres_c[:3], comp,
            f"'{oeuvre}' a été composé par {comp} ({pays}, {siecle})."))

        autres_o = [o for c, p, s, o in COMPOSITEURS if o != oeuvre]
        random.shuffle(autres_o)
        questions.append(make_q(M, C, "Difficile",
            f"Quelle est l'œuvre majeure de {comp} ?",
            [oeuvre] + autres_o[:3], oeuvre,
            f"L'œuvre emblématique de {comp} est '{oeuvre}'."))

        autres_pays = [p for c, p, s, o in COMPOSITEURS if p != pays]
        random.shuffle(autres_pays)
        questions.append(make_q(M, C, "Difficile",
            f"De quelle nationalité était {comp} ?",
            [pays] + autres_pays[:3], pays,
            f"{comp} était de nationalité {pays} et a vécu au {siecle}."))

    for note, equiv, registre in NOTES_MUSIQUE:
        autres_eq = [e for n, e, r in NOTES_MUSIQUE if e != equiv]
        random.shuffle(autres_eq)
        questions.append(make_q(M, C, "Facile",
            f"Quelle est la notation anglo-saxonne de la note '{note}' ?",
            [equiv] + autres_eq[:3], equiv,
            f"La note '{note}' est notée '{equiv}' en notation anglaise."))

    extra = [
        ("Facile","Combien de notes y a-t-il dans la gamme musicale ?","7",
         ["7","5","8","12"],"La gamme musicale occidentale comporte 7 notes : do, ré, mi, fa, sol, la, si."),
        ("Facile","Quel instrument a 88 touches ?","le piano",
         ["le piano","l'orgue","le synthétiseur","le clavecin"],
         "Un piano standard possède 88 touches (52 blanches et 36 noires)."),
        ("Moyenne","Quelle est la fréquence standard du 'la' de référence en musique ?","440 Hz",
         ["440 Hz","432 Hz","450 Hz","480 Hz"],
         "Le 'la' de référence (A4) est standardisé à 440 Hz depuis 1939."),
        ("Facile","Quel chanteur français est connu pour 'La Vie en rose' ?","Édith Piaf",
         ["Édith Piaf","Charles Aznavour","Jacques Brel","Dalida"],
         "Édith Piaf a rendu célèbre 'La Vie en rose' en 1945."),
        ("Facile","De quelle nationalité était Jacques Brel ?","belge",
         ["belge","française","suisse","luxembourgeoise"],
         "Jacques Brel (1929-1978) était un chanteur et auteur-compositeur belge."),
        ("Moyenne","Quel groupe britannique est surnommé 'les Fab Four' ?","Les Beatles",
         ["Les Beatles","The Rolling Stones","Pink Floyd","Led Zeppelin"],
         "Les Beatles (John, Paul, George et Ringo) sont surnommés les 'Fab Four'."),
    ]
    for diff, q, a, opts, expl in extra:
        questions.append(make_q(M, C, diff, q, opts, a, expl))

    return questions


def gen_mythologie():
    questions = []
    M, C = "Culture générale", "Mythologie"

    for dieu, role, attribut in DIEUX_GRECS:
        autres_d = [d for d, r, a in DIEUX_GRECS if d != dieu]
        random.shuffle(autres_d)
        questions.append(make_q(M, C, "Facile",
            f"Dans la mythologie grecque, qui est '{role}' ?",
            [dieu] + autres_d[:3], dieu,
            f"Dans la mythologie grecque, {dieu} est {role}. Son attribut est {attribut}."))

        autres_roles = [r for d, r, a in DIEUX_GRECS if r != role]
        random.shuffle(autres_roles)
        questions.append(make_q(M, C, "Moyenne",
            f"Quel est le rôle de {dieu} dans la mythologie grecque ?",
            [role] + autres_roles[:3], role,
            f"{dieu} est {role}. Son attribut principal est {attribut}."))

        autres_attr = [a for d, r, a in DIEUX_GRECS if a != attribut]
        random.shuffle(autres_attr)
        questions.append(make_q(M, C, "Difficile",
            f"Quel est l'attribut symbolique de {dieu} dans la mythologie grecque ?",
            [attribut] + autres_attr[:3], attribut,
            f"L'attribut de {dieu} est {attribut}. Il/Elle est {role}."))

    correspondances = {
        "Jupiter":"Zeus","Junon":"Héra","Neptune":"Poséidon","Cérès":"Déméter",
        "Minerve":"Athéna","Mars":"Arès","Vénus":"Aphrodite","Vulcain":"Héphaïstos",
        "Mercure":"Hermès","Bacchus":"Dionysos","Diane":"Artémis","Pluton":"Hadès","Saturne":"Cronos"
    }
    for dieu_romain, role in DIEUX_ROMAINS:
        autres = [d for d, r in DIEUX_ROMAINS if d != dieu_romain]
        random.shuffle(autres)
        questions.append(make_q(M, C, "Facile",
            f"Dans la mythologie romaine, qui est {role} ?",
            [dieu_romain] + autres[:3], dieu_romain,
            f"Dans la mythologie romaine, {dieu_romain} est {role}."))

        grec = correspondances.get(dieu_romain)
        if grec:
            autres_grecs = [v for k, v in correspondances.items() if v != grec]
            random.shuffle(autres_grecs)
            questions.append(make_q(M, C, "Difficile",
                f"Quel est l'équivalent grec du dieu romain {dieu_romain} ?",
                [grec] + autres_grecs[:3], grec,
                f"{dieu_romain} (romain) correspond à {grec} (grec). Les deux sont {role}."))

    extra = [
        ("Facile","Qui est le roi des dieux dans la mythologie grecque ?","Zeus",
         ["Zeus","Poséidon","Hadès","Apollon"],
         "Zeus est le roi des dieux de l'Olympe dans la mythologie grecque."),
        ("Facile","Quel héros grec a accompli les Douze Travaux ?","Héraclès",
         ["Héraclès","Thésée","Achille","Ulysse"],
         "Héraclès (Hercule en latin) a accompli les Douze Travaux imposés par le roi Eurysthée."),
        ("Moyenne","Qui a construit le labyrinthe du Minotaure ?","Dédale",
         ["Dédale","Icare","Thésée","Minos"],
         "Dédale est l'architecte qui a construit le labyrinthe en Crète pour y enfermer le Minotaure."),
        ("Difficile","Combien de travaux Héraclès a-t-il accomplis ?","12",
         ["12","7","10","9"],
         "Héraclès a accompli 12 travaux pour expier ses fautes, dont tuer le lion de Némée."),
        ("Moyenne","Qui est le dieu de la mort dans la mythologie grecque ?","Hadès",
         ["Hadès","Thanatos","Cronos","Arès"],
         "Hadès est le dieu des Enfers et des morts dans la mythologie grecque."),
        ("Facile","Quel cheval ailé de la mythologie grecque est né du sang de Méduse ?","Pégase",
         ["Pégase","Arion","Licorne","Sleipnir"],
         "Pégase, le cheval ailé, est né du sang de Méduse quand Persée lui coupa la tête."),
        ("Difficile","Qui était l'épouse de Zeus ?","Héra",
         ["Héra","Aphrodite","Déméter","Artémis"],
         "Héra est la sœur et épouse de Zeus, déesse du mariage et de la famille."),
    ]
    for diff, q, a, opts, expl in extra:
        questions.append(make_q(M, C, diff, q, opts, a, expl))

    return questions


def gen_securite():
    questions = []
    M, C = "Culture générale", "Securite"

    for zone, vitesse, contexte in LIMITES_VITESSE:
        autres_v = [v for z, v, c in LIMITES_VITESSE if v != vitesse]
        random.shuffle(autres_v)
        questions.append(make_q(M, C, "Facile",
            f"Quelle est la vitesse maximale autorisée en {zone} ?",
            [vitesse] + autres_v[:3], vitesse,
            f"En {zone}, la vitesse est limitée à {vitesse} ({contexte})."))

        autres_z = [z for z, v, c in LIMITES_VITESSE if z != zone]
        random.shuffle(autres_z)
        questions.append(make_q(M, C, "Facile",
            f"Dans quelle zone la limite de vitesse est-elle fixée à {vitesse} ?",
            [zone] + autres_z[:3], zone,
            f"La vitesse est limitée à {vitesse} en {zone} ({contexte})."))

    for forme, signification, desc in PANNEAUX_ROUTIERS:
        autres = [s for f, s, d in PANNEAUX_ROUTIERS if s != signification]
        random.shuffle(autres)
        questions.append(make_q(M, C, "Facile",
            f"Que signifie un panneau de {forme} sur la route ?",
            [signification] + autres[:3], signification,
            f"Un panneau en {forme} indique {signification} ({desc})."))

    extra = [
        ("Facile","Quel est le taux d'alcoolémie maximal autorisé pour un conducteur expérimenté en France ?",
         "0,5 g/L (0,25 mg/L d'air expiré)",
         ["0,5 g/L (0,25 mg/L d'air expiré)","0,8 g/L","0,2 g/L","1 g/L"],
         "En France, le taux d'alcoolémie maximal est 0,5 g/L de sang (ou 0,25 mg/L d'air expiré)."),
        ("Facile","Quel est le taux d'alcoolémie maximal pour un conducteur novice (moins de 3 ans de permis) ?",
         "0,2 g/L",
         ["0,2 g/L","0,5 g/L","0,8 g/L","0 g/L"],
         "Pour les nouveaux conducteurs (moins de 3 ans de permis), le taux est limité à 0,2 g/L."),
        ("Moyenne","Quelle est la distance de sécurité minimale recommandée à 130 km/h ?",
         "115 mètres (2 secondes)",
         ["115 mètres (2 secondes)","50 mètres","200 mètres","75 mètres"],
         "À 130 km/h, la règle des 2 secondes correspond à environ 115 mètres de distance."),
        ("Facile","Combien de points possède un permis de conduire neuf en France ?","6 points",
         ["6 points","12 points","8 points","10 points"],
         "Un permis probatoire commence à 6 points et peut atteindre 12 points après 3 ans."),
        ("Facile","Combien de points possède un permis de conduire confirmé en France ?","12 points",
         ["12 points","20 points","6 points","8 points"],
         "Un permis de conduire confirmé (plus de 3 ans) comporte 12 points."),
        ("Moyenne","Quelle est la sanction pour conduite sous l'emprise d'alcool (>0,5 g/L) ?",
         "jusqu'à 4 500 € d'amende et 2 ans de prison",
         ["jusqu'à 4 500 € d'amende et 2 ans de prison","amende de 135 €","retrait de 3 points","stage de sensibilisation obligatoire"],
         "La conduite avec un taux d'alcoolémie >0,5 g/L est punie d'une amende jusqu'à 4 500 € et 2 ans d'emprisonnement."),
        ("Difficile","Que risque-t-on pour un refus de se soumettre aux vérifications de l'alcoolémie ?",
         "les mêmes peines que l'alcoolémie délictuelle",
         ["les mêmes peines que l'alcoolémie délictuelle","une simple amende","retrait de 2 points","un stage obligatoire"],
         "Le refus de se soumettre à l'éthylotest est assimilé à une infraction et sanctionné comme l'alcoolémie délictuelle."),
        ("Facile","À quelle distance doit-on signaler un obstacle sur la route avec des triangles ?","30 mètres minimum",
         ["30 mètres minimum","10 mètres","100 mètres","50 mètres"],
         "Les triangles de signalisation doivent être placés à au moins 30 mètres de l'obstacle."),
    ]
    for diff, q, a, opts, expl in extra:
        questions.append(make_q(M, C, diff, q, opts, a, expl))

    return questions


def gen_institutions():
    questions = []
    M, C = "Culture générale", "Institutions"

    for inst, siege, role in INSTITUTIONS_UE:
        autres_siege = [s for i, s, r in INSTITUTIONS_UE if s != siege]
        random.shuffle(autres_siege)
        questions.append(make_q(M, C, "Moyenne",
            f"Où se situe le siège de {inst} ?",
            [siege] + autres_siege[:3], siege,
            f"{inst} a son siège à {siege}. Son rôle est de {role}."))

        autres_role = [r for i, s, r in INSTITUTIONS_UE if r != role]
        random.shuffle(autres_role)
        questions.append(make_q(M, C, "Facile",
            f"Quel est le rôle de {inst} ?",
            [role] + autres_role[:3], role,
            f"{inst} est chargé de {role}, avec siège à {siege}."))

        autres_inst = [i for i, s, r in INSTITUTIONS_UE if i != inst]
        random.shuffle(autres_inst)
        questions.append(make_q(M, C, "Difficile",
            f"Quelle institution européenne se trouve à {siege} et est chargée de {role} ?",
            [inst] + autres_inst[:3], inst,
            f"{inst} est l'institution européenne basée à {siege}, responsable de {role}."))

    for pays, annee, desc, cap in PAYS_UE:
        autres_annees = [a for p, a, d, c in PAYS_UE if a != annee]
        random.shuffle(autres_annees)
        questions.append(make_q(M, C, "Difficile",
            f"En quelle année {pays} a-t-il rejoint l'Union européenne ?",
            [annee] + autres_annees[:3], annee,
            f"{pays} a rejoint l'Union européenne en {annee}. {desc.capitalize()}."))

    extra = [
        ("Facile","Combien de pays membres compte l'Union européenne ?","27",
         ["27","28","25","30"],"L'UE compte 27 membres depuis le Brexit (retrait du Royaume-Uni en 2020)."),
        ("Facile","Quelle est la monnaie unique européenne ?","l'euro",
         ["l'euro","le franc","le mark","la lire"],
         "L'euro (€) est la monnaie unique de la zone euro depuis 2002."),
        ("Moyenne","En quelle année a été signé le traité de Maastricht ?","1992",
         ["1992","1989","1995","1986"],
         "Le traité de Maastricht a été signé le 7 février 1992, fondant l'Union européenne."),
        ("Difficile","Quel pays a quitté l'Union européenne en 2020 ?","le Royaume-Uni",
         ["le Royaume-Uni","la Norvège","la Suisse","la Turquie"],
         "Le Royaume-Uni a officiellement quitté l'UE le 31 janvier 2020 (Brexit)."),
        ("Moyenne","Combien de sièges compte le Parlement européen ?","720 (depuis 2024)",
         ["720 (depuis 2024)","751","705","600"],
         "Le Parlement européen compte 720 membres depuis les élections de 2024."),
        ("Facile","Quelle est la devise de l'Union européenne ?","Unie dans la diversité",
         ["Unie dans la diversité","Liberté Égalité Fraternité","In varietate concordia","Unis et forts"],
         "La devise de l'UE est 'Unie dans la diversité' (In varietate concordia en latin)."),
        ("Difficile","Quel traité de 2007 a réformé les institutions de l'UE ?","le traité de Lisbonne",
         ["le traité de Lisbonne","le traité de Nice","le traité d'Amsterdam","le traité de Rome"],
         "Le traité de Lisbonne (signé en 2007, en vigueur en 2009) a réformé les institutions de l'UE."),
    ]
    for diff, q, a, opts, expl in extra:
        questions.append(make_q(M, C, diff, q, opts, a, expl))

    return questions


def gen_actualite():
    questions = []
    M, C = "Culture générale", "Actualite"

    extra = [
        ("Facile","Quelle organisation internationale regroupe les 5 grandes puissances nucléaires ?",
         "le Conseil de sécurité de l'ONU",
         ["le Conseil de sécurité de l'ONU","le G7","l'OTAN","l'OCDE"],
         "Le Conseil de sécurité de l'ONU est composé des 5 membres permanents : USA, Russie, Chine, Royaume-Uni, France."),
        ("Facile","Combien de membres permanents compte le Conseil de sécurité de l'ONU ?","5",
         ["5","15","10","7"],"Le Conseil de sécurité de l'ONU compte 5 membres permanents dotés du droit de veto."),
        ("Moyenne","Où se situe le siège des Nations Unies ?","New York",
         ["New York","Genève","Vienne","Paris"],"Le siège des Nations Unies est à New York, aux États-Unis."),
        ("Facile","Quel pays est le premier émetteur mondial de CO₂ ?","la Chine",
         ["la Chine","les États-Unis","l'Inde","la Russie"],
         "La Chine est le premier émetteur mondial de dioxyde de carbone, suivie des États-Unis."),
        ("Moyenne","Combien de pays ont signé l'Accord de Paris sur le climat (2015) ?",
         "plus de 190 pays",
         ["plus de 190 pays","55 pays","100 pays","25 pays"],
         "L'Accord de Paris (2015) a été signé par plus de 190 pays pour limiter le réchauffement climatique."),
        ("Difficile","Quel pays a accueilli la COP21 en 2015 ?","la France",
         ["la France","les États-Unis","le Royaume-Uni","l'Allemagne"],
         "La France a accueilli la COP21 à Paris en décembre 2015, aboutissant à l'Accord de Paris."),
        ("Facile","Que signifie ONU ?","Organisation des Nations Unies",
         ["Organisation des Nations Unies","Office des Nations Unies","Organisation Nationale Universelle","Organisation des Nouveaux États"],
         "ONU signifie Organisation des Nations Unies, fondée en 1945."),
        ("Facile","En quelle année a été fondée l'Organisation des Nations Unies ?","1945",
         ["1945","1919","1948","1960"],"L'ONU a été fondée en 1945, après la Seconde Guerre mondiale."),
        ("Moyenne","Quel phénomène météorologique est lié au réchauffement des eaux du Pacifique ?","El Niño",
         ["El Niño","La Niña","Le Mistral","La Tramontane"],
         "El Niño est un phénomène climatique périodique lié au réchauffement des eaux du Pacifique tropical."),
        ("Difficile","Quelle est la principale organisation commerciale mondiale ?","l'OMC (Organisation mondiale du commerce)",
         ["l'OMC (Organisation mondiale du commerce)","le FMI","l'OCDE","la Banque mondiale"],
         "L'OMC (Organisation mondiale du commerce) régule le commerce international depuis 1995."),
        ("Facile","Que signifie OMS ?","Organisation mondiale de la santé",
         ["Organisation mondiale de la santé","Organisation des marchés sanitaires","Office mondial de surveillance","Organisation médicale spécialisée"],
         "L'OMS (Organisation mondiale de la santé) est l'agence de l'ONU spécialisée dans la santé publique."),
        ("Moyenne","Quelle monnaie est utilisée en Grande-Bretagne ?","la livre sterling",
         ["la livre sterling","l'euro","le dollar","le franc"],
         "Le Royaume-Uni utilise la livre sterling (GBP), et non l'euro."),
        ("Facile","Quelle est la capitale des États-Unis ?","Washington D.C.",
         ["Washington D.C.","New York","Los Angeles","Chicago"],
         "Washington D.C. est la capitale fédérale des États-Unis depuis 1800."),
        ("Difficile","Quel pays est le plus peuplé du monde depuis 2023 ?","l'Inde",
         ["l'Inde","la Chine","les États-Unis","l'Indonésie"],
         "L'Inde a dépassé la Chine en 2023 pour devenir le pays le plus peuplé du monde."),
        ("Moyenne","Quel est le sigle de l'organisation atlantique de défense collective ?","OTAN",
         ["OTAN","ONU","UE","OCDE"],
         "L'OTAN (Organisation du Traité de l'Atlantique Nord) est l'alliance militaire fondée en 1949."),
    ]
    for diff, q, a, opts, expl in extra:
        questions.append(make_q(M, C, diff, q, opts, a, expl))

    return questions


def gen_france():
    questions = []
    M, C = "Culture générale", "France"

    for artiste, type_art, oeuvre, siecle in ARTISTES_FRANCAIS:
        autres_a = [a for a, t, o, s in ARTISTES_FRANCAIS if a != artiste]
        random.shuffle(autres_a)
        questions.append(make_q(M, C, "Moyenne",
            f"Qui est l'auteur de '{oeuvre}' ({siecle}) ?",
            [artiste] + autres_a[:3], artiste,
            f"'{oeuvre}' est l'œuvre de {artiste}, {type_art} du {siecle}."))

        autres_oeuvres = [o for a, t, o, s in ARTISTES_FRANCAIS if o != oeuvre]
        random.shuffle(autres_oeuvres)
        questions.append(make_q(M, C, "Difficile",
            f"Quelle est l'œuvre majeure de {artiste} ?",
            [oeuvre] + autres_oeuvres[:3], oeuvre,
            f"{artiste} est connu pour '{oeuvre}' ({siecle})."))

    for nom, debut, fin, parti in PRESIDENTS_FRANCE:
        autres = [n for n, d, f, p in PRESIDENTS_FRANCE if n != nom]
        random.shuffle(autres)
        questions.append(make_q(M, C, "Moyenne",
            f"Quel parti politique représentait {nom} ?",
            [parti] + ["SFIO","PCF","FN","DL"][:3], parti,
            f"{nom} était membre du {parti} lors de sa présidence ({debut}-{fin})."))

    extra = [
        ("Facile","Combien de régions compte la France métropolitaine ?","13",
         ["13","22","18","10"],"La France métropolitaine est divisée en 13 régions depuis la réforme de 2016."),
        ("Facile","Quelle est la devise nationale de la France ?","Liberté, Égalité, Fraternité",
         ["Liberté, Égalité, Fraternité","Dieu et mon droit","Unie dans la diversité","Liberté ou la mort"],
         "La devise de la République française est 'Liberté, Égalité, Fraternité'."),
        ("Facile","Quel est l'hymne national français ?","La Marseillaise",
         ["La Marseillaise","Le Chant du départ","La Victoire en chantant","Aux armes citoyens"],
         "La Marseillaise, composée par Rouget de Lisle en 1792, est l'hymne national français."),
        ("Moyenne","En quelle année la France a-t-elle adopté la Constitution de la Ve République ?","1958",
         ["1958","1946","1875","1962"],"La Constitution de la Ve République a été adoptée le 4 octobre 1958."),
        ("Facile","Quel monument est le symbole de Paris dans le monde entier ?","la Tour Eiffel",
         ["la Tour Eiffel","l'Arc de Triomphe","Notre-Dame de Paris","Le Louvre"],
         "La Tour Eiffel, construite par Gustave Eiffel pour l'Exposition universelle de 1889, est le symbole de Paris."),
        ("Difficile","Quelle est la population approximative de la France ?","environ 68 millions",
         ["environ 68 millions","environ 45 millions","environ 80 millions","environ 55 millions"],
         "La France comptait environ 68 millions d'habitants en 2023."),
        ("Facile","Quel est le plus long fleuve de France ?","la Loire",
         ["la Loire","la Seine","le Rhône","la Garonne"],
         "La Loire, avec 1012 km, est le plus long fleuve de France."),
        ("Moyenne","Quel document constitue le fondement des droits des citoyens français depuis 1789 ?",
         "la Déclaration des droits de l'homme et du citoyen",
         ["la Déclaration des droits de l'homme et du citoyen","la Constitution","le Code civil","la Charte des droits fondamentaux"],
         "La Déclaration des droits de l'homme et du citoyen du 26 août 1789 est le texte fondateur de la République."),
        ("Facile","De quelle couleur est le drapeau français ?","bleu, blanc, rouge",
         ["bleu, blanc, rouge","rouge, blanc, bleu","bleu, rouge, blanc","blanc, bleu, rouge"],
         "Le drapeau tricolore français est composé de trois bandes verticales bleu, blanc, rouge."),
    ]
    for diff, q, a, opts, expl in extra:
        questions.append(make_q(M, C, diff, q, opts, a, expl))

    for dep, num, pref in DEPARTEMENTS[:20]:
        autres_pref = [p for d, n, p in DEPARTEMENTS if p != pref]
        random.shuffle(autres_pref)
        questions.append(make_q(M, C, "Difficile",
            f"Quelle est la préfecture du {dep} ?",
            [pref] + autres_pref[:3], pref,
            f"La préfecture du {dep} ({num}) est {pref}."))

    return questions


def gen_police():
    questions = []
    M, C = "Culture générale", "Police"

    for sigle, nom_complet, mission in STRUCTURES_POLICE:
        questions.append(make_q(M, C, "Difficile",
            f"Que signifie le sigle '{sigle}' dans la police nationale ?",
            [nom_complet] + [n for s, n, m in STRUCTURES_POLICE if n != nom_complet][:3],
            nom_complet,
            f"{sigle} signifie '{nom_complet}'. Sa mission est : {mission}."))

        autres_m = [m for s, n, m in STRUCTURES_POLICE if m != mission]
        random.shuffle(autres_m)
        questions.append(make_q(M, C, "Moyenne",
            f"Quelle est la mission principale de {sigle} ?",
            [mission] + autres_m[:3], mission,
            f"{sigle} ({nom_complet}) est chargé de {mission}."))

        autres_sigle = [s for s, n, m in STRUCTURES_POLICE if s != sigle]
        random.shuffle(autres_sigle)
        questions.append(make_q(M, C, "Difficile",
            f"Quel service est chargé de {mission} dans la police ?",
            [sigle] + autres_sigle[:3], sigle,
            f"C'est le {sigle} ({nom_complet}) qui est chargé de {mission}."))

    for grade, def_grade, categorie in GRADES_POLICE:
        questions.append(make_q(M, C, "Moyenne",
            f"À quelle catégorie de la fonction publique appartient le grade de {grade} ?",
            [categorie] + [c for g, d, c in GRADES_POLICE if c != categorie][:3],
            categorie,
            f"Le {grade} ({def_grade}) appartient à la {categorie}."))

        questions.append(make_q(M, C, "Difficile",
            f"Qu'est-ce qu'un {grade} dans la police nationale ?",
            [def_grade] + [d for g, d, c in GRADES_POLICE if d != def_grade][:3],
            def_grade,
            f"Le {grade} est {def_grade} dans la police nationale ({categorie})."))

    for sigle, nom_complet, domaine in SIGLES_POLICE:
        autres = [n for s, n, d in SIGLES_POLICE if n != nom_complet]
        random.shuffle(autres)
        questions.append(make_q(M, C, "Difficile",
            f"Que signifie le sigle '{sigle}' ?",
            [nom_complet] + autres[:3], nom_complet,
            f"'{sigle}' signifie '{nom_complet}'. Domaine : {domaine}."))

    extra = [
        ("Facile","Quel est le numéro d'urgence de la police en France ?","17",
         ["17","15","18","112"],"Le 17 est le numéro d'urgence de la police nationale en France."),
        ("Facile","Quel service assure l'ordre en milieu rural ?","la Gendarmerie nationale",
         ["la Gendarmerie nationale","la Police nationale","la Police municipale","la CRS"],
         "La Gendarmerie nationale est compétente dans les zones rurales et périurbaines."),
        ("Moyenne","Qui contrôle la police nationale ?","le ministre de l'Intérieur",
         ["le ministre de l'Intérieur","le Premier ministre","le ministre de la Justice","le Président de la République"],
         "La police nationale est placée sous l'autorité du ministre de l'Intérieur."),
        ("Difficile","En quelle année a été créée la police nationale française ?","1966",
         ["1966","1945","1900","1848"],"La police nationale a été créée par la réforme Fouchet de 1966."),
        ("Moyenne","Quelle est la mission de l'IGPN ?",
         "contrôler et inspecter la police nationale",
         ["contrôler et inspecter la police nationale","combattre le terrorisme","gérer les frontières","former les policiers"],
         "L'IGPN (Inspection générale de la Police nationale) est la 'police des polices'."),
        ("Facile","Que signifie CSP dans l'organisation de la police ?","Commissariat de sécurité publique",
         ["Commissariat de sécurité publique","Corps de sécurité de proximité","Centre de surveillance policière","Corps spécial de police"],
         "Un CSP est un Commissariat de sécurité publique, structure de base de la police nationale."),
        ("Difficile","Quelle loi régit les pouvoirs de la police judiciaire ?","le Code de procédure pénale",
         ["le Code de procédure pénale","le Code pénal","le Code civil","le Code de la sécurité intérieure"],
         "Les pouvoirs de la police judiciaire sont définis par le Code de procédure pénale."),
        ("Moyenne","Quel est le rôle du OPJ (Officier de Police Judiciaire) ?",
         "diriger les enquêtes et constater les infractions",
         ["diriger les enquêtes et constater les infractions","maintenir l'ordre public","contrôler les frontières","former les policiers"],
         "L'OPJ est habilité à diriger des enquêtes, effectuer des gardes à vue et dresser des procès-verbaux."),
    ]
    for diff, q, a, opts, expl in extra:
        questions.append(make_q(M, C, diff, q, opts, a, expl))

    return questions


def gen_droit():
    questions = []
    M, C = "Culture générale", "Droit"

    for loi, objet, domaine in LOIS_FRANCE:
        autres_obj = [o for l, o, d in LOIS_FRANCE if o != objet]
        random.shuffle(autres_obj)
        questions.append(make_q(M, C, "Moyenne",
            f"Quel est l'objet de la {loi} ?",
            [objet] + autres_obj[:3], objet,
            f"La {loi} concerne {objet} dans le domaine du {domaine}."))

        autres_loi = [l for l, o, d in LOIS_FRANCE if l != loi]
        random.shuffle(autres_loi)
        questions.append(make_q(M, C, "Difficile",
            f"Quelle loi traite de {objet} en droit français ?",
            [loi] + autres_loi[:3], loi,
            f"C'est la {loi} qui régit {objet} dans le domaine du {domaine}."))

    for droit, source, domaine in DROITS_FONDAMENTAUX:
        autres_s = [s for d, s, do in DROITS_FONDAMENTAUX if s != source]
        random.shuffle(autres_s)
        questions.append(make_q(M, C, "Difficile",
            f"Sur quel article de la CEDH se fonde {droit} ?",
            [source] + autres_s[:3], source,
            f"Le {droit} est garanti par {source} ({domaine})."))

        autres_d = [d for d, s, do in DROITS_FONDAMENTAUX if d != droit]
        random.shuffle(autres_d)
        questions.append(make_q(M, C, "Moyenne",
            f"Que garantit {source} de la Convention européenne des droits de l'homme ?",
            [droit] + autres_d[:3], droit,
            f"{source} de la CEDH protège {droit} dans le domaine du {domaine}."))

    for infraction, definition, consequence in INFRACTIONS:
        autres_d = [d for i, d, c in INFRACTIONS if d != definition]
        random.shuffle(autres_d)
        questions.append(make_q(M, C, "Facile",
            f"Comment définit-on une {infraction} en droit pénal ?",
            [definition] + autres_d[:3], definition,
            f"Une {infraction} est {definition}. Conséquence : {consequence}."))

    for peine, description, contexte in PEINES_PRINCIPALES:
        questions.append(make_q(M, C, "Moyenne",
            f"Dans quel contexte applique-t-on {peine} ?",
            [contexte] + [c for p, d, c in PEINES_PRINCIPALES if c != contexte][:3],
            contexte,
            f"{peine.capitalize()} est une peine appliquée dans le cas de : {contexte}. {description}."))

    extra = [
        ("Facile","Quelle juridiction juge les crimes en France ?","la Cour d'assises",
         ["la Cour d'assises","le Tribunal correctionnel","le Tribunal de police","le Conseil d'État"],
         "La Cour d'assises est la juridiction compétente pour juger les crimes en France."),
        ("Facile","Quelle juridiction juge les délits en France ?","le Tribunal correctionnel",
         ["le Tribunal correctionnel","la Cour d'assises","le Tribunal de police","la Cour d'appel"],
         "Le Tribunal correctionnel est compétent pour les délits passibles d'emprisonnement."),
        ("Facile","Quelle juridiction juge les contraventions en France ?","le Tribunal de police",
         ["le Tribunal de police","le Tribunal correctionnel","la Cour d'assises","le Conseil d'État"],
         "Le Tribunal de police est compétent pour les 5 classes de contraventions."),
        ("Moyenne","Quelle est la durée maximale d'une garde à vue de droit commun ?","48 heures",
         ["48 heures","24 heures","72 heures","96 heures"],
         "La garde à vue de droit commun dure au maximum 48 heures (24h renouvelables avec accord du procureur)."),
        ("Difficile","Que désigne la présomption d'innocence ?",
         "toute personne est réputée innocente jusqu'à preuve de sa culpabilité",
         ["toute personne est réputée innocente jusqu'à preuve de sa culpabilité","le droit au silence","l'interdiction de témoigner","le droit à un avocat"],
         "La présomption d'innocence est un principe fondamental : nul n'est coupable tant que le juge ne l'a pas déclaré."),
        ("Moyenne","Qu'est-ce que le Code civil ?",
         "le recueil des lois régissant les relations entre personnes privées",
         ["le recueil des lois régissant les relations entre personnes privées","le code des infractions pénales","le code des procédures judiciaires","le code administratif"],
         "Le Code civil (1804), dit Code Napoléon, régit les relations entre personnes privées : famille, contrats, propriété."),
        ("Difficile","Quelle est la distinction entre 'fait' et 'droit' en procédure ?",
         "le fait est ce qui s'est passé, le droit est la règle applicable",
         ["le fait est ce qui s'est passé, le droit est la règle applicable","le fait est écrit, le droit est oral","le fait concerne l'État, le droit concerne les particuliers","pas de distinction"],
         "En procédure, les faits sont les événements concrets, et le droit est la règle juridique qui s'y applique."),
    ]
    for diff, q, a, opts, expl in extra:
        questions.append(make_q(M, C, diff, q, opts, a, expl))

    return questions


def gen_sport():
    questions = []
    M, C = "Culture générale", "Sport"

    for sport, discipline, description in SPORTS_OLYMPIQUES:
        autres = [s for s, d, de in SPORTS_OLYMPIQUES if s != sport]
        random.shuffle(autres)
        questions.append(make_q(M, C, "Facile",
            f"Le {sport} appartient à quelle discipline olympique ?",
            [discipline] + ["natation","combat","force","aquatique"][:3], discipline,
            f"Le {sport} est un sport {discipline} ({description}) présent aux Jeux olympiques."))

        autres_desc = [de for s, d, de in SPORTS_OLYMPIQUES if de != description]
        random.shuffle(autres_desc)
        questions.append(make_q(M, C, "Difficile",
            f"Quelle est la caractéristique du {sport} ?",
            [description] + autres_desc[:3], description,
            f"Le {sport} ({discipline}) est caractérisé par {description}."))

    for epreuve, athlete, record, annee in RECORDS_ATHLETISME:
        autres_athletes = [a for e, a, r, an in RECORDS_ATHLETISME if a != athlete]
        random.shuffle(autres_athletes)
        questions.append(make_q(M, C, "Difficile",
            f"Qui détient le record du monde du {epreuve} ?",
            [athlete] + autres_athletes[:3], athlete,
            f"Le record du monde du {epreuve} est détenu par {athlete} avec {record} en {annee}."))

        questions.append(make_q(M, C, "Difficile",
            f"Quel est le record du monde du {epreuve} ?",
            [record] + [r for e, a, r, an in RECORDS_ATHLETISME if r != record][:3],
            record,
            f"Le record du monde du {epreuve} est {record}, établi par {athlete} en {annee}."))

    extra = [
        ("Facile","Combien y a-t-il d'anneaux sur le drapeau olympique ?","5",
         ["5","4","6","7"],"Le drapeau olympique comporte 5 anneaux colorés symbolisant les 5 continents."),
        ("Facile","Quelle est la devise des Jeux olympiques ?","Plus vite, plus haut, plus fort — ensemble",
         ["Plus vite, plus haut, plus fort — ensemble","Citius, Altius, Fortius","L'important c'est de participer","Toujours plus loin"],
         "La devise olympique est 'Citius, Altius, Fortius — Communiter' (Plus vite, plus haut, plus fort — ensemble)."),
        ("Facile","De combien de joueurs est composée une équipe de football ?","11",
         ["11","10","12","9"],"Une équipe de football est composée de 11 joueurs sur le terrain."),
        ("Facile","De combien de sets est composé un match de tennis en Grand Chelem masculin ?","5 sets maximum",
         ["5 sets maximum","3 sets","4 sets","6 sets"],"Un match masculin en Grand Chelem se joue au meilleur des 5 sets."),
        ("Moyenne","Quelle est la longueur officielle d'une piscine olympique ?","50 mètres",
         ["50 mètres","25 mètres","100 mètres","33 mètres"],"Une piscine olympique mesure 50 mètres de long et 25 mètres de large."),
        ("Difficile","En quelle année la France a-t-elle remporté sa première Coupe du monde de football ?","1998",
         ["1998","2006","2018","1984"],"La France a remporté sa première Coupe du monde de football en 1998 à domicile."),
        ("Facile","Quel sport se joue avec un volant ?","le badminton",
         ["le badminton","le squash","le tennis","le tennis de table"],"Le badminton se joue avec un volant et une raquette."),
        ("Moyenne","Quel sport pratique-t-on sur un hippodrome ?","l'équitation / les courses hippiques",
         ["l'équitation / les courses hippiques","le polo","le saut d'obstacles","le dressage"],
         "L'hippodrome est une piste destinée aux courses de chevaux."),
    ]
    for diff, q, a, opts, expl in extra:
        questions.append(make_q(M, C, diff, q, opts, a, expl))

    return questions


# ─────────────────────────────────────────────────────────────
# DÉDOUBLONNAGE
# ─────────────────────────────────────────────────────────────

def deduplicate(questions):
    seen = set()
    result = []
    for q in questions:
        key = hashlib.md5(q["question"].strip().lower().encode()).hexdigest()
        if key not in seen:
            seen.add(key)
            result.append(q)
    return result


# ─────────────────────────────────────────────────────────────
# INSERTION SUPABASE
# ─────────────────────────────────────────────────────────────

async def insert_batch(session, batch):
    url = f"{SUPABASE_URL}/rest/v1/quiz_questions"
    payload = json.dumps(batch, ensure_ascii=False)
    async with session.post(url, data=payload, headers=HEADERS) as r:
        if r.status not in (200, 201):
            text = await r.text()
            log.error(f"HTTP {r.status}: {text[:200]}")
            return 0
    return len(batch)


async def insert_all(questions):
    total = 0
    async with aiohttp.ClientSession() as session:
        for i in range(0, len(questions), BATCH_SIZE):
            batch = questions[i:i+BATCH_SIZE]
            n = await insert_batch(session, batch)
            total += n
    return total


# ─────────────────────────────────────────────────────────────
# MAIN
# ─────────────────────────────────────────────────────────────

async def main():
    log.info("=" * 60)
    log.info(f"CoPiQ Générateur v4 — {datetime.now()}")
    log.info("=" * 60)

    generators = [
        ("Geographie", gen_geographie),
        ("Histoire", gen_histoire),
        ("Sciences", gen_sciences),
        ("Sante", gen_sante),
        ("Cinema", gen_cinema),
        ("Musique", gen_musique),
        ("Mythologie", gen_mythologie),
        ("Securite", gen_securite),
        ("Institutions", gen_institutions),
        ("Actualite", gen_actualite),
        ("France", gen_france),
        ("Police", gen_police),
        ("Droit", gen_droit),
        ("Sport", gen_sport),
    ]

    all_questions = []
    for name, fn in generators:
        qs = fn()
        qs = deduplicate(qs)
        random.shuffle(qs)
        log.info(f"  {name}: {len(qs)} questions uniques générées")
        all_questions.extend(qs)

    all_questions = deduplicate(all_questions)
    random.shuffle(all_questions)
    log.info(f"\nTotal unique: {len(all_questions)} questions")

    log.info("Insertion dans Supabase...")
    n = await insert_all(all_questions)
    log.info(f"✅ {n} questions insérées")
    log.info("=" * 60)


if __name__ == "__main__":
    asyncio.run(main())
