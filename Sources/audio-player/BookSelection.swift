import SwiftUI
import common_defs

open class BookSelection: ObservableObject {
  @Published public var info = AudioInfo(book: MediaItem(name: ""), track: AudioBookItem(name: ""))

  public init() {}
}
