/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package cangjie_tpc::cbor4cj

import std.io.InputStream

public class TagDecoder <: AbstractDecoder<Tag> {
    public init(decoder: CborDecoder, inputStream: InputStream) {
        super(decoder, inputStream)
    }

    public override func decode(initialByte: Int32): Tag {
        return Tag(getLength(initialByte))
    }
}

