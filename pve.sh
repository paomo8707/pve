#!/bin/bash 
####

# PVE语言设置
pvelocale(){
	sed -i 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && locale-gen && TIME g "PVE语言包设置完成!"
}
if [ `export|grep 'LC_ALL'|wc -l` = 0 ];then
	pvelocale
	if [ `grep "LC_ALL" /etc/profile|wc -l` = 0 ];then
		echo "export LC_ALL='en_US.UTF-8'" >> /etc/profile
		echo "export LANG='en_US.UTF-8'" >> /etc/profile
	fi
fi
if [ `grep "alias ll" /etc/profile|wc -l` = 0 ];then
	echo "alias ll='ls -alh'" >> /etc/profile
	echo "alias sn='snapraid'" >> /etc/profile
fi
source /etc/profile
# pause
pause(){
    read -n 1 -p " 按任意键继续... " input
    if [[ -n ${input} ]]; then
        echo -e "\b\n"
    fi
}

# 字体颜色设置
TIME() {
[[ -z "$1" ]] && {
	echo -ne " "
} || {
	 case $1 in
	r) export Color="\e[31;1m";;
	g) export Color="\e[32;1m";;
	b) export Color="\e[34;1m";;
	y) export Color="\e[33;1m";;
	z) export Color="\e[35;1m";;
	l) export Color="\e[36;1m";;
	  esac
	[[ $# -lt 2 ]] && echo -e "\e[36m\e[0m ${1}" || {
		echo -e "\e[36m\e[0m ${Color}${2}\e[0m"
	 }
	  }
}


