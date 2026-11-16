import SwiftUI

struct SearchView: View {
    @State private var query = ""
    @State private var results: [Track] = []
    @State private var isLoading = false

    var body: some View {
        NavigationStack {
            List(results) { TrackRow(track: $0) }
            .overlay { if isLoading { ProgressView() } }
            .searchable(text: $query, prompt: "Трек, исполнитель, альбом")
            .onSubmit(of: .search) { run() }
            .navigationTitle("Поиск")
        }
    }

    private func run() {
        isLoading = true
        Task {
            defer { isLoading = false }
            results = (try? await MusicAggregator.shared.search(query: query)) ?? []
        }
    }
}