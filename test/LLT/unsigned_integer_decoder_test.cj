// EXEC: cjc %import-path %L %l %f --test  
// EXEC: ./main

import std.unittest.*
import std.unittest.testmacro.*
import std.io.*
import cbor4cj.*
import std.math.numeric.BigInt

@Test
public class UnsignedIntegerDecoderTest {

    @TestCase
    public func shouldDecodeBigNumbers(): Unit {
        var value = BigInt(1)
        var i = 1
        while (i < 64) {
            value = value<<1
            let baos = ByteArrayStream()
            let encoder = CborEncoder(baos)
            encoder.encode(CborBuilder().add(value).build())
            let encodedBytes: Array<UInt8> = baos.bytes()
            let bais = ByteArrayStream()
            bais.write(encodedBytes)
            let decoder = CborDecoder(bais)
            let dataItems = decoder.decode()
            @Assert(1, dataItems.size)
            let dataItem = dataItems.first.getOrThrow()
            @Assert(dataItem is UnsignedInteger)
            @Assert(value, (dataItem as UnsignedInteger).getOrThrow().getValue())
            i++
        }
    }
}
