// EXEC: cjc %import-path %L %l %f --test  
// EXEC: ./main

import std.unittest.*
import std.unittest.testmacro.*
import std.io.InputStream
import std.io.ByteArrayStream
import cbor4cj.*
import std.math.numeric.BigInt

@Test
public class AbstractDecoderTest {
    public init() {}

    @TestCase
    public func shouldThrowExceptionOnUnexpectedEndOfStream(): Unit {
        let inputStream: InputStream = ByteArrayStream()
        try {
            AbstractDecoderTest_TestableAbstractDecoder(this, inputStream).callNextSymbol()
        } catch (e: CborException) {
            return
        }
        @Assert(false)
    }

    @TestCase
    public func shouldDecodeInfinityLength(): Unit {
        let inputStream: InputStream = ByteArrayStream()
        let decoder = AbstractDecoderTest_TestableAbstractDecoder(this, inputStream)
        @Assert(BigInt(-1), decoder.callGetLengthAsBigInteger(31))
    }

    @TestCase
    public func shouldThrowExceptionOnReserved1(): Unit {
        let inputStream: InputStream = ByteArrayStream()
        try {
            AbstractDecoderTest_TestableAbstractDecoder(this, inputStream).callGetLengthAsBigInteger(28)
        } catch (e: CborException) {
            return
        }
        @Assert(false)
    }

    @TestCase
    public func shouldThrowExceptionOnReserved2(): Unit {
        let inputStream: InputStream = ByteArrayStream()
        try {
            AbstractDecoderTest_TestableAbstractDecoder(this, inputStream).callGetLengthAsBigInteger(29)
        } catch (e: CborException) {
            return
        }
        @Assert(false)
    }

    @TestCase
    public func shouldThrowExceptionOnReserved3(): Unit {
        let inputStream: InputStream = ByteArrayStream()
        try {
            AbstractDecoderTest_TestableAbstractDecoder(this, inputStream).callGetLengthAsBigInteger(30)
        } catch (e: CborException) {
            return
        }
        @Assert(false)
    }

    @TestCase
    public func shouldThrowExceptionOnReserved4(): Unit {
        let inputStream: InputStream = ByteArrayStream()
        try {
            AbstractDecoderTest_TestableAbstractDecoder(this, inputStream).callGetLength(28)
        } catch (e: CborException) {
            return
        }
        @Assert(false)
    }

    @TestCase
    public func shouldThrowExceptionOnReserved5(): Unit {
        let inputStream: InputStream = ByteArrayStream()
        try {
            AbstractDecoderTest_TestableAbstractDecoder(this, inputStream).callGetLength(29)
        } catch (e: CborException) {
            return
        }
        @Assert(false)
    }

    @TestCase
    public func shouldThrowExceptionOnReserved6(): Unit {
        let inputStream: InputStream = ByteArrayStream()
        try {
            AbstractDecoderTest_TestableAbstractDecoder(this, inputStream).callGetLength(30)
        } catch (e: CborException) {
            return
        }
        @Assert(false)
    }

    @TestCase
    public func shouldDecodeEightBytesLengthToLong(): Unit {
        let inputStream: ByteArrayStream = ByteArrayStream()
        inputStream.write([1, 1, 1, 1, 1, 1, 1, 1])
        let value = AbstractDecoderTest_TestableAbstractDecoder(this, inputStream).callGetLength(27)
        @Assert(72340172838076673, value)
    }
}

class AbstractDecoderTest_TestableAbstractDecoder <: AbstractDecoder<UnicodeString> {
    public init(this_0: AbstractDecoderTest, inputStream: InputStream) {
        super(None, inputStream)
    }

    public func callNextSymbol(): Unit {
        nextSymbol()
    }

    public func callGetLength(initialByte: Int32): Int64 {
        return getLength(initialByte)
    }

    public func callGetLengthAsBigInteger(initialByte: Int32): BigInt {
        return getLengthAsBigInteger(initialByte)
    }

    public override func decode(initialByte: Int32): UnicodeString {
        return UnicodeString("")
    }
}
