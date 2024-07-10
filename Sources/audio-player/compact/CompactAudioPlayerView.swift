import SwiftUI
import AVFoundation
import media_player
import common_defs
import item_navigator
import plain_image_view

public struct CompactAudioPlayerView: View {
  private var mediaPlayerHelper: MediaPlayerHelper {
    MediaPlayerHelper(player: player)
  }
  
  private var imageFetcher = ImageFetcher()

  @ObservedObject var imageSelection = ImageSelection()

  @ObservedObject var player: MediaPlayer
  var navigator: ItemNavigator<MediaItem>
  var mediaItem: MediaItem
  @Binding var currentTime: Double
  @Binding var expanded: Bool
  var navigateAction: () -> any View
  var closeAction: () -> any View

  public init(player: MediaPlayer, navigator: ItemNavigator<MediaItem>, mediaItem: MediaItem,
              currentTime: Binding<Double>, expanded: Binding<Bool>,
              navigateAction: @escaping () -> any View, closeAction: @escaping () -> any View) {
    self.player = player
    self.navigator = navigator
    self.mediaItem = mediaItem
    self._expanded = expanded
    self._currentTime = currentTime
    self.navigateAction = navigateAction
    self.closeAction = closeAction

    Task { [self] in
      if let imageName = mediaItem.imageName {
        if let image = try await imageFetcher.fetch(imageName: imageName) {
          imageSelection.image = image
        }
        else {
          print("Cannot load image: \(imageName)")
        }
      }
    }
  }

  public var body: some View {
    VStack {
      if expanded {
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
            if let image = imageSelection.image {
              ImageView(image: image)
                .frame(width: 130, height: 130)
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
        if expanded {
          Image(systemName: "lightswitch.off")
        }
        else {
          Image(systemName: "lightswitch.on")
        }
      }
    }
  }

  func switchMode() {
    expanded = !expanded
  }
}
