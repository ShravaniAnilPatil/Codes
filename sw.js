const CACHE_NAME = "ecommerce-pwa-cache-v1";
const urlsToCache = [
    "/",             // Root path
    "/index.html",   // Main page
    "/style.css",   // CSS file
    "/index.js",       // Main JavaScript file
    "/flipkart.png",
    "flipkart4.png",
    "/electronics.png",
    "/fashion.png",
    "/home.png",
    "/books.png"
];

// Install event: Cache static assets
self.addEventListener('install', (event) => {
    event.waitUntil(
        caches.open(CACHE_NAME)
            .then(cache => {
                console.log("Opened cache");
                return Promise.all(
                    urlsToCache.map(url =>
                        fetch(url) // Try to fetch the file first
                            .then(response => {
                                if (!response.ok) throw new Error(`Failed to fetch ${url}`);
                                return cache.put(url, response);
                            })
                            .catch(err => console.warn(`Skipping ${url}:`, err))
                    )
                );
            })
            .catch(err => console.log("Cache install failed:", err))
    );
});

// Activate event: Cleanup old caches
self.addEventListener('activate', (event) => {
    event.waitUntil(
        caches.keys().then(cacheNames => {
            return Promise.all(
                cacheNames.map(cache => {
                    if (cache !== CACHE_NAME) {
                        console.log("Deleting old cache:", cache);
                        return caches.delete(cache);
                    }
                })
            );
        })
    );
});

// Fetch event: Serve from cache or fetch new data
self.addEventListener('fetch', (event) => {
    event.respondWith(
        caches.match(event.request)
            .then(response => {
                return response || fetch(event.request);
            })
            .catch(() => {
                if (event.request.destination === 'document') {
                    return caches.match('/index.html');
                }
            })
    );
});
self.addEventListener("sync", (event) => {
    console.log("sYNC event received:", event);


    event.waitUntil(
        self.registration.showNotification("E-Commerce Alert", options)
    );
});

async function syncCartData() {
    // Example: Send unsynced cart items to the server
    let cartData = await getCartFromIndexedDB(); // Fetch from IndexedDB
    if (cartData.length > 0) {
        fetch("/sync-cart", {
            method: "POST",
            body: JSON.stringify(cartData),
            headers: { "Content-Type": "application/json" }
        }).then(() => console.log("Cart synced successfully"))
          .catch(err => console.log("Cart sync failed", err));
    }
}
// Listen for push events
self.addEventListener("push", (event) => {
    console.log("Push event received:", event);

    const notificationText = "🔥 Flash Sale: 50% Off on All Items! 🔥";
    console.log("Push Notification Text:", notificationText);

    const options = {
        body: notificationText,
        icon: "/flipkart.png",
        badge: "/flipkart.png",
    };

    event.waitUntil(
        self.registration.showNotification("E-Commerce Alert", options)
    );
});


self.registration.showNotification("Cart Synced", {
    body: "Your cart items have been updated.",
    icon: "/flipkart.png",
});
