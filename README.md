<p align="center">
  <a href="https://github.com/swiftly-solution/admins">
    <img src="https://cdn.swiftlycs2.net/swiftly-logo.png" alt="SwiftlyLogo" width="80" height="80">
  </a>

  <h3 align="center">[Swiftly] Admin System - Base Commands</h3>

  <p align="center">
    A simple plugin for Swiftly that implements some base commands.
    <br/>
  </p>
</p>

<p align="center">
  <img src="https://img.shields.io/github/downloads/swiftly-solution/admins/total" alt="Downloads"> 
  <img src="https://img.shields.io/github/contributors/swiftly-solution/admins?color=dark-green" alt="Contributors">
  <img src="https://img.shields.io/github/issues/swiftly-solution/admins" alt="Issues">
  <img src="https://img.shields.io/github/license/swiftly-solution/admins" alt="License">
</p>

---

### Installation 👀

1. Download the newest [release](https://github.com/swiftly-solution/admins/releases) of Admins - Core.
2. Download the newest [release](https://github.com/swiftly-solution/admins_commands/releases) of Admins - Base Commands.
3. Everything is drag & drop, so I think you can do it!
4. Setup database connection in `addons/swiftly/configs/databases.json` with the key `swiftly_admins` like in the following example:
```json
{
    "swiftly_admins": {
        "hostname": "...",
        "username": "...",
        "password": "...",
        "database": "...",
        "port": 3306
    }
}
```
> [!WARNING]
> Don't forget to replace the `...` with the actual values !!

### Configuring the plugin 🧐

* After installing the plugin, you need to change the prefix from `addons/swiftly/configs/plugins` (optional) and if you want, you can change the messages from `addons/swiftly/translations`.

### Admin Commands 💬

* Base commands provided by this plugin:

|      Command     |        Flag       |               Description              |
|:----------------:|:-----------------:|:--------------------------------------:|
|       !rcon      |    ADMFLAG_RCON   |      Executes a command on server.     |
|       !slay      |    ADMFLAG_SLAY   |             Kills a player.            |
|       !slap      |    ADMFLAG_SLAY   |             Slaps a player.            |
| !map / !changemap | ADMFLAG_CHANGEMAP |       Changes the map on server.       |
|       !csay      |    ADMFLAG_CHAT   |   Sends a centered message on server.  |
|       !rename      |    ADMFLAG_CHAT   |   Renames a player.  |

### Creating A Pull Request 😃

1. Fork the Project
2. Create your Feature Branch
3. Commit your Changes
4. Push to the Branch
5. Open a Pull Request

### Have ideas/Found bugs? 💡
Join [Swiftly Discord Server](https://swiftlycs2.net/discord) and send a message in the topic from `📕╎plugins-sharing` of this plugin!

---
