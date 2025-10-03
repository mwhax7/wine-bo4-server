<p align="center">
  <img src="https://i.imgur.com/MvOB1uA.png" alt="Black Ops 4 Logo">
</p>

<h1 align="center">Black Ops 4 Demonware Server Emulator (Docker)</h1>

This project allows you to run a Black Ops 4 Demonware emulator server via Docker, running under Wine, letting you host your own Zombies or Multiplayer matches.

⚠️ Important: You must use the Black Ops 4 Project Shield Launcher to connect to the server.

**📦 Project Contents**
- 🐳 Docker image: `mwhax7/wine-bo4-server:latest`
- 🌐 WebUI: View online players, active lobbies, server uptime, CPU/memory usage, and manage lobbies.
- 🛠️ Admin WebUI: For managing the server and configuring advanced settings.

**🌐 WebUI**

<img src="https://i.imgur.com/wM9p2iM.png" alt="BO4 Server WebUI">

**🔢 Port Explanation**
| Port                | Usage             | Notes                                                                                                                                                                    |
| ------------------- | ----------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| 8080                | Main WebUI        | Fixed: the game automatically connects to this port to retrieve server information.                                                                                      |
| ${ADMIN_PORT:-8045} | Admin WebUI       | Configurable via the `ADMIN_PORT` environment variable. Default: 8045. Allows managing the server instance, creating/killing lobbies, and configuring advanced settings. |
| 3074                | Game (TCP/UDP)    | Primary port for player connections.                                                                                                                                     |
| 6542                | Game (TCP)        | Secondary port used by the server for certain network features.                                                                                                          |

**💾 Volumes**

`./data:/app/data` — Persists server files (`📜 logs`, `⚙️ configurations`, `💾 saves`).

## 🚀 Running the Server

1. ⚙️ Install Docker and Docker Compose on your machine.

2. 📂 Clone this repository. `git clone https://github.com/mwhax7/wine-bo4-server.git`

4. ✏️ Modify `docker-compose.yml` if you want to change the Admin port (`ADMIN_PORT`) or other configurations.

5. ▶️ Start the server with `docker-compose up -d` command.

6. 🌐 Access the main WebUI at http://<SERVER_IP>:8080
 to view server and lobby status.

7. 🛠️ Access the Admin WebUI at http://<SERVER_IP>:8045
 (or your custom ADMIN_PORT) to manage lobbies.

**🐳 Start the container with `docker run`**

```sh
docker run -d \
  --name wine-bo4-server \
  --restart unless-stopped \
  -e ADMIN_PORT=8045 \
  -p 8080:8080/tcp \
  -p 8045:8045/tcp \
  -p 3074:3074/tcp \
  -p 3074:3074/udp \
  -p 6542:6542/tcp \
  -v "$(pwd)/data:/app/data" \
  wine-bo4-server:latest
```

**🐙 or `docker-compose`**

```yaml
services:
  wine-bo4-server:
    image: wine-bo4-server:latest
    container_name: wine-bo4-server
    restart: unless-stopped
    environment:
      # Optional: if not set, the server will use 8045 by default
      ADMIN_PORT: 8045
    ports:
      # Webserver (required)
      - "8080:8080/tcp"
      # Admin panel (configurable with ADMIN_PORT above)
      - "${ADMIN_PORT:-8045}:${ADMIN_PORT:-8045}/tcp"
      # Game ports
      - "3074:3074/tcp"
      - "3074:3074/udp"
      - "6542:6542/tcp"
    volumes:
      # Mounts the local folder to keep files (logs, configs, etc.)
      - ./data:/app/data
```

## 🔌 Connecting to the Server

When launching the game with the Black Ops 4 Project Shield Launcher, you must specify the server IP:

🖥️ `Localhost (127.0.0.1)` – Use this if the server is running on the same machine as your game client.

🌍 `Remote Public IP` – Use your server’s public IP if hosted on another machine. Requires the necessary ports to be opened/forwarded on your router/firewall.

🏠 `LAN IP` – Use the local network IP (e.g., `192.168.x.x`) if the server is running on another device within the same LAN.

🔗 `ZeroTier` / `VPN IP` – Use the ZeroTier (or other VPN) assigned IP if connecting over a virtual LAN from a remote location.

## Notes
- ⚠️ The server works only with the Black Ops 4 Project Shield Launcher.
- 🔓 Make sure all critical ports are open in your firewall/router to allow players to connect.

**Main WebUI Features:**
- 👥 Online players
- 🎮 Active lobbies
- ⌚ Server uptime
- 🖥️ CPU and memory usage
- 📋 Player and lobby details (name, activity, map, etc.)
