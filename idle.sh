#!/system/bin/sh
# fast charge by Sani
# starzs3cret.github.com
# made for xperia xz3
# test by your self

clear
echo "====!====!====!====!====!====!===="
echo "+     Idle Charge For Gaming     +"
echo "+            by Sani             +"
echo "=================================="
echo "."
echo "."

echo "[+] Note : "
echo "     Use CTRL+C to stop script,"
echo "     Then re-plug charger."
echo "."
echo "."

echo -n "[+] Preparation..."
chmod 777 /sys/class/power_supply/*/*

# copy this /sys/class/power_supply/


LOW_MA=500000
MAX_MA=3000000
DEFAULT_MA=`cat /sys/class/power_supply/main/current_max`
INCASE_MA=2450000
DISCHARGING='Discharging'


BAT_LEVEL_THRESHOLD=60



echo '150' > /sys/class/power_supply/bms/temp_cool
echo '450' > /sys/class/power_supply/bms/temp_hot
echo '450' > /sys/class/power_supply/bms/temp_warm

charge_by(){
    echo $MAX_MA > /sys/class/power_supply/main/current_max
    echo $MAX_MA > /sys/class/power_supply/usb/current_max
    echo $1 > /sys/class/power_supply/main/constant_charge_current_max
    echo $1 > /sys/class/power_supply/battery/constant_charge_current_max
    echo $1 > /sys/class/power_supply/battery/max_charge_current
}


function idle_charge {
    charge_by 0
    sleep 3
}

function normal_charge {
    charge_by $LOW_MA
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
    echo " Charger is unpluged."
    echo "[+] Exit."
    unplugged
    break
elif [[ $BAT_LEVEL_NOW -ge $BAT_LEVEL_THRESHOLD ]]; then
    if [[ $((N % 4)) -eq 0 ]];then
        echo -en "\r\033[K[/] Idle Charging"
    elif [[ $((N % 4)) -eq 1 ]] ;then
        echo -en "\r\033[K[-] Idle Charging."
    elif [[ $((N % 4)) -eq 2 ]] ;then
        echo -en "\r\033[K[\] Idle Charging.."
    elif [[ $((N % 4)) -eq 3 ]] ;then
        echo -en "\r\033[K[|] Idle Charging..."
    fi
    idle_charge
else 
    if [[ $((N % 4)) -eq 0 ]] ;then
        echo -en "\r\033[K[/] Charging from $BAT_LEVEL_NOW to $BAT_LEVEL_THRESHOLD"
    elif [[ $((N % 4)) -eq 1 ]] ;then
        echo -en "\r\033[K[-] Charging from $BAT_LEVEL_NOW to $BAT_LEVEL_THRESHOLD"
    elif [[ $((N % 4)) -eq 2 ]] ;then
        echo -en "\r\033[K[\] Charging from $BAT_LEVEL_NOW to $BAT_LEVEL_THRESHOLD"
    elif [[ $((N % 4)) -eq 3 ]] ;then
        echo -en "\r\033[K[|] Charging from $BAT_LEVEL_NOW to $BAT_LEVEL_THRESHOLD"
    fi
    normal_charge
fi
N=$((N+1))
done


