/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package cangjie_tpc::cbor4cj

import std.io.OutputStream

public class SpecialEncoder <: AbstractEncoder<Special> {
    private let halfPrecisionFloatEncoder: HalfPrecisionFloatEncoder

    private let singlePrecisionFloatEncoder: SinglePrecisionFloatEncoder

    private let doublePrecisionFloatEncoder: DoublePrecisionFloatEncoder

    public init(encoder: ?CborEncoder, outputStream: OutputStream) {
        super(encoder, outputStream)
        halfPrecisionFloatEncoder = HalfPrecisionFloatEncoder(encoder, outputStream)
        singlePrecisionFloatEncoder = SinglePrecisionFloatEncoder(encoder, outputStream)
        doublePrecisionFloatEncoder = DoublePrecisionFloatEncoder(encoder, outputStream)
    }

    public override func encode(dataItem: Special): Unit {
        match (dataItem.getSpecialType().name) {
            case "BREAK" => write(((7 << 5)) | 31)
            case "SIMPLE_VALUE" =>
                let simpleValue = (dataItem as SimpleValue).getOrThrow()
                match (simpleValue.getSimpleValueType().name) {
                    case "FALSE" | "NULL" | "TRUE" | "UNDEFINED" =>
                        let Type = simpleValue.getSimpleValueType()
                        write(((7 << 5)) | Type.getValue())
                    case "UNALLOCATED" => write(((7 << 5)) | simpleValue.getValue())
                    case "RESERVED" => ()
                    case _ => ()
                }
            case "UNALLOCATED" => throw CborException("Unallocated special type")
            case "IEEE_754_HALF_PRECISION_FLOAT" =>
                if (! (dataItem is HalfPrecisionFloat)) {
                    throw CborException("Wrong data item type")
                }
                halfPrecisionFloatEncoder.encode((dataItem as HalfPrecisionFloat).getOrThrow())
            case "IEEE_754_SINGLE_PRECISION_FLOAT" =>
                if (!(dataItem is SinglePrecisionFloat)) {
                    throw CborException("Wrong data item type")
                }
                singlePrecisionFloatEncoder.encode((dataItem as SinglePrecisionFloat).getOrThrow())
            case "IEEE_754_DOUBLE_PRECISION_FLOAT" =>
                if (!(dataItem is DoublePrecisionFloat)) {
                    throw CborException("Wrong data item type")
                }
                doublePrecisionFloatEncoder.encode((dataItem as DoublePrecisionFloat).getOrThrow())
            case "SIMPLE_VALUE_NEXT_BYTE" =>
                if (!(dataItem is SimpleValue)) {
                    throw CborException("Wrong data item type")
                }
                let simpleValueNextByte = (dataItem as SimpleValue).getOrThrow()
                write(((7 << 5)) | 24)
                write(simpleValueNextByte.getValue())
            case _ => ()
        }
    }
}

