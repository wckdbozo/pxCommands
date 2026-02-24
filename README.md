# pxCommands
[![License: AGPL v3](https://img.shields.io/badge/License-AGPL_v3-blue.svg)](https://www.gnu.org/licenses/agpl-3.0)
![Version](https://img.shields.io/badge/version-0.2.0-blue)

`pxCommands` bridges the gap between complex frameworks and standalone simplicity. It handles the heavy lifting of command security creation and registration, leaving you to focus on the logic.

---

## Key Features
- **Framework Agnostic:** Native support for **ESX, QBCore, QBox**, and **Standalone** servers.
- **Secure by Design:** Server side enforcement prevents client side spoofing.
- **Integrated Visuals:** Built in modules for **3D Overhead Text** and **Color coded Notifications**.
- **Proximity Aware:** Range based messaging for immersive roleplay.
- **Auto Documentation:** Generates command suggestions and help tooltips automatically.

---

## Quick Start

1. **Install:** Drop `pxCommands` into your `resources` folder.
2. **Initialize:** Add `ensure pxCommands` to your `server.cfg`.
3. **Configure:** Open `system/config.lua` to set your framework:
   ```lua
   Config.Framework = 'qbox'  -- 'esx', 'qbcore', 'qbox', or 'standalone'
4. **Create**: Create your first command pack in the `commands/` folder.
5. **Deploy**: Open your F8 console in game and run `restart pxCommands` to see your new command(s) in action.

## Modular System
pxCommands uses a modular client side architecture. You can easily extend how players interact with your commands.

| Module | Description | Event Trigger |
| :--- | :--- | :--- |
| **Notifications** | Colored screen alerts | `pxc:notify` |
| **Overhead Text** | Floating 3D text | `pxc:showFloatingText` |


---

## Documentation

| Resource | Description |
| :--- | :--- |
| [Getting Started](https://codemeapixel.dev/docs/scripts/fxserver/pxcommands/getting-started) | Full installation and framework setup. |
| [Command Packs]([docs/COMMAND_PACKS.md](https://codemeapixel.dev/docs/scripts/fxserver/pxcommands/command-packs)) | How to write and register new commands. |
| [Config Reference]([docs/CONFIG_REFERENCE.md](https://codemeapixel.dev/docs/scripts/fxserver/pxcommands/configuration)) | Deep dive into config.lua settings. |
| [Module Reference]([docs/ARCHITECTURE.md](https://codemeapixel.dev/docs/scripts/fxserver/pxcommands/modules)) | Technical flow and module breakdown. |

## Open-Source License
This project is licensed under the GNU Affero General Public License v3.0. See the [LICENSE](./LICENSE) file for details.

