import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.staticFramework(
    name: "Domain",
    dependencies: [
        .Project.Modules.Error,
        .Project.Modules.ThirdPartyLib,
        .Project.Services.DataMapping
    ]
)
