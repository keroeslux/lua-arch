function prechroot(drive)
  local reset = function(drive)
    print("Wiping selected disk...")
    os.execute("sudo sfdisk --delete /dev/"..drive.." > /dev/null")
  end
  local partitions = function(drive)
    local timer = true
    while timer == true do
      print("Enter size of drive ( exit to finish | fill to fill the rest of drive | eg +1M +1G ): ")
      siz = io.read()
      if siz == "exit" then
        break
      elseif siz == "fill" then
        os.execute("sudo echo -e 'n\np\n\n\n\nw' | fdisk /dev/"..drive.." > /dev/null")
        timer = false
        break
      else
        os.execute("sudo echo -e 'n\np\n\n\n"..siz.."\nw' | fdisk /dev/"..drive.." > /dev/null")
      end
    end
  end
  local formatting = function(drive)
    :: perp :: print("\nEnter the partition to format (list to show all partitions | type to show all supported fs formats | exit to finish): ")
    local part = io.read()
    if part == "list" then
      os.execute("sudo lsblk /dev/"..drive)
      goto perp
    elseif part == "type" then
      print("vfat, \nntfs, \next4, \next3, \nxfs, \nbtrfs")
    print("\nEnter the fs format to use: ")
    local typ = io.read()
    local timer = true
    while timer == true do
      if part == "exit" then
        break
      else
        os.execute("mkfs."..typ.." /dev/"..part)
      end
    end
  end
  reset(drive)
  partitions(drive)
  formatting(drive)
end
print("NOTE THIS WILL ERASE ALL DATA")
local timer = true

while timer == true do
  :: printing :: print("Enter the name of the drive you want to use (ls for a list of them): ")
  drive = io.read()
  if drive == "ls" then
    os.execute("lsblk")
    goto printing
  else
    break
  end
end
prechroot(drive)
