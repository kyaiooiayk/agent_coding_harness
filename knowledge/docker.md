---
type: Reference
title: How Docker Containers Work: Internal Architecture and Runtime Explained
description: Docker containers solve the problem:
tags: [reference, docker]
timestamp: 2026-07-12T00:00:00Z
---

# How Docker Containers Work: Internal Architecture and Runtime Explained

## Overview

Docker containers solve the problem:

> "It works on my machine, but not in production."

Traditional application deployment often fails because environments differ:

- Different operating system versions
- Different runtime versions
- Missing dependencies
- Different libraries
- Different configurations

Virtual machines solved this by packaging an entire operating system with the application.

However, virtual machines have drawbacks:

- Each VM requires its own kernel
- High memory usage
- Slow startup time
- More operational complexity

Containers provide a lighter alternative.

A container packages:

- Application code
- Runtime dependencies
- Libraries
- Configuration

while sharing the host operating system kernel.

Containers are not complete virtual machines. They are isolated Linux processes using kernel-level isolation features.

---

# Core Idea

Docker is not the container itself.

Docker is a toolchain that makes Linux container technology easy to use.

Underneath Docker are Linux kernel features:

- Namespaces → isolation
- cgroups → resource limits
- OverlayFS → layered filesystems

Docker combines these primitives into a developer-friendly workflow:

- Build images
- Store images
- Run containers
- Manage networking
- Manage storage

---

# Docker Architecture

Docker is a stack of components.

The execution path looks like:

```

Docker CLI
|
v
Docker Daemon (dockerd)
|
v
containerd
|
v
containerd-shim
|
v
runc
|
v
Linux Kernel

````

Each layer has a specific responsibility.

---

# Docker CLI

## Responsibility

The Docker CLI is the user interface.

Examples:

```bash
docker run nginx

docker build .

docker pull redis
````

The CLI does not actually:

* Start containers
* Download images
* Create namespaces
* Configure networking

Instead, it converts commands into API requests.

Communication happens through:

```
/var/run/docker.sock
```

The CLI communicates with the Docker daemon.

The CLI and daemon can run on different machines because Docker exposes an API.

---

# Docker Daemon (dockerd)

## Responsibility

`dockerd` is the Docker management layer.

It manages:

* Images
* Containers
* Networks
* Volumes
* Docker API requests

Example:

When running:

```bash
docker run nginx
```

The daemon receives the request.

However:

`dockerd` does not directly create Linux processes.

It delegates container execution to lower-level runtimes.

---

# containerd

## Responsibility

containerd manages container lifecycle operations.

Responsibilities:

* Pull images
* Store images
* Extract filesystem layers
* Manage container lifecycle

Docker delegates runtime operations to containerd.

containerd communicates using gRPC APIs.

Kubernetes commonly uses containerd directly instead of Docker.

---

# containerd-shim

## Purpose

containerd-shim sits between containerd and the running container.

Architecture:

```
containerd
    |
    |
containerd-shim
    |
    |
container process
```

Responsibilities:

* Keep containers running
* Maintain stdin/stdout connections
* Report container exit status

Why is shim needed?

If containerd crashes:

* Containers should continue running
* Runtime management should be separated from container processes

The shim provides this separation.

---

# runc

## Responsibility

`runc` is the low-level container runtime.

It directly interacts with the Linux kernel.

runc:

1. Reads container configuration
2. Creates namespaces
3. Creates cgroups
4. Sets up filesystem
5. Starts the container process

After starting the process:

* runc exits
* containerd-shim keeps monitoring

At this point:

A Docker container becomes an ordinary Linux process with isolation.

---

# OCI Standards

Docker containers follow OCI standards.

OCI defines:

* Container image format
* Container runtime specification

Benefits:

* Docker images can run on different runtimes
* Kubernetes can use different container engines
* Tools remain compatible

Examples:

* Docker
* containerd
* CRI-O
* Podman

can work together because of OCI standards.

---

# Containers Are Built From Linux Kernel Features

Docker itself does not create isolation.

Linux provides the mechanisms.

The two most important concepts are:

1. Namespaces
2. Control Groups (cgroups)

---

# Linux Namespaces

## Purpose

Namespaces isolate system resources.

A process inside a namespace sees its own isolated version of:

* Processes
* Network
* Filesystem
* Users
* Hostname

The process believes it has its own machine.

The host still manages the real resources.

---

# PID Namespace

## Purpose

Isolates processes.

Normally:

```
Host:

PID 1
PID 2
PID 3
PID 1000
```

Inside a container:

```
Container:

PID 1
PID 2
PID 3
```

The container sees only its own processes.

The host sees the real process IDs.

Example:

Inside container:

```
ps aux
```

shows only container processes.

The host can see everything.

---

# Network Namespace

## Purpose

Provides isolated networking.

Each container gets:

* Own network interface
* Own IP address
* Own routing table
* Own ports

Example:

Container A:

```
localhost:80
```

Container B:

```
localhost:80
```

Both can use port 80 because they have different network namespaces.

Docker connects containers using virtual ethernet interfaces.

---

# Mount Namespace

## Purpose

Provides an isolated filesystem view.

Without mount namespaces:

All processes see the same filesystem.

With mount namespaces:

