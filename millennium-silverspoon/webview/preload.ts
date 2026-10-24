const PANEL_ID = "silverspoon-store-companion";
const STYLE_ID = "silverspoon-store-companion-style";
const SETTINGS_KEY = "silverspoon.store-companion.settings.v1";

type CompanionSettings = {
  compact: boolean;
  showAppId: boolean;
};

const defaultSettings: CompanionSettings = { compact: false, showAppId: true };

function loadSettings(): CompanionSettings {
  try {
    const parsed: unknown = JSON.parse(localStorage.getItem(SETTINGS_KEY) ?? "null");
    if (typeof parsed !== "object" || parsed === null) return { ...defaultSettings };
    const values = parsed as Record<string, unknown>;
    return {
      compact: typeof values.compact === "boolean" ? values.compact : defaultSettings.compact,
      showAppId: typeof values.showAppId === "boolean" ? values.showAppId : defaultSettings.showAppId,
    };
  } catch {
    return { ...defaultSettings };
  }
}

const styles = `
#${PANEL_ID} {
  box-sizing: border-box;
  display: flex;
  align-items: center;
  gap: 12px;
  width: 100%;
  margin: 12px 0;
  padding: 12px 14px;
  color: #dfe6ef;
  background: linear-gradient(115deg, rgba(25, 37, 56, .98), rgba(39, 52, 72, .96));
  border: 1px solid rgba(190, 199, 211, .22);
  border-radius: 4px;
  font: 13px/1.4 Arial, sans-serif;
}
#${PANEL_ID} * { box-sizing: border-box; }
#${PANEL_ID} .ss-mark { width: 34px; height: 34px; flex: 0 0 34px; }
#${PANEL_ID} .ss-copy { min-width: 0; flex: 1; }
#${PANEL_ID} .ss-title { color: #f2f5f9; font-size: 14px; font-weight: 700; }
#${PANEL_ID} .ss-detail { margin-top: 2px; color: #aeb8c6; }
#${PANEL_ID} .ss-action {
  flex: 0 0 auto;
  padding: 7px 12px;
  color: #eaf0f7;
  background: linear-gradient(90deg, #52657d, #384b63);
  border: 0;
  border-radius: 3px;
  cursor: pointer;
  font: inherit;
}
#${PANEL_ID} .ss-action:hover { background: linear-gradient(90deg, #667d98, #435a76); }
#${PANEL_ID} .ss-action:focus-visible { outline: 2px solid #d3deea; outline-offset: 2px; }
#${PANEL_ID} .ss-status { min-width: 72px; color: #c4cedb; text-align: right; }
#${PANEL_ID} .ss-settings { flex: 0 0 100%; display: flex; flex-wrap: wrap; gap: 14px; padding: 10px 0 0 46px; border-top: 1px solid rgba(190, 199, 211, .16); }
#${PANEL_ID} .ss-settings[hidden] { display: none; }
#${PANEL_ID} .ss-setting { display: inline-flex; align-items: center; gap: 7px; color: #c4cedb; cursor: pointer; }
#${PANEL_ID} .ss-setting input { accent-color: #9eacbd; }
#${PANEL_ID} .ss-note { flex: 0 0 100%; color: #8593a5; font-size: 11px; }
#${PANEL_ID}[data-compact="true"] { gap: 8px; margin: 8px 0; padding: 8px 10px; }
#${PANEL_ID}[data-compact="true"] .ss-mark { width: 28px; height: 28px; flex-basis: 28px; }
#${PANEL_ID}[data-compact="true"] .ss-settings { padding-left: 36px; }
@media (max-width: 600px) {
  #${PANEL_ID} { flex-wrap: wrap; }
  #${PANEL_ID} .ss-status { flex: 1 0 100%; text-align: left; }
}
`;

function currentAppId(): string | null {
  const match = window.location.pathname.match(/^\/app\/(\d+)(?:\/|$)/);
  return match?.[1] ?? null;
}

