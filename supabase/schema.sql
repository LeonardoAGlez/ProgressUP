-- ==============================================
-- NEON PULSE 3D - Supabase Database Schema
-- Run this in: Supabase Dashboard → SQL Editor
-- ==============================================

-- ── Enable UUID extension ─────────────────────
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ── USER PROFILES ─────────────────────────────
CREATE TABLE IF NOT EXISTS public.profiles (
  id UUID REFERENCES auth.users(id) ON DELETE CASCADE PRIMARY KEY,
  full_name TEXT,
  username TEXT UNIQUE,
  avatar_url TEXT,
  level TEXT DEFAULT 'Basic',
  current_xp INTEGER DEFAULT 0,
  total_xp INTEGER DEFAULT 0,
  current_streak INTEGER DEFAULT 0,
  max_streak INTEGER DEFAULT 0,
  is_pro BOOLEAN DEFAULT false,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ── WORKOUTS ──────────────────────────────────
CREATE TABLE IF NOT EXISTS public.workouts (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  description TEXT,
  duration_minutes INTEGER,
  calories_burned INTEGER,
  xp_earned INTEGER DEFAULT 0,
  completed_at TIMESTAMPTZ DEFAULT NOW(),
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ── EXERCISES ─────────────────────────────────
CREATE TABLE IF NOT EXISTS public.exercises (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  workout_id UUID REFERENCES public.workouts(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  sets JSONB NOT NULL DEFAULT '[]',
  order_index INTEGER DEFAULT 0
);

-- ── SOCIAL POSTS ──────────────────────────────
CREATE TABLE IF NOT EXISTS public.posts (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE,
  content TEXT NOT NULL,
  image_url TEXT,
  tag TEXT,
  likes_count INTEGER DEFAULT 0,
  comments_count INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ── POST LIKES ────────────────────────────────
CREATE TABLE IF NOT EXISTS public.post_likes (
  post_id UUID REFERENCES public.posts(id) ON DELETE CASCADE,
  user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  PRIMARY KEY (post_id, user_id)
);

-- ── LEADERBOARD VIEW ──────────────────────────
CREATE OR REPLACE VIEW public.leaderboard AS
  SELECT
    p.id,
    p.full_name,
    p.username,
    p.avatar_url,
    p.level,
    p.current_xp,
    RANK() OVER (ORDER BY p.current_xp DESC) AS rank
  FROM public.profiles p
  ORDER BY p.current_xp DESC;

-- ── ROW LEVEL SECURITY ────────────────────────

-- Profiles
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Public profiles are viewable by everyone"
  ON public.profiles FOR SELECT USING (true);

CREATE POLICY "Users can update own profile"
  ON public.profiles FOR UPDATE
  USING (auth.uid() = id);

-- Workouts
ALTER TABLE public.workouts ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own workouts"
  ON public.workouts FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own workouts"
  ON public.workouts FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own workouts"
  ON public.workouts FOR UPDATE
  USING (auth.uid() = user_id);

-- Posts
ALTER TABLE public.posts ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Posts are viewable by everyone"
  ON public.posts FOR SELECT USING (true);

CREATE POLICY "Users can create posts"
  ON public.posts FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete own posts"
  ON public.posts FOR DELETE
  USING (auth.uid() = user_id);

-- Post Likes
ALTER TABLE public.post_likes ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Likes are viewable by everyone"
  ON public.post_likes FOR SELECT USING (true);

CREATE POLICY "Users can like posts"
  ON public.post_likes FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can unlike posts"
  ON public.post_likes FOR DELETE
  USING (auth.uid() = user_id);

-- ── AUTO-CREATE PROFILE ON SIGNUP ─────────────
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.profiles (id, full_name, username)
  VALUES (
    NEW.id,
    NEW.raw_user_meta_data->>'full_name',
    LOWER(REPLACE(COALESCE(NEW.raw_user_meta_data->>'full_name', 'user'), ' ', '_'))
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE PROCEDURE public.handle_new_user();

-- ── XP LEVEL CALCULATOR ───────────────────────
CREATE OR REPLACE FUNCTION public.get_level_from_xp(xp INTEGER)
RETURNS TEXT AS $$
BEGIN
  IF xp >= 10000 THEN RETURN 'Legendary';
  ELSIF xp >= 6000 THEN RETURN 'Elite Athlete';
  ELSIF xp >= 3000 THEN RETURN 'Cyber Warrior';
  ELSIF xp >= 1000 THEN RETURN 'Neon Striker';
  ELSE RETURN 'Basic';
  END IF;
END;
$$ LANGUAGE plpgsql IMMUTABLE;

-- ── SAMPLE DATA (Optional for testing) ────────
-- INSERT INTO public.posts (user_id, content, tag)
-- SELECT id, '¡Primer workout completado! 🔥 #NeonPulse', '#PowerLift'
-- FROM public.profiles LIMIT 1;
