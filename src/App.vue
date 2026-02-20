<template>
  <div class="min-h-screen bg-stone-50 text-stone-800 font-serif">
    <!-- Navigation -->
    <nav class="p-6 flex justify-between items-center border-b border-stone-200 bg-white/80 backdrop-blur-sm sticky top-0 z-50">
      <h1 class="text-2xl font-light tracking-widest uppercase">JS Story</h1>
      <div class="space-x-8 text-sm uppercase tracking-wider font-sans">
        <a href="#" class="hover:text-stone-500 transition-colors">Portfolio</a>
        <a href="#" class="hover:text-stone-500 transition-colors">Dashboard</a>
        <a href="#" class="hover:text-stone-500 transition-colors">About</a>
      </div>
    </nav>

    <!-- Hero Section -->
    <header class="max-w-4xl mx-auto py-24 px-6 text-center">
      <h2 class="text-5xl md:text-6xl font-light mb-8 italic">Handcrafted stories in every detail.</h2>
      <p class="text-lg text-stone-600 max-w-xl mx-auto font-sans leading-relaxed">
        Unique, handmade jewelry pieces that capture moments and memories. 
        Each creation is a chapter in a beautiful story.
      </p>
    </header>

    <!-- Portfolio Grid (Placeholder) -->
    <main class="max-w-6xl mx-auto px-6 pb-24">
      <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-12">
        <div v-for="i in 6" :key="i" class="group cursor-pointer">
          <div class="aspect-[4/5] bg-stone-200 mb-4 overflow-hidden relative">
             <div class="absolute inset-0 flex items-center justify-center text-stone-400 group-hover:scale-110 transition-transform duration-700">
               [ Jewelry Piece {{ i }} ]
             </div>
          </div>
          <h3 class="text-lg font-light tracking-wide uppercase">Floral Essence Ring No.{{ i }}</h3>
          <p class="text-sm text-stone-500 font-sans mt-1">Hand-cast Silver & Quartz</p>
        </div>
      </div>
    </main>

    <!-- Simple Dashboard Preview (Admin Only Concept) -->
    <section class="bg-stone-900 text-stone-100 py-16 px-6">
      <div class="max-w-4xl mx-auto flex flex-col md:flex-row items-center justify-between gap-8">
        <div>
          <h3 class="text-2xl font-light mb-2">Business Dashboard</h3>
          <p class="text-stone-400 font-sans text-sm">Post to Instagram & Facebook instantly.</p>
        </div>
        <button class="px-8 py-3 bg-white text-stone-900 uppercase text-xs tracking-widest font-sans font-bold hover:bg-stone-200 transition-colors">
          Open Admin Portal
        </button>
      </div>
    </section>

    <footer class="p-12 text-center text-stone-400 text-xs tracking-widest uppercase font-sans">
      &copy; 2026 JS Story Handmade. Built with Heart.
    </footer>
  </div>
</template>

<script setup>
// Initial scaffolding for JS Story Portfolio
</script>

<style>
@import "tailwindcss";
@plugin "daisyui";

:root {
  --font-serif: "Playfair Display", serif;
  --font-sans: "Inter", sans-serif;
}
</style>
