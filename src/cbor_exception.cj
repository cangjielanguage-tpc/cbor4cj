/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package cangjie_tpc::cbor4cj

public class CborException <: Exception {
    public init(message: String) {
        super(message)
    }

    public init(cause: Exception) {
        super(cause.toString())
    }

    public init(message: String, cause: Exception) {
        super(message + " " + cause.toString())
    }

    public func toString(): String {
        return "CborException: " + message
    }
}

