# Modules

Optional client-side modules. Add or remove module files here; they are auto-loaded via the `modules/cl_*.lua` pattern in the fxmanifest.

Current modules:
- `cl_overhead_text.lua`: renders floating text above player heads when triggered by `pxc:showFloatingText` event.
- `cl_notifications.lua`: handles standard GTA V notification pop ups with color coded prefixes for different alert levels.

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
