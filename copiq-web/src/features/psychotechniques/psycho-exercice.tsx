"use client"
import { useState, useEffect, useCallback, useRef } from "react"
import { RotateCcw } from "lucide-react"

// ─── TYPES ────────────────────────────────────────────────────────────────────
type Level = "debutant" | "intermediaire" | "expert"
type Phase = "select-level" | "playing" | "finished"
type Choice = string | number

interface Question {
  question: string
  answer: Choice
  choices: Choice[]
}

// ─── LEVEL CONFIG ─────────────────────────────────────────────────────────────
const LEVEL_CONFIG: Record<Level, { label: string; time: number }> = {
  debutant:      { label: "Débutant",      time: 60  },
  intermediaire: { label: "Intermédiaire", time: 90  },
  expert:        { label: "Expert",        time: 120 },
}

// ─── UTILS ────────────────────────────────────────────────────────────────────
function shuffle<T>(arr: T[]): T[] {
  return [...arr].sort(() => Math.random() - 0.5)
}
function uniq<T>(arr: T[]): T[] {
  return [...new Set(arr)]
}

// ─── CALCUL MENTAL ────────────────────────────────────────────────────────────

function genCalculDebutant(): Question {
  const type = Math.random() < 0.5 ? "arith" : "mult"
  let question: string, answer: number
  if (type === "arith") {
    if (Math.random() < 0.5) {
      const a = Math.floor(Math.random() * 19) + 1
      const b = Math.floor(Math.random() * 19) + 1
      answer = a + b
      question = `${a} + ${b} = ?`
    } else {
      const a = Math.floor(Math.random() * 17) + 3
      const b = Math.floor(Math.random() * (a - 1)) + 1
      answer = a - b
      question = `${a} − ${b} = ?`
    }
  } else {
    const a = Math.floor(Math.random() * 4) + 2   // 2–5
    const b = Math.floor(Math.random() * 9) + 2   // 2–10
    answer = a * b
    question = `${a} × ${b} = ?`
  }
  const w = uniq([answer+1, answer-1, answer+2, answer-2, answer+3]).filter(v => v > 0 && v !== answer)
  return { question, answer, choices: shuffle(uniq([answer, ...w.slice(0,3)])).slice(0,4) }
}

function genCalculIntermediaire(): Question {
  const r = Math.random()
  let question: string, answer: number
  if (r < 0.35) {
    if (Math.random() < 0.5) {
      const a = Math.floor(Math.random() * 90) + 10
      const b = Math.floor(Math.random() * 90) + 10
      answer = a + b
      question = `${a} + ${b} = ?`
    } else {
      const a = Math.floor(Math.random() * 80) + 20
      const b = Math.floor(Math.random() * (a - 1)) + 1
      answer = a - b
      question = `${a} − ${b} = ?`
    }
  } else if (r < 0.70) {
    const a = Math.floor(Math.random() * 11) + 2   // 2–12
    const b = Math.floor(Math.random() * 11) + 2
    answer = a * b
    question = `${a} × ${b} = ?`
  } else {
    const pct = [10, 25, 50][Math.floor(Math.random() * 3)]
    const base = (Math.floor(Math.random() * 9) + 2) * (pct === 10 ? 10 : pct === 25 ? 4 : 2)
    answer = Math.round(base * pct / 100)
    question = `${pct}% de ${base} = ?`
  }
  const d = Math.max(2, Math.ceil(Math.abs(answer) * 0.12))
  const w = uniq([answer+d, answer-d, answer+d*2, answer-d*2]).filter(v => v >= 0 && v !== answer)
  return { question, answer, choices: shuffle(uniq([answer, ...w.slice(0,3)])).slice(0,4) }
}

