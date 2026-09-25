"use client"

import { useEffect, useState, type ComponentType } from "react"
import { Archive, Bug, CheckCircle2, ChevronRight, ClipboardCheck, Eye, FileQuestion, Flag, GraduationCap, Inbox, Mail, MessageSquareMore, RotateCcw, Search, ShieldCheck, Sparkles, Trash2 } from "lucide-react"
import toast from "react-hot-toast"
import { supportApi } from "@/lib/admin/api"
import { Badge, Button, Card, ErrorBox, Loading, PageHeader, useAsync } from "@/components/admin/admin-ui"
import { ContentReportInspector } from "./content-report-inspector"

type Report = { kind:string; id:string; created_at:string; status:string; module?:string|null; category?:string|null; question_id?:string|null; question?:string|null; message?:string|null; report_type?:string|null; email?:string|null; archived?:boolean }
type Icon = ComponentType<{ size?:number; className?:string }>

const KINDS:{value:string;label:string;icon:Icon}[] = [
  {value:"",label:"Tous",icon:Inbox},{value:"cas_pratique",label:"Cas pratiques",icon:ClipboardCheck},
  {value:"question",label:"Questions de quiz",icon:FileQuestion},{value:"culture",label:"Culture générale",icon:GraduationCap},
  {value:"psy",label:"Psychotechniques",icon:Sparkles},{value:"bug",label:"Bugs",icon:Bug},
  {value:"contact",label:"Contacts",icon:Mail},{value:"forum",label:"Forum",icon:MessageSquareMore},
]
const STATUSES = [
  {value:"new",label:"Nouveaux",icon:Flag},{value:"resolved",label:"Traités",icon:CheckCircle2},
  {value:"archived",label:"Archivés",icon:Archive},{value:"",label:"Tous",icon:Inbox},
]
const KIND_LABELS = Object.fromEntries(KINDS.map(({value,label})=>[value,label]))

