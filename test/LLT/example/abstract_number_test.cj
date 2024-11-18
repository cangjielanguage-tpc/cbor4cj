import std.math.numeric.BigInt
import std.unittest.*
import std.unittest.testmacro.*
import std.io.*
import cbor4cj.*

public class AbstractNumberTest {
    private let value: BigInt
    private let encodedValue: Array<Byte>

    public init(value: Int64, encodedValue: Array<Byte>) {
        this.value = BigInt(value)
        this.encodedValue = encodedValue
    }

    public init(value: BigInt, encodedValue: Array<Byte>) {
        this.value = value
        this.encodedValue = encodedValue
    }

    public func shouldEncode() {
        var dataItems = CborBuilder().add(value).build()
        var byteOutputStream = ByteArrayStream()
        var encoder = CborEncoder(byteOutputStream)
        encoder.encode(dataItems.first.getOrThrow())
        @Assert(encodedValue, byteOutputStream.bytes())
    }

    public func shouldDecode() {
        var inputStream = ByteArrayStream()
        inputStream.write(encodedValue)
        var decoder = CborDecoder(inputStream)
        var dataItem = decoder.decodeNext().getOrThrow()
        @Assert(dataItem is Number)
        var number = (dataItem as Number).getOrThrow()
        @Assert(value, number.getValue())
    }
}
