/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package cangjie_tpc::cbor4cj

import std.math.numeric.*

public abstract class Number <: DataItem {
    private let value: BigInt

    protected init(majorType: MajorType, value: BigInt) {
        super(majorType)
        this.value = value
    }

    public func getValue(): BigInt {
        return value
    }

    public override func equals(object: Object): Bool {
        if (object is Number) {
            let other = (object as Number).getOrThrow()
            return super.equals(object) && (value == other.value)
        }
        return false
    }
}

