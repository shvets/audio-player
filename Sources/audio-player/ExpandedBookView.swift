import SwiftUI
import media_player

public struct ExpandedBookView: View {
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
  var playImmediately: Bool
  var navigateTo: (() -> AnyView)?

  public init(@ObservedObject player: MediaPlayer, @ObservedObject navigator: AudioPlayerNavigator,
              playImmediately: Bool, navigateTo: (() -> AnyView)? = nil) {
    self.player = player
    self.navigator = navigator
    self.playImmediately = playImmediately
    self.navigateTo = navigateTo
  }

  public var body: some View {
    Group {
      if navigator.selection.info.track?.url != nil {
        HStack {
          if let navigateTo = navigateTo {
            navigateTo()
          }

          audioPlayerViewHelper.navigationControlsPrimary()
          audioPlayerViewHelper.navigationControlsSecondary()
        }
          .modifier(commandCenterHandler)
          .padding(5)
        //.frame(height: height)
      }
//      else {
//        Text("Missing url")
//      }

      HStack {
        Text("\(audioPlayerViewHelper.formatTime(audioPlayerViewHelper.currentTime))")

        BookNavigationSlider(player: player)

        Text("\(audioPlayerViewHelper.formatTime(audioPlayerViewHelper.leftTime))")
      }
    }
  }
}

//struct ExpandedBookView_Previews: PreviewProvider {
//  static var previews: some View {
//    ExpandedBookView(player: MediaPlayer(), navigator: AudioPlayerNavigator(selection: BookSelection()), playImmediately: false)
//  }
//}
