import SwiftUI

class ImageHelper {
  var customizeImage: (Image) -> any View = { image in
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
  
  func fetchImage(imageName: String) async throws -> UIImage? {
    if let url = URL(string: imageName) {
      let urlRequest = URLRequest(url: url)

      //Task {
        let (data, _) = try await URLSession.shared.data(for: urlRequest, delegate: nil)

        //DispatchQueue.main.async { [self] in
          let image = UIImage(data: data)

        return image
//          if let image = image {
//            //imageSelection.image = image
//          }
//          else {
//            print("cannot load")
//          }
        }
      //}
    //}
    
    return nil
  }
}
