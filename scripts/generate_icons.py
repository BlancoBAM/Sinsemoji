#!/usr/bin/env python3
"""
Generate all Simplemoji SVG and PNG icon sizes using Cairo.
Color Palette:
  Background: Dark Black (#0d0a12)
  Accent: #a832a6 (Magenta/Purple)
"""
import os
import math
import cairo

def draw_simplemoji_icon(ctx, size):
    scale = size / 512.0
    ctx.scale(scale, scale)

    # 1. Dark Black Background squircle / rounded rect
    ctx.new_sub_path()
    r = 100
    x, y, w, h = 20, 20, 472, 472
    ctx.arc(x + w - r, y + r, r, -math.pi/2, 0)
    ctx.arc(x + w - r, y + h - r, r, 0, math.pi/2)
    ctx.arc(x + r, y + h - r, r, math.pi/2, math.pi)
    ctx.arc(x + r, y + r, r, math.pi, 3*math.pi/2)
    ctx.close_path()

    bg_pat = cairo.LinearGradient(0, 0, 512, 512)
    bg_pat.add_color_stop_rgb(0, 0.07, 0.05, 0.09)
    bg_pat.add_color_stop_rgb(1, 0.01, 0.01, 0.02)
    ctx.set_source(bg_pat)
    ctx.fill_preserve()

    border_pat = cairo.LinearGradient(0, 0, 512, 512)
    border_pat.add_color_stop_rgba(0, 0.75, 0.25, 0.75, 0.9)
    border_pat.add_color_stop_rgba(0.5, 0.658, 0.196, 0.651, 0.8) # #a832a6
    border_pat.add_color_stop_rgba(1, 0.35, 0.05, 0.40, 0.6)
    ctx.set_source(border_pat)
    ctx.set_line_width(10)
    ctx.stroke()

    glow_pat = cairo.RadialGradient(256, 256, 100, 256, 256, 210)
    glow_pat.add_color_stop_rgba(0, 0.658, 0.196, 0.651, 0.4)
    glow_pat.add_color_stop_rgba(1, 0.658, 0.196, 0.651, 0.0)
    ctx.set_source(glow_pat)
    ctx.arc(256, 256, 210, 0, 2*math.pi)
    ctx.fill()

    # 2. Main Emoji Face Circle
    face_pat = cairo.RadialGradient(210, 200, 30, 256, 256, 160)
    face_pat.add_color_stop_rgb(0, 0.88, 0.42, 0.90)
    face_pat.add_color_stop_rgb(0.45, 0.658, 0.196, 0.651)
    face_pat.add_color_stop_rgb(1.0, 0.38, 0.08, 0.42)
    ctx.set_source(face_pat)
    ctx.arc(256, 256, 150, 0, 2*math.pi)
    ctx.fill()

    ctx.set_source_rgba(1.0, 0.75, 1.0, 0.35)
    ctx.set_line_width(4)
    ctx.arc(256, 256, 150, 0, 2*math.pi)
    ctx.stroke()

    # 3. Eyes
    ctx.set_source_rgb(0.04, 0.02, 0.05)
    ctx.set_line_width(14)
    ctx.set_line_cap(cairo.LINE_CAP_ROUND)
    ctx.arc(205, 230, 26, 1.15*math.pi, 1.85*math.pi)
    ctx.stroke()

    ctx.set_source_rgb(0.04, 0.02, 0.05)
    ctx.set_line_width(14)
    ctx.set_line_cap(cairo.LINE_CAP_ROUND)
    ctx.arc(307, 230, 26, 1.15*math.pi, 1.85*math.pi)
    ctx.stroke()

    # 4. Cheerful Smile
    ctx.set_source_rgb(0.04, 0.02, 0.05)
    ctx.set_line_width(16)
    ctx.set_line_cap(cairo.LINE_CAP_ROUND)
    ctx.arc(256, 265, 68, 0.22*math.pi, 0.78*math.pi)
    ctx.stroke()

    ctx.save()
    ctx.arc(256, 265, 68, 0.25*math.pi, 0.75*math.pi)
    ctx.close_path()
    ctx.set_source_rgba(1.0, 0.35, 0.65, 0.85)
    ctx.fill()
    ctx.restore()

    # Cheeks
    ctx.set_source_rgba(1.0, 0.6, 0.85, 0.45)
    ctx.arc(172, 275, 20, 0, 2*math.pi)
    ctx.fill()
    ctx.arc(340, 275, 20, 0, 2*math.pi)
    ctx.fill()

    # 5. Sparkling Stars
    def draw_star(sx, sy, r1, r2, color):
        ctx.save()
        ctx.set_source_rgba(*color)
        ctx.new_path()
        for i in range(8):
            ang = i * math.pi / 4
            rad = r1 if i % 2 == 0 else r2
            px = sx + rad * math.cos(ang)
            py = sy + rad * math.sin(ang)
            if i == 0:
                ctx.move_to(px, py)
            else:
                ctx.line_to(px, py)
        ctx.close_path()
        ctx.fill()
        ctx.restore()

    draw_star(400, 110, 42, 14, (1.0, 0.95, 1.0, 0.95))
    draw_star(450, 175, 18, 6, (0.9, 0.7, 1.0, 0.85))
    draw_star(105, 395, 28, 9, (1.0, 0.9, 1.0, 0.9))

def main():
    base_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    icons_dir = os.path.join(base_dir, 'icons', 'hicolor')

    scalable_dir = os.path.join(icons_dir, 'scalable', 'apps')
    os.makedirs(scalable_dir, exist_ok=True)
    svg_path = os.path.join(scalable_dir, 'simplemoji.svg')
    svg_surf = cairo.SVGSurface(svg_path, 512, 512)
    ctx_svg = cairo.Context(svg_surf)
    draw_simplemoji_icon(ctx_svg, 512)
    svg_surf.finish()
    print(f"Generated {svg_path}")

    sizes = [16, 24, 32, 48, 64, 128, 256, 512]
    for s in sizes:
        s_dir = os.path.join(icons_dir, f"{s}x{s}", "apps")
        os.makedirs(s_dir, exist_ok=True)
        png_path = os.path.join(s_dir, "simplemoji.png")
        img_surf = cairo.ImageSurface(cairo.FORMAT_ARGB32, s, s)
        ctx_png = cairo.Context(img_surf)
        draw_simplemoji_icon(ctx_png, s)
        img_surf.write_to_png(png_path)
        print(f"Generated {png_path}")

if __name__ == '__main__':
    main()
