"use client"

import { useEffect, useMemo, useState } from "react"
import { AlertTriangle, Check, Database, FileClock, Pencil, Save, Trash2, X } from "lucide-react"
import toast from "react-hot-toast"
import { supportApi, type ReportInspection } from "@/lib/admin/api"
import { Badge, Button, ErrorBox, Loading } from "@/components/admin/admin-ui"

type Report = {
  kind: string; id: string; status: string; question_id?: string | null; question?: string | null
  message?: string | null; report_type?: string | null; category?: string | null; email?: string | null
}

const asText = (value: unknown) => value == null ? "" : String(value)
const asOptions = (value: unknown): string[] => Array.isArray(value)
  ? value.map((v) => typeof v === "object" && v ? asText((v as Record<string, unknown>).label ?? (v as Record<string, unknown>).key) : asText(v))
  : []
const editableTarget = (kind: string, target: Record<string, unknown> | null) => {
  if (!target) return {}
  return kind === "cas_pratique" && target.question && typeof target.question === "object"
    ? target.question as Record<string, unknown>
    : target
}

export function ContentReportInspector({ report, onClose, onChanged }: {
  report: Report; onClose: () => void; onChanged: () => void
}) {
  const [inspection, setInspection] = useState<ReportInspection | null>(null)
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<unknown>(null)
  const [editing, setEditing] = useState(false)
  const [draft, setDraft] = useState<Record<string, unknown>>({})
  const [busy, setBusy] = useState<string | null>(null)
  const [note, setNote] = useState("")
  const [confirm, setConfirm] = useState<"report" | "target" | null>(null)

  async function load() {
    setLoading(true); setError(null)
    try {
      const data = await supportApi.inspectReport(report.kind, report.id)
      setInspection(data); setDraft(editableTarget(report.kind, data.target))
    } catch (e) { setError(e) } finally { setLoading(false) }
  }
  useEffect(() => {
    let cancelled = false
    supportApi.inspectReport(report.kind, report.id).then((data) => {
      if (!cancelled) { setInspection(data); setDraft(editableTarget(report.kind, data.target)) }
    }).catch((e: unknown) => { if (!cancelled) setError(e) })
      .finally(() => { if (!cancelled) setLoading(false) })
    return () => { cancelled = true }
  }, [report.kind, report.id])
  useEffect(() => {
    const fn = (e: KeyboardEvent) => { if (e.key === "Escape" && !busy) onClose() }
    document.addEventListener("keydown", fn); return () => document.removeEventListener("keydown", fn)
  }, [busy, onClose])

  const changed = useMemo(() => inspection?.target
    ? JSON.stringify(draft) !== JSON.stringify(editableTarget(report.kind, inspection.target)) : false, [draft, inspection, report.kind])
  const options = asOptions(draft.options)
  const contentEditable = !!inspection?.can_edit && ["psy", "culture", "cas_pratique"].includes(report.kind)

  function field(key: string, value: unknown) { setDraft((d) => ({ ...d, [key]: value })) }
  async function action(name: string, fn: () => Promise<unknown>, message: string) {
    if (busy) return
    setBusy(name); setError(null)
    try { await fn(); toast.success(message); await load(); onChanged() }
    catch (e) { setError(e); toast.error(e instanceof Error ? e.message : "L’action a échoué") }
    finally { setBusy(null) }
  }
  async function save(resolve: boolean) {
    if (!inspection?.target) return
    await action(resolve ? "save-resolve" : "save", async () => {
      const patch = editorPatch(report.kind, draft, options)
      if (report.kind !== "cas_pratique" && options.length > 0 && !options.includes(asText(patch.answer))) {
        throw new Error("La bonne réponse doit correspondre exactement à l’un des choix proposés.")
      }
      const result = await supportApi.updateReportTarget(report.kind, report.id, inspection.target!, patch, false)
      if (!result.ok || !result.target) throw new Error("Supabase n’a pas confirmé la modification.")
      if (resolve) {
        const notification = await supportApi.resolveReportWithEmail(report.kind, report.id, false, note || undefined)
        if (!notification.email_sent) toast.error("Contenu corrigé, mais l’email automatique n’a pas pu être envoyé.")
      }
      setEditing(false)
    }, resolve ? "Contenu corrigé et signalement traité." : "Contenu corrigé dans Supabase.")
  }
  async function disableTarget() {
    if (!inspection?.target) return
    const current = editableTarget(report.kind, inspection.target)
    await action("disable", async () => {
      const patch = editorPatch(report.kind, { ...current, is_active: false }, asOptions(current.options))
      await supportApi.updateReportTarget(report.kind, report.id, inspection.target!, patch, false)
    }, "Question désactivée.")
  }
  async function deleteConfirmed(type: "report" | "target") {
    if (busy) return
    setBusy(`delete-${type}`); setError(null)
    try {
      const result = type === "report"
        ? await supportApi.deleteReport(report.kind, report.id)
        : await supportApi.deleteReportTarget(report.kind, report.id)
      if (!result.ok) throw new Error("Supabase n’a supprimé aucune ligne.")
      toast.success(type === "report" ? "Signalement supprimé de Supabase." : "Question supprimée définitivement.")
      setConfirm(null)
      onChanged()
      onClose()
    } catch (e) {
      setError(e)
      toast.error(e instanceof Error ? e.message : "La suppression a échoué.")
    } finally { setBusy(null) }
  }

  return <div className="fixed inset-0 z-50 flex justify-end bg-slate-950/60 backdrop-blur-sm" role="dialog" aria-modal="true" aria-labelledby="inspector-title">
    <button className="absolute inset-0 cursor-default" aria-label="Fermer l’inspecteur" onClick={() => !busy && onClose()} />
    <section className="relative h-full w-full max-w-4xl overflow-y-auto border-l border-[var(--outline)] bg-[var(--surface)] shadow-2xl">
      <header className="sticky top-0 z-10 flex items-start justify-between gap-4 border-b border-[var(--outline-variant)] bg-[var(--surface)]/95 p-5 backdrop-blur-xl">
        <div><div className="mb-1 flex flex-wrap gap-2"><Badge tone="brand">{report.kind}</Badge><Badge tone={report.status === "resolved" ? "good" : "warn"}>{report.status}</Badge>{report.report_type && <Badge>{report.report_type}</Badge>}</div>
          <h2 id="inspector-title" className="text-xl font-semibold">Examiner et corriger</h2><p className="text-sm text-[var(--on-surface-muted)]">Signalement #{report.id}</p></div>
        <button className="grid h-11 w-11 place-items-center rounded-xl hover:bg-[var(--surface-container)] focus-visible:outline-2 focus-visible:outline-[var(--brand)]" onClick={onClose} disabled={!!busy} aria-label="Fermer"><X /></button>
      </header>
      <div className="space-y-5 p-5 md:p-6">
        {loading && <Loading />}{error != null && <ErrorBox error={error} />}
        {inspection && <>
          <Panel title="Signalé par l’utilisateur" icon={<AlertTriangle size={18} />}>
            <dl className="grid gap-3 text-sm sm:grid-cols-2"><Meta label="Motif" value={report.report_type}/><Meta label="Utilisateur" value={report.email}/><Meta label="ID signalement" value={report.id}/><Meta label="ID contenu" value={report.question_id}/></dl>
            {report.message && <p className="mt-4 whitespace-pre-wrap rounded-xl bg-[var(--surface-container)] p-4 text-sm">{report.message}</p>}
          </Panel>
          <Panel title="Ressource concernée" icon={<Database size={18} />}>
            <dl className="grid gap-3 text-sm sm:grid-cols-3"><Meta label="Table source" value={inspection.target_table}/><Meta label="ID" value={report.question_id}/><Meta label="Catégorie" value={report.category}/></dl>
            {!inspection.target_found && <div className="mt-4 flex gap-3 rounded-xl border border-amber-500/30 bg-amber-500/10 p-4 text-sm"><AlertTriangle className="shrink-0 text-amber-600"/><div><b>Ressource introuvable</b><p>Le signalement reste traitable ou supprimable, mais aucune modification de contenu ne sera tentée.</p></div></div>}
          </Panel>
          {inspection.target && <Panel title={editing ? "Modification contrôlée" : "Contenu actuel"} icon={editing ? <Pencil size={18}/> : <Check size={18}/>} actions={contentEditable && <div className="flex flex-wrap gap-2">{report.kind === "psy" && editableTarget(report.kind, inspection.target).is_active !== false && <Button variant="ghost" disabled={!!busy} onClick={() => void disableTarget()}>Désactiver</Button>}<Button variant="ghost" onClick={() => { setEditing(!editing); setDraft(editableTarget(report.kind, inspection.target)) }}>{editing ? "Annuler" : "Modifier le contenu"}</Button></div>}>
            {editing ? <Editor kind={report.kind} category={report.category} draft={draft} options={options} field={field}/> : <ContentPreview kind={report.kind} target={inspection.target}/>} 
            {editing && <div className="mt-5 flex flex-wrap gap-2 border-t border-[var(--outline-variant)] pt-4"><Button onClick={() => void save(false)} disabled={!changed || !!busy}><Save size={16}/>{busy === "save" ? "Enregistrement…" : "Enregistrer"}</Button><Button variant="ghost" onClick={() => void save(true)} disabled={!changed || !!busy}>{busy === "save-resolve" ? "Enregistrement…" : "Enregistrer et traiter"}</Button></div>}
          </Panel>}
          <Panel title="Note et traitement" icon={<FileClock size={18}/>}>
            <label className="text-sm font-medium" htmlFor="admin-note">Note interne</label><textarea id="admin-note" value={note} onChange={(e) => setNote(e.target.value)} className="mt-2 min-h-24 w-full rounded-xl border border-[var(--outline)] bg-[var(--surface)] p-3 text-sm focus:outline-2 focus:outline-[var(--brand)]" placeholder="Cette note sera conservée et journalisée."/>
            <div className="mt-3 flex flex-wrap gap-2"><Button variant="ghost" disabled={!note.trim() || !!busy} onClick={() => void action("note", async()=>{await supportApi.addReportNote(report.kind,report.id,note);setNote("")},"Note enregistrée.")}>Ajouter la note</Button>
              {report.status !== "resolved" ? <><Button disabled={!!busy} onClick={() => void action("resolve",()=>supportApi.resolveReportWithEmail(report.kind,report.id,false,note||undefined),"Signalement traité et email envoyé.")}>Marquer traité</Button><Button variant="ghost" disabled={!!busy} onClick={() => void action("archive",()=>supportApi.resolveReportWithEmail(report.kind,report.id,true,note||undefined),"Signalement traité, archivé et email envoyé.")}>Traiter et archiver</Button></> : <Button disabled={!!busy} onClick={() => void action("reopen",()=>supportApi.setReportStatus(report.kind,report.id,"new",false,note||undefined),"Signalement réouvert.")}>Réouvrir</Button>}
            </div>
          </Panel>
          <Panel title="Historique interne" icon={<FileClock size={18}/>}>
            {inspection.notes.length === 0 && inspection.history.length === 0 ? <p className="text-sm text-[var(--on-surface-muted)]">Aucun événement enregistré.</p> : <div className="space-y-2">{inspection.notes.map((n,i)=><div key={`n${i}`} className="rounded-xl bg-[var(--surface-container)] p-3 text-sm"><b>Note administrateur</b><p className="whitespace-pre-wrap">{asText(n.note)}</p><small>{formatDate(n.created_at)}</small></div>)}{inspection.history.map((h,i)=><details key={`h${i}`} className="rounded-xl border border-[var(--outline-variant)] p-3 text-sm"><summary className="cursor-pointer font-medium">{asText(h.action)} · {formatDate(h.created_at)}</summary><pre className="mt-2 max-h-60 overflow-auto text-xs">{JSON.stringify({avant:h.old_value,apres:h.new_value},null,2)}</pre></details>)}</div>}
          </Panel>
          <Panel title="Zone dangereuse" icon={<Trash2 size={18}/>}> 
            <div className="flex flex-wrap gap-2"><Button variant="ghost" disabled={!inspection.can_delete_report || !!busy} onClick={() => setConfirm("report")}><Trash2 size={16}/>Supprimer le signalement</Button>{inspection.target_found && <Button variant="ghost" disabled={!inspection.can_delete_target || !!busy} onClick={() => setConfirm("target")}><Trash2 size={16}/>Supprimer définitivement la question</Button>}</div>
            {!inspection.can_delete_target && inspection.target_found && <p className="mt-2 text-xs text-[var(--on-surface-muted)]">La suppression d’une question est réservée au rôle Owner.</p>}
          </Panel>
        </>}
      </div>
      {confirm && <ConfirmDelete type={confirm} table={confirm === "report" ? "table du signalement" : inspection?.target_table} id={confirm === "report" ? report.id : report.question_id} busy={!!busy} onCancel={()=>setConfirm(null)} onConfirm={()=>void deleteConfirmed(confirm)}/>} 
    </section>
  </div>
}

