WIDTH = window.innerWidth
HEIGHT = window.innerHeight
ITER = 3
scene = new THREE.Scene()

camera = new THREE.PerspectiveCamera(25, WIDTH / HEIGHT, 1, 20)
camera.position.z = 5
scene.add(camera)

#light = new THREE.PointLight(0xFFCCFF)
#light.position.set(-100, 200, 100)
#scene.add(light)

ambientLight = new THREE.AmbientLight(0x000000);
scene.add(ambientLight);
lights = [];
lights[0] = new THREE.PointLight(0xffffff, 1, 0);
lights[1] = new THREE.PointLight(0xffffff, 1, 0);
lights[2] = new THREE.PointLight(0xffffff, 1, 0);

lights[0].position.set(0, 20, 0);
lights[1].position.set(10, 20, 10);
lights[2].position.set(-10, -20, -10);

scene.add(lights[0]);
scene.add(lights[1]);
scene.add(lights[2]);


renderer = new THREE.WebGLRenderer({antialias: true})
#renderer = new THREE.WebGLRenderer()
renderer.setSize(WIDTH, HEIGHT)
document.body.appendChild(renderer.domElement)

render = ->
  requestAnimationFrame(render);
  #  cube.rotation.x += 0.01;
  #  cube.rotation.y += 0.01;
  renderer.render(scene, camera);
render()

controls = new THREE.TrackballControls(camera);
controls.rotateSpeed = 1.0;
controls.zoomSpeed = 1.2;
controls.panSpeed = 0.8;
controls.noZoom = false;
controls.noPan = false;
controls.staticMoving = true;
controls.dynamicDampingFactor = 0.3;
controls.keys = [65, 83, 68];
controls.addEventListener('change', render);

animate = ->
  requestAnimationFrame(animate);
  controls.update();
animate()


base_geometry = new THREE.BoxGeometry(1, 1, 1);
material = new THREE.MeshStandardMaterial({color: '#2194ce'})
transform_vectors_array = [
  [1, 1, 1],
  [1, 1, -1],
  [1, -1, 1],
  [1, -1, -1],
  [-1, 1, 1],
  [-1, 1, -1],
  [-1, -1, 1],
  [-1, -1, -1],
  [1, 1, 0],
  [1, -1, 0],
  [-1, 1, 0],
  [-1, -1, 0],
  [1, 0, 1],
  [1, 0, -1],
  [-1, 0, 1],
  [-1, 0, -1],
  [0, 1, 1],
  [0, 1, -1],
  [0, -1, 1],
  [0, -1, -1],
]
transform_vectors = []
for transform_vector_array in transform_vectors_array
  transform_vectors.push(
    new THREE.Vector3(transform_vector_array[0], transform_vector_array[1], transform_vector_array[2])
  )

transform_matrices = []
for transform_vector in transform_vectors
  transform_matrices.push(
    new THREE.Matrix4().setPosition(transform_vector)
  )


make_fractal = (transform_matrices, base_geometry)->
  geometries = []
  for transform_matrix in transform_matrices
    current_geometry = base_geometry.clone()
    current_geometry.applyMatrix(transform_matrix)
    geometries.push(
      current_geometry
    )

  result_geometry = new THREE.Geometry()
  for geometry in geometries
    result_geometry.merge(geometry)
  result_geometry.scale(1 / 3, 1 / 3, 1 / 3)
  return result_geometry

iter_geometry = base_geometry.clone()
for i in [1..ITER]
  iter_geometry = make_fractal(transform_matrices, iter_geometry)
cube = new THREE.Mesh(iter_geometry, material);
scene.add(cube);

