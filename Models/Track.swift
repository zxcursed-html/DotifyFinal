import Foundation

struct Track: Identifiable, Codable, Hashable {
    let id: UUID
    let title: String
    let artist: String
    let artworkURL: URL?
    let streamURL: URL
    let source: String
    let duration: Double
}