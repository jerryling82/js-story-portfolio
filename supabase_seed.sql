--- RUN THIS SQL IN SUPABASE SQL EDITOR TO SEED DATA ---

INSERT INTO public.categories (name, slug, description)
VALUES ('Earrings', 'earrings', 'Exquisite handmade earring collections')
ON CONFLICT (slug) DO NOTHING;

DO $$ 
DECLARE 
    cat_id uuid;
BEGIN 
    SELECT id INTO cat_id FROM public.categories WHERE slug = 'earrings' LIMIT 1;
    
    INSERT INTO public.products (category_id, name, description, price, discount, stock, ordering, is_active, img_url)
    VALUES 
    (cat_id, 'Crystal & Leaf Drop Earrings', 'Elegant handmade earrings featuring sparkling crystal clusters and delicate green leaf pendants. Perfect for adding a touch of nature-inspired glamour to any outfit.', 45.00, null, 5, 1, true, 'https://scontent-sjc3-1.xx.fbcdn.net/v/t39.30808-6/299616259_115343467954932_602165507577549007_n.jpg?_nc_cat=103&ccb=1-7&_nc_sid=833d8c&_nc_ohc=p1Q2r3s4t5u&_nc_zt=23&_nc_ht=scontent-sjc3-1.xx'),
    (cat_id, 'Opal Blossom Pearl Drops', 'Soft pink iridescent floral tops paired with elegant elongated teardrop pearls. Perfect for formal wear, weddings, or a delicate everyday look.', 55.00, 10, 3, 2, true, 'https://scontent-sjc3-1.xx.fbcdn.net/v/t39.30808-6/299307997_115343514621594_8512214470409002164_n.jpg?_nc_cat=105&ccb=1-7&_nc_sid=833d8c&_nc_ohc=a2b3c4d5e6f&_nc_zt=23&_nc_ht=scontent-sjc3-1.xx'),
    (cat_id, 'Enchanted Rose Gold Chains', 'Long chain earrings adorned with striking pink floral beads and contrasting elements for a magical, flowing aesthetic.', 35.00, null, 8, 3, true, 'https://scontent-sjc3-1.xx.fbcdn.net/v/t39.30808-6/299292193_115343461288266_547563032338240589_n.jpg?_nc_cat=109&ccb=1-7&_nc_sid=833d8c&_nc_ohc=g7h8i9j0k1l&_nc_zt=23&_nc_ht=scontent-sjc3-1.xx');
END $$;
