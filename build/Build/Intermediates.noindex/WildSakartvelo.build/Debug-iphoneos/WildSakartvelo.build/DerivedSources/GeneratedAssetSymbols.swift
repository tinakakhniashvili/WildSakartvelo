import Foundation
#if canImport(DeveloperToolsSupport)
import DeveloperToolsSupport
#endif

#if SWIFT_PACKAGE
private let resourceBundle = Foundation.Bundle.module
#else
private class ResourceBundleClass {}
private let resourceBundle = Foundation.Bundle(for: ResourceBundleClass.self)
#endif

// MARK: - Color Symbols -

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension DeveloperToolsSupport.ColorResource {

}

// MARK: - Image Symbols -

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension DeveloperToolsSupport.ImageResource {

    /// The "alpine_bellflower" asset catalog image resource.
    static let alpineBellflower = DeveloperToolsSupport.ImageResource(name: "alpine_bellflower", bundle: resourceBundle)

    /// The "alpine_chough" asset catalog image resource.
    static let alpineChough = DeveloperToolsSupport.ImageResource(name: "alpine_chough", bundle: resourceBundle)

    /// The "app_logo" asset catalog image resource.
    static let appLogo = DeveloperToolsSupport.ImageResource(name: "app_logo", bundle: resourceBundle)

    /// The "avatar_bear_explorer" asset catalog image resource.
    static let avatarBearExplorer = DeveloperToolsSupport.ImageResource(name: "avatar_bear_explorer", bundle: resourceBundle)

    /// The "avatar_bird_explorer" asset catalog image resource.
    static let avatarBirdExplorer = DeveloperToolsSupport.ImageResource(name: "avatar_bird_explorer", bundle: resourceBundle)

    /// The "avatar_deer_explorer" asset catalog image resource.
    static let avatarDeerExplorer = DeveloperToolsSupport.ImageResource(name: "avatar_deer_explorer", bundle: resourceBundle)

    /// The "avatar_fox_explorer" asset catalog image resource.
    static let avatarFoxExplorer = DeveloperToolsSupport.ImageResource(name: "avatar_fox_explorer", bundle: resourceBundle)

    /// The "avatar_leaf_explorer" asset catalog image resource.
    static let avatarLeafExplorer = DeveloperToolsSupport.ImageResource(name: "avatar_leaf_explorer", bundle: resourceBundle)

    /// The "avatar_mountain_explorer" asset catalog image resource.
    static let avatarMountainExplorer = DeveloperToolsSupport.ImageResource(name: "avatar_mountain_explorer", bundle: resourceBundle)

    /// The "badge_discovery" asset catalog image resource.
    static let badgeDiscovery = DeveloperToolsSupport.ImageResource(name: "badge_discovery", bundle: resourceBundle)

    /// The "beach_grass" asset catalog image resource.
    static let beachGrass = DeveloperToolsSupport.ImageResource(name: "beach_grass", bundle: resourceBundle)

    /// The "black_sea_bottlenose_dolphin" asset catalog image resource.
    static let blackSeaBottlenoseDolphin = DeveloperToolsSupport.ImageResource(name: "black_sea_bottlenose_dolphin", bundle: resourceBundle)

    /// The "black_sea_coast" asset catalog image resource.
    static let blackSeaCoast = DeveloperToolsSupport.ImageResource(name: "black_sea_coast", bundle: resourceBundle)

    /// The "black_sea_coast_cover" asset catalog image resource.
    static let blackSeaCoastCover = DeveloperToolsSupport.ImageResource(name: "black_sea_coast_cover", bundle: resourceBundle)

    /// The "black_sea_dolphin" asset catalog image resource.
    static let blackSeaDolphin = DeveloperToolsSupport.ImageResource(name: "black_sea_dolphin", bundle: resourceBundle)

    /// The "borjomi_forest" asset catalog image resource.
    static let borjomiForest = DeveloperToolsSupport.ImageResource(name: "borjomi_forest", bundle: resourceBundle)

    /// The "borjomi_forest_cover" asset catalog image resource.
    static let borjomiForestCover = DeveloperToolsSupport.ImageResource(name: "borjomi_forest_cover", bundle: resourceBundle)

    /// The "brown_bear" asset catalog image resource.
    static let brownBear = DeveloperToolsSupport.ImageResource(name: "brown_bear", bundle: resourceBundle)

    /// The "caucasian_black_grouse" asset catalog image resource.
    static let caucasianBlackGrouse = DeveloperToolsSupport.ImageResource(name: "caucasian_black_grouse", bundle: resourceBundle)

    /// The "caucasian_fir" asset catalog image resource.
    static let caucasianFir = DeveloperToolsSupport.ImageResource(name: "caucasian_fir", bundle: resourceBundle)

    /// The "caucasian_tur" asset catalog image resource.
    static let caucasianTur = DeveloperToolsSupport.ImageResource(name: "caucasian_tur", bundle: resourceBundle)

    /// The "caucasus_mountains" asset catalog image resource.
    static let caucasusMountains = DeveloperToolsSupport.ImageResource(name: "caucasus_mountains", bundle: resourceBundle)

    /// The "caucasus_mountains_cover" asset catalog image resource.
    static let caucasusMountainsCover = DeveloperToolsSupport.ImageResource(name: "caucasus_mountains_cover", bundle: resourceBundle)

    /// The "caucasus_rhododendron" asset catalog image resource.
    static let caucasusRhododendron = DeveloperToolsSupport.ImageResource(name: "caucasus_rhododendron", bundle: resourceBundle)

    /// The "chamois" asset catalog image resource.
    static let chamois = DeveloperToolsSupport.ImageResource(name: "chamois", bundle: resourceBundle)

    /// The "colchic_box_tree" asset catalog image resource.
    static let colchicBoxTree = DeveloperToolsSupport.ImageResource(name: "colchic_box_tree", bundle: resourceBundle)

    /// The "common_ivy" asset catalog image resource.
    static let commonIvy = DeveloperToolsSupport.ImageResource(name: "common_ivy", bundle: resourceBundle)

    /// The "common_reed" asset catalog image resource.
    static let commonReed = DeveloperToolsSupport.ImageResource(name: "common_reed", bundle: resourceBundle)

    /// The "common_tern" asset catalog image resource.
    static let commonTern = DeveloperToolsSupport.ImageResource(name: "common_tern", bundle: resourceBundle)

    /// The "empty_journal" asset catalog image resource.
    static let emptyJournal = DeveloperToolsSupport.ImageResource(name: "empty_journal", bundle: resourceBundle)

    /// The "eurasian_lynx" asset catalog image resource.
    static let eurasianLynx = DeveloperToolsSupport.ImageResource(name: "eurasian_lynx", bundle: resourceBundle)

    /// The "eurasian_marsh_harrier" asset catalog image resource.
    static let eurasianMarshHarrier = DeveloperToolsSupport.ImageResource(name: "eurasian_marsh_harrier", bundle: resourceBundle)

    /// The "eurasian_otter" asset catalog image resource.
    static let eurasianOtter = DeveloperToolsSupport.ImageResource(name: "eurasian_otter", bundle: resourceBundle)

    /// The "forest_floor" asset catalog image resource.
    static let forestFloor = DeveloperToolsSupport.ImageResource(name: "forest_floor", bundle: resourceBundle)

    /// The "golden_eagle" asset catalog image resource.
    static let goldenEagle = DeveloperToolsSupport.ImageResource(name: "golden_eagle", bundle: resourceBundle)

    /// The "great_cormorant" asset catalog image resource.
    static let greatCormorant = DeveloperToolsSupport.ImageResource(name: "great_cormorant", bundle: resourceBundle)

    /// The "great_egret" asset catalog image resource.
    static let greatEgret = DeveloperToolsSupport.ImageResource(name: "great_egret", bundle: resourceBundle)

    /// The "great_spotted_woodpecker" asset catalog image resource.
    static let greatSpottedWoodpecker = DeveloperToolsSupport.ImageResource(name: "great_spotted_woodpecker", bundle: resourceBundle)

    /// The "grey_heron" asset catalog image resource.
    static let greyHeron = DeveloperToolsSupport.ImageResource(name: "grey_heron", bundle: resourceBundle)

    /// The "kolkheti_wetlands" asset catalog image resource.
    static let kolkhetiWetlands = DeveloperToolsSupport.ImageResource(name: "kolkheti_wetlands", bundle: resourceBundle)

    /// The "kolkheti_wetlands_cover" asset catalog image resource.
    static let kolkhetiWetlandsCover = DeveloperToolsSupport.ImageResource(name: "kolkheti_wetlands_cover", bundle: resourceBundle)

    /// The "loggerhead_sea_turtle" asset catalog image resource.
    static let loggerheadSeaTurtle = DeveloperToolsSupport.ImageResource(name: "loggerhead_sea_turtle", bundle: resourceBundle)

    /// The "lowland_wetland" asset catalog image resource.
    static let lowlandWetland = DeveloperToolsSupport.ImageResource(name: "lowland_wetland", bundle: resourceBundle)

    /// The "marsh_frog" asset catalog image resource.
    static let marshFrog = DeveloperToolsSupport.ImageResource(name: "marsh_frog", bundle: resourceBundle)

    /// The "mediterranean_gull" asset catalog image resource.
    static let mediterraneanGull = DeveloperToolsSupport.ImageResource(name: "mediterranean_gull", bundle: resourceBundle)

    /// The "mission_adventure" asset catalog image resource.
    static let missionAdventure = DeveloperToolsSupport.ImageResource(name: "mission_adventure", bundle: resourceBundle)

    /// The "mountain_thyme" asset catalog image resource.
    static let mountainThyme = DeveloperToolsSupport.ImageResource(name: "mountain_thyme", bundle: resourceBundle)

    /// The "offline_pack" asset catalog image resource.
    static let offlinePack = DeveloperToolsSupport.ImageResource(name: "offline_pack", bundle: resourceBundle)

    /// The "onboarding_journal" asset catalog image resource.
    static let onboardingJournal = DeveloperToolsSupport.ImageResource(name: "onboarding_journal", bundle: resourceBundle)

    /// The "onboarding_map" asset catalog image resource.
    static let onboardingMap = DeveloperToolsSupport.ImageResource(name: "onboarding_map", bundle: resourceBundle)

    /// The "onboarding_safety" asset catalog image resource.
    static let onboardingSafety = DeveloperToolsSupport.ImageResource(name: "onboarding_safety", bundle: resourceBundle)

    /// The "onboarding_welcome" asset catalog image resource.
    static let onboardingWelcome = DeveloperToolsSupport.ImageResource(name: "onboarding_welcome", bundle: resourceBundle)

    /// The "oriental_beech" asset catalog image resource.
    static let orientalBeech = DeveloperToolsSupport.ImageResource(name: "oriental_beech", bundle: resourceBundle)

    /// The "parent_area" asset catalog image resource.
    static let parentArea = DeveloperToolsSupport.ImageResource(name: "parent_area", bundle: resourceBundle)

    /// The "red_fox" asset catalog image resource.
    static let redFox = DeveloperToolsSupport.ImageResource(name: "red_fox", bundle: resourceBundle)

    /// The "red_squirrel" asset catalog image resource.
    static let redSquirrel = DeveloperToolsSupport.ImageResource(name: "red_squirrel", bundle: resourceBundle)

    /// The "reed_warbler" asset catalog image resource.
    static let reedWarbler = DeveloperToolsSupport.ImageResource(name: "reed_warbler", bundle: resourceBundle)

    /// The "rocky_mountain_slope" asset catalog image resource.
    static let rockyMountainSlope = DeveloperToolsSupport.ImageResource(name: "rocky_mountain_slope", bundle: resourceBundle)

    /// The "roe_deer" asset catalog image resource.
    static let roeDeer = DeveloperToolsSupport.ImageResource(name: "roe_deer", bundle: resourceBundle)

    /// The "sand_lizard" asset catalog image resource.
    static let sandLizard = DeveloperToolsSupport.ImageResource(name: "sand_lizard", bundle: resourceBundle)

    /// The "sandy_coast" asset catalog image resource.
    static let sandyCoast = DeveloperToolsSupport.ImageResource(name: "sandy_coast", bundle: resourceBundle)

    /// The "sea_holly" asset catalog image resource.
    static let seaHolly = DeveloperToolsSupport.ImageResource(name: "sea_holly", bundle: resourceBundle)

    /// The "white_water_lily" asset catalog image resource.
    static let whiteWaterLily = DeveloperToolsSupport.ImageResource(name: "white_water_lily", bundle: resourceBundle)

    /// The "wild_boar" asset catalog image resource.
    static let wildBoar = DeveloperToolsSupport.ImageResource(name: "wild_boar", bundle: resourceBundle)

    /// The "yellow_iris" asset catalog image resource.
    static let yellowIris = DeveloperToolsSupport.ImageResource(name: "yellow_iris", bundle: resourceBundle)

}

