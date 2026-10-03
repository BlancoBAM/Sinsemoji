#!/usr/bin/env python3
"""
Generate all Sinsemoji icon sizes using PIL from the master artwork in assets/sinsemoji.png.
"""
import os
from PIL import Image

def main():
    base_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    src_path = os.path.join(base_dir, 'assets', 'sinsemoji.png')
    icons_dir = os.path.join(base_dir, 'icons', 'hicolor')

    if not os.path.isfile(src_path):
        fallback = os.path.expanduser('~/Downloads/sinsemoji.png')
        if os.path.isfile(fallback):
            src_path = fallback
        else:
            raise FileNotFoundError(f"Master logo not found at {src_path}")

    im = Image.open(src_path).convert('RGBA')

    sizes = [16, 24, 32, 48, 64, 128, 256, 512, 1024]
    for s in sizes:
        s_dir = os.path.join(icons_dir, f"{s}x{s}", "apps")
        os.makedirs(s_dir, exist_ok=True)
        png_path = os.path.join(s_dir, "sinsemoji.png")
        resized = im.resize((s, s), Image.Resampling.LANCZOS)
        resized.save(png_path, format="PNG", optimize=True)
        print(f"Generated {png_path} ({s}x{s})")

if __name__ == '__main__':
    main()
