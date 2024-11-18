// EXEC: cjc %import-path %L %l %f --test  
// EXEC: ./main

import std.unittest.*
import std.unittest.testmacro.*
import std.io.*
import cbor4cj.*

@Test
public class MapDecoderTest {
    @TestCase
    public func shouldThrowOnMissingKeyInMap(): Unit {
        let bytes: Array<UInt8> = [162, 1, 2]
        try {
            CborDecoder.decodeStatic(bytes)
        } catch (e: CborException) {
            return
        }
        @Assert(false)
    }

    @TestCase
    public func shouldThrowOnMissingValueInMap(): Unit {
        let bytes: Array<UInt8> = [162, 1, 2, 3]
        try {
            CborDecoder.decodeStatic(bytes)
        } catch (e: CborException) {
            return
        }
        @Assert(false)
    }

    @TestCase
    public func shouldThrowOnIncompleteIndefiniteLengthMap(): Unit {
        let bytes: Array<UInt8> = [191, 97, 1]
        try {
            CborDecoder.decodeStatic(bytes)
        } catch (e: CborException) {
            return
        }
        @Assert(false)
    }

    @TestCase
    public func shouldUseLastOfDuplicateKeysByDefault(): Unit {
        let bytes: Array<UInt8> = [162, 1, 1, 1, 2]
        let decoded = CborDecoder.decodeStatic(bytes)
        let map = (decoded.first.getOrThrow() as CborMap).getOrThrow()
        @Assert(map.getKeys().size, 1)
        @Assert(map.get(UnsignedInteger(1)), UnsignedInteger(2))
    }

    @TestCase
    public func shouldThrowOnDuplicateKeyIfEnabled(): Unit {
        let bytes: Array<UInt8> = [162, 1, 1, 1, 2]
        let bais = ByteArrayStream()
        bais.write(bytes)
        let decoder = CborDecoder(bais)
        decoder.setRejectDuplicateKeys(true)
        try {
            decoder.decode()
        } catch (e: CborException) {
            return
        }
        @Assert(false)
    }

    @TestCase
    public func shouldThrowInDuplicateKeyInIndefiniteLengthMapIfEnabled(): Unit {
        let bytes: Array<UInt8> = [191, 1, 1, 1, 2, 255]
        let bais = ByteArrayStream()
        bais.write(bytes)
        let decoder = CborDecoder(bais)
        decoder.setRejectDuplicateKeys(true)
        try {
            decoder.decode()
        } catch (e: CborException) {
            return
        }
        @Assert(false)
    }
}
