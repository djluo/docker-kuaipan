#!/bin/bash
# vim:set et ts=2 sw=2:

# Author : djluo
# version: 4.0(20150107)

# chkconfig: 3 90 19
# description:
# processname: yys-sh global admin container

process_name=$(basename $0)
if [ "x${process_name}" == "xkuaipan" ];then
  release_dir=`readlink -f $0`
  release_dir=`dirname $release_dir`
  current_dir="$release_dir"
  cd $release_dir
fi

[ -r "/etc/baoyu/functions"  ] && source "/etc/baoyu/functions" && _current_dir
[ "x$release_dir" != "x" ] && current_dir=$release_dir
[ -f "${current_dir}/docker" ] && source "${current_dir}/docker"

# ex: ...../dir1/dir2/run.sh
# container_name is "dir1-dir2"
#_container_name ${current_dir}
container_name="desktop-kuaipan"

images="docker.xlands-inc.com/desktop/kuaipan"

action="$1"    # start or stop ...

if [ "x${process_name}" == "xkuaipan" ];then
  _check_container
  cstatus=$?
  if [ $cstatus -eq 0 ];then
    action="status"
  else
    action="start"
  fi
  unset cstatus
fi

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
