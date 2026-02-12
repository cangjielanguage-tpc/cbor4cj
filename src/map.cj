/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package cangjie_tpc::cbor4cj

import std.collection.HashMap
import std.collection.LinkedList

public class CborMap <: ChunkableDataItem {
    private let map: HashMap<DataItem, DataItem>

    private let keys = LinkedList<DataItem>()

    public init() {
        super(MajorType.MAP)
        map = HashMap<DataItem, DataItem>()
    }

    public init(initialCapacity: Int32) {
        super(MajorType.MAP)
        map = HashMap<DataItem, DataItem>(Int64(initialCapacity))
    }

    public func put(key: DataItem, value: DataItem): CborMap {
        if (map.add(key, value).isNone()) {
            keys.addLast(key)
        }
        return this
    }

    public func get(key: DataItem): ?DataItem {
        return map.get(key)
    }

    public func remove(key: DataItem): ?DataItem {
        keys.removeIf({v: DataItem => return (key == v)})
        return map.remove(key)
    }

    public func getKeys(): Collection<DataItem> {
        return keys
    }

    public func getValues(): Collection<DataItem> {
        return map.values()
    }

    public override func equals(object: Object): Bool {
        if (object is CborMap) {
            let other = (object as CborMap).getOrThrow()
            return super.equals(object) && refEq(map, other.map)
        }
        return false
    }

    public override func hashCode(): Int64 {
        if (map.size != 0) {
            var result: Int64 = super.hashCode()
            for ((k, v) in map) {
                result = result ^ k.hashCode()
            }
            return result
        }
        return super.hashCode()
    }
}
