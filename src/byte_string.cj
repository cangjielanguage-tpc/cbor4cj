/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package cangjie_tpc::cbor4cj


public class ByteString <: ChunkableDataItem {
    private let bytes: ?Array<UInt8>

    public init(bytes: ?Array<UInt8>) {
        super(MajorType.BYTE_STRING)
        if (bytes.isNone()) {
            this.bytes = None
        } else {
            this.bytes = bytes.getOrThrow()
        }
    }

    public func getBytes(): ?Array<UInt8> {
        if (bytes.isNone()) {
            return None
        } else {
            return bytes
        }
    }

    public override func equals(object: Object): Bool {
        if (object is ByteString) {
            let other = (object as ByteString).getOrThrow()
            return super.equals(object) && (bytes == other.bytes)
        }
        return false
    }
}

