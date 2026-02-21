<template>
  <div>
    <div class="flex items-center justify-between mb-8">
      <div>
        <h1 class="text-3xl font-bold font-serif text-[#333]">Categories</h1>
        <p class="text-sm text-slate-500 mt-2">Manage your product categories.</p>
      </div>
      <button class="btn bg-[#0bbcd4] hover:bg-[#0aa3b8] text-white border-none rounded" @click="openModal()">
        <span class="material-symbols-outlined text-[18px]">add</span> Add Category
      </button>
    </div>

    <!-- Data Table -->
    <div class="bg-white rounded shadow-sm border border-slate-200 overflow-hidden">
      <table class="table table-zebra w-full text-sm">
        <thead class="bg-slate-50 text-slate-600 font-bold uppercase tracking-wider text-[11px]">
          <tr>
            <th>ID</th>
            <th>Name</th>
            <th>Slug</th>
            <th>Description</th>
            <th class="text-right">Actions</th>
          </tr>
        </thead>
        <tbody class="text-slate-600">
          <tr v-for="cat in categories" :key="cat.id" class="hover:bg-slate-50 transition-colors">
            <td>{{ cat.id }}</td>
            <td class="font-bold text-[#333]">{{ cat.name }}</td>
            <td class="text-slate-400">{{ cat.slug }}</td>
            <td class="max-w-[300px] truncate">{{ cat.description }}</td>
            <td class="text-right space-x-2">
              <button class="btn btn-sm btn-ghost text-[#0bbcd4]" @click="openModal(cat)">Edit</button>
              <button class="btn btn-sm btn-ghost text-red-500" @click="deleteCategory(cat.id)">Delete</button>
            </td>
          </tr>
          <tr v-if="categories.length === 0">
            <td colspan="5" class="text-center py-8 text-slate-400">No categories found.</td>
          </tr>
        </tbody>
      </table>
    </div>

    <!-- Modal Form -->
    <dialog id="category_modal" class="modal">
      <div class="modal-box bg-white rounded-lg shadow-xl max-w-lg">
        <form method="dialog">
          <button class="btn btn-sm btn-circle btn-ghost absolute right-2 top-2">✕</button>
        </form>
        <h3 class="font-serif font-bold text-2xl text-[#333] mb-6">{{ isEditing ? 'Edit Category' : 'New Category' }}</h3>
        
        <form @submit.prevent="saveCategory" class="space-y-4">
          <div class="form-control">
            <label class="label"><span class="label-text font-bold text-slate-600">Category Name *</span></label>
            <input type="text" v-model="form.name" required class="input input-bordered w-full rounded focus:outline-none focus:border-[#0bbcd4] focus:ring-1 focus:ring-[#0bbcd4]" placeholder="e.g. Handmade Mugs" />
          </div>

          <div class="form-control">
            <label class="label"><span class="label-text font-bold text-slate-600">Slug</span></label>
            <input type="text" v-model="form.slug" class="input input-bordered w-full rounded focus:outline-none focus:border-[#0bbcd4] bg-slate-50" placeholder="e.g. handmade-mugs" />
          </div>

          <div class="form-control">
            <label class="label"><span class="label-text font-bold text-slate-600">Description</span></label>
            <textarea v-model="form.description" class="textarea textarea-bordered h-24 rounded focus:outline-none focus:border-[#0bbcd4]" placeholder="Describe the category..."></textarea>
          </div>

          <div class="modal-action mt-8">
            <button type="button" class="btn btn-ghost rounded" @click="closeModal">Cancel</button>
            <button type="submit" class="btn bg-[#0bbcd4] hover:bg-[#0aa3b8] text-white rounded border-none px-8">Save</button>
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
import { ref, watch, onMounted } from 'vue'
import { supabase } from '../../lib/supabaseClient'

const categories = ref([])
const form = ref({ id: null, name: '', slug: '', description: '' })
const isEditing = ref(false)

const loadCategories = async () => {
  const { data, error } = await supabase.from('categories').select('*').order('created_at', { ascending: false })
  if (error) {
    console.error('Error loading categories:', error)
  } else {
    categories.value = data
  }
}

onMounted(() => {
  loadCategories()
})

watch(() => form.value.name, (newName) => {
  if (!isEditing.value && newName) {
    form.value.slug = newName.toLowerCase().replace(/[\s_]+/g, '-').replace(/[^\w-]+/g, '')
  }
})

const openModal = (category = null) => {
  if (category) {
    isEditing.value = true
    form.value = { ...category }
  } else {
    isEditing.value = false
    form.value = { id: null, name: '', slug: '', description: '' }
  }
  document.getElementById('category_modal').showModal()
}

const closeModal = () => {
  document.getElementById('category_modal').close()
}

const saveCategory = async () => {
  const payload = {
    name: form.value.name,
    slug: form.value.slug,
    description: form.value.description
  }

  if (isEditing.value) {
    const { error } = await supabase.from('categories').update(payload).eq('id', form.value.id)
    if (error) console.error('Error updating category:', error)
  } else {
    const { error } = await supabase.from('categories').insert([payload])
    if (error) console.error('Error inserting category:', error)
  }
  
  await loadCategories()
  closeModal()
}

const deleteCategory = async (id) => {
  if(confirm('Are you sure you want to delete this category?')) {
    const { error } = await supabase.from('categories').delete().eq('id', id)
    if (error) {
      console.error('Error deleting category:', error)
      alert('Could not delete category. It might be in use by products.')
    } else {
      await loadCategories()
    }
  }
}
</script>
