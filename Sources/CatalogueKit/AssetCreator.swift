import Files
import Foundation

public struct AssetCreator {
    let assetFileName: String

    public init(assetFileName: String) {
        self.assetFileName = assetFileName
    }

    private let fileManager = FileManager.default
    private let fileSystem = FileSystem()

    private let encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        return encoder
    }()

    public func write(_ colors: [Color], at path: String) throws {
        let assetFolder = try fileSystem.createFolderIfNeeded(at: path + "/\(assetFileName).xcassets")
        let colorsFolder = try assetFolder.createSubfolder(named: "Colors")

        try colors.forEach { color in
            let currentColorFolder = try colorsFolder.createSubfolder(named: color.name + ".colorset")
            let contents = ColorAsset(from: color.variants)
            let contentsData = try encoder.encode(contents)
            try currentColorFolder.createFile(named: "Contents.json", contents: contentsData)
        }
    }
}
