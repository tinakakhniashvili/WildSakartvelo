import Foundation

enum ContentError: Error, LocalizedError {
    case fileNotFound(String)
    case invalidData(String)
    case decodingFailed(String)
    case duplicateIdentifier(String)
    case missingReference(String)

    var errorDescription: String? {
        switch self {
        case .fileNotFound(let fileName):
            return "Content file could not be found: \(fileName).json"
        case .invalidData(let message):
            return "Content file could not be read: \(message)"
        case .decodingFailed(let message):
            return "Content file could not be decoded: \(message)"
        case .duplicateIdentifier(let identifier):
            return "Duplicate content identifier found: \(identifier)"
        case .missingReference(let reference):
            return "Missing content reference: \(reference)"
        }
    }
}
