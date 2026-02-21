<template>
  <div class="drawer lg:drawer-open font-['Inter',sans-serif]">
    <input id="my-drawer-2" type="checkbox" class="drawer-toggle" />
    <div class="drawer-content flex flex-col bg-slate-50 min-h-screen">
      <!-- Navbar for mobile -->
      <div class="w-full navbar bg-white shadow-sm lg:hidden">
        <div class="flex-none">
          <label for="my-drawer-2" aria-label="open sidebar" class="btn btn-square btn-ghost">
            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" class="inline-block w-6 h-6 stroke-current"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16"></path></svg>
          </label>
        </div>
        <div class="flex-1 font-bold font-serif text-xl tracking-wide px-2 text-[#333]">js.story.handmade Admin</div>
      </div>
      <!-- Page content here -->
      <main class="flex-1 overflow-y-auto w-full p-4 lg:p-8">
        <router-view></router-view>
      </main>
    </div> 
    
    <div class="drawer-side border-r border-slate-200">
      <label for="my-drawer-2" aria-label="close sidebar" class="drawer-overlay"></label> 
      <ul class="menu p-4 w-72 min-h-full bg-white text-slate-700">
        <!-- Sidebar content here -->
        <h2 class="text-3xl font-serif text-[#333] mb-8 mt-4 font-bold tracking-widest px-4 text-center">js.story.handmade<span class="text-[#0bbcd4]">.</span></h2>
        
        <li class="menu-title mt-2 text-slate-400 font-bold uppercase tracking-widest text-[10px]">Store Management</li>
        <li>
          <router-link to="/admin/products" active-class="bg-slate-100 font-bold text-[#0bbcd4]">
            <span class="material-symbols-outlined text-[20px]">inventory_2</span> 
            Products
          </router-link>
        </li>
        <li>
          <router-link to="/admin/categories" active-class="bg-slate-100 font-bold text-[#0bbcd4]">
            <span class="material-symbols-outlined text-[20px]">category</span> 
            Categories
          </router-link>
        </li>

        <li class="menu-title mt-8 text-slate-400 font-bold uppercase tracking-widest text-[10px]">System</li>
        <li>
           <router-link to="/" target="_blank">
             <span class="material-symbols-outlined text-[20px]">open_in_new</span>
             View Storefront
           </router-link>
        </li>
        <li>
           <button @click="handleLogout" class="text-red-500 hover:bg-red-50">
             <span class="material-symbols-outlined text-[20px]">logout</span>
             Logout
           </button>
        </li>
      </ul>
    </div>
  </div>
</template>

<script setup>
import { useRouter } from 'vue-router'
import { supabase } from '../../lib/supabaseClient'

const router = useRouter()

const handleLogout = async () => {
  const { error } = await supabase.auth.signOut()
  if (!error) {
    router.push('/admin/login')
  } else {
    console.error('Logout error:', error)
  }
}
</script>
