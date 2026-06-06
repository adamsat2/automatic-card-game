//
//  SoundManager.swift
//  card-game
//

import Foundation
import AVFoundation
import UIKit

class SoundManager {
    
    static let shared = SoundManager()
    
    var sfxPlayer: AVAudioPlayer? // Sound effects
    var bgmPlayer: AVAudioPlayer? // Background music
    
    private init() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: .duckOthers)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to set audio session category.")
        }
        
        // Observers to pause/resume background music when leaving / returning to the app
        NotificationCenter.default.addObserver(forName: UIApplication.willResignActiveNotification, object: nil, queue: .main) { [weak self] _ in
            self?.bgmPlayer?.pause()
        }
        
        NotificationCenter.default.addObserver(forName: UIApplication.didBecomeActiveNotification, object: nil, queue: .main) { [weak self] _ in
            self?.bgmPlayer?.play()
        }
    }
    
    // for sound effects
    func playSound(soundName: String) {
        guard let url = Bundle.main.url(forResource: soundName, withExtension: "mp3") else {
            print("Could not find the sound file: \(soundName)")
            return
        }
        
        do {
            sfxPlayer = try AVAudioPlayer(contentsOf: url)
            sfxPlayer?.play()
        } catch {
            print("Error playing sound: \(error.localizedDescription)")
        }
    }
    
    // for background music (used .m4a because it's supposedly better for background music)
    func playBackgroundMusic(soundName: String) {
        // this is made just in case, as unwindToStart only goes back and doesn't call this function again
        if bgmPlayer?.isPlaying == true {
                    return
        }
        
        guard let url = Bundle.main.url(forResource: soundName, withExtension: "m4a") else { return }
            do {
                bgmPlayer = try AVAudioPlayer(contentsOf: url)
                // infinite loops
                bgmPlayer?.numberOfLoops = -1
                // Lower volume so sound effecs can still be heard
                bgmPlayer?.volume = 0.3
                bgmPlayer?.play()
            } catch {
                print("Error playing BGM: \(error.localizedDescription)")
            }
    }
}
