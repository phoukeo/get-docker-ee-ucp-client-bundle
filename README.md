# get-docker-ee-ucp-client-bundle

## Introduction

The `get-docker-ee-ucp-client-bundle.sh` bash script generates and downloads a Docker EE UCP Client Bundle.

For more information on the Docker EE UCP Client Bundle refer to <https://docs.docker.com/ee/ucp/user-access/cli/>.

## Setup

1. The `get-docker-ee-ucp-client-bundle.sh` bash script requires the **curl** and **jq** commands.

    To install **curl** and **jq** if they are not currently installed:

    - Ubuntu

      ```bash
      sudo apt-get update -qq
      sudo apt-get install curl jq -y
      ```

    - RHEL/CentOS

      ```bash
      sudo yum makecache fast
      sudo yum install curl jq -y
      ```

    - MacOS

      If you are running MacOS you can install **curl** and **jq** with Homebrew <https://brew.sh/>.
      ```bash
      brew install curl jq
      ```

2. Export your Docker EE UCP user account and password as environment variables.

      Example:

      ```bash
      export DOCKER_USER="**your-docker-ee-ucp-user-account**"
      export DOCKER_PASSWORD="**your-docker-ee-ucp-password**"
      ```

## Syntax

### Command Help

```bash
./get-docker-ee-ucp-client-bundle.sh -h
```

```bash
Usage: get-docker-ee-ucp-client-bundle.sh -d docker-ee-ucp-manager-host
 -d is the Docker EE UCP Manager Host (hostname or IP address) and must be specified.
 -h displays this command help.
```

### Example to Generate and download a Docker EE UCP Client Bundle:

```bash
./get-docker-ee-ucp-client-bundle.sh -d 172.16.129.75
```

```bash
Archive:  bundle.zip
 extracting: ca.pem
 extracting: cert.pem
 extracting: key.pem
 extracting: cert.pub
 extracting: env.sh
 extracting: env.ps1
 extracting: env.cmd
 extracting: kube.yml
Run the following command to configure your shell for Docker EE commands:
eval "$(<env.sh)"
```

### Configure your shell for Docker EE commands

```bash
eval "$(<env.sh)"
```

```bash
Cluster "ucp_172.16.129.75:6443_gforghetti" set.
User "ucp_172.16.129.75:6443_gforghetti" set.
Context "ucp_172.16.129.75:6443_gforghetti" modified.
```

### Verify the configuration

```bash
$ docker version
Client: Docker Enterprise Edition (EE) 2.0
 Version:      17.06.2-ee-16
 API version:  1.30
 Go version:   go1.8.7
 Git commit:   9ef4f0a
 Built:        Thu Jul 26 16:41:28 2018
 OS/Arch:      linux/amd64

Server: Docker Enterprise Edition (EE) 2.0
 Engine:
  Version:      17.06.2-ee-16
  API version:  1.30 (minimum version 1.12)
  Go version:   go1.8.7
  Git commit:   9ef4f0a
  Built:        Thu Jul 26 16:40:18 2018
  OS/Arch:      linux/amd64
  Experimental: false
 Universal Control Plane:
  Version:       3.0.4
  ApiVersion:                   1.30
  Arch:                         amd64
  BuildTime:                    Thu Aug  9 15:03:19 UTC 2018
  GitCommit:                    0493274
  GoVersion:                    go1.9.4
  MinApiVersion:                1.20
  Os:                           linux
 Kubernetes:
  Version:      1.8+
  buildDate:                   2018-04-26T16:51:21Z
  compiler:                    gc
  gitCommit:                   8d637aedf46b9c21dde723e29c645b9f27106fa5
  gitTreeState:                clean
  gitVersion:                  v1.8.11-docker-8d637ae
  goVersion:                   go1.8.3
  major:                       1
  minor:                       8+
  platform:                    linux/amd64
 Calico:
  Version:          v3.0.8
  cni:                             v2.0.6
  kube-controllers:                v2.0.5
  node:                            v3.0.8
```

```bash
kubectl get namespaces
```

```bash
NAME          STATUS    AGE
default       Active    2d
kube-public   Active    2d
kube-system   Active    2d
```