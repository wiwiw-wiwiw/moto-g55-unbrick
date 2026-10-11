#!/usr/bin/env bash
# run from the unpacked firmware folder
LOG="flash-log.txt"
: > "$LOG"
f(){ echo ">>> fastboot $*" | tee -a "$LOG"; fastboot "$@" 2>&1 | tee -a "$LOG"; [ "${PIPESTATUS[0]}" -eq 0 ] || echo "FAIL: $*" | tee -a "$LOG"; }
f flash gpt PGPT
f getvar max-sparse-size
f oem fb_mode_set
f flash preloader preloader.img
f flash lk_a lk.img
f flash tee_a tee.img
f flash mcupm_a mcupm.img
f flash pi_img_a pi_img.img
f flash sspm_a sspm.img
f flash dtbo_a dtbo.img
f flash logo_a logo.img
f erase nvdata
f flash spmfw_a spmfw.img
f flash scp_a scp.img
f flash vbmeta_a vbmeta.img
f flash vbmeta_system_a vbmeta_system.img
f flash md1img_a md1img.img
f flash dpm_a dpm.img
f flash gz_a gz.img
f flash vcp_a vcp.img
f flash gpueb_a gpueb.img
f flash efuseBackup efuse.img
f flash boot_a boot.img
f flash vendor_boot_a vendor_boot.img
f flash super super.img_sparsechunk.0
f flash super super.img_sparsechunk.1
f flash super super.img_sparsechunk.2
f flash super super.img_sparsechunk.3
f flash super super.img_sparsechunk.4
f flash super super.img_sparsechunk.5
f flash super super.img_sparsechunk.6
f flash super super.img_sparsechunk.7
f flash super super.img_sparsechunk.8
f flash super super.img_sparsechunk.9
f flash super super.img_sparsechunk.10
f flash super super.img_sparsechunk.11
f flash super super.img_sparsechunk.12
f flash super super.img_sparsechunk.13
f flash super super.img_sparsechunk.14
f flash super super.img_sparsechunk.15
f flash super super.img_sparsechunk.16
f flash super super.img_sparsechunk.17
f flash super super.img_sparsechunk.18
f flash super super.img_sparsechunk.19
f flash super super.img_sparsechunk.20
f flash super super.img_sparsechunk.21
f flash super super.img_sparsechunk.22
f flash super super.img_sparsechunk.23
f flash super super.img_sparsechunk.24
f flash super super.img_sparsechunk.25
f flash super super.img_sparsechunk.26
f flash super super.img_sparsechunk.27
f flash super super.img_sparsechunk.28
f flash super super.img_sparsechunk.29
f flash super super.img_sparsechunk.30
f flash super super.img_sparsechunk.31
f flash super super.img_sparsechunk.32
f flash super super.img_sparsechunk.33
f flash super super.img_sparsechunk.34
f flash super super.img_sparsechunk.35
f erase userdata
f erase metadata
f erase debug_token
f oem fb_mode_clear
f oem config unset console
f oem config unset cmdl
echo "=== DONE"; grep "^FAIL:" "$LOG" || true
