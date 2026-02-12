/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package cangjie_tpc::cbor4cj

import std.io.ByteBuffer
import std.io.InputStream

public class ByteStringDecoder <: AbstractDecoder<ByteString> {
    public init(decoder: CborDecoder, inputStream: InputStream) {
        super(decoder, inputStream)
    }

    public override func decode(initialByte: Int32): ByteString {
        let length = getLength(initialByte)
        if (length == Int64(INFINITY)) {
            if (decoder.getOrThrow().isAutoDecodeInfinitiveByteStrings()) {
                return decodeInfinitiveLength()
            } else {
                let byteString = ByteString(None)
                byteString.setChunked(true)
                return byteString
            }
        } else {
            return decodeFixedLength(length)
        }
    }

    private func decodeInfinitiveLength(): ByteString {
        let bytes = ByteBuffer()
        while (true) {
            let dataItem = decoder.getOrThrow().decodeNext()
            if (dataItem.isNone()) {
                throw CborException("Unexpected end of stream")
            }
            let majorType = dataItem.getOrThrow().getMajorType()
            if (Special.BREAK.equals(dataItem.getOrThrow())) {
                break
            } else if (refEq(majorType, MajorType.BYTE_STRING)) {
                let byteString = dataItem.getOrThrow() as ByteString
                let byteArray = byteString.getOrThrow().getBytes()
                if (let Some(v) <- byteArray) {
                    bytes.write(v)
                }
            } else {
                throw CborException("Unexpected major type " + majorType.toString())
            }
        }
        return ByteString(bytes.bytes())
    }

    private func decodeFixedLength(length: Int64): ByteString {
        let bytes = ByteBuffer(length)
        var i = 0
        while (i < length) {
            bytes.write(UInt8(nextSymbol()))
            i++
        }
        return ByteString(bytes.bytes())
    }
}

