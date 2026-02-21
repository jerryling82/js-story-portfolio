<template>
  <header class="py-6 px-10 flex items-center justify-between bg-white sticky top-0 z-50 shadow-sm">
    <!-- Search / Menu Left -->
    <div class="flex items-center gap-6 flex-1">
      <button class="hover:text-[#c48f56] transition-colors">
        <span class="material-symbols-outlined text-2xl">search</span>
      </button>

    </div>
    
    <!-- Logo -->
    <div class="flex-shrink-0 text-center flex-1 flex justify-center">
      <img src="/logo.jpg" alt="Handart Logo" class="w-16 h-16 rounded-full object-cover border border-slate-200" />
    </div>

    <!-- Icons Right -->
    <div class="flex items-center gap-4 flex-1 justify-end">
      <div class="hidden lg:flex gap-8 text-[13px] uppercase tracking-widest font-semibold text-[#222] mr-6">
        <a href="#" class="hover:text-[#c48f56] transition-colors">Blog</a>
        <a href="#" class="hover:text-[#c48f56] transition-colors">Contact</a>
      </div>
    </div>
  </header>
</template>
