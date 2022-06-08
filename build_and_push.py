"""A script to build and push a docker image to a registry."""

import getpass
import os
import sys

DOCKER_REGISTRY = os.environ.get("DOCKER_REGISTRY", "docker.io")
DOCKER_USERNAME = os.environ.get("DOCKER_USERNAME", "ukalwa")
DOCKER_PASSWORD = os.environ.get("DOCKER_PASSWORD")
IS_CI = os.environ.get("CI", None) == "true"
PUSH = os.environ.get("PUSH", None) == "true"
DEBUG = os.environ.get("DEBUG", None) == "true"

# Build and push base images
base_images = ["alpine-base", "ubuntu-base"]

for image in base_images:
    print(f"Building {image}")
    command = [
        "docker",
        "build",
        "-t",
        f"{DOCKER_USERNAME}/{image}",
        "-f",
        f"{image}/Dockerfile",
        ".",
    ]
    exit_code = os.system(" ".join(command))
    if exit_code != 0:
        print(f"Error building {image}")
        sys.exit(1)
    if not PUSH:
        print(f"Skipping push for {image}")
        continue
    if not DOCKER_PASSWORD:
        if IS_CI:
            raise Exception("DOCKER_PASSWORD is not set")
        DOCKER_PASSWORD = getpass.getpass(prompt="Docker password: ")
    # Login to docker
    command = [
        "docker",
        "login",
        "-u",
        DOCKER_USERNAME,
        "-p",
        DOCKER_PASSWORD,
        DOCKER_REGISTRY,
    ]
    exit_code = os.system(" ".join(command))
    if exit_code != 0:
        print(f"Error logging in to {DOCKER_REGISTRY}")
        sys.exit(1)
    print(f"Pushing {image}")
    command = ["docker", "push", f"{DOCKER_USERNAME}/{image}"]
    exit_code = os.system(" ".join(command))
    if exit_code != 0:
        sys.exit(1)

# Build and push nodejs images
node_alpine_images = [
    "node:alpine-lts",
    "node:alpine-16.15.1",
    "node:alpine-14.19.3",
]

for image in node_alpine_images:
    name, alpine_tag = image.split(":")
    NODE_VERSION = alpine_tag.replace("alpine", "").replace("-", "")

    print(f"Building {image}")
    command = [
        "docker",
        "build",
        "-t",
        f"{DOCKER_USERNAME}/{image}",
        "-f",
        f"{name}/Dockerfile",
        "--build-arg",
        f"NODE_VERSION={'lts/*' if NODE_VERSION == 'lts' else NODE_VERSION}",
        ".",
    ]
    exit_code = os.system(" ".join(command))
    if exit_code != 0:
        print(f"Error building {image}")
        sys.exit(1)
    print(f"Building {name}:{NODE_VERSION}")
    command = [
        "docker",
        "build",
        "-t",
        f"{DOCKER_USERNAME}/{name}:{NODE_VERSION}",
        "-f",
        f"{name}/Dockerfile",
        "--build-arg",
        "IMAGE=ubuntu",
        "--build-arg",
        f"NODE_VERSION={'lts/*' if NODE_VERSION == 'lts' else NODE_VERSION}",
        ".",
    ]
    exit_code = os.system(" ".join(command))
    if exit_code != 0:
        print(f"Error building {name}:{NODE_VERSION}")
        sys.exit(1)
    if not PUSH:
        print(f"Skipping push for {image}")
        continue
    print(f"Pushing {image}")
    command = ["docker", "push", f"{DOCKER_USERNAME}/{image}"]
    exit_code = os.system(" ".join(command))
    if exit_code != 0:
        print(f"Error pushing {image}")
        sys.exit(1)
    if not PUSH:
        print(f"Skipping push for {image}")
        continue
    print(f"Pushing {name}:{NODE_VERSION}")
    command = ["docker", "push", f"{DOCKER_USERNAME}/{name}:{NODE_VERSION}"]
    exit_code = os.system(" ".join(command))
    if exit_code != 0:
        print(f"Error pushing {name}:{NODE_VERSION}")
        sys.exit(1)

# Build and push python images
python_images = [
    "python:alpine-3.10",
    "python:3.10",
    "python:alpine",
    "python:latest",
]

for image in python_images:
    name, version = image.split(":")
    print(f"Building {image}")
    command = [
        "docker",
        "build",
        "-t",
        f"{DOCKER_USERNAME}/{image}",
        "--build-arg",
        f"IMAGE={'alpine' if 'alpine' in version else 'ubuntu'}",
        "-f",
        f"{name}/Dockerfile",
        ".",
    ]
    exit_code = os.system(" ".join(command))
    if exit_code != 0:
        print(f"Error building {image}")
        sys.exit(1)
    if not PUSH:
        print(f"Skipping push for {image}")
        continue
    print(f"Pushing {image}")
    command = ["docker", "push", f"{DOCKER_USERNAME}/{image}"]
    exit_code = os.system(" ".join(command))
    if exit_code != 0:
        print(f"Error pushing {image}")
        sys.exit(1)
