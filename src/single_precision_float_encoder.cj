/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package cangjie_tpc::cbor4cj

import std.io.OutputStream

public class SinglePrecisionFloatEncoder <: AbstractEncoder<SinglePrecisionFloat> {
    public init(encoder: ?CborEncoder, outputStream: OutputStream) {
        super(encoder, outputStream)
    }
    
    @OverflowWrapping
    public func encode(dataItem: SinglePrecisionFloat): Unit {
        write((7 << 5) | 26)
        let bits = Int32(dataItem.getValue().toBits())
        write((bits >> 24) & 0xFF)
        write((bits >> 16) & 0xFF)
        write((bits >> 8) & 0xFF)
        write((bits >> 0) & 0xFF)
    }
}

