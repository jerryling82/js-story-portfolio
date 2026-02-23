<template>
  <div>
    <div class="flex items-center justify-between mb-8">
      <div>
        <h1 class="text-3xl font-bold font-serif text-[#333]">Products</h1>
        <p class="text-sm text-slate-500 mt-2">Manage your inventory, prices, and images.</p>
      </div>
      <button class="btn bg-[#0bbcd4] hover:bg-[#0aa3b8] text-white border-none rounded" @click="openModal()">
        <span class="material-symbols-outlined text-[18px]">add</span> Add Product
      </button>
    </div>

    <!-- Data Table -->
    <div class="bg-white rounded shadow-sm border border-slate-200 overflow-hidden overflow-x-auto">
      <table class="table table-zebra w-full text-sm">
        <thead class="bg-slate-50 text-slate-600 font-bold uppercase tracking-wider text-[11px]">
          <tr>
            <th>Image</th>
            <th>Name</th>
            <th>Category</th>
            <th>Price</th>
            <th>Discount</th>
            <th>Ordering</th>
            <th class="text-right">Actions</th>
          </tr>
        </thead>
        <tbody class="text-slate-600">
          <tr v-for="prod in products" :key="prod.id" class="hover:bg-slate-50 transition-colors">
            <td>
              <div class="avatar">
                <div class="w-12 h-12 rounded bg-slate-100 flex items-center justify-center overflow-hidden">
                  <img :src="prod.img_url" alt="product image" v-if="prod.img_url" class="w-full h-full object-cover" />
                  <span v-else class="material-symbols-outlined text-[#ccc]">image</span>
                </div>
              </div>
            </td>
            <td class="font-bold text-[#333]">
              <div class="w-48 truncate">{{ prod.name }}</div>
            </td>
            <td><span class="badge badge-ghost text-xs bg-slate-100">{{ getCategoryName(prod.category_id) }}</span></td>
            <td class="font-mono">${{ Number(prod.price).toFixed(2) }}</td>
            <td>
              <span v-if="prod.discount" class="text-red-500 font-bold">-{{ prod.discount }}%</span>
              <span v-else class="text-slate-300">-</span>
            </td>
            <td class="font-mono text-center">{{ prod.ordering }}</td>
            <td class="text-right space-x-2">
              <button class="btn btn-sm btn-ghost text-[#0bbcd4]" @click="openModal(prod)">Edit</button>
              <button class="btn btn-sm btn-ghost text-red-500" @click="deleteProduct(prod.id)">Delete</button>
            </td>
          </tr>
          <tr v-if="products.length === 0">
            <td colspan="7" class="text-center py-8 text-slate-400">No products found.</td>
          </tr>
        </tbody>
      </table>
    </div>

    <!-- Large Form Modal -->
    <dialog id="product_modal" class="modal">
      <div class="modal-box bg-white rounded-lg shadow-xl max-w-6xl w-11/12 max-h-[90vh] overflow-y-auto custom-scrollbar">
        <form method="dialog">
          <button class="btn btn-sm btn-circle btn-ghost absolute right-4 top-4">✕</button>
        </form>
        <h3 class="font-serif font-bold text-2xl text-[#333] mb-6 border-b border-slate-100 pb-4">
          {{ isEditing ? 'Edit Product' : 'New Product' }}
        </h3>
        
        <form @submit.prevent="saveProduct" class="grid grid-cols-1 md:grid-cols-2 gap-6 relative">
          <!-- Left Column (Images & Basic Details) -->
          <div class="space-y-4">
            
            <div class="form-control md:col-span-2">
              <label class="label"><span class="label-text font-bold text-slate-600">Product Images (First image is Cover by default)</span></label>
              
              <div class="flex flex-wrap gap-4 mb-4" v-if="form.gallery_urls && form.gallery_urls.length > 0">
                <div v-for="(url, index) in form.gallery_urls" :key="url" 
                     draggable="true"
                     @dragstart="onDragStart(index, $event)"
                     @dragover.prevent="onDragOver($event)"
                     @drop="onDrop(index, $event)"
                     class="relative group w-24 h-24 border border-slate-200 rounded-md overflow-hidden bg-slate-50 cursor-grab active:cursor-grabbing">
                  <img :src="url" class="object-cover w-full h-full pointer-events-none" />
                  
                  <div class="absolute inset-0 bg-black/60 opacity-0 group-hover:opacity-100 flex flex-col justify-center items-center gap-2 transition-opacity">
                    <button type="button" v-if="form.img_url !== url" @click.prevent="form.img_url = url" class="btn btn-xs bg-[#0bbcd4] hover:bg-[#0aa3b8] text-white border-none text-[10px]">Set Cover</button>
                    <button type="button" @click.prevent="removeImage(index)" class="btn btn-xs btn-error text-white border-none text-[10px]">Remove</button>
                  </div>

                  <div v-if="form.img_url === url" class="absolute top-1 left-1 bg-[#0bbcd4] text-white text-[9px] font-bold px-1 rounded shadow-sm">COVER</div>
                </div>
              </div>

              <div class="border-2 border-dashed border-slate-300 rounded-lg p-6 flex flex-col items-center justify-center hover:border-[#0bbcd4] transition-colors cursor-pointer bg-slate-50 relative group" style="min-height: 120px;">
                <input type="file" multiple @change="handleImageUpload" class="absolute inset-0 opacity-0 cursor-pointer z-10" accept="image/*" />
                
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

            <div class="form-control md:col-span-2">
              <label class="label"><span class="label-text font-bold text-slate-600">Product Name *</span></label>
              <input type="text" v-model="form.name" required class="input input-bordered w-full rounded focus:outline-none focus:border-[#0bbcd4]" placeholder="e.g. Vintage Leather Bag" />
            </div>

            <div class="form-control md:col-span-2">
              <label class="label"><span class="label-text font-bold text-slate-600">Description</span></label>
              <textarea v-model="form.description" class="textarea textarea-bordered w-full h-32 rounded focus:outline-none focus:border-[#0bbcd4]" placeholder="Write a gorgeous description..."></textarea>
            </div>

            <div class="form-control md:col-span-2">
              <label class="label"><span class="label-text font-bold text-slate-600">Tags</span></label>
              <input type="text" v-model="form.tags_input" class="input input-bordered w-full rounded focus:outline-none focus:border-[#0bbcd4]" placeholder="Comma separated tags (e.g. handmade, necklace, silver)" />
            </div>
            
          </div>

          <!-- Right Column (Pricing & Config) -->
          <div class="space-y-4">
            <div class="form-control">
              <label class="label"><span class="label-text font-bold text-slate-600">Category *</span></label>
              <select v-model="form.category_id" required class="select select-bordered w-full rounded focus:outline-none focus:border-[#0bbcd4]">
                <option disabled value="">Pick a category</option>
                <option v-for="cat in availableCategories" :key="cat.id" :value="cat.id">{{ cat.name }}</option>
              </select>
            </div>

            <div class="grid grid-cols-2 gap-4">
              <div class="form-control">
                <label class="label"><span class="label-text font-bold text-slate-600">Price ($) *</span></label>
                <input type="number" step="0.01" v-model="form.price" required class="input input-bordered w-full rounded focus:outline-none focus:border-[#0bbcd4]" placeholder="0.00" />
              </div>
              <div class="form-control">
                <label class="label"><span class="label-text font-bold text-slate-600">Discount (%)</span></label>
                <input type="number" min="0" max="100" v-model="form.discount" class="input input-bordered w-full rounded focus:outline-none focus:border-[#0bbcd4]" placeholder="e.g. 20" />
              </div>
            </div>

            <div class="grid grid-cols-2 gap-4">
               <div class="form-control">
                <label class="label"><span class="label-text font-bold text-slate-600">Stock Quantity</span></label>
                <input type="number" v-model="form.stock" class="input input-bordered w-full rounded focus:outline-none focus:border-[#0bbcd4]" placeholder="10" />
              </div>
              <div class="form-control">
                <label class="label">
                  <span class="label-text font-bold text-slate-600">Display Ordering</span>
                  <div class="tooltip tooltip-bottom tooltip-info text-[10px]" data-tip="Lower numbers appear first">
                    <span class="material-symbols-outlined text-[14px] text-slate-400">info</span>
                  </div>
                </label>
                <input type="number" v-model="form.ordering" class="input input-bordered w-full rounded focus:outline-none focus:border-[#0bbcd4]" placeholder="0" />
              </div>
            </div>

            <div class="form-control mt-4">
              <label class="cursor-pointer label justify-start gap-4 p-4 border border-slate-200 rounded-lg hover:bg-slate-50 transition-colors">
                <input type="checkbox" v-model="form.is_active" class="toggle toggle-info toggle-sm" />
                <span class="label-text font-bold text-slate-600">Active (Visible in Store)</span> 
              </label>
            </div>

            <div class="col-span-1 md:col-span-2 flex justify-end gap-3 mt-10 pt-6 border-t border-slate-100">
               <button type="button" class="btn btn-ghost rounded px-6" @click="closeModal">Cancel</button>
               <button type="submit" class="btn bg-[#0bbcd4] hover:bg-[#0aa3b8] text-white rounded border-none px-10">Save Product</button>
            </div>
          </div>
        </form>
      </div>
      <form method="dialog" class="modal-backdrop">
        <button @click="closeModal">close</button>
      </form>
    </dialog>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { supabase } from '../../lib/supabaseClient'

