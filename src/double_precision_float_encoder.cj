/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package cangjie_tpc::cbor4cj

import std.io.OutputStream

public class DoublePrecisionFloatEncoder <: AbstractEncoder<DoublePrecisionFloat> {
    public init(encoder: ?CborEncoder, outputStream: OutputStream) {
        super(encoder, outputStream)
    }

    public override func encode(dataItem: DoublePrecisionFloat): Unit {
        write((7 << 5) | 27)
        let bits = dataItem.getValue().toBits()
        write(Int32(((bits >> 56)) & 0xFF))
        write(Int32(((bits >> 48)) & 0xFF))
        write(Int32(((bits >> 40)) & 0xFF))
        write(Int32(((bits >> 32)) & 0xFF))
        write(Int32(((bits >> 24)) & 0xFF))
        write(Int32(((bits >> 16)) & 0xFF))
        write(Int32(((bits >> 8)) & 0xFF))
        write(Int32(((bits >> 0)) & 0xFF))
    }
}

