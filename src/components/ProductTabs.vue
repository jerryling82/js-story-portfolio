<template>
  <section id="collection" class="py-24 bg-white border-t border-[#eee]">
    <!-- Header -->
    <div class="text-center mb-16 px-4">
      <h2 class="text-3xl font-['Playfair_Display',serif] font-light text-[#222] mb-6 tracking-wide">Curated Collection</h2>
      <div class="w-8 h-[1px] bg-[#e0e0e0] mx-auto mb-10"></div>

      <!-- Tabs -->
      <div class="flex flex-wrap justify-center gap-8 md:gap-14 text-[10px] font-bold font-sans tracking-[0.2em] uppercase mb-10">
        <button 
          @click="filterProducts('all')" 
          :class="activeCategoryId === 'all' ? 'text-[#333] border-b border-[#333]' : 'text-[#aaa] hover:text-[#666] transition-colors'"
          class="pb-1"
        >
          All Pieces
        </button>
        <button 
          v-for="cat in categories" 
          :key="cat.id"
          @click="filterProducts(cat.id)"
          :class="activeCategoryId === cat.id ? 'text-[#333] border-b border-[#333]' : 'text-[#aaa] hover:text-[#666] transition-colors'"
          class="pb-1"
        >
          {{ cat.name }}
        </button>
      </div>

      <!-- Search Bar -->
      <div class="max-w-md mx-auto relative">
        <span class="material-symbols-outlined absolute left-4 top-1/2 -translate-y-1/2 text-slate-400 text-[20px]">search</span>
        <input 
          type="text" 
          v-model="searchQuery" 
          placeholder="Search pieces, tags, categories..." 
          class="w-full pl-12 pr-4 py-3 bg-[#fafafa] border border-slate-200 rounded-full focus:outline-none focus:border-[#222] focus:ring-1 focus:ring-[#222] transition-all font-sans text-sm font-light text-[#333]" 
        />
        <button v-if="searchQuery" @click="searchQuery = ''" class="absolute right-4 top-1/2 -translate-y-1/2 text-slate-400 hover:text-[#222] transition-colors">
          <span class="material-symbols-outlined text-[18px]">close</span>
        </button>
      </div>
    </div>

    <!-- Product Grid -->
    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-x-8 gap-y-16 max-w-[1300px] mx-auto px-6">
      <div v-for="product in filteredProducts()" :key="product.id" class="group flex flex-col cursor-pointer" @click="openQuickView(product)">
        
        <!-- Image Area -->
        <div class="relative bg-[#fafafa] aspect-[4/5] flex items-center justify-center mb-6 overflow-hidden">
          <img :src="product.img_url || 'https://picsum.photos/id/20/600/600'" alt="product image" class="object-cover w-full h-full transition-transform duration-1000 group-hover:scale-105" />
          
          <!-- Discount Badge (Minimalist) -->
          <div v-if="product.discount" class="absolute top-4 right-4 bg-white/90 backdrop-blur-sm text-[#222] px-3 py-1 rounded-sm text-[10px] uppercase tracking-widest font-bold">
            -{{ product.discount }}%
          </div>
        </div>

        <!-- Product Info -->
        <div class="text-center">
          <p class="text-[10px] text-[#aaa] font-sans mb-2 uppercase tracking-[0.2em]">{{ getCategoryName(product.category_id) }}</p>
          <h4 class="text-[14px] text-[#333] font-['Playfair_Display',serif] mb-2 group-hover:text-[#666] transition-colors truncate w-full tracking-wide">
            {{ product.name }}
          </h4>
          <div class="text-[13px] font-light text-[#555] font-sans">
            <span>${{ Number(product.price).toFixed(2) }}</span>
          </div>
        </div>
      </div>
      <div v-if="filteredProducts().length === 0" class="col-span-1 sm:col-span-2 lg:col-span-4 text-center py-20 text-[#aaa] font-light tracking-widest uppercase text-xs">
        No pieces found in this category.
      </div>
    </div>

    <!-- Quick View Dialog -->
    <dialog id="quick_view_modal" class="modal" @close="clearAutoplay">
      <div class="modal-box bg-white rounded-lg shadow-xl max-w-5xl w-11/12 p-0 overflow-hidden relative" v-if="selectedProduct">
        <form method="dialog">
          <button class="btn btn-sm btn-circle btn-ghost absolute right-4 top-4 z-50 hover:bg-black/10 transition-colors">✕</button>
        </form>

        <div class="flex flex-col md:flex-row h-full">
          <!-- Image Section -->
          <div class="w-full md:w-1/2 bg-[#fafafa] relative group flex flex-col">
            <!-- Gallery Slider / Selected Image -->
            <div class="aspect-[4/5] w-full relative overflow-hidden bg-slate-100">
              <img v-for="(img, idx) in selectedProduct.gallery_urls" 
                   :key="idx" 
                   :src="img" 
                   class="absolute inset-0 w-full h-full object-cover transition-opacity duration-[1500ms] ease-in-out" 
                   :class="idx === activeImageIndex ? 'opacity-100 z-10' : 'opacity-0 z-0'" />
              
              <!-- Navigation Arrows -->
              <button v-if="selectedProduct.gallery_urls && selectedProduct.gallery_urls.length > 1" @click.prevent="prevImage" class="absolute left-4 top-1/2 -translate-y-1/2 w-10 h-10 bg-white/80 hover:bg-white rounded-full flex items-center justify-center text-[#222] shadow-sm transition-all opacity-0 group-hover:opacity-100 z-10 focus:outline-none focus:ring-2 focus:ring-[#aaa]">
                <span class="material-symbols-outlined text-[20px] font-bold">chevron_left</span>
              </button>
              <button v-if="selectedProduct.gallery_urls && selectedProduct.gallery_urls.length > 1" @click.prevent="nextImage" class="absolute right-4 top-1/2 -translate-y-1/2 w-10 h-10 bg-white/80 hover:bg-white rounded-full flex items-center justify-center text-[#222] shadow-sm transition-all opacity-0 group-hover:opacity-100 z-10 focus:outline-none focus:ring-2 focus:ring-[#aaa]">
                <span class="material-symbols-outlined text-[20px] font-bold">chevron_right</span>
              </button>
            </div>
            
            <!-- Thumbnail Gallery -->
            <div class="flex gap-2 p-4 overflow-x-auto custom-scrollbar bg-white" v-if="selectedProduct.gallery_urls && selectedProduct.gallery_urls.length > 1">
              <button 
                v-for="(img, idx) in selectedProduct.gallery_urls" 
                :key="idx"
                @click.prevent="goToImage(idx)"
                class="w-16 h-20 flex-shrink-0 border-2 transition-all overflow-hidden focus:outline-none opacity-80 hover:opacity-100"
                :class="activeImageIndex === idx ? 'border-[#333] opacity-100' : 'border-transparent hover:border-gray-200'"
              >
                <img :src="img" class="w-full h-full object-cover" />
              </button>
            </div>
          </div>

          <!-- Product Details Section -->
          <div class="w-full md:w-1/2 p-8 md:p-12 flex flex-col justify-center">
            <p class="text-[10px] text-[#aaa] font-sans mb-3 uppercase tracking-[0.2em]">{{ getCategoryName(selectedProduct.category_id) }}</p>
            <h3 class="text-3xl font-['Playfair_Display',serif] text-[#222] mb-4 tracking-wide">{{ selectedProduct.name }}</h3>
            
            <div class="flex items-end gap-3 mb-8">
              <span class="text-xl font-light text-[#333] font-sans">${{ Number(selectedProduct.price).toFixed(2) }}</span>
              <span v-if="selectedProduct.discount" class="text-sm text-red-500 font-bold mb-[2px]">(-{{ selectedProduct.discount }}% OFF)</span>
            </div>

            <div class="w-12 h-[1px] bg-[#e0e0e0] mb-8"></div>

            <p class="text-[14px] text-[#666] font-light leading-relaxed mb-6 font-sans">
              {{ selectedProduct.description || 'A beautifully crafted piece designed with elegance in mind.' }}
            </p>

            <div class="flex flex-wrap gap-2 mb-10" v-if="selectedProduct.tags && selectedProduct.tags.length > 0">
              <span v-for="tag in selectedProduct.tags" :key="tag" class="px-3 py-1 bg-slate-100 text-[#555] text-[10px] uppercase tracking-widest rounded-sm cursor-pointer hover:bg-slate-200 transition-colors" @click="searchQuery = tag; closeModal()">
                #{{ tag }}
              </span>
            </div>

            <!-- Pre-order / Buy Button -->
            <button class="w-full py-4 bg-[#222] text-white text-[11px] font-bold uppercase tracking-[0.2em] hover:bg-[#444] transition-colors">
              Add To Cart
            </button>
          </div>
        </div>
      </div>
      <form method="dialog" class="modal-backdrop">
        <button>close</button>
      </form>
    </dialog>
  </section>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { supabase } from '../lib/supabaseClient'

