// EXEC: cjc %import-path %L %l %f --test  
// EXEC: ./main

import std.unittest.*
import std.unittest.testmacro.*
import std.io.*
import cbor4cj.*

@Test
public class SpecialDecoderTest {
    @TestCase
    public func shouldThrowExceptionOnUnallocated(): Unit {
        let decoder = SpecialDecoder(None, ByteArrayStream())
        try {
            decoder.decode(28)
        } catch (e: CborException) {
            return
        }
        @Assert(false)
    }
}
