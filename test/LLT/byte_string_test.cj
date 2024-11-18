// EXEC: cjc %import-path %L %l %f --test  
// EXEC: ./main

import std.unittest.*
import std.unittest.testmacro.*
import std.io.ByteArrayStream
import cbor4cj.*

@Test
public class ByteStringTest {
    @TestCase
    public func testByteString(): Unit {
        shouldEncodeAndDecode("1-byte array", ByteString([0]))
    }

    @TestCase
    public func testUnicodeString(): Unit {
        shouldEncodeAndDecode("string", UnicodeString("hello world"))
    }

    @TestCase
    public func shouldEquals(): Unit {
        let bytes: Array<UInt8> = "string".toArray()
        let byteString = ByteString(bytes)
        @Assert(byteString.equals(byteString))
    }

    @TestCase
    public func shouldNotEquals(): Unit {
        let bytes: Array<UInt8> = "string".toArray()
        let byteString = ByteString(bytes)
        @Assert(!byteString.equals(Object()))
    }

    @TestCase
    public func shouldNotClone(): Unit {
        let bytes: Array<UInt8> = "see issue #18".toArray()
        let byteString = ByteString(bytes)
        @Assert(byteString.getBytes(), bytes)
    }

    protected func shouldEncodeAndDecode(message: String, dataItem: DataItem) {
        var byteArrayOutputStream = ByteArrayStream();
        var encoder = CborEncoder(byteArrayOutputStream);
        encoder.encode(dataItem);
        var bytes = byteArrayOutputStream.bytes();
        var object: DataItem = CborDecoder.decodeStatic(bytes).first.getOrThrow()
        @Assert(dataItem, object)
    }
}
