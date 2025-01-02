//
// Created by Alexander Shvets on 9/3/22.
//

import SwiftUI

#if !os(macOS)

struct TvSlider: UIViewRepresentable {
  var minimumValue: Float
  var maximumValue: Float
  var stepValue: Float = 1

  var sliderValueChanges: () -> Void

  func makeCoordinator() -> Coordinator {
    Coordinator(handler: sliderValueChanges)
  }

  func makeUIView(context: Context) -> UIView {
    let slider = TvOSSlider()

    //slider.addTarget(self, action: #selector(sliderValueChanges), for: .valueChanged)

    slider.addTarget(context.coordinator, action: #selector(Coordinator.sliderValueChanges), for: .valueChanged)

    return slider
  }

  func updateUIView(_ uiView: UIViewType, context: Context) {
    if let slider = uiView as? TvOSSlider {
      slider.minimumValue = minimumValue
      slider.maximumValue = maximumValue
      slider.stepValue = stepValue
      slider.minimumTrackTintColor = .orange

      context.coordinator.handler = sliderValueChanges
    }
  }

  class Coordinator {
    var handler: () -> Void

    init(handler: @escaping () -> Void) {
      self.handler = handler
    }

    @objc func sliderValueChanges() {
      handler()
    }
  }
}

#endif