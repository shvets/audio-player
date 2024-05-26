import AVKit
import SwiftUI
import media_player
import common_defs

struct SecondaryControlsView: View {
  @ObservedObject var player: MediaPlayer

  public init(@ObservedObject player: MediaPlayer) {
    self.player = player
  }

  public var body: some View {
    HStack {
      Spacer()

      Button(action: {
        player.replay()
      }, label: {
        Image("Skip to Start Filled")
          .renderingMode(.template)
          .foregroundColor(.blue)
          .imageScale(.large)
      })

      Spacer()

      Button(action: {
        player.skipSeconds(-20)
      }, label: {
        Image("Rewind")
          .renderingMode(.template)
          .foregroundColor(.blue)
          .imageScale(.large)
      })

      Spacer()

      Button(action: {
        player.skipSeconds(20)
      }, label: {
        Image("Fast Forward")
          .renderingMode(.template)
          .foregroundColor(.blue)
          .imageScale(.large)
      })

      Spacer()

      Button(action: {
        player.toEnd()
      }, label: {
        Image(systemName: "stop")
          .imageScale(.large)
      })

      Spacer()
    }
  }
}

//extension View {
//  public func secondaryControls(@ObservedObject player: MediaPlayer) -> some View {
//    self.modifier(SecondaryControlsModifier(player: player))
//  }
//}

