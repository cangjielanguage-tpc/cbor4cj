/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package cangjie_tpc::cbor4cj

import std.io.InputStream
import std.math.*

public class HalfPrecisionFloatDecoder <: AbstractDecoder<HalfPrecisionFloat> {
    public init(decoder: ?CborDecoder, inputStream: InputStream) {
        super(decoder, inputStream)
    }

    public override func decode(_: Int32): HalfPrecisionFloat {
        let bits = (nextSymbol() << 8) | nextSymbol()
        return HalfPrecisionFloat(toFloat(bits))
    }

    private static func toFloat(bits: Int32): Float32 {
        let s = ((bits & 0x8000) >> 15)
        let e = ((bits & 0x7C00) >>  10)
        let f = bits & 0x03FF
        if (e == 0) {
            return Float32((if (s != 0) {  Float64(-1) } else { Float64(1) }) * pow(2.0, -14) * (Float64(f) / pow(2.0, 10)))
        } else if (e == 0x1F) {
            return if (f != 0) { Float32.NaN } else { (if (s != 0) { Float32(-1) } else { Float32(1) }) * Float32.Inf }
        }
        return Float32((if (s != 0) { Float64(-1)  } else { Float64(1) }) * pow(2.0, Float64(e - 15)) * (1.0 + Float64(f) / pow(2.0, 10)))
    }
}
