function partition(drive)
  local reset = function(drive)
    os.execute("sudo sfdisk --delete /dev/"..drive)
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
      end
      os.execute("sudo echo -e 'n\np\n\n\n"..siz.."\nw' | fdisk /dev/"..drive.." > /dev/null")
    end
  end
  local formatting = function(drive)
    print("Enter the partition to format (list to show all partitions | type to show all supported fs formats | exit to finish): ")
    local part = io.read()
    print("Enter the fs format to use: ")
    local typ = io.read()
    local timer = true
    while timer == true do
      if part == "list" then
        os.execute("sudo lsblk /dev/"..drive)
      elseif part == "type" then
        os.execute("vfat,\nntfs,\next4,\next3,\nxfs,\nbtrfs")
      elseif part == "exit" then
        break
      else
        os.execute("mkfs."..typ.." /dev/"..drive.."/"..part)
      end
    end
  end
  reset(drive)
  partitions(drive)
end
print("NOTE THIS WILL ERASE ALL DATA")
print("Enter the name of the drive you want to use (ls to show all drives): ")
local drive = io.read()
if drive == "ls" then
  os.execute("lsblk")
  partition(drive)
else
  partition(drive)
end
