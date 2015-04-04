#!/bin/bash
# vim:set et ts=2 sw=2:

# Author : djluo
# version: 4.0(20150107)

# chkconfig: 3 90 19
# description:
# processname: yys-sh global admin container

[ -r "/etc/baoyu/functions"  ] && source "/etc/baoyu/functions" && _current_dir
[ -f "${current_dir}/docker" ] && source "${current_dir}/docker"

# ex: ...../dir1/dir2/run.sh
# container_name is "dir1-dir2"
_container_name ${current_dir}

images="docker.xlands-inc.com/desktop/kuaipan"
#images="kuaipan4uk"
#default_port="172.17.42.1:3306:3306"

action="$1"    # start or stop ...
_get_uid "$2"  # uid=xxxx ,default is "1000"
shift $flag_shift
unset  flag_shift

# 转换需映射的端口号
app_port="$@"  # hostPort
app_port=${app_port:=${default_port}}
_port

_run() {
  local mode="-d --entrypoint=/entrypoint.pl " # --restart="
  local name="$container_name"
  local cmd="/usr/bin/kuaipan4uk"

  [ "x$1" == "xdebug" ] && _run_debug

    #-e "LANG=zh_CN.utf8"     \
    #-e "LC_ALL=zh_CN.utf8"   \
  sudo docker run $mode $port \
    -w "/home/docker/kuaipan" \
    -e "TZ=Asia/Shanghai"     \
    -e HOME="/home/docker"    \
    -e DISPLAY=unix$DISPLAY   \
    -e XMODIFIERS=$XMODIFIERS \
    -e QT_IM_MODULE=$QT_IM_MODULE    \
    -e QT4_IM_MODULE=$QT4_IM_MODULE  \
    -e GTK_IM_MODULE=$GTK_IM_MODULE  \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v ${HOME}/kuaipan/:/home/docker/kuaipan/ \
    -v ${HOME}/.config/ubuntukylin/:/home/docker/.config/ubuntukylin/ \
    -v ${current_dir}/entrypoint.pl:/entrypoint.pl \
    -h "djluo-hp"     \
    --dns="223.5.5.5" \
    --dns="223.6.6.6" \
    --name ${name} ${images} \
    $cmd
}
###############
_call_action $action
