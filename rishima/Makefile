ARCHS = arm64 arm64e

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = Rishima
Rishima_FILES = Rishima.mm
Rishima_INSTALL_PATH = /Library/PreferenceBundles
Rishima_FRAMEWORKS = UIKit MessageUI CoreGraphics
Rishima_PRIVATE_FRAMEWORKS = Preferences
Rishima_EXTRA_FRAMEWORKS += CepheiPrefs
Rishima_CFLAGS = -Wno-deprecated -Wno-deprecated-declarations -Wno-error

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/Rishima.plist$(ECHO_END)
