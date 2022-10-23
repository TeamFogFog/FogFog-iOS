import ProjectDescription

public extension ProjectDescription.Path {
    static func relativeToSections(_ path: String) -> Self {
        return .relativeToRoot("Projects/\(path)")
    }
    
    static func relativeToModules(_ path: String) -> Self {
        return .relativeToRoot("Projects/Modules/\(path)")
    }
    
    static func relativeToServices(_ path: String) -> Self {
        return .relativeToRoot("Projects/Services/\(path)")
    }
    
    static func relativeToUserInterfaces(_ path: String) -> Self {
        return .relativeToRoot("Projects/UsertInterfaces/\(path)")
    }
    
    static var app: Self {
        return .relativeToRoot("Projects/App")
    }
}

public extension TargetDependency {
    static func module(name: String) -> Self {
        // .project(target:_, path:_)
        // Target 안에 다른 프로젝트의 종속성 형성
        return .project(target: name, path: .relativeToModules(name))
    }
    
    static func service(name: String) -> Self {
        return .project(target: name, path: .relativeToServices(name))
    }
    
    static func ui(name: String) -> Self {
        return .project(target: name, path: .relativeToUserInterfaces(name))
    }
}
