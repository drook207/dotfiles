#!/usr/bin/env python3
"""Add a color scheme to a Windows Terminal settings.json and make it (and a
font) the default for all profiles. Keeps every other setting; writes a
one-time backup next to the file. Usage: wt-apply-theme.py SETTINGS SCHEME FONT
Kanagawa Paper Ink scheme: thesimonho/kanagawa-paper.nvim, extras/windows_terminal."""
import json
import os
import re
import shutil
import sys


def strip_jsonc(text):
    """Remove // and /* */ comments outside strings, and trailing commas."""
    out, i, n, in_str = [], 0, len(text), False
    while i < n:
        c = text[i]
        if in_str:
            out.append(c)
            if c == "\\" and i + 1 < n:
                out.append(text[i + 1])
                i += 1
            elif c == '"':
                in_str = False
        elif c == '"':
            in_str = True
            out.append(c)
        elif text.startswith("//", i):
            while i < n and text[i] != "\n":
                i += 1
            continue
        elif text.startswith("/*", i):
            end = text.find("*/", i + 2)
            i = n if end < 0 else end + 2
            continue
        else:
            out.append(c)
        i += 1
    return re.sub(r",(\s*[}\]])", r"\1", "".join(out))


def main(settings_path, scheme_path, font):
    with open(settings_path, encoding="utf-8-sig") as f:
        original = f.read()
    settings = json.loads(strip_jsonc(original)) if original.strip() else {}
    with open(scheme_path, encoding="utf-8") as f:
        scheme = json.load(f)

    schemes = [s for s in settings.get("schemes", []) if s.get("name") != scheme["name"]]
    settings["schemes"] = schemes + [scheme]

    profiles = settings.get("profiles", {})
    if isinstance(profiles, list):  # old format: a plain list of profiles
        profiles = {"list": profiles}
    defaults = profiles.setdefault("defaults", {})
    defaults["colorScheme"] = scheme["name"]
    defaults.setdefault("font", {})["face"] = font
    settings["profiles"] = profiles

    new = json.dumps(settings, indent=4, ensure_ascii=False) + "\n"
    if new == original:
        print("unchanged:", settings_path)
        return
    backup = settings_path + ".dotfiles-backup"
    if not os.path.exists(backup):
        shutil.copy2(settings_path, backup)
    with open(settings_path, "w", encoding="utf-8") as f:
        f.write(new)
    print("updated:", settings_path)


if __name__ == "__main__":
    main(*sys.argv[1:4])
