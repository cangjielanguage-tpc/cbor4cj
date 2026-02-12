/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package cangjie_tpc::cbor4cj

import std.io.InputStream

public class MapDecoder <: AbstractDecoder<CborMap> {
    public init(decoder: CborDecoder, inputStream: InputStream) {
        super(decoder, inputStream)
    }

    public override func decode(initialByte: Int32): CborMap {
        let length = getLength(initialByte)
        if (length == Int64(INFINITY)) {
            return decodeInfinitiveLength()
        } else {
            return decodeFixedLength(length)
        }
    }

    private func decodeInfinitiveLength(): CborMap {
        let map = CborMap()
        map.setChunked(true)
        if (decoder.getOrThrow().isAutoDecodeInfinitiveMaps()) {
            while (true) {
                let key = decoder.getOrThrow().decodeNext()
                if (Special.BREAK.equals(key.getOrThrow())) {
                    break
                }
                let value = decoder.getOrThrow().decodeNext()
                if (key.isNone() || value.isNone()) {
                    throw CborException("Unexpected end of stream")
                }
                if (decoder.getOrThrow().isRejectDuplicateKeys() && map.get(key.getOrThrow()).isNone() == false) {
                    throw CborException("Duplicate key found in map")
                }
                map.put(key.getOrThrow(), value.getOrThrow())
            }
        }
        return map
    }

    private func decodeFixedLength(length: Int64): CborMap {
        let map = CborMap(Int32(length))
        var i = 0
        while (i < length) {
            let key = decoder.getOrThrow().decodeNext()
            let value = decoder.getOrThrow().decodeNext()
            if (key.isNone() || value.isNone()) {
                throw CborException("Unexpected end of stream")
            }
            if (decoder.getOrThrow().isRejectDuplicateKeys() && map.get(key.getOrThrow()).isNone() == false) {
                throw CborException("Duplicate key found in map")
            }
            map.put(key.getOrThrow(), value.getOrThrow())
            i++
        }
        return map
    }
}

