import PackageDescription

let package = Package(
    name: "ProtocolBufferFunToy",
    targets: [
        Target(
            name: "Server",
            dependencies: [.Target(name: "Web")]
        ),
        Target(
            name: "Web"
        )
    ],
    dependencies: [
        .Package(url: "https://github.com/apple/swift-protobuf-runtime.git", Version(0,9,22)),
        .Package(url: "https://github.com/IBM-Swift/Kitura", Version(1,0,0))
    ]
)
