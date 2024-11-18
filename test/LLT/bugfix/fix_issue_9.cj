// EXEC: cjc %import-path %L %l %f --test
// EXEC: ./main

import std.unittest.*
import std.unittest.testmacro.*
import std.io.*
import cbor4cj.*
import std.collection.*

@Test
public class fix2 {
    @TestCase
    public func fix2() {   
        var byteOutputStream =  ByteArrayStream();  
        var inputStream = ByteArrayStream(); 
        let builder = CborBuilder()
        let dataItems = builder.startByteString().add(Array<UInt8>())
            .end().getOrThrow()
            .build()
        var cborEncoder = CborEncoder(byteOutputStream);
        cborEncoder.encode(dataItems)
        var encodedBytes = byteOutputStream.bytes()
        inputStream.write(encodedBytes)
        let cborDecoder = CborDecoder(inputStream)
        let dataRes  = cborDecoder.decode()
        @Assert(dataRes.size,1)
        var decodeArr = (dataRes.first.getOrThrow() as ByteString).getOrThrow().getBytes().getOrThrow()
        @Assert(String.fromUtf8(decodeArr),"")
    }
}
