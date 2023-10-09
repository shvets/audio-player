import AVFoundation
import SwiftUI
import media_player

open class AudioPlayerViewHelper {
  @ObservedObject var player: MediaPlayer
  @ObservedObject var navigator: AudioPlayerNavigator

  public init(@ObservedObject player: MediaPlayer, @ObservedObject navigator: AudioPlayerNavigator) {
    self.player = player
    self.navigator = navigator
  }

  public var currentTime: Double {
    player.currentTime
  }

  public var leftTime: Double {
    if let duration = player.currentItemDuration {
      return duration - currentTime
    }
    else {
      return 0
    }
  }

//  var duration: Double {
//    player.duration ?? 0
//  }

  @ViewBuilder
  public func navigationControlsPrimary() -> some View {
    HStack {
      Spacer()

      if navigator.items.count > 1 {
        Button(action: {
          self.previousTrack()
        }, label: {
          Image("Rewind Filled")
            .renderingMode(.template)
            .foregroundColor(.yellow)
            .imageScale(.large)
        })
      }

      Spacer()

      if player.isPlaying {
        Button(action: {
          self.player.pause()
        }, label: {
          Image(systemName: "pause")
            .foregroundColor(.green)
            .imageScale(.large)
        })
      } else {
        Button(action: {
          self.player.play()
        }, label: {
          Image(systemName: "play")
            .foregroundColor(.green)
            .imageScale(.large)
        })
      }

      Spacer()

      if navigator.items.count > 1 {
        Button(action: {
          self.nextTrack()
        }, label: {
          Image("Fast Forward Filled")
            .renderingMode(.template)
            .foregroundColor(.yellow)
            .imageScale(.large)
        })
      }

      Spacer()
    }
  }

  @ViewBuilder
  public func navigationControlsSecondary() -> some View {
    HStack {
      Spacer()

      Button(action: {
        self.player.replay()
      }, label: {
        Image("Skip to Start Filled")
          .renderingMode(.template)
          .foregroundColor(.blue)
          .imageScale(.large)
      })

      Spacer()

      Button(action: {
        self.player.skipSeconds(-20)
      }, label: {
        Image("Rewind")
          .renderingMode(.template)
          .foregroundColor(.blue)
          .imageScale(.large)
      })

      Spacer()

      Button(action: {
        self.player.skipSeconds(20)
      }, label: {
        Image("Fast Forward")
          .renderingMode(.template)
          .foregroundColor(.blue)
          .imageScale(.large)
      })

      Spacer()

      Button(action: {
        self.player.toEnd()
      }, label: {
        Image(systemName: "stop")
          .imageScale(.large)
      })

      Spacer()
    }
  }


  @ViewBuilder
  func volumeControls() -> some View {
    HStack {
//      Button(action: {
//        player.decrementVolume()
//      }, label: {
//        Image("Low Volume Filled")
//          .imageScale(.large)
//      })

      Image("Low Volume Filled")
        .renderingMode(.template)
        .foregroundColor(.blue)
        .imageScale(.large)

      Spacer()

      //VolumeNavigationSlider(player: player, value: $player.player.volume)

      #if !targetEnvironment(simulator)
//        Text("\(player.player.volume, specifier: "%.0f")")
//      #else
      VolumeView()
//          .alignmentGuide(HorizontalAlignment.center) { context in
//            context.width / 4
//          }
      #endif

//      Button(action: {
//        player.incrementVolume()
//      }, label: {
//        Image("High Volume Filled")
//          .imageScale(.large)
//      })

      Spacer()

      Image("High Volume Filled")
        .renderingMode(.template)
        .foregroundColor(.blue)
        .imageScale(.large)

    }
  }

  public func handleAVAudioSessionInterruption(_ notification : Notification) {
    guard let userInfo = notification.userInfo as? [String: AnyObject] else { return }

    guard let rawInterruptionType = userInfo[AVAudioSessionInterruptionTypeKey] as? NSNumber else { return }
    guard let interruptionType = AVAudioSession.InterruptionType(rawValue: rawInterruptionType.uintValue) else { return }

    switch interruptionType {
    case .began: //interruption started
      player.pause()

    case .ended: //interruption ended
      if let rawInterruptionOption = userInfo[AVAudioSessionInterruptionOptionKey] as? NSNumber {
        let interruptionOption = AVAudioSession.InterruptionOptions(rawValue: rawInterruptionOption.uintValue)
        if interruptionOption == AVAudioSession.InterruptionOptions.shouldResume {
          player.toggle()
        }
      }
    @unknown default:
      fatalError()
    }
  }

  public func nextTrack() {
    if navigator.next(), let url = navigator.selection.bookItem.url {
      player.reload(mediaSource: MediaSource(url: url, name: navigator.selection.bookItem.name))
    }
  }

  public func previousTrack() {
    if navigator.previous(), let url = navigator.selection.bookItem.url {
      player.reload(mediaSource: MediaSource(url: url, name: navigator.selection.bookItem.name))
    }
  }

  public func formatTime(_ time: Double) -> String {
    let (hours, minutes, seconds) = timeToHoursMinutesSeconds(time: Int(time))

    if hours > 0 {
      return String(format: "%i:%02i:%02i", hours, minutes, seconds)
    }
    else {
      return String(format: "%02i:%02i", minutes, seconds)
    }
  }

  func timeToHoursMinutesSeconds (time: Int) -> (Int, Int, Int) {
    (time / 3600, (time % 3600) / 60, (time % 3600) % 60)
  }
}