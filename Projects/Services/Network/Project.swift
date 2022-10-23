import ProjectDescription
import ProjectDescriptionHelpers
import UtilityPlugin

let project = Project.staticFramework(
    name: "Network",
    dependencies: [
        .Project.Domain,
        .Project.Modules.Core,
        .Project.Services.APIKit
    ]
)
