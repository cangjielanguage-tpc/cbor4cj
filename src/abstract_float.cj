/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package cangjie_tpc::cbor4cj

public open class AbstractFloat <: Special {
    private let value: Float32

    public init(specialType: SpecialType, value: Float32) {
        super(specialType)
        this.value = value
    }

    public func getValue(): Float32 {
        return value
    }

    public override func equals(object: Object): Bool {
        if (object is AbstractFloat) {
            let other = (object as AbstractFloat).getOrThrow()
            return super.equals(object) && value == other.value
        }
        return false
    }
}

