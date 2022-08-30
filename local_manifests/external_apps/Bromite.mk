LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)
LOCAL_MODULE := BromiteWebView
LOCAL_MODULE_CLASS := APPS
LOCAL_PRODUCT_MODULE := true
LOCAL_CERTIFICATE := PRESIGNED
LOCAL_OVERRIDES_PACKAGES := TrichromeWebView webview Webview WebView
LOCAL_MODULE_TARGET_ARCH := arm arm64 x86 x86_64
my_src_arch := $(call get-prebuilt-src-arch,$(LOCAL_MODULE_TARGET_ARCH))
LOCAL_SRC_FILES := $(my_src_arch)_SystemWebView.apk
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := Bromite
LOCAL_MODULE_CLASS := APPS
LOCAL_PRODUCT_MODULE := true
LOCAL_CERTIFICATE := PRESIGNED
LOCAL_OVERRIDES_PACKAGES := TrichromeChrome Jelly Browser
LOCAL_MODULE_TARGET_ARCH := arm arm64 x86 x86_64
my_src_arch := $(call get-prebuilt-src-arch,$(LOCAL_MODULE_TARGET_ARCH))
LOCAL_SRC_FILES := $(my_src_arch)_ChromePublic.apk
include $(BUILD_PREBUILT)
