#!/bin/sh

. /lib/functions/lantiq.sh

set_preinit_misc_lantiq() {
board=$(lantiq_board_name)

case "$board" in
MRL952AKW33*)
        # Enable VLAN on lantiq switch
        swconfig dev switch0 vlan 1 set ports "0 1 2 3 4 5 6"

        #Enable VLAN on rtl8637b switch
        swconfig dev switch1 vlan 1 set ports "0 1 2 3 4 5 6"

        BOOTNUM=`/usr/sbin/fw_printenv bootnum -n`
        echo "Bootnum: $BOOTNUM"
        if [[ ! -z "$BOOTNUM" ]]; then
                if [[ "$BOOTNUM" -ge 4 ]]; then
                        # Reset bootnum to not interfere with the recovery trigger of uboot.
                        # Only jumps in on vendor uboot.
                        /usr/sbin/fw_setenv bootnum
                fi
        fi
        ;;
esac
}

boot_hook_add preinit_main set_preinit_misc_lantiq
