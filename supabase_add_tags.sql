-- Add tags column to products table
ALTER TABLE products ADD COLUMN tags text[] DEFAULT '{}';
