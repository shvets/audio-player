import SwiftUI
import AVFoundation
import media_player
import common_defs

public struct CompactAudioPlayerView: View {
  private var audioPlayerViewHelper: AudioPlayerViewHelper {
    AudioPlayerViewHelper(player: player, navigator: navigator)
  }

  var commandCenterHandler: CommandCenterHandler {
    CommandCenterHandler(
        player: player, stopOnLeave: false, playImmediately: playImmediately,
        commandCenterManager: CommandCenterManager(player: player, navigator: navigator)
    )
  }

  @State var expanded: Bool = false

  @ObservedObject var player: MediaPlayer
  @Binding var navigationPath: NavigationPath
  @ObservedObject var navigator: AudioPlayerNavigator
  @ObservedObject var selection: BookSelection
  var playImmediately: Bool
  @Binding var startTime: Double
  var navigateTo: (() -> AnyView)?

  public init(@ObservedObject player: MediaPlayer, navigationPath: Binding<NavigationPath>,
              @ObservedObject navigator: AudioPlayerNavigator, selection: BookSelection,
              playImmediately: Bool, startTime: Binding<Double>, navigateTo: (() -> AnyView)? = nil) {
    self.player = player
    self._navigationPath = navigationPath
    self.navigator = navigator
    self.selection = selection
    self.playImmediately = playImmediately
    self._startTime = startTime
    self.navigateTo = navigateTo
  }

  public var body: some View {
    GeometryReader { proxy in
      VStack {
        Button {
          switchView(selection: selection)
        }
        label: {
          BookTitleView(name: title(selection.book.name), imageName: selection.book.imageName)
        }

        if expanded {
          ExpandedBookView(player: player, navigator: navigator, playImmediately: false, navigateTo: navigateTo)
        }
      }
          //.background(Color.gray)
        .navigationTitle(navigator.selection.book.name)
        .modifier(AudioPlayerListener(player: player, navigator: navigator, size: proxy.size))
    }
  }

  func title(_ name: String) -> String {
    let prefix = name.prefix(40)

    if prefix.count == name.count {
      return name
    }
    else {
      return "\(prefix)..."
    }
  }

  func switchView(selection: BookSelection) {
    navigator.selection = selection

    if let url = selection.bookItem.url {
      player.update(url: url, startTime: startTime)
    }

    expanded = !expanded
  }
}

//struct CompactAudioPlayerView_Previews: PreviewProvider {
//  static var previews: some View {
//    CompactAudioPlayerView(
//        player: MediaPlayer(),
//        navigationPath: Binding.constant(NavigationPath()),
//        navigator: AudioPlayerNavigator(selection: BookSelection()),
//        selection: BookSelection(),
//        playImmediately: false,
//        startTime: Binding.constant(.zero)
//    )
//  }
//}
