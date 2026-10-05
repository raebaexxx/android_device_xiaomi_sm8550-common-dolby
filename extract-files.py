#!/usr/bin/env -S PYTHONPATH=../../../tools/extract-utils python3
#
# SPDX-FileCopyrightText: 2024 The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

from extract_utils.fixups_blob import (
    blob_fixup,
    blob_fixups_user_type,
)
from extract_utils.main import (
    ExtractUtils,
    ExtractUtilsModule,
)

namespace_imports = [
    'device/xiaomi/sm8550-common',
    'hardware/qcom-caf/sm8550',
    'hardware/xiaomi',
]

# The Dolby HEVC blobs build a GraphicBuffer-sized object with operator new
# right after UnwrapNativeCodec2GrallocHandle, and reserve 0x100 bytes for it:
#
#     mov  x20, x0            <- unwrapped handle
#     mov  w0, #0x100         <- size passed to operator new
#     bl   _Znwm
#
# Current libui writes that object through offset 0xd28, so 256 bytes overrun the
# heap. That is what crashes MIUI Camera when Dolby Vision recording is enabled:
# the corruption happens while Dolby metadata is generated and while EGL runs.
# Reserving 0x1000 instead fixes it.
#
# The pattern is the mov plus the following operator new call so it stays unique.
# c2.dolby.hevc.enc.so also contains an unrelated "mov w0, #0x100" at 0x1d4c8
# that belongs to C2AndroidMemoryUsage::FromGrallocUsage; a bare 4-byte pattern
# would corrupt it, so do not shorten this.
GRAPHICBUFFER_ALLOC_ENCODER = (b'\x00\x20\x80\x52\x03\x42\x00\x94',
                               b'\x00\x00\x82\x52\x03\x42\x00\x94')
GRAPHICBUFFER_ALLOC_DECODER = (b'\x00\x20\x80\x52\x74\x54\x00\x94',
                               b'\x00\x00\x82\x52\x74\x54\x00\x94')

blob_fixups: blob_fixups_user_type = {
    'vendor/lib64/c2.dolby.client.so' : blob_fixup()
        .add_needed('dolbycodec_shim.so'),
    'vendor/lib64/c2.dolby.hevc.enc.so' : blob_fixup()
        .binary_regex_replace(*GRAPHICBUFFER_ALLOC_ENCODER),
    'vendor/lib64/c2.dolby.hevc.dec.so' : blob_fixup()
        .binary_regex_replace(*GRAPHICBUFFER_ALLOC_DECODER),
    'vendor/lib64/c2.dolby.hevc.sec.dec.so' : blob_fixup()
        .binary_regex_replace(*GRAPHICBUFFER_ALLOC_DECODER),
}  # fmt: skip

module = ExtractUtilsModule(
    'sm8550-common-dolby',
    'xiaomi',
    blob_fixups=blob_fixups,
    namespace_imports=namespace_imports,
)

if __name__ == '__main__':
    utils = ExtractUtils.device(module)
    utils.run()