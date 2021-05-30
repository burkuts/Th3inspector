#!/bin/bash

red="\e[0;31m"
green="\e[0;32m"
off="\e[0m"

function banner() {
clear
echo "  _____ _     _____ _                           _";
echo " |_   _| |__ |___ /(_)_ __  ___ _ __   ___  ___| |_ ___  _ __";
echo "   | | | '_ \  |_ \| | '_ \/ __| '_ \ / _ \/ __| __/ _ \| '__|";
echo "   | | | | | |___) | | | | \__ \ |_) |  __/ (__| || (_) | |";
echo "   |_| |_| |_|____/|_|_| |_|___/ .__/ \___|\___|\__\___/|_|";
echo "                               |_|";
echo "  ___             _        _ _           ";
echo " |_ _|  _ __  ___| |_ __ _| | | ___ _ __ ";
echo "  | |  | '_ \/ __| __/ _\` | | |/ _ \ '__|";
echo "  | |  | | | \__ \ || (_| | | |  __/ |   ";
echo " |___| |_| |_|___/\__\__,_|_|_|\___|_|   ";
echo "                                         ";
}

function termux() {
  echo -e "$red [$green+$red]$off Perl Yükleniyor ...";
pkg install -y perl
echo -e "$red [$green+$red]$off JSON Modülü Yükleniyor ...";
cpan install JSON
  echo -e "$red [$green+$red]$off Dizinler Kontrol Ediliyor ..."

if [ -e "/data/data/com.termux/files/usr/share/Th3inspector" ]; then
  echo -e "$red [$green+$red]$off Önceki bir kurulum bulundu Değiştirmek istiyor musunuz? [Y/n]: "
read replace
if [ "$replace" == "y" ] || [ "$replace" == "Y" ] || [ -z "$replace" ]; then
 rm -r "/data/data/com.termux/files/usr/share/Th3inspector"
 rm "/data/data/com.termux/files/usr/bin/Th3inspector"
else
  echo -e "$red [$green✘$red]$off Kurmak İstiyorsanız Önceki Kurulumları Kaldırmalısınız";
  echo -e "$red [$green✘$red]$off Yükleme Başarısız";
 exit
fi
fi

  echo -e "$red [$green+$red]$off Yükleniyor ...";
 mkdir "/data/data/com.termux/files/usr/share/Th3inspector" 
 cp "Th3inspector.pl" "/data/data/com.termux/files/usr/share/Th3inspector"
 cp "install.sh" "/data/data/com.termux/files/usr/share/Th3inspector"
 cp "update.sh" "/data/data/com.termux/files/usr/share/Th3inspector"
 chmod +x /data/data/com.termux/files/usr/share/Th3inspector/update.sh
  echo -e "$red [$green+$red]$off Sembolik Bağlantı Oluşturuluyor ...";
  echo "#!/data/data/com.termux/files/usr/bin/bash 
perl /data/data/com.termux/files/usr/share/Th3inspector/Th3inspector.pl" '${1+"$@"}' > "Th3inspector";
 cp "Th3inspector" "/data/data/com.termux/files/usr/bin"
 chmod +x "/data/data/com.termux/files/usr/bin/Th3inspector"
 rm "Th3inspector";
 if [ -d "/data/data/com.termux/files/usr/share/Th3inspector" ] ;
then
echo -e "$red [$green+$red]$off Araç başarıyla kuruldu ve 5 saniye içinde başlayacak!";
echo -e "$red [$green+$red]$off Aracı Th3inspector yazarak çalıştırabilirsiniz "
sleep 5;
Th3inspector
else
echo -e "$red [$green✘$red]$off Araç Sisteminize Yüklenemiyor!  Taşınabilir Olarak Kullanın!";
    exit
fi
}

function linux() {
echo -e "$red [$green+$red]$off Perl Yükleniyor ...";
sudo apt-get install -y perl
echo -e "$red [$green+$red]$off JSON Modülü Yükleniyor ...";
cpan install JSON
  echo -e "$red [$green+$red]$off Dizinler Kontrol Ediliyor..."
if [ -d "/usr/share/Th3inspector" ]; then
    echo -e "$red [$green+$red]$off Bir Dizin Th3inspector Bulundu!  Değiştirmek istiyor musun? [Y/n]:" ;
    read replace
    if [ "$replace" = "y" ]; then
      sudo rm -r "/usr/share/Th3inspector"
      sudo rm "/usr/share/icons/Th3inspector.png"
      sudo rm "/usr/share/applications/Th3inspector.desktop"
      sudo rm "/usr/local/bin/Th3inspector"

else
echo -e "$red [$green✘$red]$off Kurmak İstiyorsanız Önceki Kurulumları Kaldırmalısınız;
echo -e "$red [$green✘$red]$off Installation Failed";
        exit
    fi
fi 

echo -e "$red [$green+$red]$off Yükleniyor ...";
echo -e "$red [$green+$red]$off Sembolik Link Üretiliyor ...";
echo -e "#!/bin/bash
perl /usr/share/Th3inspector/Th3inspector.pl" '${1+"$@"}' > "Th3inspector";
    chmod +x "Th3inspector";
    sudo mkdir "/usr/share/Th3inspector"
    sudo cp "install.sh" "/usr/share/Th3inspector"
    sudo cp "update.sh" "/usr/share/Th3inspector"
    sudo chmod +x /usr/share/Th3inspector/update.sh
    sudo cp "Th3inspector.pl" "/usr/share/Th3inspector"
    sudo cp "config/Th3inspector.png" "/usr/share/icons"
    sudo cp "config/Th3inspector.desktop" "/usr/share/applications"
    sudo cp "Th3inspector" "/usr/local/bin/"
    rm "Th3inspector";

if [ -d "/usr/share/Th3inspector" ] ;
then
echo -e "$red [$green+$red]$off Araç Başarıyla Yüklendi ve Başlayacak 5s!";
echo -e "$red [$green+$red]$off Th3inspector yazarak aracı çalıştırabilirsiniz."
sleep 5;
Th3inspector
else
echo -e "$red [$green✘$red]$off Araç Sisteminize Yüklenemiyor!  Taşınabilir Olarak Kullanın!";
    exit
fi 
}

if [ -d "/data/data/com.termux/files/usr/" ]; then
banner
echo -e "$red [$green+$red]$off Th3inspector Sisteminize Kurulacak";
termux
elif [ -d "/usr/bin/" ];then
banner
echo -e "$red [$green+$red]$off Th3inspector Sisteminize Kurulacak";
linux
else
echo -e "$red [$green✘$red]$off Araç Sisteminize Yüklenemiyor!  Taşınabilir Olarak Kullanın!";
    exit
fi
