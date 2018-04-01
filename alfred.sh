#!/bin/bash

# DISCLAIMER
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

# INITIALIZATION ##############################################################
debug=true

packages=""
repos=()
taskNames=()
taskMessages=()
taskDescriptions=()
taskRecipes=()
taskPostInstallations=()
taskDefaults=()

# TASK LIST ###################################################################
#------------------------------------------------------------------------------
taskNames+=("Install automatic drivers")
taskMessages+=("Processing drivers")
taskDescriptions+=("Install drivers that are appropriate for automatic installation")
taskRecipes+=("autoInstallDrivers")
taskDefaults+=("FALSE")

autoInstallDrivers()
{
  ubuntu-drivers autoinstall
}
#------------------------------------------------------------------------------
taskNames+=("Install Java, Flash and codecs")
taskMessages+=("Processing Java, Flash and codecs")
taskDescriptions+=("Install non-open-source packages like Java, Flash plugin, Unrar, and some audio and video codecs like MP3/AVI/MPEG")
taskRecipes+=("installRestrictedExtras")
taskDefaults+=("FALSE")

installRestrictedExtras()
{
  addPackage "ubuntu-restricted-extras"
}
#------------------------------------------------------------------------------
taskNames+=("Install Chrome")
taskMessages+=("Processing Chrome")
taskDescriptions+=("The web browser from Google")
taskRecipes+=("installChrome")
taskDefaults+=("FALSE")

installChrome()
{
  if [[ $OSarch == "x86_64" ]]; then
      installPackage "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
  else
      >&2 echo "Your system is not supported by Google Chrome"
      return -1
  fi
}
#------------------------------------------------------------------------------
taskNames+=("Install Chromium")
taskMessages+=("Processing Chromium")
taskDescriptions+=("The open-source web browser providing the code for Google Chrome.")
taskRecipes+=("installChromium")
taskDefaults+=("FALSE")

installChromium()
{
  addPackage "chromium-browser"
}
#------------------------------------------------------------------------------
taskNames+=("Install Firefox")
taskMessages+=("Processing Firefox")
taskDescriptions+=("The web browser from Mozilla")
taskRecipes+=("installFirefox")
taskDefaults+=("FALSE")

installFirefox()
{
  addRepo "ppa:ubuntu-mozilla-security/ppa"
  addPackage "firefox firefox-locale-$(locale | grep LANGUAGE | cut -d= -f2 | cut -d_ -f1)"
}
#------------------------------------------------------------------------------
taskNames+=("Install Opera")
taskMessages+=("Processing Opera")
taskDescriptions+=("Just another web browser")
taskRecipes+=("installOpera")
taskDefaults+=("FALSE")

installOpera()
{
  if [[ $OSarch == "x86_64" ]]; then
    installPackage "https://download1.operacdn.com/pub/opera/desktop/52.0.2871.40/linux/opera-stable_52.0.2871.40_amd64.deb"
  else
    installPackage "https://download1.operacdn.com/pub/opera/desktop/52.0.2871.40/linux/opera-stable_52.0.2871.40_i386.deb"
  fi
}
#------------------------------------------------------------------------------
taskNames+=("Install Transmission")
taskMessages+=("Processing Transmission")
taskDescriptions+=("A light bittorrent download client")
taskRecipes+=("installTransmission")
taskDefaults+=("FALSE")

installTransmission()
{
  addRepo "ppa:transmissionbt/ppa"
  addPackage "transmission-gtk"
}
#------------------------------------------------------------------------------
taskNames+=("Install Dropbox")
taskMessages+=("Processing Dropbox")
taskDescriptions+=("A cloud hosting service to store your files online")
taskRecipes+=("installDropbox")
taskDefaults+=("FALSE")

installDropbox()
{
  # Handle elementary OS with wingpanel support
  if [[ $OSname == "elementary" ]]; then
    installPackage git
    apt-get --purge remove -y dropbox*
    installPackage python-gpgme
    git clone https://github.com/zant95/elementary-dropbox /tmp/elementary-dropbox
    bash /tmp/elementary-dropbox/install.sh -y
  else
    if [[ $OSarch == "x86_64" ]]; then
        wget -q -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -
    else
        wget -q -O - "https://www.dropbox.com/download?plat=lnx.x86" | tar xzf -
    fi

    /.dropbox-dist/dropboxd
  fi
}
#------------------------------------------------------------------------------
taskNames+=("Install VirtualBox")
taskMessages+=("Processing VirtualBox")
taskDescriptions+=("A virtualization software to run other OSes on top of your current OS")
taskRecipes+=("installVirtualBox")
taskDefaults+=("FALSE")

installVirtualBox()
{
  addPackage "virtualbox"
}
#------------------------------------------------------------------------------
taskNames+=("Install Skype")
taskMessages+=("Processing Skype")
taskDescriptions+=("A videocall software from Microsoft")
taskRecipes+=("installSkype")
taskDefaults+=("FALSE")

installSkype()
{
  installPackage "https://go.skype.com/skypeforlinux-64.deb"
}
#------------------------------------------------------------------------------
taskNames+=("Install Thunderbird")
taskMessages+=("Processing Thunderbird")
taskDescriptions+=("A mail client from Mozilla")
taskRecipes+=("installThunderbird")
taskDefaults+=("FALSE")

