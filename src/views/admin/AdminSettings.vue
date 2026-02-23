<template>
  <div>
    <div class="flex items-center justify-between mb-8">
      <div>
        <h1 class="text-3xl font-bold font-serif text-[#333]">Store Settings</h1>
        <p class="text-sm text-slate-500 mt-2">Manage your global store configuration here.</p>
      </div>
    </div>

    <div class="bg-white rounded shadow-sm border border-slate-200 p-8 max-w-2xl">
      <form @submit.prevent="saveSettings">
        
        <!-- Hero Slideshow Images -->
        <div class="form-control w-full mb-6">
          <label class="label"><span class="label-text font-bold text-slate-600">Home Page Hero Slideshow Images</span></label>
          <p class="text-xs text-slate-500 mb-4">Drag and drop to reorder. The first image will be shown first.</p>
          
          <div class="flex flex-wrap gap-4 mb-4" v-if="form.hero_gallery_urls && form.hero_gallery_urls.length > 0">
            <div v-for="(url, index) in form.hero_gallery_urls" :key="url" 
                 draggable="true"
                 @dragstart="onDragStart(index, $event)"
                 @dragover.prevent="onDragOver($event)"
                 @drop="onDrop(index, $event)"
                 class="relative group w-32 h-24 border border-slate-200 rounded-md overflow-hidden bg-slate-50 cursor-grab active:cursor-grabbing">
              <img :src="url" class="object-cover w-full h-full pointer-events-none" />
              
              <div class="absolute inset-0 bg-black/60 opacity-0 group-hover:opacity-100 flex flex-col justify-center items-center gap-2 transition-opacity">
                <button type="button" @click.prevent="removeImage(index)" class="btn btn-xs btn-error text-white border-none text-[10px]">Remove</button>
              </div>

              <div class="absolute top-1 left-1 bg-black/50 text-white text-[9px] font-bold px-1 rounded shadow-sm">{{ index + 1 }}</div>
            </div>
          </div>

          <div class="border-2 border-dashed border-slate-300 rounded-lg p-6 flex flex-col items-center justify-center hover:border-[#0bbcd4] transition-colors cursor-pointer bg-slate-50 relative group" style="min-height: 120px;">
            <input type="file" multiple @change="uploadHeroImages" class="absolute inset-0 opacity-0 cursor-pointer z-10" accept="image/*" />
            
            <div class="text-center z-0">
              <span class="material-symbols-outlined text-4xl text-slate-300 group-hover:text-[#0bbcd4] transition-colors mb-2">
                {{ uploading ? 'hourglass_empty' : 'cloud_upload' }}
              </span>
              <p class="text-xs text-slate-400 font-bold uppercase tracking-wider">
                {{ uploading ? 'Uploading...' : 'Upload Pictures' }}
              </p>
            </div>
          </div>
        </div>

        <div class="pt-6 border-t border-slate-100 flex justify-end">
          <button type="submit" class="btn bg-[#0bbcd4] hover:bg-[#0aa3b8] text-white rounded border-none px-10" :disabled="saving">
            {{ saving ? 'Saving...' : 'Save Settings' }}
          </button>
        </div>
      </form>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { supabase } from '../../lib/supabaseClient'

const form = ref({
  id: 1,
  hero_gallery_urls: []
})
const uploading = ref(false)
const saving = ref(false)
const draggedImageIndex = ref(null)

const onDragStart = (index, event) => {
  draggedImageIndex.value = index
  event.dataTransfer.effectAllowed = 'move'
}

const onDrop = (index, event) => {
  if (draggedImageIndex.value === null) return
  const dragIndex = draggedImageIndex.value
  const dropIndex = index
  if (dragIndex === dropIndex) return
  
  const newArray = [...form.value.hero_gallery_urls]
  const [removed] = newArray.splice(dragIndex, 1)
  newArray.splice(dropIndex, 0, removed)
  form.value.hero_gallery_urls = newArray
  draggedImageIndex.value = null
}

const onDragOver = (event) => {
  event.preventDefault()
  event.dataTransfer.dropEffect = 'move'
}

const removeImage = (index) => {
  form.value.hero_gallery_urls.splice(index, 1)
}

const loadSettings = async () => {
  const { data, error } = await supabase.from('settings').select('*').eq('id', 1).single()
  if (data) {
    form.value.hero_gallery_urls = data.hero_gallery_urls || []
  } else if (error && error.code !== 'PGRST116') {
    console.error('Error loading settings:', error)
  }
}

onMounted(() => {
  loadSettings()
})

const uploadHeroImages = async (event) => {
  const files = event.target.files
  if (!files || files.length === 0) return

  uploading.value = true
  if (!form.value.hero_gallery_urls) form.value.hero_gallery_urls = []
  
  for (let i = 0; i < files.length; i++) {
    const file = files[i]
    const fileExt = file.name.split('.').pop()
    const fileName = `hero_${Math.random()}.${fileExt}`
    const filePath = `${fileName}`

    const { error: uploadError } = await supabase.storage
      .from('store-assets')
      .upload(filePath, file)

    if (uploadError) {
      if (uploadError.message.includes('Bucket not found')) {
        const { error: fallbackError } = await supabase.storage
          .from('product-images')
          .upload(filePath, file)
          
        if(fallbackError) {
           alert('Error uploading:', fallbackError.message)
        } else {
           const { data } = supabase.storage.from('product-images').getPublicUrl(filePath)
           form.value.hero_gallery_urls.push(data.publicUrl)
        }
      } else {
        console.error('Error uploading image:', uploadError)
        alert('Error uploading image: ' + uploadError.message)
      }
    } else {
      const { data } = supabase.storage.from('store-assets').getPublicUrl(filePath)
      form.value.hero_gallery_urls.push(data.publicUrl)
    }
  }
  
  uploading.value = false
  event.target.value = ''
}

const saveSettings = async () => {
  saving.value = true
  const { error } = await supabase
    .from('settings')
    .upsert([
      { id: 1, hero_gallery_urls: form.value.hero_gallery_urls }
    ])
    
  if (error) {
    console.error('Error saving settings:', error)
    alert('Failed to save settings: ' + error.message)
  } else {
    alert('Settings saved successfully!')
  }
  saving.value = false
}
</script>
