import SwiftUI

struct DetailsImage: View {
  private var url: URL

  public init(url: URL) {
    self.url = url
  }

  var body: some View {
    AsyncImage(url: url) { phase in
      switch phase {
      case .success(let image):
        image
          .resizable()
          .aspectRatio(contentMode: .fit)
          .clipShape(RoundedRectangle(cornerRadius: 15))
          //.padding()

      case .failure(let error):
        Text(error.localizedDescription)

      case .empty:
        waitView()

      @unknown default:
        EmptyView()
      }
    }
  }

  @ViewBuilder
  func placeholderImage() -> some View {
    Image(systemName: "photo")
      .renderingMode(.template)
      .resizable()
      .aspectRatio(contentMode: .fit)
      .frame(width: 150, height: 150)
      .foregroundColor(.gray)
  }

  @ViewBuilder
  func waitView() -> some View {
    VStack {
      ProgressView()
        .progressViewStyle(CircularProgressViewStyle(tint: .indigo))

      Text("Fetching image...")
    }
  }
}

//struct DetailsImage_Previews: PreviewProvider {
//  static var previews: some View {
//    DetailsImage(url: URL(string: "someimage")!)
//  }
//}