installThunderbird()
{
  addPackage "thunderbird"
}
#------------------------------------------------------------------------------
taskNames+=("Install Telegram")
taskMessages+=("Processing Telegram")
taskDescriptions+=("A chat client, similar to Whatsapp, Viber, Facebook Messenger or Google Hangouts")
taskRecipes+=("installTelegram")
taskDefaults+=("FALSE")

installTelegram()
{
  if [[ $OSarch == "x86_64" ]]; then
    wget -O - https://telegram.org/dl/desktop/linux > /tmp/telegram.tar.xz
  else
    wget -O - https://telegram.org/dl/desktop/linux32 > /tmp/telegram.tar.xz
  fi

  tar -xf /tmp/telegram.tar.xz -C /opt

  chmod +x /opt/Telegram/Telegram
  chown -R $SUDO_USER:$SUDO_USER /opt/Telegram/

  wget -q -o /opt/Telegram/icon.png https://desktop.telegram.org/img/td_logo.png

  desktopFile="/home/$SUDO_USER/.local/share/applications/telegram.desktop"

  echo "[Desktop Entry]" > $desktopFile
  echo "Name=Telegram" >> $desktopFile
  echo "GenericName=Chat" >> $desktopFile
  echo "Comment=Chat with yours friends" >> $desktopFile
  echo "Exec=/opt/Telegram/Telegram" >> $desktopFile
  echo "Terminal=false" >> $desktopFile
  echo "Type=Application" >> $desktopFile
  echo "Icon=/opt/Telegram/icon.png" >> $desktopFile
  echo "Categories=Network;Chat;" >> $desktopFile
  echo "StartupNotify=false" >> $desktopFile
}
#------------------------------------------------------------------------------
taskNames+=("Install Slack")
taskMessages+=("Processing Slack")
taskDescriptions+=("A team communication application")
taskRecipes+=("installSlack")
taskDefaults+=("FALSE")

installSlack()
{
  installPackage "https://downloads.slack-edge.com/linux_releases/slack-desktop-2.3.3-amd64.deb"
}
#------------------------------------------------------------------------------
taskNames+=("Install VLC")
taskMessages+=("Processing VLC")
taskDescriptions+=("The most famous multimedia player")
taskRecipes+=("installVLC")
taskDefaults+=("FALSE")

installVLC()
{
  addRepo "ppa:videolan/stable-daily"
  addPackage "vlc"
}
#------------------------------------------------------------------------------
taskNames+=("Install Kazam")
taskMessages+=("Processing Kazam")
taskDescriptions+=("A tool to record your screen and take screenshots")
taskRecipes+=("installKazam")
taskDefaults+=("FALSE")

installKazam()
{
  addPackage "kazam"
}
#------------------------------------------------------------------------------
taskNames+=("Install Handbrake")
taskMessages+=("Processing Handbrake")
taskDescriptions+=("A video transcoder")
taskRecipes+=("installHandbrake")
taskDefaults+=("FALSE")

installHandbrake()
{
  addRepo "ppa:stebbins/handbrake-releases"
  addPackage "handbrake-gtk handbrake-cli"
}
#------------------------------------------------------------------------------
taskNames+=("Install Spotify")
taskMessages+=("Processing Spotify...")
taskDescriptions+=("One of the best music streaming apps")
taskRecipes+=("installSpotify")
taskDefaults+=("FALSE")

installSpotify()
{
  apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 0DF731E45CE24F27EEEB1450EFDC8610341D9410

  if [[ ! -f /etc/apt/sources.list.d/spotify.list ]]; then
    echo deb http://repository.spotify.com stable non-free | tee /etc/apt/sources.list.d/spotify.list
  fi

  addPackage "spotify-client"
}
#------------------------------------------------------------------------------
taskNames+=("Install Audacity")
taskMessages+=("Processing Audacity")
taskDescriptions+=("Record and edit audio files")
taskRecipes+=("installAudacity")
taskDefaults+=("FALSE")

installAudacity()
{
  addPackage "audacity"
}
#------------------------------------------------------------------------------
taskNames+=("Install Soundconverter")
taskMessages+=("Processing Soundconverter")
taskDescriptions+=("Audio file converter")
taskRecipes+=("installSoundconverter")
taskDefaults+=("FALSE")

installSoundconverter()
{
  addPackage "soundconverter"
}
#------------------------------------------------------------------------------
taskNames+=("Install Mixxx")
taskMessages+=("Processing Mixxx")
taskDescriptions+=("A MP3 DJ mixing software")
taskRecipes+=("installMixxx")
taskDefaults+=("FALSE")

installMixxx()
{
  addRepo "ppa:mixxx/mixxx"
  addPackage "mixxx"
}
#------------------------------------------------------------------------------
taskNames+=("Install LMMS")
taskMessages+=("Processing LMMS")
taskDescriptions+=("Music production for everyone: loops, synthesizers, mixer...")
taskRecipes+=("installLMMS")
taskDefaults+=("FALSE")

installLMMS()
{
  addPackage "lmms"
}
#------------------------------------------------------------------------------
taskNames+=("Install Gimp")
taskMessages+=("Processing Gimp")
taskDescriptions+=("Gimp is an image editor")
taskRecipes+=("installGimp")
taskDefaults+=("FALSE")

installGimp()
{
  addPackage "gimp"
}
#------------------------------------------------------------------------------
taskNames+=("Install Inkscape")
taskMessages+=("Processing Inkscape")
taskDescriptions+=("Create and edit scalable vectorial images")
taskRecipes+=("installInkscape")
taskDefaults+=("FALSE")

