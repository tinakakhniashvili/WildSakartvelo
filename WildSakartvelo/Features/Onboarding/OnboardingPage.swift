import Foundation

struct OnboardingPage: Identifiable, Hashable {
    let id: String
    let title: String
    let localizedTitle: LocalizedContentText?
    let description: String
    let localizedDescription: LocalizedContentText?
    let systemImage: String
    let imageName: String
    let narrationFileName: String?
    let narrationFileNameEnglish: String?
    let narrationFileNameGeorgian: String?

    func narrationFileName(for language: AppLanguage) -> String? {
        switch language {
        case .english:
            return narrationFileNameEnglish ?? narrationFileNameGeorgian ?? narrationFileName
        case .georgian:
            return narrationFileNameGeorgian ?? narrationFileNameEnglish ?? narrationFileName
        }
    }

    static let pages = [
        OnboardingPage(
            id: "welcome",
            title: "Welcome to Wild Sakartvelo",
            localizedTitle: LocalizedContentText(
                english: "Welcome to Wild Sakartvelo",
                georgian: "კეთილი იყოს შენი მობრძანება ველურ საქართველოში"
            ),
            description: "Meet the mountains, forests, wetlands and coast through short nature adventures.",
            localizedDescription: LocalizedContentText(
                english: "Meet the mountains, forests, wetlands and coast through short nature adventures.",
                georgian: "გაიცანი მთები, ტყეები, ჭარბტენიანი ტერიტორიები და სანაპიროები მოკლე ბუნების თავგადასავლებით."
            ),
            systemImage: "leaf.fill",
            imageName: "onboarding_welcome",
            narrationFileName: "welcome_narration",
            narrationFileNameEnglish: "welcome_narration_en",
            narrationFileNameGeorgian: "welcome_narration_ka"
        ),
        OnboardingPage(
            id: "ecosystems",
            title: "Explore ecosystems",
            localizedTitle: LocalizedContentText(
                english: "Explore ecosystems",
                georgian: "გამოიკვლიე ეკოსისტემები"
            ),
            description: "Choose a place and discover the animals and plants that live there.",
            localizedDescription: LocalizedContentText(
                english: "Choose a place and discover the animals and plants that live there.",
                georgian: "აირჩიე ადგილი და აღმოაჩინე იქ მცხოვრები ცხოველები და მცენარეები."
            ),
            systemImage: "map.fill",
            imageName: "onboarding_map",
            narrationFileName: nil,
            narrationFileNameEnglish: nil,
            narrationFileNameGeorgian: nil
        ),
        OnboardingPage(
            id: "missions",
            title: "Complete missions and collect discoveries",
            localizedTitle: LocalizedContentText(
                english: "Complete missions and collect discoveries",
                georgian: "დაასრულე მისიები და შეაგროვე აღმოჩენები"
            ),
            description: "Answer simple questions, finish missions and add discoveries to your journal.",
            localizedDescription: LocalizedContentText(
                english: "Answer simple questions, finish missions and add discoveries to your journal.",
                georgian: "უპასუხე მარტივ შეკითხვებს, დაასრულე მისიები და დაამატე აღმოჩენები შენს დღიურში."
            ),
            systemImage: "checkmark.seal.fill",
            imageName: "onboarding_journal",
            narrationFileName: nil,
            narrationFileNameEnglish: nil,
            narrationFileNameGeorgian: nil
        ),
        OnboardingPage(
            id: "safety",
            title: "Observe nature safely",
            localizedTitle: LocalizedContentText(
                english: "Observe nature safely",
                georgian: "დააკვირდი ბუნებას უსაფრთხოდ"
            ),
            description: "Do not approach wild animals or touch unknown plants. Complete outdoor activities with adult permission. This app does not require location tracking.",
            localizedDescription: LocalizedContentText(
                english: "Do not approach wild animals or touch unknown plants. Complete outdoor activities with adult permission. This app does not require location tracking.",
                georgian: "არ მიუახლოვდე ველურ ცხოველებს და არ შეეხო უცნობ მცენარეებს. გარე აქტივობები შეასრულე ზრდასრულის ნებართვით. ამ აპს არ სჭირდება მდებარეობის თვალყურის დევნება."
            ),
            systemImage: "shield.lefthalf.filled",
            imageName: "onboarding_safety",
            narrationFileName: nil,
            narrationFileNameEnglish: nil,
            narrationFileNameGeorgian: nil
        )
    ]

    static let sample = pages[0]
}
