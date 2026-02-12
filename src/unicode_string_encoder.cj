/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package cangjie_tpc::cbor4cj

import std.io.OutputStream

public class UnicodeStringEncoder <: AbstractEncoder<UnicodeString> {
    public init(encoder: CborEncoder, outputStream: OutputStream) {
        super(encoder, outputStream)
    }

    public override func encode(dataItem: UnicodeString): Unit {
        let string = dataItem.getString()
        if (dataItem.isChunked()) {
            encodeTypeChunked(MajorType.UNICODE_STRING)
            if (string.isNone() == false) {
                encode(UnicodeString(string))
            }
        } else if (string.isNone()) {
            encoder.getOrThrow().encode(SimpleValue.NULL)
        } else {
            let bytes: Array<UInt8>
            bytes = string.getOrThrow().toArray() // StandardCharsets.UTF_8)
            encodeTypeAndLength(MajorType.UNICODE_STRING, bytes.size)
            write(bytes)
        }
    }
}
