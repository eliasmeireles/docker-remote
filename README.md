Here’s an improved version of your `README.md` with better clarity, structure, and grammar while preserving all key
information:

---

# Docker Remote Access with TLS Configuration

This guide explains how to configure a Docker server for secure remote access using TLS.

## 🔐 TLS Configuration Requirements

To make your Docker server remotely accessible with TLS, use the
**[automated setup script](https://github.com/eliasmeireles/docker-deployment/blob/main/docker-remote)**.

### Important Note: Common Name (CN) Consistency

During certificate generation, you’ll be prompted for the **Common Name (CN)** (e.g., `docker-server`).  
This **must match** the value of `DOCKER_REMOTE_HOSTNAME` (e.g., `DOCKER_REMOTE_HOSTNAME=docker-server`).

---

## 🛠️ Environment Variables

| Variable                 | Description                                | Example Value                                           |
|--------------------------|--------------------------------------------|---------------------------------------------------------|
| `DOCKER_TLS_VERIFY`      | Enable TLS verification (`1` for enabled). | `1`                                                     |
| `DOCKER_CERT_PATH`       | Path to TLS certificates.                  | `/etc/docker/certs.d`                                   |
| `DOCKER_REMOTE_HOSTNAME` | Hostname of the Docker server.             | `"docker-server"`                                       |
| `DOCKER_HOST`            | Docker server connection string.           | `"tcp://${DOCKER_REMOTE_HOSTNAME:-docker-server}:2376"` |

---

## 📜 Certificate Requirements

Ensure your Docker server is TLS-enabled with these certificates:

- `ca.pem`
- `cert.pem`
- `key.pem`
- `ca-key.pem`

Bind them to the container at runtime:

### Basic Setup

```sh
docker run --rm -it -d --name docker-remote \
    -e DOCKER_REMOTE_IP_ADDRESS=<SERVER_IP> \
    -v ./.out:/etc/docker/certs.d \
    -v ./tools:/tools \
    eliasmeireles/docker-remote:latest
docker exec -it docker-remote /bin/bash
```

### Custom Configuration (Override All Variables)

```sh
docker run --rm -it -d --name docker-remote \
    -e DOCKER_TLS_VERIFY=1 \
    -e DOCKER_REMOTE_HOSTNAME="custom-docker-server" \
    -e DOCKER_HOST="tcp://custom-docker-server:2376" \
    -v /custom/path/certs:/etc/docker/certs.d \
    -v ./tools:/tools \
    eliasmeireles/docker-remote:latest
docker exec -it docker-remote /bin/bash
```

---
