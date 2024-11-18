// EXEC: cjc %import-path %L %l %f --test  
// EXEC: ./main

import std.unittest.*
import std.unittest.testmacro.*
import std.collection.ArrayList
import std.io.ByteArrayStream
import cbor4cj.*

@Test
public class ByteStringDecoderTest {
    @TestCase
    public func shouldDecodeChunkedByteString(): Unit {
        let baos = ByteArrayStream()
        let encoder = CborEncoder(baos)
        encoder.encode(
            CborBuilder().startByteString().add('\u{0000}'.toString().toArray()).add([16]).add([19]).end().getOrThrow().
            build())
        let encodedBytes: Array<UInt8> = baos.bytes()
        let bais = ByteArrayStream()
        bais.write(encodedBytes)
        let decoder = CborDecoder(bais)
        let dataItems = decoder.decode()
        @Assert(!dataItems.isEmpty())
        @Assert(1, dataItems.size)
    }

    @TestCase
    public func shouldDecodeByteString1K(): Unit {
        let baos = ByteArrayStream()
        let encoder = CborEncoder(baos)
        encoder.encode(CborBuilder().add(Array<UInt8>(1024) {_ => 0}).build())
        let encodedBytes: Array<UInt8> = baos.bytes()
        let bais = ByteArrayStream()
        bais.write(encodedBytes)
        let decoder = CborDecoder(bais)
        let dataItems = decoder.decode()
        @Assert(!dataItems.isEmpty())
        @Assert(1, dataItems.size)
    }

    @TestCase
    public func shouldDecodeByteString1M(): Unit {
        let baos = ByteArrayStream()
        let encoder = CborEncoder(baos)
        encoder.encode(CborBuilder().add(Array<UInt8>(Int64(1024 * 1024)) {_ => 0}).build())
        let encodedBytes: Array<UInt8> = baos.bytes()
        let bais = ByteArrayStream()
        bais.write(encodedBytes)
        let decoder = CborDecoder(bais)
        let dataItems = decoder.decode()
        @Assert(!dataItems.isEmpty())
        @Assert(1, dataItems.size)
    }

    @TestCase
    public func shouldThrowOnIncompleteByteString(): Unit {
        let bytes: Array<UInt8> = [66, 32]
        try {
            CborDecoder.decodeStatic(bytes)
        } catch (e: CborException) {
            return
        }
        @Assert(false)
    }

    @TestCase
    public func shouldTrowOnMissingBreak(): Unit {
        let bytes: Array<UInt8> = [95, 65, 32]
        try {
            CborDecoder.decodeStatic(bytes)
        } catch (e: CborException) {
            return
        }
        @Assert(false)
    }
}
