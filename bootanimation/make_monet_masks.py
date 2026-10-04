#!/usr/bin/env python3
"""Turn the authored RGB bootanimation into Monet channel masks.

The bootanimation dynamic-color shader uses R, G, B and A as masks for four
colors. Pixels with all four channels set stay white. This preserves the owl
and the wordmark, maps the teal circle to color1 and the orange sparks to
color2.

Pass the original RGB zip, not a zip this script already wrote.
"""

import io
import sys
import zipfile
from multiprocessing import Pool

import numpy as np
from PIL import Image

TEAL = np.array([32, 96, 112], np.float32)
ORANGE = np.array([240, 160, 48], np.float32)


def to_mask(rgb, light):
    r = rgb[:, :, 0].astype(np.float32)
    g = rgb[:, :, 1].astype(np.float32)
    b = rgb[:, :, 2].astype(np.float32)
    mx = np.maximum(np.maximum(r, g), b)
    mn = np.minimum(np.minimum(r, g), b)
    sat = mx - mn
    luma = (r + g + b) / 3.0
    achroma = sat < 32
    orange = (~achroma) & (r > g) & (g >= b) & (r > 50)
    teal = (~achroma) & (~orange)

    def proj(brand):
        denom = float(np.dot(brand, brand))
        num = r * brand[0] + g * brand[1] + b * brand[2]
        return np.clip(num / denom, 0, 1)

    teal_a = np.where(teal, proj(TEAL), 0)
    orange_a = np.where(orange, proj(ORANGE), 0)
    white = np.where(achroma, (1.0 - luma / 255.0) if light else luma / 255.0, 0)
    if not light:
        white = np.where(luma < 16, 0, white)
    w = np.clip(white, 0, 1)
    channels = np.dstack([
        np.clip(np.maximum(teal_a, w), 0, 1),
        np.clip(np.maximum(orange_a, w), 0, 1),
        w,
        w,
    ])
    return (channels * 255).astype(np.uint8)


def convert_frame(item):
    name, data, light = item
    rgb = np.array(Image.open(io.BytesIO(data)).convert("RGB"))
    mask = to_mask(rgb, light)
    buf = io.BytesIO()
    Image.fromarray(mask, "RGBA").save(buf, format="PNG", optimize=True, compress_level=9)
    return name, buf.getvalue()


def build(src, dst, light, desc):
    with zipfile.ZipFile(src) as zin:
        frames = [(i.filename, zin.read(i.filename), light)
                  for i in zin.infolist()
                  if i.filename.lower().endswith(".png")]
    print(f"converting {len(frames)} frames light={light} -> {dst}", flush=True)
    with Pool() as pool:
        converted = dict(pool.map(convert_frame, frames, chunksize=4))
    with zipfile.ZipFile(dst, "w") as zout:
        zout.writestr("desc.txt", desc.encode("utf-8"), compress_type=zipfile.ZIP_STORED)
        for name, _, _ in frames:
            zout.writestr(name, converted[name], compress_type=zipfile.ZIP_STORED)
    print(f"wrote {dst}", flush=True)


def main():
    src, light_dst, dark_dst = sys.argv[1:]
    with zipfile.ZipFile(src) as zin:
        original = zin.read("desc.txt").decode("utf-8").splitlines()
        part0 = sum(1 for i in zin.infolist() if i.filename.startswith("part0/") and i.filename.endswith(".png"))
    header = original[0]
    parts = [line for line in original[1:] if line.strip()]
    dynamic = f"dynamic_colors part0 #206070 #F0A030 #000000 #000000 0 {part0 - 1}"
    desc = "\n".join([header, dynamic, *parts]) + "\n"
    build(src, light_dst, True, desc)
    build(src, dark_dst, False, desc)


if __name__ == "__main__":
    main()
