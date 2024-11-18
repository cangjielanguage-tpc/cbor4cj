// EXEC: cjc %import-path %L %l %f --test  
// EXEC: ./main

import std.unittest.*
import std.unittest.testmacro.*
import cbor4cj.*
import std.io.ByteArrayStream

@Test
public class ByteStringEncoderTest {

    @TestCase
    public func shouldEncodeChunkedString(): Unit {
        let byteArrayOutputStream = ByteArrayStream()
        let dataItems = CborBuilder().add(ByteString(None)).add(ByteString("test".toArray())).startByteString("test".toArray()).end().getOrThrow().build()
        CborEncoder(byteArrayOutputStream).encode(dataItems)
    }
}

