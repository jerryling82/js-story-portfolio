<template>
  <div class="min-h-screen bg-white text-[#333] font-['Playfair_Display',serif]">
    <!-- Top Header / Announcement -->
    <div class="bg-[#f5f5f5] text-[11px] py-2 px-10 flex justify-between uppercase tracking-widest border-b border-[#eee] font-sans">
      <span>Free Shipping Worldwide</span>
      <div class="flex gap-4">
        <a href="#" class="hover:text-amber-700">Login</a>
        <a href="#" class="hover:text-amber-700">Create Account</a>
      </div>
    </div>

    <!-- Main Navigation -->
    <nav class="py-10 px-10 flex flex-col items-center border-b border-[#eee] sticky top-0 bg-white z-50">
      <h1 class="text-4xl font-bold tracking-[0.2em] uppercase mb-8">JS Story</h1>
      <div class="flex gap-10 text-[13px] uppercase tracking-[0.15em] font-sans font-medium text-[#666]">
        <a href="#" class="hover:text-amber-800 transition-colors border-b border-transparent hover:border-amber-800 pb-1">Home</a>
        <a href="#" class="hover:text-amber-800 transition-colors border-b border-transparent hover:border-amber-800 pb-1">Shop Jewelry</a>
        <a href="#" class="hover:text-amber-800 transition-colors border-b border-transparent hover:border-amber-800 pb-1">Handmade</a>
        <a href="#" class="hover:text-amber-800 transition-colors border-b border-transparent hover:border-amber-800 pb-1">Dashboard</a>
        <a href="#" class="hover:text-amber-800 transition-colors border-b border-transparent hover:border-amber-800 pb-1">Contact</a>
      </div>
    </nav>

    <!-- Hero Slider Concept -->
    <section class="relative h-[700px] bg-[#f9f9f9] overflow-hidden flex items-center justify-center group">
      <div class="absolute inset-0 bg-[url('https://images.unsplash.com/photo-1515562141207-7a88fb7ce338?q=80&w=2070')] bg-cover bg-center transition-transform duration-1000 group-hover:scale-105"></div>
      <div class="absolute inset-0 bg-black/5"></div>
      <div class="relative z-10 text-center bg-white/90 backdrop-blur-sm p-16 border border-white max-w-2xl shadow-2xl animate-fade-in">
        <span class="text-amber-800 uppercase tracking-[0.3em] text-xs mb-4 block font-sans font-bold">New Collection 2026</span>
        <h2 class="text-6xl font-normal mb-8 leading-tight text-[#222]">Welcome To <br/> Handart Stories</h2>
        <p class="text-stone-500 font-sans text-sm leading-loose max-w-md mx-auto mb-10 uppercase tracking-widest">
          Unique jewelry that captures the soul of craftsmanship and elegance.
        </p>
        <button class="px-12 py-4 bg-[#222] text-white text-[11px] uppercase tracking-[0.3em] font-sans font-bold hover:bg-amber-800 transition-all duration-300">
          Discover Now
        </button>
      </div>
    </section>

    <!-- Welcome Section -->
    <section class="py-24 px-10 max-w-5xl mx-auto text-center">
      <h3 class="text-xs uppercase tracking-[0.4em] text-amber-800 mb-6 font-sans font-bold">Who Are We</h3>
      <h2 class="text-4xl mb-10 italic">Our Story & Craftsmanship</h2>
      <p class="text-[#777] font-sans text-[15px] leading-[2.2] max-w-3xl mx-auto">
        At JS Story, every piece is born from a moment of inspiration. We believe that jewelry should be as unique as the person wearing it. Our artisan process involves meticulous hand-casting, delicate polishing, and the selection of only the finest raw materials to create modern heirlooms.
      </p>
    </section>

    <!-- Product Grid -->
    <section class="py-20 bg-[#fafafa]">
      <div class="text-center mb-16">
        <h2 class="text-3xl uppercase tracking-[0.2em] font-bold mb-4">Latest Arrivals</h2>
        <div class="w-20 h-[2px] bg-amber-800 mx-auto"></div>
      </div>
      
      <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-0.5 px-0.5 max-w-[1600px] mx-auto">
        <div v-for="i in 8" :key="i" class="bg-white group cursor-pointer border border-[#f0f0f0] overflow-hidden">
          <div class="relative aspect-[1/1.2] overflow-hidden bg-[#f5f5f5]">
            <!-- Placeholder Image logic -->
            <div class="absolute inset-0 flex items-center justify-center text-[#999] text-xs uppercase tracking-tighter transition-all duration-700 group-hover:scale-110">
               [ Sample Jewelry {{ i }} ]
            </div>
            <!-- Badges -->
            <div class="absolute top-4 left-4 flex flex-col gap-2">
              <span class="bg-[#222] text-white text-[9px] uppercase px-3 py-1 font-bold tracking-widest" v-if="i % 3 === 0">New</span>
              <span class="bg-amber-800 text-white text-[9px] uppercase px-3 py-1 font-bold tracking-widest" v-if="i % 2 === 0">-20%</span>
            </div>
            <!-- Quick Action Overlay -->
            <div class="absolute bottom-0 left-0 right-0 p-4 translate-y-full group-hover:translate-y-0 transition-transform duration-500 bg-white/95 border-t border-[#eee] flex justify-center gap-6">
               <button class="hover:text-amber-800 transition-colors"><span class="material-symbols-outlined text-[20px]">shopping_bag</span></button>
               <button class="hover:text-amber-800 transition-colors"><span class="material-symbols-outlined text-[20px]">favorite</span></button>
               <button class="hover:text-amber-800 transition-colors"><span class="material-symbols-outlined text-[20px]">search</span></button>
            </div>
          </div>
          <div class="p-8 text-center bg-white">
            <p class="text-[10px] text-[#999] uppercase tracking-widest mb-2 font-sans">Handmade Silver</p>
            <h4 class="text-[15px] font-normal mb-3 hover:text-amber-800 transition-colors">Aopo Designs Woolrich Klettersack</h4>
            <div class="text-[14px] font-bold text-[#333]">
              <span class="text-amber-800 mr-2">$120.00</span>
              <span class="text-[#bbb] line-through font-normal" v-if="i % 2 === 0">$150.00</span>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- Services / Trust Badges -->
    <section class="py-20 px-10 grid grid-cols-1 md:grid-cols-3 gap-10 max-w-7xl mx-auto border-b border-[#eee]">
      <div class="flex flex-col items-center text-center">
        <div class="w-16 h-16 border border-[#eee] rounded-full flex items-center justify-center mb-6">
          <span class="material-symbols-outlined text-2xl text-stone-400">local_shipping</span>
        </div>
        <h4 class="text-xs uppercase tracking-[0.2em] font-bold mb-3 font-sans">Free Shipping</h4>
        <p class="text-stone-400 text-xs leading-loose font-sans uppercase">Mirum est notare quam littera gothica</p>
      </div>
      <div class="flex flex-col items-center text-center">
        <div class="w-16 h-16 border border-[#eee] rounded-full flex items-center justify-center mb-6">
          <span class="material-symbols-outlined text-2xl text-stone-400">history</span>
        </div>
        <h4 class="text-xs uppercase tracking-[0.2em] font-bold mb-3 font-sans">Money Back Guarantee</h4>
        <p class="text-stone-400 text-xs leading-loose font-sans uppercase">Mirum est notare quam littera gothica</p>
      </div>
      <div class="flex flex-col items-center text-center">
        <div class="w-16 h-16 border border-[#eee] rounded-full flex items-center justify-center mb-6">
          <span class="material-symbols-outlined text-2xl text-stone-400">headset_mic</span>
        </div>
        <h4 class="text-xs uppercase tracking-[0.2em] font-bold mb-3 font-sans">Online Support 24/7</h4>
        <p class="text-stone-400 text-xs leading-loose font-sans uppercase">Mirum est notare quam littera gothica</p>
      </div>
    </section>

    <!-- Footer -->
    <footer class="py-20 px-10 bg-white">
      <div class="max-w-7xl mx-auto grid grid-cols-1 md:grid-cols-4 gap-12 border-b border-[#eee] pb-20">
        <div class="col-span-1 md:col-span-1">
          <h2 class="text-xl font-bold tracking-[0.2em] uppercase mb-10">JS Story</h2>
          <p class="text-stone-400 text-[13px] leading-[1.8] font-sans">
             Address: 123 Artisan Way, Creative District, AB<br/>
             Phone: (555) 123-4567<br/>
             Email: hello@jsstory.com
          </p>
        </div>
        <div v-for="title in ['Information', 'Customer Service', 'My Account']" :key="title">
          <h4 class="text-[11px] uppercase tracking-[0.2em] font-bold mb-10 font-sans">{{ title }}</h4>
          <ul class="flex flex-col gap-4 text-stone-400 text-[13px] font-sans">
            <li v-for="item in ['About Us', 'Contact Us', 'Privacy Policy', 'Terms & Conditions']" :key="item">
              <a href="#" class="hover:text-amber-800 transition-colors">{{ item }}</a>
            </li>
          </ul>
        </div>
      </div>
      <div class="pt-10 text-center">
        <p class="text-[#999] text-[11px] uppercase tracking-[0.2em] font-sans font-bold">
          © 2026 JS Story Handmade. Powered by OpenClaw.
        </p>
      </div>
    </footer>
  </div>
</template>

<script setup>
// Handart-inspired Luxury Handmade Theme Implementation
</script>

<style>
@import url('https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400;0,700;1,400&family=Inter:wght@400;500;700&display=swap');
@import "tailwindcss";
@plugin "daisyui";

body {
  margin: 0;
  -webkit-font-smoothing: antialiased;
}

@keyframes fade-in {
  from { opacity: 0; transform: translateY(20px); }
  to { opacity: 1; transform: translateY(0); }
}

.animate-fade-in {
  animation: fade-in 1.2s cubic-bezier(0.16, 1, 0.3, 1) forwards;
}

/* Material Icons Support */
@import url('https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200');
</style>
