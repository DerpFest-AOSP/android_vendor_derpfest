#!/usr/bin/env python3
# Rewrite desc.txt so a bootanimation fits inside a device panel.
#
# Bootanimation draws frames at the width and height on the first line of
# desc.txt and centers them. The PNGs stay at their authored size and are
# scaled onto that rectangle, so one zip covers every resolution: larger
# panels get a bigger picture, smaller ones are not clipped.

import sys
import zipfile


def fit(src_w, src_h, dst_w, dst_h):
    if src_w <= 0 or src_h <= 0 or dst_w <= 0 or dst_h <= 0:
        return src_w, src_h
    scale = min(dst_w / src_w, dst_h / src_h)
    # Floor so rounding cannot make the picture larger than the panel.
    return max(1, int(src_w * scale)), max(1, int(src_h * scale))


def rewrite(src, dst, dst_w, dst_h):
    with zipfile.ZipFile(src) as zin:
        lines = zin.read("desc.txt").decode("utf-8").splitlines(keepends=True)
        replaced = False
        new_lines = []
        for line in lines:
            if not replaced and line.strip():
                parts = line.split()
                out_w, out_h = fit(int(parts[0]), int(parts[1]), dst_w, dst_h)
                parts[0] = str(out_w)
                parts[1] = str(out_h)
                newline = "\n" if line.endswith("\n") else ""
                new_lines.append(" ".join(parts) + newline)
                replaced = True
            else:
                new_lines.append(line)
        if not replaced:
            raise SystemExit(f"{src}: desc.txt has no resolution line")
        if new_lines and not new_lines[-1].endswith("\n"):
            new_lines[-1] += "\n"

        with zipfile.ZipFile(dst, "w") as zout:
            zout.writestr("desc.txt", "".join(new_lines).encode("utf-8"),
                          compress_type=zipfile.ZIP_STORED)
            for info in zin.infolist():
                if info.is_dir() or info.filename == "desc.txt":
                    continue
                # Stored entries are required; deflate is rejected at boot.
                zout.writestr(info, zin.read(info.filename),
                              compress_type=zipfile.ZIP_STORED)


def main(argv):
    if len(argv) != 5:
        print("usage: fit_desc.py SRC.zip DST.zip WIDTH HEIGHT", file=sys.stderr)
        return 2
    src, dst, width, height = argv[1:]
    try:
        dst_w = int(width)
        dst_h = int(height)
    except ValueError:
        print(f"width and height must be integers, got {width!r} {height!r}",
              file=sys.stderr)
        return 2
    rewrite(src, dst, dst_w, dst_h)
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv))
