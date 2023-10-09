import SwiftUI
import common_defs

open class BookSelection: ObservableObject {
  @Published public var book = MediaItem(name: "")
  @Published public var items: [AudioBookItem] = []
  @Published public var bookItem = AudioBookItem(name: "")

  var audioStorage: AudioStorage<AudioInfo>

  public init(audioStorage: AudioStorage<AudioInfo>) {
    self.audioStorage = audioStorage
  }

  open func select(_ newBookItem: AudioBookItem) {
    save(newBookItem)

    bookItem = newBookItem
  }

  private func save(_ newBookItem: AudioBookItem) {
    if bookItem.url != newBookItem.url {
      audioStorage.saveAudioBookItem(newBookItem)

      if let currentBookItemIndex = items.firstIndex(where: {$0.name == bookItem.name}) {
        audioStorage.saveTrackId(currentBookItemIndex)
      }
    }
  }
}