if ('serviceWorker' in navigator) {
    window.addEventListener('load', () => {
        navigator.serviceWorker.register('/sw.js')
            .then(reg => console.log('Fetched successfully Service Worker registered!', reg))
            .catch(err => console.log('Service Worker registration failed:', err));
    });
}
Notification.requestPermission().then(permission => {
    if (permission === "granted") {
        console.log("Notification permission granted.");
    }
});
