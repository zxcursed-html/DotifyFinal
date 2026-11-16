import SwiftUI

struct HomeView: View {
    @State private var trending: [Track] = []
    @State private var isLoading = false
    private let seeds = ["The Weeknd", "Dua Lipa", "Travis Scott", "Billie Eilish", "Kanye West"]

    var body: some View {
        NavigationStack {
            ScrollView {
                if isLoading {
                    ProgressView().padding(.top, 100)
                } else {
                    LazyVStack(alignment: .leading, spacing: 16) {
                        Text("Тренды").font(.title2).bold().padding(.horizontal)
                        ForEach(trending) { TrackRow(track: $0) }
                    }
                    .padding(.vertical)
                }
            }
            .navigationTitle("Dotify")
            .task { await loadTrending() }
        }
    }

    private func loadTrending() async {
        isLoading = true
        defer { isLoading = false }
        var acc: [Track] = []
        for seed in seeds {
            if let r = try? await MusicAggregator.shared.search(query: seed) {
                acc.append(contentsOf: r.prefix(4))
            }
        }
        trending = acc.shuffled()
    }
}