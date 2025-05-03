'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.json": "0f984d7910e6778cd90db2fdc5139a26",
"assets/AssetManifest.bin": "6c6b97010ebd33ac67d5d1bf861680d5",
"assets/assets/app-icon.png": "ec650e8fbb164051207f8afcf4fcb96b",
"assets/FontManifest.json": "c21f76c6387878cac292958b2e2ff00b",
"assets/fonts/MaterialIcons-Regular.otf": "f5bea3069cdc76f17ec1cd76d7d439d4",
"assets/AssetManifest.bin.json": "e33af367f471a5b77a02ce43dc7779e9",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/NOTICES": "06c85d876271818d0eb75daf06b37c34",
"assets/packages/youtube_player_iframe/assets/player.html": "663ba81294a9f52b1afe96815bb6ecf9",
"assets/packages/feature_puzzles/assets/clouds.jpg": "f03f89bfaa6ae5ffa3fb88cef5fd6855",
"assets/packages/feature_puzzles/assets/water.jpg": "7ad45e838f5cf0e4925fe4540465d4e5",
"assets/packages/feature_puzzles/assets/background.jpg": "656fa741ccffa848a6957d49d9d9797f",
"assets/packages/feature_puzzles/assets/boat.png": "f3db44b9c6e985f0f40002462f261cce",
"assets/packages/design_system/assets/fonts/poppins/Poppins-Regular.ttf": "093ee89be9ede30383f39a899c485a82",
"assets/packages/design_system/assets/fonts/poppins/Poppins-Bold.ttf": "08c20a487911694291bd8c5de41315ad",
"assets/packages/design_system/assets/fonts/poppins/Poppins-ExtraBold.ttf": "d45bdbc2d4a98c1ecb17821a1dbbd3a4",
"assets/packages/design_system/assets/fonts/poppins/Poppins-Medium.ttf": "bf59c687bc6d3a70204d3944082c5cc0",
"assets/packages/design_system/assets/fonts/poppins/Poppins-SemiBold.ttf": "6f1520d107205975713ba09df778f93f",
"assets/packages/design_system/assets/fonts/poppins/Poppins-Black.ttf": "14d00dab1f6802e787183ecab5cce85e",
"assets/packages/font_awesome_flutter/lib/fonts/fa-brands-400.ttf": "64ada2f045a2280ef248d6c27f2a0e9c",
"assets/packages/font_awesome_flutter/lib/fonts/fa-solid-900.ttf": "a2eb084b706ab40c90610942d98886ec",
"assets/packages/font_awesome_flutter/lib/fonts/fa-regular-400.ttf": "3ca5dc7621921b901d513cc1ce23788c",
"assets/packages/flutter_inappwebview/assets/t_rex_runner/t-rex.css": "5a8d0222407e388155d7d1395a75d5b9",
"assets/packages/flutter_inappwebview/assets/t_rex_runner/t-rex.html": "16911fcc170c8af1c5457940bd0bf055",
"assets/packages/flutter_inappwebview_web/assets/web/web_support.js": "509ae636cfdd93e49b5a6eaf0f06d79f",
"assets/packages/feature_tmdb/assets/images/fantasy.png": "db04ca9c9594db2523fdf8a19ffda6f2",
"assets/packages/feature_tmdb/assets/images/thriller.png": "d3fb583d2c000deca69e2c55704c6579",
"assets/packages/feature_tmdb/assets/images/action.png": "3e7fcd304ae36db9cc4be53f3e0924a7",
"assets/packages/feature_tmdb/assets/images/kids.png": "4463e14a6747219f84efb152a0f2d7e7",
"assets/packages/feature_tmdb/assets/images/scienceFiction.png": "0f582818d0fb0448b5a5e695ef0917d3",
"assets/packages/feature_tmdb/assets/images/western.png": "053349053d041dc0450be61a362a0ea9",
"assets/packages/feature_tmdb/assets/images/family.png": "98cf7add142ac115a3b4c812696b80a8",
"assets/packages/feature_tmdb/assets/images/comedy.png": "098e6852a65b29447ec8a1a16fd0040a",
"assets/packages/feature_tmdb/assets/images/romance.png": "1db6addee31f3735b198e804556c31b4",
"assets/packages/feature_tmdb/assets/images/news.png": "486ed7117a3b8496aaf7a6666b43ce15",
"assets/packages/feature_tmdb/assets/images/tvMovie.png": "74d2195690e864a2210c5566a3c20f57",
"assets/packages/feature_tmdb/assets/images/war.png": "73a65724c5a90fd93ee61fe6943e21dc",
"assets/packages/feature_tmdb/assets/images/soap.png": "a767f86e356e42863fd9c4a1db49ddae",
"assets/packages/feature_tmdb/assets/images/documentary.png": "1532ba013b33e55a676a61ff2025d292",
"assets/packages/feature_tmdb/assets/images/mystery.png": "e7b462af37733de39e617375827f89ec",
"assets/packages/feature_tmdb/assets/images/history.png": "200c7d62c14a9093212c0126a965160c",
"assets/packages/feature_tmdb/assets/images/music.png": "16684c07bf102d6f507f05e5a77651b0",
"assets/packages/feature_tmdb/assets/images/adventure.png": "05004f44e7837829609f0de295ba7b65",
"assets/packages/feature_tmdb/assets/images/talk.png": "42a068370dc653202a94b19fde1668a9",
"assets/packages/feature_tmdb/assets/images/horror.png": "1ff1703c7475d0a1847e270413e3c87a",
"assets/packages/feature_tmdb/assets/images/crime.png": "aaa1c7b86afb86af3c0aef3253ad68a6",
"assets/packages/feature_tmdb/assets/images/drama.png": "9e884c40f88e9e3ad7d0cf7a3b9edc87",
"assets/packages/feature_tmdb/assets/images/reality.png": "e1619f3e5ab4fdf49f38431233316baf",
"assets/packages/feature_tmdb/assets/images/animation.png": "ec0160a4e875082dfffe3bfadab28551",
"assets/packages/wakelock_plus/assets/no_sleep.js": "7748a45cd593f33280669b29c2c8919a",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "d7d83bd9ee909f8a9b348f56ca7b68c6",
"manifest.json": "69b93399a54fde7c44233c5c972a0302",
"splash/img/dark-4x.png": "cb06066bede1ecea769f1bf3f5c66a96",
"splash/img/dark-1x.png": "2f7d096fcad2432104e65952f3db01f4",
"splash/img/light-2x.png": "d77e91be26bd7e623689912cc18be18e",
"splash/img/light-4x.png": "cb06066bede1ecea769f1bf3f5c66a96",
"splash/img/light-1x.png": "2f7d096fcad2432104e65952f3db01f4",
"splash/img/dark-2x.png": "d77e91be26bd7e623689912cc18be18e",
"splash/img/light-3x.png": "f9601853bc9c4ec0461782d210268902",
"splash/img/dark-3x.png": "f9601853bc9c4ec0461782d210268902",
"version.json": "016bcbfaa3de7a81f4733c906b871481",
"flutter.js": "83d881c1dbb6d6bcd6b42e274605b69c",
"canvaskit/chromium/canvaskit.js": "8191e843020c832c9cf8852a4b909d4c",
"canvaskit/chromium/canvaskit.wasm": "c054c2c892172308ca5a0bd1d7a7754b",
"canvaskit/chromium/canvaskit.js.symbols": "f7c5e5502d577306fb6d530b1864ff86",
"canvaskit/skwasm.js": "ea559890a088fe28b4ddf70e17e60052",
"canvaskit/skwasm.wasm": "1c93738510f202d9ff44d36a4760126b",
"canvaskit/canvaskit.js": "728b2d477d9b8c14593d4f9b82b484f3",
"canvaskit/canvaskit.wasm": "a37f2b0af4995714de856e21e882325c",
"canvaskit/skwasm.js.symbols": "9fe690d47b904d72c7d020bd303adf16",
"canvaskit/canvaskit.js.symbols": "27361387bc24144b46a745f1afe92b50",
"index.html": "603bdd72c8df41328c70560ce4151c98",
"/": "603bdd72c8df41328c70560ce4151c98",
"flutter_bootstrap.js": "91d93772770ae9d34f5696071be02ba2",
"icons/Icon-192.png": "a81cc62c9f801701b4c04552a760245f",
"icons/Icon-maskable-192.png": "a81cc62c9f801701b4c04552a760245f",
"icons/Icon-maskable-512.png": "61bc9cff4e990e9ebcb8bef341a9c8dc",
"icons/Icon-512.png": "61bc9cff4e990e9ebcb8bef341a9c8dc",
"favicon.png": "75b160b55a77c3972c737c81f3d88ac6",
"main.dart.js": "574b24327eaa54a769bc7c7739307b95"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