#--------------PVE更换软件源----------------
# apt国内源
aptsources() {
	sver=`cat /etc/debian_version |awk -F"." '{print $1}'`
	case "$sver" in
 	12 )
  		sver="bookworm"
 	;;
	11 )
		sver="bullseye"
	;;
	10 )
		sver="buster"
	;;
	9 )
		sver="stretch"
	;;
	8 )
		sver="jessie"
	;;
	7 )
		sver="wheezy"
	;;
	6 )
		sver="squeeze"
	;;
	* )
		sver=""
	;;
	esac
	if [ ! $sver ];then
		TIME r "您的版本不支持！"
		exit 1
	fi
	cp -rf /etc/apt/sources.list /etc/apt/backup/sources.list.bak
	echo " 请选择您需要的apt国内源"
	echo " 1. 清华大学镜像站"
	echo " 2. 中科大镜像站"
	echo " 3. 上海交大镜像站"
	echo " 4. 阿里云镜像站"
	echo " 5. 腾讯云镜像站"
	echo " 6. 网易镜像站"
	echo " 7. 华为镜像站"
	input="请输入选择[默认1]"
	while :; do
	read -t 30 -p " ${input}： " aptsource || echo
	aptsource=${aptsource:-1}
	case $aptsource in
	1)
	cat > /etc/apt/sources.list <<-EOF
		deb https://mirrors.tuna.tsinghua.edu.cn/debian/ ${sver} main contrib non-free
		deb-src https://mirrors.tuna.tsinghua.edu.cn/debian/ ${sver} main contrib non-free
		deb https://mirrors.tuna.tsinghua.edu.cn/debian/ ${sver}-updates main contrib non-free
		deb-src https://mirrors.tuna.tsinghua.edu.cn/debian/ ${sver}-updates main contrib non-free
		deb https://mirrors.tuna.tsinghua.edu.cn/debian/ ${sver}-backports main contrib non-free
		deb-src https://mirrors.tuna.tsinghua.edu.cn/debian/ ${sver}-backports main contrib non-free
		deb https://mirrors.tuna.tsinghua.edu.cn/debian-security ${sver}-security main contrib non-free
		deb-src https://mirrors.tuna.tsinghua.edu.cn/debian-security ${sver}-security main contrib non-free
	EOF
	break
	;;
	2)
	cat > /etc/apt/sources.list <<-EOF
		deb https://mirrors.ustc.edu.cn/debian/ ${sver} main contrib non-free
		deb-src https://mirrors.ustc.edu.cn/debian/ ${sver} main contrib non-free
		deb https://mirrors.ustc.edu.cn/debian/ ${sver}-updates main contrib non-free
		deb-src https://mirrors.ustc.edu.cn/debian/ ${sver}-updates main contrib non-free
		deb https://mirrors.ustc.edu.cn/debian/ ${sver}-backports main contrib non-free
		deb-src https://mirrors.ustc.edu.cn/debian/ ${sver}-backports main contrib non-free
		deb https://mirrors.ustc.edu.cn/debian-security/ ${sver}-security main contrib non-free
		deb-src https://mirrors.ustc.edu.cn/debian-security/ ${sver}-security main contrib non-free
	EOF
	break
	;;  
	3)
	cat > /etc/apt/sources.list <<-EOF
		deb https://mirror.sjtu.edu.cn/debian/ ${sver} main non-free contrib
		deb-src https://mirror.sjtu.edu.cn/debian/ ${sver} main non-free contrib
		deb https://mirror.sjtu.edu.cn/debian/ ${sver}-security main
		deb-src https://mirror.sjtu.edu.cn/debian/ ${sver}-security main
		deb https://mirror.sjtu.edu.cn/debian/ ${sver}-updates main non-free contrib
		deb-src https://mirror.sjtu.edu.cn/debian/ ${sver}-updates main non-free contrib
		deb https://mirror.sjtu.edu.cn/debian/ ${sver}-backports main non-free contrib
		deb-src https://mirror.sjtu.edu.cn/debian/ ${sver}-backports main non-free contrib
	EOF
	break
	;;
	4)
	cat > /etc/apt/sources.list <<-EOF
		deb http://mirrors.aliyun.com/debian/ ${sver} main non-free contrib
		deb-src http://mirrors.aliyun.com/debian/ ${sver} main non-free contrib
		deb http://mirrors.aliyun.com/debian-security/ ${sver}-security main
		deb-src http://mirrors.aliyun.com/debian-security/ ${sver}-security main
		deb http://mirrors.aliyun.com/debian/ ${sver}-updates main non-free contrib
		deb-src http://mirrors.aliyun.com/debian/ ${sver}-updates main non-free contrib
		deb http://mirrors.aliyun.com/debian/ ${sver}-backports main non-free contrib
		deb-src http://mirrors.aliyun.com/debian/ ${sver}-backports main non-free contrib
	EOF
	break
	;;
	5)
	cat > /etc/apt/sources.list <<-EOF
		deb https://mirrors.tencent.com/debian/ ${sver} main non-free contrib
		deb-src https://mirrors.tencent.com/debian/ ${sver} main non-free contrib
		deb https://mirrors.tencent.com/debian-security/ ${sver}-security main
		deb-src https://mirrors.tencent.com/debian-security/ ${sver}-security main
		deb https://mirrors.tencent.com/debian/ ${sver}-updates main non-free contrib
		deb-src https://mirrors.tencent.com/debian/ ${sver}-updates main non-free contrib
		deb https://mirrors.tencent.com/debian/ ${sver}-backports main non-free contrib
		deb-src https://mirrors.tencent.com/debian/ ${sver}-backports main non-free contrib
	EOF
	break
	;;
	6)
	cat > /etc/apt/sources.list <<-EOF
		deb https://mirrors.163.com/debian/ ${sver} main non-free contrib
		deb-src https://mirrors.163.com/debian/ ${sver} main non-free contrib
		deb https://mirrors.163.com/debian-security/ ${sver}-security main
		deb-src https://mirrors.163.com/debian-security/ ${sver}-security main
		deb https://mirrors.163.com/debian/ ${sver}-updates main non-free contrib
		deb-src https://mirrors.163.com/debian/ ${sver}-updates main non-free contrib
		deb https://mirrors.163.com/debian/ ${sver}-backports main non-free contrib
		deb-src https://mirrors.163.com/debian/ ${sver}-backports main non-free contrib
	EOF
	break
	;;
	7)
	cat > /etc/apt/sources.list <<-EOF
		deb https://mirrors.huaweicloud.com/debian/ ${sver} main non-free contrib
		deb-src https://mirrors.huaweicloud.com/debian/ ${sver} main non-free contrib
		deb https://mirrors.huaweicloud.com/debian-security/ ${sver}-security main
		deb-src https://mirrors.huaweicloud.com/debian-security/ ${sver}-security main
		deb https://mirrors.huaweicloud.com/debian/ ${sver}-updates main non-free contrib
		deb-src https://mirrors.huaweicloud.com/debian/ ${sver}-updates main non-free contrib
		deb https://mirrors.huaweicloud.com/debian/ ${sver}-backports main non-free contrib
		deb-src https://mirrors.huaweicloud.com/debian/ ${sver}-backports main non-free contrib
	EOF
	break
	;;
	*)
	TIME r "请输入正确编码！"
	;;
	esac
	done
	TIME g "apt源，更换完成!"
}
# CT模板国内源
ctsources() {
	cp -rf /usr/share/perl5/PVE/APLInfo.pm /usr/share/perl5/PVE/APLInfo.pm.bak
	echo " 请选择您需要的CT模板国内源"
	echo " 1. 清华大学镜像站"
	echo " 2. 中科大镜像站"
	input="请输入选择[默认1]"
	while :; do
	read -t 30 -p " ${input}： " ctsource || echo
	ctsource=${ctsource:-1}
	case $ctsource in
	1)
	sed -i 's|http://download.proxmox.com|https://mirrors.tuna.tsinghua.edu.cn/proxmox|g' /usr/share/perl5/PVE/APLInfo.pm
	sed -i 's|http://mirrors.ustc.edu.cn/proxmox|https://mirrors.tuna.tsinghua.edu.cn/proxmox|g' /usr/share/perl5/PVE/APLInfo.pm
	break
	;;
	2)
	sed -i 's|http://download.proxmox.com|http://mirrors.ustc.edu.cn/proxmox|g' /usr/share/perl5/PVE/APLInfo.pm
	sed -i 's|https://mirrors.tuna.tsinghua.edu.cn/proxmox|http://mirrors.ustc.edu.cn/proxmox|g' /usr/share/perl5/PVE/APLInfo.pm
	break
	;;
	*)
	TIME r "请输入正确编码！"
	;;
	esac
	done
	TIME g "CT模板源，更换完成!"
}
# 更换使用帮助源
pvehelp(){
	cp -rf /etc/apt/sources.list.d/pve-no-subscription.list /etc/apt/backup/pve-no-subscription.list.bak
	cat > /etc/apt/sources.list.d/pve-no-subscription.list <<-EOF
deb https://mirrors.tuna.tsinghua.edu.cn/proxmox/debian ${sver} pve-no-subscription
EOF
	TIME g "使用帮助源，更换完成!"
}
# 关闭企业源
pveenterprise(){
	if [[ -f /etc/apt/sources.list.d/pve-enterprise.list ]];then
		cp -rf /etc/apt/sources.list.d/pve-enterprise.list /etc/apt/backup/pve-enterprise.list.bak
		rm -rf /etc/apt/sources.list.d/pve-enterprise.list
		TIME g "CT模板源，更换完成!"
	else
		TIME g "pve-enterprise.list不存在，忽略!"
	fi
}
# 移除无效订阅
novalidsub(){
	# 移除 Proxmox VE 无有效订阅提示 (6.4-5、6、8、9 、13；7.0-9、10、11已测试通过)
	cp -rf /usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.js /usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.js.bak
	sed -Ezi.bak "s/(Ext.Msg.show\(\{\s+title: gettext\('No valid sub)/void\(\{ \/\/\1/g" /usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.js
	# sed -i 's#if (res === null || res === undefined || !res || res#if (false) {#g' /usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.js
	# sed -i '/data.status.toLowerCase/d' /usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.js
	TIME g "已移除订阅提示!"
}
pvegpg(){
	cp -rf /etc/apt/trusted.gpg.d/proxmox-release-${sver}.gpg /etc/apt/backup/proxmox-release-${sver}.gpg.bak
	rm -rf /etc/apt/trusted.gpg.d/proxmox-release-${sver}.gpg
	wget -q --timeout=5 --tries=1 --show-progres http://mirrors.ustc.edu.cn/proxmox/debian/proxmox-release-${sver}.gpg -O /etc/apt/trusted.gpg.d/proxmox-release-${sver}.gpg
	if [[ $? -ne 0 ]];then
		TIME r "尝试重新下载..."
		wget -q --timeout=5 --tries=1 --show-progres http://mirrors.ustc.edu.cn/proxmox/debian/proxmox-release-${sver}.gpg -O /etc/apt/trusted.gpg.d/proxmox-release-${sver}.gpg
			if [[ $? -ne 0 ]];then
				TIME r "下载秘钥失败，请检查网络再尝试!"
				sleep 2
				exit 1
		else
			TIME g "密匙下载完成!"
			fi
	else
		TIME g "密匙下载完成!"	
	fi
}
pve_optimization(){
	echo
	clear
	TIME y "提示：PVE原配置文件放入/etc/apt/backup文件夹"
	[[ ! -d /etc/apt/backup ]] && mkdir -p /etc/apt/backup
	echo
	TIME y "※※※※※ 更换apt源... ※※※※※"
	aptsources
	echo
	TIME y "※※※※※ 更换CT模板源... ※※※※※"
	ctsources
	echo
	TIME y "※※※※※ 更换使用帮助源... ※※※※※"
	pvehelp
	echo
	TIME y "※※※※※ 关闭企业源... ※※※※※"
	pveenterprise
	echo
	TIME y "※※※※※ 移除 Proxmox VE 无有效订阅提示... ※※※※※"
	novalidsub
	echo
	TIME y "※※※※※ 下载PVE7.0源的密匙... ※※※※※"
	pvegpg
	echo
	TIME y "※※※※※ 重新加载服务配置文件、重启web控制台... ※※※※※"
	systemctl daemon-reload && systemctl restart pveproxy.service && TIME g "服务重启完成!"
	sleep 3
	echo
	TIME y "※※※※※ 更新源、安装常用软件和升级... ※※※※※"
	# apt-get update && apt-get install -y net-tools curl git
	# apt-get dist-upgrade -y
	TIME y "如需对PVE进行升级，请使用apt-get update -y && apt-get upgrade -y && apt-get dist-upgrade -y"
	echo
	TIME g "修改完毕！"
}
#--------------PVE更换软件源----------------


