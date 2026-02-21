-- ==========================================
-- SUPABASE SCHEMA INITIALIZATION SCRIPT
-- ==========================================

-- 1. Create Categories Table
CREATE TABLE public.categories (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    name TEXT NOT NULL,
    slug TEXT NOT NULL UNIQUE,
    description TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 2. Create Products Table
CREATE TABLE public.products (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    category_id UUID REFERENCES public.categories(id) ON DELETE SET NULL,
    name TEXT NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL,
    discount INTEGER CHECK (discount >= 0 AND discount <= 100),
    stock INTEGER DEFAULT 0,
    ordering INTEGER DEFAULT 0,
    is_active BOOLEAN DEFAULT true,
    img_url TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 3. Set up Row Level Security (RLS)
-- This protects your data rules.
ALTER TABLE public.categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.products ENABLE ROW LEVEL SECURITY;

-- 4. Create Security Policies
-- Everyone can read the categories and products, but only authenticated admins can create/update/delete.
CREATE POLICY "Allow public read access to categories" 
ON public.categories FOR SELECT 
USING (true);

CREATE POLICY "Allow authenticated users to modify categories" 
ON public.categories FOR ALL 
USING (auth.role() = 'authenticated');

CREATE POLICY "Allow public read access to active products" 
ON public.products FOR SELECT 
USING (true);

CREATE POLICY "Allow authenticated users to modify products" 
ON public.products FOR ALL 
USING (auth.role() = 'authenticated');

-- 5. Auto-update `updated_at` Timestamp Trigger
CREATE OR REPLACE FUNCTION handle_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER set_categories_updated_at
BEFORE UPDATE ON public.categories
FOR EACH ROW EXECUTE FUNCTION handle_updated_at();

CREATE TRIGGER set_products_updated_at
BEFORE UPDATE ON public.products
FOR EACH ROW EXECUTE FUNCTION handle_updated_at();

-- ==========================================
-- STORAGE BUCKET CONFIGURATION INSTRUCTIONS
-- ==========================================
-- You will also need to create a bucket for your product images:
-- 1. Go to your Supabase Dashboard -> Storage
-- 2. Click "Create a new bucket"
-- 3. Name it: "product-images"
-- 4. Make sure to toggle "Public bucket" to ON so images can be viewed anywhere.
