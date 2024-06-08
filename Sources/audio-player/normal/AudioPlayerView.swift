import SwiftUI
import media_player
import common_defs
import item_navigator

public struct AudioPlayerView: View {
  @ObservedObject var player: MediaPlayer
  var navigator: ItemNavigator<MediaItem>
  var mediaItem: MediaItem
  var playImmediately: Bool

  public init(player: MediaPlayer, navigator: ItemNavigator<MediaItem>, mediaItem: MediaItem, playImmediately: Bool) {
    self.player = player
    self.navigator = navigator
    self.mediaItem = mediaItem
    self.playImmediately = playImmediately
  }

  public var body: some View {
    AudioPlayerBody(player: player, navigator: navigator, mediaItem: mediaItem, playImmediately: playImmediately)
    .navigationTitle(mediaItem.name)
    .onReceive(NotificationCenter.default.publisher(for: .AVPlayerItemPlaybackStalled)) { _ in
      player.pause()
      player.play()
    }
  }
}
