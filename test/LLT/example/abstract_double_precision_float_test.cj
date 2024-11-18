import std.math.numeric.BigInt
import std.unittest.*
import std.unittest.testmacro.*
import std.io.*
import cbor4cj.*

public class AbstractDoublePrecisionFloatTest {
    private let value: Float64
    private let encodedValue: Array<Byte>

    public init(value: Float64, encodedValue: Array<Byte>) {
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
        var inputStream = ByteArrayStream();
        inputStream.write(encodedValue)
        var decoder = CborDecoder(inputStream);
        var dataItem = decoder.decodeNext().getOrThrow()
        @Assert(dataItem is DoublePrecisionFloat)
        var doublePrecisionFloat = (dataItem as DoublePrecisionFloat).getOrThrow()
        @Assert(value ==doublePrecisionFloat.getValue())
    }
}
