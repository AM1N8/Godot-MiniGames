# Godot 4 Active Ragdoll Puzzle-Platformer Level

A physical 3D puzzle-platformer level designed for Godot 4, highlighting physics-based active ragdoll locomotion and independent hand-grabbing mechanics (similar to *Human Fall Flat*).

## Level Design Overview

The level is structured as a progressive vertical/horizontal climb, divided into 5 distinct areas:

```
[Tutorial Zone] ──> [Area 1: Button Puzzle] ──> [Area 2: Seesaw Bridge]
                                                      │
[Area 5: Zenith] <── [Area 4: Vault & Plug] <── [Area 3: Swing]
```

### 1. Tutorial Zone (Locomotion & Jumping)
- **Goal:** Get comfortable with the loose, physics-driven movement.
- **Challenge:** A sequence of low steps up a shallow incline.
- **Fail-safe:** Falling drops the player onto the floor below.

### 2. Area 1: Button Puzzle (Object Manipulation)
- **Goal:** Open the sliding door blocking the path.
- **Mechanics:** Locate the yellow physics crate and drag/push it onto the glowing green pressure plate.
- **Improvement:** The door now rises 6 meters high when activated to avoid hitting the character's head.

### 3. Area 2: Seesaw Bridge (Tilting Balance Platforming)
- **Goal:** Cross a wide chasm to reach the next platform.
- **Mechanics:** Step onto a dynamic, pivot-pinned seesaw plank. As the player walks past the center pivot, the plank tilts forward. Balance the ragdoll character and run to the other end to jump onto the landing platform.
- **Fail-safe:** Pinned in place, so the bridge itself cannot fall off.

### 4. Area 3: Timing & Swing (Timing & Double-Hand coordination)
- **Goal:** Cross a second gap to the upper temple entrance.
- **Mechanics:** Jump and grab onto a suspended physical pendulum bar using both hands, swing to gain momentum, and release to fly across.

### 5. Area 4: Vault & Plug (Both Hands & Heavy Physics)
- **Goal:** Gain access to the final elevator platform.
- **Mechanics:** A heavy concrete plug block blocks the doorway. Grab the handles with both hands to apply torque and pull it out of the socket.

### 6. Area 5: Zenith Sanctuary (Victory)
- **Goal:** Reach the cyan portal of light to win.

---

## Checkpoint & Respawn System

To eliminate frustration, an **instant checkpoint respawn system** is integrated:
- The game automatically tracks your progress based on your Z position.
- If you fall below $Y = -2.5$, the game immediately halts all physical momentum, clears bone velocities, and teleports you to the latest checkpoint you reached.

### Checkpoints:
1. **Spawn / Area 1 Entrance:** `Vector3(0, 2.5, 10.0)`
2. **Area 2 Entrance (before Seesaw):** `Vector3(0, 2.5, -34.0)`
3. **Area 3 Entrance (before Swing):** `Vector3(0, 2.5, -60.0)`
4. **Area 4 Entrance (before Vault):** `Vector3(0, 2.5, -100.0)`
5. **Area 5 Entrance (Zenith):** `Vector3(0, 5.5, -123.0)`

---

## Input Controls

| Action | Control |
|---|---|
| **Move** | `W` / `A` / `S` / `D` |
| **Jump** | `Space` |
| **Grab Left Hand** | `Left Click` |
| **Grab Right Hand** | `Right Click` |
| **Toggle Ragdoll (Limp)** | `R` |
| **Free Mouse/Menu** | `Esc` |

---

## Playtesting and Validation

### Running the game locally
To launch the game and playtest the level:
```bash
godot --path .
```
