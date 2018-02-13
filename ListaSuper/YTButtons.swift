//
//  YTButtons.swift
//  YouTube Example
//
//  Created by Sean Allen on 4/11/17.
//  Copyright © 2017 Sean Allen. All rights reserved.
//

import UIKit

class YTRoundedButton: UIButton {

    required init() {
        super.init(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        layer.cornerRadius = self.frame.height / 2
        clipsToBounds = true
    }
}


