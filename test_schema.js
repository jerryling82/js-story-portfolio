import { createClient } from '@supabase/supabase-js';
import dotenv from 'dotenv';
dotenv.config();

const supabase = createClient(process.env.VITE_SUPABASE_URL, process.env.VITE_SUPABASE_API);

async function check() {
    const res = await supabase.from('products').select('*').limit(1);
    console.dir(res.data[0], { depth: null, colors: false });
    console.log("Keys:", Object.keys(res.data[0]));
}
check();
