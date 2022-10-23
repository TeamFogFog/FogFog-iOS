import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.staticFramework(
    name: "Data",
    dependencies: [
        .Project.Domain,
        .Project.Services.Network
    ])
