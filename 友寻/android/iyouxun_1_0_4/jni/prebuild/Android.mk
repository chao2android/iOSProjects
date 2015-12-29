LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)
LOCAL_MODULE := liblocSDK5
LOCAL_SRC_FILES := liblocSDK5.so
include $(PREBUILT_SHARED_LIBRARY)


include $(CLEAR_VARS)
LOCAL_MODULE := libBaiduMapSDK
LOCAL_SRC_FILES := libBaiduMapSDK.so
include $(PREBUILT_SHARED_LIBRARY)