installInkscape()
{
  addPackage "inkscape"
}
#------------------------------------------------------------------------------
taskNames+=("Install Blender")
taskMessages+=("Processing Blender")
taskDescriptions+=("3D modelling, animation, rendering and production")
taskRecipes+=("installBlender")
taskDefaults+=("FALSE")

installBlender()
{
  addRepo "ppa:thomas-schiex/blender"
  addPackage "blender"
}
#------------------------------------------------------------------------------
taskNames+=("Install LeoCad")
taskMessages+=("Processing LeoCad")
taskDescriptions+=("Virtual LEGO CAD software")
taskRecipes+=("installLeoCad")
taskDefaults+=("FALSE")

installLeoCad()
{
  installPackage unzip

  wget -q -O /tmp/ldraw.zip http://www.ldraw.org/library/updates/complete.zip
  unzip /tmp/ldraw.zip -d /home/$SUDO_USER

  addPackage "leocad"
}
#------------------------------------------------------------------------------
taskNames+=("Install LibreOffice suite")
taskMessages+=("Processing LibreOffice")
taskDescriptions+=("A complete office suite: word processor, spreadsheets, slideshows, diagrams, drawings, databases and equations")
taskRecipes+=("installLibreOffice")
taskDefaults+=("FALSE")

installLibreOffice()
{
  addPackage "libreoffice libreoffice-l10n-$lang"
}
#------------------------------------------------------------------------------
taskNames+=("Install LibreOffice Writer")
taskMessages+=("Processing LibreOffice Writer")
taskDescriptions+=("Install just the LibreOffice word processor")
taskRecipes+=("installLibreOfficeWriter")
taskDefaults+=("FALSE")

installLibreOfficeWriter()
{
  addPackage "libreoffice-writer libreoffice-l10n-$lang"
}
#------------------------------------------------------------------------------
taskNames+=("Install LibreOffice Impress")
taskMessages+=("Processing LibreOffice Impress")
taskDescriptions+=("Install just the LibreOffice slide show editor")
taskRecipes+=("installLibreOfficeImpress")
taskDefaults+=("FALSE")

installLibreOfficeImpress()
{
  addPackage "libreoffice-impress libreoffice-l10n-$lang"
}
#------------------------------------------------------------------------------
taskNames+=("Install LibreOffice Spreadsheet")
taskMessages+=("Processing LibreOffice Spreadsheet")
taskDescriptions+=("Install just the LibreOffice spreadsheet editor")
taskRecipes+=("installLibreOfficeSpreadsheet")
taskDefaults+=("FALSE")

installLibreOfficeSpreadsheet()
{
  addPackage "libreoffice-calc libreoffice-l10n-$lang"
}
#------------------------------------------------------------------------------
taskNames+=("Install LibreOffice Draw")
taskMessages+=("Processing LibreOffice Draw")
taskDescriptions+=("Install just the LibreOffice drawing editor")
taskRecipes+=("installLibreOfficeDraw")
taskDefaults+=("FALSE")

installLibreOfficeDraw()
{
  addPackage "libreoffice-draw libreoffice-l10n-$lang"
}
#------------------------------------------------------------------------------
taskNames+=("Install LibreOffice Base")
taskMessages+=("Processing LibreOffice Base")
taskDescriptions+=("Install just the LibreOffice database manager")
taskRecipes+=("installLibreOfficeBase")
taskDefaults+=("FALSE")

installLibreOfficeBase()
{
  addPackage "libreoffice-base libreoffice-l10n-$lang"
}
#------------------------------------------------------------------------------
taskNames+=("Install LibreOffice Math")
taskMessages+=("Processing LibreOffice Math")
taskDescriptions+=("Install just the LibreOffice equation editor")
taskRecipes+=("installLibreOfficeMath")
taskDefaults+=("FALSE")

installLibreOfficeMath()
{
  addPackage "libreoffice-math libreoffice-l10n-$lang"
}
#------------------------------------------------------------------------------
taskNames+=("Install Evince")
taskMessages+=("Processing Evince")
taskDescriptions+=("A document viewer with support for PDF, Postscript, djvu, tiff, dvi, XPS and SyncTex")
taskRecipes+=("installEvince")
taskDefaults+=("FALSE")

installEvince()
{
  addPackage "evince"
}
#------------------------------------------------------------------------------
taskNames+=("Install Master PDF Editor")
taskMessages+=("Processing Master PDF Editor")
taskDescriptions+=("A convenient and smart PDF editor for Linux")
taskRecipes+=("installMasterPDF")
taskDefaults+=("FALSE")

installMasterPDF()
{
  if [[ $OSarch == "x86_64" ]]; then
    installPackage "http://get.code-industry.net/public/master-pdf-editor-3.7.10_amd64.deb"
  else
    installPackage "http://get.code-industry.net/public/master-pdf-editor-3.7.10_i386.deb"
  fi
}
#------------------------------------------------------------------------------
taskNames+=("Install Jabref")
taskMessages+=("Processing Jabref")
taskDescriptions+=("A graphical editor for bibtex libraries")
taskRecipes+=("installJabref")
taskDefaults+=("FALSE")

installJabref()
{
  addPackage "jabref"
}
#------------------------------------------------------------------------------
taskNames+=("Install TexMaker")
taskMessages+=("Processing TexMaker")
taskDescriptions+=("A LateX development environment")
taskRecipes+=("installTexMaker")
taskDefaults+=("FALSE")

