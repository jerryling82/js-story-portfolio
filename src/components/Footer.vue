<template>
  <footer class="bg-white border-t border-[#eee]">
    <!-- Newsletter Section -->
    <div class="max-w-[800px] mx-auto py-24 px-4 text-center border-b border-[#eee]">
      <h3 class="text-2xl md:text-3xl font-['Playfair_Display',serif] text-[#222] mb-4 font-light tracking-wide">Stay Connected</h3>
      <p class="text-[14px] text-[#888] font-sans font-light mb-10 max-w-lg mx-auto">
        Join our community to discover new collections and exclusive pieces.
      </p>
      <form class="flex items-center max-w-[400px] mx-auto border-b border-[#ccc] pb-2">
        <input 
          type="email" 
          placeholder="Your email address" 
          class="flex-1 py-2 px-2 text-[12px] text-[#333] outline-none font-sans bg-transparent tracking-widest placeholder-[#bbb]"
        >
        <button class="text-[#222] px-4 py-2 text-[10px] font-bold uppercase tracking-widest hover:text-[#888] transition-colors">
          Subscribe
        </button>
      </form>
    </div>

    <!-- Bottom Footer -->
    <div class="max-w-[1400px] mx-auto py-8 px-6 flex flex-col md:flex-row justify-between items-center gap-6">
      <p class="text-[14px] font-sans text-[#777] font-light">
        © 2026 <span class="text-[#333] font-bold">js.story.handmade</span>. All Rights Reserved.
      </p>
      
      <!-- Socials -->
      <div class="flex items-center gap-6 text-[12px] text-[#222] font-semibold tracking-widest">
        <a href="https://www.instagram.com/js.story.handmade/" target="_blank" class="hover:text-[#aaa] transition-colors">IG</a>
        <a href="https://www.facebook.com/JsStoryHandmade" target="_blank" class="hover:text-[#aaa] transition-colors">FB</a>
        <a href="mailto:js.story.handmade@gmail.com" class="hover:text-[#aaa] transition-colors">EMAIL</a>
      </div>
    </div>
  </footer>
</template>
