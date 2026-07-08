struct TokoMessageService {
    enum Situation {
        case firstMission
        case incorrectAnswer
        case missionComplete
        case newAnimal
        case newEcosystem
        case emptyJournal
        case observationSafety
        case challengeComplete
    }

    func message(for situation: Situation, language: AppLanguage) -> String {
        switch (situation, language) {
        case (.firstMission, .english): return "Pick one place and start with a short mission."
        case (.firstMission, .georgian): return "აირჩიე ადგილი და დაიწყე მოკლე მისიით."
        case (.incorrectAnswer, .english): return "Try again. Look for the clue in the picture."
        case (.incorrectAnswer, .georgian): return "სცადე კიდევ. მინიშნება სურათში მოძებნე."
        case (.missionComplete, .english): return "Nice exploring. Your journal has something new."
        case (.missionComplete, .georgian): return "კარგი კვლევაა. დღიურში ახალი რამ დაემატა."
        case (.newAnimal, .english): return "A new animal card is ready to inspect."
        case (.newAnimal, .georgian): return "ახალი ცხოველის ბარათი მზადაა სანახავად."
        case (.newEcosystem, .english): return "A new ecosystem path opened."
        case (.newEcosystem, .georgian): return "ახალი ეკოსისტემის გზა გაიხსნა."
        case (.emptyJournal, .english): return "Complete a mission to add your first discovery."
        case (.emptyJournal, .georgian): return "პირველი აღმოჩენისთვის დაასრულე მისია."
        case (.observationSafety, .english): return "Observe from a safe place and ask an adult before going outside."
        case (.observationSafety, .georgian): return "დააკვირდი უსაფრთხო ადგილიდან და გარეთ გასვლამდე ჰკითხე ზრდასრულს."
        case (.challengeComplete, .english): return "Challenge complete. Check your reward."
        case (.challengeComplete, .georgian): return "გამოწვევა დასრულდა. ნახე ჯილდო."
        }
    }
}
