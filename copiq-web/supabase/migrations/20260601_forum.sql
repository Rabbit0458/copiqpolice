-- Forum categories
CREATE TABLE IF NOT EXISTS forum_categories (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  slug text UNIQUE NOT NULL,
  description text,
  position integer DEFAULT 0,
  created_at timestamptz DEFAULT now()
);

-- Forum posts
CREATE TABLE IF NOT EXISTS forum_posts (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  category_id uuid REFERENCES forum_categories(id) ON DELETE SET NULL,
  category_slug text,
  title text NOT NULL CHECK (length(title) >= 5 AND length(title) <= 200),
  content text NOT NULL CHECK (length(content) >= 10 AND length(content) <= 5000),
  pinned boolean DEFAULT false,
  locked boolean DEFAULT false,
  reply_count integer DEFAULT 0,
  view_count integer DEFAULT 0,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Forum replies
CREATE TABLE IF NOT EXISTS forum_replies (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  post_id uuid REFERENCES forum_posts(id) ON DELETE CASCADE NOT NULL,
  user_id uuid REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  content text NOT NULL CHECK (length(content) >= 1 AND length(content) <= 2000),
  is_solution boolean DEFAULT false,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Forum user roles
CREATE TABLE IF NOT EXISTS forum_user_roles (
  user_id uuid REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  role text NOT NULL CHECK (role IN ('user', 'moderator', 'admin')),
  granted_at timestamptz DEFAULT now(),
  PRIMARY KEY (user_id)
);

-- Forum reports
CREATE TABLE IF NOT EXISTS forum_reports (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  reporter_id uuid REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  post_id uuid REFERENCES forum_posts(id) ON DELETE CASCADE,
  reply_id uuid REFERENCES forum_replies(id) ON DELETE CASCADE,
  reason text NOT NULL,
  resolved boolean DEFAULT false,
  created_at timestamptz DEFAULT now(),
  CHECK (post_id IS NOT NULL OR reply_id IS NOT NULL)
);

-- Forum likes
CREATE TABLE IF NOT EXISTS forum_likes (
  user_id uuid REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  post_id uuid REFERENCES forum_posts(id) ON DELETE CASCADE,
  reply_id uuid REFERENCES forum_replies(id) ON DELETE CASCADE,
  created_at timestamptz DEFAULT now(),
  PRIMARY KEY (user_id, COALESCE(post_id, '00000000-0000-0000-0000-000000000000'), COALESCE(reply_id, '00000000-0000-0000-0000-000000000000'))
);

-- RLS
ALTER TABLE forum_categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE forum_posts ENABLE ROW LEVEL SECURITY;
ALTER TABLE forum_replies ENABLE ROW LEVEL SECURITY;
ALTER TABLE forum_user_roles ENABLE ROW LEVEL SECURITY;
ALTER TABLE forum_reports ENABLE ROW LEVEL SECURITY;
ALTER TABLE forum_likes ENABLE ROW LEVEL SECURITY;

-- Categories: public read
CREATE POLICY "forum_categories_read" ON forum_categories FOR SELECT USING (true);

-- Posts: authenticated read; own insert; own update/delete
CREATE POLICY "forum_posts_read" ON forum_posts FOR SELECT USING (true);
CREATE POLICY "forum_posts_insert" ON forum_posts FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "forum_posts_update" ON forum_posts FOR UPDATE USING (auth.uid() = user_id AND NOT locked);
CREATE POLICY "forum_posts_delete" ON forum_posts FOR DELETE USING (auth.uid() = user_id);

-- Replies
CREATE POLICY "forum_replies_read" ON forum_replies FOR SELECT USING (true);
CREATE POLICY "forum_replies_insert" ON forum_replies FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "forum_replies_delete" ON forum_replies FOR DELETE USING (auth.uid() = user_id);

-- Roles: own read only
CREATE POLICY "forum_roles_read" ON forum_user_roles FOR SELECT USING (auth.uid() = user_id);

-- Likes
CREATE POLICY "forum_likes_read" ON forum_likes FOR SELECT USING (true);
CREATE POLICY "forum_likes_insert" ON forum_likes FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "forum_likes_delete" ON forum_likes FOR DELETE USING (auth.uid() = user_id);

-- Auto-increment reply count
CREATE OR REPLACE FUNCTION increment_reply_count()
RETURNS TRIGGER AS $$
BEGIN
  UPDATE forum_posts SET reply_count = reply_count + 1, updated_at = now() WHERE id = NEW.post_id;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER on_reply_insert
  AFTER INSERT ON forum_replies
  FOR EACH ROW EXECUTE FUNCTION increment_reply_count();

-- Seed default categories
INSERT INTO forum_categories (name, slug, description, position) VALUES
  ('Général', 'general', 'Discussions générales sur la préparation aux concours de police', 0),
  ('Droit Pénal', 'droit-penal', 'Questions et discussions sur le droit pénal', 1),
  ('Procédure Pénale', 'procedure', 'GAV, enquêtes, instruction, voies de recours', 2),
  ('Psychotechniques', 'psychotechniques', 'Exercices, méthodes et conseils pour les épreuves psychotechniques', 3),
  ('Cas Pratiques', 'cas-pratiques', 'Rédaction, corrections et méthodes pour les cas pratiques GPX', 4),
  ('Annonces', 'annonces', 'Annonces officielles et actualités des concours de police', 5)
ON CONFLICT (slug) DO NOTHING;

-- Index for performance
CREATE INDEX IF NOT EXISTS forum_posts_category_idx ON forum_posts(category_id);
CREATE INDEX IF NOT EXISTS forum_posts_user_idx ON forum_posts(user_id);
CREATE INDEX IF NOT EXISTS forum_posts_created_idx ON forum_posts(created_at DESC);
CREATE INDEX IF NOT EXISTS forum_replies_post_idx ON forum_replies(post_id);
