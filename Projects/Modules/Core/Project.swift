import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.staticFramework(
    name: "Core",
    dependencies: [
        .Project.Modules.ThirdPartyLib
    ]
)
