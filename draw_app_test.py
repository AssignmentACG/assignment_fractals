# -*- encoding: utf-8 -*-
# Author: Epix
from PIL import Image, ImageDraw

MAX_ITER = 100
ESCAPE_RADIUS = 4
TILE_SIZE = 256


def make_mandelbrot(f_formula, z, x, y, path):
    im = Image.new('RGB', (TILE_SIZE, TILE_SIZE))
    draw = ImageDraw.Draw(im)
    for p_x in range(TILE_SIZE):
        for p_y in range(TILE_SIZE):
            a_x = p_x / TILE_SIZE + x
            a_y = p_y / TILE_SIZE + y
            z = 0
            c = a_x + a_y * 1j
            for i in range(MAX_ITER):
                z = z ** 2 + c
                if abs(z) > ESCAPE_RADIUS:
                    draw.point((p_x, p_y), fill=(int(i / MAX_ITER * 255), 0, 0))
                    break
            else:
                draw.point((p_x, p_y), fill=(0, 255, 0))
    im.save(path)


make_mandelbrot('', 0, 0, 0, 'test.png')
