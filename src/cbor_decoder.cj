/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package cangjie_tpc::cbor4cj

import std.collection.LinkedList
import std.collection.ArrayList
import std.io.IOException
import std.io.InputStream
import std.io.ByteBuffer

/**
 * Decoder for the CBOR format based.
 */
public class CborDecoder {
    private let inputStream: InputStream

    private var unsignedIntegerDecoder: ?UnsignedIntegerDecoder = None

    private var negativeIntegerDecoder: ?NegativeIntegerDecoder = None

    private var byteStringDecoder: ?ByteStringDecoder = None

    private var unicodeStringDecoder: ?UnicodeStringDecoder = None

    private var arrayDecoder: ?ArrayDecoder = None

    private var mapDecoder: ?MapDecoder = None

    private var tagDecoder: ?TagDecoder = None

    private var specialDecoder: ?SpecialDecoder = None

    private var autoDecodeInfinitiveArrays = true

    private var autoDecodeInfinitiveMaps = true

    private var autoDecodeInfinitiveByteStrings = true

    private var autoDecodeInfinitiveUnicodeStrings = true

    private var autoDecodeRationalNumbers = true

    private var autoDecodeLanguageTaggedStrings = true

    private var rejectDuplicateKeys = false

    public init(inputStream: InputStream) {
        //Objects.requireNonNull(inputStream)
        this.inputStream = inputStream
        unsignedIntegerDecoder = UnsignedIntegerDecoder(this, inputStream)
        unsignedIntegerDecoder = UnsignedIntegerDecoder(this, inputStream)
        unsignedIntegerDecoder = UnsignedIntegerDecoder(this, inputStream)
        negativeIntegerDecoder = NegativeIntegerDecoder(this, inputStream)
        byteStringDecoder = ByteStringDecoder(this, inputStream)
        unicodeStringDecoder = UnicodeStringDecoder(this, inputStream)
        arrayDecoder = ArrayDecoder(this, inputStream)
        mapDecoder = MapDecoder(this, inputStream)
        tagDecoder = TagDecoder(this, inputStream)
        specialDecoder = SpecialDecoder(this, inputStream)
    }

    /**
     * Convenience method to decode a byte array directly.
     *
     * @param bytes
     *            the CBOR encoded data
     * @return a list of {@link DataItem}s
     * @throws CborException
     *             if decoding failed
     */
    public static func decodeStatic(bytes: Array<UInt8>): LinkedList<DataItem> {
        var stream = ByteBuffer()
        stream.write(bytes)
        return CborDecoder(stream).decode()
    }

    /**
     * Decode the {@link InputStream} to a list of {@link DataItem}s.
     *
     * @return the list of {@link DataItem}s
     * @throws CborException
     *             if decoding failed
     */
    public func decode(): LinkedList<DataItem> {
        let dataItems = LinkedList<DataItem>()
        var dataItem: ?DataItem
        dataItem = decodeNext()
        while (dataItem.isSome()) {
            dataItems.addLast(dataItem.getOrThrow())
            dataItem = decodeNext()
        }
        return dataItems
    }

    /**
     * Streaming decoding of an input stream. On each decoded DataItem, the
     * callback listener is invoked.
     *
     * @param dataItemListener
     *            the callback listener
     * @throws CborException
     *             if decoding failed
     */
    public func decode(dataItemListener: DataItemListener): Unit {
        //Objects.requireNonNull(dataItemListener)
        var dataItem = decodeNext()
        while (dataItem.isNone() == false) {
            dataItemListener.onDataItem(dataItem.getOrThrow())
            dataItem = decodeNext()
        }
    }

    /**
     * Decodes exactly one DataItem from the input stream.
     *
     * @return a {@link DataItem} or null if end of stream has reached.
     * @throws CborException
     *             if decoding failed
     */
    public func decodeNext(): ?DataItem {
        let symbol: Int32
        var readbyte: Int64 = 0
        try {
            var arr = Array<UInt8>(1, repeat: 0)
            readbyte = inputStream.read(arr)
            symbol = Int32(arr[0])
        } catch (ioException: IOException) {
            throw CborException(ioException)
        }
        if (readbyte == 0) {
            return None
        }
       
        match (MajorType.ofByte(symbol).name) {
            case "ARRAY" => return arrayDecoder.getOrThrow().decode(symbol)
            case "BYTE_STRING" => return byteStringDecoder.getOrThrow().decode(symbol)
            case "MAP" => return mapDecoder.getOrThrow().decode(symbol)
            case "NEGATIVE_INTEGER" => return negativeIntegerDecoder.getOrThrow().decode(symbol)
            case "UNICODE_STRING" => return unicodeStringDecoder.getOrThrow().decode(symbol)
            case "UNSIGNED_INTEGER" => return unsignedIntegerDecoder.getOrThrow().decode(symbol)
            case "SPECIAL" => return specialDecoder.getOrThrow().decode(symbol)
            case "TAG" =>
                let tag = tagDecoder.getOrThrow().decode(symbol)
                let next = decodeNext()
                if (next.isNone()) {
                    throw CborException("Unexpected end of stream: tag without following data item.")
                } else {
                    if (autoDecodeRationalNumbers && tag.getValue() == 30) {
                        return decodeRationalNumber(next.getOrThrow())
                    } else if (autoDecodeLanguageTaggedStrings && tag.getValue() == 38) {
                        return decodeLanguageTaggedString(next.getOrThrow())
                    } else {
                        var itemToTag = next
                        while (itemToTag.getOrThrow().hasTag()) {
                            itemToTag = itemToTag.getOrThrow().getTag().getOrThrow()
                        }
                        itemToTag.getOrThrow().setTag(tag)
                        return next
                    }
                }
            case "INVALID" => throw CborException("Not implemented major type " + symbol.toString())
            case _ => throw CborException("Not implemented major type " + symbol.toString())
        }
    }

