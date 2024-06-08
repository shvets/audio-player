import SwiftUI

public struct ImageView: View {
  var image: UIImage
  var customizeImage: (Image) -> any View

  public init(image: UIImage, customizeImage: @escaping (Image) -> any View) {
    self.image = image
    self.customizeImage = customizeImage
  }

  public var body: some View {
    content()
  }

  #if !os(tvOS)
  @ViewBuilder
  func content() -> some View {
    AnyView(customizeImage(Image(uiImage: image)))
  }
  #endif

  #if os(tvOS)
  @ViewBuilder
  func content() -> some View {
    Rectangle()
      .aspectRatio(1, contentMode: .fill)
      .overlay {
        AnyView(customizeImage(Image(uiImage: image)))
      }
      .cornerRadius(5)
  }
  #endif
}