function Panel({title,icon,actions,children}:{title:string;icon:React.ReactNode;actions?:React.ReactNode;children:React.ReactNode}) { return <section className="rounded-2xl border border-[var(--outline-variant)] bg-[var(--surface)] p-4 shadow-sm md:p-5"><div className="mb-4 flex items-center gap-2 text-[var(--brand)]">{icon}<h3 className="font-semibold text-[var(--on-surface)]">{title}</h3><div className="ml-auto">{actions}</div></div>{children}</section> }
function Meta({label,value}:{label:string;value:unknown}) { return <div><dt className="text-xs uppercase tracking-wide text-[var(--on-surface-faint)]">{label}</dt><dd className="mt-0.5 break-all font-medium">{asText(value)||"—"}</dd></div> }
function Input({label,value,onChange,area=false}:{label:string;value:unknown;onChange:(v:string)=>void;area?:boolean}) { const cls="mt-1 w-full rounded-xl border border-[var(--outline)] bg-[var(--surface)] px-3 py-2.5 text-sm focus:outline-2 focus:outline-[var(--brand)]"; return <label className="block text-sm font-medium">{label}{area?<textarea className={`${cls} min-h-24`} value={asText(value)} onChange={e=>onChange(e.target.value)}/>:<input className={cls} value={asText(value)} onChange={e=>onChange(e.target.value)}/>}</label> }
function Editor({kind,category,draft,options,field}:{kind:string;category?:string|null;draft:Record<string,unknown>;options:string[];field:(k:string,v:unknown)=>void}) {
  if(kind==="psy"&&category==="attention_visuelle") return <div className="grid gap-4"><Input label="Texte A" value={draft.text_a} onChange={v=>field("text_a",v)}/><Input label="Texte B" value={draft.text_b} onChange={v=>field("text_b",v)}/><label className="flex items-center gap-2 text-sm"><input type="checkbox" checked={draft.is_true===true} onChange={e=>field("is_true",e.target.checked)}/>Les textes sont identiques</label><Input label="Difficulté" value={draft.difficulty} onChange={v=>field("difficulty",v)}/><Input area label="Explication" value={draft.explanation} onChange={v=>field("explanation",v)}/><Active draft={draft} field={field}/></div>
  const questionKey=kind==="cas_pratique"?"label":category==="suite_logique"||category==="suites_logiques"?"sequence_text":"question"
  return <div className="grid gap-4"><Input area label={kind==="cas_pratique"?"Question du cas":"Question"} value={draft[questionKey]} onChange={v=>field(questionKey,v)}/>{kind!=="cas_pratique"&&<><div className="grid gap-3 sm:grid-cols-2">{options.map((o,i)=><Input key={i} label={`Réponse ${String.fromCharCode(65+i)}`} value={o} onChange={v=>{const x=[...options];x[i]=v;field("options",x);if(asText(draft.answer)===o)field("answer",v)}}/>)}</div><label className="block text-sm font-medium">Bonne réponse<select className="mt-1 w-full rounded-xl border border-[var(--outline)] bg-[var(--surface)] p-2.5" value={asText(draft.answer)} onChange={e=>field("answer",e.target.value)}>{options.map((o,i)=><option key={i} value={o}>{String.fromCharCode(65+i)}. {o}</option>)}</select></label><Input area label="Explication" value={draft.explanation} onChange={v=>field("explanation",v)}/><div className="grid gap-4 sm:grid-cols-2"><Input label="Catégorie" value={draft.category} onChange={v=>field("category",v)}/><Input label="Difficulté" value={draft.difficulty} onChange={v=>field("difficulty",v)}/></div>{kind==="psy"&&<Active draft={draft} field={field}/>}</>}{kind==="cas_pratique"&&<Input area label="Indice" value={draft.hint} onChange={v=>field("hint",v)}/>}</div>
}
function Active({draft,field}:{draft:Record<string,unknown>;field:(k:string,v:unknown)=>void}) { return <label className="flex items-center gap-2 text-sm"><input type="checkbox" checked={draft.is_active!==false} onChange={e=>field("is_active",e.target.checked)}/>Question active</label> }
function ContentPreview({kind,target}:{kind:string;target:Record<string,unknown>}) { const data=kind==="cas_pratique"&&target.question&&typeof target.question==="object"?target.question as Record<string,unknown>:target; const opts=asOptions(data.options); return <div className="space-y-4 text-sm"><div><p className="text-xs uppercase text-[var(--on-surface-faint)]">Question</p><p className="mt-1 whitespace-pre-wrap text-base font-medium">{asText(data.question??data.sequence_text??data.label??data.text_a)}</p>{data.text_b!=null&&<p className="mt-2 text-base font-medium">{asText(data.text_b)}</p>}</div>{opts.length>0&&<div className="space-y-2">{opts.map((o,i)=><div key={i} className={`rounded-xl border p-3 ${asText(data.answer)===o?"border-emerald-500 bg-emerald-500/10":"border-[var(--outline-variant)]"}`}>{String.fromCharCode(65+i)}. {o}</div>)}</div>}{data.answer!=null&&<Meta label="Bonne réponse" value={data.answer}/>} {data.explanation!=null&&<Meta label="Explication" value={data.explanation}/>}<details><summary className="cursor-pointer text-xs text-[var(--on-surface-muted)]">Données brutes</summary><pre className="mt-2 max-h-72 overflow-auto rounded-xl bg-[var(--surface-container)] p-3 text-xs">{JSON.stringify(target,null,2)}</pre></details></div> }
function editorPatch(kind:string,draft:Record<string,unknown>,options:string[]) { if(kind==="cas_pratique") return draft; return {...draft,options} }
function formatDate(v:unknown){if(!v)return "";return new Date(asText(v)).toLocaleString("fr-FR")}
function ConfirmDelete({type,table,id,busy,onCancel,onConfirm}:{type:"report"|"target";table:unknown;id:unknown;busy:boolean;onCancel:()=>void;onConfirm:()=>void}) { const [typed,setTyped]=useState(""); const word=type==="report"?"SUPPRIMER LE SIGNALEMENT":"SUPPRIMER LA QUESTION";return <div className="fixed inset-0 z-20 grid place-items-center bg-slate-950/70 p-4"><div className="w-full max-w-lg rounded-2xl bg-[var(--surface)] p-6 shadow-2xl"><AlertTriangle className="mb-3 text-red-500"/><h3 className="text-lg font-semibold">{type==="report"?"Supprimer ce signalement ?":"Supprimer définitivement cette question ?"}</h3><p className="mt-2 text-sm text-[var(--on-surface-muted)]">Table : <b>{asText(table)}</b><br/>ID : <b>{asText(id)}</b></p><label className="mt-4 block text-sm">Saisissez <b>{word}</b><input autoFocus value={typed} onChange={e=>setTyped(e.target.value)} className="mt-2 w-full rounded-xl border border-[var(--outline)] bg-[var(--surface)] p-3"/></label><div className="mt-5 flex justify-end gap-2"><Button variant="ghost" onClick={onCancel} disabled={busy}>Annuler</Button><Button onClick={onConfirm} disabled={typed!==word||busy}><Trash2 size={16}/>{busy?"Suppression…":"Confirmer"}</Button></div></div></div> }
