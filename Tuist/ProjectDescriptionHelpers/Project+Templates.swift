import ProjectDescription
import UtilityPlugin

public extension Project {
    
    /// Static Library
    static func staticLibrary(
        name: String,
        platform: Platform = .iOS,
        packages: [Package] = [],
        sources: SourceFilesList = .sources,
        dependencies: [TargetDependency] = []
    ) -> Self {
        
        return project(
            name: name,
            platform: platform,
            product: .staticLibrary,
            packages: packages,
            dependencies: dependencies,
            sources: sources
        )
    }
    
    /// Static Framework
    static func staticFramework(
        name: String,
        platform: Platform = .iOS,
        packages: [Package] = [],
        sources: SourceFilesList = .sources,
        dependencies: [TargetDependency] = [],
        infoPlist: InfoPlist = .default
    ) -> Self {
        
        return project(
            name: name,
            platform: platform,
            product: .staticFramework,
            packages: packages,
            dependencies: dependencies,
            sources: sources,
            infoPlist: infoPlist
        )
    }
    
    /// Dynamic Framework
    static func framework(
        name: String,
        platform: Platform = .iOS,
        packages: [Package] = [],
        sources: SourceFilesList = .sources,
        resources: ProjectDescription.ResourceFileElements? = ["Resources/**"],
        dependencies: [TargetDependency] = [],
        infoPlist: InfoPlist = .default
    ) -> Self {
        
        return project(
            name: name,
            platform: platform,
            product: .framework,
            packages: packages,
            dependencies: dependencies,
            sources: sources,
            resources: resources,
            infoPlist: infoPlist
        )
    }
}

public extension Project {
    
    static func project(
        name: String,
        organizationName: String = Environment.organizationName,
        platform: Platform = Environment.platform,
        product: Product,
        packages: [Package] = [],
        deploymentTarget: DeploymentTarget? = Environment.deploymentTarget,
        dependencies: [TargetDependency] = [],
        sources: SourceFilesList,
        resources: ProjectDescription.ResourceFileElements? = nil,
        infoPlist: InfoPlist = .default
    ) -> Project {
        
        let scripts: [TargetScript] = [
            .swiftLint
        ]
        
        let settings: Settings = .settings(
            base: Environment.baseSetting,
            configurations: [
                .debug(name: .debug),
                .release(name: .release)
            ],
            defaultSettings: .recommended
        )
        
        let appTarget = Target(
            name: name,
            platform: platform,
            product: product,
            bundleId: "\(organizationName).\(name)",
            deploymentTarget: deploymentTarget,
            infoPlist: infoPlist,
            sources: sources,
            resources: resources,
            scripts: scripts,
            dependencies: dependencies
        )
        
        let testTarget = Target(
            name: "\(name)Tests",
            platform: platform,
            product: .unitTests,
            bundleId: "\(organizationName).\(name)Tests",
            deploymentTarget: deploymentTarget,
            infoPlist: .default,
            sources: ["Tests/**"],
            dependencies: [.target(name: name)]
        )
        
        let schemes: [Scheme] = [.makeScheme(target: .debug, name: name)]
        
        let targets: [Target] = [appTarget, testTarget]
        
        return Project(
            name: name,
            organizationName: organizationName,
            packages: packages,
            settings: settings,
            targets: targets,
            schemes: schemes
        )
    }
}

extension Scheme {
    static func makeScheme(target: ConfigurationName, name: String) -> Scheme {
        
        return Scheme(
            name: name,
            shared: true,
            buildAction: .buildAction(targets: ["\(name)"]),
            testAction: .targets(
                ["\(name)Tests"],
                configuration: target,
                options: .options(coverage: true, codeCoverageTargets: ["\(name)"])
            ),
            runAction: .runAction(configuration: target),
            archiveAction: .archiveAction(configuration: target),
            profileAction: .profileAction(configuration: target),
            analyzeAction: .analyzeAction(configuration: target)
        )
    }
}
