import SwiftUI
import AVFoundation
import media_player
import common_defs
import item_navigator

public struct CompactAudioPlayerView: View {
  private var mediaPlayerHelper: MediaPlayerHelper {
    MediaPlayerHelper(player: player)
  }

  @State var expanded: Bool = false

  var player: MediaPlayer
  var navigator: ItemNavigator<MediaItem>
  @ObservedObject var selection: Selection<MediaItem>
  var mediaItem: MediaItem
  @Binding var currentTime: Double
  var playImmediately: Bool
  var urlBuilder: (MediaItem) -> URL?
  var navigateTo: () -> AnyView
  var closeView: () -> AnyView

  public init(player: MediaPlayer, navigator: ItemNavigator<MediaItem>, selection: Selection<MediaItem>,
              mediaItem: MediaItem, currentTime: Binding<Double>, playImmediately: Bool,
              urlBuilder: @escaping (MediaItem) -> URL?,
              navigateTo: @escaping () -> AnyView, closeView: @escaping () -> AnyView) {
    self.player = player
    self.navigator = navigator
    self.selection = selection
    self.mediaItem = mediaItem
    self._currentTime = currentTime
    self.playImmediately = playImmediately
    self.urlBuilder = urlBuilder
    self.navigateTo = navigateTo
    self.closeView = closeView
  }

  public var body: some View {
    GeometryReader { proxy in
      VStack {
        if expanded {
          HStack {
            switchModeView()
            closeView()
            Spacer()
            navigateTo()
          }

          HStack {
            PrimaryControlsView(player: player, navigator: navigator)
            SecondaryControlsView(player: player)
          }
            .padding(5)

          HStack {
            Text("\(mediaPlayerHelper.formatTime(mediaPlayerHelper.currentTime))")

            VolumeSlider(player: player)

            Text("\(mediaPlayerHelper.formatTime(mediaPlayerHelper.leftTime))")
          }
        }
        else {
          HStack {
            switchModeView()
            closeView()

            if let imageName = mediaItem.imageName, let url = URL(string: imageName) {
              DetailsImage(url: url)
                .frame(width: 50, height: 50)
            }

            Spacer()

            Text(title(mediaItem.name))
              .fixedSize()
              .font(.subheadline)
          }
            .padding(5)
        }
      }
          //.background(Color.gray)
        .navigationTitle(mediaItem.name)
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

  var switchModeView: () -> AnyView {
    {
      AnyView(Button {
        switchMode()
      } label: {
        if expanded {
          Image(systemName: "lightswitch.off")
        }
        else {
          Image(systemName: "lightswitch.on")
        }
      })
    }
  }

  func switchMode() {
    if let mediaItem = selection.currentItem, let url = urlBuilder(mediaItem)  {
      if player.url?.absoluteString != url.absoluteString {
        player.update(url: url, startTime: currentTime)
      }
    }

    expanded = !expanded
  }
}
