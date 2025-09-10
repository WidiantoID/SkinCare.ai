import Foundation

public enum SkinCondition: String, Codable, CaseIterable, Identifiable {
    case acne
    case redness
    case darkSpots
    case wrinkles
    case pigmentation
    case dryness
    case oiliness
    case sensitivity
    case dullness
    case dehydration
    case sunDamage
    case pores
    case texture

    public var id: String { rawValue }
}


