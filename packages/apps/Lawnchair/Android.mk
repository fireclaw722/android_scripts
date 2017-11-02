LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE := Lawnchair
LOCAL_CERTIFICATE := PRESIGNED
LOCAL_SRC_FILES := Lawnchair.apk
LOCAL_MODULE_CLASS := APPS
LOCAL_MODULE_SUFFIX := $(COMMON_ANDROID_PACKAGE_SUFFIX)

LOCAL_OVERRIDES_PACKAGES := Home Launcher2 Launcher3 Fluctuation PixelHome Trebuchet

include $(BUILD_PREBUILT)