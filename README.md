# Moto G55 5G (XT2435-3, China) — unbrick "No valid operating system"

**English** · [Русский](README.ru.md)

A tested, end-to-end recovery for a **China-hardware Moto G55 5G (XT2435-3, codename `taipei`)** that was cross-flashed to global firmware and then bricked by **re-locking the bootloader**. The route goes from a dead phone to global firmware with Russian/English UI and Google Play. Every script in this repo was used on a real device on 2026-10-11.

> ⚠️ You do everything here at your own risk. This guide is for **your own phone**. Clearing Factory Reset Protection (FRP) needs the **Google account that was signed in on the phone**. This repo has no FRP bypass and never will.

---

## Is this your case?

Symptoms:

- The phone boots straight into the fastboot screen and shows **"No valid operating system could be found. The device will not boot."**
- `fastboot oem unlock <CODE>` answers `(bootloader) Check 'Allow OEM Unlock' in Android Settings`, and you can't get into Android to turn that on.

Put the phone in fastboot (Power + Volume Down) and run `windows\getvar.bat` (or `fastboot getvar all`). Your case matches if you see:

| Field | Value | Meaning |
|---|---|---|
| `sku` | `XT2435-3` | China hardware |
| `cid` | `0x000B` | China customer ID (= 11) |
| `version-bootloader` | `MBM-3.1-taipei_g_vext-…` | **g** = global bootloader on China hardware |
| `securestate` | `flashing_locked` | bootloader is locked |
| `iswarrantyvoid` | `yes` | it was unlocked before |
| `frp-state` | `protected` | a Google account is stored in the FRP partition |

## What happened (root cause)

1. Marketplace sellers buy cheap **China** units (`cid 11`), unlock the bootloader and flash **global** firmware, which is signed for `cid 50`. The phone works because the bootloader is unlocked.
2. The owner signs in with a Google account. Some apps (banks, payments) complain about the unlocked bootloader, so the owner runs `fastboot oem lock`.
3. The locked bootloader now checks signatures. Global images are signed for `cid 50`, the phone is `cid 11`, so you get **"No valid operating system"**.
4. The Google account stays in the `frp` partition, and flashing never touches that partition. On Android 15 the phone then refuses to turn on *OEM unlocking* (`SecurityException: FRP is active`) until that account is verified.

The way out: flash **China** firmware, which a locked phone accepts because it is signed for `cid 11`. Then switch on the Google services that ship disabled in it, sign in with **the same Google account** so FRP clears, unlock the bootloader with the Motorola code, flash global firmware, and **never lock again**.

## What you need