installTexMaker()
{
  addPackage "texmaker"
}
#------------------------------------------------------------------------------
taskNames+=("Install DiffPdf")
taskMessages+=("Processing DiffPdf")
taskDescriptions+=("Tool to compare PDF files")
taskRecipes+=("installDiffPdf")
taskDefaults+=("FALSE")

installDiffPdf()
{
  addPackage "diffpdf"
}
#------------------------------------------------------------------------------
taskNames+=("Install Steam")
taskMessages+=("Processing Steam")
taskDescriptions+=("A game digital distribution platform developed by Valve")
taskRecipes+=("installSteam")
taskPostInstallations+=("postSteam")
taskDefaults+=("FALSE")

installSteam()
{
  addRepo "multiverse"
  addPackage "steam"
}

postSteam()
{
  cd $HOME/.steam/ubuntu12_32/steam-runtime/i386/usr/lib/i386-linux-gnu
  mv libstdc++.so.6 libstdc++.so.6.bak
  cd $HOME/.steam/ubuntu12_32/steam-runtime/amd64/usr/lib/x86_64-linux-gnu
  mv libstdc++.so.6 libstdc++.so.6.bak
}
#------------------------------------------------------------------------------
taskNames+=("Install 0 A.D.")
taskMessages+=("Processing 0 A.D.")
taskDescriptions+=("0 A.D. is a game of ancient warfare, similar to Age of Empires")
taskRecipes+=("install0AD")
taskDefaults+=("FALSE")

install0AD()
{
  addPackage "0ad"
}
#------------------------------------------------------------------------------
taskNames+=("Install Wine")
taskMessages+=("Processing Wine")
taskDescriptions+=("A tool to install Windows software on Linux")
taskRecipes+=("installWine")
taskDefaults+=("FALSE")

installWine()
{
  if [[ $OSarch == "x86_64" ]]; then
    dpkg --add-architecture i386
  fi

  wget -q -nc -O /tmp/Release.key https://dl.winehq.org/wine-builds/Release.key
  apt-key add /tmp/Release.key
  installRepo "https://dl.winehq.org/wine-builds/ubuntu/"
  apt-get update
  installPackage "--install-recommends winehq-stable"
}
#------------------------------------------------------------------------------
taskNames+=("Install PlayOnLinux")
taskMessages+=("Processing PlayOnLinux")
taskDescriptions+=("A tool to install Windows games on Linux")
taskRecipes+=("installPlayOnLinux")
taskDefaults+=("FALSE")

installPlayOnLinux()
{
  addPackage "playonlinux"
}
#------------------------------------------------------------------------------
taskNames+=("Install Disk utility")
taskMessages+=("Processing Disk utility")
taskDescriptions+=("A tool to manage your drives")
taskRecipes+=("installDiskUtility")
taskDefaults+=("FALSE")

installDiskUtility()
{
  addPackage "gnome-disk-utility"
}
#------------------------------------------------------------------------------
taskNames+=("Install GParted")
taskMessages+=("Processing GParted")
taskDescriptions+=("A tool to make partitions in your hard drives")
taskRecipes+=("installGParted")
taskDefaults+=("FALSE")

installGParted()
{
  addPackage "gparted"
}
#------------------------------------------------------------------------------
taskNames+=("Install MenuLibre")
taskMessages+=("Processing MenuLibre")
taskDescriptions+=("Add or remove applications from your menu")
taskRecipes+=("installMenuLibre")
taskDefaults+=("FALSE")

installMenuLibre()
{
  addPackage "menulibre"
}
#------------------------------------------------------------------------------
taskNames+=("Install Seahorse")
taskMessages+=("Processing Seahorse")
taskDescriptions+=("Manage your passwords")
taskRecipes+=("installSeahorse")
taskDefaults+=("FALSE")

installSeahorse()
{
  addPackage "seahorse"
}
#------------------------------------------------------------------------------
taskNames+=("Install Duplicity")
taskMessages+=("Processing Duplicity")
taskDescriptions+=("Keep your files safe by making automatic backups")
taskRecipes+=("installDuplicity")
taskDefaults+=("FALSE")

installDuplicity()
{
  addPackage "duplicity"
}
#------------------------------------------------------------------------------
taskNames+=("Install UNetbootin")
taskMessages+=("Processing UNetbootin")
taskDescriptions+=("Tool for creating Live USB drives")
taskRecipes+=("installUNetbootin")
taskDefaults+=("FALSE")

installUNetbootin()
{
  addPackage "unetbootin"
}
#------------------------------------------------------------------------------
taskNames+=("Install EncFS")
taskMessages+=("Processing EncFS")
taskDescriptions+=("Create and manage encrypted folders to keep your files safe")
taskRecipes+=("installEncFS")
taskDefaults+=("FALSE")

installEncFS()
{
  addRepo "ppa:gencfsm"
  addPackage "gnome-encfs-manager"
}
#------------------------------------------------------------------------------
taskNames+=("Install FileZilla")
taskMessages+=("Processing FileZilla")
taskDescriptions+=("Download and upload files via FTP, FTPS and SFTP")
taskRecipes+=("installFileZilla")
taskDefaults+=("FALSE")

installFileZilla()
{
  addPackage "filezilla"
}
#------------------------------------------------------------------------------
taskNames+=("Install utilities bundle")
taskMessages+=("Processing utilities bundle")
taskDescriptions+=("Java, zip, rar and exfat tools")
taskRecipes+=("installUtilities")
taskDefaults+=("FALSE")

