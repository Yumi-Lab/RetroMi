# hid-playstation DKMS — builds led-class-multicolor + hid-playstation
# For Armbian kernels where CONFIG_HID_PLAYSTATION and CONFIG_LEDS_CLASS_MULTICOLOR
# are not set. Provides DS4 v2 (054C:09CC) Bluetooth support.

obj-m += led-class-multicolor.o
obj-m += hid-playstation.o

# hid-playstation needs CRC32 (already =y in kernel) and POWER_SUPPLY (already =y)
# LEDS_CLASS_MULTICOLOR is provided by our led-class-multicolor.ko
ccflags-y += -DCONFIG_LEDS_CLASS_MULTICOLOR_MODULE
