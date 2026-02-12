/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package cangjie_tpc::cbor4cj

import std.io.InputStream


public class SpecialDecoder <: AbstractDecoder<Special> {
    private let halfPrecisionFloatDecoder: HalfPrecisionFloatDecoder

    private let singlePrecisionFloatDecoder: SinglePrecisionFloatDecoder

    private let doublePrecisionFloatDecoder: DoublePrecisionFloatDecoder

    public init(decoder: ?CborDecoder, inputStream: InputStream) {
        super(decoder, inputStream)
        this.halfPrecisionFloatDecoder = HalfPrecisionFloatDecoder(decoder, inputStream)
        this.singlePrecisionFloatDecoder = SinglePrecisionFloatDecoder(decoder, inputStream)
        this.doublePrecisionFloatDecoder = DoublePrecisionFloatDecoder(decoder, inputStream)
    }

    public override func decode(initialByte: Int32): Special {
        match (SpecialType.ofByte(initialByte).name) {
            case "BREAK" => return Special.BREAK
            case "SIMPLE_VALUE" => match (SimpleValueType.ofByte(initialByte).name) {
                case "FALSE" => return SimpleValue.FALSE
                case "TRUE" => return SimpleValue.TRUE
                case "NULL" => return SimpleValue.NULL
                case "UNDEFINED" => return SimpleValue.UNDEFINED
                case "UNALLOCATED" => return SimpleValue(initialByte & 31)
                case "RESERVED" => throw CborException("Not implemented")
                case _ => throw CborException("Not implemented")
            }
            case "IEEE_754_HALF_PRECISION_FLOAT" => return halfPrecisionFloatDecoder.decode(initialByte)
            case "IEEE_754_SINGLE_PRECISION_FLOAT" => return singlePrecisionFloatDecoder.decode(initialByte)
            case "IEEE_754_DOUBLE_PRECISION_FLOAT" => return doublePrecisionFloatDecoder.decode(initialByte)
            case "SIMPLE_VALUE_NEXT_BYTE" => return SimpleValue(nextSymbol())
            case "UNALLOCATED" => throw CborException("Not implemented")
            case _ => throw CborException("Not implemented")
        }
    }
}
