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

# Codec list
#
# /vendor/etc/media_codecs.xml is the file media_server actually parses (the
# ro.media.xml_variant.codecs property is unset, and it is the only
# media_codecs.xml under the parser's search dirs). Stock ships it without an
# include of media_codecs_dolby_audio.xml, which leaves the c2.dolby.eac3 and
# c2.dolby.ac4 decoders out of the parsed codec map. Codec2InfoBuilder skips any
# component missing from that map ("component ... not found in xml"), so the
# decoders stay invisible and AC-3 / E-AC-3 / AC-4 audio plays as silence.
#
# This file is a verbatim copy of the vendor blob with exactly one line added
# after the media_codecs_c2_audio.xml include. Keep it in sync when the blob is
# re-extracted. Duplicate PRODUCT_COPY_FILES destinations resolve first-wins,
# and the vendor blob is registered by the inherit below, so this entry has to
# stay above it.
PRODUCT_COPY_FILES += \
    $(DOLBY_PATH)/configs/media/media_codecs.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs.xml

# Dolby Vision encoder declaration. c2.dolby.encoder.hevc has to be in the parsed
# codec map or Codec2InfoBuilder drops it before it ever reaches the store, which
# is why Dolby Vision recording in MIUI Camera either crashes or writes nothing.
PRODUCT_COPY_FILES += \
    $(DOLBY_PATH)/configs/media/media_codecs_fuxi_dolby_vision.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_fuxi_dolby_vision.xml

# Inherit proprietary files
$(call inherit-product, vendor/xiaomi/sm8550-common-dolby/sm8550-common-dolby-vendor.mk)