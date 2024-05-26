import SwiftUI
import UIKit
import MediaPlayer

struct VolumeView: UIViewRepresentable {
  func makeUIView(context: Context) -> UIView {
    MPVolumeView()
  }

  func updateUIView(_ uiView: UIView, context: Context) {
    setupVolumeSlider()
  }

  func setupVolumeSlider() {
#if os(iOS)
    if let volumeSlider = MPVolumeView().subviews.first(where: {$0 is UISlider}) {
      UIView().addSubview(volumeSlider)
    }
#endif
  }
}