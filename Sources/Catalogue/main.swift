import CatalogueKit
import Foundation

//guard CommandLine.arguments.count > 1 else {
//    fatalError("Path to write required as a parameter")
//}
let path = CommandLine.arguments.count > 1 ? CommandLine.arguments[1] : "Okay"

do {
    let colorJson: [String: Any] = [
        "name": "BackgroundPrimary",
        "variants": [
            [
                "luminosity": "any",
                "contrast": "normal",
                "colorSpace": "srgb",
                "hex": [
                    "red": 255,
                    "green": 120,
                    "blue": 241,
                    "alpha": 1.0
                ]
            ],
            [
                "luminosity": "light",
                "contrast": "normal",
                "colorSpace": "srgb",
                "hex": [
                    "red": 255,
                    "green": 120,
                    "blue": 241,
                    "alpha": 1.0
                ]
            ],
            [
                "luminosity": "dark",
                "contrast": "normal",
                "colorSpace": "srgb",
                "hex": [
                    "red": 255,
                    "green": 120,
                    "blue": 241,
                    "alpha": 1.0
                ]
            ],
            [
                "luminosity": "any",
                "contrast": "high",
                "colorSpace": "srgb",
                "hex": [
                    "red": 255,
                    "green": 120,
                    "blue": 241,
                    "alpha": 1.0
                ]
            ],
            [
                "luminosity": "light",
                "contrast": "high",
                "colorSpace": "srgb",
                "hex": [
                    "red": 255,
                    "green": 120,
                    "blue": 241,
                    "alpha": 1.0
                ]
            ],
            [
                "luminosity": "dark",
                "contrast": "high",
                "colorSpace": "srgb",
                "hex": [
                    "red": 255,
                    "green": 120,
                    "blue": 241,
                    "alpha": 1.0
                ]
            ]
        ]
    ]

    let data = try JSONSerialization.data(withJSONObject: colorJson, options: [])
    let decoder = JSONDecoder()
    let color = try decoder.decode(Color.self, from: data)

    let creator = AssetCreator(assetFileName: "Primer")
    try creator.write([color], at: path)
} catch {
    print(error.localizedDescription)
    exit(1)
//    fatalError(error.localizedDescription)
}
