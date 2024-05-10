import SwiftUI
import AVFoundation
import media_player
import common_defs

public struct AudioPlayerView: View {
  private var audioPlayerViewHelper: AudioPlayerViewHelper {
    AudioPlayerViewHelper(player: player, navigator: navigator)
  }

  var commandCenterHandler: CommandCenterHandler {
    CommandCenterHandler(
        player: player, stopOnLeave: false, playImmediately: playImmediately,
        commandCenterManager: CommandCenterManager(player: player, navigator: navigator)
    )
  }

  @ObservedObject var player: MediaPlayer
  @ObservedObject var navigator: AudioPlayerNavigator
  var mediaItem: MediaItem
  var playImmediately: Bool
  var startTime: Double

  public init(player: MediaPlayer, navigator: AudioPlayerNavigator, mediaItem: MediaItem, playImmediately: Bool,
              startTime: Double) {
    self.player = player
    self.navigator = navigator
    self.mediaItem = mediaItem
    self.playImmediately = playImmediately
    self.startTime = startTime
  }

  public var body: some View {
    GeometryReader { proxy in
      VStack {
        playerBody()
      }
        //.background(Color.gray)
        .navigationTitle(mediaItem.name)
        .modifier(AudioPlayerListener(player: player, navigator: navigator, size: proxy.size))
    }
  }

  @ViewBuilder
  func playerBody() -> some View {
    VStack {
      if let imageName = mediaItem.imageName, let url = URL(string: imageName) {
        DetailsImage(url: url)
          .padding(5)
      }

      Text(navigator.selection.info.track?.name ?? "")
        .fixedSize()
      //.frame(width: width, alignment: .center)

      VStack {
        BookNavigationSlider(player: player)

        HStack {
          Text("\(audioPlayerViewHelper.formatTime(audioPlayerViewHelper.currentTime))")

          Spacer()

          Text("\(audioPlayerViewHelper.formatTime(audioPlayerViewHelper.leftTime))")
        }
      }
        .padding(5)
        .frame(height: 30)

      Spacer()

      audioPlayerViewHelper.volumeControls()
        .padding(5)
        .frame(height: 50)

      Spacer()

      Group {
        audioPlayerViewHelper.navigationControlsPrimary()
        audioPlayerViewHelper.navigationControlsSecondary()
      }
          .onAppear {
            if player.url?.absoluteString != navigator.selection.info.track?.url?.absoluteString {
              if let url = navigator.selection.info.track?.url {
                player.update(url: url, startTime: .zero)
              }
            }
          }
        .modifier(commandCenterHandler)
        .padding(5)
        .frame(height: 50)

      Spacer()
    }
    //.frame(width: width, height: height, alignment: .center)
  }
}

//struct AudioPlayerView_Previews: PreviewProvider {
//  static var previews: some View {
//    AudioPlayerView(
//        player: MediaPlayer(),
//        navigator: AudioPlayerNavigator(selection: BookSelection()),
//        mediaItem: MediaItem(name: "name"),
//        playImmediately: false,
//        startTime: .zero
//    )
//  }
//}
