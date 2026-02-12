/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package cangjie_tpc::cbor4cj

import std.io.InputStream
import std.math.numeric.BigInt

public class NegativeIntegerDecoder <: AbstractDecoder<NegativeInteger> {
    private static let MINUS_ONE = BigInt(-1)

    public init(decoder: CborDecoder, inputStream: InputStream) {
        super(decoder, inputStream)
    }

    public override func decode(initialByte: Int32): NegativeInteger {
        return NegativeInteger(MINUS_ONE - (getLengthAsBigInteger(initialByte)))
    }
}

