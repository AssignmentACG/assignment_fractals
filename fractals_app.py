# -*- encoding: utf-8 -*-
# Author: Epix
import os

from PIL import Image, ImageDraw
from flask import Flask, send_file, send_from_directory

app = Flask(__name__)
CACHE_PATH = 'tile'
TILE_SIZE = 256
MAX_ITER = 100
ESCAPE_RADIUS = 4
BLACK_COLOR = (0, 0, 0)


def gradient2color_map(gradient):
    color_map = {i: gradient.get(i, None) for i in range(100 + 1)}
    gradient_key = list(gradient.keys())
    gradient_key.sort()
    gradient_bands = list(zip(gradient_key[:-1], gradient_key[1:]))
    for band_start, band_end in gradient_bands:
        for i in range(band_start + 1, band_end):
            band_start_color = gradient[band_start]
            band_end_color = gradient[band_end]
            color_map[i] = tuple(get_l(band_start, band_end, band_start_color[rgb], band_end_color[rgb], i) for rgb in
                                 range(3))
    return color_map


def get_l(start_k, stop_k, start_v, stop_v, key):
    value = start_v + (key - start_k) * (stop_v - start_v) / (stop_k - start_k)
    return int(value)


GRADIENT = {0: (41, 137, 204),
            50: (255, 255, 255),
            52: (144, 106, 0),
            64: (217, 159, 0),
            100: (255, 255, 255),
            }
COLOR_MAP = gradient2color_map(GRADIENT)


@app.route('/', methods=['GET'])
def homepage():
    return send_from_directory('static', 'index.html')


@app.route('/tile/<string:f_type>_<string:f_formula>_<int:z>_<int:x>_<int:y>.png', methods=['GET'])
def get_fractals(f_type, f_formula, z, x, y):
    path = os.path.join(CACHE_PATH,
                        '{f_type}_{f_formula}_{z}_{x}_{y}.png'.format(f_type=f_type, f_formula=f_formula, z=z, x=x,
                                                                      y=y))
    if not os.path.isfile(path):
        # if file not exist, generate
        if f_type == 'mandelbrot':
            make_mandelbrot(f_formula, z, x, y, path)
    return send_file(path)


def make_mandelbrot(f_formula, zoom, x, y, path):
    im = Image.new('RGB', (TILE_SIZE, TILE_SIZE))
    draw = ImageDraw.Draw(im)
    for p_x in range(TILE_SIZE):
        for p_y in range(TILE_SIZE):
            a_x = (p_x / TILE_SIZE + x) / (2 ** zoom)
            a_y = (p_y / TILE_SIZE + y) / (2 ** zoom)
            z = 0
            c = a_x + a_y * 1j
            for i in range(MAX_ITER):
                z = z ** 2 + c
                if abs(z) > ESCAPE_RADIUS:
                    draw.point((p_x, p_y), fill=COLOR_MAP[i])
                    break
            else:
                draw.point((p_x, p_y), fill=BLACK_COLOR)
    im.save(path)


@app.route('/<path:path>')
def send_static(path):
    return send_from_directory('static', path)


if __name__ == '__main__':
    app.run(
        # debug=True
    )
