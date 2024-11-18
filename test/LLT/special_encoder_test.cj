// EXEC: cjc %import-path %L %l %f --test  
// EXEC: ./main

import std.unittest.*
import std.unittest.testmacro.*
import std.io.*
import cbor4cj.*

@Test
public class SpecialEncoderTest {
    private var encoder: SpecialEncoder = SpecialEncoder(None, ByteArrayStream())

    @TestCase
    public func shouldNotEncodeReserved(): Unit {
        try {
            encoder.encode(SpecialEncoderTest_Mock(this, SpecialType.UNALLOCATED))
        } catch (e: CborException) {
            return
        }
        @Assert(false)
    }

    @TestCase
    public func shouldVerifyImplementation1(): Unit {
        try {
            encoder.encode(SpecialEncoderTest_Mock(this, SpecialType.IEEE_754_DOUBLE_PRECISION_FLOAT))
        } catch (e: CborException) {
            return
        }
        @Assert(false)
    }

    @TestCase
    public func shouldVerifyImplementation2(): Unit {
        try {
            encoder.encode(SpecialEncoderTest_Mock(this, SpecialType.IEEE_754_HALF_PRECISION_FLOAT))
        } catch (e: CborException) {
            return
        }
        @Assert(false)
    }

    @TestCase
    public func shouldVerifyImplementation3(): Unit {
        try {
            encoder.encode(SpecialEncoderTest_Mock(this, SpecialType.IEEE_754_SINGLE_PRECISION_FLOAT))
        } catch (e: CborException) {
            return
        }
        @Assert(false)
    }

    @TestCase
    public func shouldVerifyImplementation4(): Unit {
        try {
            encoder.encode(SpecialEncoderTest_Mock(this, SpecialType.SIMPLE_VALUE_NEXT_BYTE))
        } catch (e: CborException) {
            return
        }
        @Assert(false)
    }
}

class SpecialEncoderTest_Mock <: Special {
    public init(this_0: SpecialEncoderTest, specialType: SpecialType) {
        super(specialType)
    }
}
