/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package cangjie_tpc::cbor4cj

import std.io.OutputStream


public class ByteStringEncoder <: AbstractEncoder<ByteString> {
    public init(encoder: CborEncoder, outputStream: OutputStream) {
        super(encoder, outputStream)
    }

    public override func encode(byteString: ByteString): Unit {
        let bytes = byteString.getBytes() // )
        if (byteString.isChunked()) {
            encodeTypeChunked(MajorType.BYTE_STRING)
            if (bytes.isSome()) {
                encode(ByteString(bytes))
            }
        } else if (bytes.isNone()) {
            encoder.getOrThrow().encode(SimpleValue.NULL)
        } else {
            encodeTypeAndLength(MajorType.BYTE_STRING, bytes.getOrThrow().size)
            write(bytes.getOrThrow())
        }
    }
}
