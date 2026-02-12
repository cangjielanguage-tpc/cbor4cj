/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package cangjie_tpc::cbor4cj

import std.io.OutputStream

public class UnsignedIntegerEncoder <: AbstractEncoder<UnsignedInteger> {
    public init(encoder: CborEncoder, outputStream: OutputStream) {
        super(encoder, outputStream)
    }

    public override func encode(dataItem: UnsignedInteger): Unit {
        encodeTypeAndLength(MajorType.UNSIGNED_INTEGER, dataItem.getValue())
    }
}
