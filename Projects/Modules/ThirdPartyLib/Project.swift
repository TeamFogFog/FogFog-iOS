import ProjectDescription
import ProjectDescriptionHelpers
import UtilityPlugin

let project = Project.framework(
    name: "ThirdPartyLib",
    packages: [
        .Moya,
        .SnapKit,
        .Then,
        .RxSwift,
    ],
    dependencies: [
        .SPM.Moya,
        .SPM.Alamofire,
        .SPM.RxMoya,
        .SPM.RxSwift,
        .SPM.RxCocoa,
        .SPM.RxRelay
    ])
