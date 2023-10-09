import media_player
import common_defs

public class AudioStorage<T: AudioInfo>: UserDefaultsStorage<T> {
  var settingsCreator: () -> T = { AudioInfo() as! T }

  public var savedBook: MediaItem? {
    try? load()?.book
  }

  public var savedCurrentBookItem: AudioBookItem? {
    try? load()?.currentBookItem
  }

  public var savedTrackId: Int {
    (try? load()?.trackId) ?? 0
  }

  public var savedAudioPosition: Double {
    (try? load()?.audioPosition) ?? 0
  }

  public func audioPosition(book: MediaItem, trackId: Int, maxCount: Int) -> Double {
    if savedBook == nil { // new book
      return .zero
    }
    else if let savedBook = savedBook, savedBook.id != book.id { // new book
      return .zero
    }
    else { // same book as saved
      if trackId != savedTrackId { // different track
        return .zero
      }
      else { // same track
        if  trackId < maxCount {
          return savedAudioPosition
        }
        else {
          return .zero
        }
      }
    }
  }

  public func saveBook(_ book: MediaItem) {
    print("save book: \(book.name)")

    save { settings in
      settings.book = book
//      settings.trackId = 0
//      settings.audioPosition = 0
    }
  }

  public func saveAudioBookItem(_ item: AudioBookItem) {
    print("save audio book item: \(item)")

    save { settings in
      settings.currentBookItem = item
    }
  }

  public func saveTrackId(_ index: Int) {
    print("save track id: \(index)")

    save { settings in
      settings.trackId = index
    }
  }

  public func saveAudioPosition(_ audioPosition: Double) {
    print("save audio position: \(audioPosition)")

    save { settings in
      settings.audioPosition = audioPosition
    }
  }

  private func save(_ callback: (inout T) -> Void) {
    var settings: T

    do {
      settings = try load() ?? settingsCreator()
    }
    catch let error {
      print("Error: \(error)")

      settings = settingsCreator()
    }

    callback(&settings)

    do {
      try save(settings)
    }
    catch let error {
      print("Error: \(error)")
    }
  }
}
