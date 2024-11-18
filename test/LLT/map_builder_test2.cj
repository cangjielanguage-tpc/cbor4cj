// EXEC: cjc %import-path %L %l %f --test  
// EXEC: ./main

import std.unittest.*
import std.unittest.testmacro.*
import std.io.*
import cbor4cj.*

@Test
public class MapBuilderTest2 {
    @TestCase
    public func testMapBuilder(): Unit {
        var d = LanguageTaggedString("a", "t")
        d.getLanguage()
        d.getString()
    }

    @TestCase
    public func shouldDecodeZero() {
        var dataItems = [1];
        var outputStream = ByteArrayStream();
        CborEncoder(outputStream).encode(CborBuilder().add(1234).build());
        var data = ByteArrayStream()
        data.write(outputStream.bytes())
        CborDecoder(data).decode(impleDataItemListener())
    }

    @TestCase
    public func testDecoding() {
        var items =  CborBuilder()
            .addTag(38)
            .addArray().add("en").add("string").end().getOrThrow()
            .build();
        var baos = ByteArrayStream();
        var encoder = CborEncoder(baos);
        encoder.encode(items);
        var bais = ByteArrayStream();
        bais.write(baos.bytes())
        var decoder = CborDecoder(bais);
        var item = decoder.decodeNext();
        @Assert(LanguageTaggedString(UnicodeString("en"), UnicodeString("string")), item);
    }

    @TestCase
    public func decode() {
        var byte = AdditionalInformation.DIRECT
        byte.ordinal
        byte.compare(AdditionalInformation.DIRECT)
        byte.hashCode()
        byte.toString()
        byte==byte
        byte!=byte
    
    }
}

class impleDataItemListener <: DataItemListener {
    public func onDataItem(dataItem: DataItem) {
        @Assert(dataItem is UnsignedInteger)
    }
}
