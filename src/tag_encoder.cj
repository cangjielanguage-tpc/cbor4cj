/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package cangjie_tpc::cbor4cj

import std.io.OutputStream

public class TagEncoder <: AbstractEncoder<Tag> {
    public init(encoder: CborEncoder, outputStream: OutputStream) {
        super(encoder, outputStream)
    }

    public override func encode(tag: Tag): Unit {
        encodeTypeAndLength(MajorType.TAG, tag.getValue())
    }
}

