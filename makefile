export TARGET = iphone:clang:latest:6.0
export ARCHS = armv7

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = AndroidPattern
AndroidPattern_FILES = Tweak.x
AndroidPattern_FRAMEWORKS = UIKit CoreGraphics QuartzCore

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"