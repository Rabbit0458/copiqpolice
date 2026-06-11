-- ════════════════════════════════════════════════════════════════════════════
--  COP'IQ — Cas Pratique — Multi-tenant organisations (centres de formation)
--  Migration : 20260607000001
--  Tâche     : CODE-095
-- ════════════════════════════════════════════════════════════════════════════

-- ─────────────────────────────────────────────────────────────────────────────
-- 1. TABLE cas_pratique_organizations
-- ─────────────────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.cas_pratique_organizations (
    id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    slug            text NOT NULL UNIQUE,
    name            text NOT NULL,
    -- Plan : 'starter' (gratuit, 5 membres max) | 'pro' (50) | 'enterprise' (illimité)
    plan            text NOT NULL DEFAULT 'starter'
                        CHECK (plan IN ('starter','pro','enterprise')),
    max_members     int  NOT NULL DEFAULT 5,
    -- Branding optionnel
    logo_url        text,
    primary_color   text DEFAULT '#1147D9',
    -- Contact facturation
    billing_email   text,
    stripe_customer_id text,
    -- Métadonnées
    is_active       boolean NOT NULL DEFAULT true,
    trial_ends_at   timestamptz,
    created_at      timestamptz NOT NULL DEFAULT now(),
    updated_at      timestamptz NOT NULL DEFAULT now()
);

COMMENT ON TABLE public.cas_pratique_organizations IS
    'Centres de formation multi-tenant. Un utilisateur peut appartenir à 0 ou 1 organisation.';

-- ─────────────────────────────────────────────────────────────────────────────
-- 2. TABLE cas_pratique_org_members  (lien users ↔ organisations)
-- ─────────────────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.cas_pratique_org_members (
    id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    org_id          uuid NOT NULL REFERENCES public.cas_pratique_organizations(id) ON DELETE CASCADE,
    user_id         uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    -- Rôle : 'trainer' (formateur, accès stats promo) | 'learner' (élève)
    role            text NOT NULL DEFAULT 'learner'
                        CHECK (role IN ('trainer','learner')),
    -- Promo / classe optionnelle (ex: "Promotion 2026 Lyon")
    promo_label     text,
    invited_by      uuid REFERENCES auth.users(id) ON DELETE SET NULL,
    joined_at       timestamptz NOT NULL DEFAULT now(),
    UNIQUE (org_id, user_id)
);

COMMENT ON TABLE public.cas_pratique_org_members IS
    'Appartenance d''un utilisateur à une organisation avec son rôle (formateur / élève).';

-- ─────────────────────────────────────────────────────────────────────────────
-- 3. TABLE cas_pratique_org_invitations  (invitations par email)
-- ─────────────────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.cas_pratique_org_invitations (
    id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    org_id          uuid NOT NULL REFERENCES public.cas_pratique_organizations(id) ON DELETE CASCADE,
    email           text NOT NULL,
    role            text NOT NULL DEFAULT 'learner'
                        CHECK (role IN ('trainer','learner')),
    promo_label     text,
    token           text NOT NULL UNIQUE DEFAULT encode(gen_random_bytes(24), 'hex'),
    invited_by      uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    accepted_at     timestamptz,
    expires_at      timestamptz NOT NULL DEFAULT now() + INTERVAL '7 days',
    created_at      timestamptz NOT NULL DEFAULT now(),
    UNIQUE (org_id, email)
);

COMMENT ON TABLE public.cas_pratique_org_invitations IS
    'Invitations en attente d''acceptation par email.';

-- ─────────────────────────────────────────────────────────────────────────────
-- 4. TRIGGER updated_at sur organizations
-- ─────────────────────────────────────────────────────────────────────────────
CREATE OR REPLACE TRIGGER trg_cp_orgs_updated_at
    BEFORE UPDATE ON public.cas_pratique_organizations
    FOR EACH ROW EXECUTE FUNCTION fn_cp_set_updated_at();

-- ─────────────────────────────────────────────────────────────────────────────
-- 5. INDEXES
-- ─────────────────────────────────────────────────────────────────────────────
CREATE INDEX IF NOT EXISTS idx_cp_org_members_org_id  ON public.cas_pratique_org_members(org_id);
CREATE INDEX IF NOT EXISTS idx_cp_org_members_user_id ON public.cas_pratique_org_members(user_id);
CREATE INDEX IF NOT EXISTS idx_cp_org_invitations_org_id ON public.cas_pratique_org_invitations(org_id);
CREATE INDEX IF NOT EXISTS idx_cp_org_invitations_token  ON public.cas_pratique_org_invitations(token);

-- ─────────────────────────────────────────────────────────────────────────────
-- 6. HELPER — savoir si l'utilisateur courant est trainer d'une org
-- ─────────────────────────────────────────────────────────────────────────────
CREATE OR REPLACE FUNCTION fn_cp_is_trainer(_org_id uuid)
RETURNS boolean
LANGUAGE sql
STABLE
SECURITY DEFINER
AS $$
    SELECT EXISTS (
        SELECT 1
        FROM public.cas_pratique_org_members
        WHERE org_id = _org_id
          AND user_id = auth.uid()
          AND role = 'trainer'
    );