installUtilities()
{
  addPackage "icedtea-8-plugin openjdk-8-jre p7zip rar exfat-fuse exfat-utils"
}
#------------------------------------------------------------------------------
taskNames+=("Install Glipper")
taskMessages+=("Processing Glipper")
taskDescriptions+=("Gnome clipboard manager")
taskRecipes+=("installGlipper")
taskDefaults+=("FALSE")

installGlipper()
{
  addPackage "glipper"
}
#------------------------------------------------------------------------------
taskNames+=("Install developer bundle")
taskMessages+=("Processing developer bundle")
taskDescriptions+=("Tools for developers: build-essential, cmake, git, svn, java, python, octave, autotools...")
taskRecipes+=("installDevBundle")
taskDefaults+=("FALSE")

installDevBundle()
{
  addPackage "build-essential cmake cmake-gui cmake-curses-gui python python3 octave gfortran git git-svn subversion kdiff3 colordiff openjdk-8-jdk autoconf autotools-dev cppcheck"
}
#------------------------------------------------------------------------------
taskNames+=("Install Boost libraries")
taskMessages+=("Processing Boost")
taskDescriptions+=("Boost C++ libraries")
taskRecipes+=("installBoost")
taskDefaults+=("FALSE")

installBoost()
{
  addPackage "libboost-dev libboost-serialization-dev libboost-filesystem-dev liboost-dev libboost-system-dev"
}
#------------------------------------------------------------------------------
taskNames+=("Install CodeLite")
taskMessages+=("Processing CodeLite")
taskDescriptions+=("A C/C++, PHP and JavaScript IDE for developers")
taskRecipes+=("installCodeLite")
taskDefaults+=("FALSE")

installCodeLite()
{
  apt-key adv --fetch-keys https://repos.codelite.org/CodeLite.asc
  addRepo "deb http://repos.codelite.org/ubuntu/ $OSbaseCodeName universe"
  addPackage "codelite wxcrafter"
}
#------------------------------------------------------------------------------
taskNames+=("Install Visual Studio Code")
taskMessages+=("Processing Visual Studio Code")
taskDescriptions+=("A source code editor developed by Microsoft")
taskRecipes+=("installVSCode")
taskDefaults+=("FALSE")

installVSCode()
{
  if [[ $OSarch == "x86_64" ]]; then
    installPackage "https://az764295.vo.msecnd.net/stable/79b44aa704ce542d8ca4a3cc44cfca566e7720f1/code_1.21.1-1521038896_amd64.deb"
  else
    installPackage "https://az764295.vo.msecnd.net/stable/79b44aa704ce542d8ca4a3cc44cfca566e7720f1/code_1.21.1-1521038898_i386.deb"
  fi
}
#------------------------------------------------------------------------------
taskNames+=("Install Atom")
taskMessages+=("Processing Atom")
taskDescriptions+=("A hackable text editor")
taskRecipes+=("installAtom")
taskDefaults+=("FALSE")

installAtom()
{
  addRepo "ppa:webupd8team/atom"
  addPackage "atom"
}
#------------------------------------------------------------------------------
taskNames+=("Install Arduino")
taskMessages+=("Processing Arduino")
taskDescriptions+=("The official IDE for the Arduino board")
taskRecipes+=("installArduino")
taskDefaults+=("FALSE")

installArduino()
{
  if [[ $OSarch == "x86_64" ]]; then
    wget -q -O /tmp/arduino.tar.xz https://downloads.arduino.cc/arduino-1.8.5-linux64.tar.xz
  else
    wget -q -O /tmp/arduino.tar.xz https://downloads.arduino.cc/arduino-1.8.5-linux32.tar.xz
  fi

  tar xf /tmp/arduino.tar.xz -C /tmp
  mv /tmp/arduino-1.6.13/ /opt/arduino
  /opt/arduino/install.sh
}
#------------------------------------------------------------------------------
taskNames+=("Install GitKraken")
taskMessages+=("Processing GitKraken")
taskDescriptions+=("A graphical git client from Axosoft")
taskRecipes+=("installGitKraken")
taskDefaults+=("FALSE")

installGitKraken()
{
  if [[ $OSarch == "x86_64" ]]; then
    installPackage "https://release.gitkraken.com/linux/gitkraken-amd64.deb"
  else
    >&2 echo "Your system is not supported by Gitkraken"
    return -1
  fi
}
#------------------------------------------------------------------------------
taskNames+=("Install SmartGit")
taskMessages+=("Processing SmartGit")
taskDescriptions+=("A graphical git client from Syntevo")
taskRecipes+=("installSmartGit")
taskDefaults+=("FALSE")

installSmartGit()
{
  installPackage "https://www.syntevo.com/downloads/smartgit/smartgit-17_1_6.deb"
}
#------------------------------------------------------------------------------
taskNames+=("Install SysAdmin bundle")
taskMessages+=("Processing SysAdmin bundle")
taskDescriptions+=("Tools for sysadmins: tmux, cron, screen, ncdu, htop, aptitude, apache, etckeeper, xpra and dconf-editor")
taskRecipes+=("installSysAdminBundle")
taskDefaults+=("FALSE")

installSysAdminBundle()
{
  addPackage "tmux cron screen ncdu htop aptitude apache2 etckeeper xpra dconf-editor exfat-fuse exfat-utils"
}
#------------------------------------------------------------------------------
taskNames+=("Install Exodus")
taskMessages+=("Processing Exodus")
taskDescriptions+=("A blockchain wallet")
taskRecipes+=("installExodus")
taskDefaults+=("FALSE")

