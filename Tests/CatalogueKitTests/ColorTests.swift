import XCTest
import Foundation
import CatalogueKit

final class ColorTests: XCTestCase {
    func testCodable() throws {
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
                ]
            ]
        ]

        let data = try JSONSerialization.data(withJSONObject: colorJson, options: [])
        let color = try JSONDecoder().decode(Color.self, from: data)
        XCTAssertEqual(color.variants.count, 1)
        XCTAssertEqual(color.name, "BackgroundPrimary")
        guard let variant = color.variants.first else {
            XCTFail()
            return
        }
        XCTAssertEqual(variant.colorSpace, .srgb)
        XCTAssertEqual(variant.contrast, .normal)
        XCTAssertEqual(variant.luminosity, .any)
        XCTAssertEqual(variant.hex.red, 255)
        XCTAssertEqual(variant.hex.green, 120)
        XCTAssertEqual(variant.hex.blue, 241)
        XCTAssertEqual(variant.hex.alpha, 1.0)
    }

    func testMultipleVariants() throws {
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
        let color = try JSONDecoder().decode(Color.self, from: data)
        XCTAssertEqual(color.variants.count, 6)

        Color.Luminosity.allCases.forEach { luminosity in
            Color.Contrast.allCases.forEach { contrast in
                let variant = color.variants.first(where: {
                    $0.luminosity == luminosity
                        && $0.contrast == contrast
                })
                XCTAssertNotNil(variant)
            }
        }
    }

    func testFromHexValue() throws {
        let cases = [
            "#123": Color.HexRepresentation(r: 17, g: 34, b: 51, a: 1.0),
            "#1113": Color.HexRepresentation(r: 17, g: 17, b: 17, a: 0.2),
            "#FF3A30": Color.HexRepresentation(r: 255, g: 58, b: 48, a: 1.0),
            "#11111111": Color.HexRepresentation(r: 17, g: 17, b: 17, a: 0.067),
        ]

        cases.forEach { (key, value) in
            let converted = try? Color.HexRepresentation(hexString: key)
            XCTAssertEqual(converted, value, "Mismatched value: \(key)")
        }
    }

    static var allTests = [
        ("testCodable", testCodable),
        ("testMultipleVariants", testMultipleVariants)
    ]
}
