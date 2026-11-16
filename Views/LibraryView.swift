import SwiftUI

struct LibraryView: View {
    @ObservedObject private var player = PlayerManager.shared

    var body: some View {
        NavigationStack {
            List {
                Section("Сейчас играет") {
                    if let t = player.currentTrack {
                        TrackRow(track: t)
                    } else {
                        Text("Ничего не воспроизводится").foregroundStyle(.secondary)
                    }
                }
                Section("О приложении") {
                    Text("Dotify Clone — агрегатор Deezer + Apple Music превью.")
                }
            }
            .navigationTitle("Медиатека")
        }
    }
}