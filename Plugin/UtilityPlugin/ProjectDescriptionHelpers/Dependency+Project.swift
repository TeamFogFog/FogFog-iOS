import ProjectDescription

public extension TargetDependency {
    enum Project {
        public enum Modules {}
        public enum Services {}
        public enum UserInterfaces {}
    }
}

public extension TargetDependency.Project {
    static let Data = TargetDependency.project(name: "Data")
    static let Domain = TargetDependency.project(name: "Domain")
    static let Presentation = TargetDependency.project(name: "Presentation")
}

public extension TargetDependency.Project.Modules {
    static let Core = TargetDependency.module(name: "Core")
    static let Error = TargetDependency.module(name: "Error")
    static let ThirdPartyLib = TargetDependency.module(name: "ThirdPartyLib")
}

public extension TargetDependency.Project.Services {
    static let APIKit = TargetDependency.service(name: "APIKit")
    static let Network = TargetDependency.service(name: "Network")
    static let DataMapping = TargetDependency.service(name: "DataMapping")
}

public extension TargetDependency.Project.UserInterfaces {
    static let DesignSystem = TargetDependency.ui(name: "DesignSystem")
}