function genCalculExpert(): Question {
  const r = Math.random()
  let question: string, answer: number
  if (r < 0.40) {
    // Calcul à 2 étapes
    const variants = [
      () => { const a = Math.floor(Math.random()*20)+5; const b = Math.floor(Math.random()*9)+2; const c = Math.floor(Math.random()*30)+5; return { q:`${a} × ${b} + ${c} = ?`, a:a*b+c } },
      () => { const a = Math.floor(Math.random()*20)+5; const b = Math.floor(Math.random()*9)+2; const c = Math.floor(Math.random()*20)+2; return { q:`${a} × ${b} − ${c} = ?`, a:a*b-c } },
      () => { const a = Math.floor(Math.random()*25)+10; const b = Math.floor(Math.random()*15)+5; const c = Math.floor(Math.random()*8)+2; return { q:`(${a} + ${b}) × ${c} = ?`, a:(a+b)*c } },
      () => { const a = Math.floor(Math.random()*40)+20; const b = Math.floor(Math.random()*10)+2; const c = Math.floor(Math.random()*15)+5; return { q:`${a} ÷ ${b} + ${c} = ?`, a:Math.floor(a/b)+c } },
    ]
    const v = variants[Math.floor(Math.random()*variants.length)]()
    question = v.q; answer = v.a
  } else if (r < 0.70) {
    // Racine carrée entière
    const root = Math.floor(Math.random()*11) + 2   // 2–12
    answer = root
    question = `√${root * root} = ?`
  } else {
    // % complexe
    const pct = [15,20,30,35,40,60,75][Math.floor(Math.random()*7)]
    const base = (Math.floor(Math.random()*9)+2) * 20
    answer = Math.round(base * pct / 100)
    question = `${pct}% de ${base} = ?`
  }
  const d = Math.max(1, Math.ceil(Math.abs(answer) * 0.08))
  const w = uniq([answer+d, answer-d, answer+d*2, answer+d*3, answer-d*2]).filter(v => v >= 0 && v !== answer)
  return { question, answer, choices: shuffle(uniq([answer, ...w.slice(0,3)])).slice(0,4) }
}

// ─── SUITES LOGIQUES ──────────────────────────────────────────────────────────

function genSuiteDebutant(): Question {
  const a = Math.floor(Math.random()*8)+1
  const d = Math.floor(Math.random()*5)+1
  const seq = Array.from({length:5}, (_,i) => a + d*i)
  const answer = a + d*5
  const w = [answer+d, answer-d, answer+d*2].filter(v => v !== answer)
  return { question:`${seq.join(" — ")} — ?`, answer, choices:shuffle(uniq([answer,...w.slice(0,3)])).slice(0,4) }
}

function genSuiteIntermediaire(): Question {
  const types = [
    // Géométrique ×r
    () => {
      const a = Math.floor(Math.random()*3)+1
      const r = Math.floor(Math.random()*2)+2
      const seq = Array.from({length:5}, (_,i) => a * Math.pow(r,i))
      const answer = seq[4]*r
      const w = [answer+a, answer*2, Math.floor(answer/r)].filter(v => v>0 && v!==answer)
      return { question:`${seq.join(" — ")} — ?`, answer, choices:shuffle(uniq([answer,...w.slice(0,3)])).slice(0,4) }
    },
    // Alternante +a +b +a +b
    () => {
      const a = Math.floor(Math.random()*4)+2
      const b = Math.floor(Math.random()*3)+1
      const s = Math.floor(Math.random()*10)+1
      const seq = [s, s+a, s+a+b, s+2*a+b, s+2*a+2*b]
      const answer = s+3*a+2*b
      const w = [answer+a, answer-b, answer+b].filter(v => v!==answer)
      return { question:`${seq.join(" — ")} — ?`, answer, choices:shuffle(uniq([answer,...w.slice(0,3)])).slice(0,4) }
    },
    // +2n pattern : diff croissant de 2
    () => {
      const s = Math.floor(Math.random()*10)+1
      const seq = [s]
      for (let i=1;i<5;i++) seq.push(seq[seq.length-1]+2*i)
      const answer = seq[4]+10
      const w = [answer+2, answer-2, answer+4].filter(v => v!==answer)
      return { question:`${seq.join(" — ")} — ?`, answer, choices:shuffle(uniq([answer,...w.slice(0,3)])).slice(0,4) }
    },
    // Suite décroissante arithmétique
    () => {
      const a = Math.floor(Math.random()*30)+50
      const d = Math.floor(Math.random()*5)+3
      const seq = Array.from({length:5}, (_,i) => a - d*i)
      const answer = a - d*5
      const w = [answer-d, answer+d, answer-2*d].filter(v => v!==answer)
      return { question:`${seq.join(" — ")} — ?`, answer, choices:shuffle(uniq([answer,...w.slice(0,3)])).slice(0,4) }
    },
    // ×2 puis +5 alternant
    () => {
      const s = Math.floor(Math.random()*5)+2
      const seq = [s]
      for (let i=1;i<5;i++) seq.push(i%2===1 ? seq[seq.length-1]*2 : seq[seq.length-1]+5)
      const answer = seq[4]*2
      const w = [answer+5, answer-5, answer/2].filter(v => v>0 && v!==answer)
      return { question:`${seq.join(" — ")} — ?`, answer, choices:shuffle(uniq([answer,...w.slice(0,3)])).slice(0,4) }
    },
    // Carrés parfaits n²
    () => {
      const n = Math.floor(Math.random()*5)+1
      const seq = Array.from({length:5}, (_,i) => (n+i)*(n+i))
      const answer = (n+5)*(n+5)
      const w = [answer+2*(n+5)+1, answer-1, answer+2*(n+5)].filter(v => v!==answer)
      return { question:`${seq.join(" — ")} — ?`, answer, choices:shuffle(uniq([answer,...w.slice(0,3)])).slice(0,4) }
    },
    // Pairs / Impairs alternants
    () => {
      const start = (Math.floor(Math.random()*10)+1)*2
      const seq = [start, start+3, start+6, start+9, start+12]
      const answer = start+15
      const w = [answer+3, answer-3, answer+6].filter(v => v!==answer)
      return { question:`${seq.join(" — ")} — ?`, answer, choices:shuffle(uniq([answer,...w.slice(0,3)])).slice(0,4) }
    },
  ]
  return types[Math.floor(Math.random()*types.length)]()
}

