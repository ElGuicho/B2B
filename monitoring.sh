arch=$(uname -a)
cores=$(lscpu | awk '$1=="Core(s)"{print $4}')
sock=$(lscpu | awk '$1=="Socket(s):"{print $2}')
pCPU=$(expr $cores \* $sock)
vCPU=$(nproc)
Mem=$(free --mega | awk '/Mem/ {printf "%s/%sMB (%.2f%%)", $3, $2, $3/$2*100}')
Disk=$(df -m | grep "/dev/" | grep -v "boot" | awk '{used+=$3;} {total+=$2;} END{printf "%.s/%.sMB (%.2f%%)", used, total, used/total*100}')
CPU_use=$(top -bn2 | grep "%Cpu(s):" | tail -1 | awk '{printf "%.1f%%", 100-$8}')
lstboot=$(who -b | awk '/system/ {print $3" "$4}')
lvm=$(if [ $(lsblk | grep "lvm" | wc -l) -gt 0 ]; then echo "yes"; else echo "no"; fi)
TCP=$(echo "$(ss -ta | grep "ESTAB" | wc -l) ESTABLISHED")
user_nb=$(users | wc -w)
mac=$(ip link | awk '$1=="link/ether" {print $2}')
ipv4=$(hostname -I)
ntwrk=$(printf "IP %s (%s)" "$ipv4" "$mac")
sudocmd=$(echo "$(journalctl _COMM=sudo | grep "COMMAND" | wc -l) cmd")

wall -n	"	#Architecture	:  $arch
	#CPU physical	:  $pCPU
	#vCPU			:  $vCPU
	#Memory Usage	:  $Mem
	#Disk Usage		:  $Disk
	#CPU load		:  $CPU_use
	#Last boot		:  $lstboot
	#LVM use		:  $lvm
	#TCP Connections:  $TCP
	#User log		:  $user_nb
	#Network		:  $ntwrk
	#Sudo			:  $sudocmd"
