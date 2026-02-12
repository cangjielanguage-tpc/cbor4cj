/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package cangjie_tpc::cbor4cj

import std.math.numeric.*
import std.io.OutputStream

public class NegativeIntegerEncoder <: AbstractEncoder<NegativeInteger> {
    private static let MINUS_ONE = BigInt(-1)

    public init(encoder: CborEncoder, outputStream: OutputStream) {
        super(encoder, outputStream)
    }

    public override func encode(dataItem: NegativeInteger): Unit {
        encodeTypeAndLength(MajorType.NEGATIVE_INTEGER, abs(MINUS_ONE - dataItem.getValue()))
    }
}

