<template>
  <div>
    <div class="flex items-center justify-between mb-8">
      <div>
        <h1 class="text-3xl font-bold font-serif text-[#333]">Subscribers</h1>
        <p class="text-sm text-slate-500 mt-2">Manage your newsletter subscribers.</p>
      </div>
      <button class="btn bg-[#0bbcd4] hover:bg-[#0aa3b8] text-white border-none rounded" @click="exportCSV">
        <span class="material-symbols-outlined text-[18px]">download</span> Export CSV
      </button>
    </div>

    <!-- Data Table -->
    <div class="bg-white rounded shadow-sm border border-slate-200 overflow-hidden overflow-x-auto">
      <table class="table table-zebra w-full text-sm">
        <thead class="bg-slate-50 text-slate-600 font-bold uppercase tracking-wider text-[11px]">
          <tr>
            <th>Email</th>
            <th>Subscribed At</th>
            <th class="text-right">Actions</th>
          </tr>
        </thead>
        <tbody class="text-slate-600">
          <tr v-for="sub in subscribers" :key="sub.id" class="hover:bg-slate-50 transition-colors">
            <td class="font-bold text-[#333]">{{ sub.email }}</td>
            <td>{{ new Date(sub.created_at).toLocaleString() }}</td>
            <td class="text-right space-x-2">
              <button class="btn btn-sm btn-ghost text-red-500" @click="deleteSubscriber(sub.id)">Delete</button>
            </td>
          </tr>
          <tr v-if="subscribers.length === 0">
            <td colspan="3" class="text-center py-8 text-slate-400">No subscribers found.</td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { supabase } from '../../lib/supabaseClient'

const subscribers = ref([])

const loadData = async () => {
  const { data, error } = await supabase.from('subscribers').select('*').order('created_at', { ascending: false })
  if (data) subscribers.value = data
  if (error) console.error('Error loading subscribers:', error)
}

onMounted(() => {
  loadData()
})

const deleteSubscriber = async (id) => {
  if (confirm('Are you sure you want to delete this subscriber?')) {
    const { error } = await supabase.from('subscribers').delete().eq('id', id)
    if (error) {
      console.error('Error deleting subscriber:', error)
      alert('Error deleting subscriber')
    } else {
      await loadData()
    }
  }
}

const exportCSV = () => {
  if (subscribers.value.length === 0) return
  const headers = ['Email', 'Subscribed At']
  const csvContent = [
    headers.join(','),
    ...subscribers.value.map(sub => `"${sub.email}", "${new Date(sub.created_at).toLocaleString()}"`)
  ].join('\n')

  const blob = new Blob([csvContent], { type: 'text/csv;charset=utf-8;' })
  const url = URL.createObjectURL(blob)
  const link = document.createElement('a')
  link.setAttribute('href', url)
  link.setAttribute('download', 'subscribers.csv')
  link.style.visibility = 'hidden'
  document.body.appendChild(link)
  link.click()
  document.body.removeChild(link)
}
</script>
