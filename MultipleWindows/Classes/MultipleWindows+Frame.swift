//
//  MultipleWindows+Frame.swift
//  Vick_Custom
//
//  Created by Vick on 2022/8/8.
//

import UIKit
import Util_V

enum AdsorptionDirection {
    case right
    case bottom
    case left
    case top
}

///吸附优先级：右-下-左-上
extension MultipleWindows {
    internal func adsorptionFrame(by frame: CGRect) -> CGRect {
        let right = UIScreen.main.bounds.width - frame.width - frame.origin.x
        let bottom = UIScreen.main.bounds.height - frame.height - frame.origin.y
        let left = frame.origin.x
        let top = frame.origin.y
        
        var m: [(direction: AdsorptionDirection, distance: CGFloat)] = [
            (.right, right),
            (.bottom, bottom),
            (.left, left),
            (.top, top)
        ]
        m.sort(by: { $0.distance < $1.distance })
        switch m[0].direction {
        case .right:
            return CGRect(x: UIScreen.main.bounds.width - frame.width - MultipleWindows.shared.edgeInsets.right,
                          y: frame.origin.y,
                          width: frame.width,
                          height: frame.height)
        case .bottom:
            return CGRect(x: frame.origin.x,
                          y: UIScreen.main.bounds.height - frame.height - MultipleWindows.shared.edgeInsets.bottom,
                          width: frame.width,
                          height: frame.height)
        case .left:
            return CGRect(x: MultipleWindows.shared.edgeInsets.left,
                          y: frame.origin.y,
                          width: frame.width,
                          height: frame.height)
        case .top:
            return CGRect(x: frame.origin.x,
                          y: MultipleWindows.shared.edgeInsets.right,
                          width: frame.width,
                          height: frame.height)
        }
    }
    
    internal func correctionFrame(by frame: CGRect) -> CGRect {
        var new = frame
        if new.width > UIScreen.main.bounds.width {
            new.size.width = UIScreen.main.bounds.width
        }
        if new.height > UIScreen.main.bounds.height {
            new.size.height = UIScreen.main.bounds.height
        }
        if new.minX + new.width > UIScreen.main.bounds.width {
            new.origin.x = UIScreen.main.bounds.width - new.width
        }
        if new.minY + new.height > UIScreen.main.bounds.height {
            new.origin.y = UIScreen.main.bounds.height - new.height
        }
        return new
    }
}
