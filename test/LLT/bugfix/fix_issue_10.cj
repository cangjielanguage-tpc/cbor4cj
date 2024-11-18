// EXEC: cjc %import-path %L %l %f --test
// EXEC: ./main

import std.unittest.*
import std.unittest.testmacro.*
import std.io.*
import cbor4cj.*
import std.collection.*

@Test
public class fix3 {
    @TestCase
    public func fix3() {   
        var byteOutputStream =  ByteArrayStream();  
        var inputStream = ByteArrayStream(); 
        let builder = CborBuilder()
        var dataItems = (builder.addMap().put(1,2).end()).getOrThrow().build()
        var d : CborMap = (dataItems.first.getOrThrow() as CborMap).getOrThrow()
        var cborEncoder = CborEncoder(byteOutputStream);
        cborEncoder.encode(dataItems)
        var encodedBytes = byteOutputStream.bytes()
        inputStream.write(encodedBytes)
        let cborDecoder = CborDecoder(inputStream)
        let dataRes  = cborDecoder.decode()
        @Assert(dataRes.size,1)
        @Assert(dataRes.first.getOrThrow() is CborMap,true)
    }
}
