/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package cangjie_tpc::cbor4cj

public open class DataItem <: Hashable & Equatable<DataItem> {
    private let majorType: MajorType

    private var tag: ?Tag = None

    protected init(majorType: MajorType) {
        this.majorType = majorType
    }

    public func getMajorType(): MajorType {
        return majorType
    }

    public func setTag(tag: Int32): Unit {
        if (tag < 0) {
            throw IllegalArgumentException("tag number must be 0 or greater")
        }
        this.tag = Tag(Int64(tag))
    }

    public func setTag(tag: Tag): Unit {
        this.tag = tag
    }

    public func removeTag(): Unit {
        tag = None
    }

    public func getTag(): ?Tag {
        return tag
    }

    public func hasTag(): Bool {
        return tag.isSome()
    }

    public open func equals(object: Object): Bool {
        if (object is DataItem) {
            let other = (object as DataItem).getOrThrow()
            if (tag.isNone() == false) {
                var tag = tag.getOrThrow()
                if(other.tag.isNone() == false) {
                    return tag.equals(other.tag.getOrThrow()) && refEq(majorType, other.majorType)
                }
            } else {
                return other.tag.isNone() && refEq(majorType, other.majorType)
            }
        }
        return false
    }

    public operator func ==(rhs: DataItem): Bool {
        return this.equals(rhs)
    }

    public operator func !=(rhs: DataItem): Bool {
        return !this.equals(rhs)
    }

    public open func hashCode(): Int64 {
        if (tag.isNone()) {
            return majorType.getValue().hashCode()
        }
        return (Int64(majorType.getValue()) + tag.getOrThrow().getValue()).hashCode()
    }
}
