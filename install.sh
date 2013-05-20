#!/bin/bash
# This is a generic theme installer made for the LBM series.
# Theoretically it can be used for any gnome-shell theme, even
# without modifying the code.
#
# Copyright (C) 2013, ConvMe
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
# Contact to the author at http://convme.deviantart.com

# ----- Configuration variables -----

# Define theme name
themename=${1:-LittleBigMod_2nd}

# Default menue color
color=32

# Default file names
readonly gdm_file="gdm_background.jpg"
readonly wallpaper_file="lbm_background.jpg"
readonly plymouth_file="background.png" # Do not change

# Default sources
readonly lbm_plymouth="LBM_PLYMOUTH"
readonly lbm_gdm="LBM_GDM/$gdm_file"
readonly lbm_shell="LBM_SHELL"
readonly lbm_wallpaper="LBM_WALLPAPER/$wallpaper_file"

# Default destinations
defaults () {
roottheme="/usr/share/gnome-shell"
rootfonts="/usr/local/share/fonts/truetype"
rootwall="/usr/share/backgrounds"
usertheme="$HOME/.themes"
userfonts="$HOME/.fonts"
userwall="$HOME/.cache/wallpaper"
plymouth="/lib/plymouth/themes"
}

# Font names
fontnames=( "negotiate free.ttf" "Raleway-Light.ttf" )

# ----- Program part from here -----

# Error handling
error() {
read -p ""
exit 1
}

# Screen outputs
text () {
count=$1
name=$2
folder=$3
case "$count" in
        0) echo "$name will be installed now..."
        ;;
        1) echo -e "\033[1m$name installed into: $folder\033[0m"
        ;;
        2) echo "$name will be removed now..."
        ;;
        3) echo -e "\033[1m$name removed from: $folder\033[0m"
        ;;
        4) echo -e "\033[0;31mError: $name could not be removed from $folder\033[0;0m"
        ;;
        5) echo -e "\033[0;31mError: $name folder not found\033[0;0m"
        ;;
        6) echo -e "\033[1mNothing to do\033[0m"
        ;;
        7) echo -e "\033[0;31mWarning: Could not install $name\033[0;0m"
        ;;
        8) echo -e "\033[0;31mWarning: File is not a png\033[0;0m"
        ;;
        9) echo -e "\033[0;31mWarning: File does not exist\033[0;0m"
        ;;
        10) echo -e "\033[0;31mError: Version of gnome is incorrect\033[0;0m"
esac
}

# Check for version of gnome shell
gver=`gnome-session --version | grep '3.6\|3.8'`
if [ -z "$gver" ]; then
  text 10
  error
fi

# Internas
chkInErr () {
local err=$1
local name="$2"
local folder="$3"
if [ $err -eq 0 ]; then
  text 1 "$name" $folder
else
  text 7 "$name"
fi   
}

chkRmErr () {
local err=$1
local name="$2"
local folder="$3"
if [ $err -eq 0 ]; then
  text 3 "$name" $folder
else
  text 4 "$name" $folder
fi
}

rmFonts () {
local fontname="$1"
local fontfolder="$2"
local admin=$3

if [ -e "$fontfolder/$fontname" ]; then
  if [ $admin = on ]; then
    sudo rm -f "$fontfolder/$fontname"
  else
    rm -f "$fontfolder/$fontname"
  fi
  if [ $? -eq 0 ]; then                       
    return 0
  else
    return 1
  fi
else
  return 2
fi
}

chgDest () {
local folder="$1"
clear
echo Current destination: $folder 
}

