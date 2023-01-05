#!/bin/bash
# factorio开服脚本
# @author fsongs

dirname="$HOME/factorio"
bin="$dirname/bin/x64/factorio"

# 获取源
function install() {
  # 下载最新稳定版
  echo -e "\e[92m 即将下载安装包... \e[0m"
  wget -O factorio.tar.xz https://factorio.com/get-download/stable/headless/linux64
  # 解压
  echo -e "\e[92m 即将安装... \e[0m"
  tar -xvf factorio.tar.xz
  # 删除安装包
  # rm -f factorio.tar.xz
  if [ -f "$bin" ]; then
    echo '下载成功'
  else
    echo "失败"
  fi

  main
}

# 启动服务器
function run() {
  tmp=$(ps -ef | grep $bin | grep -v grep | awk '{print $2}')
  if [ "$tmp" ]; then
    echo "服务器已启动, 即将返回主菜单.."
    main
  else
    echo '请输入要开启的存档名：'
    read save

    $(nohup $bin --port 34197 --start-server $dirname/saves/$save.zip --server-settings $dirname/data/server-settings.json >$dirname/factorio.log 2>&1 &)

    echo "服务器启动成功!!"
  fi
}

# 关闭服务器
function close() {
  # 获取进程名为factorio的进程号
  tmp=$(ps -ef | grep $bin | grep -v grep | awk '{print $2}')
  if [ "$tmp" ]; then
    echo "是否关闭factorio进程(y/n), 进程号: $tmp"
    read isClose
    if [ "$isClose"x = "y"x ]; then
      kill $tmp
      echo "服务器关闭成功"
    fi
  else
    echo "没有运行中的服务器"
  fi
  main
}

# 查看日志
function log() {
  echo '默认展示最新20条日志:'
  tail -fn20 $dirname/factorio.log
}

# 主菜单
function main() {
  echo "===================================================================="
  while :; do
    echo "[1]更新服务器               [2]启动服务器        [3]关闭服务器"
    echo "[4]查看日志                 [5]退出脚本"
    echo "===================================================================="
    echo -e "\e[92m请输入命令代号: \e[0m"
    # 输入对应数字执行函数
    read flag
    case $flag in
    1)
      install
      break
      ;;
    2)
      run
      break
      ;;
    3)
      close
      break
      ;;
    4)
      log
      break
      ;;
    5)
      echo '感谢使用 @author fsongs'
      exit
      ;;
    esac
  done
}

# 主程序入口
echo -e '\033[31m factorio开服脚本 @author fsongs \033[0m'
main
