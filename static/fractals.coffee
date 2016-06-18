ParamControl = L.Control.extend({
  options:
    position: 'topright'
  onAdd: (map) ->
    this_map = map
    container = L.DomUtil.create('div', 'param-control leaflet-control-layers leaflet-control-layers-expanded');
    p1 = L.DomUtil.create('input', '', container)
    p1.setAttribute('id', 'param1')
    p1.setAttribute('type', 'number')
    p2 = L.DomUtil.create('input', '', container)
    p2.setAttribute('id', 'param2')
    p2.setAttribute('type', 'number')
    p3 = L.DomUtil.create('input', '', container)
    p3.setAttribute('id', 'param3')
    p3.setAttribute('type', 'number')
    btn = L.DomUtil.create('button', '', container)
    btn.innerHTML = 'Update'
    L.DomEvent.addListener btn, 'click', ->
      this_map.eachLayer((layer)->
        layer.options.f_formula = [document.getElementById('param1').value,
          document.getElementById('param2').value,
          document.getElementById('param3').value].join(',')
        layer.redraw()
      )
      return
    return container;
})


map = L.map 'map', {minZoom: 0, crs: L.CRS.Simple}
multibrot_layer = L.tileLayer '/tile/{f_type}_{f_formula}_{z}_{x}_{y}.png',
  f_type: 'multibrot'
  f_formula: '2,0,0'
  continuousWorld: true
  noWrap: true
  maxBounds: [[-2, -2], [2, 2]]
.addTo(map)
julia_layer = L.tileLayer '/tile/{f_type}_{f_formula}_{z}_{x}_{y}.png',
  f_type: 'julia'
  f_formula: '2,-0.4,0.6'
  continuousWorld: true
  noWrap: true
  maxBounds: [[-2, -2], [2, 2]]
burning_layer = L.tileLayer '/tile/{f_type}_{f_formula}_{z}_{x}_{y}.png',
  f_type: 'burning'
  f_formula: '2,-0.4,0.6'
  continuousWorld: true
  noWrap: true
  maxBounds: [[-2, -2], [2, 2]]
layers =
  'multibrot': multibrot_layer
  'julia': julia_layer
  'burning ship': burning_layer
lc = L.control.layers(layers, {}, {position: 'topleft', collapsed: false}).addTo(map)
map.addControl(new ParamControl())
map.setView([0, 0], 0)