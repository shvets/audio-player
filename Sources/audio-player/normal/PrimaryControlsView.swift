import AVKit
import SwiftUI
import media_player
import common_defs
import item_navigator

struct PrimaryControlsView: View {
  @ObservedObject var player: MediaPlayer
  var navigator: ItemNavigator<MediaItem>

  public var body: some View {
    HStack {
      Spacer()

      if navigator.selection.items.count > 1 {
        Button(action: {
          if let item = navigator.previous() {
            navigator.update(item: item, time: .zero)
          }
        }, label: {
          Image("Rewind Filled")
            .renderingMode(.template)
            .foregroundColor(.yellow)
            .imageScale(.large)
        })
      }

      Spacer()

      if player.isPlaying {
        Button(action: {
          player.pause()
        }, label: {
          Image(systemName: "pause")
            .foregroundColor(.green)
            .imageScale(.large)
        })
      } else {
        Button(action: {
          player.play()
        }, label: {
          Image(systemName: "play")
            .foregroundColor(.green)
            .imageScale(.large)
        })
      }

      Spacer()

      if navigator.selection.items.count > 1 {
        Button(action: {
          if let item = navigator.next() {
            navigator.update(item: item, time: .zero)
          }
        }, label: {
          Image("Fast Forward Filled")
            .renderingMode(.template)
            .foregroundColor(.yellow)
            .imageScale(.large)
        })
      }

      Spacer()
    }
  }
}