function genSuiteExpert(): Question {
  const types = [
    // Suite de Fibonacci généralisée (a, b, a+b, ...)
    () => {
      const a = Math.floor(Math.random()*4)+1
      const b = Math.floor(Math.random()*4)+2
      const seq = [a, b]
      for (let i=2;i<7;i++) seq.push(seq[i-1]+seq[i-2])
      const answer = seq[6]+seq[5]
      const w = [answer+seq[4], answer-seq[5], answer+1].filter(v => v!==answer)
      return { question:`${seq.slice(0,7).join(" — ")} — ?`, answer, choices:shuffle(uniq([answer,...w.slice(0,3)])).slice(0,4) }
    },
    // Différences secondes constantes (triangulaires)
    () => {
      const a = Math.floor(Math.random()*5)+1
      const d = Math.floor(Math.random()*3)+1
      const seq = [a, a+d, a+3*d, a+6*d, a+10*d]
      const answer = a+15*d
      const w = [answer+d, answer-d, a+12*d].filter(v => v!==answer)
      return { question:`${seq.join(" — ")} — ?`, answer, choices:shuffle(uniq([answer,...w.slice(0,3)])).slice(0,4) }
    },
    // Alternance géométrique + arithmétique
    () => {
      const s = Math.floor(Math.random()*10)+5
      const add = Math.floor(Math.random()*8)+3
      const seq = [s]
      for (let i=1;i<6;i++) seq.push(i%2===1 ? seq[seq.length-1]*2 : seq[seq.length-1]+add)
      const answer = seq[5]*2
      const w = [answer+add, answer/2, answer-add].filter(v => v>0 && v!==answer)
      return { question:`${seq.join(" — ")} — ?`, answer, choices:shuffle(uniq([answer,...w.slice(0,3)])).slice(0,4) }
    },
    // 2^n − 1
    () => {
      const off = Math.floor(Math.random()*3)
      const seq = Array.from({length:5}, (_,i) => Math.pow(2,i+1+off)-1)
      const answer = Math.pow(2,6+off)-1
      const w = [answer+1, answer*2, answer-1].filter(v => v!==answer)
      return { question:`${seq.join(" — ")} — ?`, answer, choices:shuffle(uniq([answer,...w.slice(0,3)])).slice(0,4) }
    },
    // Cubes : n³
    () => {
      const n = Math.floor(Math.random()*4)+1
      const seq = Array.from({length:5}, (_,i) => Math.pow(n+i,3))
      const answer = Math.pow(n+5,3)
      const w = [answer+(n+5)**2, answer-1, answer+1].filter(v => v!==answer)
      return { question:`${seq.join(" — ")} — ?`, answer, choices:shuffle(uniq([answer,...w.slice(0,3)])).slice(0,4) }
    },
    // Géométrique ÷2
    () => {
      const mult = (Math.floor(Math.random()*4)+2)*32
      const seq = [mult, mult/2, mult/4, mult/8, mult/16]
      const answer = mult/32
      const w = [answer-1, answer+1, mult/64].filter(v => v>=0 && v!==answer)
      return { question:`${seq.join(" — ")} — ?`, answer, choices:shuffle(uniq([answer,...w.slice(0,3)])).slice(0,4) }
    },
    // Différences croissant de façon quadratique : +1, +4, +9, +16, +25 (sommes de carrés)
    () => {
      const s = Math.floor(Math.random()*10)+1
      const seq = [s, s+1, s+5, s+14, s+30]
      const answer = s+55
      const w = [answer+16, answer-5, answer+25].filter(v => v!==answer)
      return { question:`${seq.join(" — ")} — ?`, answer, choices:shuffle(uniq([answer,...w.slice(0,3)])).slice(0,4) }
    },
    // Alternance +n, −m avec n croissant de 2
    () => {
      const s = Math.floor(Math.random()*20)+30
      const m = Math.floor(Math.random()*5)+2
      const seq = [s, s+3, s+3-m, s+3-m+5, s+3-m+5-m]
      const answer = seq[4]+7
      const w = [answer+2, answer-m, answer-2].filter(v => v!==answer)
      return { question:`${seq.join(" — ")} — ?`, answer, choices:shuffle(uniq([answer,...w.slice(0,3)])).slice(0,4) }
    },
  ]
  return types[Math.floor(Math.random()*types.length)]()
}

