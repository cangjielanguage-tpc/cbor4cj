// DEPENDENCE: ./abstract_number_test.cj
// EXEC: cjc %import-path %L %l %f ./abstract_number_test.cj --test
// EXEC: ./main

import std.unittest.*
import std.unittest.testmacro.*
import std.io.*
import cbor4cj.*
import std.math.numeric.BigInt

@Test
public class Example02Test {
    @TestCase
    public func Example11Test() {
        var test = AbstractNumberTest(
            BigInt("18446744073709551615"),
            [0x1b, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff]
        )
        test.shouldDecode()
        test.shouldEncode()
    }

    @TestCase
    public func Example12Test() {
        var test = AbstractNumberTest(
            BigInt("18446744073709551615"),
            [0x1b, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff]
        )
        test.shouldDecode()
        test.shouldEncode()
    }

    @TestCase
    public func Example13Test() {
        var test = AbstractNumberTest(
            BigInt("-18446744073709551616"),
            [0x3b, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff]
        )
        test.shouldDecode()
        test.shouldEncode()
    }

    //@TestCase
    public func Example14TestshouldEncode() {
        var byteArrayOutputStream = ByteArrayStream();
        var encoder = CborEncoder(byteArrayOutputStream);
        encoder.encode(NegativeInteger(BigInt("-18446744073709551617")));
        var except: Array<Byte> = [0xc3, 0x49, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]
        @Assert(except,
				byteArrayOutputStream.bytes())
    }

    @TestCase
    public func Example14TestshouldDecode() {
    	var byteArrayInputStream = ByteArrayStream()
        byteArrayInputStream.write([0xc3, 0x49, 0x01, 0x00, 0x00, 0x00, 0x00,
    					0x00, 0x00, 0x00, 0x00])
    	var decoder = CborDecoder(byteArrayInputStream);
    	var b = decoder.decodeNext().getOrThrow();

    	@Assert(b.hasTag());
    	var tag = b.getTag().getOrThrow();
    	@Assert(3, tag.getValue());

    	@Assert(b is ByteString);
    	var byteString = (b as ByteString).getOrThrow();
        var except: Array<Byte> = [0x01, 0x00, 0x00, 0x00,
    			0x00, 0x00, 0x00, 0x00, 0x00 ]
    	@Assert(except, byteString.getBytes());
    }

    @TestCase
    public func Example15Test() {
        var test = AbstractNumberTest(
            BigInt("-1"),
            [0x20]
        )
        test.shouldDecode()
        test.shouldEncode()
    }

    @TestCase
    public func Example16Test() {
        var test = AbstractNumberTest(
            BigInt("-10"),
            [0x29]
        )
        test.shouldDecode()
        test.shouldEncode()
    }

    @TestCase
    public func Example17Test() {
        var test = AbstractNumberTest(
            BigInt("-100"),
            [0x38, 0x63]
        )
        test.shouldDecode()
        test.shouldEncode()
    }

    @TestCase
    public func Example18Test() {
        var test = AbstractNumberTest(
            BigInt("-1000"),
            [0x39, 0x03, 0xe7]
        )
        test.shouldDecode()
        test.shouldEncode()
    }
}
