#!/usr/bin/env python3
"""Merge a classes.dex into an unsigned APK produced by aapt."""
import sys
import zipfile


def main() -> int:
    if len(sys.argv) != 4:
        print("usage: pack.py <base.apk> <classes.dex> <out.apk>", file=sys.stderr)
        return 2

    base_apk, classes_dex, out_apk = sys.argv[1:]

    with zipfile.ZipFile(base_apk, "r") as src, zipfile.ZipFile(
        out_apk, "w", zipfile.ZIP_DEFLATED
    ) as dst:
        for info in src.infolist():
            if info.filename == "classes.dex":
                continue
            dst.writestr(info, src.read(info.filename))
        with open(classes_dex, "rb") as dex:
            dst.writestr("classes.dex", dex.read())

    print(f"wrote {out_apk}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
