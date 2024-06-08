import SwiftUI
import media_player
import common_defs
import item_navigator

public struct AudioPlayerView: View {
  private var audioPlayerHelper: MediaPlayerHelper {
    MediaPlayerHelper(player: player)
  }

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
    VStack {
      if let imageName = mediaItem.imageName, let url = URL(string: imageName) {
        DetailsImage(url: url)
          .padding(5)
      }

      Text(navigator.selection.currentItem?.name ?? "")
        .fixedSize()

      VStack {
        VolumeSlider(player: player)

        HStack {
          Text("\(audioPlayerHelper.formatTime(audioPlayerHelper.currentTime))")

          Spacer()

          Text("\(audioPlayerHelper.formatTime(audioPlayerHelper.leftTime))")
        }
      }
        .padding(5)
        .frame(height: 30)

      Spacer()

      VolumeControlsView()
        .padding(5)
        .frame(height: 50)

      Spacer()

      Group {
        PrimaryControlsView(player: player, navigator: navigator)
        SecondaryControlsView(player: player)
      }
        .commandCenter(player: player, navigator: navigator, stopOnLeave: false, playImmediately: playImmediately)
        .padding(5)
        .frame(height: 50)

      Spacer()
    }
      .navigationTitle(mediaItem.name)
      .onReceive(NotificationCenter.default.publisher(for: AVAudioSession.interruptionNotification)) { notification in
        audioPlayerHelper.handleAVAudioSessionInterruption(notification)
      }
    .onReceive(NotificationCenter.default.publisher(for: .AVPlayerItemPlaybackStalled)) { _ in
      player.pause()
      player.play()
    }
  }
}
