// EXEC: cjc %import-path %L %l %f --test
// EXEC: ./main

import std.unittest.*
import std.unittest.testmacro.*
import std.io.*
import cbor4cj.*

@Test
public class ReadMeTest {
    @TestCase
    public func Example01Test() {
        var except: Array<Byte> = [100, 116, 101, 120, 116, 25, 4, 210, 65, 16, 130, 1, 100, 116, 101, 120, 116]
        let baos = ByteArrayStream();
        CborEncoder(baos).encode(
            CborBuilder().add("text") // add string
                .add(1234) // add integer
                .add([0x10]) // add byte array
                .addArray() // add array
                    .add(1)
                    .add("text")
                    .end().getOrThrow()
                .build());
        var encodedBytes = baos.bytes();
        println(encodedBytes)
        @Assert(encodedBytes,except)
    }
}
