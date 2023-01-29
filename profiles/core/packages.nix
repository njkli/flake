{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    ### absolute minimum
    acpi
    # smem
    acpitool
    lm_sensors
    iputils
    dnsutils
    dosfstools
    gptfdisk
    binutils
    coreutils
    file
    lsof
    moreutils
    nfs-utils
    bridge-utils

    usbutils # Tools for working with USB devices, such as lsusb
    utillinux # A set of system utilities for Linux
    whois # Intelligent WHOIS client from Debian
    ###
    brightnessctl
    ###
    vim

    # Archive tools
    unrar
    unzip
    p7zip

    #
    gotop

    #
    exfat
  ];
}
