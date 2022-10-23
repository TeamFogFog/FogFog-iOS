import ProjectDescription

public extension TargetDependency {
    enum SPM {}
}

// MARK: - Network
public extension TargetDependency.SPM {
    static let Moya = TargetDependency.package(product: "Moya")
    static let Alamofire = TargetDependency.package(product: "Alamofire")
}

// MARK: - Rx
public extension TargetDependency.SPM {
    static let RxSwift = TargetDependency.package(product: "RxSwift")
    static let RxCocoa = TargetDependency.package(product: "RxCocoa")
    static let RxRelay = TargetDependency.package(product: "RxRelay")
    static let RxMoya = TargetDependency.package(product: "RxMoya")
}

// MARK: - Layout
public extension TargetDependency.SPM {
    static let SnapKit = TargetDependency.swiftPackageManager(name: "SnapKit")
    static let Then = TargetDependency.swiftPackageManager(name: "Then")
}

public extension Package {
    static let SnapKit = Package.package(url: "https://github.com/SnapKit/SnapKit.git", .upToNextMajor(from: "5.0.1"))
    static let Then = Package.package(url: "https://github.com/devxoul/Then", .upToNextMajor(from: "2.7.0"))
    static let Alamofire = Package.package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.6.0"))
    static let Moya = Package.package(url: "https://github.com/Moya/Moya.git", .upToNextMajor(from: "15.0.3"))
    static let RxSwift = Package.package(url: "https://github.com/ReactiveX/RxSwift.git", .upToNextMajor(from: "6.2.0"))
}

public extension TargetDependency {
  static func swiftPackageManager(name: String) -> Self {
    TargetDependency.package(product: name)
  }
}
