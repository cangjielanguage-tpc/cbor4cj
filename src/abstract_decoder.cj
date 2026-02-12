/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package cangjie_tpc::cbor4cj

import std.io.IOException
import std.io.InputStream
import std.math.numeric.BigInt

public abstract class AbstractDecoder<T> {
    protected static let INFINITY = -1

    protected let inputStream: InputStream

    protected let decoder: ?CborDecoder

    public init(decoder: ?CborDecoder, inputStream: InputStream) {
        this.decoder = decoder
        this.inputStream = inputStream
    }

    public func decode(initialByte: Int32): T

    protected func nextSymbol(): Int32 {
        try {
            var arr = Array<UInt8>(1, repeat: 0)
            var readsize = inputStream.read(arr)
            let symbol = Int32(arr[0])
            if (readsize == 0) {
                throw Exception("Unexpected end of stream")
            }
            return Int32(symbol)
        } catch (ioException: IOException) {
            throw CborException(ioException)
        }
    }

    protected func getLength(initialByte: Int32): Int64 {
        match (AdditionalInformation.ofByte(initialByte).getValue()) {
            case 0 => return Int64(initialByte & 31)
            case 24 => return Int64(nextSymbol())
            case 25 =>
                var twoByteValue = 0
                twoByteValue |= Int64((nextSymbol() << 8))
                twoByteValue |= Int64((nextSymbol() << 0))
                return twoByteValue
            case 26 =>
                var fourByteValue = 0
                fourByteValue |= (Int64(nextSymbol()) << 24)
                fourByteValue |= (Int64(nextSymbol()) << 16)
                fourByteValue |= (Int64(nextSymbol()) << 8)
                fourByteValue |= (Int64(nextSymbol()) << 0)
                return fourByteValue
            case 27 =>
                var eightByteValue = 0
                eightByteValue |= (Int64(nextSymbol()) << 56)
                eightByteValue |= (Int64(nextSymbol()) << 48)
                eightByteValue |= (Int64(nextSymbol()) << 40)
                eightByteValue |= (Int64(nextSymbol()) << 32)
                eightByteValue |= (Int64(nextSymbol()) << 24)
                eightByteValue |= (Int64(nextSymbol()) << 16)
                eightByteValue |= (Int64(nextSymbol()) << 8)
                eightByteValue |= (Int64(nextSymbol()) << 0)
                return eightByteValue
            case 31 => return Int64(INFINITY)
            case 28 => throw CborException("Reserved additional information")
            case _ => throw CborException("Reserved additional information")
        }
    }

    protected func getLengthAsBigInteger(initialByte: Int32): BigInt {
        match (AdditionalInformation.ofByte(initialByte).getValue()) {
            case 0 => return BigInt(Int64(initialByte & 31))
            case 24 => return BigInt(Int64(nextSymbol()))
            case 25 =>
                var twoByteValue = 0
                twoByteValue |= Int64((nextSymbol() << 8))
                twoByteValue |= Int64((nextSymbol() << 0))
                return BigInt(twoByteValue)
            case 26 =>
                var fourByteValue = 0
                fourByteValue |= (Int64(nextSymbol()) << 24)
                fourByteValue |= (Int64(nextSymbol()) << 16)
                fourByteValue |= (Int64(nextSymbol()) << 8)
                fourByteValue |= (Int64(nextSymbol()) << 0)
                return BigInt(fourByteValue)
            case 27 =>
                var eightByteValue = BigInt(0)
                eightByteValue = eightByteValue | (BigInt(Int64(nextSymbol())) << (56))
                eightByteValue = eightByteValue | (BigInt(Int64(nextSymbol())) << (48))
                eightByteValue = eightByteValue | (BigInt(Int64(nextSymbol())) << (40))
                eightByteValue = eightByteValue | (BigInt(Int64(nextSymbol())) << (32))
                eightByteValue = eightByteValue | (BigInt(Int64(nextSymbol())) << (24))
                eightByteValue = eightByteValue | (BigInt(Int64(nextSymbol())) << (16))
                eightByteValue = eightByteValue | (BigInt(Int64(nextSymbol())) << (8))
                eightByteValue = eightByteValue | (BigInt(Int64(nextSymbol())) << (0))
                return eightByteValue
            case 31 => return BigInt(Int64(INFINITY))
            case 28 => throw CborException("Reserved additional information")
            case _ => throw CborException("Reserved additional information")
        }
    }
}
