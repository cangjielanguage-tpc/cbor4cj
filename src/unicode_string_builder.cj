/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package cangjie_tpc::cbor4cj

public class UnicodeStringBuilder<T> <: AbstractBuilder<T> where T <: AbstractBuilder<T> {
    public init(parent: T) {
        super(parent)
    }

    public func add(string: String): UnicodeStringBuilder<T> {
        getParent().getOrThrow().addChunk(convert(string))
        return this
    }

    public func end(): ?T {
        getParent().getOrThrow().addChunk(SimpleValue.BREAK)
        return getParent()
    }
}
