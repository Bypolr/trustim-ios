//
//  TIButton.swift
//  TrustIM-iOS
//
//  Created by towry on 05/03/2017.
//  Copyright © 2017 towry. All rights reserved.
//

import UIKit

class TIButton: UIButton {
    public var backgroundColorForHighlight: UIColor?
    
    override var isHighlighted: Bool {
        didSet {
            if backgroundColorForHighlight != nil {
                let tempColor = backgroundColor
                backgroundColor = backgroundColorForHighlight!
                backgroundColorForHighlight = tempColor
            }
        }
    }
}
