include $(THEOS)/makefiles/common.mk

TWEAK_NAME = AndroidPattern
AndroidPattern_FILES = Tweak.x
AndroidPattern_FRAMEWORKS = UIKit CoreGraphics

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"