    private func decodeLanguageTaggedString(dataItem: DataItem): DataItem {
        if (!(dataItem is CborArray)) {
            throw CborException("Error decoding LanguageTaggedString: not an array")
        }
        let array = (dataItem as CborArray).getOrThrow()
        if (Int32(array.getDataItems().size) != 2) {
            throw CborException("Error decoding LanguageTaggedString: array size is not 2")
        }
        let languageDataItem = array.getDataItems()[0]
        if (!(languageDataItem is UnicodeString)) {
            throw CborException("Error decoding LanguageTaggedString: first data item is not an UnicodeString")
        }
        let stringDataItem = array.getDataItems()[1]
        if (!(stringDataItem is UnicodeString)) {
            throw CborException("Error decoding LanguageTaggedString: second data item is not an UnicodeString")
        }
        let language = (languageDataItem as UnicodeString).getOrThrow()
        let string = (stringDataItem as UnicodeString).getOrThrow()
        return LanguageTaggedString(language, string)
    }

    private func decodeRationalNumber(dataItem: DataItem): DataItem {
        if (!(dataItem is CborArray)) {
            throw CborException("Error decoding RationalNumber: not an array")
        }
        let array = (dataItem as CborArray).getOrThrow()
        if (Int32(array.getDataItems().size) != 2) {
            throw CborException("Error decoding RationalNumber: array size is not 2")
        }
        let numeratorDataItem = array.getDataItems()[0]
        if (!(numeratorDataItem is Number)) {
            throw CborException("Error decoding RationalNumber: first data item is not a number")
        }
        let denominatorDataItem = array.getDataItems()[1]
        if (!(denominatorDataItem is Number)) {
            throw CborException("Error decoding RationalNumber: second data item is not a number")
        }
        let numerator = (numeratorDataItem as Number).getOrThrow()
        let denominator = (denominatorDataItem as Number).getOrThrow()
        return RationalNumber(numerator, denominator)
    }

    public func isAutoDecodeInfinitiveArrays(): Bool {
        return autoDecodeInfinitiveArrays
    }

    public func setAutoDecodeInfinitiveArrays(autoDecodeInfinitiveArrays: Bool): Unit {
        this.autoDecodeInfinitiveArrays = autoDecodeInfinitiveArrays
    }

    public func isAutoDecodeInfinitiveMaps(): Bool {
        return autoDecodeInfinitiveMaps
    }

    public func setAutoDecodeInfinitiveMaps(autoDecodeInfinitiveMaps: Bool): Unit {
        this.autoDecodeInfinitiveMaps = autoDecodeInfinitiveMaps
    }

    public func isAutoDecodeInfinitiveByteStrings(): Bool {
        return autoDecodeInfinitiveByteStrings
    }

    public func setAutoDecodeInfinitiveByteStrings(autoDecodeInfinitiveByteStrings: Bool): Unit {
        this.autoDecodeInfinitiveByteStrings = autoDecodeInfinitiveByteStrings
    }

    public func isAutoDecodeInfinitiveUnicodeStrings(): Bool {
        return autoDecodeInfinitiveUnicodeStrings
    }

    public func setAutoDecodeInfinitiveUnicodeStrings(autoDecodeInfinitiveUnicodeStrings: Bool): Unit {
        this.autoDecodeInfinitiveUnicodeStrings = autoDecodeInfinitiveUnicodeStrings
    }

    public func isAutoDecodeRationalNumbers(): Bool {
        return autoDecodeRationalNumbers
    }

    public func setAutoDecodeRationalNumbers(autoDecodeRationalNumbers: Bool): Unit {
        this.autoDecodeRationalNumbers = autoDecodeRationalNumbers
    }

    public func isAutoDecodeLanguageTaggedStrings(): Bool {
        return autoDecodeLanguageTaggedStrings
    }

    public func setAutoDecodeLanguageTaggedStrings(autoDecodeLanguageTaggedStrings: Bool): Unit {
        this.autoDecodeLanguageTaggedStrings = autoDecodeLanguageTaggedStrings
    }

    public func isRejectDuplicateKeys(): Bool {
        return rejectDuplicateKeys
    }

    public func setRejectDuplicateKeys(rejectDuplicateKeys: Bool): Unit {
        this.rejectDuplicateKeys = rejectDuplicateKeys
    }
}

