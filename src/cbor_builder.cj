/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package cbor4cj

import std.collection.ArrayList
import std.collection.LinkedList
import std.math.numeric.BigInt

public class CborBuilder <: AbstractBuilder<CborBuilder> {
    private let dataItems = LinkedList<DataItem>()

    public init() {
        super(None)
    }

    public func reset(): CborBuilder {
        dataItems.clear()
        return this
    }

    public func build(): LinkedList<DataItem> {
        return dataItems
    }

    public func add(dataItem: DataItem): CborBuilder {
        dataItems.append(dataItem)
        return this
    }

    public func add(value: Int64): CborBuilder {
        add(convert(value))
        return this
    }

    public func add(value: BigInt): CborBuilder {
        add(convert(value))
        return this
    }

    public func add(value: Bool): CborBuilder {
        add(convert(value))
        return this
    }

    public func add(value: Float32): CborBuilder {
        add(convert(value))
        return this
    }

    public func add(value: Float64): CborBuilder {
        add(convert(value))
        return this
    }

    public func add(bytes: Array<UInt8>): CborBuilder {
        add(convert(bytes))
        return this
    }

    public func startByteString(): ByteStringBuilder<CborBuilder> {
        return startByteString(None)
    }

    public func startByteString(bytes: ?Array<UInt8>): ByteStringBuilder<CborBuilder> {
        add(ByteString(bytes).setChunked(true))
        return ByteStringBuilder<CborBuilder>(this)
    }

    public func add(string: String): CborBuilder {
        add(convert(string))
        return this
    }

    public func startString(): UnicodeStringBuilder<CborBuilder> {
        return startString(None)
    }

    public func startString(string: ?String): UnicodeStringBuilder<CborBuilder> {
        add(UnicodeString(string).setChunked(true))
        return UnicodeStringBuilder<CborBuilder>(this)
    }

    public func addTag(value: Int64): CborBuilder {
        add(tag(value))
        return this
    }

    public func startArray(): ArrayBuilder<CborBuilder> {
        let array = CborArray()
        array.setChunked(true)
        add(array)
        return ArrayBuilder<CborBuilder>(this, array)
    }

    public func addArray(): ArrayBuilder<CborBuilder> {
        let array = CborArray()
        add(array)
        return ArrayBuilder<CborBuilder>(this, array)
    }

    public func addMap(): MapBuilder<CborBuilder> {
        let map = CborMap()
        add(map)
        return MapBuilder<CborBuilder>(this, map)
    }

    public func startMap(): MapBuilder<CborBuilder> {
        let map = CborMap()
        map.setChunked(true)
        add(map)
        return MapBuilder<CborBuilder>(this, map)
    }

    protected override func addChunk(dataItem: ?DataItem): Unit {
        add(dataItem.getOrThrow())
    }
}
