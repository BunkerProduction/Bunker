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

    private var loadingView: LoadingView = {
        return LoadingView(color: .clear, lineWidth: 3)
    }()

    var isLoading = false {
        didSet {
            if isLoading {
                startAnimation()
            } else {
                stopAnimation()
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = 12
        self.setHeight(to: 48)
        self.setWidth(to: ScreenSize.Width-48)
        self.titleLabel?.font = .customFont.body
        self.addTarget(self, action: #selector(playSound), for: .touchUpInside)
        self.addSubview(loadingView)
        self.loadingView.alpha = 0

        loadingView.setHeight(to: 24)
        loadingView.setWidth(to: 24)
        loadingView.pinCenter(to: self)
    }

    func setTitleVisible(_ visible: Bool) {
        if visible {
            self.titleLabel?.alpha = 1
        } else {
            self.titleLabel?.alpha = 0
        }

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

    private func startAnimation() {
        loadingView.isAnimating = true
        loadingView.alpha = 1
        self.setTitleVisible(false)

    }

    private func stopAnimation() {
        loadingView.isAnimating = false
        loadingView.alpha = 0
        self.setTitleVisible(true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setTheme(_ theme: Appearence) {
        self.backgroundColor = .Main.Primary.colorFor(theme)
        self.layer.applyFigmaShadow(color: .Main.Shadow.colorFor(theme) ?? .clear)
        self.setTitleColor(.Main.onPrimary.colorFor(theme), for: .normal)
        self.setTitleColor(.Main.onPrimary.colorFor(theme)?.withAlphaComponent(0.5), for: .disabled)
        self.loadingView.setStrokeColor(.Main.onPrimary.colorFor(theme) ?? .clear)
    }
}
