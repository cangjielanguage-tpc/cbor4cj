/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package cangjie_tpc::cbor4cj

import std.io.OutputStream

public class ArrayEncoder <: AbstractEncoder<CborArray> {
    public init(encoder: CborEncoder, outputStream: OutputStream) {
        super(encoder, outputStream)
    }

    public override func encode(array: CborArray): Unit {
        let dataItems = array.getDataItems()
        if (array.isChunked()) {
            encodeTypeChunked(MajorType.ARRAY)
        } else {
            encodeTypeAndLength(MajorType.ARRAY, dataItems.size)
        }
        for (dataItem in dataItems) {
            encoder.getOrThrow().encode(dataItem)
        }
    }
}
