//
//  PaddingLabel.swift
//  VK-Test
//
//  Created by Данила on 03.12.2024.
//

import Foundation
import UIKit

class PaddedLabel: UILabel {
    var textInsets = UIEdgeInsets(top: 2, left: 5, bottom: 2, right: 5)
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: textInsets))
    }
    
    override var intrinsicContentSize: CGSize {
        let originalSize = super.intrinsicContentSize
        let width = originalSize.width + textInsets.left + textInsets.right
        let height = originalSize.height + textInsets.top + textInsets.bottom
        return CGSize(width: width, height: height)
    }
}

