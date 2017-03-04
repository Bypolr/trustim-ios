//
//  TITextField.swift
//  TrustIM-iOS
//
//  Created by towry on 04/03/2017.
//  Copyright © 2017 towry. All rights reserved.
//

import UIKit

class TITextField: UITextField {
    
    private var _corners: UIRectCorner?
    private var _radius: CGFloat?
    
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
        self._corners = corners
        self._radius = radius
    }
    
    private func _roundCorners() {
        if self._corners == nil || self._radius == nil {
            return
        }
        
        let path = UIBezierPath(roundedRect: layer.bounds, byRoundingCorners: _corners!, cornerRadii: CGSize(width: _radius!, height: _radius!))
        let mask = CAShapeLayer()
        mask.frame = layer.bounds
        mask.path = path.cgPath
        layer.mask = mask
        
        // create border layer 
        let borderLayer = CAShapeLayer()
        borderLayer.path = path.cgPath
        borderLayer.lineWidth = self.layer.borderWidth + 1
        borderLayer.strokeColor = self.layer.borderColor
        borderLayer.fillColor = nil
        
        self.layer.addSublayer(borderLayer)
    }
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        self._roundCorners()
    }
}
