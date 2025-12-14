import Foundation
import Alamofire

// MARK: - MultipartData

/// Represents data for multipart form uploads (matches main app)
enum MultipartData {
    case image(data: Data, name: String)
    case video(data: Data, name: String)
    case file(data: Data, name: String)

    var data: Data {
        switch self {
        case .image(let data, _): return data
        case .video(let data, _): return data
        case .file(let data, _): return data
        }
    }

    var name: String {
        switch self {
        case .image(_, let name): return name
        case .video(_, let name): return name
        case .file(_, _): return "files"
        }
    }

    var fileName: String {
        switch self {
        case .image(_, let name): return "\(name).jpg"
        case .video(_, let name): return "\(name).mp4"
        case .file(_, let name): return "\(name)"
        }
    }

    var mimeType: String {
        switch self {
        case .image: return "image/jpg"
        case .video: return "multipart/form-data"
        case .file: return "multipart/form-data"
        }
    }
}

// MARK: - EndPointProtocol

/// Protocol that all API endpoints must conform to.
/// Matches the main YorNest app's EndPointProtocol pattern.
protocol EndPointProtocol {
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var requestParameters: Parameters { get }
    var headers: [String: String] { get }
    var encoding: ParameterEncoding { get }
    var multipartData: [MultipartData] { get }
}

extension EndPointProtocol {
    /// Default empty parameters
    var requestParameters: Parameters { [:] }

    /// Default empty headers
    var headers: [String: String] { [:] }

    /// Default empty multipart data
    var multipartData: [MultipartData] { [] }

    /// Default JSON encoding for POST requests
    var encoding: ParameterEncoding {
        switch httpMethod {
        case .get:
            return URLEncoding.default
        default:
            return JSONEncoding.default
        }
    }

    /// Helper to convert a Codable model to a dictionary for use as parameters
    func asJSONDictionary<T: Codable>(_ model: T, snakeCase: Bool = false) -> [String: Any] {
        let jsonEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = .sortedKeys
        jsonEncoder.keyEncodingStrategy = snakeCase ? .convertToSnakeCase : .useDefaultKeys

        guard let data = try? jsonEncoder.encode(model),
              let dictionary = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            return [:]
        }
        return dictionary
    }
}

