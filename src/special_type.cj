/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package cangjie_tpc::cbor4cj

import std.reflect.ClassTypeInfo
import std.reflect.TypeInfo

public class SpecialType <: Enum<SpecialType> {
    public static let SIMPLE_VALUE: SpecialType = SpecialType("SIMPLE_VALUE", 0)

    public static let SIMPLE_VALUE_NEXT_BYTE: SpecialType = SpecialType("SIMPLE_VALUE_NEXT_BYTE", 1)

    public static let IEEE_754_HALF_PRECISION_FLOAT: SpecialType = SpecialType("IEEE_754_HALF_PRECISION_FLOAT", 2)

    public static let IEEE_754_SINGLE_PRECISION_FLOAT: SpecialType = SpecialType("IEEE_754_SINGLE_PRECISION_FLOAT", 3)

    public static let IEEE_754_DOUBLE_PRECISION_FLOAT: SpecialType = SpecialType("IEEE_754_DOUBLE_PRECISION_FLOAT", 4)

    public static let UNALLOCATED: SpecialType = SpecialType("UNALLOCATED", 5)

    public static let BREAK: SpecialType = SpecialType("BREAK", 6)

    private init(_enum_name: String, _enum_ordinal: Int32) {
        super(_enum_name, _enum_ordinal)
    }

    public static func ofByte(b: Int32): SpecialType {
        match (b & 31) {
            case 24 => return SIMPLE_VALUE_NEXT_BYTE
            case 25 => return IEEE_754_HALF_PRECISION_FLOAT
            case 26 => return IEEE_754_SINGLE_PRECISION_FLOAT
            case 27 => return IEEE_754_DOUBLE_PRECISION_FLOAT
            case 28 | 29 | 30 => return UNALLOCATED
            case 31 => return BREAK
            case _ => return SIMPLE_VALUE
        }
    }
}