export default function SignalementsPage(){
  const [kind,setKind]=useState(""); const [status,setStatus]=useState("new"); const [search,setSearch]=useState("");
  const [debouncedSearch,setDebouncedSearch]=useState(""); const [selected,setSelected]=useState<Report|null>(null)
  useEffect(()=>{const timer=setTimeout(()=>setDebouncedSearch(search.trim()),350);return()=>clearTimeout(timer)},[search])
  const {data,error,loading,reload}=useAsync(()=>supportApi.reports(kind,status,debouncedSearch) as Promise<Report[]>,[kind,status,debouncedSearch])
  const resetFilters=()=>{setKind("");setStatus("");setSearch("")}

  return <>
    <PageHeader title="Centre de correction du contenu" subtitle="Une vue de contrôle unique pour examiner, corriger et clôturer chaque signalement."
      action={<div className="hidden items-center gap-2 rounded-full border border-[var(--outline-variant)] bg-[var(--surface)]/70 px-3 py-2 text-xs text-[var(--on-surface-muted)] shadow-sm lg:flex"><span className="relative flex h-2 w-2"><span className="absolute inline-flex h-full w-full animate-ping rounded-full bg-[var(--success)] opacity-60"/><span className="relative h-2 w-2 rounded-full bg-[var(--success)]"/></span>Synchronisé avec Supabase</div>}/>

    <Card className="relative mb-5 overflow-hidden p-5 md:p-6">
      <div className="pointer-events-none absolute -right-16 -top-24 h-64 w-64 rounded-full bg-[var(--brand)]/12 blur-3xl"/>
      <div className="relative grid gap-5 xl:grid-cols-[1fr_auto] xl:items-center">
        <div><div className="mb-3 flex items-center gap-2"><span className="grid h-10 w-10 place-items-center rounded-xl bg-[var(--brand)]/12 text-[var(--brand)]"><ShieldCheck size={20}/></span><div><p className="text-sm font-semibold">File de traitement</p><p className="text-xs text-[var(--on-surface-faint)]">Chaque action reste tracée et reliée au contenu source.</p></div></div>
          <div className="flex flex-wrap items-center gap-2 text-xs font-medium text-[var(--on-surface-muted)]"><WorkflowStep number="01" label="Identifier" active/><ChevronRight size={15}/><WorkflowStep number="02" label="Corriger"/><ChevronRight size={15}/><WorkflowStep number="03" label="Clôturer & informer"/></div>
        </div>
        <div className="flex min-w-40 items-end gap-2 rounded-2xl border border-[var(--outline-variant)] bg-[var(--surface-container)]/70 px-5 py-4"><strong className="text-3xl font-semibold tracking-[-.04em] tabular-nums">{loading?"—":(data?.length??0)}</strong><span className="pb-1 text-xs text-[var(--on-surface-muted)]">résultat{data?.length===1?"":"s"}<br/>affiché{data?.length===1?"":"s"}</span></div>
      </div>
    </Card>

    <Card className="mb-5 p-3 md:p-4">
      <div className="mb-4 flex gap-2 overflow-x-auto pb-1" role="tablist" aria-label="Types de signalements">{KINDS.map(({value,label,icon:KindIcon})=><button key={value} type="button" role="tab" aria-selected={kind===value} onClick={()=>setKind(value)} className={`flex min-h-11 shrink-0 cursor-pointer items-center gap-2 rounded-xl px-3.5 text-sm font-medium transition duration-200 focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-[var(--brand)] ${kind===value?"bg-[var(--brand)] text-white shadow-lg shadow-blue-600/15":"text-[var(--on-surface-muted)] hover:bg-[var(--surface-container)] hover:text-[var(--on-surface)]"}`}><KindIcon size={16}/>{label}</button>)}</div>
      <div className="grid gap-3 border-t border-[var(--outline-variant)] pt-4 lg:grid-cols-[minmax(280px,1fr)_auto]">
        <label className="relative"><Search className="pointer-events-none absolute left-4 top-1/2 -translate-y-1/2 text-[var(--on-surface-faint)]" size={18}/><span className="sr-only">Rechercher un signalement</span><input placeholder="Rechercher une question, un email ou un identifiant…" value={search} onChange={e=>setSearch(e.target.value)} className="min-h-12 w-full rounded-xl border border-[var(--outline)] bg-[var(--surface-container)] py-3 pl-11 pr-4 text-sm outline-none transition focus:border-[var(--brand)] focus:ring-4 focus:ring-[var(--brand)]/10"/></label>
        <div className="grid grid-cols-2 gap-1 rounded-xl bg-[var(--surface-container)] p-1 sm:grid-cols-4" role="tablist" aria-label="État des signalements">{STATUSES.map(({value,label,icon:StatusIcon})=><button key={value} type="button" role="tab" aria-selected={status===value} onClick={()=>setStatus(value)} className={`flex min-h-10 cursor-pointer items-center justify-center gap-1.5 rounded-lg px-3 text-sm font-medium transition focus-visible:outline-2 focus-visible:outline-[var(--brand)] ${status===value?"bg-[var(--surface)] text-[var(--brand)] shadow-sm":"text-[var(--on-surface-muted)] hover:text-[var(--on-surface)]"}`}><StatusIcon size={15}/>{label}</button>)}</div>
      </div>
    </Card>

    {error&&<ErrorBox error={error}/>} {loading&&<Card><Loading label="Chargement des signalements…"/></Card>}
    {data&&data.length===0&&<Card className="relative overflow-hidden px-6 py-14 text-center"><div className="pointer-events-none absolute inset-x-0 top-0 mx-auto h-32 w-64 rounded-full bg-[var(--brand)]/10 blur-3xl"/><span className="relative mx-auto grid h-16 w-16 place-items-center rounded-2xl border border-[var(--outline-variant)] bg-[var(--surface-container)] text-[var(--brand)] shadow-lg"><Inbox size={28}/></span><h2 className="relative mt-5 text-lg font-semibold">Aucun signalement à afficher</h2><p className="relative mx-auto mt-1 max-w-md text-sm leading-6 text-[var(--on-surface-muted)]">La file est vide pour la catégorie et l’état sélectionnés. Modifiez les filtres ou affichez l’ensemble des demandes.</p>{(kind||status||search)&&<Button variant="ghost" className="relative mt-5" onClick={resetFilters}><RotateCcw size={16}/>Réinitialiser les filtres</Button>}</Card>}
    <div className="space-y-3">{(data??[]).map(r=><ReportCard key={`${r.kind}-${r.id}`} r={r} onDone={reload} onInspect={()=>setSelected(r)}/>)}</div>
    {selected&&<ContentReportInspector report={selected} onClose={()=>setSelected(null)} onChanged={reload}/>} 
  </>
}

function WorkflowStep({number,label,active=false}:{number:string;label:string;active?:boolean}){return <span className={`inline-flex min-h-8 items-center gap-2 rounded-full border px-3 ${active?"border-[var(--brand)]/25 bg-[var(--brand)]/10 text-[var(--brand)]":"border-[var(--outline-variant)] bg-[var(--surface-container)]"}`}><span className="text-[10px] tabular-nums opacity-70">{number}</span>{label}</span>}

