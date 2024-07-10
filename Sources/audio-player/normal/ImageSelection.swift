import Foundation
import AVKit

class ImageSelection: ObservableObject {
  @Published public var image: UIImage?

  init(image: UIImage? = nil) {
    self.image = image
  }
}
