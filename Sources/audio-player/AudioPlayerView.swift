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
  var book: MediaItem
  var playImmediately: Bool
  @Binding var startTime: Double

  public init(player: MediaPlayer, navigator: AudioPlayerNavigator, book: MediaItem, playImmediately: Bool,
              startTime: Binding<Double>) {
    self.player = player
    self.navigator = navigator
    self.book = book
    self.playImmediately = playImmediately
    self._startTime = startTime
  }

  public var body: some View {
    GeometryReader { proxy in
      VStack {
        playerBody()
      }
        //.background(Color.gray)
        .navigationTitle(book.name)
        .modifier(AudioPlayerListener(player: player, navigator: navigator, size: proxy.size))
    }
  }

  @ViewBuilder
  func playerBody() -> some View {
    VStack {
      if let imageName = book.imageName, let url = URL(string: imageName) {
        DetailsImage(url: url)
          .padding(5)
      }

      Text(navigator.selection.bookItem.name)
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
//          .onAppear {
//            if let mediaSource = mediaSource {
//              player.update(mediaSource: mediaSource, startTime: startTime)
//            }
//          }
        .modifier(commandCenterHandler)
        .padding(5)
        .frame(height: 50)

      Spacer()
    }
    //.frame(width: width, height: height, alignment: .center)
  }
}

struct AudioPlayerView_Previews: PreviewProvider {
  static var previews: some View {
    AudioPlayerView(
        player: MediaPlayer(),
        navigator: AudioPlayerNavigator(),
        book: MediaItem(name: "name"),
        playImmediately: false,
        startTime: Binding.constant(.zero)
    )
  }
}
