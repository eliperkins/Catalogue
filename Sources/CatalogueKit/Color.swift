import Foundation

public struct Color: Codable {
    public enum Luminosity: String, Codable, CaseIterable {
        case any
        case light
        case dark
    }

    public enum Contrast: String, Codable, CaseIterable {
        case normal
        case high
    }

    public enum ColorSpace: String, Codable {
        case srgb
    }

    public struct HexRepresentation: Equatable,Codable {
        public let red: Int
        public let green: Int
        public let blue: Int
        public let alpha: Double

        public init(from decoder: Decoder) throws {
            if let values = try? decoder.container(keyedBy: CodingKeys.self) {
                red = try values.decode(Int.self, forKey: .red)
                green = try values.decode(Int.self, forKey: .green)
                blue = try values.decode(Int.self, forKey: .blue)
                alpha = try values.decode(Double.self, forKey: .alpha)
            } else if let container = try? decoder.singleValueContainer() {
                let stringValue = try container.decode(String.self)
                self = try HexConverting.fromStringValue(stringValue)
            } else {
                throw DecodingError.typeMismatch(
                    HexRepresentation.self,
                    DecodingError.Context(codingPath: [], debugDescription: "Missing value")
                )
            }
        }

        public init(hexString: String) throws {
            self = try HexConverting.fromStringValue(hexString)
        }

        public init(r: Int, g: Int, b: Int, a: Double) {
            red = r
            green = g
            blue = b
            alpha = a
        }
    }

    public struct Variant: Codable {
        public let luminosity: Luminosity
        public let contrast: Contrast
        public let colorSpace = ColorSpace.srgb
        public let hex: HexRepresentation

        enum CodingKeys: String, CodingKey {
            case luminosity
            case contrast
            case colorSpace
            case hex = "hexWithTrailingAlpha"
        }
    }

    public let name: String
    public let variants: [Variant]
}