const products = ref([])
const availableCategories = ref([])
const form = ref({ id: null, name: '', category_id: '', price: null, discount: null, ordering: 0, stock: 0, is_active: true, description: '', img_url: null, gallery_urls: [], tags: [], tags_input: '' })
const isEditing = ref(false)
const uploading = ref(false)
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
  
  const newArray = [...form.value.gallery_urls]
  const [removed] = newArray.splice(dragIndex, 1)
  newArray.splice(dropIndex, 0, removed)
  form.value.gallery_urls = newArray
  draggedImageIndex.value = null
}

const onDragOver = (event) => {
  event.preventDefault()
  event.dataTransfer.dropEffect = 'move'
}

const loadData = async () => {
  const [catRes, prodRes] = await Promise.all([
    supabase.from('categories').select('*'),
    supabase.from('products').select('*').order('created_at', { ascending: false })
  ])
  if (catRes.data) availableCategories.value = catRes.data
  if (prodRes.data) products.value = prodRes.data
}

onMounted(() => {
  loadData()
})

const getCategoryName = (id) => {
  const cat = availableCategories.value.find(c => c.id === id)
  return cat ? cat.name : 'Unknown'
}

const openModal = (prod = null) => {
  if (prod) {
    isEditing.value = true
    form.value = { ...prod, gallery_urls: prod.gallery_urls || [], tags: prod.tags || [], tags_input: (prod.tags || []).join(', ') }
  } else {
    isEditing.value = false
    form.value = { id: null, name: '', category_id: '', price: null, discount: null, ordering: 0, stock: 0, is_active: true, description: '', img_url: null, gallery_urls: [], tags: [], tags_input: '' }
  }
  document.getElementById('product_modal').showModal()
}

