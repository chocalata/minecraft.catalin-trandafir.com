# Minecraft Server

A simple Minecraft server that runs in Docker, with some helper scripts to make things easier.

## What's in this repo

- A Docker setup for running a Minecraft server
- Helper scripts to manage the server

## Table of Contents

- [What you'll need](#what-youll-need)
- [Quick start](#quick-start-development-image)
- [How it runs](#how-it-runs)
- [ENV variables/Server properties](#environment--serverproperties)
- [Things to know](#things-to-know)
- [Important files](#files-of-interest)

## What you'll need

- Docker (and docker-compose)
- Docker (and docker-compose)
- The Minecraft server JAR: this repository does not include `server.jar`. Set `MC_VERSION` in your `.env` to the desired version (or `latest`) and build the image with Docker Compose — the `get-server-jar.sh` downloads `server.jar` automatically.
- You need to accept the Minecraft EULA by editing `eula.txt` and setting `eula=true`

## Quick start (development image)

1. Copy the environment file template:

   ```
   cp .env.demo .env
   ```

   Then edit the `.env` file to set your RAM limits, CPU limits, and any server properties you want.

2. Accept the EULA:

   - Edit `eula.txt` and set `eula=true`
   - There's an example in `eula.txt.demo`

3. Build and run:
   ```
   docker compose up --build
   ```
   or to run in the background:
   ```
   docker compose up -d --build
   ```

## How it runs

When the container starts, it runs a main script that handles everything:

- **Orchestrator**: `minecraft-container/src/start.sh` (the main script)
- **Server jar downloader**: `minecraft-container/src/get-server-jar.sh`
- **Server starter**: `minecraft-container/src/start-server.sh`
- **Settings updater**: `minecraft-container/src/set-properties.sh`
- **Data cleaner**: `minecraft-container/src/delete-server.sh` (only if you tell it to)

Important settings you can use:

- `MC_MAX_RAM` and `MC_MIN_RAM` - control how much memory Java uses
- `MC_DELETE_SERVER=true` - will wipe your server data on startup (be careful!)
- `MC_PROPERTY_*` - any setting that starts with this will be added to server.properties

## Environment / server.properties

You can set Minecraft server properties using environment variables! Just prefix them with `MC_PROPERTY_`.

For example, `MC_PROPERTY_MAX_PLAYERS=10` becomes `max-players=10` in server.properties.

## Things to know

- This repo doesn't include the Minecraft `server.jar`. Uses the included downloader (`minecraft-container/src/get-server-jar.sh`) to fetch the requested `MC_VERSION` automatically.
- Make sure you have the `.env` file (copy from `.env.demo`)
- Don't forget to accept the EULA in `eula.txt`

## Files of interest

**Docker files:**

- `minecraft-container/Dockerfile.local`
- `minecraft-container/Dockerfile`
- `docker-compose.yml`
- `docker-compose-server.yml`

**Scripts:**

- `minecraft-container/src/start.sh`
- `minecraft-container/src/start-server.sh`
- `minecraft-container/src/set-properties.sh`
- `minecraft-container/src/delete-server.sh`
- `minecraft-container/src/get-server-jar.sh`

**Helper files:**

- `.env.demo`
- `eula.txt.demo`