#--------------开启硬件直通----------------
# 开启硬件直通
enable_pass(){
	echo
	TIME y "开启硬件直通..."
	if [ `dmesg | grep -e DMAR -e IOMMU|wc -l` = 0 ];then
		TIME r "您的硬件不支持直通！"
		pause
		menu
	fi
	if [ `cat /proc/cpuinfo|grep Intel|wc -l` = 0 ];then
		iommu="amd_iommu=on"
	else
		iommu="intel_iommu=on"
	fi
	if [ `grep $iommu /etc/default/grub|wc -l` = 0 ];then
		sed -i 's|quiet|quiet '$iommu'|' /etc/default/grub
		update-grub
		if [ `grep "vfio" /etc/modules|wc -l` = 0 ];then
			cat <<-EOF >> /etc/modules
				vfio
				vfio_iommu_type1
				vfio_pci
				vfio_virqfd
				kvmgt
			EOF
		fi
		
	if [ ! -f "/etc/modprobe.d/blacklist.conf" ];then
       echo "blacklist snd_hda_intel" >> /etc/modprobe.d/blacklist.conf 
       echo "blacklist snd_hda_codec_hdmi" >> /etc/modprobe.d/blacklist.conf 
       echo "blacklist i915" >> /etc/modprobe.d/blacklist.conf 
       fi


    if [ ! -f "/etc/modprobe.d/vfio.conf" ];then
      echo "options vfio-pci ids=8086:3185" >> /etc/modprobe.d/vfio.conf
       fi	
		TIME g "开启设置后需要重启系统，请稍后重启。"
	else
		TIME r "您已经配置过!"
	   fi

}
# 关闭硬件直通
disable_pass(){
	echo
	TIME y "关闭硬件直通..."
	if [ `dmesg | grep -e DMAR -e IOMMU|wc -l` = 0 ];then
		TIME r "您的硬件不支持直通！"
		pause
		menu
	fi
	if [ `cat /proc/cpuinfo|grep Intel|wc -l` = 0 ];then
		iommu="amd_iommu=on"
	else
		iommu="intel_iommu=on"
	fi
	if [ `grep $iommu /etc/default/grub|wc -l` = 0 ];then
		TIME r "您还没有配置过该项"
	else
		{
			sed -i 's/ '$iommu'//g' /etc/default/grub
			sed -i '/vfio/d' /etc/modules
			rm -rf /etc/modprobe.d/blacklist.conf
			rm -rf /etc/modprobe.d/vfio.conf
			sleep 1
		}|TIME g "关闭设置后需要重启系统，请稍后重启。"
		sleep 1
		update-grub
	fi
}
# 硬件直通菜单
hw_passth(){
	while :; do
		clear
		cat <<-EOF
`TIME y "	      配置硬件直通"`
┌──────────────────────────────────────────┐
    1. 开启硬件直通
    2. 关闭硬件直通
├──────────────────────────────────────────┤
    0. 返回
└──────────────────────────────────────────┘
EOF
		echo -ne " 请选择: [ ]\b\b"
		read -t 60 hwmenuid
		hwmenuid=${hwmenuid:-0}
		case "${hwmenuid}" in
		1)
			enable_pass
			pause
			hw_passth
			break
		;;
		2)
			disable_pass
			pause
			hw_passth
			break
		;;
		0)
			menu
			break
		;;
		*)
		;;
		esac
	done
}
#--------------开启硬件直通----------------


