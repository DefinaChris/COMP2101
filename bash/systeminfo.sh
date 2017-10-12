#!/bin/bash

# This is the bash assignment for the first half of the semester

# Here are my variables.
thisprogram="yes"

# This is my function for narrowing down the output field
# inspired heavily by your example
function writedis {
  echo "
Try one of these: $0 [-h  | --help]
                  $0 [-nm | --Host/domain name]
                  $0 [-os | --Operating System name]
                  $0 [-ov | --Operating System version]
                  $0 [-ip | --IP address]
                  $0 [-cp | --CPU info]
                  $0 [-rm | --RAM info]
                  $0 [-hd | --Available Disk Space]
                  $0 [-p  | --List of Installed Printers]
                  $0 [-sw | --List of User installed Software]
  "
}
function hellnah {
  echo "$@" >&2
}

# This case is where you can narrow the information field down
while [ $# -gt 0 ]; do
  case "$1" in
    -h|--help)
      writedis
      exit 0
      ;;
    -nm)
      namesandstuffyo="yes"
      thisprogram="no"
      ;;
    -os)
      osnameyo="yes"
      thisprogram="no"
      ;;
    -ov)
      osversionyo="yes"
      thisprogram="no"
      ;;
    -ip)
      ipaddyo="yes"
      thisprogram="no"
      ;;
    -cp)
      cpuyo="yes"
      thisprogram="no"
      ;;
    -rm)
      ramyo="yes"
      thisprogram="no"
      ;;
    -hd)
      harddriveyo="yes"
      thisprogram="no"
      ;;
    -p)
      printersyo="yes"
      thisprogram="no"
      ;;
    -sw)
      softwareyo="yes"
      thisprogram="no"
      ;;
    *)
      hellnah "
      Whoops! '$1' is not a valid entry. Try something else.
      "
      hellnah "$(writedis)
      "
      exit 1
      ;;
  esac
  shift
done

# These are my variable names that actually contain info
OSnameinfo="$(lsb_release -i)"
OSversioninfo="$(lsb_release -r)"
hnameinfo="$(hostname)"
dnameinfo="$(domainname)"
ipaddinfo="$(hostname -I)"
# takes only the model name information from cpuinfo
cpuinfo="$(cat /proc/cpuinfo | grep 'model name' | uniq)"
# Displays only the installed memory in megabytes
raminfo="$(free -m | awk '/^Mem:/{print $2}')"
# Displays only the available hard drive space in megabytes
harddriveinfo="$(df -m /tmp | tail -1 | awk '{print $4}')"
# shows a list of installed printers
printerinfo="$(lpstat -p | awk '{print $2}')"
# Alright, I can't take credit for the next command. Found it at
# SuperUser.com but it is amazing
softwareinfo="$(comm -13 \
  <(gzip -dc /var/log/installer/initial-status.gz | sed -n 's/^Package: //p' | sort) \
  <(comm -23 \
    <(dpkg-query -W -f='${Package}\n' | sed 1d | sort) \
    <(apt-mark showauto | sort) \
  ))"




# Graceful, human readable outputs
OSnameinfoforhumans="
Your Operating Systeam is:
     $OSnameinfo

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
"
OSversioninfoforhumans="
Your Operating System Version is:
     $OSversioninfo

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
"
ipaddinfoforhumans="
IP Information:
     IP: $ipaddinfo

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
"
namesandstuffinfoforhumans="
System Information:
     Hostname: $hnameinfo
     Domain name: $dnameinfo

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
"
harddriveinfoforhumans="
Available Disk Space:
     Disk Space (Mb): $harddriveinfo

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
"
raminfoforhumans="
This is how much RAM you got:
     Installed RAM (Mb): $raminfo

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
"
cpuinfoforhumans="
Your CPU Information:
     $cpuinfo

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
"
printerinfoforhumans="
Here's a list of your installed printers:
     Printer name(s):

$printerinfo

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
"
softwareinfoforhumans="
Here's the software you've installed:
     Software installed by User:

$softwareinfo

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
"

# Here is the order of the output using all necessary variables
if [ "$thisprogram" = "yes" -o "$namesandstuffyo" = "yes" ]; then
  echo "$namesandstuffinfoforhumans"
fi
if [ "$thisprogram" = "yes" -o  "$osnameyo" = "yes" ]; then
  echo "$OSnameinfoforhumans"
fi
if [ "$thisprogram" = "yes" -o  "$osversionyo" = "yes" ]; then
  echo "$OSversioninfoforhumans"
fi
if [ "$thisprogram" = "yes" -o  "$ipaddyo" = "yes" ]; then
  echo "$ipaddinfoforhumans"
fi
if [ "$thisprogram" = "yes" -o  "$cpuyo" = "yes" ]; then
  echo "$cpuinfoforhumans"
fi
if [ "$thisprogram" = "yes" -o  "$ramyo" = "yes" ]; then
  echo "$raminfoforhumans"
fi
if [ "$thisprogram" = "yes" -o  "$harddriveyo" = "yes" ]; then
  echo "$harddriveinfoforhumans"
fi
if [ "$thisprogram" = "yes" -o  "$printersyo" = "yes" ]; then
  echo "$printerinfoforhumans"
fi
if [ "$thisprogram" = "yes" -o  "$softwareyo" = "yes" ]; then
  echo "$softwareinfoforhumans"
fi