installExodus()
{
  wget -q -O /tmp/Exodus.zip https://exodusbin.azureedge.net/releases/exodus-linux-x64-1.48.0.zip
  chown -R $SUDO_USER:$SUDO_USER /opt/Exodus/
  #FIXME: install desktop file
}
#------------------------------------------------------------------------------
taskNames+=("Install Delta")
taskMessages+=("Processing Delta")
taskDescriptions+=("A cryptocurrency portfolio tracker")
taskRecipes+=("installDelta")
taskDefaults+=("FALSE")

installDelta()
{
  wget -q -O /home/$SUDO_USER/Delta.AppImage https://static-assets.getdelta.io/desktop_app/Delta-0.9.2-x86_64.AppImage
  chmod +x /home/$SUDO_USER/Delta.AppImage
  #FIXME: message the user to execute it
  #bash --rcfile <(echo '. ~/.bashrc; some_command')
}
#------------------------------------------------------------------------------
taskNames+=("Install rEFInd")
taskMessages+=("Processing rEFInd")
taskDescriptions+=("An EFI boot manager")
taskRecipes+=("installrEFInd")
taskPostInstallations+=("postrEFInd")
taskDefaults+=("FALSE")

installrEFInd()
 {
  addRepo "ppa:rodsmith/refind"
  addPackage "refind"
}

postrEFInd()
{
  refind-install --shim /boot/efi/EFI/ubuntu/shimx64.efi --localkeys
  refind-mkdefault
}
#------------------------------------------------------------------------------
taskNames+=("Install Discord")
taskMessages+=("Processing Discord")
taskDescriptions+=("Gaming voice/chat service")
taskRecipes+=("installDiscord")
taskDefaults+=("FALSE")

installDiscord()
{
  if [[ $OSarch == "x86_64" ]]; then
    installPackage "https://dl.discordapp.net/apps/linux/0.0.4/discord-0.0.4.deb"
  else
    >&2 echo "Your system is not supported by Gitkraken"
    return -1
  fi
}
#------------------------------------------------------------------------------
taskNames+=("Install Tux Guitar")
taskMessages+=("Processing Tux Guitar")
taskDescriptions+=("A tablature editor")
taskRecipes+=("installTuxGuitar")
taskDefaults+=("FALSE")

installTuxGuitar()
{
  addPackage "tuxguitar tuxguitar-alsa tuxguitar-jsa tuxguitar-oss"
}
#------------------------------------------------------------------------------
taskNames+=("Install Ukuu")
taskMessages+=("Processing Ukuu")
taskDescriptions+=("A kernel update tool")
taskRecipes+=("installUkuu")
taskDefaults+=("FALSE")

installUkuu()
{
  addRepo "ppa:teejee2008/ppa"
  addPackage "ukuu"
}
#------------------------------------------------------------------------------
taskNames+=("Install Gnome System Monitor")
taskMessages+=("Processing Gnome System Monitor")
taskDescriptions+=("A system resource usage monitor")
taskRecipes+=("installSystemMonitor")
taskDefaults+=("FALSE")

installSystemMonitor()
{
  addPackage "gnome-system-monitor"
}
#------------------------------------------------------------------------------
taskNames+=("Install ANoise")
taskMessages+=("Processing ANoise")
taskDescriptions+=("An ambient music player")
taskRecipes+=("installANoise")
taskDefaults+=("FALSE")

installANoise()
{
  addRepo "ppa:costales/anoise"
  addPackage "anoise"
}
#------------------------------------------------------------------------------
taskNames+=("Install Minetest")
taskMessages+=("Processing Minetest")
taskDescriptions+=("A Minecraft clone")
taskRecipes+=("installMinetest")
taskDefaults+=("FALSE")

installMinetest()
{
  addRepo "ppa:minetestdevs/stable"
  addPackage "minetest"
}
#------------------------------------------------------------------------------
taskNames+=("Install Typora")
taskMessages+=("Processing Typora")
taskDescriptions+=("A minimalist text editor")
taskRecipes+=("installTypora")
taskDefaults+=("FALSE")

installTypora()
{
  apt-key adv --keyserver keyserver.ubuntu.com --recv-keys BA300B7755AFCFAE
  addRepo "deb http://typora.io linux/"
  addPackage "typora"
}
#------------------------------------------------------------------------------
taskNames+=("Install Kdenlive")
taskMessages+=("Processing Kdenlive")
taskDescriptions+=("A video editing suite")
taskRecipes+=("installKdenlive")
taskDefaults+=("FALSE")

installKdenlive()
{
  addPackage "kdenlive"
}
#------------------------------------------------------------------------------
taskNames+=("Install Openshot")
taskMessages+=("Processing Openshot")
taskDescriptions+=("A video editor")
taskRecipes+=("installOpenshot")
taskDefaults+=("FALSE")

installOpenshot()
{
  addRepo "ppa:openshot.developers/ppa"
  addPackage "openshot-qt"
}
#------------------------------------------------------------------------------
taskNames+=("Install Retroarch")
taskMessages+=("Processing Retroarch")
taskDescriptions+=("A retro games emulator frontend")
taskRecipes+=("installRetroarch")
taskDefaults+=("FALSE")

