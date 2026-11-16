import SwiftUI

struct TrackRow: View {
    let track: Track
    @ObservedObject private var player = PlayerManager.shared

    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: track.artworkURL) { img in
                img.resizable().scaledToFill()
            } placeholder: { Color.gray.opacity(0.3) }
            .frame(width: 52, height: 52)
            .cornerRadius(6)

            VStack(alignment: .leading, spacing: 2) {
                Text(track.title).font(.headline).lineLimit(1)
                Text("\(track.artist) · \(track.source)")
                    .font(.caption).foregroundStyle(.secondary)
            }
            Spacer()
            Button {
                if player.currentTrack == track { player.toggle() } else { player.play(track) }
            } label: {
                Image(systemName: (player.currentTrack == track && player.isPlaying) ? "pause.fill" : "play.fill")
                    .font(.title3)
            }
        }
        .contentShape(Rectangle())
        .onTapGesture { player.play(track) }
        .padding(.horizontal)
    }
}