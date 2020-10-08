import CatalogueKit
import Foundation

guard CommandLine.arguments.count == 3 else {
    fatalError("Usage: catalogue source.json OutputDir/")
}
let source = CommandLine.arguments[1]
let outputPath = CommandLine.arguments[2]

do {
    // TODO
    if #available(OSX 10.11, *) {
        let sourceDataPath = URL(fileURLWithPath: FileManager.default.currentDirectoryPath).appendingPathComponent(source)
        let data = try Data(contentsOf: sourceDataPath)
        let decoder = JSONDecoder()
        let colors = try decoder.decode([Color].self, from: data)
        let creator = AssetCreator(assetFileName: "Assets")
        try creator.write(colors, at: outputPath)
    }
} catch {
    print(error.localizedDescription)
    dump(error)
    exit(1)
//    fatalError(error.localizedDescription)
}
