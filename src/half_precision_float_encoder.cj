/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package cangjie_tpc::cbor4cj

import std.io.OutputStream

public open class HalfPrecisionFloatEncoder <: AbstractEncoder<HalfPrecisionFloat> {
    public init(encoder: ?CborEncoder, outputStream: OutputStream) {
        super(encoder, outputStream)
    }

    public open func encode(dataItem: HalfPrecisionFloat): Unit {
        write(((7 << 5)) | 25)
        let bits = fromFloat(dataItem.getValue())
        write(((bits >> 8)) & 0xFF)
        write(((bits >> 0)) & 0xFF)
    }

    public static func fromFloat(fval: Float32): Int32 {
        let fbits = fval.toBits()
        let sign = (fbits >> 16) & 0x8000 // >>>
        var val = 0x1000 + fbits & 0x7fffffff
        if (val >= 0x47800000) {
            if ((fbits & 0x7fffffff) >= 0x47800000) {
                if (val < 0x7f800000) {
                    return Int32(sign) | 0x7c00
                }
                return Int32(sign) | 0x7c00 | Int32((fbits & 0x007fffff) >> 13) // >>>
            }
            return Int32(sign) | 0x7bff
        }
        if (val >= 0x38800000) {
            return Int32(sign) | Int32((val - 0x38000000 >> 13)) // >>>
        }
        if (val < 0x33000000) {
            return Int32(sign)
        }
        val = ((fbits & 0x7fffffff) >> 23) // >>>
        return Int32(sign) | Int32((((fbits & 0x7fffff | 0x800000) + ((0x800000 >> val - 102)) >> 126 - val))) // >>>
    }
}

