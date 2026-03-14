// ── State ──────────────────────────────────────────
let allHosts = [];
let editingId = null;

// ── DOM Refs ────────────────────────────────────────
const viewList  = document.getElementById('viewList');
const viewForm  = document.getElementById('viewForm');
const hostList  = document.getElementById('hostList');
const emptyState = document.getElementById('emptyState');
const searchInput = document.getElementById('searchInput');
const formTitle = document.getElementById('formTitle');
const formError = document.getElementById('formError');

const fLabel = document.getElementById('fLabel');
const fHost  = document.getElementById('fHost');
const fPort  = document.getElementById('fPort');
const fUser  = document.getElementById('fUser');
const fPass  = document.getElementById('fPass');
const fNotes = document.getElementById('fNotes');

// ── Init ────────────────────────────────────────────
chrome.storage.local.get(['hosts'], ({ hosts }) => {
  allHosts = hosts || [];
  renderList();
});

// ── Render ──────────────────────────────────────────
function renderList(filter = '') {
  const q = filter.toLowerCase().trim();
  const visible = q
    ? allHosts.filter(h =>
        h.label.toLowerCase().includes(q) ||
        h.host.toLowerCase().includes(q) ||
        h.username.toLowerCase().includes(q)
      )
    : allHosts;

  hostList.innerHTML = '';

  if (visible.length === 0) {
    emptyState.style.display = 'block';
    return;
  }
  emptyState.style.display = 'none';

  visible.forEach(host => {
    const card = document.createElement('div');
    card.className = 'host-card';
    card.innerHTML = `
      <div class="host-icon">🖥</div>
      <div class="host-info">
        <div class="host-label">${esc(host.label || host.host)}</div>
        <div class="host-addr">${esc(host.username)}@${esc(host.host)}:${host.port}</div>
        ${host.notes ? `<div class="host-notes">${esc(host.notes)}</div>` : ''}
      </div>
      <div class="host-actions">
        <button class="btn-connect" data-id="${host.id}">Verbinden</button>
        <button class="btn-icon edit" data-id="${host.id}" title="Bearbeiten">✎</button>
        <button class="btn-icon delete" data-id="${host.id}" title="Löschen">✕</button>
      </div>
    `;
    hostList.appendChild(card);
  });

  // Event delegation
  hostList.querySelectorAll('.btn-connect').forEach(btn => {
    btn.addEventListener('click', () => connectHost(btn.dataset.id));
  });
  hostList.querySelectorAll('.btn-icon.edit').forEach(btn => {
    btn.addEventListener('click', () => openEditForm(btn.dataset.id));
  });
  hostList.querySelectorAll('.btn-icon.delete').forEach(btn => {
    btn.addEventListener('click', () => deleteHost(btn.dataset.id));
  });
}

// ── Connect ─────────────────────────────────────────
async function connectHost(id) {
  const host = allHosts.find(h => h.id === id);
  if (!host) return;

  // Store connection params in session storage (cleared when Chrome closes)
  // Use a temp key so passwords never appear in URLs
  const connId = 'conn_' + Date.now();
  await chrome.storage.local.set({ [connId]: { ...host, _connId: connId } });

  const termUrl = chrome.runtime.getURL('terminal.html') + '?id=' + connId;
  chrome.tabs.create({ url: termUrl });
}

// ── Add / Edit Form ─────────────────────────────────
document.getElementById('btnAdd').addEventListener('click', openAddForm);
document.getElementById('btnBack').addEventListener('click', showList);
document.getElementById('btnCancel').addEventListener('click', showList);
document.getElementById('btnSave').addEventListener('click', saveHost);
document.getElementById('btnSettings').addEventListener('click', () => {
  chrome.runtime.openOptionsPage();
});

searchInput.addEventListener('input', () => renderList(searchInput.value));

function openAddForm() {
  editingId = null;
  formTitle.textContent = 'Neuer Host';
  clearForm();
  showForm();
}

function openEditForm(id) {
  const host = allHosts.find(h => h.id === id);
  if (!host) return;
  editingId = id;
  formTitle.textContent = 'Host bearbeiten';
  fLabel.value = host.label || '';
  fHost.value  = host.host;
  fPort.value  = host.port || 22;
  fUser.value  = host.username;
  fPass.value  = host.password || '';
  fNotes.value = host.notes || '';
  showForm();
}

function clearForm() {
  fLabel.value = '';
  fHost.value  = '';
  fPort.value  = '22';
  fUser.value  = '';
  fPass.value  = '';
  fNotes.value = '';
  hideFormError();
}

function saveHost() {
  const host   = fHost.value.trim();
  const user   = fUser.value.trim();
  const port   = parseInt(fPort.value) || 22;

  if (!host) return showFormError('Hostname / IP ist erforderlich.');
  if (!user) return showFormError('Benutzername ist erforderlich.');
  if (port < 1 || port > 65535) return showFormError('Ungültiger Port (1–65535).');

  const data = {
    id:       editingId || generateId(),
    label:    fLabel.value.trim() || host,
    host,
    port,
    username: user,
    password: fPass.value,
    notes:    fNotes.value.trim()
  };

  if (editingId) {
    const idx = allHosts.findIndex(h => h.id === editingId);
    if (idx !== -1) allHosts[idx] = data;
  } else {
    allHosts.push(data);
  }

  chrome.storage.local.set({ hosts: allHosts }, () => {
    showList();
    renderList(searchInput.value);
  });
}

function deleteHost(id) {
  if (!confirm('Host wirklich löschen?')) return;
  allHosts = allHosts.filter(h => h.id !== id);
  chrome.storage.local.set({ hosts: allHosts }, () => renderList(searchInput.value));
}

// ── View Switching ───────────────────────────────────
function showList() {
  viewList.style.display = '';
  viewForm.style.display = 'none';
  renderList(searchInput.value);
}

function showForm() {
  viewList.style.display = 'none';
  viewForm.style.display = 'flex';
  hideFormError();
  setTimeout(() => fLabel.focus(), 50);
}

function showFormError(msg) {
  formError.textContent = msg;
  formError.style.display = 'block';
}

function hideFormError() {
  formError.style.display = 'none';
}

// ── Helpers ─────────────────────────────────────────
function esc(str) {
  return String(str ?? '')
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;');
}

function generateId() {
  return 'h_' + Date.now().toString(36) + '_' + Math.random().toString(36).slice(2, 7);
}
