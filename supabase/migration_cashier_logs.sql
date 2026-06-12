-- Création de la table cashier_logs pour le pointage des caissiers
CREATE TABLE IF NOT EXISTS public.cashier_logs (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE,
    login_time TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()),
    logout_time TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now())
);

-- Activation de la sécurité au niveau des lignes (RLS)
ALTER TABLE public.cashier_logs ENABLE ROW LEVEL SECURITY;

-- Politique pour permettre aux utilisateurs authentifiés de tout faire
-- Note: Dans un environnement de production, on limiterait probablement 
-- l'insertion à l'utilisateur lui-même (auth.uid() = user_id)
CREATE POLICY "Enable all for authenticated users on cashier_logs" 
ON public.cashier_logs FOR ALL 
TO authenticated 
USING (true) 
WITH CHECK (true);

-- Permissions pour les utilisateurs authentifiés
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE public.cashier_logs TO authenticated;
