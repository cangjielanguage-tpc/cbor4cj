/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package cangjie_tpc::cbor4cj

import std.math.numeric.BigInt

public class NegativeInteger <: Number {
    public init(value: Int64) {
        this(BigInt(value))
        if(value >= 0) {
            throw CborException("value " + value.toString() + " is not < 0")
        }
    }

    public init(value: BigInt) {
        super(MajorType.NEGATIVE_INTEGER, value)
    }
}

