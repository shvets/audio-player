import AVKit
import SwiftUI
import media_player

struct VolumeNavigationSlider: View {
  @ObservedObject var player: MediaPlayer

  @Binding var value: Float
  @State private var sliderValue: Float = 0.0

  var body: some View {
#if os(iOS)
    Slider(value: $sliderValue, in: 0...value)
      .onAppear {
        sliderValue = player.player.volume
      }
      .onChange(of: sliderValue, perform: sliderChanged)
#else
    Text("Not implemented")
#endif
  }

  private func sliderChanged(to newValue: Float) {
    sliderValue = newValue.rounded()

    let roundedValue = Float(sliderValue)

    if roundedValue == value {
      return
    }

    value = roundedValue
  }
}
