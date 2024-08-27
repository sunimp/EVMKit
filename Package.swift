// swift-tools-version:5.10
import PackageDescription

let package = Package(
    name: "EvmKit",
    platforms: [
        .iOS(.v14),
        .macOS(.v12)
    ],
    products: [
        .library(
            name: "EvmKit",
            targets: ["EvmKit"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/attaswift/BigInt.git", .upToNextMajor(from: "5.0.0")),
        .package(url: "https://github.com/Kitura/BlueSocket.git", .upToNextMajor(from: "2.0.0")),
        .package(url: "https://github.com/groue/GRDB.swift.git", .upToNextMajor(from: "6.0.0")),
        .package(url: "https://github.com/tristanhimmelman/ObjectMapper.git", .upToNextMajor(from: "4.4.3")),
        .package(url: "https://github.com/sunimp/WWCryptoKit.Swift.git", .upToNextMajor(from: "1.3.6")),
        .package(url: "https://github.com/sunimp/HDWalletKit.Swift.git", .upToNextMajor(from: "1.3.6")),
        .package(url: "https://github.com/sunimp/WWToolKit.Swift.git", .upToNextMajor(from: "2.1.2")),
        .package(url: "https://github.com/sunimp/WWExtensions.Swift.git", .upToNextMajor(from: "1.1.1")),
        .package(url: "https://github.com/nicklockwood/SwiftFormat.git", from: "0.54.0"),
    ],
    targets: [
        .target(
            name: "EvmKit",
            dependencies: [
                "BigInt",
                .product(name: "Socket", package: "BlueSocket"),
                .product(name: "GRDB", package: "GRDB.swift"),
                "ObjectMapper",
                .product(name: "WWCryptoKit", package: "WWCryptoKit.Swift"),
                .product(name: "HDWalletKit", package: "HDWalletKit.Swift"),
                .product(name: "WWToolKit", package: "WWToolKit.Swift"),
                .product(name: "WWExtensions", package: "WWExtensions.Swift"),
            ]
        ),
    ]
)
