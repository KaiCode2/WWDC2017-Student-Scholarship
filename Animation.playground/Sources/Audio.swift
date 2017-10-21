import AVFoundation

public struct Audio {
    public enum Sounds: String {
        case typing = "Keyboard_typing"
        case touch_down = "Touch_Down"
        case touch_up = "Touch_Up"
    }

    private let sound: Sounds
    private let player: AVAudioPlayer


    public init(sound: Sounds) {
        self.sound = sound

        player = try! AVAudioPlayer(contentsOf: Bundle.main.url(forResource: sound.rawValue,
                                                                withExtension: "m4a")!)
        player.prepareToPlay()
    }

    public func play(count: Int = 1, delay: TimeInterval = 0.1) {
        (1...count).delayedMap(block: { _ -> TimeInterval in
            self.player.play()
            return delay
        })
    }
}

