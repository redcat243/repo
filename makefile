include $(THEOS)/makefiles/common.mk

TWEAK_NAME = AndroidPattern
AndroidPattern_FILES = Tweak.x
AndroidPattern_FRAMEWORKS = UIKit

include $(THEOS_MAKE_PATH)/tweak.mk

# Replace 'prefs' with whatever your subfolder is named
SUBPROJECTS += prefs
include $(THEOS_MAKE_PATH)/aggregate.mk