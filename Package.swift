import PackageDescription

let package = Package(
    name: "ProtocolBufferFunToy",
    dependencies: [
        .Package(url: "https://github.com/apple/swift-protobuf-plugin", Version(0,9,21)),
        .Package(url: "https://github.com/IBM-Swift/Kitura", Version(1,0,0))
    ]
)
