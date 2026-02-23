<template>
  <div class="relative w-full h-[700px] md:h-[85vh] overflow-hidden bg-[#222]">
    <!-- Background Image Slider -->
    <div v-for="(img, idx) in heroGalleryUrls" :key="img"
         class="absolute inset-0 bg-cover bg-center transition-opacity duration-[2000ms] ease-in-out"
         :style="{ backgroundImage: `url(${img})` }"
         :class="idx === currentImageIndex ? 'opacity-100 z-0' : 'opacity-0 z-0'">
    </div>
    <!-- Dark overlay over everything -->
    <div class="absolute inset-0 bg-black/40 z-[1]"></div>
    
    <!-- Transparent Header Overlay -->
    <header class="absolute top-0 w-full z-50 flex items-center justify-between px-8 py-5 text-white bg-transparent">
      <!-- Left Spacer -->
      <div class="flex-1"></div>

      <!-- Center Logo -->
      <div class="flex-1 text-center flex flex-col items-center justify-center">
        <img src="/logo-transparent.png" alt="Handart Logo" class="w-32 h-auto object-contain filter drop-shadow-md" />
        <span class="text-[14px] font-sans tracking-[0.2em] font-light mt-4 hidden sm:block text-white" style="font-family: 'Inter', sans-serif;">Calgary Handmade Shop</span>
      </div>

      <!-- Right Nav Icons -->
      <div class="flex items-center justify-end gap-6 flex-1">
      </div>
    </header>

    <!-- Hero Content -->
    <div class="absolute inset-0 flex flex-col items-center justify-center text-center px-4 animate-fade-in z-10">
      <h2 class="text-4xl md:text-6xl font-serif text-white mb-6 tracking-wide font-light">Elegance in Every Detail</h2>
      <p class="text-white/80 text-[13px] md:text-[15px] max-w-xl font-light mb-10 tracking-widest uppercase">
        Discover uniquely crafted pieces that speak to the soul.
      </p>
      <a href="#collection" class="px-10 py-4 border border-white/50 text-white text-[10px] font-semibold uppercase tracking-[0.2em] hover:bg-white hover:text-black hover:border-white transition-all duration-500 inline-block">
        Explore Collection
      </a>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, onUnmounted } from 'vue'
import { supabase } from '../lib/supabaseClient'

const heroGalleryUrls = ref([
  'https://scontent.fyyc7-1.fna.fbcdn.net/v/t1.6435-9/43346115_332671167501293_2080575702570106880_n.jpg?_nc_cat=106&ccb=1-7&_nc_sid=0327a3&_nc_ohc=t4t6YAffox4Q7kNvwEEUouY&_nc_oc=AdltUExi7blcmkX52cQ5xMjgr7N1Tf6IjCeoZ5oCyInVjT4Ch9e2mQX3ZWDBHs_mi7o&_nc_zt=23&_nc_ht=scontent.fyyc7-1.fna&_nc_gid=zomgBR4S7FEEPRMX-2H0MQ&oh=00_AfvrYP_UktVDXA1DY8gXlTE3EZfyncflyW9Elge8nss9AA&oe=69C0D44A'
])
const currentImageIndex = ref(0)
let sliderInterval = null

const startSlider = () => {
  if (heroGalleryUrls.value.length > 1) {
    sliderInterval = setInterval(() => {
      currentImageIndex.value = (currentImageIndex.value + 1) % heroGalleryUrls.value.length
    }, 5000)
  }
}

const loadSettings = async () => {
  const { data } = await supabase.from('settings').select('hero_gallery_urls').eq('id', 1).single()
  if (data && data.hero_gallery_urls && data.hero_gallery_urls.length > 0) {
    heroGalleryUrls.value = data.hero_gallery_urls
  }
  startSlider()
}

onMounted(() => {
  loadSettings()
})

onUnmounted(() => {
  if (sliderInterval) clearInterval(sliderInterval)
})
</script>
