import SwiftUI
import common_defs

open class BookSelection: ObservableObject {
  @Published public var info = AudioInfo(book: MediaItem(name: ""), track: AudioBookItem(name: ""))
  
//  @Published public var book = MediaItem(name: "")
//  @Published public var bookItem = AudioBookItem(name: "")

  //public var convertBookItem: ((MediaItem, AudioBookItem) -> AudioBookItem?)? = nil

  public init() {}

//  open func select(bookItem: AudioBookItem) {
//    var newItem: AudioBookItem
//
//    if let convertBookItem = convertBookItem, let converted = convertBookItem(book, bookItem) {
//      newItem = converted
//    }
//    else {
//      newItem = bookItem
//    }
//
//    self.bookItem = newItem
//  }
}