chgDestMenue () {
clear
echo -e "\033[1;${color}mInstall $themename theme\033[0;${color}m in $gver"
echo "--------------------------------------------------------------------------------"
echo -e "\033[1;${color}m        Global theme folders\033[0;${color}m"
echo -e "\033[1;${color}m  Gt =\033[0;${color}m  -- Theme    : $roottheme" 
echo -e "\033[1;${color}m  Gf =\033[0;${color}m  -- Fonts    : $rootfonts"
echo -e "\033[1;${color}m  Gw =\033[0;${color}m  -- Wallpaper: $rootwall"
echo;
echo -e "\033[1;${color}m        Local theme folders\033[0;${color}m"
echo -e "\033[1;${color}m  Lt =\033[0;${color}m  -- Theme    : $usertheme"
echo -e "\033[1;${color}m  Lf =\033[0;${color}m  -- Fonts    : $userfonts"
echo -e "\033[1;${color}m  Lw =\033[0;${color}m  -- Wallpaper: dummy for the system"
echo;
echo -e "\033[1;${color}m        Plymouth theme folders\033[0;${color}m"
echo -e "\033[1;${color}m  Pt =\033[0;${color}m  -- Pymouth    : $plymouth"
echo;
echo -e "\033[1;${color}m  R  =  Restore defaults\033[0;${color}m"
echo;
echo -e "\033[1;${color}m  f  =  Finish\033[0;${color}m"
echo -e "--------------------------------------------------------------------------------\033[1;${color}m"
read -p "Which destination would you like to change? " input
echo -e "\033[0;0m"
case "$input" in
       Gt|gt|gT|GT) chgDest $roottheme
            read -p "New destination: " roottheme
            roottheme=$(echo "$roottheme" | sed "s/ /_/g")
            chgDestMenue
       ;;
       Lt|lt|lT|LT) chgDest $usertheme
            read -p "New destination: " usertheme
            usertheme=$(echo "$usertheme" | sed "s/ /_/g")
            chgDestMenue
       ;;
       Gf|gf|gF|GF) chgDest $rootfonts
            read -p "New destination: " rootfonts
            rootfonts=$(echo "$rootfonts" | sed "s/ /_/g")
            chgDestMenue
       ;;
       Lf|lf|lF|LF) chgDest $userfonts
            read -p "New destination: " userfonts
            userfonts=$(echo "$userfonts" | sed "s/ /_/g")
            chgDestMenue
       ;;
       Gw|gw|gW|GW) chgDest $rootwall
            read -p "New destination: " rootwall
            rootwall=$(echo "$rootwall" | sed "s/ /_/g")
            chgDestMenue
       ;;
       Lw|lw|lW|LW) chgDestMenue
       ;;
       Pt|pt|pT|PT) chgDest $plymouth
            read -p "New destination: " plymouth
            plymouth=$(echo "$plymouth" | sed "s/ /_/g")
            chgDestMenue
       ;;       
       r|R)
            defaults
            chgDestMenue
       ;;
       f|F|*|"") menue
esac
}

getCustBg () {
echo "Enter custom background (i. e. ~/MyBackgrounds/MyFile.png)"
echo "By now only png files are supported."
read -p "Destination: " custombg
custombg="${custombg/#\~/${HOME}}"
if [ "${custombg##*.}" = "png" ] && [ -e $custombg ]; then
  return 0
else
  if [ -e $custombg ]; then
    text 8
  else
    text 9
  fi 
fi
return 1
}

setGdmBg () {
local err=$1
local gdm_bg="$2"

if [ $err -eq 0 ] && [ -e $gdm_bg ]; then

sudo -i bash << "EOF"
cat > /tmp/runasgdm << "EOOF"
#! /bin/bash
`dbus-launch | sed 's/^/export /'`
EOOF
chmod 777 /tmp/runasgdm
EOF
sudo echo "GSETTINGS_BACKEND=dconf gsettings set org.gnome.desktop.background picture-uri 'file://$gdm_bg'" >> /tmp/runasgdm
sudo -i bash << "EOF"
su - gdm -s /tmp/runasgdm
rm -f /tmp/runasgdm
EOF

return $?
fi
return 1
}

setBg () {
local err=$1
local gdm_bg="$2"

if [ $err -eq 0 ] && [ -e $gdm_bg ]; then
  gsettings set org.gnome.desktop.background picture-uri "file://$gdm_bg"
return $?
fi
return 1
}

setReGS () {
nohup gnome-shell --replace >/dev/null 2>&1 &
disown -h %1
}

