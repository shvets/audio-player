import Foundation

public struct AudioBookItem: Codable, Equatable, Hashable, Identifiable {
  public var name: String
  public var url: URL? = nil

  public var id: String {
    name
  }

  public init(name: String, url: URL? = nil) {
    self.name = name
    self.url = url
  }
}
