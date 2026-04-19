LOCAL_PATH := $(call my-dir)

ifneq ($(filter X663,$(TARGET_DEVICE)),)
include $(call all-makefiles-under,$(LOCAL_PATH))
endif
