// EXEC: cjc %import-path %L %l %f --test
// EXEC: ./main

import std.unittest.*
import std.unittest.testmacro.*
import std.io.*
import cbor4cj.*
import std.math.numeric.BigInt

@Test
public class ReadMeTest3 {
    @TestCase
    public func Example03Test() {
        let baos = ByteArrayStream();
        CborEncoder(baos).encode(CborBuilder().add(666).add("666").build());
        CborDecoder(baos).decode(impleDataItemListener())
    }
}

class impleDataItemListener <: DataItemListener {
    public func onDataItem(dataItem: DataItem) {
        if (dataItem is UnsignedInteger) {
            let value = (dataItem as UnsignedInteger).getOrThrow().getValue()
            @Assert(value, BigInt(666))
            return
        }
        if (dataItem is UnicodeString) {
            let value = (dataItem as UnicodeString).getOrThrow().toString()
            @Assert(value, "666")
            return
        }
        @Assert(false)
    }
}
