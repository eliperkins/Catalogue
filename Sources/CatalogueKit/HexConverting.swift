import Foundation

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
