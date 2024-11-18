// EXEC: cjc %import-path %L %l %f --test  
// EXEC: ./main

import std.unittest.*
import std.unittest.testmacro.*
import std.io.*
import cbor4cj.*
import std.math.numeric.BigInt
import std.sync.Monitor

@Test
public class AbstractEncoderTest {
    @TestCase
    public func shouldThrowCborExceptionOnUnderlyingIoException(): Unit {
        try {
            let counter = Array<Int32>(1) {_ => 0}
            CborEncoder(AbstractEncoderTest_1(this, counter)).encode(
                CborBuilder().startString().add("string").end().getOrThrow().build())
        } catch (e: CborException) {
            return
        }
        @Assert(false)
    }

    @TestCase
    public func shouldThrowCborExceptionOnUnderlyingIoException2(): Unit {
        try {
            CborEncoder(AbstractEncoderTest_2(this)).encode(
                CborBuilder().startArray().add(1).end().getOrThrow().build())
        } catch (e: CborException) {
            return
        }
        @Assert(false)
    }

    @TestCase
    public func shallEncode32bit(): Unit {
        let outputStream = ByteArrayStream()
        let encoder = AbstractEncoderTest_TestEncoder(this, outputStream)
        encoder.doEncodeTypeAndLength(4294967296)
        let bytes: Array<UInt8> = outputStream.bytes()
        @Assert(9, bytes.size)
        @Assert(Int64(155), Int64(bytes[0]))
        @Assert(Int64(0), Int64(bytes[1]))
        @Assert(Int64(0), Int64(bytes[2]))
        @Assert(Int64(0), Int64(bytes[3]))
        @Assert(Int64(1), Int64(bytes[4]))
        @Assert(Int64(0), Int64(bytes[5]))
        @Assert(Int64(0), Int64(bytes[6]))
        @Assert(Int64(0), Int64(bytes[7]))
        @Assert(Int64(0), Int64(bytes[8]))
    }
}

class AbstractEncoderTest_TestEncoder <: AbstractEncoder<Object> {
    public init(this_0: AbstractEncoderTest, outputStream: OutputStream) {
        super(None, outputStream)
    }

    public override func encode(dataItem: Object): Unit {}

    public func doEncodeTypeAndLength(length: Int64): Unit {
        encodeTypeAndLength(MajorType.ARRAY, length)
    }
}

class AbstractEncoderTest_1 <: OutputStream {
    private let GeneratedLockObject = Monitor()

    public func getMonitor(): Monitor {
        return GeneratedLockObject
    }

    let val_counter: Array<Int32>

    init(this_0: AbstractEncoderTest, val_counter: Array<Int32>) {
        this.val_counter = val_counter
    }

    public override func write(buffer: Array<UInt8>): Unit {
        synchronized(GeneratedLockObject) {
            if (match (0) {
                case _ =>
                    val_counter[0] += 1
                    val_counter[0]
            } == 3) {
                throw IOException()
            }
        }
    }
}

class AbstractEncoderTest_2 <: OutputStream {
    private let GeneratedLockObject = Monitor()

    public func getMonitor(): Monitor {
        return GeneratedLockObject
    }

    init(this_0: AbstractEncoderTest) {}

    public override func write(buffer: Array<UInt8>): Unit {
        synchronized(GeneratedLockObject) {
            throw IOException()
        }
    }
}

// public class CborBuilder {
//     init(param0: Any) { return } // TODO
// }
// public class OutputStream {
// }
// public class Synchronizable {
// }
// public class Assert {
//     public static func assertEquals(param0: Any, param1: Any) { return } // TODO
// }
