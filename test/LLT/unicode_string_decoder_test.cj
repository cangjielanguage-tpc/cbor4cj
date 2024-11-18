// EXEC: cjc %import-path %L %l %f --test  
// EXEC: ./main

import std.unittest.*
import std.unittest.testmacro.*
import std.io.*
import cbor4cj.*

@Test
public class UnicodeStringDecoderTest {

    @TestCase
    public func shouldDecodeChunkedUnicodeString(): Unit {
        let baos = ByteArrayStream()
        let encoder = CborEncoder(baos)
        encoder.encode(CborBuilder().startString().add("foo").add("bar").end().getOrThrow().build())
        let encodedBytes: Array<UInt8> = baos.bytes()
        let bais = ByteArrayStream()
        bais.write(encodedBytes)
        let decoder = CborDecoder(bais)
        let dataItems = decoder.decode()
        @Assert(1, dataItems.size)
    }

    @TestCase
    public func shouldThrowOnIncompleteString(): Unit {
        let bytes: Array<UInt8> = [98, 97]
        try {
            CborDecoder.decodeStatic(bytes)
        } catch (e: CborException) {
            return
        }
        @Assert(false)
    }

    @TestCase
    public func shouldThrowOnMissingBreak(): Unit {
        let bytes: Array<UInt8> = [127, 97, 97]
        try {
            CborDecoder.decodeStatic(bytes)
        } catch (e: CborException) {
            return
        }
        @Assert(false)
    }
}
