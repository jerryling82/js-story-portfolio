import { createRouter, createWebHistory } from 'vue-router'
import HomeView from '../views/HomeView.vue'
import AdminLayout from '../views/admin/AdminLayout.vue'
import AdminCategories from '../views/admin/AdminCategories.vue'
import AdminProducts from '../views/admin/AdminProducts.vue'
import AdminLogin from '../views/admin/AdminLogin.vue'
import { supabase } from '../lib/supabaseClient'

const router = createRouter({
    history: createWebHistory(import.meta.env.BASE_URL),
    routes: [
        {
            path: '/',
            name: 'home',
            component: HomeView
        },
        {
            path: '/admin/login',
            name: 'admin-login',
            component: AdminLogin
        },
        {
            path: '/admin',
            component: AdminLayout,
            redirect: '/admin/products',
            meta: { requiresAuth: true },
            children: [
                {
                    path: 'categories',
                    name: 'admin-categories',
                    component: AdminCategories
                },
                {
                    path: 'products',
                    name: 'admin-products',
                    component: AdminProducts
                }
            ]
        }
    ]
})

router.beforeEach(async (to, from, next) => {
    const { data: { session } } = await supabase.auth.getSession()

    // If the route requires auth and there is no active session, redirect to login
    if (to.meta.requiresAuth && !session) {
        next({ name: 'admin-login' })
    }
    // If user tries to access the login page while already logged in, redirect them back to admin
    else if (to.name === 'admin-login' && session) {
        next({ name: 'admin-products' })
    }
    // Otherwise, proceed as normal
    else {
        next()
    }
})

export default router
