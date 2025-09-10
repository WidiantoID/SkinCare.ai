import Foundation

public struct Ingredient: Identifiable, Codable, Equatable {
    public let id: UUID
    public let name: String
    public let description: String
    public let benefits: [String]
    public let helpsWith: [SkinCondition]
    public let cautions: [String]
    public var isFavorite: Bool
    public var isUserCreated: Bool

    public init(
        id: UUID = UUID(),
        name: String,
        description: String,
        benefits: [String],
        helpsWith: [SkinCondition],
        cautions: [String] = [],
        isFavorite: Bool = false,
        isUserCreated: Bool = false
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.benefits = benefits
        self.helpsWith = helpsWith
        self.cautions = cautions
        self.isFavorite = isFavorite
        self.isUserCreated = isUserCreated
    }
}

public enum IngredientCatalog {
    public static let sample: [Ingredient] = [
        Ingredient(
            name: "Salicylic Acid",
            description: "A beta-hydroxy acid (BHA) that exfoliates inside pores to reduce congestion.",
            benefits: ["Unclogs pores", "Reduces blackheads", "Improves texture"],
            helpsWith: [.acne],
            cautions: ["May cause dryness or irritation"],
            isFavorite: true
        ),
        Ingredient(
            name: "Azelaic Acid",
            description: "Dicarboxylic acid that reduces redness and brightens.",
            benefits: ["Reduces redness", "Fades spots", "Antimicrobial"],
            helpsWith: [.redness, .acne, .pigmentation],
            cautions: []
        ),
        Ingredient(
            name: "Niacinamide",
            description: "Vitamin B3 that supports barrier function and regulates sebum.",
            benefits: ["Reduces redness", "Improves tone", "Balances oil"],
            helpsWith: [.redness, .darkSpots],
            cautions: [],
            isUserCreated: true
        ),
        Ingredient(
            name: "Vitamin C (Ascorbic Acid)",
            description: "Antioxidant that brightens and supports collagen production.",
            benefits: ["Brightens dullness", "Fades dark spots", "Fights free radicals"],
            helpsWith: [.darkSpots, .pigmentation, .wrinkles],
            cautions: ["Can be unstable; store properly"]
        ),
        Ingredient(
            name: "Retinol",
            description: "A vitamin A derivative that accelerates cell turnover.",
            benefits: ["Reduces fine lines", "Improves texture", "Clears pores"],
            helpsWith: [.wrinkles, .acne, .pigmentation],
            cautions: ["May increase sensitivity", "Use SPF during the day"]
        ),
        Ingredient(
            name: "Retinal",
            description: "A potent retinoid often better tolerated than retinol.",
            benefits: ["Anti-aging", "Texture", "Acne"],
            helpsWith: [.wrinkles, .acne],
            cautions: ["Irritation possible; start slow"]
        ),
        Ingredient(
            name: "Hyaluronic Acid",
            description: "Humectant that draws moisture into the skin for plumping hydration.",
            benefits: ["Hydrates", "Plumps fine lines", "Supports barrier"],
            helpsWith: [.wrinkles, .redness, .dryness, .dehydration],
            cautions: []
        ),
        Ingredient(
            name: "Ceramides",
            description: "Lipids that restore and strengthen the skin barrier.",
            benefits: ["Strengthens barrier", "Locks moisture", "Soothes"],
            helpsWith: [.redness, .dryness, .sensitivity],
            cautions: []
        ),
        Ingredient(
            name: "Glycolic Acid",
            description: "AHA exfoliant that smooths texture and brightens.",
            benefits: ["Exfoliates", "Brightens", "Fades spots"],
            helpsWith: [.darkSpots, .pigmentation, .wrinkles, .texture, .dullness],
            cautions: ["Photosensitivity; use SPF"]
        ),
        Ingredient(
            name: "Lactic Acid",
            description: "Gentler AHA for mild exfoliation and hydration.",
            benefits: ["Exfoliates", "Hydrates", "Smooths"],
            helpsWith: [.wrinkles, .darkSpots, .texture, .dullness],
            cautions: []
        ),
        Ingredient(
            name: "Mandelic Acid",
            description: "Large-molecule AHA suitable for sensitive skin.",
            benefits: ["Gentle exfoliation", "Tone", "Texture"],
            helpsWith: [.acne, .darkSpots, .texture],
            cautions: []
        ),
        Ingredient(
            name: "Benzoyl Peroxide",
            description: "Antibacterial agent that targets acne-causing bacteria.",
            benefits: ["Reduces acne", "Prevents breakouts"],
            helpsWith: [.acne, .pores],
            cautions: ["May bleach fabrics", "Irritating"]
        ),
        Ingredient(
            name: "Zinc",
            description: "Mineral that soothes and regulates oil.",
            benefits: ["Soothing", "Sebum control"],
            helpsWith: [.acne, .redness, .oiliness],
            cautions: []
        ),
        Ingredient(
            name: "Arbutin",
            description: "Skin-brightening agent that targets hyperpigmentation.",
            benefits: ["Fades spots", "Evens tone"],
            helpsWith: [.darkSpots, .pigmentation],
            cautions: []
        ),
        Ingredient(
            name: "Kojic Acid",
            description: "Brightener derived from fungi; inhibits melanin.",
            benefits: ["Fades dark spots", "Evens tone"],
            helpsWith: [.darkSpots, .pigmentation],
            cautions: ["Sensitivity possible"]
        ),
        Ingredient(
            name: "Tranexamic Acid",
            description: "Amino acid derivative for stubborn hyperpigmentation.",
            benefits: ["Targets melasma", "Brightens"],
            helpsWith: [.pigmentation, .darkSpots],
            cautions: []
        ),
        Ingredient(
            name: "Bakuchiol",
            description: "Plant-derived retinol alternative with better tolerance.",
            benefits: ["Anti-aging", "Tone", "Texture"],
            helpsWith: [.wrinkles, .pigmentation, .texture],
            cautions: []
        ),
        Ingredient(
            name: "Peptides",
            description: "Short chains of amino acids supporting skin structure.",
            benefits: ["Firming", "Repair"],
            helpsWith: [.wrinkles, .texture],
            cautions: []
        ),
        Ingredient(
            name: "Squalane",
            description: "Lightweight emollient mimicking skin's sebum.",
            benefits: ["Moisturizes", "Soothes"],
            helpsWith: [.redness, .dryness, .dehydration],
            cautions: []
        ),
        Ingredient(
            name: "Centella Asiatica",
            description: "Soothing botanical that calms irritation.",
            benefits: ["Reduces redness", "Soothes"],
            helpsWith: [.redness, .sensitivity],
            cautions: []
        ),
        Ingredient(
            name: "Green Tea",
            description: "Antioxidant and soothing extract.",
            benefits: ["Antioxidant", "Soothing"],
            helpsWith: [.redness, .oiliness, .sensitivity],
            cautions: []
        ),
        Ingredient(
            name: "Licorice Root",
            description: "Brightening and soothing botanical.",
            benefits: ["Fades spots", "Soothes"],
            helpsWith: [.darkSpots, .redness, .dullness],
            cautions: []
        )
    ]