#--------------设置CPU电源模式----------------

# 设置CPU电源模式
cpupower(){
	governors=`cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_governors`
	while :; do
		clear
		cat <<-EOF
`TIME y "	      设置CPU电源模式"`
┌──────────────────────────────────────────┐

    1. 设置CPU模式 conservative  保守模式
    2. 设置CPU模式 ondemand       按需模式		[默认]
    3. 设置CPU模式 powersave      节能模式
    4. 设置CPU模式 performance   性能模式
    5. 设置CPU模式 schedutil      负载模式

    6. 恢复系统默认电源设置

├──────────────────────────────────────────┤
    0. 返回
└──────────────────────────────────────────┘
EOF
		echo
		echo "部分CPU仅支持 performance 和 powersave 模式，只能选择这两项"
		echo
		echo "你的CPU支持 ${governors} 等模式"
		echo
		echo
		echo
		echo -ne " 请选择: [ ]\b\b"
		read -t 60 cpupowerid
		cpupowerid=${cpupowerid:-2}
		case "${cpupowerid}" in
		1)
			GOVERNOR="conservative"
		;;
		2)
			GOVERNOR="ondemand"
		;;	
		3)
			GOVERNOR="powersave"
		;;
		4)
			GOVERNOR="performance"
		;;
		5)
			GOVERNOR="schedutil"
		;;
		6)
			cpupower_del
			break
		;;
		0)
			menu
			break
		;;
		*)
			echo "你的输入无效 ,请重新输入 !!!"
			pause
			cpupower
		;;
		esac
		if [[ ${GOVERNOR} != "" ]]; then
			if [[ -n `echo "${governors}" | grep -o "${GOVERNOR}"` ]]; then
				echo "您选择的CPU模式：${GOVERNOR}"
				echo
				cpupower_add
			else
				echo "您的CPU不支持该模式！"
				cpupower
			fi
		fi
	done
}

# 修改CPU模式
cpupower_add(){
	echo "${GOVERNOR}" | tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor >/dev/null
	echo "查看当前CPU模式"
	cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor

	echo "添加开机任务"
	NEW_CRONTAB_COMMAND="sleep 10 && echo "${GOVERNOR}" | tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor >/dev/null #CPU Power Mode"
	EXISTING_CRONTAB=$(crontab -l 2>/dev/null)
     if [[ -n "$EXISTING_CRONTAB" ]]; then
       TEMP_CRONTAB_FILE=$(mktemp)
       echo "$EXISTING_CRONTAB" | grep -v "@reboot sleep 10 && echo*" > "$TEMP_CRONTAB_FILE"
       crontab "$TEMP_CRONTAB_FILE"
       rm "$TEMP_CRONTAB_FILE"
     fi
	# 修改完成
    (crontab -l 2>/dev/null; echo "@reboot $NEW_CRONTAB_COMMAND") | crontab -
    echo -e "\n检查计划任务设置 (使用 'crontab -l' 命令来检查)"

    pause
}

# 恢复系统默认电源设置
cpupower_del(){
	# 恢复性模式
	echo "performance" | tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor >/dev/null
	# 删除计划任务
    EXISTING_CRONTAB=$(crontab -l 2>/dev/null)
    if [[ -n "$EXISTING_CRONTAB" ]]; then
      TEMP_CRONTAB_FILE=$(mktemp)
      echo "$EXISTING_CRONTAB" | grep -v "@reboot sleep 10 && echo*" > "$TEMP_CRONTAB_FILE"
      crontab "$TEMP_CRONTAB_FILE"
      rm "$TEMP_CRONTAB_FILE"
    fi

    echo "已恢复系统默认电源设置！"
}
#--------------设置CPU电源模式----------------


#--------------CPU、主板、硬盘温度显示----------------