installRetroarch()
{
  addRepo "ppa:libretro/stable"
  addPackage "retroarch"
}
#------------------------------------------------------------------------------
taskNames+=("Install Ulauncher")
taskMessages+=("Processing Ulauncher")
taskDescriptions+=("Application launcher for Linux")
taskRecipes+=("installUlauncher")
taskDefaults+=("FALSE")

installUlauncher()
{
  addRepo "ppa:agornostal/ulauncher"
  addPackage "ulauncher"
}
#------------------------------------------------------------------------------
taskNames+=("Install Wireshark")
taskMessages+=("Processing Wireshark")
taskDescriptions+=("A network traffic analyzer")
taskRecipes+=("installWireshark")
taskDefaults+=("FALSE")

installWireshark()
{
  addPackage "wireshark"
}
#------------------------------------------------------------------------------
# INSTRUCTIONS
# To add a new task, add a new section above this block copying and pasting the following 5 lines:

# taskNames+=("<Task Name>")
# taskMessages+=("<Task message>")
# taskDescriptions+=("<Task description>")
# taskRecipes+=("<Task recipe function>")
# taskDefaults+=("Task boolean value")

# Then, uncomment them and:

# Replace <Task Name> with the new task's name.
# Replace <Task message> with the message that will be displayed while.
# performing the task, i.e. "Upgrading the system" .
# Replace <Task description> with the new task's description.
# Replace <Task recipe function> with the function name which will contain .
# the necessary commands to perform the task and write that function. Do NOT use sudo in it.
# Replace <Task boolean value> with TRUE of FALSE to make this task to be marked by default.
#------------------------------------------------------------------------------
# END OF TASK LIST ############################################################
#------------------------------------------------------------------------------

