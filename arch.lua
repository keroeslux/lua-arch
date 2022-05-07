function partition(drive)
  local reset = function(drive)
    os.execute("sudo sfdisk --delete /dev/"..drive)
  end
  local partitions = function(drive)
    local timer = true
    while true do
      print("Enter size of drive ( exit to finish | eg +1M +1G ): ")
      siz = io.read()
      if siz == "exit" then
        break
      end
      os.execute("sudo echo -e 'n\np\n\n\n"..siz.."\nw' | fdisk /dev/"..drive)
    end
  end
  reset(drive)
  partitions(drive)
end
print("NOTE THIS WILL ERASE ALL DATA")
print("Enter the name of the drive you want to use: ")
local drive = io.read()
partition(drive)
