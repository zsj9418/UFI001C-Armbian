#!/bin/bash

secho(){
  echo `date`"$1" >> /root/gpiofan.log
}
#删除日志
rm -r /root/gpiofan.log

secho "初始化引脚"
echo timer > /sys/class/leds/green\:internet/trigger 
secho "初始化参数"
echo 0 > /sys/class/leds/green:internet/delay_on
echo 1000 > /sys/class/leds/green:internet/delay_off
# 定义档位速度
pwm_v=(300 500 700 900)


wenkon()
{
  echo $[1000 - $1] > /sys/class/leds/green\:internet/delay_off
  echo $1 > /sys/class/leds/green\:internet/delay_on 
}
#日志大于10M删除
clog()
{
  FILE_PATH=/root/gpiofan.log
  if [ -f "$FILE_PATH" ]; then
      FILE_SIZE=`stat -c "%s" "$FILE_PATH"`
  else
      arg1=1
  fi
  if [ "$FILE_SIZE" -gt 10485760 ]; then
      rm -rf "$FILE_PATH"
  else
      arg1=0
  fi
}
sead="0"
while true
do
  # 获取温度
  temp=$[$(< /sys/class/thermal/thermal_zone0/temp) / 1000]
  # 进行温度判断和控制风扇档位
  if [ "$temp" -lt 25 ]; then
      if [ "$sead" != "0" ]; then
          secho "温度在(0,25)区间内,关闭风扇"
          sead="0"
          wenkon 0
      fi
  elif [ "$temp" -ge 25 ] && [ "$temp" -lt 35 ]; then
      if [ "$sead" != "1" ]; then
          secho "温度在[25,35)区间内,开启第一档"
          sead="1"
          wenkon "${pwm_v[0]}"
      fi
  elif [ "$temp" -ge 35 ] && [ "$temp" -lt 45 ]; then
      if [ "$sead" != "2" ]; then
          secho "温度在[35,45)区间内,开启第二档"
          sead="2"
          wenkon "${pwm_v[1]}"
      fi
  elif [ "$temp" -ge 45 ] && [ "$temp" -lt 55 ]; then
      if [ "$sead" != "3" ]; then
      secho "温度在[45,55)区间内,开启第三档"
      sead="3"
      wenkon "${pwm_v[2]}"
      fi
  elif [ "$temp" -ge 55 ] && [ "$temp" -lt 65 ]; then
      if [ "$sead" != "4" ]; then
          secho "温度在[55,65)区间内,开启第四档"
          sead="4"
          wenkon "${pwm_v[3]}"
      fi
  elif [ "$temp" -ge 65 ]; then
      if [ "$sead" != "5" ]; then
          secho "温度大于 65 摄氏度,开启最大功率"
          sead="5"
          wenkon 1000
      fi
  fi
    sleep 0.5
    clog
done

