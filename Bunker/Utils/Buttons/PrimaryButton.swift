//
//  YellowButton.swift
//  Bunker
//
//  Created by Дмитрий Соколов on 06.05.2022.
//

import UIKit
import AVFoundation

final class PrimaryButton: UIButton {
    private var audioPlayer = AVAudioPlayer()
    static let sound1 = URL(fileURLWithPath: Bundle.main.path(forResource: "buttonSound3", ofType: "wav")!)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = 12
        self.setTitleColor(.black, for: .normal)
        self.setHeight(to: 48)
        self.setWidth(to: ScreenSize.Width-48)
        self.titleLabel?.font = .customFont.body
        self.addTarget(self, action: #selector(playSound), for: .touchUpInside)
    }
    
    @objc
    private func playSound() {
        if(UserSettings.shared.volume == .off) {
            return
        }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: PrimaryButton.sound1)
            audioPlayer.setVolume(0.1, fadeDuration: 1)
            audioPlayer.play()
        } catch {
            
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setTheme(_ theme: Appearence) {
        self.backgroundColor = .Main.Primary.colorFor(theme)
        self.layer.applyFigmaShadow(color: .Main.Shadow.colorFor(theme) ?? .clear)
        self.setTitleColor(.Main.onPrimary.colorFor(theme), for: .normal)
    }
}
