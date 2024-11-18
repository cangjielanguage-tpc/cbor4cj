// EXEC: cjc %import-path %L %l %f --test  
// EXEC: ./main

import std.unittest.*
import std.unittest.testmacro.*
import std.io.*
import cbor4cj.*

@Test
public class CborEncoderTest {
    private var encoder: CborEncoder = CborEncoder(ByteArrayStream())

    @TestCase
    public func shouldNotEncodeInvalidMajorType(): Unit {
        try {
            encoder.encode(CborEncoderTest_InvalidDataItem(this))
        } catch (e: CborException) {
            return
        }
        @Assert(false)
    }
}

class CborEncoderTest_InvalidDataItem <: DataItem {
    public init(this_0: CborEncoderTest) {
        super(MajorType.INVALID)
    }
}
