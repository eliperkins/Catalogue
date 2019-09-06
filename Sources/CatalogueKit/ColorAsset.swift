struct ColorAsset: Codable {
    struct Info: Codable {
        let version: Int = 1
        let author: String = "xcode"
    }

    struct AssetColor: Codable {
        enum Idiom: String, Codable {
            case universal
        }

        struct Appearance: Codable {
            let appearance: String
            let value: String
        }

        struct ColorValue: Codable {
            struct Components: Codable {
                let red: String
                let green: String
                let blue: String
                let alpha: String
            }

            let colorSpace: String
            let components: Components

            enum CodingKeys: String, CodingKey {
                case colorSpace = "color-space"
                case components
            }
        }

        let idiom: Idiom = .universal
        let appearances: [Appearance]?
        let color: ColorValue
    }

    let info = Info()
    let colors: [AssetColor]

    init(from variants: [Color.Variant]) {
        func appearances(from variant: Color.Variant) -> [ColorAsset.AssetColor.Appearance]? {
            switch (variant.contrast, variant.luminosity) {
            case (.normal, .light),
                 (.normal, .dark):
                return [
                    ColorAsset.AssetColor.Appearance(appearance: "luminosity", value: variant.luminosity.rawValue)
                ]
            case (.high, .dark),
                 (.high, .light):
                return [
                    ColorAsset.AssetColor.Appearance(appearance: "contrast", value: variant.contrast.rawValue),
                    ColorAsset.AssetColor.Appearance(appearance: "luminosity", value: variant.luminosity.rawValue)
                ]
            case (.high, .any):
                return [
                    ColorAsset.AssetColor.Appearance(appearance: "contrast", value: variant.contrast.rawValue),
                ]
            case (.normal, .any):
                return nil
            }
        }

        func normalize(_ variants: [Color.Variant]) -> [Color.Variant] {
            // TODO: handle multiple contrasts
            if variants.contains(where: { $0.luminosity == .any }) {
                return variants
            }

            guard let lightVariant = variants.first(where: { $0.luminosity == .light }) else {
                return variants
            }

            let anyVariant = Color.Variant(luminosity: .any, contrast: lightVariant.contrast, hex: lightVariant.hex)
            return variants + [anyVariant]
        }

        self.colors = normalize(variants).map { variant in
            AssetColor(
                appearances: appearances(from: variant),
                color: ColorAsset.AssetColor.ColorValue(
                    colorSpace: variant.colorSpace.rawValue,
                    components: ColorAsset.AssetColor.ColorValue.Components(
                        red: String(variant.hex.red),
                        green: String(variant.hex.green),
                        blue: String(variant.hex.blue),
                        alpha: String(variant.hex.alpha)
                )))
        }
    }
}
