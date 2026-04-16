# Force Theos to use the downloaded SDK instead of Xcode's
SYSROOT = $(THEOS)/sdks/iPhoneOS14.5.sdk

TARGET := iphone:clang:latest:6.0
ARCHS = armv7

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = AndroidPattern
AndroidPattern_FILES = Tweak.x
AndroidPattern_LIBRARIES = substrate
AndroidPattern_FRAMEWORKS = UIKit CoreGraphics QuartzCore

include $(THEOS_MAKE_PATH)/tweak.mk
