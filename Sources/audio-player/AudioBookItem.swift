import Foundation

public class AudioBookItem: Codable, Equatable, Hashable, Identifiable {
  public var name: String
  public var url: URL?

  public var id: String {
    name
  }

  public init(name: String, url: URL? = nil) {
    self.name = name
    self.url = url
  }
  
  private enum CodingKeys: String, CodingKey {
    case name
    case url
  }

  public required convenience init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    let name = try container.decode(String.self, forKey: .name)
    let url = try container.decodeIfPresent(URL.self, forKey: .url)

    self.init(name: name, url: url)
  }

  open func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)

    try container.encode(name, forKey: .name)
    try container.encode(url, forKey: .url)
  }

  public static func ==(lhs: AudioBookItem, rhs: AudioBookItem) -> Bool {
    lhs.id == rhs.id
  }

  public func hash(into hasher: inout Hasher) {
    hasher.combine(name)
    hasher.combine(url)
  }
}
