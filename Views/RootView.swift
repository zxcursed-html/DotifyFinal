import SwiftUI

struct RootView: View {
    var body: some View {
        TabView {
            HomeView().tabItem { Label("Главная", systemImage: "house.fill") }
            SearchView().tabItem { Label("Поиск", systemImage: "magnifyingglass") }
            LibraryView().tabItem { Label("Медиатека", systemImage: "music.note.list") }
        }
        .safeAreaInset(edge: .bottom) {
            if let track = PlayerManager.shared.currentTrack {
                MiniPlayer(track: track)
            }
        }
    }
}