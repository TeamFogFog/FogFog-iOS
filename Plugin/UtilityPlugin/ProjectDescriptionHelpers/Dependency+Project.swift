import ProjectDescription

public extension TargetDependency {
    enum Project {
        public enum Modules {}
        public enum Services {}
        public enum UserInterfaces {}
    }
}

public extension TargetDependency.Project.Modules {
    // static let ThirdPartyLib = TargetDependency.module(name: "ThirdPartyLib")
    // static let Utility = TargetDependency.module(name: "Utility")
}

public extension TargetDependency.Project.Services {
    // static let APIKit = TargetDependency.service(name: "APIKit")
    // static let Data = TargetDependency.service(name: "DataModule")
    // static let Domain = TargetDependency.service(name: "DomainModule")
    // static let DatabaseModule = TargetDependency.service(name: "DatabaseModule")
    // static let NetworkModule = TargetDependency.service(name: "NetworkModule")
    // static let DataMappingModule = TargetDependency.service(name: "DataMappingModule")
}

public extension TargetDependency.Project.UserInterfaces {
    // static let DesignSystem = TargetDependency.ui(name: "DesignSystem")
}
