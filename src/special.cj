/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package cangjie_tpc::cbor4cj

public open class Special <: DataItem {
    public static let BREAK: Special = Special(SpecialType.BREAK)

    private let specialType: SpecialType

    protected init(specialType: SpecialType) {
        super(MajorType.SPECIAL)
        this.specialType = specialType
    }

    public func getSpecialType(): SpecialType {
        return specialType
    }

    public override open func equals(object: Object): Bool {
        if (object is Special) {
            let other = (object as Special).getOrThrow()
            return super.equals(object) && refEq(specialType, other.specialType)
        }
        return false
    }
}

