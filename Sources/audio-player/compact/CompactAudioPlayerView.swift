import SwiftUI
import AVFoundation
import media_player
import common_defs
import item_navigator

public struct CompactAudioPlayerView: View {
  private var mediaPlayerHelper: MediaPlayerHelper {
    MediaPlayerHelper(player: player)
  }
  
  private var imageHelper = ImageHelper()

  @ObservedObject var imageSelection = ImageSelection()
  
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

    Task { [self] in
      if let imageName = mediaItem.imageName {
        if let image = try await imageHelper.fetchImage(imageName: imageName) {
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
          switchModeView()
          closeView()
          navigateTo()
          Spacer()
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
          navigateTo()

          Spacer()

          Text(mediaItem.name)
            .scaledToFit()
            .minimumScaleFactor(0.01)
        }
          .padding(5)

          HStack {
            if let image = imageSelection.image {
              ImageView(image: image, customizeImage: imageHelper.customizeImage)
                .frame(width: 130, height: 130)
            }

            Spacer()
          }
      }
    }
      .navigationTitle(mediaItem.name)
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