const products = ref([])
const categories = ref([])
const activeCategoryId = ref('all')
const searchQuery = ref('')

const selectedProduct = ref(null)
const activeImageIndex = ref(0)
const autoplayInterval = ref(null)

const clearAutoplay = () => {
  if (autoplayInterval.value) {
    clearInterval(autoplayInterval.value)
    autoplayInterval.value = null
  }
}

const startAutoplay = () => {
  clearAutoplay()
  if (selectedProduct.value && selectedProduct.value.gallery_urls && selectedProduct.value.gallery_urls.length > 1) {
    autoplayInterval.value = setInterval(() => {
      const maxIdx = selectedProduct.value.gallery_urls.length - 1
      activeImageIndex.value = activeImageIndex.value === maxIdx ? 0 : activeImageIndex.value + 1
    }, 3000)
  }
}

const loadData = async () => {
  const [catRes, prodRes] = await Promise.all([
    supabase.from('categories').select('*'),
    supabase.from('products').select('*').eq('is_active', true).order('ordering', { ascending: true })
  ])
  if (catRes.data) categories.value = catRes.data
  if (prodRes.data) products.value = prodRes.data
}

onMounted(() => {
  loadData()
})

const getCategoryName = (id) => {
  const cat = categories.value.find(c => c.id === id)
  return cat ? cat.name : 'Unknown'
}

