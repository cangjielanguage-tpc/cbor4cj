/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package cangjie_tpc::cbor4cj

public class SimpleValue <: Special {
    private let simpleValueType: SimpleValueType

    public static let FALSE: SimpleValue = SimpleValue(SimpleValueType.FALSE)

    public static let TRUE: SimpleValue = SimpleValue(SimpleValueType.TRUE)

    public static let NULL: SimpleValue = SimpleValue(SimpleValueType.NULL)

    public static let UNDEFINED: SimpleValue = SimpleValue(SimpleValueType.UNDEFINED)

    private let value: Int32

    public init(simpleValueType: SimpleValueType) {
        super(SpecialType.SIMPLE_VALUE)
        this.value = simpleValueType.getValue()
        this.simpleValueType = simpleValueType
    }

    public init(value: Int32) {
        super(if (value <= 23) { SpecialType.SIMPLE_VALUE } else { SpecialType.SIMPLE_VALUE_NEXT_BYTE })
        this.value = value
        this.simpleValueType = SimpleValueType.ofByte(value)
    }

    public func getSimpleValueType(): SimpleValueType {
        return simpleValueType
    }

    public func getValue(): Int32 {
        return value
    }

    public override func equals(object: Object): Bool {
        if (object is SimpleValue) {
            let other = (object as SimpleValue).getOrThrow()
            return super.equals(object) && value == other.value
        }
        return false
    }
}