function ReportCard({r,onDone,onInspect}:{r:Report;onDone:()=>void;onInspect:()=>void}){
  const [busy,setBusy]=useState(false); const [comment,setComment]=useState(""); const [err,setErr]=useState<unknown>(null)
  const KindIcon=KINDS.find(({value})=>value===r.kind)?.icon??Flag; const isResolved=r.status==="resolved"
  async function resolve(archive:boolean){setBusy(true);setErr(null);try{const result=await supportApi.resolveReportWithEmail(r.kind,r.id,archive,comment||undefined);if(result.email_sent)toast.success(archive?"Signalement traité, archivé et email envoyé.":"Signalement traité et email envoyé.");else toast.error("Signalement traité, mais l’email automatique n’a pas pu être envoyé.");onDone()}catch(e){setErr(e)}finally{setBusy(false)}}
  async function deleteReport(){if(!window.confirm(`Supprimer définitivement le signalement #${r.id} de ${r.email??"cet utilisateur"} ?\n\nLa ligne du signalement sera supprimée de Supabase. La question restera intacte.`))return;setBusy(true);setErr(null);try{const result=await supportApi.deleteReport(r.kind,r.id);if(!result.ok)throw new Error("Supabase n’a supprimé aucune ligne.");toast.success(`Signalement #${r.id} supprimé de Supabase.`);onDone()}catch(e){setErr(e);toast.error(e instanceof Error?e.message:"La suppression a échoué.")}finally{setBusy(false)}}
  async function reopen(){setBusy(true);setErr(null);try{await supportApi.setReportStatus(r.kind,r.id,"new",false);toast.success("Signalement réouvert.");onDone()}catch(e){setErr(e)}finally{setBusy(false)}}
  return <Card className="group overflow-hidden transition duration-200 hover:-translate-y-0.5 hover:border-[var(--brand)]/25 hover:shadow-xl hover:shadow-blue-950/10"><div className="flex"><div className={`w-1 shrink-0 ${isResolved?"bg-[var(--success)]":"bg-[var(--brand)]"}`}/><div className="min-w-0 flex-1 p-4 md:p-5">
    <div className="flex flex-col gap-4 lg:flex-row lg:items-start lg:justify-between"><div className="flex min-w-0 gap-3.5"><span className="grid h-11 w-11 shrink-0 place-items-center rounded-xl bg-[var(--brand)]/10 text-[var(--brand)] transition group-hover:scale-105"><KindIcon size={20}/></span><div className="min-w-0"><div className="mb-2 flex flex-wrap items-center gap-1.5"><Badge tone="brand">{KIND_LABELS[r.kind]??r.kind}</Badge>{r.module&&<Badge>{r.module}</Badge>}{r.report_type&&<Badge tone="warn">{r.report_type.replaceAll("_"," ")}</Badge>}{isResolved&&<Badge tone="good"><CheckCircle2 size={11} className="mr-1"/>Traité</Badge>}</div><h2 className="max-w-4xl text-sm font-semibold leading-6 md:text-base">{r.question||r.message||"Signalement sans titre"}</h2><div className="mt-2 flex flex-wrap gap-x-3 gap-y-1 text-xs text-[var(--on-surface-faint)]"><span>{r.email??"Utilisateur non identifié"}</span><span>•</span><span>Signalement #{r.id}</span>{r.question_id&&<><span>•</span><span>Contenu #{r.question_id}</span></>}</div></div></div><time className="shrink-0 rounded-lg bg-[var(--surface-container)] px-2.5 py-1.5 text-xs text-[var(--on-surface-faint)]" dateTime={r.created_at}>{new Date(r.created_at).toLocaleString("fr-FR")}</time></div>
    {r.message&&r.question&&<div className="mt-4 rounded-xl border border-[var(--outline-variant)] bg-[var(--surface-container)]/70 p-3.5"><p className="mb-1 text-[10px] font-semibold uppercase tracking-[.14em] text-[var(--on-surface-faint)]">Message de l’utilisateur</p><p className="whitespace-pre-wrap text-sm leading-6">{r.message}</p></div>}
    {!isResolved?<div className="mt-4 border-t border-[var(--outline-variant)] pt-4"><label className="mb-3 block"><span className="sr-only">Commentaire interne</span><input value={comment} onChange={e=>setComment(e.target.value)} placeholder="Ajouter un commentaire interne avant traitement…" className="min-h-11 w-full rounded-xl border border-[var(--outline)] bg-[var(--surface-container)] px-3.5 py-2.5 text-sm outline-none transition focus:border-[var(--brand)] focus:ring-4 focus:ring-[var(--brand)]/10"/></label><ErrorBox error={err}/><div className="flex flex-wrap items-center gap-2"><Button variant="ghost" onClick={onInspect} disabled={busy}><Eye size={16}/>Examiner et corriger</Button><Button onClick={()=>resolve(false)} disabled={busy}><CheckCircle2 size={16}/>Marquer traité</Button><Button variant="ghost" onClick={()=>resolve(true)} disabled={busy}><Archive size={16}/>Traiter &amp; archiver</Button><Button variant="ghost" className="ml-auto text-[var(--danger)] hover:border-[var(--danger)]/30 hover:bg-[var(--danger)]/8" onClick={()=>void deleteReport()} disabled={busy}><Trash2 size={16}/>Supprimer</Button></div></div>:<div className="mt-4 flex flex-wrap gap-2 border-t border-[var(--outline-variant)] pt-4"><Button onClick={onInspect}><Eye size={16}/>Voir la correction</Button><Button variant="ghost" disabled={busy} onClick={()=>void reopen()}><RotateCcw size={16}/>Réouvrir</Button><Button variant="ghost" className="ml-auto text-[var(--danger)] hover:border-[var(--danger)]/30 hover:bg-[var(--danger)]/8" onClick={()=>void deleteReport()} disabled={busy}><Trash2 size={16}/>Supprimer</Button></div>}
  </div></div></Card>
}
