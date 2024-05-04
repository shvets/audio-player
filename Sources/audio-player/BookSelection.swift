import SwiftUI
import common_defs

open class BookSelection: ObservableObject {
  @Published public var book = MediaItem(name: "")
  @Published public var items: [AudioBookItem] = []
  @Published public var bookItem = AudioBookItem(name: "")

  public init() {}

  open func select(bookItem: AudioBookItem) {
    self.bookItem = bookItem
  }
}
