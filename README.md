# Minecraft Server (mc.catalin-trandafir.com)

A simple Minecraft server that runs in Docker, with some helper scripts to make things easier.

## What's in this repo

- A Docker setup for running a Minecraft server
- Helper scripts to manage the server
- Everything you need to get started (except the actual Minecraft server file)

## Table of Contents

- [What you'll need](#what-youll-need)
- [Quick start](#quick-start-development-image)
- [How it runs](#runtime--scripts)
- [Settings](#environment--serverproperties)
- [Things to know](#notes--troubleshooting)
- [Important files](#files-of-interest)

## What you'll need

- Docker (and docker-compose)
- The official Minecraft server JAR file - you need to put this at `minecraft-container/src/server/server.jar` yourself
- You need to accept the Minecraft EULA by editing `eula.txt` and setting `eula=true`

## Quick start (development image)

1. Copy the environment file template:

   ```
   cp .env.demo .env
   ```

   Then edit the `.env` file to set your RAM limits, CPU limits, and any server properties you want.

2. Get the Minecraft server file:

   - Download the official Minecraft server JAR
   - Put it at: `minecraft-container/src/server/server.jar`
   - There's a demo file there that shows you what to do

3. Accept the EULA:

   - Edit `eula.txt` and set `eula=true`
   - There's an example in `eula.txt.demo`

4. Build and run:
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

- This repo doesn't include the actual Minecraft server.jar - you have to add that yourself
- Make sure you have the `.env` file (copy from `.env.demo`)
- Don't forget to accept the EULA in `eula.txt`
- A couple of script limitations:
  - The delete script might have issues with filenames that have spaces
  - The property script might not handle really large environment values well

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

**Helper files:**

- `build.sh`
- `version`
- `.env.demo`
- `eula.txt.demo`
- `minecraft-container/src/server/server.jar.demo`
