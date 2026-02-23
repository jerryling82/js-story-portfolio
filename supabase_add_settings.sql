-- Create a settings table for global configuration
CREATE TABLE IF NOT EXISTS public.settings (
    id integer PRIMARY KEY DEFAULT 1,
    hero_gallery_urls text[] DEFAULT ARRAY['https://scontent.fyyc7-1.fna.fbcdn.net/v/t1.6435-9/43346115_332671167501293_2080575702570106880_n.jpg?_nc_cat=106&ccb=1-7&_nc_sid=0327a3&_nc_ohc=t4t6YAffox4Q7kNvwEEUouY&_nc_oc=AdltUExi7blcmkX52cQ5xMjgr7N1Tf6IjCeoZ5oCyInVjT4Ch9e2mQX3ZWDBHs_mi7o&_nc_zt=23&_nc_ht=scontent.fyyc7-1.fna&_nc_gid=zomgBR4S7FEEPRMX-2H0MQ&oh=00_AfvrYP_UktVDXA1DY8gXlTE3EZfyncflyW9Elge8nss9AA&oe=69C0D44A'],
    updated_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Note: In Supabase, if the table only has 1 row by design, we enforce it using the id.
INSERT INTO public.settings (id) VALUES (1) ON CONFLICT (id) DO NOTHING;

-- If they already created the table from the last step, add the column:
ALTER TABLE public.settings ADD COLUMN IF NOT EXISTS hero_gallery_urls text[] DEFAULT ARRAY['https://scontent.fyyc7-1.fna.fbcdn.net/v/t1.6435-9/43346115_332671167501293_2080575702570106880_n.jpg?_nc_cat=106&ccb=1-7&_nc_sid=0327a3&_nc_ohc=t4t6YAffox4Q7kNvwEEUouY&_nc_oc=AdltUExi7blcmkX52cQ5xMjgr7N1Tf6IjCeoZ5oCyInVjT4Ch9e2mQX3ZWDBHs_mi7o&_nc_zt=23&_nc_ht=scontent.fyyc7-1.fna&_nc_gid=zomgBR4S7FEEPRMX-2H0MQ&oh=00_AfvrYP_UktVDXA1DY8gXlTE3EZfyncflyW9Elge8nss9AA&oe=69C0D44A'];

-- Enable RLS
ALTER TABLE public.settings ENABLE ROW LEVEL SECURITY;

-- Allow public read access to settings
CREATE POLICY "Allow public read access to settings" ON public.settings FOR SELECT USING (true);

-- Require auth for all other operations
CREATE POLICY "Allow authenticated users to update settings" ON public.settings FOR UPDATE USING (auth.role() = 'authenticated');
CREATE POLICY "Allow authenticated users to insert settings" ON public.settings FOR INSERT WITH CHECK (auth.role() = 'authenticated');

-- Trigger to automatically update the 'updated_at' column
CREATE OR REPLACE FUNCTION update_settings_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = timezone('utc'::text, now());
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_settings_updated_at_trigger
BEFORE UPDATE ON public.settings
FOR EACH ROW EXECUTE FUNCTION update_settings_updated_at();
