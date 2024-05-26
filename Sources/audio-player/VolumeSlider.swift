import SwiftUI
import media_player

//struct NavigationSlider: View {
//  @State private var value : Double = 0
//
//  init<V>(value: Binding<V>, in bounds: ClosedRange<V>, onEditingChanged: @escaping (Bool) -> Void) {
//  //= 0...1, @ViewBuilder label: () -> Label, @ViewBuilder minimumValueLabel: () -> ValueLabel, @ViewBuilder maximumValueLabel: () -> ValueLabel, onEditingChanged: @escaping (Bool) -> Void = { _ in }) {
//    let thumbImage = UIImage(named: "sliderThumb")
//    UISlider.appearance().setThumbImage(thumbImage, for: .normal)
//  }
//
//  var body: some View {
//    Slider(value: $value)
//  }
//}

struct VolumeSlider: View {
  @ObservedObject var player: MediaPlayer

  var body: some View {
    if let duration = player.currentItemDuration {
      #if os(iOS)
      Slider(value: $player.currentTime, in: 0...duration,
          onEditingChanged: { isEditing in
            player.isEditingCurrentTime = isEditing
          })
        .accentColor(Color.green)
//        .overlay(
//            RoundedRectangle(cornerRadius: 8.0)
//              .stroke(lineWidth: 1.0)
//              //.foregroundColor(Color.green)
//        )
      #else
      TvSlider(minimumValue: 1, maximumValue: 10) {
        print("in handler")
        //valueLabel.text = "\(slider.value)"
      }
      #endif
    }
    else {
      Spacer()
    }
  }
}
