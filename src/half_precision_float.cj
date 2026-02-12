/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package cangjie_tpc::cbor4cj

public class HalfPrecisionFloat <: AbstractFloat {
    public init(value: Float32) {
        super(SpecialType.IEEE_754_HALF_PRECISION_FLOAT, value)
    }
}

