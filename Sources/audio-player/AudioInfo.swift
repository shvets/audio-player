import Foundation
import common_defs

public class AudioInfo: Codable {
  var book: MediaItem?
  var currentBookItem: AudioBookItem?
  var trackId: Int?
  var audioPosition: Double?

//  private enum CodingKeys: String, CodingKey {
//    case book
//    case currentBookItem
//    case trackId
//    case audioPosition
//  }

  public init(book: MediaItem? = nil, currentBookItem: AudioBookItem? = nil, trackId: Int? = nil, audioPosition: Double? = nil) {
    self.book = book
    self.currentBookItem = currentBookItem
    self.trackId = trackId
    self.audioPosition = audioPosition
  }

//  init(from decoder: Decoder) throws {
//    let container = try decoder.container(keyedBy: CodingKeys.self)
//
//    let book = try container.decodeIfPresent(AudioBook.self, forKey: .book)
//    let currentBookItem = try container.decodeIfPresent(AudioBookItem.self, forKey: .currentBookItem)
//    let trackId = try container.decodeIfPresent(Int.self, forKey: .trackId)
//    let audioPosition = try container.decodeIfPresent(Double.self, forKey: .audioPosition)
//
//    self.init(book: book, currentBookItem: currentBookItem, trackId: trackId, audioPosition: audioPosition)
//  }

//  init(data: Data) throws {
//    let settings = try JSONDecoder().decode(AudioPlayerSettings.self, from: data)
//
//    book = settings.book
//    currentBookItem = settings.currentBookItem
//    trackId = settings.trackId
//    audioPosition = settings.audioPosition
//  }

//  public init(from decoder: Decoder) throws {
//    let book = try decoder.decode("book") as AudioBook
//    let currentBookItem = try decoder.decode("currentBookItem") as AudioBookItem
//    let trackId = try decoder.decode("trackId") as Int
//    let audioPosition = try decoder.decode("audioPosition") as Double
//
//    self.init(book: book, currentBookItem: currentBookItem, trackId: trackId, audioPosition: audioPosition)
//  }

//  func setTrackId(trackId: Int) {
//    self.trackId = trackId
//  }

  //public func encode(to encoder: Encoder) throws {
//    try encoder.encode(book, for: "book")
//    try encoder.encode(currentBookItem, for: "currentBookItem")
//    try encoder.encode(trackId, for: "trackId")
//    try encoder.encode(audioPosition, for: "audioPosition")
 // }
}