// ─── RAISONNEMENT – BANQUE DE QUESTIONS ───────────────────────────────────────

const Q_DEBUTANT = [
  { q:"Tous les policiers portent un uniforme.\nPierre est policier.\nDonc :", a:"Pierre porte un uniforme", c:["Pierre porte un uniforme","Pierre est en civil","On ne peut pas savoir","Pierre ne porte pas d'uniforme"] },
  { q:"Tous les chiens sont des animaux.\nRex est un chien.\nDonc :", a:"Rex est un animal", c:["Rex est un animal","Rex n'est pas un animal","Rex est un chat","On ne sait pas"] },
  { q:"Aucun suspect n'est libre.\nMarc est suspect.\nDonc :", a:"Marc n'est pas libre", c:["Marc est libre","Marc n'est pas libre","Marc peut être libre","On ne sait pas"] },
  { q:"Tous les gardiens ont suivi une formation.\nJulie est gardienne.\nDonc :", a:"Julie a suivi une formation", c:["Julie a suivi une formation","Julie n'est pas formée","Julie est chef","On ne peut pas savoir"] },
  { q:"Tous les véhicules de patrouille sont blancs.\nCette voiture est un véhicule de patrouille.\nDonc :", a:"Cette voiture est blanche", c:["Cette voiture est noire","Cette voiture est blanche","On ne sait pas","Cette voiture n'est pas blanche"] },
  { q:"Aucun délinquant réhabilité ne récidive.\nTom est un délinquant réhabilité.\nDonc :", a:"Tom ne récidivera pas", c:["Tom récidivera","Tom ne récidivera pas","On ne peut pas savoir","Tom est dangereux"] },
  { q:"Tous les officiers ont un grade supérieur aux agents.\nLuc est officier.\nDonc :", a:"Luc a un grade supérieur aux agents", c:["Luc a un grade supérieur aux agents","Luc est agent","Luc n'a pas de grade","On ne sait pas"] },
  { q:"Tous les procès-verbaux sont des documents officiels.\nCe papier est un procès-verbal.\nDonc :", a:"Ce papier est un document officiel", c:["Ce papier est un document officiel","Ce papier est un brouillon","Ce papier n'a aucune valeur","On ne peut pas savoir"] },
  { q:"Aucune arme n'est autorisée dans la salle d'attente.\nCet objet est une arme.\nDonc :", a:"Cet objet n'est pas autorisé dans la salle d'attente", c:["Cet objet est autorisé","Cet objet n'est pas autorisé dans la salle d'attente","Cet objet est dangereux","On ne sait pas"] },
  { q:"Tous les cadets finissent leur formation en juin.\nAna est cadet.\nDonc :", a:"Ana finit sa formation en juin", c:["Ana finit sa formation en juin","Ana abandonne sa formation","Ana est officière","On ne peut pas savoir"] },
  { q:"Tous les agents de nuit portent une lampe.\nSamir est agent de nuit.\nDonc :", a:"Samir porte une lampe", c:["Samir porte une lampe","Samir travaille le jour","Samir n'a pas de lampe","On ne sait pas"] },
]

