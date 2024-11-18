// EXEC: cjc %import-path %L %l %f --test
// EXEC: ./main

import std.unittest.*
import std.unittest.testmacro.*
import std.io.*
import cbor4cj.*
import std.math.*
import std.math.numeric.BigInt
import std.convert.*

@Test
public class Example06Test {
    private var VALUE:Collection<DataItem>

    private var ENCODED_VALUE: Array<Byte> = [0xc0, 0x74, 0x32, 0x30, 0x31, 0x33, 0x2d, 0x30, 0x33, 0x2d, 0x32, 0x31, 0x54, 0x32,
        0x30, 0x3a, 0x30, 0x34, 0x3a, 0x30, 0x30, 0x5a]

    public init() {
		var di = UnicodeString("2013-03-21T20:04:00Z");
		di.setTag(0);

		VALUE = CborBuilder().add(di).build();
	}

    @TestCase
    public func shouldEncode() {
        var byteOutputStream = ByteArrayStream();
        var encoder = CborEncoder(byteOutputStream);
        encoder.encode(VALUE);
        @Assert(ENCODED_VALUE, byteOutputStream.bytes())
    }

    @TestCase
    public func shouldDecode() {
        var inputStream = ByteArrayStream();
        inputStream.write(ENCODED_VALUE)
        var decoder = CborDecoder(inputStream);
        var dataItems = decoder.decode();
        @Assert(VALUE.toArray(), dataItems.toArray())
    }
}