    // MARK: - Comprehensive Catalog
    // We build a large catalog from category name lists with category-derived defaults.
    public static let comprehensive: [Ingredient] = {
        func make(_ name: String, category: String) -> Ingredient {
            switch category {
            case "AHA":
                return Ingredient(
                    name: name,
                    description: "Alpha Hydroxy Acid that gently exfoliates to smooth texture and brighten.",
                    benefits: ["Exfoliates", "Brightens", "Smooths texture"],
                    helpsWith: [.texture, .dullness, .darkSpots]
                )
            case "BHA":
                return Ingredient(
                    name: name,
                    description: "Beta Hydroxy Acid that penetrates pores to reduce congestion.",
                    benefits: ["Unclogs pores", "Reduces blackheads", "Improves clarity"],
                    helpsWith: [.acne, .pores, .oiliness]
                )
            case "PHA":
                return Ingredient(
                    name: name,
                    description: "Polyhydroxy Acid offering gentle exfoliation with added hydration.",
                    benefits: ["Gentle exfoliation", "Hydrates", "Smooths"],
                    helpsWith: [.texture, .dullness, .sensitivity]
                )
            case "Retinoid":
                return Ingredient(
                    name: name,
                    description: "Vitamin A derivative supporting cell turnover and collagen.",
                    benefits: ["Anti-aging", "Improves texture", "Clears pores"],
                    helpsWith: [.wrinkles, .texture, .acne]
                )
            case "Vitamin C":
                return Ingredient(
                    name: name,
                    description: "Vitamin C/derivative with antioxidant and brightening properties.",
                    benefits: ["Brightens", "Antioxidant", "Supports collagen"],
                    helpsWith: [.darkSpots, .dullness, .sunDamage]
                )
            case "Peptide":
                return Ingredient(
                    name: name,
                    description: "Peptide that supports skin firmness and repair.",
                    benefits: ["Firms", "Supports barrier", "Smooths"],
                    helpsWith: [.wrinkles, .texture]
                )
            case "B Vitamin":
                return Ingredient(
                    name: name,
                    description: "B vitamin supporting barrier and soothing skin.",
                    benefits: ["Soothes", "Supports barrier"],
                    helpsWith: [.redness, .dryness, .dehydration]
                )
            case "Antioxidant":
                return Ingredient(
                    name: name,
                    description: "Antioxidant that helps fight free radicals and brighten.",
                    benefits: ["Antioxidant", "Brightens"],
                    helpsWith: [.dullness, .sunDamage]
                )
            case "Brightener":
                return Ingredient(
                    name: name,
                    description: "Brightening agent that targets uneven tone and dark spots.",
                    benefits: ["Evens tone", "Fades spots"],
                    helpsWith: [.darkSpots, .pigmentation]
                )
            case "Humectant":
                return Ingredient(
                    name: name,
                    description: "Humectant that attracts water to hydrate skin.",
                    benefits: ["Hydrates", "Plumps"],
                    helpsWith: [.dehydration, .dryness]
                )
            case "Ceramide":
                return Ingredient(
                    name: name,
                    description: "Ceramide lipid that helps restore and strengthen the barrier.",
                    benefits: ["Strengthens barrier", "Locks moisture"],
                    helpsWith: [.dryness, .sensitivity]
                )
            case "Emollient":
                return Ingredient(
                    name: name,
                    description: "Emollient that softens and smooths skin.",
                    benefits: ["Softens", "Nourishes"],
                    helpsWith: [.dryness, .dehydration]
                )
            case "Occlusive":
                return Ingredient(
                    name: name,
                    description: "Occlusive that seals in moisture and protects the barrier.",
                    benefits: ["Locks in moisture", "Protects"],
                    helpsWith: [.dryness, .dehydration]
                )
            case "Botanical":
                return Ingredient(
                    name: name,
                    description: "Botanical extract with soothing/antioxidant properties.",
                    benefits: ["Soothes", "Antioxidant"],
                    helpsWith: [.redness, .sensitivity]
                )
            case "Marine":
                return Ingredient(
                    name: name,
                    description: "Marine-derived ingredient supporting hydration and minerals.",
                    benefits: ["Mineral rich", "Hydrates"],
                    helpsWith: [.dehydration, .dryness]
                )
            case "Enzyme":
                return Ingredient(
                    name: name,
                    description: "Enzyme exfoliant that gently dissolves dead skin.",
                    benefits: ["Gentle exfoliation", "Brightens"],
                    helpsWith: [.texture, .dullness]
                )
            case "Cleanser":
                return Ingredient(
                    name: name,
                    description: "Gentle surfactant/cleanser that removes impurities.",
                    benefits: ["Cleanses", "Gentle"],
                    helpsWith: [.oiliness, .pores]
                )
            case "Surfactant":
                return Ingredient(
                    name: name,
                    description: "Traditional surfactant used for cleansing formulations.",
                    benefits: ["Foaming", "Cleansing"],
                    helpsWith: [.oiliness]
                )
            case "Preservative":
                return Ingredient(
                    name: name,
                    description: "Preservative that helps keep formulas stable and safe.",
                    benefits: ["Stabilizes", "Protects formula"],
                    helpsWith: [.sensitivity]
                )
            case "Natural Preservative":
                return Ingredient(
                    name: name,
                    description: "Naturally-derived preservative/antioxidant for stability.",
                    benefits: ["Antioxidant", "Stabilizes"],
                    helpsWith: [.sunDamage]
                )
            case "pH":
                return Ingredient(
                    name: name,
                    description: "pH adjuster/buffer used to balance formulation acidity.",
                    benefits: ["Balances pH"],
                    helpsWith: [.sensitivity]
                )
            case "Thickener":
                return Ingredient(
                    name: name,
                    description: "Thickener/texture modifier for formulation aesthetics.",
                    benefits: ["Stabilizes texture"],
                    helpsWith: [.sensitivity]
                )
            case "Anti-Aging":
                return Ingredient(
                    name: name,
                    description: "Active that targets signs of aging and supports firmness.",
                    benefits: ["Anti-aging", "Firms"],
                    helpsWith: [.wrinkles, .texture]
                )
            case "Acne":
                return Ingredient(
                    name: name,
                    description: "Active that helps reduce acne and blemishes.",
                    benefits: ["Targets acne", "Clarifies"],
                    helpsWith: [.acne, .pores]
                )
            case "Soothing":
                return Ingredient(
                    name: name,
                    description: "Soothing/anti-inflammatory ingredient.",
                    benefits: ["Soothes", "Calms irritation"],
                    helpsWith: [.redness, .sensitivity]
                )
            case "UV Filter":
                return Ingredient(
                    name: name,
                    description: "UV filter used for sun protection in sunscreens.",
                    benefits: ["UV protection"],
                    helpsWith: [.sunDamage]
                )
            case "Exfoliant":
                return Ingredient(
                    name: name,
                    description: "Physical exfoliant providing mechanical polishing.",
                    benefits: ["Exfoliates", "Smooths"],
                    helpsWith: [.texture]
                )
            case "Pigment":
                return Ingredient(
                    name: name,
                    description: "Color additive/pigment used in tinted skincare.",
                    benefits: ["Color/Tint"],
                    helpsWith: [.sunDamage]
                )
            case "Fragrance":
                return Ingredient(
                    name: name,
                    description: "Fragrance component/essential oil.",
                    benefits: ["Scent"],
                    helpsWith: [.sensitivity]
                )
            default:
                return Ingredient(
                    name: name,
                    description: "Skincare ingredient.",
                    benefits: [],
                    helpsWith: []
                )
            }
        }

        var out: [Ingredient] = []

        // Active Ingredients
        let ahas = ["Glycolic Acid", "Lactic Acid", "Mandelic Acid", "Citric Acid", "Malic Acid", "Tartaric Acid", "Phytic Acid"].map { make($0, category: "AHA") }
        let bhas = ["Salicylic Acid", "Betaine Salicylate"].map { make($0, category: "BHA") }
        let phas = ["Gluconolactone", "Lactobionic Acid", "Galactose"].map { make($0, category: "PHA") }
        let retinoids = ["Retinol", "Retinyl Palmitate", "Retinyl Acetate", "Retinaldehyde (Retinal)", "Adapalene", "Tretinoin", "Tazarotene", "Isotretinoin", "Hydroxypinacolone Retinoate (HPR)", "Retinyl Retinoate"].map { make($0, category: "Retinoid") }
        let vitaminC = ["L-Ascorbic Acid", "Magnesium Ascorbyl Phosphate (MAP)", "Sodium Ascorbyl Phosphate (SAP)", "Ascorbyl Glucoside", "Ethyl Ascorbic Acid", "Ascorbyl Palmitate", "Calcium Ascorbate", "3-O-Ethyl Ascorbic Acid"].map { make($0, category: "Vitamin C") }
        let peptides = ["Copper Peptides (GHK-Cu)", "Palmitoyl Pentapeptide-4 (Matrixyl)", "Palmitoyl Tripeptide-1", "Palmitoyl Tripeptide-5", "Acetyl Hexapeptide-8 (Argireline)", "Palmitoyl Tetrapeptide-7", "Dipeptide Diaminobutyroyl Benzylamide Diacetate", "Tripeptide-10 Citrulline", "Pentapeptide-18", "Acetyl Octapeptide-3"].map { make($0, category: "Peptide") }
        let bVitamins = ["Niacinamide (Vitamin B3)", "Panthenol (Pro-Vitamin B5)", "Pyridoxine (Vitamin B6)", "Biotin (Vitamin B7)", "Riboflavin (Vitamin B2)", "Thiamine (Vitamin B1)"].map { make($0, category: "B Vitamin") }
        let antioxidants = ["Vitamin E (Tocopherol)", "Ferulic Acid", "Resveratrol", "Green Tea Extract (EGCG)", "Vitamin K", "CoQ10 (Ubiquinone)", "Idebenone", "Astaxanthin", "Lycopene", "Alpha Lipoic Acid", "Pycnogenol", "Grape Seed Extract", "White Tea Extract", "Pomegranate Extract", "Açai Extract", "Goji Berry Extract"].map { make($0, category: "Antioxidant") }
        let brighteners = ["Hydroquinone", "Kojic Acid", "Arbutin", "Alpha Arbutin", "Licorice Root Extract", "Mulberry Extract", "Bearberry Extract", "Azelaic Acid", "Tranexamic Acid", "Magnesium Ascorbyl Phosphate"].map { make($0, category: "Brightener") }

        // Moisturizing & Hydrating
        let humectants = ["Hyaluronic Acid", "Sodium Hyaluronate", "Glycerin", "Propylene Glycol", "Butylene Glycol", "Sorbitol", "Honey", "Sodium PCA", "Urea", "Lactic Acid", "Glycolic Acid", "Panthenol", "Algae Extract", "Aloe Vera", "Beta-Glucan"].map { make($0, category: "Humectant") }
        let ceramideList = ["Ceramide NP", "Ceramide AP", "Ceramide EOP", "Ceramide NS", "Ceramide EOS", "Ceramide AS", "Phytosphingosine", "Sphingosine"].map { make($0, category: "Ceramide") }
        let emollients = ["Squalane", "Squalene", "Jojoba Oil", "Argan Oil", "Rosehip Oil", "Marula Oil", "Coconut Oil", "Sweet Almond Oil", "Avocado Oil", "Sunflower Oil", "Safflower Oil", "Grapeseed Oil", "Olive Oil", "Macadamia Oil", "Shea Butter", "Cocoa Butter", "Mango Butter", "Murumuru Butter", "Lanolin", "Petrolatum", "Mineral Oil", "Dimethicone", "Cyclomethicone", "Isopropyl Myristate", "Caprylic/Capric Triglyceride"].map { make($0, category: "Emollient") }
        let occlusives = ["Petrolatum", "Lanolin", "Beeswax", "Carnauba Wax", "Paraffin", "Dimethicone", "Silicones"].map { make($0, category: "Occlusive") }

        // Natural & Plant-Based
        let botanicals = ["Aloe Vera", "Green Tea", "Chamomile", "Calendula", "Witch Hazel", "Rose Hip", "Sea Buckthorn", "Ginkgo Biloba", "Ginseng", "Licorice Root", "Centella Asiatica", "Cica (Centella Asiatica)", "Neem", "Turmeric", "Tea Tree Oil", "Lavender Oil", "Rosemary Extract", "Cucumber Extract", "Oatmeal (Colloidal Oatmeal)", "Honey (Manuka Honey)"].map { make($0, category: "Botanical") }
        let marine = ["Algae (Brown, Red, Green)", "Sea Salt", "Marine Collagen", "Seaweed Extract", "Kelp Extract", "Spirulina", "Chlorella"].map { make($0, category: "Marine") }
        let enzymes = ["Papain (Papaya)", "Bromelain (Pineapple)", "Pumpkin Enzymes"].map { make($0, category: "Enzyme") }

        // Cleansers & Surfactants
        let gentleCleansers = ["Sodium Cocoyl Glutamate", "Coco-Glucoside", "Decyl Glucoside", "Cocamidopropyl Betaine", "Sodium Lauroyl Sarcosinate", "Sodium Cocoyl Isethionate"].map { make($0, category: "Cleanser") }
        let traditionalSurfactants = ["Sodium Lauryl Sulfate (SLS)", "Sodium Laureth Sulfate (SLES)", "Ammonium Lauryl Sulfate"].map { make($0, category: "Surfactant") }

        // Preservatives & Stabilizers
        let preservatives = ["Phenoxyethanol", "Methylparaben", "Propylparaben", "Ethylparaben", "Butylparaben", "Benzyl Alcohol", "Dehydroacetic Acid", "Sodium Benzoate", "Potassium Sorbate", "Caprylyl Glycol", "Ethylhexylglycerin"].map { make($0, category: "Preservative") }
        let naturalPres = ["Rosemary Extract", "Grapefruit Seed Extract", "Vitamin E", "Tea Tree Oil"].map { make($0, category: "Natural Preservative") }

        // pH adjusters & Thickeners
        let phAdjusters = ["Sodium Hydroxide", "Citric Acid", "Lactic Acid", "Triethanolamine", "Aminomethyl Propanol"].map { make($0, category: "pH") }
        let thickeners = ["Carbomer", "Xanthan Gum", "Hyaluronic Acid", "Cetearyl Alcohol", "Stearyl Alcohol", "Cetyl Alcohol", "Glyceryl Stearate", "PEG-100 Stearate"].map { make($0, category: "Thickener") }

        // Specialty Actives
        let antiAging = ["Bakuchiol", "Adenosine", "Caffeine", "DMAE", "Argireline", "Syn-Ake", "Leuphasyl"].map { make($0, category: "Anti-Aging") }
        let acneFighting = ["Benzoyl Peroxide", "Tea Tree Oil", "Sulfur", "Zinc Oxide", "Zinc Pyrithione"].map { make($0, category: "Acne") }
        let soothing = ["Allantoin", "Bisabolol", "Colloidal Oatmeal", "Zinc Oxide", "Calamine", "Centella Asiatica", "Madecassoside", "Asiaticoside"].map { make($0, category: "Soothing") }

        // Sun Protection
        let chemUV = ["Avobenzone", "Octinoxate", "Octisalate", "Oxybenzone", "Homosalate", "Ensulizole"].map { make($0, category: "UV Filter") }
        let physUV = ["Zinc Oxide", "Titanium Dioxide"].map { make($0, category: "UV Filter") }

        // Exfoliating Ingredients
        let physicalExfoliants = ["Jojoba Beads", "Rice Bran", "Walnut Shell Powder", "Apricot Kernel Powder", "Sugar", "Salt"].map { make($0, category: "Exfoliant") }
        let enzymaticExfoliants = ["Papain", "Bromelain", "Subtilisin"].map { make($0, category: "Enzyme") }

        // Pigments & Fragrance
        let pigments = ["Iron Oxides", "Titanium Dioxide", "Mica", "Bismuth Oxychloride", "Chromium Oxide", "Ultramarines"].map { make($0, category: "Pigment") }
        let fragrance = ["Linalool", "Limonene", "Geraniol", "Citronellol", "Benzyl Salicylate", "Hexyl Cinnamal", "Lavender Oil", "Tea Tree Oil", "Peppermint Oil", "Eucalyptus Oil", "Rosemary Oil", "Frankincense Oil", "Jojoba Oil"].map { make($0, category: "Fragrance") }

        out += ahas + bhas + phas + retinoids + vitaminC + peptides + bVitamins + antioxidants + brighteners
        out += humectants + ceramideList + emollients + occlusives
        out += botanicals + marine + enzymes
        out += gentleCleansers + traditionalSurfactants
        out += preservatives + naturalPres
        out += phAdjusters + thickeners
        out += antiAging + acneFighting + soothing
        out += chemUV + physUV
        out += physicalExfoliants + enzymaticExfoliants
        out += pigments + fragrance

        // Remove duplicates by name while preserving first occurrence
        var seen = Set<String>()
        let deduped = out.filter { ing in
            if seen.contains(ing.name.lowercased()) { return false }
            seen.insert(ing.name.lowercased())
            return true
        }
        return deduped
    }()

    public static let all: [Ingredient] = sample + comprehensive
}


