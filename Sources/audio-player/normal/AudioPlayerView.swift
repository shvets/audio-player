import SwiftUI
import media_player
import common_defs
import item_navigator

public struct AudioPlayerView: View {
  @ObservedObject var player: MediaPlayer
  var navigator: ItemNavigator<MediaItem>
  var mediaItem: MediaItem
  var playImmediately: Bool
  var currentTime: Double

  public init(player: MediaPlayer, navigator: ItemNavigator<MediaItem>, mediaItem: MediaItem, playImmediately: Bool,
              currentTime: Double) {
    self.player = player
    self.navigator = navigator
    self.mediaItem = mediaItem
    self.playImmediately = playImmediately
    self.currentTime = currentTime
  }

  public var body: some View {
    GeometryReader { proxy in
      VStack {
        AudioPlayerBody(player: player, navigator: navigator, mediaItem: mediaItem, playImmediately: playImmediately)
      }
        .frame(width: proxy.size.width, height: proxy.size.height, alignment: .center)
        //.background(Color.gray)
        .navigationTitle(mediaItem.name)
        .onReceive(NotificationCenter.default.publisher(for: .AVPlayerItemPlaybackStalled)) { _ in
          player.pause()
          player.play()
        }
    }
  }
}

//struct AudioPlayerView_Previews: PreviewProvider {
//  static var previews: some View {
//    AudioPlayerView(
//        player: MediaPlayer(),
//        mediaItem: MediaItem(name: "name"),
//        playImmediately: false,
//        startTime: .zero
//    )
//  }
//}
