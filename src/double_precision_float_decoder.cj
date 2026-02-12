/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package cangjie_tpc::cbor4cj

import std.io.InputStream

public class DoublePrecisionFloatDecoder <: AbstractDecoder<DoublePrecisionFloat> {
    public init(decoder: ?CborDecoder, inputStream: InputStream) {
        super(decoder, inputStream)
    }
    
    @OverflowWrapping
    public override func decode(_: Int32): DoublePrecisionFloat {
        var bits = 0
        bits |= Int64(nextSymbol() & 0xFF)
        bits <<= 8
        bits |= Int64(nextSymbol() & 0xFF)
        bits <<= 8
        bits |= Int64(nextSymbol() & 0xFF)
        bits <<= 8
        bits |= Int64(nextSymbol() & 0xFF)
        bits <<= 8
        bits |= Int64(nextSymbol() & 0xFF)
        bits <<= 8
        bits |= Int64(nextSymbol() & 0xFF)
        bits <<= 8
        bits |= Int64(nextSymbol() & 0xFF)
        bits <<= 8
        bits |= Int64(nextSymbol() & 0xFF)
        return DoublePrecisionFloat(Float64.fromBits(UInt64(bits)))
    }
}

