# msm8916-armbian
MSM8916设备的Armbian镜像，支持UFI001B/C, UFI003等型号。

## 本地构建
1. 克隆本仓库
2. 执行download脚本
3. 以root权限运行armbian-rebuild脚本
4. 选择构建型号
5. 构建完成后会在源码目录得到rootfs.img

6. fan 手动风扇 默认绿色 
7. gpiofan 自动散热 默认绿色
8. 关闭自动散热 systemctl start gpiofan

蓝色 ： /sys/class/leds/blue:wifi/trigger
绿色 ： /sys/class/leds/green:internet/trigger
红色 ： /sys/class/leds/red:os/trigger

<img width="290" alt="fan" src="https://github.com/YANXIAOXIH/msm8916-armbian/assets/77421578/12e1544c-1f8a-4718-a5a5-5f26c0451d55">

<img width="336" alt="fan" src="https://github.com/YANXIAOXIH/UFI001C-Armbian/assets/77421578/b26c7572-c872-41e2-a2df-7bdf31134293">
