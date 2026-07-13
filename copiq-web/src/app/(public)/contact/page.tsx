"use client"
import type { Metadata } from "next"
import { useState } from "react"
import { Mail, MessageSquare, Send, Check } from "lucide-react"

export default function ContactPage() {
  const [sent, setSent] = useState(false)
  const [loading, setLoading] = useState(false)
  async function handleSubmit(e: React.FormEvent<HTMLFormElement>) {
    e.preventDefault()
    setLoading(true)
    await new Promise(r => setTimeout(r, 1200))
    setSent(true)
    setLoading(false)
  }
  return (
    <div className="max-w-2xl mx-auto px-4 py-16">
      <div className="text-center mb-10">
        <div className="w-14 h-14 rounded-2xl bg-[#1147D9]/10 flex items-center justify-center mx-auto mb-4">
          <MessageSquare size={24} className="text-[#1147D9]" />
        </div>
        <h1 className="text-3xl font-bold text-[var(--on-surface)] mb-2">Nous contacter</h1>
        <p className="text-[var(--on-surface-muted)]">Une question, une suggestion ? On vous répond sous 24h.</p>
      </div>
      {sent ? (
        <div className="text-center py-12">
          <div className="w-16 h-16 rounded-full bg-[#22C55E]/10 flex items-center justify-center mx-auto mb-4">
            <Check size={28} className="text-[#22C55E]" />
          </div>
          <h2 className="text-xl font-bold text-[var(--on-surface)] mb-2">Message envoyé !</h2>
          <p className="text-[var(--on-surface-muted)]">Nous vous répondrons dans les meilleurs délais à l&apos;adresse indiquée.</p>
        </div>
      ) : (
        <form onSubmit={handleSubmit} className="space-y-4 rounded-2xl border border-[var(--outline)] p-8">
          {[
            { id: "name", label: "Nom complet", type: "text", placeholder: "Jean Dupont" },
            { id: "email", label: "Email", type: "email", placeholder: "vous@exemple.fr" },
          ].map(({ id, label, type, placeholder }) => (
            <div key={id}>
              <label htmlFor={id} className="block text-sm font-medium text-[var(--on-surface)] mb-1.5">{label}</label>
              <input id={id} type={type} placeholder={placeholder} required className="w-full px-4 py-3 rounded-xl border border-[var(--outline)] bg-[var(--surface)] text-[var(--on-surface)] text-sm placeholder:text-[var(--on-surface-faint)] focus:outline-none focus:ring-2 focus:ring-[#1147D9]/30 focus:border-[#1147D9] transition-all" />
            </div>
          ))}
          <div>
            <label className="block text-sm font-medium text-[var(--on-surface)] mb-1.5">Sujet</label>
            <select className="w-full px-4 py-3 rounded-xl border border-[var(--outline)] bg-[var(--surface)] text-[var(--on-surface)] text-sm focus:outline-none focus:ring-2 focus:ring-[#1147D9]/30 focus:border-[#1147D9] transition-all">
              <option>Question sur l&apos;abonnement</option>
              <option>Problème technique</option>
              <option>Contenu / cours</option>
              <option>Forum / modération</option>
              <option>Autre</option>
            </select>
          </div>
          <div>
            <label className="block text-sm font-medium text-[var(--on-surface)] mb-1.5">Message</label>
            <textarea rows={5} required placeholder="Décrivez votre demande..." className="w-full px-4 py-3 rounded-xl border border-[var(--outline)] bg-[var(--surface)] text-[var(--on-surface)] text-sm placeholder:text-[var(--on-surface-faint)] focus:outline-none focus:ring-2 focus:ring-[#1147D9]/30 focus:border-[#1147D9] transition-all resize-none" />
          </div>
          <button type="submit" disabled={loading} className="w-full flex items-center justify-center gap-2 py-3.5 rounded-xl bg-[#1147D9] hover:bg-[#1A55E6] text-white font-semibold text-sm transition-all disabled:opacity-60">
            {loading ? <span className="w-4 h-4 border-2 border-white/30 border-t-white rounded-full animate-spin" /> : <Send size={15} />}
            {loading ? "Envoi…" : "Envoyer le message"}
          </button>
          <p className="text-center text-xs text-[var(--on-surface-faint)]">
            Ou par email directement : <a href="mailto:contact@copiqpolice.app" className="text-[#1147D9] hover:underline">contact@copiqpolice.app</a>
          </p>
        </form>
      )}
    </div>
  )
}
