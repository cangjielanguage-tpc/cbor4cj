/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package cangjie_tpc::cbor4cj

import std.io.InputStream

public class ArrayDecoder <: AbstractDecoder<CborArray> {
    public init(decoder: CborDecoder, inputStream: InputStream) {
        super(decoder, inputStream)
    }

    public override func decode(initialByte: Int32): CborArray {
        let length = getLength(initialByte)
        if (length == Int64(INFINITY)) {
            return decodeInfinitiveLength()
        } else {
            return decodeFixedLength(length)
        }
    }

    private func decodeInfinitiveLength(): CborArray {
        let array = CborArray()
        array.setChunked(true)
        if (decoder.getOrThrow().isAutoDecodeInfinitiveArrays()) {
            var dataItem: ?DataItem
            while (true) {
                dataItem = decoder.getOrThrow().decodeNext()
                if (dataItem.isNone()) {
                    throw CborException("Unexpected end of stream")
                }
                if (Special.BREAK.equals(dataItem.getOrThrow())) {
                    array.add(Special.BREAK)
                    break
                }
                array.add(dataItem.getOrThrow())
            }
        }
        return array
    }

    private func decodeFixedLength(length: Int64): CborArray {
        let array = CborArray()
        var i = 0
        while (i < length) {
            let dataItem = decoder.getOrThrow().decodeNext()
            if (dataItem.isNone()) {
                throw CborException("Unexpected end of stream")
            }
            array.add(dataItem.getOrThrow())
            i++
        }
        return array
    }
}

