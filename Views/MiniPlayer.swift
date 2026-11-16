import SwiftUI

struct MiniPlayer: View {
    let track: Track
    @ObservedObject private var player = PlayerManager.shared

    var body: some View {
        VStack(spacing: 0) {
            ProgressView(value: player.progress, total: max(player.duration, 0.01))
                .tint(.green)
            HStack(spacing: 12) {
                AsyncImage(url: track.artworkURL) { $0.resizable() } placeholder: { Color.gray }
                    .frame(width: 44, height: 44).cornerRadius(6)
                VStack(alignment: .leading, spacing: 2) {
                    Text(track.title).font(.subheadline).lineLimit(1)
                    Text(track.artist).font(.caption2).foregroundStyle(.secondary).lineLimit(1)
                }
                Spacer()
                Button { player.toggle() } label: {
                    Image(systemName: player.isPlaying ? "pause.fill" : "play.fill")
                        .font(.title3)
                }
            }
            .padding(.horizontal, 12).padding(.vertical, 8)
        }
        .background(.ultraThinMaterial)
    }
}