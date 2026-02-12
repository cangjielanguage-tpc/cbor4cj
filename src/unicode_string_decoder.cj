/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package cangjie_tpc::cbor4cj

import std.io.InputStream
import std.io.ByteBuffer

public class UnicodeStringDecoder <: AbstractDecoder<UnicodeString> {
    public init(decoder: CborDecoder, inputStream: InputStream) {
        super(decoder, inputStream)
    }

    public override func decode(initialByte: Int32): UnicodeString {
        let length = getLength(initialByte)
        if (length == Int64(INFINITY)) {
            if (decoder.getOrThrow().isAutoDecodeInfinitiveUnicodeStrings()) {
                return decodeInfinitiveLength()
            } else {
                let unicodeString = UnicodeString(None)
                unicodeString.setChunked(true)
                return unicodeString
            }
        } else {
            return decodeFixedLength(length)
        }
    }

    private func decodeInfinitiveLength(): UnicodeString {
        let bytes = ByteBuffer()
        while (true) {
            let dataItem = decoder.getOrThrow().decodeNext()
            if (dataItem.isNone()) {
                throw CborException("Unexpected end of stream")
            }
            let majorType = dataItem.getOrThrow().getMajorType()
            if (Special.BREAK.equals(dataItem.getOrThrow())) {
                break
            } else if (refEq(majorType, MajorType.UNICODE_STRING)) {
                let unicodeString = dataItem.getOrThrow() as UnicodeString
                let byteArray = unicodeString.getOrThrow().toString().toArray() // StandardCharsets.UTF_8)
                bytes.write(byteArray)
            } else {
                throw CborException("Unexpected major type " + majorType.toString())
            }
        }
        return UnicodeString(String.fromUtf8(bytes.bytes()))
    }

    private func decodeFixedLength(length: Int64): UnicodeString {
        let bytes = ByteBuffer(length)
        var i = 0
        while (i < length) {
            bytes.write(UInt8(nextSymbol()))
            i++
        }
        return UnicodeString(String.fromUtf8(bytes.bytes()))
    }
}
