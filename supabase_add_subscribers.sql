-- Create subscribers table
CREATE TABLE IF NOT EXISTS public.subscribers (
    id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    email text UNIQUE NOT NULL,
    created_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Enable RLS
ALTER TABLE public.subscribers ENABLE ROW LEVEL SECURITY;

-- Allow public to INSERT (subscribe)
CREATE POLICY "Allow public insert to subscribers" ON public.subscribers FOR INSERT WITH CHECK (true);

-- Only authenticated users (admins) can view subscribers
CREATE POLICY "Allow authenticated users to select subscribers" ON public.subscribers FOR SELECT USING (auth.role() = 'authenticated');

-- Only authenticated users (admins) can delete/update subscribers
CREATE POLICY "Allow authenticated users to delete subscribers" ON public.subscribers FOR DELETE USING (auth.role() = 'authenticated');
CREATE POLICY "Allow authenticated users to update subscribers" ON public.subscribers FOR UPDATE USING (auth.role() = 'authenticated');
