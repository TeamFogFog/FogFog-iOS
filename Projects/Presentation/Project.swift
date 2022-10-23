import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.staticFramework(
    name: "Presentation",
    dependencies: [
        .Project.Domain,
        .Project.Modules.Core,
        .Project.Modules.ThirdPartyLib,
        .Project.UserInterfaces.DesignSystem
    ]
)
