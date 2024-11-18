// EXEC: cjc %import-path %L %l %f --test
// EXEC: ./main

import std.unittest.*
import std.unittest.testmacro.*
import std.io.*
import std.collection.*
import std.math.numeric.BigInt
import cbor4cj.*

@Test
public class ReadMeTest2 {
    @TestCase
    public func Example02Test() {
        var except: Array<Byte> = [100, 116, 101, 120, 116, 25, 4, 210, 65, 16, 130, 1, 100, 116, 101, 120, 116]
        let baos = ByteArrayStream();
        baos.write(except)
        var dataItems: LinkedList<DataItem> = CborDecoder(baos).decode();
        @Assert(dataItems.size,4)
        var iter = dataItems.iterator()
        var value1 = iter.next().getOrThrow()
        @Assert((value1 as UnicodeString).getOrThrow().toString(), "text")

        var value2 = iter.next().getOrThrow()
        @Assert((value2 as UnsignedInteger).getOrThrow().getValue(), BigInt(1234))

        var value3 = iter.next().getOrThrow()
        @Assert((value3 as ByteString).getOrThrow().getBytes(), [0x10u8])

        var value4 = iter.next().getOrThrow()
        @Assert(value4.getMajorType(),MajorType.ARRAY)
        var items = (value4 as CborArray).getOrThrow().getDataItems()
        @Assert(items.size, 2)
        @Assert((items[0] as UnsignedInteger).getOrThrow(), UnsignedInteger(BigInt(1)))
        @Assert((items[1] as UnicodeString).getOrThrow().toString(), "text")
    }
}
