/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package cangjie_tpc::cbor4cj

import std.io.IOException
import std.io.OutputStream
import std.math.numeric.BigInt

public abstract class AbstractEncoder<T> {
    private let outputStream: OutputStream

    protected let encoder: ?CborEncoder

    public init(encoder: ?CborEncoder, outputStream: OutputStream) {
        this.encoder = encoder
        this.outputStream = outputStream
    }

    public open func encode(dataItem: T): Unit

    protected func encodeTypeChunked(majorType: MajorType): Unit {
        var symbol = majorType.getValue() << 5 //shl(majorType.getValue(), 5)
        symbol |= AdditionalInformation.INDEFINITE.getValue()
        try {
            outputStream.write([UInt8(symbol)])
        } catch (ioException: IOException) {
            throw CborException(ioException)
        }
    }

    protected func encodeTypeAndLength(majorType: MajorType, length: Int64): Unit {
        var symbol = majorType.getValue() << 5
        if (length <= 23) {
            write(Int32(Int64(symbol) | length))
        } else if (length <= 0xFF) {
            symbol |= AdditionalInformation.ONE_BYTE.getValue()
            write(symbol)
            write(Int32(length))
        } else if (length <= 0xFFFF) {
            symbol |= AdditionalInformation.TWO_BYTES.getValue()
            write(symbol)
            write(Int32(length >> 8))
            write(Int32(length & 0xFF))
        } else if (length <= 0xFFFFFFFF) {
            symbol |= AdditionalInformation.FOUR_BYTES.getValue()
            write(symbol)
            write(Int32((length >> 24) & 0xFF))
            write(Int32((length >> 16) & 0xFF))
            write(Int32((length >> 8) & 0xFF))
            write(Int32(length & 0xFF))
        } else {
            symbol |= AdditionalInformation.EIGHT_BYTES.getValue()
            write(symbol)
            write(Int32((length >> 56) & 0xFF))
            write(Int32((length >> 48) & 0xFF))
            write(Int32((length >> 40) & 0xFF))
            write(Int32((length >> 32) & 0xFF))
            write(Int32((length >> 24) & 0xFF))
            write(Int32((length >> 16) & 0xFF))
            write(Int32((length >> 8) & 0xFF))
            write(Int32(length & 0xFF))
        }
    }

    protected func encodeTypeAndLength(majorType: MajorType, length: BigInt): Unit {
        let negative = refEq(majorType, MajorType.NEGATIVE_INTEGER)
        var symbol = majorType.getValue() << 5
        if (length.compare(BigInt(24)) == Ordering.LT) {
            write(symbol | length.toInt32())
        } else if (length.compare(BigInt(256)) == Ordering.LT) {
            symbol |= AdditionalInformation.ONE_BYTE.getValue()
            write(symbol)
            write(length.toInt32())
        } else if (length.compare(BigInt(65536)) == Ordering.LT) {
            symbol |= AdditionalInformation.TWO_BYTES.getValue()
            write(symbol)
            let twoByteValue = length.toInt64()
            write(Int32(twoByteValue >> 8))
            write(Int32(twoByteValue & 0xFF))
        } else if (length.compare(BigInt(4294967296)) == Ordering.LT) {
            symbol |= AdditionalInformation.FOUR_BYTES.getValue()
            write(symbol)
            let fourByteValue = length.toInt64()
            write(Int32((fourByteValue >> 24) & 0xFF))
            write(Int32((fourByteValue >> 16) & 0xFF))
            write(Int32((fourByteValue >> 8) & 0xFF))
            write(Int32(fourByteValue & 0xFF))
        } else if (length.compare(BigInt("18446744073709551616")) == Ordering.LT) {
            symbol |= AdditionalInformation.EIGHT_BYTES.getValue()
            write(symbol)
            let mask = BigInt(0xFF)
            write(((length >> 56) & mask).toInt32())
            write(((length >> 48) & mask).toInt32())
            write(((length >> 40) & mask).toInt32())
            write(((length >> 32) & mask).toInt32())
            write(((length >> 24) & mask).toInt32())
            write(((length >> 16) & mask).toInt32())
            write(((length >> 8) & mask).toInt32())
            write((length & mask).toInt32())
        } else {
            if (negative) {
                encoder.getOrThrow().encode(Tag(3))
            } else {
                encoder.getOrThrow().encode(Tag(2))
            }
            encoder.getOrThrow().encode(ByteString(length.toBytes()))
        }
    }

    @OverflowWrapping
    protected func write(b: Int32): Unit {
        try {
            outputStream.write([UInt8(b)])
        } catch (ioException: IOException) {
            throw CborException(ioException)
        }
    }

    protected func write(bytes: Array<UInt8>): Unit {
        try {
            outputStream.write(bytes)
        } catch (ioException: IOException) {
            throw CborException(ioException)
        }
    }
}
