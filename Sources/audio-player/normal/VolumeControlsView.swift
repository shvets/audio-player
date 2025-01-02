import SwiftUI

#if !os(macOS)

public struct VolumeControlsView: View {
  public var body: some View {
    HStack {
//      Button(action: {
//        player.decrementVolume()
//      }, label: {
//        Image("Low Volume Filled")
//          .imageScale(.large)
//      })

      Image("Low Volume Filled")
        .renderingMode(.template)
        .foregroundColor(.blue)
        .imageScale(.large)

      Spacer()

      //VolumeNavigationSlider(player: player, value: $player.player.volume)

      #if !targetEnvironment(simulator)
//        Text("\(player.player.volume, specifier: "%.0f")")
//      #else
      VolumeView()
//          .alignmentGuide(HorizontalAlignment.center) { context in
//            context.width / 4
//          }
      #endif

//      Button(action: {
//        player.incrementVolume()
//      }, label: {
//        Image("High Volume Filled")
//          .imageScale(.large)
//      })

      Spacer()

      Image("High Volume Filled")
        .renderingMode(.template)
        .foregroundColor(.blue)
        .imageScale(.large)
    }
  }
}

#endif
