<template>
  <div class="min-h-screen bg-white text-[#333] font-['Inter',sans-serif]">
    <!-- Hero Slider includes the Header Nav overlay -->
    <HeroSlider />
    
    <!-- Welcome To js.story.handmade Section -->
    <WelcomeSection />
    
    <!-- Mostviewed Products -->
    <ProductTabs />
    
    <!-- Footer with Newsletter -->
    <Footer />
  </div>
</template>

<script setup>
import HeroSlider from '../components/HeroSlider.vue'
import WelcomeSection from '../components/WelcomeSection.vue'
import ProductTabs from '../components/ProductTabs.vue'
import Footer from '../components/Footer.vue'
</script>
