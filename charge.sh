#!/system/bin/sh
# fast charge by Sani
# starzs3cret.github.com
# made for xperia xz3
# test by your self

BAT_LEVEL_THRESHOLD=80

clear
echo "====!====!====!====!====!====!===="
echo "+        Fast Charge 18W         +"
echo "+            by Sani             +"
echo "=================================="
echo "."
echo "."

echo "[+] Note : "
echo "     Use CTRL+C to stop script,"
echo "     Then re-plug charger."
echo "     Auto stop at $BAT_LEVEL_THRESHOLD %"
echo "."
echo "."

echo -n "[+] Preparation..."
chmod 777 /sys/class/power_supply/*/*

# copy this /sys/class/power_supply/



MAX_MA=3600000
DEFAULT_MA=`cat /sys/class/power_supply/main/current_max`
INCASE_MA=2450000
DISCHARGING='Discharging'






echo '150' > /sys/class/power_supply/bms/temp_cool
echo '600' > /sys/class/power_supply/bms/temp_hot
echo '500' > /sys/class/power_supply/bms/temp_warm

charge_by(){
    echo $1 > /sys/class/power_supply/main/current_max
    echo $1 > /sys/class/power_supply/usb/current_max
    echo $1 > /sys/class/power_supply/main/constant_charge_current_max
    echo $1 > /sys/class/power_supply/battery/constant_charge_current_max
    echo $1 > /sys/class/power_supply/battery/max_charge_current
}

function slow_charge {
    charge_by $DEFAULT_MA
}

function normal_charge {
    charge_by $MAX_MA
    sleep 0.2
}

function unplugged (){
    charge_by $INCASE_MA 
}

N=4
sleep 1
echo "    Done."
sleep 1
echo "[+] Running..."
while :
do
STATUS=`cat /sys/class/power_supply/battery/status`
BAT_LEVEL_NOW=`cat /sys/class/power_supply/bms/capacity`
if [[ $STATUS == $DISCHARGING ]];then
    echo "."
    echo " Charger is unpluged."
    echo "[+] Exit."
    unplugged
    break
elif [[ $BAT_LEVEL_NOW -ge $BAT_LEVEL_THRESHOLD ]]; then
    echo "."
    echo " FastCharging Done."
    echo "[+] Exit."
    slow_charge
    break
else 
    if [[ $((N % 4)) -eq 0 ]] ;then
        echo -en "\r\033[K[/] FastCharging from $BAT_LEVEL_NOW to $BAT_LEVEL_THRESHOLD"
    elif [[ $((N % 4)) -eq 1 ]] ;then
        echo -en "\r\033[K[-] FastCharging from $BAT_LEVEL_NOW to $BAT_LEVEL_THRESHOLD"
    elif [[ $((N % 4)) -eq 2 ]] ;then
        echo -en "\r\033[K[\] FastCharging from $BAT_LEVEL_NOW to $BAT_LEVEL_THRESHOLD"
    elif [[ $((N % 4)) -eq 3 ]] ;then
        echo -en "\r\033[K[|] FastCharging from $BAT_LEVEL_NOW to $BAT_LEVEL_THRESHOLD"
    fi
    normal_charge
fi
N=$((N+1))
done