const closeModal = () => {
  document.getElementById('product_modal').close()
}

const handleImageUpload = async (event) => {
  const files = event.target.files
  if (!files || files.length === 0) return
  
  uploading.value = true
  if (!form.value.gallery_urls) form.value.gallery_urls = []
  
  for (let i = 0; i < files.length; i++) {
    const file = files[i]
    const fileExt = file.name.split('.').pop()
    const fileName = `${Math.random()}.${fileExt}`
    const filePath = `${fileName}`

    const { error: uploadError } = await supabase.storage
      .from('product-images')
      .upload(filePath, file)

    if (uploadError) {
      console.error('Error uploading image:', uploadError)
      alert('Error uploading image: ' + uploadError.message)
    } else {
      const { data } = supabase.storage.from('product-images').getPublicUrl(filePath)
      form.value.gallery_urls.push(data.publicUrl)
      
      if (!form.value.img_url) {
        form.value.img_url = data.publicUrl
      }
    }
  }
  
  uploading.value = false
  event.target.value = ''
}

const removeImage = (index) => {
  const removedUrl = form.value.gallery_urls[index]
  form.value.gallery_urls.splice(index, 1)
  
  if (form.value.img_url === removedUrl) {
    form.value.img_url = form.value.gallery_urls.length > 0 ? form.value.gallery_urls[0] : null
  }
}

const saveProduct = async () => {
  const payload = {
    name: form.value.name,
    category_id: form.value.category_id,
    price: form.value.price,
    discount: form.value.discount || null,
    stock: form.value.stock || 0,
    ordering: form.value.ordering || 0,
    is_active: form.value.is_active,
    description: form.value.description,
    img_url: form.value.img_url,
    gallery_urls: form.value.gallery_urls,
    tags: form.value.tags_input.split(',').map(tag => tag.trim()).filter(tag => tag)
  }

  if (isEditing.value) {
    const { error } = await supabase.from('products').update(payload).eq('id', form.value.id)
    if (error) console.error('Error updating product:', error)
  } else {
    const { error } = await supabase.from('products').insert([payload])
    if (error) console.error('Error inserting product:', error)
  }
  
  await loadData()
  closeModal()
}

const deleteProduct = async (id) => {
  if(confirm('Are you sure you want to delete this product?')) {
    const { error } = await supabase.from('products').delete().eq('id', id)
    if (error) console.error('Error deleting product:', error)
    else await loadData()
  }
}
</script>

<style scoped>
.custom-scrollbar::-webkit-scrollbar {
  width: 6px;
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
