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

# Dolby Vision encoder declaration, included by
# device/xiaomi/sm8550-common from media_codecs_kalama.xml. The declaration has
# to be in the parsed codec map or Codec2InfoBuilder drops it before it ever
# reaches a store, which is why Dolby Vision recording in MIUI Camera crashes.
PRODUCT_COPY_FILES += \
    $(DOLBY_PATH)/configs/media/media_codecs_fuxi_dolby_vision.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_fuxi_dolby_vision.xml

# Inherit proprietary files
$(call inherit-product, vendor/xiaomi/sm8550-common-dolby/sm8550-common-dolby-vendor.mk)