%w[
clamp
terrapin
json
pastel
tty-prompt
filesize
dry-struct

awesome_print
pry
].each(&method(:require))

# ostruct
#
AwesomePrint.defaults = {
  indent: -2,
  color: {
    hash: :pale,
    class: :white
  }
}

# Find available storage
# Prepare zfs and dm stuff
# format and mount storage
class Helpers
  class Disk < OpenStruct
    def initialize args
      super
      # binding.pry
      self.children = self.children.map{ |c| self.class.new c } if self.children
    end

    class << self
      def lsblk
      end
    end
  end

  class << self
    INSTALL_DIR = "/mnt/install"
    POOL_NAME_RAIDZ = "data"
    POOL_NAME_RAID0 = "rpool"

    def lsblk
      p = "/home/vod/Projects/world/pkgs/tools/nix/nixos-install-tools/nixos-install-rb/example.json"
      JSON.parse(IO.read p)['blockdevices'].select{ |d| d["name"] !~ filter }

      # (JSON.parse (Terrapin::CommandLine.new "sudo", "lsblk --perms --fs --json").run)["blockdevices"].select{ |d| d["name"] !~ filter }
    end

    def lsblk_without_fs
      p = "/home/vod/Projects/world/pkgs/tools/nix/nixos-install-tools/nixos-install-rb/example_size.json"
      JSON.parse(IO.read p)['blockdevices'].select{ |d| d["name"] !~ filter }

      # (JSON.parse (Terrapin::CommandLine.new "sudo", "lsblk --json").run)["blockdevices"].select{ |d| d["name"] !~ filter }
    end

    def md_devices
      lsblk.select { |d| d['children'] && d['children'].find { |e| e['fstype'] == 'linux_raid_member' } }.
        map{|d| d['children'].map{|di| di['children']}}.flatten.compact.uniq.
        map{ |e| '/dev/' + e['name'] }
    end

    def device_names
      lsblk.map { |d| d['name'] }
    end

    def filter
      /^sr.*|^zram.*|^zd.*|^mmcblk.boot.*/i
    end

    def cmd args
      # FIXME: change back to sudo
      Terrapin::CommandLine.new "echo", args
    end

    def mkRaid disks
      lines = Array.new
      disks.each do |disk_name|
        sorted = lsblk_without_fs.select{ |e| disks.include? e['name'] }.sort { |a, b| Filesize.from(a['size']) <=> Filesize.from(b['size']) }
        disk_with_size = sorted.find { |e| e['name'] == disk_name }
        disk = lsblk.find { |e| e['name'] == disk_name }

        if has_raid disk
          lines << (raid_devices disk).map{ |d| "mdadm --stop #{d}"}
          lines << "mdadm --zero-superblock --force /dev/#{disk_name}"
          lines << "sgdisk --zap-all /dev/#{disk_name}"
        end

        # EFI boot for raid1
        efi_boot_size = Filesize.from("1G")
        lines << "sgdisk -n1:1M:+#{efi_boot_size.to_s('G').split.join} -t1:EF00 -c1:boot /dev/#{disk_name}"

        if disks.size > 2
          max_zraid_size = Filesize.from(sorted.first['size']) - efi_boot_size
          lines << "sgdisk -n2:0:+#{max_zraid_size.to_s('G').split.join} -t2:BF01 -c2:persist /dev/#{disk_name}"
          lines << "sgdisk -n3:0:0 -t3:BF01 -c3:rpool /dev/#{disk_name}" if (Filesize.from(disk_with_size['size'])  > (max_zraid_size + efi_boot_size))
        else
          lines << "sgdisk -n2:0:0 -t2:BF01 -c2:rpool /dev/#{disk_name}"
        end
      end
      l = lines.flatten.uniq.map(&method(:cmd))
      binding.pry
    end

    def raid_devices disk
      disk['children'].select { |e| e['fstype'] == 'linux_raid_member' }.
        map{|d| d['children'] }.flatten.compact.uniq.
        map{ |e| '/dev/' + e['name'] }
    end

    def has_raid disk
      disk['children'] && disk['children'].find { |e| e['fstype'] == 'linux_raid_member' }
    end

    def mkPartiton dev
      [ Helpers.cmd("sgdisk --zap-all /dev/#{dev}"),
        Helpers.cmd("sgdisk -n1:1M:+1G -t1:EF00 /dev/#{dev}"),
        Helpers.cmd("sgdisk -n2:0:+57G -t2:BF01 /dev/#{dev}")
      ]
    end

    def mkSingleDisk disks
    end
  end
end

class DiskCommand < Clamp::Command
  def execute
    disks = TTY::Prompt.new.multi_select "Select devices to initialize:", Helpers.device_names #.map(&method(:mkPartiton))
    lines = disks.size > 1 ? Helpers.mkRaid(disks) : Helpers.mkSingleDisk(disks)
    ap disks
    binding.pry
  end

end

class StatusCommand < Clamp::Command
  # option "--loud", :flag, "say it loud"

  def execute
    ap Helpers.lsblk
  end

end

class MainCommand < Clamp::Command
  self.default_subcommand = "status"

  subcommand ["status", "s" ], "Get status", StatusCommand
  subcommand ["disk", "d" ], "Init disks", DiskCommand

  # option "--loud", :flag, "say it loud"
  # option ["-n", "--iterations"], "N", "say it N times", default: 1 do |s|
  #   Integer(s)
  # end

  # parameter "WORDS ...", "the thing to say", attribute_name: :words


  # def execute
  #   the_truth = words.join(" ")
  #   the_truth.upcase! if loud?
  #   iterations.times do
  #     puts the_truth
  #   end
  # end

end

binding.pry
Helpers::Disk.new Helpers.lsblk_without_fs.first
MainCommand.run
