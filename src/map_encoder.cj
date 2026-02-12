/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package cangjie_tpc::cbor4cj

import std.io.ByteBuffer
import std.io.readToEnd
import std.io.OutputStream
import std.collection.TreeMap

public class MapEncoder <: AbstractEncoder<CborMap> {
    public init(encoder: CborEncoder, outputStream: OutputStream) {
        super(encoder, outputStream)
    }

    public override func encode(map: CborMap): Unit {
        let keys = map.getKeys()
        if (map.isChunked()) {
            encodeTypeChunked(MajorType.MAP)
        } else {
            encodeTypeAndLength(MajorType.MAP, keys.size)
        }
        if (keys.isEmpty()) {
            return
        }
        if (map.isChunked()) {
            for (key in keys) {
                encoder.getOrThrow().encode(key)
                encoder.getOrThrow().encode(map.get(key))
            }
            encoder.getOrThrow().encode(SimpleValue.BREAK)
            return
        }
        let sortedMap = TreeMap<CborMapKeyBytes, Array<Byte>>()
        var byteArrayOutputStream = ByteBuffer()
        let e = CborEncoder(byteArrayOutputStream)
        for (key in keys) {
            e.encode(key)
            let keyBytes: Array<UInt8> = byteArrayOutputStream.bytes()
            readToEnd(byteArrayOutputStream)
            e.encode(map.get(key))
            let valueBytes: Array<UInt8> = byteArrayOutputStream.bytes()
            readToEnd(byteArrayOutputStream)
            sortedMap.add(CborMapKeyBytes(keyBytes), valueBytes)
        }
        for (entry in sortedMap) {
            write(entry[0].arr)
            write(entry[1])
        }
    }
}

class CborMapKeyBytes {
    var arr: Array<Byte>
    init(arr: Array<Byte>) {
        this.arr = arr
    }
}

extend CborMapKeyBytes <: Comparable<CborMapKeyBytes> {
    public operator func ==(rhs: CborMapKeyBytes): Bool {
        return compare(rhs) == Ordering.EQ
    }

    public operator func !=(rhs: CborMapKeyBytes): Bool {
        return compare(rhs) != Ordering.EQ
    }

    public operator func >(rhs: CborMapKeyBytes): Bool {
        return compare(rhs) == Ordering.LT
    }

    public operator func <(rhs: CborMapKeyBytes): Bool {
        return compare(rhs) == Ordering.GT
    }

    public operator func >=(rhs: CborMapKeyBytes): Bool {
        if (compare(rhs) == Ordering.GT) {
            return true
        }
        if (compare(rhs) == Ordering.EQ) {
            return true
        }
        return false
    }

    public operator func <=(rhs: CborMapKeyBytes): Bool {
        if (compare(rhs) == Ordering.LT) {
            return true
        }
        if (compare(rhs) == Ordering.EQ) {
            return true
        }
        return false
    }

    public func compare(that: CborMapKeyBytes): Ordering {
        if (Int32(this.arr.size) < Int32(that.arr.size)) {
            return Ordering.LT
        }
        if (Int32(this.arr.size) > Int32(that.arr.size)) {
            return Ordering.GT
        }
        var i: Int32 = 0
        while (i < Int32(this.arr.size)) {
            if (this.arr[Int64(i)] < that.arr[Int64(i)]) {
                return Ordering.LT
            }
            if (this.arr[Int64(i)] > that.arr[Int64(i)]) {
                return Ordering.GT
            }
            i++
        }
        return Ordering.EQ
    }
}
