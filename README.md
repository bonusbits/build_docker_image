# Build Docker Image with Args from YAML
[![CircleCI](https://circleci.com/gh/bonusbits/build_docker_image.svg?style=shield)](https://circleci.com/gh/bonusbits/build_docker_image)
[![Join the chat at https://gitter.im/bonusbits](https://badges.gitter.im/bonusbits/bonusbits.svg)](https://gitter.im/bonusbits?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

## Purpose
A Ruby script to build a Docker image from Dockerfile with arguments saved in a YAML file.

## Usage
### Create Folder Structure
The folder structure is an easy way to keep the configs organized.
```yaml
region:
  client:
    awsaccount:
      environment:
        project.yml
```

##### Example
```mkdir -p $HOME/.bdi/us-west-2/client1/awsaccount1/dev```

### Create Settings YAML
Add as many or little arguments to pass in a YAMl file. The key value pair will be passed to the build command.

```yaml
sudo_user: docker
data_bag_item: project01_dev
stack_name: account01-dev-ecs-web
logs_group_name: account01-dev-ecs-web
efs_filesystem_id: fs-00000000
version_major: 1
version_minor: 28
x_forwarded_traffic: false
rewrite_wiki_alias: false
dns_configure: true
hosted_zone_id: IA3E9KCU3YU2Q5
record_name: ecs-web.account01-dev-us-west-2.com
data_bag_secret: "v32U1Q6Up+WypN5M7B9pxpxOOXh4KRn6j/39Wr1aH2ynzbvnqAkf5q6mR2EFAN1nBLESbO4TnNkxDrUNH8MpgqnPfgbc2N8wxofiNcQzrFzdZT+3xF8PT4ldHyTjwBUNUQuceOYsAxnqRpNJKuVw0o5nS6uhA+o+JRLhYG3wiUF84GZ/aO++/lpNuh8dmLrGewP2vk6qnepwl77OLtWgsqMVFmWxxR2NK0UkDXoK9eAUT7GqyZCUltyjiI/EXR5IdLQZQNnSrY55dulkRvljqDqV+PSx1FPDm9CUvuepG9e08PdLghMQC2q5QsG/gRj/yznevyUBsrpemyHOda0H3VQj8MaN2yrDhrTYTbo/i1f9AMUv5k1KMbSy6OTbUCOTRK3yyJ1ZDf9ZLHR+5HXDqH47jr7JiZNDGQB39l9IyuZV+4a7KXYk2XafM/d4fuFEkBdXke8D+sAiRCrQ/pdh2wlaxtGl4APLIlZ2mR3vOjGUR55leGn/DGdZvsLV83jGhHqlblV2qE6yyXIgyHpDrvaIRp/h9LuPcJgVUmP5sT8/EPo5EAyE9r/mV+SSE8fTTlEVBtxcUMuVha8zIUBjhsfHKtUopPcHR36/qncCLxs="
ssh_key: "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCzmTVSVKeyWO7mLH5nN/O9APz++KyeSULtnzxdVzRI01asZWAN3JjktLiCBlbpFTmPA0XoQNo3s85BVXeAoZz1OcMFKl6lXc8UI2L9RsChTZEkMe/yPC31VUQfZq1tpMowuFpwTjEqhIEErOt4nl+xDTd3/N51/giIGHEKUZkAhln5+CFHhoNON+7pbw6ZCuQrBX5soKfCm111OKvdzn2o0gwMim5UJlDipqc7+9fJSlho6c9bhyBxYYtmvakb2Vl3SS4bq3peU5Y92Ll2i9b1e+9R1UxEi85kMTiO5U5M+VEk7LpeU2LYi5NUnOeELr8qtP5Yh1MgOcre7lxW9Bl1 user@localhost.local"
```


```
Usage: bdi.rb -c examples/chef.yml [OPTIONS]

Options:
    -c, --config FULLNAME            (Required) Full Path to YAML Account Config
    -d, --dockerfile-path            (Optional) Path to Dockerfile. Default is Current working Directory.
    -b, --build-path                 (Optional) Path to Dockerfile. Default is Current working Directory.
    -t, --tags                       (Optional) No Space Comma Separated Image Tags. Default is None.
    -h, --help                       (Flag) Show this message
    -v, --version                    (Flag) Output Script Version
```

## Examples
* ```./bdi.rb -c webapp.yml```
* ```./bdi.rb -c webapp.yml -d /path/to/Dockefile -p /path/to/build/from```
* ```./bdi.rb -c webapp.yml -e '-q --compress' -d /path/to/Dockefile -p /path/to/build/from```

### Symlink
To make it quick to call from bash_profile etc. you can create a symlink to the ruby script.
```bash
 if [ ! -h "/usr/local/bin/bdi" ]; then
   ln -s "/path/to/clone/build_docker_image/bdi.rb" /usr/local/bin/bdi
 fi
```
