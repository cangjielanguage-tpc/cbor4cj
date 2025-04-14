/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package cbor4cj

import std.collection.ArrayList

public open class CborArray <: ChunkableDataItem {
    private let objects: ArrayList<DataItem>

    public init() {
        super(MajorType.ARRAY)
        objects = ArrayList<DataItem>()
    }

    public func add(object: DataItem): CborArray {
        objects.prepend(object)
        return this
    }

    public func getDataItems(): ArrayList<DataItem> {
        return objects
    }

    public override func equals(object: Object): Bool {
        if (object is CborArray) {
            let other = (object as CborArray).getOrThrow()
            return super.equals(object) && (objects == other.objects)
        }
        return false
    }
}

