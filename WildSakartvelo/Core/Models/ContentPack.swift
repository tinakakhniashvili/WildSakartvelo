import Foundation

struct ContentPack: Identifiable, Codable, Hashable {
    let id: String
    let ecosystemID: String
    let title: String
    let version: Int
    let estimatedSizeBytes: Int
    let remoteBaseURL: String?
    let resourceFiles: [String]

    enum CodingKeys: String, CodingKey {
        case id
        case ecosystemID
        case title
        case version
        case estimatedSizeBytes
        case remoteBaseURL
        case resourceFiles
    }

    init(
        id: String,
        ecosystemID: String,
        title: String,
        version: Int,
        estimatedSizeBytes: Int,
        remoteBaseURL: String?,
        resourceFiles: [String]
    ) {
        self.id = id
        self.ecosystemID = ecosystemID
        self.title = title
        self.version = version
        self.estimatedSizeBytes = estimatedSizeBytes
        self.remoteBaseURL = remoteBaseURL
        self.resourceFiles = resourceFiles
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(String.self, forKey: .id)
        ecosystemID = try container.decode(String.self, forKey: .ecosystemID)
        title = try container.decode(String.self, forKey: .title)
        version = try container.decodeIfPresent(Int.self, forKey: .version) ?? 1
        estimatedSizeBytes = try container.decodeIfPresent(Int.self, forKey: .estimatedSizeBytes) ?? 0
        remoteBaseURL = try container.decodeIfPresent(String.self, forKey: .remoteBaseURL)
        resourceFiles = try container.decodeIfPresent([String].self, forKey: .resourceFiles) ?? []
    }

    static let sample = ContentPack(
        id: "caucasus-mountains-media",
        ecosystemID: "caucasus-mountains",
        title: "Caucasus Mountains Media",
        version: 1,
        estimatedSizeBytes: 1_200_000,
        remoteBaseURL: nil,
        resourceFiles: [
            "caucasian_tur_sound.m4a",
            "identify_animal_instruction.m4a"
        ]
    )
}
