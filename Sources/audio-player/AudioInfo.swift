import Foundation
import common_defs

public class AudioInfo: Codable {
  public var book: MediaItem?
  public var track: AudioBookItem?
//  public var trackId: Int?
//  public var audioPosition: Double?

  private enum CodingKeys: String, CodingKey {
    case book
    case track
//    case trackId
//    case audioPosition
  }

  public init(book: MediaItem? = nil, track: AudioBookItem? = nil) {
//, trackId: Int? = nil, audioPosition: Double? = nil) {
    self.book = book
    self.track = track
//    self.trackId = trackId
//    self.audioPosition = audioPosition
  }

  public required convenience init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    let book = try container.decodeIfPresent(MediaItem.self, forKey: .book)
    let track = try container.decodeIfPresent(AudioBookItem.self, forKey: .track)

    self.init(book: book, track: track)
  }

  open func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)

    try container.encode(book, forKey: .book)
    try container.encode(track, forKey: .track)
  }

  public static func ==(lhs: AudioInfo, rhs: AudioInfo) -> Bool {
    lhs.book?.name == rhs.book?.name
  }

  public func hash(into hasher: inout Hasher) {
    hasher.combine(book)
    hasher.combine(track)
  }

//  convenience init(from decoder: Decoder) throws {
//    let container = try decoder.container(keyedBy: CodingKeys.self)
//
//    let book = try container.decodeIfPresent(MediaItem.self, forKey: .book)
//    let track = try container.decodeIfPresent(AudioBookItem.self, forKey: .track)
////    let trackId = try container.decodeIfPresent(Int.self, forKey: .trackId)
////    let audioPosition = try container.decodeIfPresent(Double.self, forKey: .audioPosition)
//
//    self.init(book: book, track: track)
//    //, trackId: trackId, audioPosition: audioPosition)
//  }

//  init(data: Data) throws {
//    let settings = try JSONDecoder().decode(AudioPlayerSettings.self, from: data)
//
//    book = settings.book
//    currentBookItem = settings.currentBookItem
////    trackId = settings.trackId
////    audioPosition = settings.audioPosition
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

//  public func encode(to encoder: Encoder) throws {
//    try encoder.encode(book, for: "book")
//    try encoder.encode(currentBookItem, for: "currentBookItem")
//    try encoder.encode(trackId, for: "trackId")
//    try encoder.encode(audioPosition, for: "audioPosition")
//   }
}
