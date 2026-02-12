/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package cangjie_tpc::cbor4cj

import std.reflect.*

public class AdditionalInformation <: Enum<AdditionalInformation>{
    public static let DIRECT: AdditionalInformation = AdditionalInformation("DIRECT", 0, 0)

    public static let ONE_BYTE: AdditionalInformation = AdditionalInformation("ONE_BYTE", 1, 24)

    public static let TWO_BYTES: AdditionalInformation = AdditionalInformation("TWO_BYTES", 2, 25)

    public static let FOUR_BYTES: AdditionalInformation = AdditionalInformation("FOUR_BYTES", 3, 26)

    public static let EIGHT_BYTES: AdditionalInformation = AdditionalInformation("EIGHT_BYTES", 4, 27)

    public static let RESERVED: AdditionalInformation = AdditionalInformation("RESERVED", 5, 28)

    public static let INDEFINITE: AdditionalInformation = AdditionalInformation("INDEFINITE", 6, 31)

    private let value: Int32

    private init(_enum_name: String, _enum_ordinal: Int32, value: Int32) {
        super(_enum_name, _enum_ordinal)
        this.value = value
    }

    public func getValue(): Int32 {
        return value
    }

    public static func ofByte(b: Int32): AdditionalInformation {
        match (b & 31) {
            case 24 => return ONE_BYTE
            case 25 => return TWO_BYTES
            case 26 => return FOUR_BYTES
            case 27 => return EIGHT_BYTES
            case 28 | 29 | 30 => return RESERVED
            case 31 => return INDEFINITE
            case _ => return DIRECT
        }
    }
}

public abstract class Enum<E> <: Equatable<E> & Hashable & ToString where E <: Enum<E> {
    private let name_value: String
    private let ordinal_value: Int32

    protected init(name: String, ordinal: Int32) {
        this.name_value = name
        this.ordinal_value = ordinal
    }

    public prop name: String {
        get() {
            name_value
        }
    }

    public prop ordinal: Int32 {
        get() {
            ordinal_value
        }
    }

    public open func compare(rhs: E): Ordering {
        this.ordinal.compare(rhs.ordinal)
    }

    public open func hashCode(): Int64 {
        ordinal_value.hashCode()
    }

    public open func toString(): String {
        name_value
    }

    public open operator func == (that: E): Bool {
        refEq(this, that)
    }

    public open operator func != (that: E): Bool {
        !(this == that)
    }
}

