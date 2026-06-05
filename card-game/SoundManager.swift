//
//  SoundManager.swift
//  card-game
//

import Foundation
import AVFoundation

class SoundManager {
    
    static let shared = SoundManager()
    
    var audioPlayer: AVAudioPlayer?
    
    private init() {}
    
    func playSound(soundName: String) {
        guard let url = Bundle.main.url(forResource: soundName, withExtension: "mp3") else {
            print("Could not find the sound file: \(soundName)")
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        } catch {
            print("Error playing sound: \(error.localizedDescription)")
        }
    }
}
