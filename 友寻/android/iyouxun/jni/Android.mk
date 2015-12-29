LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)
LOCAL_C_INCLUDES := $(LOCAL_PATH)/include
LOCAL_LDLIBS += -L$(SYSROOT)/usr/lib -llog
LOCAL_MODULE    := iyouxun
LOCAL_SRC_FILES := iyouxun.c
include $(BUILD_SHARED_LIBRARY)
LOCAL_SHARED_LIBRARIES := liblocSDK5
LOCAL_SHARED_LIBRARIES := libBaiduMapSDK
include $(LOCAL_PATH)/prebuild/Android.mk