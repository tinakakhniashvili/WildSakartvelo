import Foundation

struct JSONLoader {
    static func load<T: Decodable>(_ fileName: String) throws -> T {
        guard let url = Bundle.main.url(
            forResource: fileName,
            withExtension: "json",
            subdirectory: "Content"
        ) ?? Bundle.main.url(forResource: fileName, withExtension: "json") else {
            throw ContentError.fileNotFound(fileName)
        }

        let data: Data
        do {
            data = try Data(contentsOf: url)
        } catch {
            throw ContentError.invalidData("\(fileName).json: \(error.localizedDescription)")
        }

        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw ContentError.decodingFailed("\(fileName).json: \(error.localizedDescription)")
        }
    }
}
