---

# JaraServices – Carry (QBCore / Qbox)

Lightweight **/carry** system with **per-player consent toggle**.
Plug & play — no config file.

> Built by **Jaramiyo** — JaraServices

---

## ✨ Features

* **`/carry`** → carry the **nearest player** (3m radius).
* **`/tcarry`** → toggle your **consent** (allow/deny being carried).
* Clear notifications (deny without consent, start/stop, invalid target).
* Smooth animations + safe attach/detach for both players.
* **Frameworks:** QBCore and Qbox (see notes below).

---

## ✅ Requirements

* **FiveM (FXServer)**
* **QBCore** (or **Qbox** that still provides the `qb-core` export)
* **ox_lib** for notifications (`lib.notify`) — *strongly recommended*

> If your Qbox build does **not** export `qb-core`, change this line in `sv_carry.lua`:
>
> ```lua
> local QBCore = exports['qb-core']:GetCoreObject()
> -- to:
> -- local QBCore = exports['qbx-core']:GetCoreObject()
> ```

---

## 📦 Installation

1. Drop the resource into your server, e.g.:

   ```
   resources/[jaraservices]/js_carry
   ```
2. In `server.cfg`, after your framework:

   ```cfg
   ensure ox_lib      # recommended for notifications
   ensure qb-core     # or ensure qbx-core
   ensure js_carry
   ```
3. Restart the server. That’s it.

---

## 🕹️ Usage

* **`/carry`** → Start/stop carrying the nearest player (within ~3m).

  * If the target **disabled consent**, the carry is denied.
* **`/tcarry`** → Toggle **your** consent (allow/deny being carried).

Examples:

```
/carry
/tcarry
```

---

## 📁 Files Included

* `cl_carry.lua` — client logic (find nearest, play anims, attach/detach).
* `sv_carry.lua` — server logic (consent states, syncing, cleanup).

**Key details:**

* Distance check ≈ **3.0 meters**.
* Dead/unconscious players are blocked (`LocalPlayer.state.isDead / isIncapacitated`).
* Animations:

  * Carrier: `missfinale_c2mcs_1:fin_c2_mcs_1_camman`
  * Carried: `nm:firemans_carry` (attached with tuned offsets).

---

## 🔔 Notifications

This release uses **ox_lib**:

```lua
lib.notify({ title = "Carry", description = "...", type = "success|error|info" })
```

If you don’t use ox_lib, replace those calls with your preferred notify system (okokNotify, mythic, chat, etc.).

---

## 🧹 Safety & Cleanup

* Server tracks both states (`carrying[]` and `carried[]`) and cleans up on:

  * manual stop,
  * disconnect (`playerDropped`),
  * or when either side cancels.
* Client replays animations if interrupted while still attached.

---

## 🛠️ Troubleshooting

* **No notifications / errors about `lib`**
  Ensure **ox_lib** is started before this resource, or replace `lib.notify` calls.
* **Export error for `qb-core`**
  On some Qbox builds change:

  ```lua
  exports['qb-core']:GetCoreObject()
  -- to
  exports['qbx-core']:GetCoreObject()
  ```
* **Nothing happens on `/carry`**
  Make sure another player is within ~3m and not dead/in a vehicle.
  Ask the target to `/tcarry` to allow being carried.

---

## 📜 License

**MIT License** — free to use & modify. Please keep credits.
© JaraServices

---

## 💬 Support & Links

* 🌐 Website: **[https://www.jaraservices.com/](https://www.jaraservices.com/)**
* 💬 Discord: **[https://discord.gg/KKqZkg8HJY](https://discord.gg/KKqZkg8HJY)**

If you enjoyed this, check our **premium scripts** and **custom commissions** at **JaraServices**.

---

¿Quieres que también te deje un **`fxmanifest.lua` de ejemplo** y un **banner PNG** minimal para el repo? Te los preparo al toque.
