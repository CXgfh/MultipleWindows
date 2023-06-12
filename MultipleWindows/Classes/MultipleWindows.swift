//
//  MultipleWindows.swift
//  Vick_Custom
//
//  Created by Vick on 2022/8/2.
//

import UIKit
import Foundation
import Util_V

public protocol MultipleWindowsViewController: AnyObject {
    func minTransitioning()
    func fullTransitioning()
}

public class MultipleWindows: NSObject {
    
    public static var shared = MultipleWindows()
    
    public var edgeInsets = Util.deviceSafeAreaInsets
    public var minCornerRadius: CGFloat = 10
    
    public var duration: CGFloat = 0.34
    public var addDuration: CGFloat = 0.34
    public var removeDuration: CGFloat = 0.34
    
    public lazy var addAnimation: CAAnimation = {
        let animation = CATransition()
        animation.type = "push"
        animation.subtype = "fromRight"
        animation.startProgress = 0
        animation.endProgress = 1
        animation.duration = addDuration
        return animation
    }()
    
    public lazy var removeFullAnimation: CAAnimation = {
        let animation = CABasicAnimation(keyPath: "transform.translation.x")
        animation.isCumulative = false
        animation.autoreverses = false
        animation.timingFunction = .init(name: "easeOut")
        animation.isRemovedOnCompletion = false
        animation.fillMode = "forwards"
        animation.repeatCount = 1
        animation.duration = removeDuration
        animation.byValue = UIScreen.main.bounds.width
        return animation
    }()
    
    public lazy var removeMinAnimation: CAAnimation = {
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.isCumulative = false
        animation.autoreverses = false
        animation.timingFunction = .init(name: "default")
        animation.isRemovedOnCompletion = false
        animation.fillMode = "forwards"
        animation.repeatCount = 1
        animation.duration = removeDuration
        animation.fromValue = 1
        animation.toValue = 0
        return animation
    }()
    
    internal var level: CGFloat = 1
    public internal(set) var currentWindow: BaseWindow?
    public var windowsMamager = Set<BaseWindow>()
    internal var gesturesManager: [UIWindow.Level: UIPanGestureRecognizer] = [:]
}

extension MultipleWindows {
    @objc func panWindow(_ sender: UIPanGestureRecognizer) {
        if let window = MultipleWindows.shared.currentWindow {
            switch sender.state {
            case .changed:
                let distance = sender.translation(in: window)
                var x = window.x + distance.x
                if x < edgeInsets.left {
                    x = edgeInsets.left
                } else if x > UIScreen.main.bounds.width - edgeInsets.right - window.frame.width {
                    x = UIScreen.main.bounds.width - edgeInsets.right - window.frame.width
                }
                window.x = x
                
                var y = window.y + distance.y
                if y < edgeInsets.top {
                    y = edgeInsets.top
                } else if y > UIScreen.main.bounds.height - edgeInsets.bottom - window.frame.height {
                    y = UIScreen.main.bounds.height - edgeInsets.bottom - window.frame.height
                }
                window.y = y
                
                sender.setTranslation(.zero, in: window)
            case .ended:
                adsorptionWindow(by: window.frame, on: window)
            default:
                break
            }
        }
    }
}

