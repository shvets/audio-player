import SwiftUI
import AVFoundation
import media_player

public struct AudioPlayerListener: ViewModifier {
  private var audioPlayerViewHelper: AudioPlayerViewHelper {
    AudioPlayerViewHelper(player: player, navigator: navigator)
  }

  @ObservedObject var player: MediaPlayer
  @ObservedObject var navigator: AudioPlayerNavigator
  var size: CGSize

  public init(@ObservedObject player: MediaPlayer, @ObservedObject navigator: AudioPlayerNavigator, size: CGSize) {
    self.player = player
    self.navigator = navigator
    self.size = size
  }

  public func body(content: Content) -> some View {
    content
      .frame(width: size.width, height: size.height, alignment: .center)
      //.aspectRatio(contentMode: .fit)
      .onReceive(NotificationCenter.default.publisher(for: .AVPlayerItemDidPlayToEndTime)) { _ in
        audioPlayerViewHelper.nextTrack()
      }
      .onReceive(NotificationCenter.default.publisher(for: .AVPlayerItemPlaybackStalled)) { _ in
        player.pause()
        player.play()
      }
      .onReceive(NotificationCenter.default.publisher(for: AVAudioSession.interruptionNotification)) { notification in
        audioPlayerViewHelper.handleAVAudioSessionInterruption(notification)
      }
  }
}