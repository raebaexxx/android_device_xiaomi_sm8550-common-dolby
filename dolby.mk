#
# Copyright (C) 2024-2026 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

DOLBY_PATH := device/xiaomi/sm8550-common-dolby

PRODUCT_SOONG_NAMESPACES += \
    vendor/xiaomi/sm8550-common-dolby

# System Properties
TARGET_ODM_PROP += $(DOLBY_PATH)/dolby.prop

# VINTF Manifests
DEVICE_FRAMEWORK_COMPATIBILITY_MATRIX_FILE += \
    $(DOLBY_PATH)/configs/vintf/framework_matrix_dolby.xml

# SEPolicy
BOARD_VENDOR_SEPOLICY_DIRS += \
    $(DOLBY_PATH)/sepolicy/vendor

# DolbyAtmos
PRODUCT_PACKAGES += \
    DolbyAtmos

# Shim Library
PRODUCT_PACKAGES += \
    dolbycodec_shim

# Audio Effects XML 
PRODUCT_COPY_FILES += \
    $(DOLBY_PATH)/configs/audio/sku_kalama/audio_effects.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio/sku_kalama/audio_effects.xml

# Inherit proprietary files
$(call inherit-product, vendor/xiaomi/sm8550-common-dolby/sm8550-common-dolby-vendor.mk)