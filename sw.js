const CACHE='hatchery-island-v6';
const SHELL=['./','index.html','styles.css?build=6','game.js?build=6','assets/matter.min.js','manifest.webmanifest','assets/images/app-icon-192.png','assets/images/archive-screenshot.jpeg'];
self.addEventListener('install',event=>event.waitUntil(caches.open(CACHE).then(cache=>cache.addAll(SHELL)).then(()=>self.skipWaiting())));
self.addEventListener('activate',event=>event.waitUntil(caches.keys().then(keys=>Promise.all(keys.filter(key=>key!==CACHE).map(key=>caches.delete(key)))).then(()=>self.clients.claim())));
self.addEventListener('fetch',event=>{
 if(event.request.method!=='GET'||new URL(event.request.url).origin!==location.origin||event.request.url.endsWith('.ipa'))return;
 const url=new URL(event.request.url),fresh=event.request.mode==='navigate'||url.searchParams.has('build');
 const save=response=>{if(response.ok){const copy=response.clone();caches.open(CACHE).then(cache=>cache.put(event.request,copy))}return response};
 if(fresh)event.respondWith(fetch(event.request).then(save).catch(()=>caches.match(event.request)));
 else event.respondWith(caches.match(event.request).then(cached=>cached||fetch(event.request).then(save)));
});
