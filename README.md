# NVIDIA DinD (Docker in Docker) Container

Based on https://github.com/cruizba/ubuntu-dind

Isolated DinD (Docker in Docker) container for developing and deploying docker containers using NVIDIA GPUs and the NVIDIA container toolkit. Useful for deploying the docker engine with NVIDIA in Kubernetes.

Host is required to have the NVIDIA container toolkit installed and set up. Privileged mode is required like any other DinD container with root requirement.

```
docker run --gpus 1 -it --privileged ehfd/nvidia-dind
```
