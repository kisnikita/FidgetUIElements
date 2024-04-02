//
//  File.swift
//  
//
//  Created by Никита Кислов on 24.02.2024.
//

import Foundation

import AVFoundation

var player: AVAudioPlayer?

func playSound(_ soundName: String) {
    guard let url = Bundle.module.url(forResource: soundName, withExtension: "mp3") else {
        print("URL is wrong")
        return
    }
    do {
        player = try AVAudioPlayer(contentsOf: url)
        guard let player = player else { print("URL is wrong 2"); return }

        player.prepareToPlay()
        player.play()

    } catch {
        print(error.localizedDescription)
    }
}
