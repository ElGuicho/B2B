arch=$(uname -a)
cores=$(lscpu | awk '$1=="Core(s)"{print $4}')
sock=$(lscpu | awk '$1=="Socket(s):"{print $2}')
pCPU=$(expr $cores \* $sock)
vCPU=$(nproc)
Mem=$(free --mega | awk '/Mem:/ {printf "%s/%sMB (%.2f%%)", $3, $2, $3/$2*100}')
Disk=$(df -m | grep "/dev/mapper" | awk '{used+=$3;} {total+=$2;} END{printf "%s/%sMB (%.2f%%)", used, total, used/total*100;}')
CPU_use=$(top -bn2 | grep "%Cpu(s):" | tail -1 | awk '{printf "%.1f%%", 100-$8}')
lstboot=$(who -b | awk '{print $3" "$4}')
lvm=$(lsblk | grep "lvm" | grep "root" | awk '{ if ($6=="lvm") {print "yes"} else {print "no"}}')
TCP=$(ss -s | awk '/TCP:/{print $4}' | awk -F "," '{print $1" ESTABLISHED"}')
user_nb=$(getent passwd | wc -l)
mac=$(ip a | awk '$1=="link/ether" {print $2}')
ipv4=$(hostname -I)
ntwrk=$(printf "IP %s (%s)" "$ipv4" "$mac")
sudo=$(journalctl | grep "sudo" | wc -l)
sudocmd=$(printf "%s cmd" "$sudo")

wall -n "       #Architecture   :       $arch
  #CPU physical :       $pCPU
  #vCPU         :       $vCPU
  #Memory Usage :       $Mem
  #Disk Usage   :       $Disk
  #CPU load     :       $CPU_use
  #Last boot    :       $lstboot
  #LVM use      :       $lvm
  #TCP Connections:     $TCP
  #User log     :       $user_nb
  #Network      :       $ntwrk
  #Sudo         :       $sudocmd"