const Q_INTERMEDIAIRE = [
  { q:"Certains agents sont en mission.\nTous les agents en mission sont armés.\nDonc :", a:"Certains agents sont armés", c:["Tous les agents sont armés","Certains agents sont armés","Aucun agent n'est armé","On ne peut pas conclure"] },
  { q:"Aucun témoin n'est mis en cause.\nCertains témoins connaissent le suspect.\nDonc :", a:"Certaines personnes qui connaissent le suspect ne sont pas mises en cause", c:["Tous les témoins sont suspects","Certaines personnes qui connaissent le suspect ne sont pas mises en cause","Aucun témoin ne connaît le suspect","On ne peut pas conclure"] },
  { q:"Certains policiers sont spécialisés en balistique.\nTous les spécialistes en balistique ont suivi une formation de 2 ans.\nDonc :", a:"Certains policiers ont suivi une formation de 2 ans", c:["Tous les policiers ont une formation de 2 ans","Certains policiers ont suivi une formation de 2 ans","Aucun policier n'est formé","On ne peut pas conclure"] },
  { q:"Aucun coupable ne dit la vérité.\nMarc dit la vérité.\nDonc :", a:"Marc n'est pas coupable", c:["Marc est coupable","Marc n'est pas coupable","Marc ment parfois","On ne peut pas conclure"] },
  { q:"Certains gardiens font des heures supplémentaires.\nTous ceux qui font des heures supplémentaires reçoivent une prime.\nDonc :", a:"Certains gardiens reçoivent une prime", c:["Tous les gardiens reçoivent une prime","Certains gardiens reçoivent une prime","Personne ne reçoit de prime","On ne peut pas conclure"] },
  { q:"Aucun accusé présumé innocent ne peut être détenu sans preuve.\nPaul est présumé innocent.\nDonc :", a:"Paul ne peut être détenu sans preuve", c:["Paul peut être détenu sans preuve","Paul ne peut être détenu sans preuve","Paul est coupable","On ne peut pas conclure"] },
  { q:"Tous les rapports urgents sont traités le jour même.\nCertains rapports sont urgents.\nDonc :", a:"Certains rapports sont traités le jour même", c:["Tous les rapports sont traités le jour même","Certains rapports sont traités le jour même","Aucun rapport n'est traité le jour même","On ne peut pas conclure"] },
  { q:"Certains officiers dirigent des équipes de nuit.\nAucun chef d'équipe de nuit n'est disponible le week-end.\nDonc :", a:"Certains officiers ne sont pas disponibles le week-end", c:["Tous les officiers sont disponibles le week-end","Certains officiers ne sont pas disponibles le week-end","Aucun officier n'est disponible","On ne peut pas conclure"] },
  { q:"Aucune preuve numérique n'est admissible sans certificat.\nCe fichier est une preuve numérique sans certificat.\nDonc :", a:"Ce fichier n'est pas admissible", c:["Ce fichier est admissible","Ce fichier n'est pas admissible","Ce fichier est une preuve valide","On ne peut pas conclure"] },
  { q:"Certains détenus bénéficient d'une remise de peine.\nTous ceux qui en bénéficient ont eu un bon comportement.\nDonc :", a:"Certains détenus ont eu un bon comportement", c:["Tous les détenus ont eu un bon comportement","Certains détenus ont eu un bon comportement","Aucun détenu n'a eu un bon comportement","On ne peut pas conclure"] },
  { q:"Aucun suspect mineur ne comparaît devant le tribunal correctionnel.\nLéa est mineure et suspecte.\nDonc :", a:"Léa ne comparaît pas devant le tribunal correctionnel", c:["Léa comparaît devant le tribunal correctionnel","Léa ne comparaît pas devant le tribunal correctionnel","Léa est jugée comme adulte","On ne peut pas conclure"] },
]

