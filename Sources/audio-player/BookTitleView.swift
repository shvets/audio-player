import SwiftUI

public struct BookTitleView: View {
  public var name: String
  public var imageName: String?

  public init(name: String, imageName: String? = nil) {
    self.name = name
    self.imageName = imageName
  }

  public var body: some View {
    HStack {
      if let imageName = imageName, let url = URL(string: imageName) {
        DetailsImage(url: url)
          .frame(width: 50, height: 50)
      }
      else {
        EmptyView()
      }

      Spacer()

      Text(name)
        .fixedSize()
        .font(.subheadline)
    }
      .padding(5)
  }
}