ARCHS = arm64 arm64e
SDK = iPhoneOS12.1.2
FINALPACKAGE = 1
THEOS_DEVICE_IP = 192.168.1.101

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Rishima
Rishima_FILES = Tweak.xm UIView+DCAnimationKit.m iKARingerHUDViewController.xm
Rishima_FRAMEWORKS = UIKit CoreGraphics QuartzCore AVFoundation AudioToolbox
Rishima_EXTRA_FRAMEWORKS += Cephei
Rishima_CFLAGS = -Wno-deprecated -Wno-deprecated-declarations -Wno-error
UIView+DCAnimationKit.m_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += rishima
include $(THEOS_MAKE_PATH)/aggregate.mk
