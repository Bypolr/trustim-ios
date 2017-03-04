//
//  TITextField.swift
//  TrustIM-iOS
//
//  Created by towry on 04/03/2017.
//  Copyright © 2017 towry. All rights reserved.
//

import UIKit

class TITextField: UITextField {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 10, dy: 0)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }
    
    func setup() {
        borderStyle = .none
        layer.masksToBounds = true
        layer.borderColor = UIColor(hex: 0xE5EFEF).cgColor
        layer.borderWidth = 1.0
    }
    
    // corners
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        print(self.bounds)
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let layer = CAShapeLayer()
        layer.backgroundColor = UIColor.yellow.cgColor
        layer.frame = self.bounds
        layer.path = path.cgPath
        self.layer.mask = layer
    }
}
