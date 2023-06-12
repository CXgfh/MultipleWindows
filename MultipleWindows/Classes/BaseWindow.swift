//
//  VWindow.swift
//  Vick_Custom
//
//  Created by Vick on 2022/8/8.
//

import UIKit

public enum MultipleWindowsState {
    case min
    case full
}

public class BaseWindow: UIWindow {
    public var state: MultipleWindowsState
    
    public var adsorption: Bool
    
    init(frame: CGRect, adsorption: Bool) {
        self.adsorption = adsorption
        state = frame.size == UIScreen.main.bounds.size ? .full : .min
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        MultipleWindows.shared.changeCurrect(by: self)
        return super.hitTest(point, with: event)
    }
}
