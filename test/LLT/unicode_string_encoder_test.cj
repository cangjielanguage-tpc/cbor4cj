// EXEC: cjc %import-path %L %l %f --test  
// EXEC: ./main

import std.unittest.*
import std.unittest.testmacro.*
import std.io.*
import cbor4cj.*

@Test
public class UnicodeStringEncoderTest {

    @TestCase
    public func shouldEncodeChunkedString(): Unit {
        let byteArrayOutputStream = ByteArrayStream()
        let dataItems = CborBuilder().startString("test").end().getOrThrow().build()
        CborEncoder(byteArrayOutputStream).encode(dataItems)
    }
}

