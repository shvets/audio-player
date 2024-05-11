import SwiftUI
import media_player
import common_defs

public class AudioPlayerNavigator: ObservableObject, PlayerNavigator {
  @Published public var items: [AudioBookItem] = []

  @Published public var selection = BookSelection()

  var trackConverter: (String, AudioBookItem) -> AudioBookItem

  public init(trackConverter: @escaping (String, AudioBookItem) -> AudioBookItem = { _, item in item }) {
    self.trackConverter = trackConverter
  }

  @discardableResult public func next() -> Bool {
    let index = items.firstIndex(where: { $0.name == selection.info.track?.name}) ?? -1

    if index < items.count-1 {
      let nextItem = items[index+1]

      if let bookId = selection.info.book?.id {
        selection.info.track = trackConverter(bookId, nextItem)
      }
      else {
        selection.info.track = nextItem
      }

      return true
    }

    return false
  }

  @discardableResult public func previous() -> Bool {
    let index = items.firstIndex(where: { $0.name == selection.info.track?.name}) ?? -1

    if index > 0 {
      let previousItem = items[index-1]

      if let bookId = selection.info.book?.id {
        selection.info.track = trackConverter(bookId, previousItem)
      }
      else {
        selection.info.track = previousItem
      }

      return true
    }

    return false
  }
}
