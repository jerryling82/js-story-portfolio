<template>
  <footer class="bg-white border-t border-[#eee]">
    <!-- Newsletter Section -->
    <div class="max-w-[800px] mx-auto py-24 px-4 text-center border-b border-[#eee]">
      <h3 class="text-2xl md:text-3xl font-['Playfair_Display',serif] text-[#222] mb-4 font-light tracking-wide">Stay Connected</h3>
      <p class="text-[14px] text-[#888] font-sans font-light mb-10 max-w-lg mx-auto">
        Join our community to discover new collections and exclusive pieces.
      </p>
      <form @submit.prevent="handleSubscribe" class="flex items-center max-w-[400px] mx-auto border-b border-[#ccc] pb-2 relative">
        <input 
          type="email" 
          v-model="email"
          required
          :disabled="loading"
          placeholder="Your email address" 
          @invalid="(e) => e.target.setCustomValidity('Please fill out your email address.')"
          @input="(e) => e.target.setCustomValidity('')"
          class="flex-1 py-2 px-2 text-[12px] text-[#333] outline-none font-sans bg-transparent tracking-widest placeholder-[#bbb] disabled:opacity-50"
        >
        <button 
          type="submit" 
          :disabled="loading"
          class="text-[#222] px-4 py-2 text-[10px] font-bold uppercase tracking-widest hover:text-[#888] cursor-pointer transition-colors disabled:opacity-50 disabled:cursor-not-allowed">
          {{ loading ? 'Subscribing...' : 'Subscribe' }}
        </button>
        <p v-if="message" :class="isSuccess ? 'text-green-600' : 'text-red-500'" class="absolute -bottom-6 w-full text-[10px] font-sans text-center tracking-widest">
          {{ message }}
        </p>
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

<script setup>
import { ref } from 'vue'
import { supabase } from '../lib/supabaseClient'

const email = ref('')
const loading = ref(false)
const message = ref('')
const isSuccess = ref(false)

const handleSubscribe = async () => {
  if (!email.value) return
  
  loading.value = true
  message.value = ''
  
  try {
    const { error } = await supabase
      .from('subscribers')
      .insert([{ email: email.value.trim() }])
      
    if (error) {
      if (error.code === '23505') { // Postgres unique constraint error code
        message.value = 'You are already subscribed!'
        isSuccess.value = true
        email.value = ''
      } else {
        throw error
      }
    } else {
      message.value = 'Thank you for subscribing!'
      isSuccess.value = true
      email.value = ''
    }
  } catch (err) {
    console.error('Subscription error:', err)
    message.value = 'An error occurred. Please try again.'
    isSuccess.value = false
  } finally {
    loading.value = false
    setTimeout(() => {
      message.value = ''
    }, 4000)
  }
}
</script>
