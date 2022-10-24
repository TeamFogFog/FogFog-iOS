import ProjectDescription
import ProjectDescriptionHelpers
import UtilityPlugin

let settings: Settings =
    .settings(
        base: Environment.baseSetting,
        configurations: [
            .debug(name: .debug),     // "Debug" return
            .release(name: .release)  // "Release" return
        ],
        defaultSettings: .recommended)

/// Build Phases 단계에서 실행할 스크립트 정의
let scripts: [TargetScript] = [
    .swiftLint
]

let targets: [Target] = [
    .init(
        name: Environment.targetName,
        platform: .iOS,
        product: .app,
        productName: Environment.appName,
        bundleId: "\(Environment.organizationName).\(Environment.targetName)",
        deploymentTarget: Environment.deploymentTarget,
        infoPlist: .file(path: "Support/Info.plist"),
        sources: ["Sources/**"],
        resources: ["Resources/**"],
        scripts: scripts,
        dependencies: [
            .Project.Presentation,
            .Project.Data
        ],
        settings: .settings(base: Environment.baseSetting)
    ),
    .init(
        name: Environment.targetTestName,
        platform: .iOS,
        product: .unitTests,
        bundleId: "\(Environment.organizationName).\(Environment.targetName)Tests",
        deploymentTarget: Environment.deploymentTarget,
        infoPlist: .default,
        sources: ["Tests/**"],
        dependencies: [
            .target(name: Environment.targetName)
        ]
    )
]

let schemes: [Scheme] = [
    .init(
        name: "\(Environment.targetName)-DEBUG",
        shared: true,
        buildAction: .buildAction(targets: ["\(Environment.targetName)"]),
        testAction: TestAction.targets(
            ["\(Environment.targetTestName)"],
            configuration: .debug,
            options: TestActionOptions.options(
                coverage: true,
                codeCoverageTargets: ["\(Environment.targetName)"]
            )
        ),
        runAction: .runAction(configuration: .debug),
        archiveAction: .archiveAction(configuration: .debug),
        profileAction: .profileAction(configuration: .debug),
        analyzeAction: .analyzeAction(configuration: .debug)
    ),
    .init(
        name: "\(Environment.targetName)-RELEASE",
        shared: true,
        buildAction: BuildAction(targets: ["\(Environment.targetName)"]),
        testAction: nil,
        runAction: .runAction(configuration: .release),
        archiveAction: .archiveAction(configuration: .release),
        profileAction: .profileAction(configuration: .release),
        analyzeAction: .analyzeAction(configuration: .release)
    )
]

let project: Project =
    .init(
        name: Environment.targetName,
        organizationName: Environment.organizationName,
        settings: settings,
        targets: targets,
        schemes: schemes
    )
