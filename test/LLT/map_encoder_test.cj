// EXEC: cjc %import-path %L %l %f --test  
// EXEC: ./main

import std.unittest.*
import std.unittest.testmacro.*
import std.io.*
import cbor4cj.*

@Test
public class MapEncoderTest {

    @TestCase
    public func shouldEncodeMap(): Unit {
        let byteArrayOutputStream = ByteArrayStream()
        let dataItems = CborBuilder().addMap().put(1, true).put(".", true).put(3, true).put("..", true).put(2, true).put("...", true).end().getOrThrow().build()
        CborEncoder(byteArrayOutputStream).encode(dataItems)
    }
}

