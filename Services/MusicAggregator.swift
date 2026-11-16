import Foundation

final class MusicAggregator {
    static let shared = MusicAggregator()

    func search(query: String) async throws -> [Track] {
        async let deezer = searchDeezer(query)
        async let itunes = searchiTunes(query)
        let all = try await deezer + itunes
        return all.sorted { $0.title.lowercased() < $1.title.lowercased() }
    }

    private func searchDeezer(_ query: String) async throws -> [Track] {
        let q = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query
        guard let url = URL(string: "https://api.deezer.com/search?q=\(q)&limit=25") else { return [] }
        let (data, _) = try await URLSession.shared.data(from: url)
        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] ?? [:]
        let items = json["data"] as? [[String: Any]] ?? []
        return items.compactMap { item in
            guard
                let title = item["title"] as? String,
                let artist = (item["artist"] as? [String: Any])?["name"] as? String,
                let preview = item["preview"] as? String,
                let streamURL = URL(string: preview)
            else { return nil }
            let artwork = (item["album"] as? [String: Any])?["cover_medium"] as? String
            let duration = (item["duration"] as? Double) ?? 30
            return Track(id: UUID(), title: title, artist: artist,
                         artworkURL: artwork.flatMap(URL.init),
                         streamURL: streamURL, source: "Deezer", duration: duration)
        }
    }

    private func searchiTunes(_ query: String) async throws -> [Track] {
        let q = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query
        guard let url = URL(string: "https://itunes.apple.com/search?term=\(q)&media=music&limit=25") else { return [] }
        let (data, _) = try await URLSession.shared.data(from: url)
        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] ?? [:]
        let items = json["results"] as? [[String: Any]] ?? []
        return items.compactMap { item in
            guard
                let title = item["trackName"] as? String,
                let artist = item["artistName"] as? String,
                let preview = item["previewUrl"] as? String,
                let streamURL = URL(string: preview)
            else { return nil }
            let artwork = item["artworkUrl100"] as? String
            let duration = ((item["trackTimeMillis"] as? Double) ?? 30000) / 1000
            return Track(id: UUID(), title: title, artist: artist,
                         artworkURL: artwork.flatMap(URL.init),
                         streamURL: streamURL, source: "Apple Music", duration: duration)
        }
    }
}