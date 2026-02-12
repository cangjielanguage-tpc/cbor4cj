/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package cangjie_tpc::cbor4cj

import std.collection.ArrayList
import std.io.OutputStream

/**
 * Encoder for the CBOR format based.
 */
public class CborEncoder {
    private var unsignedIntegerEncoder: ?UnsignedIntegerEncoder = None

    private var negativeIntegerEncoder: ?NegativeIntegerEncoder = None

    private var byteStringEncoder: ?ByteStringEncoder = None

    private var unicodeStringEncoder: ?UnicodeStringEncoder = None

    private var arrayEncoder: ?ArrayEncoder = None

    private var mapEncoder: ?MapEncoder = None

    private var tagEncoder: ?TagEncoder = None

    private var specialEncoder: ?SpecialEncoder = None

    public init(outputStream: OutputStream) {
        //Objects.requireNonNull(outputStream)
        unsignedIntegerEncoder = UnsignedIntegerEncoder(this, outputStream)
        negativeIntegerEncoder = NegativeIntegerEncoder(this, outputStream)
        byteStringEncoder = ByteStringEncoder(this, outputStream)
        unicodeStringEncoder = UnicodeStringEncoder(this, outputStream)
        arrayEncoder = ArrayEncoder(this, outputStream)
        mapEncoder = MapEncoder(this, outputStream)
        tagEncoder = TagEncoder(this, outputStream)
        specialEncoder = SpecialEncoder(this, outputStream)
    }

    /**
     * Encode a list of {@link DataItem}s, also known as a stream.
     *
     * @param dataItems
     *            a list of {@link DataItem}s
     * @throws CborException
     *             if the {@link DataItem}s could not be encoded or there was an
     *             problem with the {@link OutputStream}.
     */
    public func encode(dataItems: Collection<DataItem>): Unit {
        for (dataItem in dataItems) {
            encode(dataItem)
        }
    }

    /**
     * Encode a single {@link DataItem}.
     *
     * @param dataItem
     *            the {@link DataItem} to encode. If null, encoder encodes a
     *            {@link SimpleValue} NULL value.
     * @throws CborException
     *             if {@link DataItem} could not be encoded or there was an
     *             problem with the {@link OutputStream}.
     */
    public func encode(dataItem: ?DataItem): Unit {
        var tempdataItem = dataItem
        if (tempdataItem.isNone()) {
            tempdataItem = SimpleValue.NULL
        }
        if (tempdataItem.getOrThrow().hasTag()) {
            let tagDi = tempdataItem.getOrThrow().getTag()
            tagEncoder.getOrThrow().encode(tagDi.getOrThrow())
        }
        match (tempdataItem.getOrThrow().getMajorType().name) {
            case "UNSIGNED_INTEGER" => unsignedIntegerEncoder.getOrThrow().encode(
                (tempdataItem.getOrThrow() as UnsignedInteger).getOrThrow())
            case "NEGATIVE_INTEGER" => negativeIntegerEncoder.getOrThrow().encode(
                (tempdataItem.getOrThrow() as NegativeInteger).getOrThrow())
            case "BYTE_STRING" => byteStringEncoder.getOrThrow().encode(
                (tempdataItem.getOrThrow() as ByteString).getOrThrow())
            case "UNICODE_STRING" => unicodeStringEncoder.getOrThrow().encode(
                (tempdataItem.getOrThrow() as UnicodeString).getOrThrow())
            case "ARRAY" => arrayEncoder.getOrThrow().encode((tempdataItem.getOrThrow() as CborArray).getOrThrow())
            case "MAP" => mapEncoder.getOrThrow().encode((tempdataItem.getOrThrow() as CborMap).getOrThrow())
            case "SPECIAL" => specialEncoder.getOrThrow().encode((tempdataItem.getOrThrow() as Special).getOrThrow())
            case "TAG" => tagEncoder.getOrThrow().encode((tempdataItem.getOrThrow() as Tag).getOrThrow())
            case _ => throw CborException("Unknown major type")
        }
    }
}
