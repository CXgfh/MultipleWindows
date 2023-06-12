//
//  MultipleWindows+Size.swift
//  Vick_Custom
//
//  Created by Vick on 2022/8/8.
//

import UIKit
import Util_V

extension MultipleWindows {
    public func minWindow(by frame: CGRect, completion: (()->Void)? = nil) {
        if let window = MultipleWindows.shared.currentWindow {
            if window.adsorption {
                adsorptionWindow(by: frame, on: window) {
                    if MultipleWindows.shared.gesturesManager[window.windowLevel] == nil {
                        let pan = UIPanGestureRecognizer.init(target: self, action: #selector(self.panWindow))
                        MultipleWindows.shared.gesturesManager[window.windowLevel] = pan
                        window.addGestureRecognizer(pan)
                    }
                    completion?()
                }
            }
        }
    }
    
    internal func adsorptionWindow(by frame: CGRect, on window: BaseWindow, completion: (()->Void)? = nil) {
        let new = adsorptionFrame(by: frame)
        if window.frame != new {
            UIView.animate(withDuration: MultipleWindows.shared.duration, delay: 0, options: [.curveEaseOut]) {
                window.frame = new
                window.layer.cornerRadius = MultipleWindows.shared.minCornerRadius
            } completion: { _ in
                if window.state == .full,
                   let vc =  findTopViewController(window.rootViewController) as? MultipleWindowsViewController {
                    vc.minTransitioning()
                }
                window.state = .min
                completion?()
            }
        }
    }
    
    public func fullWindow(completion: (()->Void)? = nil) {
        if let window = MultipleWindows.shared.currentWindow {
            if window.state == .min {
                UIView.animate(withDuration: MultipleWindows.shared.duration, delay: 0, options: [.curveEaseInOut]) {
                    window.frame = UIScreen.main.bounds
                    window.layer.cornerRadius = 0
                } completion: { _ in
                    if let vc = findTopViewController(window.rootViewController) as? MultipleWindowsViewController {
                        vc.fullTransitioning()
                    }
                    let pan = MultipleWindows.shared.gesturesManager[window.windowLevel]
                    MultipleWindows.shared.gesturesManager[window.windowLevel] = nil
                    if let pan = pan {
                        window.removeGestureRecognizer(pan)
                    }
                    window.state = .full
                    completion?()
                }
            }
        }
    }
}
