import SwiftUI

public class ImageHelper {
  public init() {}

  public var customizeImage: (Image) -> any View = { image in
    #if os(tvOS)
    return image.resizable()
      .scaledToFill()
    #endif

    #if !os(tvOS)
    return image.resizable()
      .aspectRatio(contentMode: .fit)
      .scaledToFit()
      .cornerRadius(5)
    #endif
  }

  public func fetchImage(imageName: String) async throws -> UIImage? {
    if let url = URL(string: imageName) {
      let urlRequest = URLRequest(url: url)

      let (data, _) = try await URLSession.shared.data(for: urlRequest, delegate: nil)

       return UIImage(data: data)
    }

    return nil
  }
}