Each container gets:

* Own root filesystem
* Own libraries
* Own binaries
* Own application files

Containers cannot normally see host files.

---

# UTS Namespace

## Purpose

Controls:

* Hostname
* Domain name

Example:

Host:

```
server-production
```

Container:

```
nginx-container
```

The container sees its own hostname.

---

# IPC Namespace

## Purpose

Controls inter-process communication.

Isolation applies to:

* Shared memory
* Message queues
* Semaphores

A container cannot access another container's IPC resources.

---

# User Namespace

## Purpose

Maps users inside containers to users on the host.

Important security feature.

Example:

Inside container:

```
root
```

Host:

```
unprivileged-user
```

The container thinks it has root access.

The host limits actual privileges.

Benefits:

* Safer containers
* Rootless containers
* Smaller attack surface

---

# Control Groups (cgroups)

## Purpose

Namespaces control visibility.

cgroups control resource usage.

They limit:

* CPU
* Memory
* Disk I/O
* Network bandwidth

Example:

Container A:

```
Memory limit: 512MB
CPU limit: 1 core
```

Container B:

```
Memory limit: 4GB
CPU limit: 4 cores
```

Both run on the same machine.

---

# Container Images

## Image Definition

A Docker image is a read-only template used to create containers.

Example:

```
Python image
+
Application code
+
Dependencies
=
Docker image
```

A container is a running instance of an image.

Relationship:

```
Image
 |
 |
 v

Container
```

---

# Image Layers

Docker images use layered filesystems.

Example:

```
Application Layer
-----------------
Dependencies Layer
-----------------
Python Layer
-----------------
Ubuntu Layer
```

Each layer is immutable.

Benefits:

* Faster builds
* Image reuse
* Efficient storage

---

# OverlayFS

Docker commonly uses OverlayFS.

It combines:

```
Read-only image layers
+
Writable container layer
```

When a container starts:

* Image layers remain unchanged
* New writes go into writable layer

Example:

Image:

```
/app/config.json
```

Container changes:

```
/app/config.json
```

The original image is unchanged.

---

# Docker Run Flow

When executing:

```bash
docker run nginx
```

The flow is:

## Step 1

Docker CLI sends request.

```
CLI
 |
 v
dockerd
```

---

## Step 2

Docker daemon asks containerd.

```
dockerd
 |
 v
containerd
```

---

## Step 3

containerd prepares:

* Image
* Filesystem
* Runtime configuration

---

## Step 4

containerd starts shim.

```
containerd
 |
 v
shim
```

---

## Step 5

shim calls runc.

```
shim
 |
 v
runc
```

---

## Step 6

runc creates:

* Namespaces
* cgroups
* Filesystem mounts

---

## Step 7

Linux kernel starts the application process.

The container is now running.

---

# Container Networking

Docker networking uses:

* Network namespaces
* Virtual ethernet pairs
* Bridges
* Routing rules

Basic flow:

```
Container

network namespace

        |
        |
virtual ethernet

        |
        |
Docker bridge

        |
        |
Host network
```

This allows:

* Container-to-container communication
* Container-to-host communication
* External access

---

# Container Storage

Containers are ephemeral.

If a container is deleted:

```
Container filesystem
=
deleted
```

Persistent data requires:

* Volumes
* Bind mounts

Example:

Database container:

```
PostgreSQL container

        |
        |
Docker volume

        |
        |
Persistent disk
```

---

# Docker vs Virtual Machines

| Feature        | Docker Container   | Virtual Machine         |
| -------------- | ------------------ | ----------------------- |
| Kernel         | Shared host kernel | Own kernel              |
| Startup        | Seconds            | Minutes                 |
| Size           | MBs                | GBs                     |
| Isolation      | Process isolation  | Hardware virtualization |
| Resource usage | Low                | Higher                  |

---

# Mental Model

A Docker container is:

```
A normal Linux process
+
isolated using namespaces
+
restricted using cgroups
+
running on layered filesystem
+
managed through Docker tooling
```

Docker is not magic.

It is a developer-friendly interface around existing Linux kernel capabilities.

---

# Key Concepts Summary

| Concept    | Purpose                        |
| ---------- | ------------------------------ |
| Docker CLI | User interface                 |
| dockerd    | Docker API and management      |
| containerd | Container lifecycle management |
| runc       | Creates containers             |
| OCI        | Container standards            |
| Namespace  | Isolation                      |
| cgroups    | Resource limits                |
| OverlayFS  | Layered filesystem             |
| Image      | Container template             |
| Container  | Running image instance         |
| Volume     | Persistent storage             |

---

# Final Understanding

When you run a Docker container:

1. Docker receives your command.
2. Docker finds or downloads an image.
3. The runtime prepares the filesystem.
4. Linux namespaces isolate the process.
5. cgroups control resources.
6. runc starts the application.
7. The container runs as an isolated Linux process.

Containers are lightweight because they do not virtualize hardware or an entire operating system.

They simply make Linux processes believe they have their own private environment.

```

This format should work well as an **agent knowledge source** because it preserves:
- concepts
- definitions
- component relationships
- execution flow
- terminology mappings
- technical hierarchy


## References
- https://newsletter.systemdesign.one/p/how-do-docker-containers-work
***