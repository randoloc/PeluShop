const { createClient } = require('@supabase/supabase-js');

const supabaseUrl = 'https://ubmjcdmzfelgmyjuowgf.supabase.co';
const supabaseKey = process.env.SUPABASE_ANON_KEY || 'YOUR_ANON_KEY_HERE';

const supabase = createClient(supabaseUrl, supabaseKey);

module.exports = supabase;