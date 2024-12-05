//
//  Size+Extension.swift
//  VK-Test
//
//  Created by Данила on 03.12.2024.
//

import Foundation
import UIKit

public class Size {

    static let shared = Size()
    
    public func fontSize(_ valueMob: CGFloat, _ valuePad: CGFloat = 0) -> CGFloat {
        let x = UIScreen.main.bounds.width/375
        return valueMob * x
    }
    public func width(_ valueMob: CGFloat, _ valuePad: CGFloat = 0) -> CGFloat {
        let x = UIScreen.main.bounds.width/375
        return valueMob * x
    }

    public func height(_ valueMob: CGFloat, _ valuePad: CGFloat = 0) -> CGFloat {
        let y = UIScreen.main.bounds.height/812
        return valueMob * y
    }
    
    public func maxWidth() -> CGFloat {
        return UIScreen.main.bounds.width
    }
    
    public func maxHeight() -> CGFloat {
        return UIScreen.main.bounds.height
    }
    
}