function mountPanel(): void {
  const appId = currentAppId();
  const oldPanel = document.getElementById(PANEL_ID);
  if (!appId) {
    oldPanel?.remove();
    return;
  }

  if (oldPanel?.dataset.appId === appId) return;
  oldPanel?.remove();

  const host =
    document.querySelector<HTMLElement>("#game_area_purchase") ??
    document.querySelector<HTMLElement>(".game_area_purchase_game_wrapper") ??
    document.querySelector<HTMLElement>("#game_area_purchase_game") ??
    document.querySelector<HTMLElement>("#appHubAppName")?.parentElement;
  if (!host) return;

  if (!document.getElementById(STYLE_ID)) {
    const style = document.createElement("style");
    style.id = STYLE_ID;
    style.textContent = styles;
    document.head.append(style);
  }

  const panel = document.createElement("section");
  panel.id = PANEL_ID;
  panel.dataset.appId = appId;
  panel.setAttribute("aria-label", "SilverSpoon store companion");
  panel.innerHTML = `
    <img class="ss-mark" src="../resources/silverspoon-icon.png" alt="" aria-hidden="true" />
    <div class="ss-copy">
      <div class="ss-title">SilverSpoon</div>
      <div class="ss-detail">Steam store companion <span class="ss-app-id">· App ${appId}</span></div>
    </div>
    <button class="ss-action" type="button">Copy App ID</button>
    <button class="ss-action ss-settings-toggle" type="button" aria-expanded="false">Settings</button>
    <div class="ss-status" role="status" aria-live="polite"></div>
    <div class="ss-settings" hidden>
      <label class="ss-setting"><input class="ss-show-app-id" type="checkbox"> Show App ID</label>
      <label class="ss-setting"><input class="ss-compact" type="checkbox"> Compact panel</label>
      <div class="ss-note">Settings are stored locally in this Steam webview.</div>
    </div>
  `;

  const button = panel.querySelector<HTMLButtonElement>(".ss-action");
  const status = panel.querySelector<HTMLElement>(".ss-status");
  const settingsToggle = panel.querySelector<HTMLButtonElement>(".ss-settings-toggle");
  const settingsPanel = panel.querySelector<HTMLElement>(".ss-settings");
  const appIdLabel = panel.querySelector<HTMLElement>(".ss-app-id");
  const showAppIdControl = panel.querySelector<HTMLInputElement>(".ss-show-app-id");
  const compactControl = panel.querySelector<HTMLInputElement>(".ss-compact");
  const settings = loadSettings();

  const applySettings = () => {
    panel.dataset.compact = String(settings.compact);
    if (appIdLabel) appIdLabel.hidden = !settings.showAppId;
    if (showAppIdControl) showAppIdControl.checked = settings.showAppId;
    if (compactControl) compactControl.checked = settings.compact;
    localStorage.setItem(SETTINGS_KEY, JSON.stringify(settings));
  };

  settingsToggle?.addEventListener("click", (event) => {
    event.stopPropagation();
    const isOpen = settingsToggle.getAttribute("aria-expanded") === "true";
    settingsToggle.setAttribute("aria-expanded", String(!isOpen));
    if (settingsPanel) settingsPanel.hidden = isOpen;
  });
  showAppIdControl?.addEventListener("change", () => {
    settings.showAppId = showAppIdControl.checked;
    applySettings();
  });
  compactControl?.addEventListener("change", () => {
    settings.compact = compactControl.checked;
    applySettings();
  });
  button?.addEventListener("click", async () => {
    try {
      await navigator.clipboard.writeText(appId);
      if (status) status.textContent = "Copied.";
    } catch {
      if (status) status.textContent = "Clipboard unavailable.";
    }
  });
  applySettings();

  host.prepend(panel);
}

let scheduled = false;
const observer = new MutationObserver(() => {
  if (scheduled) return;
  scheduled = true;
  window.requestAnimationFrame(() => {
    scheduled = false;
    mountPanel();
  });
});

observer.observe(document.documentElement, { childList: true, subtree: true });
mountPanel();
