# Modules

Optional client-side modules. Add or remove module files here; they are auto-loaded via the `modules/cl_*.lua` pattern in the fxmanifest.

Current modules:
- `cl_overhead_text.lua`: renders floating text above player heads when triggered by `pxc:showFloatingText` event.
- `cl_notifications.lua`: handles standard GTA V notification pop ups with color coded prefixes for different alert levels.

---

## Overhead Text Module Details
This module handles the rendering of temporary 3D text labels that "stick" to a player's head bone. It uses an optimized thread that only stays active when there is text to display.

### Configuration Constants:
| Variable | Value | Description |
| :--- | :--- | :--- |
| FloatingTextDuration | 5000 | How long the text stays visible (ms). |
| FloatingTextMaxDistance | 50.0 | Max distance (meters) before text stops rendering. |
| FloatingTextSize | 1.0 | Base scale of the text. |
| FloatingTextFont | 4 | The UI font ID used for the render. |

### Technical Behavior:
- **Dynamic Scaling**: The text size adjusts based on the player's distance and camera FOV to remain legible.
- **Bone Tracking**: The text follows the head bone of the target player entity, with a slight vertical offset _*(+0.2 units)*_.
- **Performance**: The main loop idles at 500ms when no text is active to save CPU cycles.

### Events:
- `pxc:showFloatingText`: Triggers a text label to appear over a specific player.
   - **Parameters**:
      - `target (int)` - The Server ID of the player who should have the text above them.
      - `text (string)` The message to display.
   - **Validation**: Includes a check to prevent clients from spoofing the event locally with a source ID.

---

## Notification Module Details
This module provides a unified way to display on screen notifications using color coded prefixes.

### Notification Types & Colors:
| Type | Prefix | Color |
| :--- | :--- | :--- |
| success | ~g~ | Green |
| error | ~r~ | Red |
| warning | ~y~ | Yellow |
| info | ~b~ | Blue |

### Events:
- `pxc:notify`: Allows the server to trigger a notification for the client.
   - **Security**: Includes a safety check to ensure it is not being executed as a local command by a client.
   - **Parameters**:
    ```
    message (string), notifType (string, defaults to "info")
    ```
- `pxc:notifyLocal`: Used by other client side scripts to trigger a notification locally without network overhead.
   - **Parameters**:
   ```
   message (string), notifType (string, defaults to "info")
   ```

