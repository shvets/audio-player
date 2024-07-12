import SwiftUI
import AVFoundation
import media_player
import common_defs
import item_navigator
import plain_image_view
import swift_ui_commons

public struct CompactAudioPlayerView: View {
  private var mediaPlayerHelper: MediaPlayerHelper {
    MediaPlayerHelper(player: player)
  }

  @ObservedObject var player: MediaPlayer
  var navigator: ItemNavigator<MediaItem>
  var mediaItem: MediaItem
  @Binding var image: UIImage?
  @Binding var currentTime: Double
  @ObservedObject var expanded: SimpleSelection<Bool>
  var navigateAction: () -> any View
  var closeAction: () -> any View

  public init(player: MediaPlayer, navigator: ItemNavigator<MediaItem>, mediaItem: MediaItem,
              image: Binding<UIImage?>, currentTime: Binding<Double>, expanded: SimpleSelection<Bool>,
              navigateAction: @escaping () -> any View, closeAction: @escaping () -> any View) {
    self.player = player
    self.navigator = navigator
    self.mediaItem = mediaItem
    self._image = image
    self.expanded = expanded
    self._currentTime = currentTime
    self.navigateAction = navigateAction
    self.closeAction = closeAction
  }

  public var body: some View {
    VStack {
      if expanded.value {
        HStack {
          AnyView(switchModeView())
          AnyView(closeAction())
          AnyView(navigateAction())
          Spacer()

          Text(mediaItem.name)
            .scaledToFit()
            .minimumScaleFactor(0.01)
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
          AnyView(switchModeView())
          AnyView(closeAction())
          AnyView(navigateAction())

          Spacer()

          Text(mediaItem.name)
            .scaledToFit()
            .minimumScaleFactor(0.01)
        }
          .padding(5)

        HStack {
          ImageView(image: image)
            .frame(width: 150, height: 150)
            .onTapGesture {
              switchMode()
            }

          Spacer()
        }
      }
    }
      .navigationTitle(mediaItem.name)
  }

  var switchModeView: () -> any View {
    {
      Button {
        switchMode()
      } label: {
        if expanded.value {
          Image(systemName: "lightswitch.off")
        }
        else {
          Image(systemName: "lightswitch.on")
        }
      }
    }
  }

  func switchMode() {
    expanded.value = !expanded.value
  }
}