# Main function
main()
{
  # Test that this is Ubuntu or an Ubuntu derivative
  grep -Fxq "ID_LIKE=ubuntu" /etc/os-release

  if [[ $? -ne 0 ]]; then
    if ! $(testPackage zenity); then
      echo "This is not an Ubuntu or Ubuntu derivative distro. You can't run Alfred in this system."
    else
      zenity --error --title="Alfred" --text="This is not an Ubuntu or Ubuntu derivative distro. You can't run Alfred in this system."
    fi
    exit 0
  fi

  # Get system info
  OSarch=$(uname -m)
  OSname=$(lsb_release -si)
  OSversion=$(lsb_release -sr)
  OScodeName=$(lsb_release -sc)
  OSbaseCodeName=$(lsb_release -scu)
  lang=$(locale | grep LANGUAGE | cut -d= -f2 | cut -d_ -f1)


  # Test /var/lib/dpkg/lock to ensure we can install packages
  lock=$(fuser /var/lib/dpkg/lock)

  if [ ! -z "$lock" ]; then
    if ! $(testPackage zenity); then
      echo "Another program is installing or updating packages. Please wait until this process finishes and then launch Alfred again."
    else
      zenity --error --title="Alfred" --text="Another program is installing or updating packages. Please wait until this process finishes and then launch Alfred again."
    fi
    exit 0
  fi

  # Repair installation interruptions
  dpkg --configure -a


  # Check if Zenity package is installed
  if ! $(testPackage zenity); then
    installPackage "zenity"
  fi


  # Test connectivity
  if ! ping -c 1 google.com >> /dev/null 2>&1; then
    zenity --error --title="Alfred" --text="There is no connection to the Internet. Please connect and then launch Alfred again."
    exit 0
  fi


  # Build task table for Zenity
  taskTable=()

  for (( i=0; i<${#taskNames[@]}; i++ )); do
      taskTable+=("${taskDefaults[$i]}" "${taskNames[$i]}" "${taskDescriptions[$i]}")
  done

  # Create selection GUI with Zenity
  while true; do

    tasks=$(zenity --list --checklist \
      --height 720 \
      --width 1280 \
      --title="Alfred" \
      --text "Select tasks to perform:" \
      --column=Selection \
      --column=Task \
      --column=Description \
      "${taskTable[@]}" \
      --separator=', '
    )

    # Check for closed window / cancel button
    if [[ $? == 1 ]]; then
      exit 0
    fi

    # Check zero tasks selected
    if [[ -z "$tasks" ]]; then
      zenity --info --title="Alfred" --text "No tasks were selected"
      continue
    fi

    # Warning message and confirmation
    message="The selected tasks will be performed now. "
    message+="You won't be able to cancel this operation once started.\n"
    message+="Are you sure you want to continue?"

    if zenity --question --title="Alfred" --text "$message"; then
      break
    fi

  done

  # Write error log file header
  debugLog="/tmp/Alfred-dbg.log"
  errorLog="/tmp/Alfred-errors.log"

  logHeader="==================================================================================================\n"
  logHeader="${logHeader}NEW SESSION $(date)\n"
  logHeader="$logHeader$(lsb_release -d | cut -d: -f2 | sed "s/^[ \t]*//")\n"
  logHeader="$logHeader$(uname -a)\n"

  echo -e "$logHeader" >> $errorLog

  if $debug; then
    echo -e "$logHeader" >> $debugLog
  fi

  # Perform all tasks and show progress in a progress bar
  ntasks=$(( $(echo "$tasks" | grep -o "\," | wc -l) + 1 ))
  taskpercentage=$((100 / $ntasks))

  (
    progress=0
    errors=false

    for i in ${!taskNames[@]}; do
      if [[ $tasks == *"${taskNames[i]}"* ]]; then
        echo "# ${taskMessages[$i]}..."

        outputMsg=$(
                      set -e

                      if $debug; then
                        ${taskRecipes[$i]} &>> $debugLog
                      else
                        ${taskRecipes[$i]} 2>&1
                      fi
                   )

        if [[ $? -ne 0 ]]; then
          echo "RECIPE "${taskNames[$i]}"\n" >> $errorLog
          echo "$outputMsg" >> $errorLog
          echo "--------------------------------------------------------------------------------------------------\n" >> $errorLog
          errors=true
        fi

        progress=$(( $progress + $taskpercentage ))
        echo $progress
      fi
    done

    if $errors ; then
      echo "RECIPE_ERRORS_HAPPENED\n" >> $errorLog
    fi
  ) |
  zenity --progress \
         --no-cancel \
         --title="Alfred" \
         --text="Processing all tasks" \
         --percentage=0 \
         --height 100 \
         --width 500

  # Add repos and install packages
  (
    errors=false

    if [[ $(tail -1 $errorLog) == "RECIPE_ERRORS_HAPPENED" ]]; then
      errors=true
    fi

    # Add repos
    if $debug; then
      processRepos &>> $debugLog
    else
      processRepos 2>&1
    fi

    if [[ $? != 0 ]]; then
      errors=true
      echo "REPO_ERRORS_HAPPENED\n" >> $errorLog
    fi

    # Install packages
    if $debug; then
      processPackages &>> $debugLog
    else
      processPackages 2>&1
    fi

    if [[ $? != 0 ]]; then
      errors=true
      echo "PACKAGE_ERRORS_HAPPENED\n" >> $errorLog
    fi

    if $errors ; then
      echo "SOME_ERRORS_HAPPENED\n" >> $errorLog
      echo "# Some tasks ended with errors"
      if $(testPackage libnotify-bin); then
        notify-send -i utilities-terminal Alfred "Some tasks ended with errors"
      fi
    else
      echo "# All tasks completed succesfully"
      if $(testPackage libnotify-bin); then
        notify-send -i utilities-terminal Alfred "All tasks completed succesfully"
      fi
    fi

  ) |
  zenity --progress \
         --no-cancel \
         --pulsate \
         --title "Alfred"
         --text "Installing packages" \
         --height 100 \
         --width 500

  # Notify errors
  if [[ $? != 0 ]]; then
    zenity --error --title="Alfred"\
           --text="An unexpected error occurred. Some tasks may not have been performed."
    exit 1
  fi

  # Show error list from the error log
  errors=false
  if [[ $(tail -1 $errorLog) == "SOME_ERRORS_HAPPENED" ]]; then
    errors=true
  fi

  if $errors ; then
    errorList=()

    # Last occurrence of NEW SESSION
    startLine=$(tac $errorLog | grep -n -m1 "NEW SESSION" | cut -d: -f1)

    while read line; do
      firstword=$(echo $line | cut -d' ' -f1)

      if [[ "$firstword" == "RECIPE" ]]; then # If line starts with RECIPE
          errorList+=("${line/RECIPE /}")
      fi
    done <<< "$(tail -n $startLine $errorLog)" # Use the error log only from startLine to the end

    if [[ ${#errorList[@]} > 0 ]]; then

      message="The following tasks ended with errors and could not be completed:"

      selected=$(zenity --list --height 500 --width 500 --title="Alfred" \
                        --text="$message" \
                        --hide-header --column "Tasks with errors" "${errorList[@]}")

      message="Please notify the following error log at https://github.com/derkomai/alfred/issues\n"
      message+="-------------------------------------------------------------"
      message+="---------------------------------------------------------\n\n"

      echo -e $message"$(tail -n $startLine $errorLog)" |
      zenity --text-info --height 700 --width 800 --title="Alfred"
    fi
  fi
}
# End of main function


testPackage()
{
  dpkg-query -l $1 &> /dev/null

  if [[ $? == 0 ]]; then
    echo true
  else
    echo false
  fi
}


addPackage()
{
  packages+=" $1"
}


installPackage()
{
  for arg in $@; do
    if [[ "$arg" == "http"*".deb" ]]; then
      wget -q -O /tmp/package.deb $1
      apt-get -y install /tmp/package.deb
      rm /tmp/package.deb
    else
      apt-get -y install $arg
    fi
  done
}


processPackages()
{
  apt-get update
  apt-get -y upgrade
  apt-get -y install packages
  apt-get -y autoremove
}


addRepo()
{
  repos+=("$1")
}


installRepo()
{
  if ! $(testPackage software-properties-common); then
    installPackage software-properties-common
  fi

  add-apt-repository -y $1
}


processRepos()
{
  if ! $(testPackage software-properties-common); then
    installPackage software-properties-common
  fi

  for repo in ${repos[@]}; do
    add-apt-repository -y "$repo"
  done
}


getPassword()
{
  sudo -k

  while true; do
    password=$(zenity --password --title="Alfred")

    # Check for closed window / cancel button
    if [[ $? == 1 ]]; then
      return -1
    fi

    # Check for correct password
    myid=$(echo $password | sudo -S id -u)

    if [[ $? == 0 ]] && [[ $myid == 0 ]]; then
      echo $password
      return 0
    else
        zenity --info --title="Alfred" --text="Wrong password, try again"
    fi
  done
}


# RUN

# Check for root permissions and ask for password in other case
if [[ $(id -u) == 0 ]]; then
    main
else
    password=$(getPassword)

    if [[ $? == 0 ]]; then
      echo $password | sudo -S "$0"
    else
      exit 0
    fi
fi

exit 0
