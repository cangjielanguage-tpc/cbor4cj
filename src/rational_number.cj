/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package cangjie_tpc::cbor4cj

import std.math.numeric.*

public class RationalNumber <: CborArray {
    public init(numerator: Number, denominator: Number) {
        super()
        setTag(30)
        if (denominator.getValue() == BigInt(0)) {
            throw CborException("Denominator is zero")
        }
        add(numerator)
        add(denominator)
    }

    public func getNumerator(): DataItem {
        return getDataItems()[0]
    }

    public func getDenominator(): DataItem {
        return getDataItems()[1]
    }
}

