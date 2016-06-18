map = L.map 'map', {minZoom: 0}
mandelbrot_layer = L.tileLayer '/tile/{f_type}_{f_formula}_{z}_{x}_{y}.png',
  f_type: 'mandelbrot'
  f_formula: 2
  noWrap: true
  maxBounds: [[0, 0], [2, 2]]
.addTo(map)
layers =
  'mandelbrot': mandelbrot_layer
lc = L.control.layers(layers, {}, {position: 'topleft', collapsed: false}).addTo(map)
map.setView([0, 0], 1)