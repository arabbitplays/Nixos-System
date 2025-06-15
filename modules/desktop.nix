{ lib, config, pkgs, ... }:

{
    options = {
        hypr-desktop.enable 
            = lib.mkEnableOption "enable desktop module";
    };

    config = lib.mkIf config.hypr-desktop.enable {
        # Enable the X11 windowing system.
        services.xserver.enable = true;
        services.displayManager.gdm = {
            enable = true;
            wayland = true;
        };

        # Enable the Cinnamon Desktop Environment.
        #services.xserver.displayManager.lightdm.enable = true;
        #services.xserver.desktopManager.cinnamon.enable = true;

        programs.hyprland = {
            enable = true;
            xwayland.enable = true;
        };
        
        environment.sessionVariables = {
            WLR_NO_HARDWARE_CURSORS = "1";
            NISOS_OZONE_WL = "1";
        };

        hardware = {
            # enable opengl
            graphics.enable = true;
            nvidia.modesetting.enable = true;
        };

        environment.systemPackages = with pkgs; [
            kitty # terminal emulator (for hyprland)
            rofi-wayland # launcher
            nemo # filemanager
            (waybar.overrideAttrs (oldAttrs: {
            mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
            })) # desktop bar
            dunst # notification deamon
            libnotify # notify dependency
            swww # wallpaper manager
            lxqt.lxqt-policykit # authenticaton manager for polkit
            networkmanagerapplet
            wlogout # logout manager
        ];
    };
}