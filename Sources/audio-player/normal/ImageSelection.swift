import Foundation
import AVKit

open class ImageSelection: ObservableObject {
  @Published public var image: UIImage?

  public init(image: UIImage? = nil) {
    self.image = image
  }
}
