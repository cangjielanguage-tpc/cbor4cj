// EXEC: cjc %import-path %L %l %f --test  
// EXEC: ./main

import std.unittest.*
import std.unittest.testmacro.*
import std.io.*
import cbor4cj.*
import std.math.numeric.BigInt

@Test
public class UnsignedIntegerTest {
    @TestCase
    public func shouldEncodeAndDecode(): Unit {
        let maxInteger = 4294967295
        var i = 0
        while (i < maxInteger) {
            shouldEncodeAndDecode(i.toString(), UnsignedInteger(i))
            i += (maxInteger / 100000)
        }
        shouldEncodeAndDecode(maxInteger.toString(), UnsignedInteger(maxInteger))
    }

    @TestCase
    public func shouldNotAcceptNegativeValues(): Unit {
        try {
            UnsignedInteger(-1)
        } catch (e: CborException) {
            return
        }
        @Assert(false)
    }

    @TestCase
    public func testEquals1(): Unit {
        let unsignedInteger = UnsignedInteger(BigInt(0))
        @Assert(unsignedInteger.equals(unsignedInteger))
    }

    @TestCase
    public func testEquals2(): Unit {
        var i = 0
        while (i < 256) {
            let unsignedInteger1 = UnsignedInteger(BigInt(Int64(i)))
            let unsignedInteger2 = UnsignedInteger(BigInt(Int64(i)))
            @Assert(unsignedInteger1.equals(unsignedInteger2))
            i++
        }
    }

    @TestCase
    public func testEquals3(): Unit {
        let unsignedInteger = UnsignedInteger(BigInt(0))
        @Assert(!unsignedInteger.equals(Object()))
    }

    @TestCase
    public func testHashcode(): Unit {
        let unsignedInteger = UnsignedInteger(BigInt(0))
        @Assert(BigInt(0).hashCode(), unsignedInteger.getValue().hashCode())
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
