<template>
  <div class="min-h-screen bg-slate-50 flex items-center justify-center p-4">
    <div class="bg-white p-8 rounded-lg shadow-xl max-w-sm w-full border border-slate-200">
      <div class="text-center mb-8">
        <h2 class="text-4xl font-serif text-[#333] font-bold tracking-widest mb-2">js.story.handmade<span class="text-[#0bbcd4]">.</span></h2>
        <p class="text-sm text-slate-500 uppercase tracking-widest font-bold">Admin Portal</p>
      </div>

      <form @submit.prevent="handleLogin" class="space-y-6">
        <div class="form-control">
          <label class="label"><span class="label-text font-bold text-slate-600">Email Server</span></label>
          <input type="email" v-model="email" required class="input input-bordered w-full rounded focus:outline-none focus:border-[#0bbcd4]" placeholder="admin@js.story.handmade.com" />
        </div>

        <div class="form-control">
          <label class="label"><span class="label-text font-bold text-slate-600">Password</span></label>
          <input type="password" v-model="password" required class="input input-bordered w-full rounded focus:outline-none focus:border-[#0bbcd4]" placeholder="••••••••" />
        </div>

        <div v-if="errorMsg" class="text-red-500 text-xs text-center bg-red-50 p-2 rounded">
          {{ errorMsg }}
        </div>

        <button type="submit" class="btn bg-[#0bbcd4] hover:bg-[#0aa3b8] text-white w-full border-none rounded" :disabled="loading">
          {{ loading ? 'Signing In...' : 'Sign In' }}
        </button>
      </form>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { supabase } from '../../lib/supabaseClient'

const router = useRouter()
const email = ref('')
const password = ref('')
const errorMsg = ref('')
const loading = ref(false)

const handleLogin = async () => {
  try {
    loading.value = true
    errorMsg.value = ''
    
    const { error } = await supabase.auth.signInWithPassword({
      email: email.value,
      password: password.value,
    })

    if (error) throw error
    
    // On success, redirect to the admin dashboard
    router.push('/admin')
  } catch (error) {
    errorMsg.value = error.message
  } finally {
    loading.value = false
  }
}
</script>
