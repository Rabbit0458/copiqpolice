"use client"

import { AdminGate } from "@/components/admin/admin-gate"
import { AdminShell } from "@/components/admin/admin-ui"

export default function AdminLayout({ children }: { children: React.ReactNode }) {
  return (
    <AdminGate>
      {(session) => <AdminShell session={session}>{children}</AdminShell>}
    </AdminGate>
  )
}
