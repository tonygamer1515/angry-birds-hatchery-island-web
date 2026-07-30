const CACHE='hatchery-island-v4';
const SHELL=['./','index.html','styles.css','game.js','assets/matter.min.js','manifest.webmanifest','assets/data/sprites.json','assets/data/game-data.json','assets/data/physics.json','assets/images/app-icon-192.png','assets/images/archive-screenshot.jpeg'];
self.addEventListener('install',e=>e.waitUntil(caches.open(CACHE).then(c=>c.addAll(SHELL)).then(()=>self.skipWaiting())));
self.addEventListener('activate',e=>e.waitUntil(caches.keys().then(k=>Promise.all(k.filter(x=>x!==CACHE).map(x=>caches.delete(x)))).then(()=>self.clients.claim())));
self.addEventListener('fetch',e=>{if(e.request.method!=='GET'||new URL(e.request.url).origin!==location.origin||e.request.url.endsWith('.ipa'))return;e.respondWith(caches.match(e.request).then(c=>c||fetch(e.request).then(r=>{if(r.ok){const copy=r.clone();caches.open(CACHE).then(x=>x.put(e.request,copy))}return r}))) });
