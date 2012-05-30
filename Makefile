include theos/makefiles/common.mk

TWEAK_NAME = ConfirmDictation
ConfirmDictation_FILES = Tweak.xm
ConfirmDictation_FRAMEWORKS = UIKit

include $(THEOS_MAKE_PATH)/tweak.mk
