"use client"

import { AdminGate } from "@/components/admin/admin-gate"
import { AdminShell } from "@/components/admin/admin-ui"
import { AdminSessionContext } from "@/components/admin/admin-session"

export default function AdminLayout({ children }: { children: React.ReactNode }) {
  return (
    <AdminGate>
      {(session) => <AdminSessionContext.Provider value={session}><AdminShell session={session}>{children}</AdminShell></AdminSessionContext.Provider>}
    </AdminGate>
  )
}
