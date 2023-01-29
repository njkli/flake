{ config, lib, ... }:

with lib;
let
  inherit (config.boot.kernelPackages) kernel;
  # fix_freezes = versionAtLeast kernel.version "5.4.11" && versionOlder kernel.version "5.6.7";
in
{
  ###
  # TODO: echo 1 | sudo tee /sys/class/graphics/fbcon/rotate
  # console and X rotation upon sensor position.
  # "fbcon=rotate:3" <- for chuwi air10

  sound.enable = mkForce false;

  boot.tmpOnTmpfs = mkDefault true;
  boot.loader.systemd-boot.enable = mkDefault true;
  boot.loader.efi.canTouchEfiVariables = mkDefault false;
  boot.loader.timeout = mkDefault 0;

  boot.initrd.supportedFilesystems = [ "f2fs" "ext4" ];

  services.acpid.enable = true;
  services.logind.lidSwitch = mkForce "ignore";

  powerManagement.enable = true;
  powerManagement.cpuFreqGovernor = "powersave";

  hardware.sensor.iio.enable = mkDefault true;

  # TODO: touchscreen, there's a section in sources.toml hardware.firmware = [ ];
  # boot.extraModulePackages        = [ gslx680-acpi ];

  hardware.bluetooth.enable = false;
  hardware.bluetooth.powerOnBoot = false;

  boot.blacklistedKernelModules = [ "snd_hdmi_lpe_audio" ];
  boot.initrd.availableKernelModules = [
    "ahci"
    "sdhci_acpi"
    "sdhci_pci"
    "xhci_pci"
    "rtsx_usb_sdmmc"
    "usb_storage"
    "usbhid"
    "sd_mod"
    "dwc3_pci"
    "intel_pmc_mux"
    "xhci_hcd"
    "pwm_lpss"
    "pwm_lpss_platform"
    "rtsx_pci_sdmmc"
  ];

  boot.kernelParams = mkBefore [
    "fbcon=rotate:1"
    "i915.enable_dpcd_backlight=1"
    "acpi_osi=!"
    "acpi_osi=\"android\""
    # the idle_cstate in cherrytrails isn't going away
    "intel_idle.max_cstate=1"
    # "acpi_osi=\"Windows 2015\""
  ];

  boot.kernelModules = [ "i915" "intel_pmc_mux" ];
  boot.kernelPatches = [
    {
      name = "rtl8723bs_bt";
      patch = null;
      extraConfig = ''
        SERIAL_8250_DW m
        RFKILL_GPIO m
        SERIAL_DEV_BUS y
        BT_HCIUART_RTL y
      '';
    }
    # TODO: CONFIG_TASK_DELAY_ACCT
    {
      name = "cherrytrail-platform";
      patch = null;
      extraConfig = ''
        PMIC_OPREGION y
        FB_VIA_DIRECT_PROCFS y

        # CPU
        MATOM y

        # MMC
        MMC y
        MMC_BLOCK y
        MMC_SDHCI y
        MMC_SDHCI_ACPI y

        # intel_pmc_mux is supposed to be the driver
        # INTEL_PMC_IPC is replaced with INTEL_SCU_IPC

        # PMIC
        INTEL_SCU_IPC y
        INTEL_SOC_PMIC y
        MFD_AXP20X y
        MFD_AXP20X_I2C y

        PWM_LPSS m
        PWM_LPSS_PLATFORM m

        # Backlight
        PWM y
        PWM_SYSFS y
        PWM_CRC y
        GPIO_CRYSTAL_COVE y

        # GPU
        AGP n
        DRM y
        DRM_I915 m

        # Thermal
        INT3406_THERMAL m
        INT340X_THERMAL m

        # GPIO
        PINCTRL_CHERRYVIEW y

        # I2C
        I2C_DESIGNWARE_BAYTRAIL y
        I2C_DESIGNWARE_PLATFORM y

        # HID
        INTEL_HID_EVENT y

        # MEI
        INTEL_MEI y
        INTEL_MEI_TXE y
      '';
    }
  ];

}
