/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package cangjie_tpc::cbor4cj

public class LanguageTaggedString <: CborArray {
    public init(language: String, string: String) {
        this(UnicodeString(language), UnicodeString(string))
    }

    public init(language: UnicodeString, string: UnicodeString) {
        super()
        setTag(38)
        add(language)
        add(string)
    }

    public func getLanguage(): DataItem {
        return getDataItems()[0]
    }

    public func getString(): DataItem {
        return getDataItems()[1]
    }
}

