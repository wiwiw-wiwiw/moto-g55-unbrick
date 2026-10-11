#!/usr/bin/env python3
"""Convert a Motorola flashfile.xml into a flashing script.

Windows (.bat) output reproduces the scripts in ../windows/ exactly.
Linux (.sh) output does the same steps with the system `fastboot`.

Examples:
  python3 flashfile2script.py flashfile.xml --fwdir C:\\g55\\fw > flash.bat
  python3 flashfile2script.py flashfile.xml --format sh > flash.sh
"""
import argparse
import sys
import xml.etree.ElementTree as ET


def steps(xml_path):
    out = []
    for s in ET.parse(xml_path).iter("step"):
        op = s.get("operation")
        if op == "flash":
            out.append(["flash", s.get("partition"), s.get("filename")])
        elif op == "erase":
            out.append(["erase", s.get("partition")])
        elif op == "oem":
            out.append(["oem"] + s.get("var").split())
        elif op == "getvar":
            out.append(["getvar", s.get("var")])
        else:
            sys.exit(f"unknown operation in flashfile.xml: {op} {s.attrib}")
    return out


def bat(st, a):
    log = a.log or r"C:\g55\flash-log.txt"
    L = ["@echo off"]
    if a.title:
        L.append(f"echo {a.title}")
    L += [f"cd /d {a.fwdir}", r"set FB=C:\platform-tools\fastboot.exe", f"set LOG={log}",
          "echo === flash start %DATE% %TIME% > %LOG%",
          f"if not exist flashfile.xml (echo flashfile.xml not found in {a.fwdir} & pause & exit /b 1)"]
    if a.require_unlocked:
        L += ['%FB% getvar securestate 2>&1 | findstr /c:"flashing_unlocked" >nul',
              "if errorlevel 1 (echo STOP: bootloader is NOT unlocked. Run unlock.bat first. & pause & exit /b 1)"]
    body = [" ".join(x) for x in st]
    if a.set_active:
        i = body.index("oem fb_mode_clear") if "oem fb_mode_clear" in body else len(body)
        body.insert(i, f"--set-active={a.set_active}")
    L += [f"call :f {b}" for b in body]
    L += ["echo.", f"echo === DONE. Log: {log}", "echo === DONE >> %LOG%", 'findstr /c:"FAIL:" %LOG%',
          "pause", "goto :eof", "", ":f", "echo ^>^>^> fastboot %*", "echo ^>^>^> fastboot %* >> %LOG%",
          "%FB% %* >> %LOG% 2>&1", "if errorlevel 1 (echo     FAIL: %* & echo FAIL: %* >> %LOG%)", "goto :eof"]
    return "\r\n".join(L) + "\r\n"


def sh(st, a):
    log = a.log or "flash-log.txt"
    L = ["#!/usr/bin/env bash", "# run from the unpacked firmware folder", f'LOG="{log}"', ': > "$LOG"',
         'f(){ echo ">>> fastboot $*" | tee -a "$LOG"; fastboot "$@" 2>&1 | tee -a "$LOG"; '
         '[ "${PIPESTATUS[0]}" -eq 0 ] || echo "FAIL: $*" | tee -a "$LOG"; }']
    if a.require_unlocked:
        L.append('fastboot getvar securestate 2>&1 | grep -q flashing_unlocked || '
                 '{ echo "STOP: bootloader is NOT unlocked"; exit 1; }')
    body = [" ".join(x) for x in st]
    if a.set_active:
        i = body.index("oem fb_mode_clear") if "oem fb_mode_clear" in body else len(body)
        body.insert(i, f"--set-active={a.set_active}")
    L += [f"f {b}" for b in body]
    L += ['echo "=== DONE"; grep "^FAIL:" "$LOG" || true']
    return "\n".join(L) + "\n"


def main():
    p = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    p.add_argument("xml")
    p.add_argument("--format", choices=["bat", "sh"], default="bat")
    p.add_argument("--fwdir", default=r"C:\g55\fw", help="firmware folder (bat only)")
    p.add_argument("--log", help="log file path")
    p.add_argument("--title", help="banner line (bat only)")
    p.add_argument("--require-unlocked", action="store_true", help="refuse to run if bootloader is locked")
    p.add_argument("--set-active", metavar="SLOT", help="add fastboot --set-active=SLOT before fb_mode_clear")
    a = p.parse_args()
    st = steps(a.xml)
    sys.stdout.buffer.write((bat(st, a) if a.format == "bat" else sh(st, a)).encode("ascii"))


if __name__ == "__main__":
    main()
