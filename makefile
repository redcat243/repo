# Targeting iOS 6 for the iPod Touch 4
TARGET := iphone:clang:latest:6.0
ARCHS = armv7

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = AndroidPattern
AndroidPattern_FILES = Tweak.x
# We add 'substrate' here so the linker finds the hooking functions
AndroidPattern_LIBRARIES = substrate
AndroidPattern_FRAMEWORKS = UIKit CoreGraphics QuartzCore

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
