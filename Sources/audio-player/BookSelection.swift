import SwiftUI
import common_defs

open class BookSelection: ObservableObject {
  @Published public var book = MediaItem(name: "")
  @Published public var items: [AudioBookItem] = []
  @Published public var bookItem = AudioBookItem(name: "")

  open func select(_ newBookItem: AudioBookItem) {
    bookItem = newBookItem
  }
}