const Q_EXPERT = [
  { q:"Si une infraction est commise avec préméditation, la peine est aggravée.\nPaul a planifié son acte plusieurs jours à l'avance.\nDonc :", a:"La peine de Paul est aggravée", c:["La peine de Paul est réduite","La peine de Paul est aggravée","Paul est acquitté","On ne peut pas conclure"] },
  { q:"Toute personne interpellée doit être informée de ses droits.\nSi elle ne l'est pas, l'interpellation est nulle.\nKarim a été interpellé sans être informé.\nDonc :", a:"L'interpellation de Karim est nulle", c:["L'interpellation de Karim est valide","L'interpellation de Karim est nulle","Karim est libre","On ne peut pas conclure"] },
  { q:"La légitime défense n'est admise que si l'attaque est imminente ET la riposte proportionnelle.\nL'attaque était imminente mais la riposte était disproportionnée.\nDonc :", a:"La légitime défense n'est pas admise", c:["La légitime défense est admise","La légitime défense n'est pas admise","La riposte était justifiée","On ne peut pas conclure"] },
  { q:"Un agent peut fouiller un véhicule uniquement avec réquisition ou en cas de flagrant délit.\nL'agent n'avait pas de réquisition et il n'y avait pas flagrant délit.\nDonc :", a:"La fouille n'était pas légale", c:["La fouille était légale","La fouille n'était pas légale","L'agent avait tous les droits","On ne peut pas conclure"] },
  { q:"Tout témoignage est recevable s'il est spontané ET cohérent.\nCe témoignage est spontané mais incohérent.\nDonc :", a:"Ce témoignage n'est pas recevable", c:["Ce témoignage est recevable","Ce témoignage n'est pas recevable","Ce témoignage est partiellement valide","On ne peut pas conclure"] },
  { q:"Une garde à vue ne peut excéder 24 h sans prolongation autorisée.\nLe suspect est en garde à vue depuis 26 h sans prolongation.\nDonc :", a:"La garde à vue est illégale", c:["La garde à vue est légale","La garde à vue est illégale","Le suspect sera relâché","On ne peut pas conclure"] },
  { q:"Si A implique B et B implique C, alors A implique C.\nLe flagrant délit (A) implique une arrestation immédiate (B).\nL'arrestation immédiate (B) implique une mise en garde à vue (C).\nDonc :", a:"Le flagrant délit implique une mise en garde à vue", c:["Le flagrant délit implique une mise en garde à vue","B n'implique pas C ici","A n'implique pas C","On ne peut pas conclure"] },
  { q:"La perquisition nécessite un mandat, sauf en cas d'urgence absolue.\nIl n'y avait pas d'urgence absolue et aucun mandat n'a été obtenu.\nDonc :", a:"La perquisition était irrégulière", c:["La perquisition était régulière","La perquisition était irrégulière","Le mandat est facultatif","On ne peut pas conclure"] },
  { q:"Un fait non contesté par la défense est réputé acquis.\nLa défense n'a pas contesté la présence de l'accusé sur les lieux.\nDonc :", a:"La présence de l'accusé sur les lieux est réputée acquise", c:["La présence de l'accusé n'est pas établie","La présence de l'accusé sur les lieux est réputée acquise","La défense a tort","On ne peut pas conclure"] },
  { q:"Si le mobile est établi et l'alibi est réfuté, le suspect devient présumé coupable.\nLe mobile de Sofia est établi. Son alibi a été réfuté.\nDonc :", a:"Sofia est présumée coupable", c:["Sofia est innocente","Sofia est présumée coupable","L'enquête doit continuer","On ne peut pas conclure"] },
  { q:"Tout aveu obtenu sous la contrainte est irrecevable.\nL'aveu de Romain a été obtenu sous la contrainte.\nDonc :", a:"L'aveu de Romain est irrecevable", c:["L'aveu de Romain est recevable","L'aveu de Romain est irrecevable","Romain est coupable","On ne peut pas conclure"] },
]

function pickQ(bank: {q:string;a:string;c:string[]}[]): Question {
  const item = bank[Math.floor(Math.random()*bank.length)]
  return { question: item.q, answer: item.a, choices: shuffle(item.c) }
}

// ─── GENERATORS MAP ───────────────────────────────────────────────────────────
type GenFn = () => Question

const GENERATORS: Record<string, Record<Level, GenFn>> = {
  calcul: {
    debutant:      genCalculDebutant,
    intermediaire: genCalculIntermediaire,
    expert:        genCalculExpert,
  },
  "suites-logiques": {
    debutant:      genSuiteDebutant,
    intermediaire: genSuiteIntermediaire,
    expert:        genSuiteExpert,
  },
  raisonnement: {
    debutant:      () => pickQ(Q_DEBUTANT),
    intermediaire: () => pickQ(Q_INTERMEDIAIRE),
    expert:        () => pickQ(Q_EXPERT),
  },
}

// ─── CIRCULAR TIMER SVG ───────────────────────────────────────────────────────
function CircularTimer({ timeLeft, maxTime }: { timeLeft: number; maxTime: number }) {
  const R = 20
  const circ = 2 * Math.PI * R
  const pct  = timeLeft / maxTime
  const offset = circ * (1 - pct)
  const color = timeLeft <= 10 ? "#EF4444" : timeLeft <= maxTime * 0.33 ? "#F59E0B" : "#1147D9"
  return (
    <svg width="56" height="56" viewBox="0 0 56 56">
      <circle cx="28" cy="28" r={R} fill="none" stroke="var(--outline)" strokeWidth="4"/>
      <circle
        cx="28" cy="28" r={R}
        fill="none"
        stroke={color}
        strokeWidth="4"
        strokeDasharray={circ}
        strokeDashoffset={offset}
        strokeLinecap="round"
        transform="rotate(-90 28 28)"
        style={{ transition:"stroke-dashoffset 1s linear, stroke 0.3s" }}
      />
      <text x="28" y="33" textAnchor="middle" fontSize="13" fontWeight="bold" fill={color}>{timeLeft}</text>
    </svg>
  )
}

