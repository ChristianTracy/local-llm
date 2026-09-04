> You are a senior Three.js engineer. 
Create a complete, runnable 3D Breakout (Arkanoid) game in a SINGLE file named exactly `index.html`
 (lowercase), written to disk with a file-write tool (not just printed to chat). All CSS and JS
 inline.

   === HARD CONSTRAINTS ===
   - Three.js 0.160.0 ONLY, loaded via es-module-shims + importmap. Use exactly:
     <script async src="https://unpkg.com/es-module-shims@1.8.0/dist/es-module-shims.js"></script>
     <script
 type="importmap">{"imports":{"three":"https://unpkg.com/three@0.160.0/build/three.module.js","three/a
 ddons/":"https://unpkg.com/three@0.160.0/examples/jsm/"}}</script>
   - Vanilla Three.js only. NO physics/animation/sound libraries (no cannon-es, gsap, howler).
   - NO external assets (no texture/model/sound files). All visuals from Three.js geometry + materials
 + procedural CanvasTexture; all audio from Web Audio oscillators.
   - Game loop: requestAnimationFrame + THREE.Clock.getDelta() with delta clamped to 0.05.
   - renderer.shadowMap.enabled = true and shadowMap.type = THREE.PCFSoftShadowMap.
   - No placeholders, no `// TODO`. Code must run immediately when opened in a browser.

   === RENDERER / SCENE / CAMERA ===
   - Logical size W=800, H=600; renderer antialias, setPixelRatio(min(devicePixelRatio,2)),
 ACESFilmicToneMapping exposure 1.1.
   - Scene background #06080f; Fog(#06080f, 38, 75).
   - PerspectiveCamera fov 60, aspect W/H, near 0.1 far 100. Auto camera base position (0,9,14)
 looking at (0,1,0) — this framing keeps ALL bricks, the paddle, and the floor in view.

   === PLAYFIELD (2D gameplay at z=0 in a 3D scene) ===
   - Invisible wall colliders: LEFT=-6, RIGHT=6, TOP=8, FLOOR_Y=-6. Paddle rests at PADDLE_Y=-4.5.
   - A subtle LineLoop border frame drawn around those bounds as decoration (colliders themselves
 invisible).
   - Paddle: RoundedBoxGeometry(2.4, 0.3, 0.8, 4, 0.1), PADDLE_SPEED=11, clamped to [LEFT+1.2,
 RIGHT-1.2].
   - Ball: SphereGeometry radius BALL_R=0.25, BALL_SPEED=16.
   - Bricks: 8 cols x 5 rows of RoundedBoxGeometry(1.3, 0.55, 0.9, 4, 0.08). X starts at -5.25 with
 1.5 spacing; Y starts at 4.5 with 0.85 spacing (rows 0..4). 5 distinct row colors top→bottom:
 0xff5252, 0xffb74d, 0xffd54f, 0x66bb6a, 0x4fc3f7.

   === PHYSICS / GAMEPLAY ===
   - Paddle move: ArrowLeft/ArrowRight and A/D.
   - Ball launch: random small spread angle = (Math.random()-0.5)*0.5; velocity (sin(a)*SPEED,
 cos(a)*SPEED, 0).
   - Paddle reflection: offset = clamp((ball.x-paddle.x)/(PADDLE_W/2), -1, 1); angle = offset*60°;
 velocity = (sin(angle)*SPEED, cos(angle)*SPEED).
   - Brick collision: AABB overlap; reflect off the face with least penetration; +10 score per brick.
   - Walls reflect the ball (left/right/top).
   - Anti-stall: if |ballVel.y| < 1.5, nudge ballVel.y to ±1.5.
   - Ball below FLOOR_Y → lose a life. 3 lives total.
   - All bricks destroyed → victory.

   === STATE MACHINE ===
   - States: START, READY, PLAYING, PAUSED, GAMEOVER, VICTORY.
   - START --Space--> READY (ball sits on paddle). READY --Space--> PLAYING (launch). PLAYING
 --Space--> PAUSED. PAUSED --Space--> PLAYING.
   - loseLife → back to READY (ball resets on paddle) or GAMEOVER if 0 lives.
   - GAMEOVER/VICTORY: any key press or click → full reset → START.

   === LIGHTING / SHADOWS ===
   - AmbientLight 0x404040 intensity 1.2.
   - DirectionalLight 0xffffff intensity 1.7 at (6,16,9), castShadow: mapSize 2048x2048, shadow camera
 left/right -10/10, top 12, bottom -10, near 2, far 45, bias -0.0003, normalBias 0.02.
   - Rim DirectionalLight 0x4a6cff intensity 0.5 at (-8,4,-10).
   - PointLight 0x66d9ff intensity 1.2 range 9 decay 2 that follows the ball at (ball.x, ball.y+0.3,
 1.5).

   === PROCEDURAL TEXTURES (CanvasTexture, no files) ===
   - Floor: 512x512 canvas — base #0d1226, central radial glow, fine subgrid (32px) + main grid
 (64px), edge vignette. Plane 46x46 at y=-6, receiveShadow.
   - Bricks: 256x96 canvas per row — base row color, vertical gloss gradient (bright top → dark
 bottom), ~40 subtle random white streaks, bevel border stroke.
   - Paddle: 256x64 canvas — vertical gradient #9feaff→#29c7ff→#0a6fa8, center stripe, two edge
 accents.
   - Backdrop: 1024x512 canvas — vertical gradient #0a1028→#070b1c→#03050c plus 3 soft nebula radial
 blobs; on a 220x110 plane at (0,8,-48) with fog disabled.
   - Starfield: ~260 THREE.Points scattered behind the playfield.

   === ANIMATIONS / EFFECTS ===
   - Brick death: 0.25s scale-to-0 + emissive flash; then hidden.
   - Paddle squash/stretch: 0.1s sine curve on hit.
   - Ball emissive pulse while playing: 0.4 + 0.35*(0.5+0.5*sin(elapsed*8)).
   - Ball trail: 12 ghost spheres with fading opacity (hidden outside active play).
   - Particle burst on brick destroy: 10 small spheres, gravity, fade, colored to the brick's row
 color.
   - Camera shake (0.35s) on life loss.
   - Auto camera: lerp X toward paddle.x*0.25 (factor min(1, dt*4)); tiny Y offset (0.3) on launch
 decaying via exp(-dt*3).

   === MANUAL CAMERA MODE (optional) ===
   - Toggle with C key; HUD shows "CAM: AUTO" / "CAM: MANUAL".
   - Switching to manual takes over the current auto-camera position (compute yaw/pitch/dist from it)
 so there's no jump.
   - Drag to orbit (pitch clamped 0.08–1.35 rad); wheel to zoom (dist clamped 8–30).
   - Default manual orbit ≈ base camera: target (0,1,0), yaw 0, pitch 0.519, dist 16.16.
   - R resets the manual orbit (or the auto camera). Camera shake still applies in both modes.

   === AUDIO (Web Audio oscillators, unlocked on first user gesture) ===
   - Each beep = 2 layers: base oscillator + a quieter octave (freq*2 at 25% volume).
   - Paddle: 880 Hz square 0.07s vol 0.18. Brick: 660 Hz triangle 0.09s vol 0.22. Life lost: 220 Hz
 sawtooth 0.35s vol 0.22. Victory: 523/659/784 Hz sine, 0.12s apart.
   - Mute toggle with M key (🔊/🔇 indicator).

   === HUD / SCREENS (DOM overlay) ===
   - HUD: score (with a pop animation on change), lives as hearts (♥/·), camera mode, mute indicator.
   - Overlay screen with gradient title, blinking "press space" subtitle, and a key-hints block.
   - Screens shown for: start, pause, game over, victory.

   Make it polished and complete — this is the final version, not a prototype.