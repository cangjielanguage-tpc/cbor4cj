/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package cangjie_tpc::cbor4cj


public class Tag <: DataItem {
    private let value: Int64

    public init(value: Int64) {
        super(MajorType.TAG)
        this.value = value
    }

    public func getValue(): Int64 {
        return value
    }

    public override func equals(object: Object): Bool {
        if (object is Tag) {
            let other = (object as Tag).getOrThrow()
            return super.equals(object) && value == other.value
        }
        return false
    }
}