// ─── MAIN COMPONENT ───────────────────────────────────────────────────────────
export default function PsychoExercice({ type, label, tier: _tier }: { type: string; label: string; tier?: string }) {
  const [phase,    setPhase]    = useState<Phase>("select-level")
  const [level,    setLevel]    = useState<Level>("debutant")
  const [score,    setScore]    = useState(0)
  const [total,    setTotal]    = useState(0)
  const [timeLeft, setTimeLeft] = useState(60)
  const [current,  setCurrent]  = useState<Question | null>(null)
  const [selected, setSelected] = useState<Choice | null>(null)
  const [feedback, setFeedback] = useState<"correct" | "wrong" | null>(null)
  const [maxStreak,setMaxStreak]= useState(0)
  const streakRef = useRef(0)

  const gens   = GENERATORS[type]
  const maxTime = LEVEL_CONFIG[level].time

  const nextQuestion = useCallback(() => {
    if (!gens) return
    setSelected(null)
    setFeedback(null)
    setCurrent(gens[level]())
  }, [gens, level])

  // Timer countdown
  useEffect(() => {
    if (phase !== "playing") return
    const id = setInterval(() => {
      setTimeLeft(t => {
        if (t <= 1) { setPhase("finished"); return 0 }
        return t - 1
      })
    }, 1000)
    return () => clearInterval(id)
  }, [phase])

  // Save best score
  useEffect(() => {
    if (phase !== "finished" || total === 0) return
    const key = `copiq_psycho_best_${type}_${level}`
    const raw = localStorage.getItem(key)
    const prev = raw ? JSON.parse(raw) : null
    const pct  = score / total
    const prevPct = prev ? prev.score / prev.total : -1
    if (pct > prevPct) {
      localStorage.setItem(key, JSON.stringify({ score, total, date: new Date().toISOString() }))
    }
  }, [phase]) // eslint-disable-line

  function start(lvl: Level) {
    setLevel(lvl)
    setScore(0)
    setTotal(0)
    setTimeLeft(LEVEL_CONFIG[lvl].time)
    setFeedback(null)
    setSelected(null)
    streakRef.current = 0
    setMaxStreak(0)
    if (gens) setCurrent(gens[lvl]())
    setPhase("playing")
  }

  function handleSelect(choice: Choice) {
    if (selected !== null || !current || phase !== "playing") return
    setSelected(choice)
    const correct = String(choice) === String(current.answer)
    setFeedback(correct ? "correct" : "wrong")
    setTotal(t => t + 1)
    if (correct) {
      setScore(s => s + 1)
      streakRef.current += 1
      setMaxStreak(m => Math.max(m, streakRef.current))
    } else {
      streakRef.current = 0
    }
    setTimeout(nextQuestion, 700)
  }

  // ── No generator ──────────────────────────────────────────────────────────
  if (!gens) {
    return (
      <div className="rounded-2xl border border-[var(--outline)] bg-[var(--surface)] p-8 text-center">
        <p className="text-[var(--on-surface-muted)] text-sm">Ce type d&apos;exercice arrive bientôt !</p>
      </div>
    )
  }

  // ── SÉLECTION DU NIVEAU ───────────────────────────────────────────────────
  if (phase === "select-level") {
    return (
      <div className="rounded-2xl border border-[var(--outline)] bg-[var(--surface)] p-8 text-center">
        <div className="text-5xl mb-4">🧠</div>
        <h2 className="text-2xl font-bold text-[var(--on-surface)] mb-2">{label}</h2>
        <p className="text-[var(--on-surface-muted)] text-sm mb-8">Choisissez votre niveau de difficulté</p>

        <div className="grid grid-cols-3 gap-3 mb-8 max-w-sm mx-auto">
          {(["debutant","intermediaire","expert"] as Level[]).map(lvl => {
            const cfg = LEVEL_CONFIG[lvl]
            const active = level === lvl
            return (
              <button
                key={lvl}
                onClick={() => setLevel(lvl)}
                className={`rounded-xl py-4 px-2 border-2 transition-all flex flex-col items-center gap-1 ${
                  active
                    ? "border-[#1147D9] bg-[#1147D9]/10 text-[#1147D9]"
                    : "border-[var(--outline)] text-[var(--on-surface-muted)] hover:border-[#1147D9]/40"
                }`}
              >
                <span className="font-bold text-sm">{cfg.label}</span>
                <span className="text-xs opacity-70">{cfg.time}s</span>
              </button>
            )
          })}
        </div>

        <button
          onClick={() => start(level)}
          className="px-10 py-3.5 rounded-xl bg-[#1147D9] text-white font-bold hover:bg-[#1A55E6] transition-all text-base"
        >
          Commencer ({LEVEL_CONFIG[level].time}s)
        </button>
      </div>
    )
  }

  // ── RÉSULTATS ─────────────────────────────────────────────────────────────
  if (phase === "finished") {
    const pct   = total > 0 ? Math.round((score / total) * 100) : 0
    const color = pct >= 80 ? "#22C55E" : pct >= 60 ? "#F59E0B" : "#EF4444"
    const msg   = pct >= 80
      ? "Excellent ! Vous maîtrisez ce niveau."
      : pct >= 60
        ? "Bon résultat. Continuez à vous entraîner !"
        : "Encouragez-vous ! La régularité paye."
    return (
      <div className="rounded-2xl border border-[var(--outline)] bg-[var(--surface)] p-8 text-center">
        <div className="text-5xl mb-3">{pct >= 80 ? "🏆" : pct >= 60 ? "👍" : "💪"}</div>
        <h2 className="text-xl font-bold text-[var(--on-surface)] mb-1">Temps écoulé !</h2>

        <div className="text-6xl font-black my-3" style={{ color }}>{pct}%</div>

        <p className="font-semibold text-[var(--on-surface)] mb-1">{score} / {total} bonnes réponses</p>
        <p className="text-sm text-[var(--on-surface-muted)] mb-1">
          Niveau : <span className="font-semibold">{LEVEL_CONFIG[level].label}</span>
        </p>
        <p className="text-sm text-[var(--on-surface-muted)] mb-1">
          Série max : <span className="font-bold text-[var(--on-surface)]">{maxStreak}</span> consécutives
        </p>
        <p className="text-xs text-[var(--on-surface-muted)] mt-2 mb-8">{msg}</p>

        <div className="flex gap-3 justify-center flex-wrap">
          <button
            onClick={() => start(level)}
            className="flex items-center gap-2 px-6 py-3 rounded-xl bg-[#1147D9] text-white font-bold hover:bg-[#1A55E6] transition-all"
          >
            <RotateCcw size={15}/> Réessayer ({LEVEL_CONFIG[level].label})
          </button>
          <button
            onClick={() => setPhase("select-level")}
            className="flex items-center gap-2 px-6 py-3 rounded-xl border border-[var(--outline)] text-[var(--on-surface)] font-semibold hover:border-[#1147D9]/40 transition-all"
          >
            Changer de niveau
          </button>
        </div>
      </div>
    )
  }

  // ── EN JEU ────────────────────────────────────────────────────────────────
  const currentStreak = streakRef.current
  return (
    <div className="space-y-4">
      {/* Header */}
      <div className="rounded-xl border border-[var(--outline)] bg-[var(--surface)] p-4 flex items-center justify-between">
        <div className="flex flex-col">
          <span className="text-xs text-[var(--on-surface-muted)] uppercase tracking-wide">
            {LEVEL_CONFIG[level].label}
          </span>
          <span className="text-lg font-black text-[var(--on-surface)]">Score : {score} / {total}</span>
          {currentStreak >= 2 && (
            <span className="text-xs text-[#F59E0B] font-semibold">🔥 Série de {currentStreak} !</span>
          )}
        </div>
        <CircularTimer timeLeft={timeLeft} maxTime={maxTime}/>
      </div>

      {/* Question */}
      {current && (
        <div className="rounded-2xl border border-[var(--outline)] bg-[var(--surface)] p-6">
          <p className="text-xl font-bold text-[var(--on-surface)] text-center mb-6 leading-relaxed whitespace-pre-line">
            {current.question}
          </p>

          <div className="grid grid-cols-2 gap-3">
            {current.choices.map((choice, i) => {
              const isSelected = String(selected) === String(choice)
              const isCorrect  = String(choice)   === String(current.answer)
              let cls = "w-full py-4 px-3 rounded-xl border-2 text-sm font-semibold transition-all text-center "
              if (selected !== null) {
                if (isCorrect)     cls += "border-[#22C55E] bg-[#22C55E]/15 text-[#22C55E]"
                else if (isSelected) cls += "border-red-500 bg-red-500/15 text-red-500"
                else                 cls += "border-[var(--outline)] text-[var(--on-surface-muted)] opacity-40"
              } else {
                cls += "border-[var(--outline)] text-[var(--on-surface)] hover:border-[#1147D9] hover:bg-[#1147D9]/5 cursor-pointer"
              }
              return (
                <button key={i} onClick={() => handleSelect(choice)} disabled={selected !== null} className={cls}>
                  {String(choice)}
                </button>
              )
            })}
          </div>

          {feedback && (
            <div className={`flex items-center justify-center gap-2 mt-4 text-sm font-semibold ${feedback === "correct" ? "text-[#22C55E]" : "text-red-500"}`}>
              {feedback === "correct"
                ? "✓ Correct !"
                : `✗ Réponse correcte : ${current.answer}`}
            </div>
          )}
        </div>
      )}
    </div>
  )
}
