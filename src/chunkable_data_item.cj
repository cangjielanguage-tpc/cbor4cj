/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package cangjie_tpc::cbor4cj


 public open class ChunkableDataItem <: DataItem {
    private var chunked = false

    public init(majorType: MajorType) {
        super(majorType)
    }

    public func isChunked(): Bool {
        return chunked
    }

    public func setChunked(chunked: Bool): ChunkableDataItem {
        this.chunked = chunked
        return this
    }

    public open func equals(object: Object): Bool {
        if (object is ChunkableDataItem) {
            let other = (object as ChunkableDataItem).getOrThrow()
            return super.equals(object) && chunked == other.chunked
        }
        return false
    }
}