- A Windows 10/11 PC with ~20 GB free on `C:` and a good USB cable (use a rear port, no hubs).
- [Motorola USB drivers / Device Manager](https://en-us.support.motorola.com/app/answers/detail/a_id/88481).
- **The login and password of the Google account that was on the phone.** Without it you can only stay on China firmware (stage 1).
- A Motorola bootloader unlock code: [motorola.com unlock page](https://en-us.support.motorola.com/app/standalone/bootloader/unlock-your-device-a). You feed it the output of `fastboot oem get_unlock_data`, joined into one line with no `(bootloader)` prefixes and no spaces.

Use the scripts in [`windows/`](windows/). Put them all in **`C:\g55\`** and run them by double-clicking. They contain no `$` characters on purpose: copy-pasting PowerShell through chat apps that render `$…$` as math silently corrupted our first script. Send the files themselves, not their text.

## Stage 0 — tools

1. Install the Motorola drivers and reboot the PC.
2. Run `get_platform_tools.bat`. It creates `C:\platform-tools\` with `adb` and `fastboot`.
3. Charge the phone for at least an hour.

## Stage 1 — bring the phone back to life (China firmware, bootloader stays locked)

1. Run `get_cn15.bat`. It downloads 7 GB and unpacks to `C:\g55\fw`. If the download stops, run it again and it resumes.
2. Phone in fastboot, connected. Run `getvar.bat` and check the table above.
3. Run `flash_cn15.bat`. It takes 5–10 min; don't touch the cable. It writes `C:\g55\flash-log.txt`.
   - Expected: every step `OKAY`. The line `Blowing efuseBackup is not allowed, skipping!` is normal.
   - If `gpt`, `preloader`, `lk_a` or `tee_a` fail (rollback protection), use `get_cn16.bat` + `flash_cn16.bat` (Android 16) instead.
4. `C:\platform-tools\fastboot.exe reboot`. The first boot takes up to 10–15 minutes. The phone comes up in Chinese, with English selectable on the first screen.

If you only want a working phone with a **locked** bootloader, you can stop here. The China ROM is official and boots `green`.

## Stage 2 — clear FRP with your own Google account

The China ROM ships Google Play Services, Google Services Framework and Play Store as **disabled system apps**. Because they are privileged system apps, they can verify the FRP account.

1. Turn on Developer options: 设置 (Settings) → 关于手机 (About phone) → tap 版本号 (Build number) 7×.
2. 设置 → 系统 (System) → 开发者选项 (Developer options) → **USB 调试** (USB debugging) ON. Connect the phone and allow the prompt.
3. Run `enable_gms.bat`. Every line must end with `new state: enabled`, and then the phone reboots.
4. Connect to Wi-Fi and add **the same Google account** that was on the phone: 设置 → 账号 (Accounts) → Add → Google, or just open Play Store. Wait 5–10 minutes.

How to tell FRP is still active: switching on *OEM unlocking* crashes Settings. `diag_frp.bat` collects `C:\g55\diag.txt` and `C:\g55\logcat.txt`, and the log shows `PersistentDataBlockService: Attempt to update PDB was blocked because FRP is active`.

## Stage 3 — unlock the bootloader

1. 开发者选项 → **OEM 解锁** (OEM unlocking) ON. It needs internet; if it is greyed out, wait 10–30 min online.
2. **Do not install the system update** the China ROM offers. It can raise rollback protection.
3. Phone in fastboot. Run `unlock.bat`, paste the Motorola code, then on the phone pick **UNLOCK THE BOOTLOADER** with the volume keys and confirm with Power. The phone wipes and reboots.
4. Back in fastboot, `fastboot getvar securestate` must say `flashing_unlocked`.

## Stage 4 — global firmware

1. Run `get_global.bat`. It downloads 4.9 GB to `C:\g55\fwg`.
2. Phone in fastboot. Run `flash_global.bat`. It **refuses to run unless the bootloader is unlocked**, flashes, sets slot `a` active, and logs to `C:\g55\flash-global-log.txt`.
3. `fastboot reboot`. You'll see an "unlocked bootloader" warning at every boot; that's expected. Setup offers your language based on the SIM or nearby cell network.

## Stage 5 — after flashing (important)

- **Never lock the bootloader again** (`fastboot oem lock` / `flashing lock`) and never switch off *OEM unlocking*. Locking global firmware on China hardware means "No valid operating system" again.
- **Block Motorola system updates** so the way back to China firmware stays open. `com.motorola.ccc.ota` can't be disabled (`Failure: package is non-disable`), so `block_ota.bat` stops it from running in the background with `appops`. Also turn off auto-download in Settings → System → System updates. To undo, run `unblock_ota.bat`. Google Play updates are safe.
- IMEI shown as `…/01` on China and `…/22` on global firmware: the number after the slash is the firmware's software version (IMEISV), not part of the IMEI. Compare only the 15 digits.
- Apps that check the bootloader (some banks, Mir Pay) may still complain. That is the trade-off of global firmware on this hardware.

## Firmware used

All files come from the [Lolinet mirror](https://mirrors.lolinet.com/firmware/lenomola/2024/). The values below were read from each archive's `signing-info.txt` and `*.info.txt`.

| Firmware | Size | Signed for cid | Bootloader / modem rollback | HAB security version |
|---|---|---|---|---|
| [CN Android 15 `V1UTC35H.45-32-8`](https://mirrors.lolinet.com/firmware/lenomola/2024/taipei_retcn/official/RETCN/XT2435-3_TAIPEI_CMCC_15_V1UTC35H.45-32-8_subsidy-DEFAULT_regulatory-DEFAULT_CFC.xml.zip) | 7.0 GB | 11 | 0x01 / 0x01 | 8 |
| [CN Android 16 `W1UTC36.1-36`](https://mirrors.lolinet.com/firmware/lenomola/2024/taipei_retcn/official/RETCN/XT2435-3_TAIPEI_CMCC_16_W1UTC36.1-36_subsidy-DEFAULT_regulatory-DEFAULT_CFC.xml.zip) | 7.9 GB | 11 | 0x01 / **0x02** | 20 |
| [Global RETAIL Android 15 `V1UTS35H.61-21-4-3-2-1`](https://mirrors.lolinet.com/firmware/lenomola/2024/taipei/official/RETAIL/TAIPEI_RETAIL_15_V1UTS35H.61-21-4-3-2-1_subsidy-DEFAULT_regulatory-DEFAULT_cid50_CFC.xml.zip) | 4.9 GB | 50 | 0x01 / 0x01 | 13 |
| Global `V1UTS35H.61-21-2` (what the seller installed) | — | 50 | 0x01 / 0x01 | 9 |

All 14 non-China `taipei` firmware folders on the mirror are signed for `cid 50` (checked). Only `taipei_retcn` builds boot on a locked China unit.

**Going back to China firmware:** while the global firmware stays un-updated, CN Android 16 (`get_cn16.bat` + `flash_cn16.bat`) is guaranteed to flash, because all its rollback values are ≥ global. CN 15 is very likely to flash too: it flashed over SV 9, but SV 13 → 8 was not tested. On China firmware the bootloader can be re-locked, since the images match `cid 11`. We did not do that step ourselves.

## Other firmware versions / Linux

[`tools/flashfile2script.py`](tools/flashfile2script.py) turns any Motorola `flashfile.xml` into a `.bat` or a bash script. It reproduces the `windows/flash_*.bat` files byte for byte.

```bash
python3 tools/flashfile2script.py fw/flashfile.xml --fwdir 'C:\g55\fw' --title "my build" > flash.bat
python3 tools/flashfile2script.py fw/flashfile.xml --format sh > flash.sh   # run inside the firmware folder
```

Ready-made bash versions are in [`linux/`](linux/) (`sudo dnf install android-tools` / `apt install fastboot adb`).

## What we do not recommend

- **mtkclient / SP Flash Tool / "MTK auth bypass"** on this Dimensity (MT6855). Secure boot with DA authentication is enabled, and these tools are an easy way to a hard brick.
- **"FRP bypass" tools.** They exist to defeat anti-theft protection and are often malware themselves. Use the account that was on the phone.
- **Lenovo Software Fix (RSA)** usually doesn't offer China builds for this model.

## Credits

- XDA thread on the same symptom: [Moto G55 5G – XT2435-3](https://xdaforums.com/t/moto-g55-5g-xt2435-3.4786841/)
- Firmware mirror: [Lolinet](https://mirrors.lolinet.com/)

License: MIT. Motorola firmware is **not** included; it is downloaded from the mirror.
