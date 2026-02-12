/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package cangjie_tpc::cbor4cj

public class DoublePrecisionFloat <: Special {
    private let value: Float64

    public init(value: Float64) {
        super(SpecialType.IEEE_754_DOUBLE_PRECISION_FLOAT)
        this.value = value
    }

    public func getValue(): Float64 {
        return value
    }

    public override func equals(object: Object): Bool {
        if (object is DoublePrecisionFloat) {
            let other = (object as DoublePrecisionFloat).getOrThrow()
            return super.equals(object) && value == other.value
        }
        return false
    }
}

