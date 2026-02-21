--- RUN THIS SQL IN THE SUPABASE SQL EDITOR TO ADD MULTIPLE IMAGES SUPPORT ---

-- Add a new column to store an array of image URLs
ALTER TABLE public.products ADD COLUMN IF NOT EXISTS gallery_urls TEXT[] DEFAULT '{}';
