import SwiftUI
import media_player

public class AudioPlayerNavigator: ObservableObject, PlayerNavigator {
  @Published public var items: [AudioBookItem] = []

  @Published public var selection = BookSelection()

  public init() {}

  @discardableResult public func next() -> Bool {
    let index = items.firstIndex(where: { $0.name == selection.info.track?.name}) ?? -1

    if index < items.count-1 {
      let nextItem = items[index+1]

      selection.info.track = nextItem

      return true
    }

    return false
  }

  @discardableResult public func previous() -> Bool {
    let index = items.firstIndex(where: { $0.name == selection.info.track?.name}) ?? -1

    if index > 0 {
      let previousItem = items[index-1]

      selection.info.track = previousItem

      return true
    }

    return false
  }
}
