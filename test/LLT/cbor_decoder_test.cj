// EXEC: cjc %import-path %L %l %f --test  
// EXEC: ./main

import std.unittest.*
import std.unittest.testmacro.*
import std.io.*
import cbor4cj.*

@Test
public class CborDecoderTest {
    @TestCase
    public func shouldThrowCborException(): Unit {
        try {
            let cborDecoder = CborDecoder(CborDecoderTest_1(this))
            cborDecoder.decodeNext()
        } catch (e: CborException) {
            return
        }
        @Assert(false)
    }

    @TestCase
    public func shouldThrowCborException2(): Unit {
        try {
            let cborDecoder = CborDecoder(CborDecoderTest_2(this))
            cborDecoder.decodeNext()
        } catch (e: CborException) {
            return
        }
        @Assert(false)
    }

    @TestCase
    public func shouldSetAutoDecodeInfinitiveMaps(): Unit {
        let inputStream: ByteArrayStream = ByteArrayStream()
        inputStream.write([0, 1, 2])
        let cborDecoder = CborDecoder(inputStream)
        @Assert(cborDecoder.isAutoDecodeInfinitiveMaps())
        cborDecoder.setAutoDecodeInfinitiveMaps(false)
        @Assert(!cborDecoder.isAutoDecodeInfinitiveMaps())
    }

    @TestCase
    public func shouldSetAutoDecodeRationalNumbers(): Unit {
        let inputStream: ByteArrayStream = ByteArrayStream()
        inputStream.write([0, 1, 2])
        let cborDecoder = CborDecoder(inputStream)
        @Assert(cborDecoder.isAutoDecodeRationalNumbers())
        cborDecoder.setAutoDecodeRationalNumbers(false)
        @Assert(!cborDecoder.isAutoDecodeRationalNumbers())
    }

    @TestCase
    public func shouldSetAutoDecodeLanguageTaggedStrings(): Unit {
        let inputStream: ByteArrayStream = ByteArrayStream()
        inputStream.write([0, 1, 2])
        let cborDecoder = CborDecoder(inputStream)
        @Assert(cborDecoder.isAutoDecodeLanguageTaggedStrings())
        cborDecoder.setAutoDecodeLanguageTaggedStrings(false)
        @Assert(!cborDecoder.isAutoDecodeLanguageTaggedStrings())
    }

    @TestCase
    public func shouldThrowOnRationalNumberDecode1(): Unit {
        let items = CborBuilder().addTag(30).add(true).build()
        let baos = ByteArrayStream()
        let encoder = CborEncoder(baos)
        encoder.encode(items)
        let bais = ByteArrayStream()
        bais.write(baos.bytes())
        let decoder = CborDecoder(bais)
        try {
            decoder.decode()
        } catch (e: CborException) {
            return
        }
        @Assert(false)
    }

    @TestCase
    public func shouldThrowOnRationalNumberDecode2(): Unit {
        let items = CborBuilder().addTag(30).addArray().add(true).end().getOrThrow().build()
        let baos = ByteArrayStream()
        let encoder = CborEncoder(baos)
        encoder.encode(items)
        let bais = ByteArrayStream()
        bais.write(baos.bytes())
        let decoder = CborDecoder(bais)
        try {
            decoder.decode()
        } catch (e: CborException) {
            return
        }
        @Assert(false)
    }

    @TestCase
    public func shouldThrowOnRationalNumberDecode3(): Unit {
        let items = CborBuilder().addTag(30).addArray().add(true).add(true).end().getOrThrow().build()
        let baos = ByteArrayStream()
        let encoder = CborEncoder(baos)
        encoder.encode(items)
        let bais = ByteArrayStream()
        bais.write(baos.bytes())
        let decoder = CborDecoder(bais)
        try {
            decoder.decode()
        } catch (e: CborException) {
            return
        }
        @Assert(false)
    }

    @TestCase
    public func shouldThrowOnRationalNumberDecode4(): Unit {
        let items = CborBuilder().addTag(30).addArray().add(1).add(true).end().getOrThrow().build()
        let baos = ByteArrayStream()
        let encoder = CborEncoder(baos)
        encoder.encode(items)
        let bais = ByteArrayStream()
        bais.write(baos.bytes())
        let decoder = CborDecoder(bais)
        try {
            decoder.decode()
        } catch (e: CborException) {
            return
        }
        @Assert(false)
    }

    @TestCase
    public func shouldDecodeRationalNumber(): Unit {
        let items = CborBuilder().addTag(30).addArray().add(1).add(2).end().getOrThrow().build()
        let baos = ByteArrayStream()
        let encoder = CborEncoder(baos)
        encoder.encode(items)
        let bais = ByteArrayStream()
        bais.write(baos.bytes())
        let decoder = CborDecoder(bais)
        var ddd = RationalNumber(UnsignedInteger(1), UnsignedInteger(2))
        var c: CborArray = (decoder.decodeNext().getOrThrow() as CborArray).getOrThrow()
        @Assert((ddd.equals(c)))
    }

    @TestCase
    public func shouldDecodeTaggedTags(): Unit {
        let decoded = CborDecoder.decodeStatic([193, 194, 2]).first.getOrThrow()
        let outer = Tag(1)
        let inner = Tag(2)
        let expected = UnsignedInteger(2)
        inner.setTag(outer)
        expected.setTag(inner)
        @Assert(expected, decoded)
    }

    @TestCase
    public func shouldDecodeTaggedRationalNumber(): Unit {
        let items = CborBuilder().addTag(1).addTag(30).addArray().add(1).add(2).end().getOrThrow().build()
        let baos = ByteArrayStream()
        let encoder = CborEncoder(baos)
        encoder.encode(items)
        let bais = ByteArrayStream()
        bais.write(baos.bytes())
        let decoder = CborDecoder(bais)
        let expected = RationalNumber(UnsignedInteger(1), UnsignedInteger(2))
        expected.getTag().getOrThrow().setTag(Tag(1))
        @Assert(expected, decoder.decodeNext().getOrThrow())
    }
}

class CborDecoderTest_1 <: InputStream {
    init(this_0: CborDecoderTest) {}

    public override func read(io: Array<Byte>): Int64 {
        throw IOException()
    }
}

class CborDecoderTest_2 <: InputStream {
    init(this_0: CborDecoderTest) {}

    public override func read(io: Array<Byte>): Int64 {
        io[0] = 254
        return 1
    }
}
