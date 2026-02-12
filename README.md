<div align="center">
<h1>cbor4cj</h1>
</div>

<p align="center">
<img alt="" src="https://img.shields.io/badge/release-v1.0.1-brightgreen" style="display: inline-block;" />
<img alt="" src="https://img.shields.io/badge/build-pass-brightgreen" style="display: inline-block;" />
<img alt="" src="https://img.shields.io/badge/cjc-v1.0.0-brightgreen" style="display: inline-block;" />
<img alt="" src="https://img.shields.io/badge/cjcov-91.2%25-brightgreen" style="display: inline-block;" />
<img alt="" src="https://img.shields.io/badge/project-open-brightgreen" style="display: inline-block;" />
</p>

## 介绍

基于RFC 7049协议的简明二进制对象表示法(Cbor)的Cangjie语言实现

### 特性

- 🚀 支持Cbor数据编解码
- 🚀 支持Cbor数据流式解码

```shell
.
├── doc
├── src
└── test
│   ├── DOC
│   ├── HLT
│   └── LLT
├── CHANGELOG.md
├── LICENSE.txt
├── cjpm.toml
├── README.md
└── README.OpenSource
```

- `doc`  文档目录，用于存API接口文档
- `src`  是库源码目录
- `test` 存放 HLT 测试用例、LLT 自测用例、和文档示例用例

### 接口说明

主要类和函数接口说明详见 [API](./doc/feature_api.md)


## 使用说明

### 编译（win/linux）

```shell
cjpm build
```

### 功能示例
#### 编码

示例代码如下：

```cangjie
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
                .add(1234) // add int
                .add([0x10]) // add byte array
                .addArray() // add array
                .add(1).add("text").end().getOrThrow().build());
        var encodedBytes = baos.bytes();
        println(encodedBytes)
        @Assert(encodedBytes,except)
    }
}
```

执行结果如下：

```shell
[ PASSED ] CASE: Example01Test
```

#### 解码

示例代码如下：

```cangjie
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
        @Assert((value3 as ByteString).getOrThrow().getBytes(), Array<Byte>([0x10]))

        var value4 = iter.next().getOrThrow()
        var items = (value4 as CborArray).getOrThrow().getDataItems()
        @Assert(items.size, 2)
        @Assert((items[0] as UnsignedInteger).getOrThrow(), UnsignedInteger(BigInt(1)))
        @Assert((items[1] as UnicodeString).getOrThrow().toString(), "text")
    }
}
```

执行结果如下：

```shell
[ PASSED ] CASE: Example02Test
```

#### 流式解码

示例代码如下：

```cangjie
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
```

执行结果如下：

```shell
[ PASSED ] CASE: Example03Test
```

## 约束与限制

在下述版本验证通过：

    Cangjie Version: 1.1.0

## 开源协议

本项目基于 [Apache License 2.0](./LICENSE) ，请自由的享受和参与开源。

## 参与贡献

欢迎给我们提交PR，欢迎给我们提交Issue，欢迎参与任何形式的贡献。
