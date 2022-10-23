import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.staticFramework(
    name: "APIKit",
    dependencies: [
        .Project.Modules.ThirdPartyLib,
        .Project.Modules.Error,
        .Project.Services.DataMapping
    ]
)
