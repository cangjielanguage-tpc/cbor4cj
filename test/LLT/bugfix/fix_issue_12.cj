// EXEC: cjc %import-path %L %l %f --test
// EXEC: ./main

import std.unittest.*
import std.unittest.testmacro.*
import std.io.*
import cbor4cj.*
import std.collection.*

@Test
public class fix5 {
    @TestCase
    public func fix5() {   
        var byteOutputStream = ByteArrayStream();
        var inputStream = ByteArrayStream();
        let builder = CborBuilder()
        var arr: Array<Byte> = []
        var dataItems = builder.add(arr).build()
        var cborEncoder = CborEncoder(byteOutputStream);
        cborEncoder.encode(dataItems)
        var encodedBytes = byteOutputStream.bytes()
        inputStream.write(encodedBytes)
        let cborDecoder = CborDecoder(inputStream)
        let dataRes = cborDecoder.decode()
        @Assert(dataRes.first.getOrThrow().getMajorType().toString(),"BYTE_STRING")
    }
}
