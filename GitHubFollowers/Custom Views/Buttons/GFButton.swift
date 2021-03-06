//
//  GFButton.swift
//  GitHubFollowers
//
//  Created by Mateusz Zacharski on 07/11/2020.
//

import UIKit

class GFButton: UIButton {

    override init(frame: CGRect) { // we have to override the initializer if we do custom stuff in it.
        super.init(frame: frame) // first we let all Apple's things initialize.
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(backgroundColor: UIColor, title: String) {
        self.init(frame: .zero) // normally when you initialize you have to give it a frame, but we will do it with auto-layout constraints anyway, so we can initialize it with a frame of .zero.
        self.backgroundColor = backgroundColor
        self.setTitle(title, for: .normal)
    }
    
    private func configure() { // 'private' means it can be called only in this class.
        layer.cornerRadius = 10
        titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        setTitleColor(.white, for: .normal)
        translatesAutoresizingMaskIntoConstraints = false
        
        self.addTarget(self, action: #selector(buttonUp), for: .touchUpInside)
        self.addTarget(self, action: #selector(buttonDown), for: .touchDown)
        self.addTarget(self, action: #selector(buttonCancel), for: .touchDragExit)
        self.addTarget(self, action: #selector(buttonDragInside), for: .touchDragInside)
    }
    
    func set(backgroundColor: UIColor, title: String) {
        self.backgroundColor = backgroundColor
        setTitle(title, for: .normal)
    }
    
    @objc func buttonUp(_ sender: UIButton) {
        animateButtonAlpha(buttonAnimated: sender, toAlpha: 1)
    }

    @objc func buttonDown(_ sender: UIButton) {
        animateButtonAlpha(buttonAnimated: sender, toAlpha: 0.6)
    }

    @objc func buttonCancel(_ sender: UIButton) {
        animateButtonAlpha(buttonAnimated: sender, toAlpha: 1)
    }

    @objc func buttonDragInside(_ sender: UIButton) {
        animateButtonAlpha(buttonAnimated: sender, toAlpha: 0.6)
    }
    
    private func animateButtonAlpha(buttonAnimated button: UIButton, toAlpha alpha: CGFloat) {
        UIView.animate(withDuration: 0.1) {
            button.alpha = alpha
        }
    }
    
}