const filterProducts = (catId) => {
  activeCategoryId.value = catId
}

const filteredProducts = () => {
  let list = products.value;
  
  if (activeCategoryId.value !== 'all') {
    list = list.filter(p => p.category_id === activeCategoryId.value);
  }

  if (searchQuery.value.trim()) {
    const q = searchQuery.value.toLowerCase().trim();
    list = list.filter(p => {
      const catName = getCategoryName(p.category_id).toLowerCase();
      const pName = (p.name || '').toLowerCase();
      const pDesc = (p.description || '').toLowerCase();
      const pTags = (p.tags || []).join(' ').toLowerCase();

      return catName.includes(q) || pName.includes(q) || pDesc.includes(q) || pTags.includes(q);
    });
  }

  return list;
}

const prevImage = () => {
  if (selectedProduct.value && selectedProduct.value.gallery_urls) {
    const maxIdx = selectedProduct.value.gallery_urls.length - 1
    activeImageIndex.value = activeImageIndex.value === 0 ? maxIdx : activeImageIndex.value - 1
    startAutoplay() // Reset timer on manual interaction
  }
}

const nextImage = () => {
  if (selectedProduct.value && selectedProduct.value.gallery_urls) {
    const maxIdx = selectedProduct.value.gallery_urls.length - 1
    activeImageIndex.value = activeImageIndex.value === maxIdx ? 0 : activeImageIndex.value + 1
    startAutoplay() // Reset timer on manual interaction
  }
}

const goToImage = (idx) => {
  activeImageIndex.value = idx
  startAutoplay() // Reset timer on manual interaction
}

const closeModal = () => {
  document.getElementById('quick_view_modal').close()
}

const openQuickView = (product) => {
  selectedProduct.value = product
  
  // Also quietly ensure the cover image is in the gallery array if it isn't already, for a smooth slider experience
  if (product.gallery_urls) {
     if (!product.gallery_urls.includes(product.img_url)) {
         product.gallery_urls = [product.img_url, ...product.gallery_urls]
     }
  } else {
     product.gallery_urls = [product.img_url]
  }

  // Find index of cover image
  const coverIdx = product.gallery_urls.indexOf(product.img_url)
  activeImageIndex.value = coverIdx >= 0 ? coverIdx : 0

  document.getElementById('quick_view_modal').showModal()
  startAutoplay()
}
</script>

<style scoped>
.custom-scrollbar::-webkit-scrollbar {
  height: 4px;
}
.custom-scrollbar::-webkit-scrollbar-track {
  background: transparent; 
}
.custom-scrollbar::-webkit-scrollbar-thumb {
  background: #cbd5e1; 
  border-radius: 10px;
}
.custom-scrollbar::-webkit-scrollbar-thumb:hover {
  background: #94a3b8; 
}
</style>