# 安装工具
cpu_add(){

nodes="/usr/share/perl5/PVE/API2/Nodes.pm"
pvemanagerlib="/usr/share/pve-manager/js/pvemanagerlib.js"
proxmoxlib="/usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.js"

pvever=$(pveversion | awk -F"/" '{print $2}')
echo pve版本$pvever

# 判断是否已经执行过修改
[ ! -e $nodes.$pvever.bak ] || { echo 已经执行过修改，请勿重复执行; exit 1;}

# 输入需要安装的软件包
packages=(lm-sensors nvme-cli sysstat linux-cpupower)

# 查询软件包，判断是否安装
for package in "${packages[@]}"; do
    if ! dpkg -s "$package" &> /dev/null; then
        echo "$package 未安装，开始安装软件包"
        apt-get install "${packages[@]}" -y
        modprobe msr
        install=ok
        break
    fi
done

# 设置执行权限
chmod +s /usr/sbin/nvme && chmod +s /usr/sbin/hddtemp && chmod +s /usr/sbin/smartctl && chmod +s /usr/sbin/turbostat
modprobe msr

# 软件包安装完成
if [ "$install" == "ok" ]; then
    echo 软件包安装完成，检测硬件信息
sensors-detect --auto > /tmp/sensors
drivers=`sed -n '/Chip drivers/,/\#----cut here/p' /tmp/sensors|sed '/Chip /d'|sed '/cut/d'`
if [ `echo $drivers|wc -w` = 0 ];then
    echo 没有找到任何驱动，似乎你的系统不支持或驱动安装失败。
    pause
    menu
else
    for i in $drivers
    do
        modprobe $i
        if [ `grep $i /etc/modules|wc -l` = 0 ];then
            echo $i >> /etc/modules
        fi
    done
    sensors
    sleep 3
    echo 驱动信息配置成功。
fi
/etc/init.d/kmod start
rm /tmp/sensors
# 驱动信息配置完成
fi

echo 备份源文件
# 删除旧版本备份文件
rm -f  $nodes.*.bak
rm -f  $pvemanagerlib.*.bak
rm -f  $proxmoxlib.*.bak
# 备份当前版本文件
[ ! -e $nodes.$pvever.bak ] && cp $nodes $nodes.$pvever.bak
[ ! -e $pvemanagerlib.$pvever.bak ] && cp $pvemanagerlib $pvemanagerlib.$pvever.bak
[ ! -e $proxmoxlib.$pvever.bak ] && cp $proxmoxlib $proxmoxlib.$pvever.bak

# 生成系统变量
tmpf=tmpfile.temp
touch $tmpf
cat > $tmpf << 'EOF' 
	$res->{thermalstate} = `sensors`;
	$res->{cpusensors} = `cat /proc/cpuinfo | grep MHz && lscpu | grep MHz`;
	
	my $nvme0_temperatures = `smartctl -a /dev/nvme0|grep -E "Model Number|(?=Total|Namespace)[^:]+Capacity|Temperature:|Available Spare:|Percentage|Data Unit|Power Cycles|Power On Hours|Unsafe Shutdowns|Integrity Errors"`;
	my $nvme0_io = `iostat -d -x -k 1 1 | grep -E "^nvme0"`;
	$res->{nvme0_status} = $nvme0_temperatures . $nvme0_io;
	
	$res->{hdd_temperatures} = `smartctl -a /dev/sd?|grep -E "Device Model|Capacity|Power_On_Hours|Temperature"`;

	my $powermode = `cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor && turbostat -S -q -s PkgWatt -i 0.1 -n 1 -c package | grep -v PkgWatt`;
	$res->{cpupower} = $powermode;

EOF

###################  修改node.pm   ##########################
echo 修改node.pm：
echo 找到关键字 PVE::pvecfg::version_text 的行号并跳到下一行
# 显示匹配的行
ln=$(expr $(sed -n -e '/PVE::pvecfg::version_text/=' $nodes) + 1)
echo "匹配的行号：" $ln

echo 修改结果：
sed -i "${ln}r $tmpf" $nodes
# 显示修改结果
sed -n '/PVE::pvecfg::version_text/,+18p' $nodes
rm $tmpf



###################  修改pvemanagerlib.js   ##########################
tmpf=tmpfile.temp
touch $tmpf
cat > $tmpf << 'EOF'

	{
          itemId: 'CPUW',
          colspan: 2,
          printBar: false,
          title: gettext('CPU功耗'),
          textField: 'cpupower',
          renderer:function(value){
			  const w0 = value.split('\n')[0].split(' ')[0];
			  const w1 = value.split('\n')[1].split(' ')[0];
			  return `CPU电源模式: ${w0} | CPU功耗: ${w1} W `
            }
	},

	{
          itemId: 'MHz',
          colspan: 2,
          printBar: false,
          title: gettext('CPU频率'),
          textField: 'cpusensors',
          renderer:function(value){
			  const f0 = value.match(/cpu MHz.*?([\d]+)/)[1];
			  const f1 = value.match(/CPU min MHz.*?([\d]+)/)[1];
			  const f2 = value.match(/CPU max MHz.*?([\d]+)/)[1];
			  return `CPU实时: ${f0} MHz | 最小: ${f1} MHz | 最大: ${f2} MHz `
            }
	},
	
	{
          itemId: 'thermal',
          colspan: 2,
          printBar: false,
          title: gettext('CPU温度'),
          textField: 'thermalstate',
          renderer:function(value){
              // const p0 = value.match(/Package id 0.*?\+([\d\.]+)Â/)[1];  // CPU包温度
              const c0 = value.match(/Core 0.*?\+([\d\.]+)?/)[1];  // CPU核心1温度
              const c1 = value.match(/Core 1.*?\+([\d\.]+)?/)[1];  // CPU核心2温度
              const c2 = value.match(/Core 2.*?\+([\d\.]+)?/)[1];  // CPU核心3温度
              const c3 = value.match(/Core 3.*?\+([\d\.]+)?/)[1];  // CPU核心4温度
	      const c4 = value.match(/Core 4.*?\+([\d\.]+)?/)[1];  // CPU核心5温度
              const c5 = value.match(/Core 5.*?\+([\d\.]+)?/)[1];  // CPU核心6温度
              const b0 = value.match(/temp1.*?\+([\d\.]+)?/)[1];  // 主板温度
              return ` 核心1: ${c0} ℃ | 核心2: ${c1} ℃ | 核心3: ${c2} ℃ | 核心4: ${c3} ℃ | 核心5: ${c4} ℃ | 核心6: ${c5} ℃ || 主板: ${b0} ℃ `
            }
    },



	{
          itemId: 'HEXIN',
          colspan: 2,
          printBar: false,
          title: gettext('核心频率'),
          textField: 'cpusensors',
          renderer:function(value){
			  const e0 = value.split('\n')[0].split(' ')[2];
			  const e1 = value.split('\n')[1].split(' ')[2];
			  const e2 = value.split('\n')[2].split(' ')[2];
			  const e3 = value.split('\n')[3].split(' ')[2];
                          const e4 = value.split('\n')[4].split(' ')[2];
			  const e5 = value.split('\n')[5].split(' ')[2];
			  return `核心1: ${e0} MHz | 核心2: ${e1} MHz | 核心3: ${e2} MHz | 核心4: ${e3} MHz | 核心5: ${e4} MHz | 核心6: ${e5} MHz `
            }
	},


	
	/* 检测不到相关参数的可以注释掉---需要的注释本行即可
	// 风扇转速
	{
          itemId: 'RPM',
          colspan: 2,
          printBar: false,
          title: gettext('CPU风扇'),
          textField: 'thermalstate',
          renderer:function(value){
			  const fan1 = value.match(/fan1:.*?\ ([\d.]+) R/)[1];
			  const fan2 = value.match(/fan2:.*?\ ([\d.]+) R/)[1];
			  if (fan1 === "0") {
			    fan11 = "停转";
			  } else {
			    fan11 = fan1 + " RPM";
			  }
			  if (fan2 === "0") {
			    fan22 = "停转";
			  } else {
			    fan22 = fan2 + " RPM";
			  }
			  return `CPU风扇: ${fan11} | 系统风扇: ${fan22}`
            }
	},
	检测不到相关参数的可以注释掉---需要的注释本行即可  */

	// /* 检测不到相关参数的可以注释掉---需要的注释本行即可
	// NVME硬盘温度
	{
	    itemId: 'nvme0-status',
	    colspan: 2,
	    printBar: false,
	    title: gettext('NVME 硬盘'),
	    textField: 'nvme0_status',
	    renderer:function(value){
	        if (value.length > 0) {
	            value = value.replace(/Â/g, '');
	            let data = [];
	            let nvmes = value.matchAll(/(^(?:Model|Total|Temperature:|Available Spare:|Percentage|Data|Power|Unsafe|Integrity Errors|nvme)[\s\S]*)+/gm);
	            for (const nvme of nvmes) {
	                let nvmeNumber = 0;
	                data[nvmeNumber] = {
	                    Models: [],
	                    Integrity_Errors: [],
	                    Capacitys: [],
	                    Temperatures: [],
	                    Available_Spares: [],
	                    Useds: [],
	                    Reads: [],
	                    Writtens: [],
	                    Cycles: [],
	                    Hours: [],
	                    Shutdowns: [],
	                    States: [],
	                    r_kBs: [],
	                    r_awaits: [],
	                    w_kBs: [],
	                    w_awaits: [],
	                    utils: []
	                };

	                let Models = nvme[1].matchAll(/^Model Number: *([ \S]*)$/gm);
	                for (const Model of Models) {
	                    data[nvmeNumber]['Models'].push(Model[1]);
	                }

	                let Integrity_Errors = nvme[1].matchAll(/^Media and Data Integrity Errors: *([ \S]*)$/gm);
	                for (const Integrity_Error of Integrity_Errors) {
	                    data[nvmeNumber]['Integrity_Errors'].push(Integrity_Error[1]);
	                }

	                let Capacitys = nvme[1].matchAll(/^(?=Total|Namespace)[^:]+Capacity:[^\[]*\[([ \S]*)\]$/gm);
	                for (const Capacity of Capacitys) {
	                    data[nvmeNumber]['Capacitys'].push(Capacity[1]);
	                }

	                let Temperatures = nvme[1].matchAll(/^Temperature: *([\d]*)[ \S]*$/gm);
	                for (const Temperature of Temperatures) {
	                    data[nvmeNumber]['Temperatures'].push(Temperature[1]);
	                }

	                let Available_Spares = nvme[1].matchAll(/^Available Spare: *([\d]*%)[ \S]*$/gm);
	                for (const Available_Spare of Available_Spares) {
	                    data[nvmeNumber]['Available_Spares'].push(Available_Spare[1]);
	                }

	                let Useds = nvme[1].matchAll(/^Percentage Used: *([ \S]*)%$/gm);
	                for (const Used of Useds) {
	                    data[nvmeNumber]['Useds'].push(Used[1]);
	                }

	                let Reads = nvme[1].matchAll(/^Data Units Read:[^\[]*\[([ \S]*)\]$/gm);
	                for (const Read of Reads) {
	                    data[nvmeNumber]['Reads'].push(Read[1]);
	                }

	                let Writtens = nvme[1].matchAll(/^Data Units Written:[^\[]*\[([ \S]*)\]$/gm);
	                for (const Written of Writtens) {
	                    data[nvmeNumber]['Writtens'].push(Written[1]);
	                }

	                let Cycles = nvme[1].matchAll(/^Power Cycles: *([ \S]*)$/gm);
	                for (const Cycle of Cycles) {
	                    data[nvmeNumber]['Cycles'].push(Cycle[1]);
	                }

	                let Hours = nvme[1].matchAll(/^Power On Hours: *([ \S]*)$/gm);
	                for (const Hour of Hours) {
	                    data[nvmeNumber]['Hours'].push(Hour[1]);
	                }

	                let Shutdowns = nvme[1].matchAll(/^Unsafe Shutdowns: *([ \S]*)$/gm);
	                for (const Shutdown of Shutdowns) {
	                    data[nvmeNumber]['Shutdowns'].push(Shutdown[1]);
	                }

	                let States = nvme[1].matchAll(/^nvme\S+(( *\d+\.\d{2}){22})/gm);
	                for (const State of States) {
	                    data[nvmeNumber]['States'].push(State[1]);
	                    const IO_array = [...State[1].matchAll(/\d+\.\d{2}/g)];
	                    if (IO_array.length > 0) {
	                        data[nvmeNumber]['r_kBs'].push(IO_array[1]);
	                        data[nvmeNumber]['r_awaits'].push(IO_array[4]);
	                        data[nvmeNumber]['w_kBs'].push(IO_array[7]);
	                        data[nvmeNumber]['w_awaits'].push(IO_array[10]);
	                        data[nvmeNumber]['utils'].push(IO_array[21]);
	                    }
	                }

	                let output = '';
	                for (const [i, nvme] of data.entries()) {
	                    if (nvme.Models.length > 0) {
	                        for (const nvmeModel of nvme.Models) {
	                            output += `${nvmeModel}`;
	                        }
	                    }

	                    if (nvme.Integrity_Errors.length > 0) {
	                        for (const nvmeIntegrity_Error of nvme.Integrity_Errors) {
	                            if (nvmeIntegrity_Error != 0) {
	                                output += ` (`;
	                                output += `0E: ${nvmeIntegrity_Error}-故障！`;
	                                if (nvme.Available_Spares.length > 0) {
	                                    output += ', ';
	                                    for (const Available_Spare of nvme.Available_Spares) {
	                                        output += `备用空间: ${Available_Spare}`;
	                                    }
	                                }
	                                output += `)`;
	                            }
	                        }
	                    }

	                    if (nvme.Capacitys.length > 0) {
	                        output += ' | ';
	                        for (const nvmeCapacity of nvme.Capacitys) {
	                            output += `容量: ${nvmeCapacity.replace(/ |,/gm, '')}`;
	                        }
	                    }

	                    if (nvme.Useds.length > 0) {
	                        output += ' | ';
	                        for (const nvmeUsed of nvme.Useds) {
	                            output += `寿命: ${100-Number(nvmeUsed)}% `;
	                            if (nvme.Reads.length > 0) {
	                                output += '(';
	                                for (const nvmeRead of nvme.Reads) {
	                                    output += `已读${nvmeRead.replace(/ |,/gm, '')}`;
	                                    output += ')';
	                                }
	                            }

	                            if (nvme.Writtens.length > 0) {
	                                output = output.slice(0, -1);
	                                output += ', ';
	                                for (const nvmeWritten of nvme.Writtens) {
	                                    output += `已写${nvmeWritten.replace(/ |,/gm, '')}`;
	                                }
	                                output += ')';
	                            }
	                        }
	                    }

	                    if (nvme.Temperatures.length > 0) {
	                        output += ' | ';
	                        for (const nvmeTemperature of nvme.Temperatures) {
	                            output += `温度: ${nvmeTemperature}°C`;
	                        }
	                    }

	                    if (nvme.States.length > 0) {
	                        if (nvme.Models.length > 0) {
	                            output += '\n';
	                        }

	                        output += 'I/O: ';
	                        if (nvme.r_kBs.length > 0 || nvme.r_awaits.length > 0) {
	                            output += '读-';
	                            if (nvme.r_kBs.length > 0) {
	                                for (const nvme_r_kB of nvme.r_kBs) {
	                                    var nvme_r_mB = `${nvme_r_kB}` / 1024;
	                                    nvme_r_mB = nvme_r_mB.toFixed(2);
	                                    output += `速度${nvme_r_mB}MB/s`;
	                                }
	                            }
	                            if (nvme.r_awaits.length > 0) {
	                                for (const nvme_r_await of nvme.r_awaits) {
	                                    output += `, 延迟${nvme_r_await}ms / `;
	                                }
	                            }
	                        }

	                        if (nvme.w_kBs.length > 0 || nvme.w_awaits.length > 0) {
	                            output += '写-';
	                            if (nvme.w_kBs.length > 0) {
	                                for (const nvme_w_kB of nvme.w_kBs) {
	                                    var nvme_w_mB = `${nvme_w_kB}` / 1024;
	                                    nvme_w_mB = nvme_w_mB.toFixed(2);
	                                    output += `速度${nvme_w_mB}MB/s`;
	                                }
	                            }
	                            if (nvme.w_awaits.length > 0) {
	                                for (const nvme_w_await of nvme.w_awaits) {
	                                    output += `, 延迟${nvme_w_await}ms | `;
	                                }
	                            }
	                        }

	                        if (nvme.utils.length > 0) {
	                            for (const nvme_util of nvme.utils) {
	                                output += `负载${nvme_util}%`;
	                            }
	                        }
	                    }

                        if (nvme.Cycles.length > 0) {
                            output += '\n';
                            for (const nvmeCycle of nvme.Cycles) {
                                output += `通电: ${nvmeCycle.replace(/ |,/gm, '')}次`;
                            }

                            if (nvme.Shutdowns.length > 0) {
                                output += ', ';
                                for (const nvmeShutdown of nvme.Shutdowns) {
                                    output += `不安全断电${nvmeShutdown.replace(/ |,/gm, '')}次`;
                                    break
                                }
                            }

                            if (nvme.Hours.length > 0) {
                                output += ', ';
                                for (const nvmeHour of nvme.Hours) {
                                    output += `累计${nvmeHour.replace(/ |,/gm, '')}小时`;
                                }
                            }
                        }
	                    //output = output.slice(0, -3);
	                }
	                return output.replace(/\n/g, '<br>');
	            }
	        } else {
	            return `提示: 未安装 NVME 或已直通 NVME 控制器！`;
	        }
	    }
	},
	// 检测不到相关参数的可以注释掉---需要的注释本行即可  */

          // SATA硬盘温度
          {
          itemId: 'hdd-temperatures',
          colspan: 2,
          printBar: false,
          title: gettext('SATA硬盘'),
          textField: 'hdd_temperatures',
          renderer:function(value){
          if (value.length > 0) {
          let devices = value.matchAll(/(\s*Model.*:\s*[\s\S]*?\n){1,2}^User.*\[([\s\S]*?)\]\n^\s*9[\s\S]*?\-\s*([\d]+)[\s\S]*?(\n(^19[0,4][\s\S]*?$){1,2}|\s{0}$)/gm);
          for (const device of devices) {
          if(device[1].indexOf("Family") !== -1){
          devicemodel = device[1].replace(/.*Model Family:\s*([\s\S]*?)\n^Device Model:\s*([\s\S]*?)\n/m, '$1 - $2');
          } else {
          devicemodel = device[1].replace(/.*Model:\s*([\s\S]*?)\n/m, '$1');
          }
          device[2] = device[2].replace(/ |,/gm, '');
          if(value.indexOf("Min/Max") !== -1){
          let devicetemps = device[5].matchAll(/19[0,4][\s\S]*?\-\s*(\d+)(\s\(Min\/Max\s(\d+)\/(\d+)\)$|\s{0}$)/gm);
          for (const devicetemp of devicetemps) {
          value = `${devicemodel} | 容量: ${device[2]} | 已通电: ${device[3]}小时 | 温度: ${devicetemp[1]}°C\n`;
          }
          } else if (value.indexOf("Temperature") !== -1){
          let devicetemps = device[5].matchAll(/19[0,4][\s\S]*?\-\s*(\d+)/gm);
          for (const devicetemp of devicetemps) {
          value = `${devicemodel} | 容量: ${device[2]} | 已通电: ${device[3]}小时 | 温度: ${devicetemp[1]}°C\n`;
          }
          } else {
          value = `${devicemodel} | 容量: ${device[2]} | 已通电: ${device[3]}小时 | 提示: 未检测到温度传感器\n`;
          }
          }
          return value.replace(/\n/g, '<br>');
          } else { 
          return `提示: 未安装硬盘或已直通硬盘控制器`;
          }
          }
          },
EOF

echo 找到关键字pveversion的行号
# 显示匹配的行
ln=$(sed -n '/pveversion/,+10{/},/{=;q}}' $pvemanagerlib)
echo "匹配的行号pveversion：" $ln

echo 修改结果：
sed -i "${ln}r $tmpf" $pvemanagerlib
# 显示修改结果
# sed -n '/pveversion/,+30p' $pvemanagerlib
rm $tmpf


echo 修改页面高度
# 修改并显示修改结果,位置10288行,原始值400
# sed -i -r '/\[logView\]/,+5{/heigh/{s#[0-9]+#700#;}}' $pvemanagerlib
# sed -n '/\[logView\]/,+5{/heigh/{p}}' $pvemanagerlib
# 修改并显示修改结果,位置36495行,原始值300
sed -i -r '/widget\.pveNodeStatus/,+5{/height/{s#[0-9]+#480#}}' $pvemanagerlib
sed -n '/widget\.pveNodeStatus/,+5{/height/{p}}' $pvemanagerlib
## 两处 height 的值需按情况修改，每多一行数据增加 20

# 调整显示布局
ln=$(expr $(sed -n -e '/widget.pveDcGuests/=' $pvemanagerlib) + 10)
sed -i "${ln}a\		textAlign: 'right'," $pvemanagerlib
ln=$(expr $(sed -n -e '/widget.pveNodeStatus/=' $pvemanagerlib) + 10)
sed -i "${ln}a\		textAlign: 'right'," $pvemanagerlib

###################  修改proxmoxlib.js   ##########################


echo 修改去除订阅弹窗
sed -r -i '/\/nodes\/localhost\/subscription/,+10{/^\s+if \(res === null /{N;s#.+#\t\t  if(false){#}}' $proxmoxlib
# 显示修改结果
sed -n '/\/nodes\/localhost\/subscription/,+10p' $proxmoxlib

systemctl restart pveproxy

echo "请刷新浏览器缓存shift+f5"


}

# 删除工具
cpu_del(){

nodes="/usr/share/perl5/PVE/API2/Nodes.pm"
pvemanagerlib="/usr/share/pve-manager/js/pvemanagerlib.js"
proxmoxlib="/usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.js"

pvever=$(pveversion | awk -F"/" '{print $2}')
echo pve版本$pvever
if [ -f "$nodes.$pvever.bak" ];then
rm -f $nodes $pvemanagerlib $proxmoxlib
mv $nodes.$pvever.bak $nodes
mv $pvemanagerlib.$pvever.bak $pvemanagerlib
mv $proxmoxlib.$pvever.bak $proxmoxlib

echo "已删除温度显示，请重新刷新浏览器缓存."
else
echo "你没有添加过温度显示，退出脚本."
fi


}

#--------------CPU、主板、硬盘温度显示----------------



# 主菜单
menu(){
	cat <<-EOF

`TIME y "	      PVE优化脚本     "`
┌──────────────────────────────────────────┐
    1. 一键优化PVE(换源、去订阅等)
    2. 配置PCI硬件直通
    3. 设置CPU电源模式
    4. 添加CPU、主板、硬盘温度显示
    5. 删除CPU、主板、硬盘温度显示
├──────────────────────────────────────────┤
    0. 退出
└──────────────────────────────────────────┘

EOF
	echo -ne " 请选择: [ ]\b\b"
	read -t 60 menuid
	menuid=${menuid:-0}
	case ${menuid} in
	1)
		pve_optimization
		echo
		pause
		menu
	;;
	2)
		hw_passth
		echo
		pause
		menu
	;;
	3)
		cpupower
		echo
		pause
		menu
	;;
	4)
		cpu_add
		echo
		pause
		menu
	;;
	5)
		cpu_del
		echo
		pause
		menu
	;;
	0)
		clear
		exit 0
	;;
	*)
		echo "你的输入无效 ,请重新输入 !!!"
		pause
		menu
	;;
	esac
}
menu
