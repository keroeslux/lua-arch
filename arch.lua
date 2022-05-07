function partition(drive)
  local reset = function(drive)
    os.execute("sudo sfdisk --delete /dev/"..drive)
  end
  local partitions = function(drive)
    local timer = true
    while true do
      print("Enter size of drive ( exit to finish | fill to fill the rest of drive | eg +1M +1G ): ")
      siz = io.read()
      if siz == "exit" then
        break
      elseif siz == "fill" then
        os.execute("sudo echo -e 'n\np\n\n\n\nw' | fdisk /dev/"..drive)
        break
      end
      os.execute("sudo echo -e 'n\np\n\n\n"..siz.."\nw' | fdisk /dev/"..drive)
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
