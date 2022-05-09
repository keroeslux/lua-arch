local environmentSetup = function(dewm)
  local plasma = function()
    os.execute("pacman -S xorg plasma plasma-wayland-session kde-applications --noconfirm > /dev/null")
    os.execute("systemctl enable sddm.service")
  end
  local gnome = function()
    os.execute("pacman -S gnome --noconfirm > /dev/null")
    os.execute("systemctl enable gdm")
  end
  local xfce = function()
    os.execute("pacman -S xfce4 xfce4-goodies --noconfirm > /dev/null")
    os.execute("systemctl enable sddm.service")
  end

  if dewm == "xfce" then
    xfce()
  elseif dewm == "gnome" then
    gnome()
  elseif dewm == "kde" then
    plasma()
  else
    print("Error while installing drive.")
  end
end



local postchroot = function()
  local init = function()
    print("Enter your timezone (e.g. Canada/Central): ")
    local tz = io.read()
    print("Enter your locale (example: en_US.UTF-8 UTF-8): ")
    local locale = io.read()
    print("using LANG=en_US.UTF-8 for locale.conf...")
    local exec = function()
      os.execute("timedatectl set-timezone "..tz)
      os.execute("echo "..locale.. " > /etc/locale.gen")
    end
    exec()
  end
  local userSet = function()
    print("Enter your hostname: ")
    local hostname = io.read()
    local hosts = function()
      os.execute("touch /etc/hosts")
      os.execute("echo '127.0.0.1\t\tlocalhost' >> /etc/hosts")
      os.execute("echo '::1\t\tlocalhost' >> /etc/hosts")
      os.execute("echo '127.0.1.1\t\t"..hostname.."' >> /etc/hosts")
    end
    hosts()
    print("Enter the password for the root user: ")
    local rootpasswd = io.read()
    os.execute("echo -e '"..rootpasswd.."\n"..rootpasswd.."' | passwd root")
  end
  local bootSet = function()
    os.execute("pacman -S grub efibootmgr networkmanager --noconfirm > /dev/null")
    print("Enter the drive you used previously: ")
    local drive = io.read()
    print("Enter the boot partition: ")
    local bootpart = io.read()
    print("Make an efi directory? y\n : ")
    local yn = io.read()
    if yn == "y" then
      os.execute("mkdir /boot/efi")
      os.execute("mount /dev/"..bootpart.." /boot/efi")
      os.execute("grub-install --target=x86_64-efi --bootloader-id=GRUB --efi-directory=/boot/efi > /dev/null")
      os.execute("grub-mkconfig -o /boot/grub/grub.cfg")
    else
      os.execute("grub-install /dev/"..drive)
    end
    os.execute("systemctl enable NetworkManager")
  end
  local desktopSetup = function()
    local userSetup = function()
      print("Enter a name for your user: ")
      local user = io.read()
      os.execute("useradd -m "..user)
      print("Enter a password for the user: ")
      local passwd = io.read()
      os.execute("echo -e '"..passwd.."\n"..passwd.."' | passwd "..user)
      print("Grant them sudo access? y\n : ")
      local yn = io.read()
      if yn == "y" then
        os.execute("sed -i '80i "..user.." ALL=(ALL) ALL' /etc/sudoers")
      end
    end
    userSetup()
    local desktop = function()
      print("Enter the DE/WM you want to use (server for server)")
      local dewm = io.read()
      environmentSetup(dewm)
    end
    desktop()
  end
  init()
  userSet()
  bootSet()
  desktopSetup()

end