$$;

-- ─────────────────────────────────────────────────────────────────────────────
-- 7. RLS — Row Level Security multi-tenant
-- ─────────────────────────────────────────────────────────────────────────────

-- Organisations
ALTER TABLE public.cas_pratique_organizations ENABLE ROW LEVEL SECURITY;

CREATE POLICY "cp_orgs_admin_all" ON public.cas_pratique_organizations
    FOR ALL TO authenticated
    USING (fn_cp_is_admin())
    WITH CHECK (fn_cp_is_admin());

CREATE POLICY "cp_orgs_member_select" ON public.cas_pratique_organizations
    FOR SELECT TO authenticated
    USING (
        id IN (
            SELECT org_id FROM public.cas_pratique_org_members WHERE user_id = auth.uid()
        )
    );

-- Membres
ALTER TABLE public.cas_pratique_org_members ENABLE ROW LEVEL SECURITY;

CREATE POLICY "cp_org_members_admin_all" ON public.cas_pratique_org_members
    FOR ALL TO authenticated
    USING (fn_cp_is_admin())
    WITH CHECK (fn_cp_is_admin());

CREATE POLICY "cp_org_members_trainer_select" ON public.cas_pratique_org_members
    FOR SELECT TO authenticated
    USING (fn_cp_is_trainer(org_id));

CREATE POLICY "cp_org_members_self_select" ON public.cas_pratique_org_members
    FOR SELECT TO authenticated
    USING (user_id = auth.uid());

-- Invitations
ALTER TABLE public.cas_pratique_org_invitations ENABLE ROW LEVEL SECURITY;

CREATE POLICY "cp_org_invitations_admin_all" ON public.cas_pratique_org_invitations
    FOR ALL TO authenticated
    USING (fn_cp_is_admin())
    WITH CHECK (fn_cp_is_admin());

CREATE POLICY "cp_org_invitations_trainer_crud" ON public.cas_pratique_org_invitations
    FOR ALL TO authenticated
    USING (fn_cp_is_trainer(org_id))
    WITH CHECK (fn_cp_is_trainer(org_id));

CREATE POLICY "cp_org_invitations_self_select" ON public.cas_pratique_org_invitations
    FOR SELECT TO authenticated
    USING (invited_by = auth.uid());

-- ─────────────────────────────────────────────────────────────────────────────
-- 8. RPC admin — CRUD organisations pour le panel admin
-- ─────────────────────────────────────────────────────────────────────────────

-- Liste toutes les organisations avec comptage membres
CREATE OR REPLACE FUNCTION cp_admin_list_orgs()
RETURNS TABLE (
    id              uuid,
    slug            text,
    name            text,
    plan            text,
    max_members     int,
    is_active       boolean,
    member_count    bigint,
    trainer_count   bigint,
    created_at      timestamptz
)
LANGUAGE sql
STABLE
SECURITY DEFINER
AS $$
    SELECT
        o.id,
        o.slug,
        o.name,
        o.plan,
        o.max_members,
        o.is_active,
        COUNT(m.id)                                            AS member_count,
        COUNT(m.id) FILTER (WHERE m.role = 'trainer')         AS trainer_count,
        o.created_at
    FROM public.cas_pratique_organizations o
    LEFT JOIN public.cas_pratique_org_members m ON m.org_id = o.id
    WHERE fn_cp_is_admin()
    GROUP BY o.id
    ORDER BY o.created_at DESC;
$$;

-- Détail d'une organisation avec ses membres
CREATE OR REPLACE FUNCTION cp_admin_get_org(_org_id uuid)
RETURNS TABLE (
    org_id          uuid,
    org_slug        text,
    org_name        text,
    org_plan        text,
    org_max_members int,
    org_is_active   boolean,
    org_logo_url    text,
    org_trial_ends  timestamptz,
    org_created_at  timestamptz,
    member_id       uuid,
    member_user_id  uuid,
    member_email    text,
    member_role     text,
    member_promo    text,
    member_joined   timestamptz
)
LANGUAGE sql
STABLE
SECURITY DEFINER
AS $$
    SELECT
        o.id,
        o.slug,
        o.name,
        o.plan,
        o.max_members,
        o.is_active,
        o.logo_url,
        o.trial_ends_at,
        o.created_at,
        m.id,
        m.user_id,
        u.email,
        m.role,
        m.promo_label,
        m.joined_at
    FROM public.cas_pratique_organizations o
    LEFT JOIN public.cas_pratique_org_members m ON m.org_id = o.id
    LEFT JOIN auth.users u ON u.id = m.user_id
    WHERE o.id = _org_id
      AND fn_cp_is_admin()
    ORDER BY m.joined_at DESC;
$$;
