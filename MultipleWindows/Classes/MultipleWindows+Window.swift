//
//  MultipleWindows+Window.swift
//  Vick_Custom
//
//  Created by Vick on 2022/8/8.
//

import UIKit

extension MultipleWindows {
    public func addWindow(frame: CGRect = UIScreen.main.bounds,
                          rootViewController vc: UIViewController,
                          adsorption: Bool = false,
                          animation: CAAnimation?,
                          completion: (()->Void)? = nil) {
        let window = BaseWindow(frame: frame, adsorption: adsorption)
        window.layer.cornerRadius = window.state == .full ? 0 : minCornerRadius
        window.layer.masksToBounds = true
        window.backgroundColor = .clear
        window.rootViewController = vc
        window.windowLevel = MultipleWindows.shared.level
        window.isHidden = false
        
        if let animation = animation {
            window.layer.add(animation, forKey: nil)
        }
        
        if adsorption {
            let new = correctionFrame(by: frame)
            DispatchQueue.main.asyncAfter(deadline: .now()+addDuration) {
                if window.state == .min {
                    self.minWindow(by: new, completion: completion)
                } else {
                    completion?()
                }
            }
        }
        
        MultipleWindows.shared.windowsMamager.insert(window)
        MultipleWindows.shared.currentWindow = window
        MultipleWindows.shared.level += 1
    }
    
    public func removeCurrentWindow(completion: (()->Void)? = nil) {
        if let window = MultipleWindows.shared.currentWindow {
            switch window.state {
            case .min:
                window.layer.add(removeMinAnimation, forKey: nil)
            case .full:
                window.layer.add(removeFullAnimation, forKey: nil)
            default:
                break
            }
            DispatchQueue.main.asyncAfter(deadline: .now()+removeDuration) {
                window.layer.removeAllAnimations()
                window.isHidden = true
                window.rootViewController = nil
                MultipleWindows.shared.windowsMamager.remove(window)
                MultipleWindows.shared.currentWindow = nil
                completion?()
            }
        } else {
            completion?()
        }
    }
    
    public func changeCurrect(by window: BaseWindow) {
        MultipleWindows.shared.currentWindow = window
    }
}
