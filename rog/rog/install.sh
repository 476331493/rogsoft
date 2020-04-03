#! /bin/sh
source /koolshare/scripts/base.sh
alias echo_date='echo 【$(TZ=UTC-8 date -R +%Y年%m月%d日\ %X)】:'
DIR=$(cd $(dirname $0); pwd)
odmpid=$(nvram get odmpid)

# 判断路由架构和平台
case $(uname -m) in
	aarch64)
		if [ "$(uname -o|grep Merlin)" ] && [ -d "/koolshare" ];then
			echo_date 固件平台【koolshare merlin hnd/axhnd aarch64】符合安装要求，开始安装插件！
		else
			echo_date 本插件适用于【koolshare merlin hnd/axhnd aarch64】固件平台，你的固件平台不能安装！！！
			echo_date 退出安装！
			rm -rf /tmp/rog* >/dev/null 2>&1
			exit 1
		fi
		;;
	armv7l)
		if [ "$(nvram get productid)" == "TUF-AX3000" ] && [ -d "/koolshare" ];then
			echo_date 固件TUF-AX3000 koolshare官改固件符合安装要求，开始安装插件！
		else
			echo_date 本插件适用于【koolshare merlin hnd/axhnd aarch64】固件平台，你的固件平台不能安装！！！
			echo_date 退出安装！
			rm -rf /tmp/rog* >/dev/null 2>&1
			exit 1
		fi
		;;
	*)
		echo_date 本插件适用于【koolshare merlin hnd/axhnd aarch64】固件平台，你的平台：$(uname -m)不能安装！！！
		echo_date 退出安装！
		rm -rf /tmp/rog* >/dev/null 2>&1
		exit 1
	;;
esac

if [ "$(nvram get model)" == "GT-AC5300" ] || [ "$(nvram get model)" == "GT-AX11000" ] || [ -n "$(nvram get extendno | grep koolshare)" -a "$(nvram get productid)" == "RT-AC86U" ];then
	ROG=1
fi

if [ "$(nvram get productid)" == "TUF-AX3000" ];then
	TUF=1
fi

# 安装插件
cp -rf /tmp/rog/scripts/* /koolshare/scripts/
cp -rf /tmp/rog/webs/* /koolshare/webs/
cp -rf /tmp/rog/res/* /koolshare/res/
if [ -n "$odmpid" -a "$odmpid" == "RAX80" ];then
	cp -rf /tmp/rog/init.d/* /koolshare/init.d/
fi
cp -rf /tmp/rog/uninstall.sh /koolshare/scripts/uninstall_rog.sh
if [ "$ROG" == "1" ];then
	cp -rf /tmp/$MODULE/ROG/webs/* /koolshare/webs/
fi
if [ "$TUF" == "1" ];then
	# rog ui to tuf ui
	find /tmp/$MODULE/ROG -name "*.css" | xargs sed -i 's/91071f/92650F/g'
	find /tmp/$MODULE/ROG -name "*.css" | xargs sed -i 's/680516/D0982C/g'
	find /tmp/$MODULE/ROG -name "*.asp" | xargs sed -i 's/91071f/92650F/g'
	find /tmp/$MODULE/ROG -name "*.asp" | xargs sed -i 's/680516/D0982C/g'
	cp -rf /tmp/$MODULE/ROG/webs/* /koolshare/webs/
fi
chmod +x /koolshare/scripts/rog*
chmod +x /koolshare/scripts/uninstall_rog.sh

# 离线安装用
dbus set rog_version="$(cat $DIR/version)"
dbus set softcenter_module_rog_version="$(cat $DIR/version)"
dbus set softcenter_module_rog_description="一些小功能的插件"
dbus set softcenter_module_rog_install="1"
dbus set softcenter_module_rog_name="rog"
dbus set softcenter_module_rog_title="ROG工具箱"

# 完成
echo_date "rog工具箱插件安装完毕！"
rm -rf /tmp/rog* >/dev/null 2>&1
exit 0
