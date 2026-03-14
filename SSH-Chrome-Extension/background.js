// Service Worker – minimal background logic

chrome.runtime.onInstalled.addListener(() => {
  // Set default bridge URL on first install
  chrome.storage.local.get(['settings'], (result) => {
    if (!result.settings) {
      chrome.storage.local.set({
        settings: { bridgeUrl: 'ws://localhost:2222' },
        hosts: []
      });
    }
  });
});
