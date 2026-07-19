/* ============================================================
   Interactive 3D Potato — Three.js viewer
   Loads a baked glTF model (exported from Blender) and presents it
   with image-based lighting, orbit controls, a soft contact shadow,
   and a click-for-a-fact interaction.
   ============================================================ */

import * as THREE from "three";
import { OrbitControls } from "three/addons/controls/OrbitControls.js";
import { RoomEnvironment } from "three/addons/environments/RoomEnvironment.js";
import { GLTFLoader } from "three/addons/loaders/GLTFLoader.js";

const MODEL_URL = "assets/models/potato.glb";

const mount = document.getElementById("potato-viewer");
if (mount) {
  try { initPotato(mount); }
  catch (err) {
    try { sessionStorage.setItem("__potatoErr", (err && err.stack) || String(err)); } catch (_) {}
    console.error("Potato init failed:", err);
  }
}

function initPotato(mount) {
  const loading = document.getElementById("viewer-loading");
  const tooltip = document.getElementById("viewer-tooltip");

  const scene = new THREE.Scene();
  const W = mount.clientWidth, H = mount.clientHeight;

  const camera = new THREE.PerspectiveCamera(36, W / H, 0.1, 100);
  camera.position.set(0.4, 0.4, 6.4);

  const renderer = new THREE.WebGLRenderer({ antialias: true, alpha: true });
  renderer.setSize(W, H);
  renderer.setPixelRatio(Math.min(window.devicePixelRatio, 2));
  renderer.shadowMap.enabled = true;
  renderer.shadowMap.type = THREE.PCFSoftShadowMap;
  renderer.toneMapping = THREE.ACESFilmicToneMapping;
  renderer.toneMappingExposure = 1.0;
  mount.appendChild(renderer.domElement);

  // image-based lighting for soft, realistic reflections
  const pmrem = new THREE.PMREMGenerator(renderer);
  scene.environment = pmrem.fromScene(new RoomEnvironment(), 0.04).texture;

  // soft key + warm fill (matches the Blender studio mood)
  scene.add(new THREE.HemisphereLight(0xfff3e0, 0x6a5236, 0.35));
  const key = new THREE.DirectionalLight(0xfff4de, 1.4);
  key.position.set(3, 6, 5);
  key.castShadow = true;
  key.shadow.mapSize.set(2048, 2048);
  key.shadow.camera.near = 1; key.shadow.camera.far = 22;
  key.shadow.bias = -0.0004;
  key.shadow.radius = 5;
  scene.add(key);
  const fill = new THREE.DirectionalLight(0xffe6bf, 0.4);
  fill.position.set(-5, 1.5, -3);
  scene.add(fill);

  const potato = new THREE.Group();
  scene.add(potato);

  // soft contact shadow
  const ground = new THREE.Mesh(
    new THREE.PlaneGeometry(16, 16),
    new THREE.ShadowMaterial({ opacity: 0.22 })
  );
  ground.rotation.x = -Math.PI / 2;
  ground.receiveShadow = true;
  scene.add(ground);

  // controls
  const controls = new OrbitControls(camera, renderer.domElement);
  controls.enableDamping = true;
  controls.dampingFactor = 0.08;
  controls.minDistance = 4.2;
  controls.maxDistance = 9;
  controls.enablePan = false;
  controls.autoRotate = true;
  controls.autoRotateSpeed = 1.0;
  controls.target.set(0, 0, 0);

  let model = null;

  // load the baked Blender model
  const loader = new GLTFLoader();
  loader.load(
    MODEL_URL,
    (gltf) => {
      model = gltf.scene;
      model.traverse((o) => {
        if (o.isMesh) {
          o.castShadow = true;
          o.receiveShadow = true;
          if (o.material) {
            o.material.envMapIntensity = 0.5;
            o.material.needsUpdate = true;
          }
        }
      });

      // centre the model and scale it to a consistent size
      const box = new THREE.Box3().setFromObject(model);
      const size = new THREE.Vector3(), center = new THREE.Vector3();
      box.getSize(size); box.getCenter(center);
      model.position.sub(center);                 // centre at origin
      const targetH = 3.0;
      const s = targetH / Math.max(size.x, size.y, size.z);
      model.scale.setScalar(s);
      potato.add(model);

      // sit it on the (invisible) shadow ground
      const box2 = new THREE.Box3().setFromObject(potato);
      ground.position.y = box2.min.y - 0.02;

      if (loading) loading.style.display = "none";
    },
    undefined,
    (err) => {
      console.error("Failed to load potato model:", err);
      if (loading) loading.innerHTML = "<div>Could not load the 3D model.</div>";
    }
  );

  /* ---- interaction: click the potato for a fact ---- */
  const facts = [
    "Potato eyes are buds — each one can grow into a brand-new plant.",
    "A single potato plant can yield up to 20 tubers underground.",
    "Potatoes were the first vegetable grown in space, back in 1995.",
    "There are over 4,000 known varieties of native potato.",
    "By weight, a raw potato is about 79% water.",
    "Green patches signal solanine — cut them away before cooking.",
    "Potatoes were first domesticated in the Andes some 8,000 years ago.",
    "Stored cool and dark, potatoes keep for months.",
    "The skin holds much of the potato's fibre and potassium.",
    "Cool a cooked potato and it forms gut-friendly resistant starch.",
    "China and India together grow a third of the world's potatoes.",
  ];
  let factIdx = 0;

  const ray = new THREE.Raycaster();
  const mouse = new THREE.Vector2();
  function pointer(e) {
    const r = renderer.domElement.getBoundingClientRect();
    const cx = (e.touches ? e.touches[0].clientX : e.clientX) - r.left;
    const cy = (e.touches ? e.touches[0].clientY : e.clientY) - r.top;
    mouse.x = (cx / r.width) * 2 - 1;
    mouse.y = -(cy / r.height) * 2 + 1;
    return { cx, cy };
  }
  function hitPotato() {
    if (!model) return false;
    ray.setFromCamera(mouse, camera);
    return ray.intersectObject(potato, true).length > 0;
  }
  function showTip(text, cx, cy) {
    if (!tooltip) return;
    tooltip.textContent = text;
    tooltip.style.left = cx + "px";
    tooltip.style.top = cy + "px";
    tooltip.classList.add("show");
  }
  function hideTip() { tooltip && tooltip.classList.remove("show"); }

  renderer.domElement.addEventListener("pointermove", (e) => {
    const { cx, cy } = pointer(e);
    if (hitPotato()) {
      renderer.domElement.style.cursor = "pointer";
      if (!tooltip || !tooltip.classList.contains("show")) showTip("Click for a fact", cx, cy);
    } else {
      renderer.domElement.style.cursor = "grab";
      if (tooltip && tooltip.textContent === "Click for a fact") hideTip();
    }
  });
  renderer.domElement.addEventListener("click", (e) => {
    const { cx, cy } = pointer(e);
    if (hitPotato()) {
      showTip(facts[factIdx % facts.length], cx, cy);
      factIdx++;
      clearTimeout(showTip._t);
      showTip._t = setTimeout(hideTip, 4500);
    }
  });

  // toolbar
  const btnRotate = document.getElementById("btn-rotate");
  const btnReset = document.getElementById("btn-reset");
  const btnZoomIn = document.getElementById("btn-zoom-in");
  const btnZoomOut = document.getElementById("btn-zoom-out");
  if (btnRotate) {
    btnRotate.classList.toggle("is-on", controls.autoRotate);
    btnRotate.addEventListener("click", () => {
      controls.autoRotate = !controls.autoRotate;
      btnRotate.classList.toggle("is-on", controls.autoRotate);
    });
  }
  if (btnReset) btnReset.addEventListener("click", () => {
    controls.reset();
    camera.position.set(0.4, 0.4, 6.4);
  });
  if (btnZoomIn) btnZoomIn.addEventListener("click", () => { camera.position.multiplyScalar(0.85); controls.update(); });
  if (btnZoomOut) btnZoomOut.addEventListener("click", () => { camera.position.multiplyScalar(1.15); controls.update(); });

  function onResize() {
    const w = mount.clientWidth, h = mount.clientHeight;
    camera.aspect = w / h; camera.updateProjectionMatrix();
    renderer.setSize(w, h);
  }
  window.addEventListener("resize", onResize);

  // render loop (window.__pausePotato halts it so tooling can grab a still)
  function loop() {
    if (window.__pausePotato) {
      window.__resumePotato = () => { window.__pausePotato = false; loop(); };
      return;
    }
    controls.update();
    renderer.render(scene, camera);
    requestAnimationFrame(loop);
  }
  loop();
}
