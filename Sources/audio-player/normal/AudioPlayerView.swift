import SwiftUI
import AVKit
import media_player
import common_defs
import item_navigator
import plain_image_view

public struct AudioPlayerView: View {
  private var mediaPlayerHelper: MediaPlayerHelper {
    MediaPlayerHelper(player: player)
  }
  
  private var imageFetcher = ImageFetcher()

  @StateObject var imageSelection = ImageSelection()

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
      if let image = imageSelection.image {
        ImageView(image: image)
          #if os(tvOS)
          .frame(width: 500, height: 500)
          #endif
          .padding(5)
      }

      Text(navigator.selection.currentItem?.name ?? "")
        .fixedSize()

      VStack {
        VolumeSlider(player: player)

        HStack {
          Text("\(mediaPlayerHelper.formatTime(mediaPlayerHelper.currentTime))")

          Spacer()

          Text("\(mediaPlayerHelper.formatTime(mediaPlayerHelper.leftTime))")
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
      .task {
        if let imageName = mediaItem.imageName {
          Task {
            if let image = try await imageFetcher.fetch(imageName: imageName) {
              imageSelection.image = image
            }
            else {
              print("Cannot load image: \(imageName)")
            }
          }
        }
      }
      .navigationTitle(mediaItem.name)
      .onReceive(NotificationCenter.default.publisher(for: AVAudioSession.interruptionNotification)) { notification in
        mediaPlayerHelper.handleAVAudioSessionInterruption(notification)
      }
    .onReceive(NotificationCenter.default.publisher(for: .AVPlayerItemPlaybackStalled)) { _ in
      player.pause()
      player.play()
    }
  }
}