menue () {
clear
echo -e "\033[1;${color}mInstall $themename theme\033[0;${color}m in $gver"
echo "--------------------------------------------------------------------------------"
echo -e  "\033[1;${color}m  G  =  Install theme for all users (with gdm):\033[0;${color}m"
echo "        This will backup & replace the default gnome-shell theme."
echo "        -- Theme    : $roottheme" 
echo "        -- Fonts    : $rootfonts"
echo "        -- Wallpaper: $rootwall"
echo;
echo -e  "\033[1;${color}m  L  =  Install theme for this user only (no gdm):\033[0;${color}m"
echo "        -- Theme    : $usertheme"
echo "        -- Fonts    : $userfonts"
echo "        -- Wallpaper: $userwall"
echo;
echo -e  "\033[1;${color}m  P  =  Install plymouth theme\033[0;${color}m"
echo;
echo -e  "\033[1;${color}m  W  =  Set custom wallpaper (plymouth, gdm, wallpaper)\033[0;${color}m"
echo -e  "\033[1;${color}m  M  =  Modify the destination(s)\033[0;${color}m"
echo -e  "\033[1;${color}m  R  =  Remove installed theme(s) and restore defaults\033[0;${color}m"
echo;
echo -e  "\033[1;${color}m  q  =  Abort the script\033[0;${color}m"
echo -e "--------------------------------------------------------------------------------\033[1;${color}m"
read -p "What do you want to do? " input
echo -e "\033[0;0m"
case "$input" in
        g|G) 
             if [ -d $lbm_shell ]; then
               text 0 "Theme and fonts"
               sudo cp -fr $lbm_shell/gnome-shell $roottheme && sudo chmod -fR 755 $roottheme/gnome-shell
               sudo touch $roottheme/gnome-shell/custom_$themename
             else
               text 5 Theme
               error
             fi
             if [ $? -eq 0 ]; then
               if [ -e $roottheme/theme/custom_$themename ] || [ -d $roottheme/theme-ORI_from_LBM ]; then
                 sudo rm -frd $roottheme/theme
               else
                 sudo mv -f $roottheme/theme $roottheme/theme-ORI_from_LBM
               fi
               if [ $? -eq 0 ]; then
                 sudo mv -f $roottheme/gnome-shell $roottheme/theme
                 if [ $? -eq 0 ]; then
                   text 1 Theme $roottheme
                   setReGS
                 fi
                 # Install wallpaper & activate it
                 if [ -e $lbm_wallpaper ]; then
                   sudo cp -fr $lbm_wallpaper $rootwall
                 fi
                 setBg $? $rootwall/$wallpaper_file
                 chkInErr $? Wallpaper $rootwall
                 # Install wallpaper & replace gdm background
                 if [ -e $lbm_gdm ]; then
                   sudo cp -fr $lbm_gdm $rootwall
                 fi
                 setGdmBg $? $rootwall/$gdm_file
                 chkInErr $? "GDM background" $rootwall
               fi
             fi
             if [ -d Fonts ]; then
               if ! [ -d $rootfonts ]; then
                 sudo mkdir -p $rootfonts               
               fi
               sudo cp -fr Fonts/*.ttf $rootfonts
             else
               text 5 Fonts
               error
             fi
             if [ $? -eq 0 ]; then
               text 1 Fonts $rootfonts
             fi
            ;;
        l|L) 
             if [ -d $lbm_shell ]; then
               text 0 "Theme and fonts"
               if [ -e $usertheme/$themename ]; then
                 rm -frd $usertheme/$themename
               fi
               cp -fr $lbm_shell $usertheme/$themename && chmod -fR 755 $usertheme/$themename
               #mv -f $usertheme/$lbm_shell $usertheme/$themename
             else
               text 5 Theme
               error
             fi
             if [ $? -eq 0 ]; then
               text 1 Theme $usertheme
             fi
             # Install wallpaper & activate it
             if [ -e $lbm_wallpaper ]; then
               setBg $? $(pwd)/$lbm_wallpaper
             fi
             chkInErr $? Wallpaper $userwall
             if [ -d Fonts ]; then
               if ! [ -d $userfonts ]; then
                 mkdir -p $userfonts
               fi
               cp -fr Fonts/*.ttf $userfonts
             else
               text 5 Fonts
               error
             fi
             if [ $? -eq 0 ]; then
               text 1 Fonts $userfonts
             fi       
            ;;
        p|P)
             if [ -d $lbm_plymouth ]; then
               text 0 "Plymouth theme"
               if [ -e $plymouth/$themename ]; then
                 sudo rm -frd $plymouth/$themename
               fi               
               sudo cp -fr $lbm_plymouth $plymouth/$themename && sudo chmod -fR 755 $plymouth/$themename
               #sudo mv -f $plymouth/$lbm_plymouth $plymouth/$themename
             else
               text 5 Plymouth
               error
             fi
             if [ $? -eq 0 ]; then
               sudo update-alternatives --install $plymouth/default.plymouth default.plymouth $plymouth/$themename/$themename.plymouth 200
               sudo update-alternatives --config default.plymouth
             fi
             if [ $? -eq 0 ]; then
               sudo update-initramfs -u
             fi
             chkInErr $? Plymouth $plymouth
            ;;
        w|W) retval=1
             while [ $retval == 1 ]; do
               getCustBg
               retval=$?
             done
             if [ $? -eq 0 ]; then
               text 0 "Custom wallpaper"
               sudo cp -f "$custombg" $rootwall/$wallpaper_file
               setBg $? $rootwall/$wallpaper_file
               chkInErr $? Wallpaper $rootwall
               sudo cp -f "$custombg" $rootwall/$gdm_file
               setGdmBg $? $rootwall/$gdm_file
               chkInErr $? "GDM background" $rootwall
               if [ -e $plymouth/$themename/$plymouth_file ]; then
                 sudo cp -f "$custombg" $plymouth/$themename/$plymouth_file && sudo chmod -fR 755 $plymouth/$themename/$plymouth_file
                 chkInErr $? "Plymouth background" $plymouth/$themename
               fi
             fi
            ;;
        m|M) chgDestMenue
            ;;
        r|R) text 2 Theme
             # Remove global theme
             if [ -d $roottheme/theme-ORI_from_LBM ]; then
               sudo rm -frd $roottheme/theme
               sudo mv -f $roottheme/theme-ORI_from_LBM $roottheme/theme
               chkRmErr $? Theme $roottheme
               nothing=0
             else
               nothing=1
             fi
             # Remove local theme
             if [ -e $usertheme/$themename ]; then
               rm -frd $usertheme/$themename
               chkRmErr $? Theme $usertheme
               nothing=0
             else
               if [ $nothing -eq 1 ]; then
                 nothing=1
               fi
             fi
             if [ $nothing = 1 ]; then
               text 6
               nothing=0
             else
               setReGS
             fi
             # Remove wallpaper
             if [ -e $rootwall/$wallpaper_file ]; then
               sudo rm -f $rootwall/$wallpaper_file
               setBg $? $rootwall/gnome/Stripes.jpg 
               chkRmErr $? Wallpaper $rootwall               
             fi
             if [ -e $userwall/* ]; then
               rm -frd $userwall/*
               setBg $? $rootwall/gnome/Stripes.jpg 
               chkRmErr $? Wallpaper $userwall
             fi                          
             # Remove Fonts
             read -p "Do you want to remove installed fonts? (y/n) " input
             case "$input" in
                       y|Y|Yes|"") text 2 Fonts
                                   if [ -n "$fontnames" ]; then
                                     for fontname in "${fontnames[@]}"
                                     do
                                       rmFonts "$fontname" $rootfonts on
                                       retval=$?
                                       if [ $retval -eq 2 ]; then
                                         nothing=1
                                       else
                                         chkRmErr $retval "$fontname" $rootfonts
                                         nothing=0
                                       fi                                     
                                     done
                                     for fontname in "${fontnames[@]}"
                                     do
                                       rmFonts "$fontname" $userfonts off
                                       retval=$?
                                       if [ $retval -eq 2 ]; then
                                         if [ $nothing -eq 1 ]; then
                                           nothing=1
                                         fi
                                       else
                                         chkRmErr $retval "$fontname" $userfonts
                                         nothing=0
                                       fi                                   
                                     done
                                   else
                                     nothing=1
                                   fi                               
                                   if [ $nothing = 1 ]; then
                                     text 6
                                   fi
                       ;;
                       n|N|No|*)
                       ;;
             esac
             # Remove Plymouth theme
             if [ -e $plymouth/$themename ]; then
               read -p "Do you want to remove plymouth theme? (y/n) " input
               case "$input" in
                       y|Y|Yes|"") text 2 Plymouth
                                   exists=`sudo update-alternatives --display default.plymouth | grep $themename`
                                   if [ -z "$exists" ]; then
                                     nothing=1
                                   else
                                     sudo update-alternatives --remove default.plymouth $plymouth/$themename/$themename.plymouth
                                     sudo update-initramfs -u
                                   fi
                                   if [ $? -eq 0 ]; then
                                     sudo rm -frd $plymouth/$themename
                                   fi    
                                   chkRmErr $? Plymouth $plymouth
                                   if [ $nothing = 1 ]; then
                                     text 6
                                   fi
                       ;;
                       n|N|No|*)
                       ;;
               esac
             fi
             # Remove wallpaper & restore gdm defaults
             if [ -e $rootwall/$gdm_file ]; then
               read -p "Do you want to restore the gdm background? (y/n) " input
               case "$input" in
                       y|Y|Yes|"") text 2 "GDM background"
                                   sudo rm -f $rootwall/$gdm_file
                                   setGdmBg $? /usr/share/themes/Adwaita/backgrounds/adwaita-timed.xml
                                   chkRmErr $? "GDM background" $rootwall
                       ;;
                       n|N|No|*)
                       ;;
               esac
             fi       
            ;;
        q|Q) exit
            ;;
        *|"") menue 
            ;;
esac
}

# Set default variables
defaults

# Run main menue
again=1
while [ $again -eq 1 ]; do
  menue
  echo -e "\033[1;${color}m"
  read -p "Want to do something else? (y/n) " input
  echo -e "\033[0;0m"
  case "$input" in
          y|Y|Yes|"") again=1
          ;;
          n|N|No|*) again=0
          ;;
  esac    
done
exit
