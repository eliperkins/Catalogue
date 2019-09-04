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
            } else if let stringValue = try? decoder.singleValueContainer() as? String {
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
    }

    public let name: String
    public let variants: [Variant]
}

public struct HexConverting {
    enum DecodingError: Error {
        case incorrectLength
        case malformedHexValue(String)
    }

    public static func fromStringValue(_ hex: String) throws -> Color.HexRepresentation  {
        let stripped = hex.starts(with: "#") ? String(hex.dropFirst()) : hex
        switch stripped.count {
        case 3: return try fromThreeCharacterValue(stripped)
        case 4: return try fromFourCharacterValue(stripped)
        case 6: return try fromSixCharacterValue(stripped)
        case 8: return try fromEightCharacterValue(stripped)
        default: throw DecodingError.incorrectLength
        }
    }

    static func fromThreeCharacterValue(_ hex: String) throws -> Color.HexRepresentation {
        return try fromSixCharacterValue(hex.map { String($0) + String($0) }.reduce("", +))
    }

    static func fromFourCharacterValue(_ hex: String) throws -> Color.HexRepresentation {
        return try fromEightCharacterValue(hex.map { String($0) + String($0) }.reduce("", +))
    }

    static func fromSixCharacterValue(_ hex: String) throws -> Color.HexRepresentation {
        return try fromEightCharacterValue(hex + "ff")
    }

    static func fromEightCharacterValue(_ hex: String) throws -> Color.HexRepresentation {
        guard let intValue = Int(hex, radix: 16) else {
            throw DecodingError.malformedHexValue(hex)
        }

        let r = (intValue & 0xff000000) >> 24
        let g = (intValue & 0x00ff0000) >> 16
        let b = (intValue & 0x0000ff00) >> 8

        var inputAlphaDecimal = Decimal(Double(intValue & 0x000000ff) / 255)
        var roundedAlpha = Decimal(0)
        NSDecimalRound(&roundedAlpha, &inputAlphaDecimal, 3, .plain)

        return Color.HexRepresentation(r: r, g: g, b: b, a: Double(truncating: roundedAlpha as NSNumber))
    }
}
