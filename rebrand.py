"""
rebrand.py - rename neura/neuraself -> technex across a project.

Usage (run inside the project folder):
    python rebrand.py            # DRY RUN: only shows what would change
    python rebrand.py --apply    # actually changes files

Make a backup copy of the folder before using --apply.
"""
import os
import re
import sys

NEW = "technex"
APPLY = "--apply" in sys.argv
ROOT = os.getcwd()
SELF = os.path.abspath(__file__)

SKIP_DIRS = {".git", "__pycache__", "venv", ".venv", "node_modules"}
SKIP_FILES = {"LICENSE"}

# Credit / license strings that must stay as they are.
PROTECT = [
    "NeuraSelf-UwU",
    "Based on NeuraSelf by",
    "routo-loop/neura-self.git",
    "routo-loop/neura-self",
]

# neura / neuraself / neura-self (but not "neural")
PATTERN = re.compile(r"neura(?:[-_ ]?self)?(?!l)", re.IGNORECASE)


def swap(match):
    s = match.group(0)
    if s.isupper():
        return NEW.upper()
    if s[0].isupper():
        return NEW.capitalize()
    return NEW


def rebrand_text(text):
    holders = {}
    for i, p in enumerate(PROTECT):
        key = f"\x00{i}\x00"
        holders[key] = p
        text = text.replace(p, key)
    text = PATTERN.sub(swap, text)
    for key, p in holders.items():
        text = text.replace(key, p)
    return text


def main():
    print("MODE:", "APPLY" if APPLY else "DRY RUN (nothing changed)")
    print("Folder:", ROOT, "\n")

    # 1) file contents
    changed = 0
    for dirpath, dirnames, filenames in os.walk(ROOT):
        dirnames[:] = [d for d in dirnames if d not in SKIP_DIRS]
        for fn in filenames:
            path = os.path.join(dirpath, fn)
            if os.path.abspath(path) == SELF or fn in SKIP_FILES:
                continue
            try:
                with open(path, "r", encoding="utf-8", newline="") as f:
                    old = f.read()
            except (UnicodeDecodeError, OSError):
                continue  # binary file (images, db, etc.)
            new = rebrand_text(old)
            if new != old:
                changed += 1
                print("[text]  ", os.path.relpath(path, ROOT))
                if APPLY:
                    with open(path, "w", encoding="utf-8", newline="") as f:
                        f.write(new)

    # 2) rename files and folders (deepest first)
    renamed = 0
    for dirpath, dirnames, filenames in os.walk(ROOT, topdown=False):
        if any(part in SKIP_DIRS for part in os.path.relpath(dirpath, ROOT).split(os.sep)):
            continue
        for name in filenames + dirnames:
            if os.path.join(dirpath, name) == SELF or name in SKIP_FILES:
                continue
            new_name = PATTERN.sub(swap, name)
            if new_name != name:
                src = os.path.join(dirpath, name)
                dst = os.path.join(dirpath, new_name)
                if os.path.exists(dst):
                    print("[skip]   exists:", os.path.relpath(dst, ROOT))
                    continue
                renamed += 1
                print("[rename]", os.path.relpath(src, ROOT), "->", new_name)
                if APPLY:
                    os.rename(src, dst)

    print(f"\nText changed in {changed} files, {renamed} renames.")
    if not APPLY:
        print("Dry run only. To apply, run:  python rebrand.py --apply")


if __name__ == "__main__":
    main()
