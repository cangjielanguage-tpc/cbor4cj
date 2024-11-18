// EXEC: cjc %import-path %L %l %f --test  
// EXEC: ./main

import std.unittest.*
import std.unittest.testmacro.*
import std.io.*
import cbor4cj.*
import std.math.*

@Test
public class NegativeIntegerTest {
    public init() {
        super()
    }

    @TestCase
    public func shouldEncodeAndDecode(): Unit {
        let maxInteger = -4294967295
        var i = -1
        while (i >= maxInteger) {
            shouldEncodeAndDecode(i.toString(), NegativeInteger(i))
            i += (maxInteger / 100000)
        }
        shouldEncodeAndDecode(maxInteger.toString(), NegativeInteger(maxInteger))
        shouldEncodeAndDecode("Long.MIN_VALUE", NegativeInteger(Int64.Min))
    }

    @TestCase
    public func shouldNotAcceptPositiveValues(): Unit {
        try {
            NegativeInteger(0)
        } catch (e: CborException) {
            return
        }
        @Assert(false)
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
