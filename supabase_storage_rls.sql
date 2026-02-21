-- ==========================================
-- SUPABASE STORAGE RLS FIX
-- ==========================================
-- This script safely configures your `product-images` bucket so that ANY authenticated 
-- user (you, the admin) can upload, update, and delete images, while ANYONE on 
-- the internet can view them.

-- 1. Ensure the bucket exists and is public
INSERT INTO storage.buckets (id, name, public) 
VALUES ('product-images', 'product-images', true)
ON CONFLICT (id) DO UPDATE SET public = true;

-- 2. Allow public to SELECT (View) images
CREATE POLICY "Public Access" 
ON storage.objects FOR SELECT 
USING ( bucket_id = 'product-images' );

-- 3. Allow authenticated users to INSERT (Upload) images
CREATE POLICY "Auth Insert" 
ON storage.objects FOR INSERT 
WITH CHECK ( bucket_id = 'product-images' AND auth.role() = 'authenticated' );

-- 4. Allow authenticated users to UPDATE images
CREATE POLICY "Auth Update" 
ON storage.objects FOR UPDATE 
USING ( bucket_id = 'product-images' AND auth.role() = 'authenticated' );

-- 5. Allow authenticated users to DELETE images
CREATE POLICY "Auth Delete" 
ON storage.objects FOR DELETE 
USING ( bucket_id = 'product-images' AND auth.role() = 'authenticated' );
