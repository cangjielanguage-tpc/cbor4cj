// EXEC: cjc %import-path %L %l %f --test
// EXEC: ./main

import std.unittest.*
import std.unittest.testmacro.*
import std.io.*
import cbor4cj.*
import std.collection.*

@Test
public class fix1 {
    @TestCase
    public func fix1() {
        var byteOutputStream = ByteArrayStream();
        var inputStream = ByteArrayStream();
        let builder = CborBuilder()
        let dataItems = builder.addArray().add(SimpleValue(-48)).end().getOrThrow().build()
        var encoder = CborEncoder(byteOutputStream);
        encoder.encode(dataItems)
        var encodedBytes = byteOutputStream.bytes()
        var except: Array<Byte> = [129, 240]
        @Assert(encodedBytes,except)
    }
}
