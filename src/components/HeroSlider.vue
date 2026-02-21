<template>
  <div class="relative w-full h-[700px] md:h-[85vh] overflow-hidden bg-[#222]">
    <!-- Background Image -->
    <div class="absolute inset-0 bg-cover bg-center" style="background-image: url('https://scontent.fyyc7-1.fna.fbcdn.net/v/t1.6435-9/43346115_332671167501293_2080575702570106880_n.jpg?_nc_cat=106&ccb=1-7&_nc_sid=0327a3&_nc_ohc=t4t6YAffox4Q7kNvwEEUouY&_nc_oc=AdltUExi7blcmkX52cQ5xMjgr7N1Tf6IjCeoZ5oCyInVjT4Ch9e2mQX3ZWDBHs_mi7o&_nc_zt=23&_nc_ht=scontent.fyyc7-1.fna&_nc_gid=zomgBR4S7FEEPRMX-2H0MQ&oh=00_AfvrYP_UktVDXA1DY8gXlTE3EZfyncflyW9Elge8nss9AA&oe=69C0D44A');">
      <div class="absolute inset-0 bg-black/40"></div>
    </div>
    
    <!-- Transparent Header Overlay -->
    <header class="absolute top-0 w-full z-50 flex items-center justify-between px-8 py-5 text-white bg-transparent">
      <!-- Left Spacer -->
      <div class="hidden lg:block flex-1"></div>

      <!-- Center Logo -->
      <div class="flex-1 text-center flex flex-col items-center justify-center lg:ml-[-100px]">
        <img src="/logo.jpg" alt="Handart Logo" class="w-20 h-20 rounded-full object-cover border-2 border-white/50 shadow-lg" />
        <span class="text-[14px] font-sans tracking-[0.2em] font-light mt-4 hidden sm:block text-white" style="font-family: 'Inter', sans-serif;">Handmade Shop</span>
      </div>

      <!-- Right Nav Icons -->
      <div class="flex items-center justify-end gap-6 flex-1">
        <button class="hover:text-[#0bbcd4] transition-colors">
          <span class="material-symbols-outlined text-[24px] font-light">search</span>
        </button>
        <button class="hover:text-[#0bbcd4] transition-colors">
          <span class="material-symbols-outlined text-[28px] font-light">menu</span>
        </button>
      </div>
    </header>

    <!-- Hero Content -->
    <div class="absolute inset-0 flex flex-col items-center justify-center text-center px-4 animate-fade-in z-10">
      <h2 class="text-4xl md:text-6xl font-serif text-white mb-6 tracking-wide font-light">Elegance in Every Detail</h2>
      <p class="text-white/80 text-[13px] md:text-[15px] max-w-xl font-light mb-10 tracking-widest uppercase">
        Discover uniquely crafted pieces that speak to the soul.
      </p>
      <button class="px-10 py-4 border border-white/50 text-white text-[10px] font-semibold uppercase tracking-[0.2em] hover:bg-white hover:text-black hover:border-white transition-all duration-500">
        Explore Collection
      </button>
    </div>
  </div>
</template>
