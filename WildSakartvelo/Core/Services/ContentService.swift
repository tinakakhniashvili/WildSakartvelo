protocol ContentProviding {
    func loadEcosystems() throws -> [Ecosystem]
    func loadAnimals() throws -> [Animal]
    func loadPlants() throws -> [Plant]
    func loadMissions() throws -> [Mission]
    func loadActivities() throws -> [MissionActivity]
    func loadContentPacks() throws -> [ContentPack]
    func loadDailyDiscoveries() throws -> [DailyDiscovery]
    func loadExplorerChallenges() throws -> [ExplorerChallenge]
    func loadObservationActivities() throws -> [ObservationActivity]
    func loadRegions() throws -> [GeorgiaRegion]
    func loadCities() throws -> [GeorgianCity]
    func loadGeographyLandmarks() throws -> [GeographyLandmark]
    func loadGeographyMissions() throws -> [GeographyMission]
    func loadGeographyActivities() throws -> [GeographyActivity]
}

struct ContentService: ContentProviding {
    func loadEcosystems() throws -> [Ecosystem] {
        try JSONLoader.load("ecosystems")
    }

    func loadAnimals() throws -> [Animal] {
        try JSONLoader.load("animals")
    }

    func loadPlants() throws -> [Plant] {
        try JSONLoader.load("plants")
    }

    func loadMissions() throws -> [Mission] {
        try JSONLoader.load("missions")
    }

    func loadActivities() throws -> [MissionActivity] {
        try JSONLoader.load("activities")
    }

    func loadContentPacks() throws -> [ContentPack] {
        try JSONLoader.load("contentPacks")
    }

    func loadDailyDiscoveries() throws -> [DailyDiscovery] {
        try JSONLoader.load("dailyDiscoveries")
    }

    func loadExplorerChallenges() throws -> [ExplorerChallenge] {
        try JSONLoader.load("explorerChallenges")
    }

    func loadObservationActivities() throws -> [ObservationActivity] {
        try JSONLoader.load("observationActivities")
    }

    func loadRegions() throws -> [GeorgiaRegion] {
        try JSONLoader.load("georgiaRegions")
    }

    func loadCities() throws -> [GeorgianCity] {
        try JSONLoader.load("georgianCities")
    }

    func loadGeographyLandmarks() throws -> [GeographyLandmark] {
        try JSONLoader.load("geographyLandmarks")
    }

    func loadGeographyMissions() throws -> [GeographyMission] {
        try JSONLoader.load("geographyMissions")
    }

    func loadGeographyActivities() throws -> [GeographyActivity] {
        try JSONLoader.load("geographyActivities")
    }
}
