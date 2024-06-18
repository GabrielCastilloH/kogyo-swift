//
//  Extensions.swift
//  App1
//
//  Created by Gabriel Castillo on 6/6/24.
//

import UIKit

extension UIView {
    
    func showHideView(_ value: Int) {
        // Shows and hides add menu with appropriate category when a categoryIsClicked.
        // Value = 1 to show, 0 to hide.
        if value == 1 {
            UIView.transition(
                with: self, duration: 0.4,
                options: .transitionCrossDissolve,
                animations: {
                    self.isHidden = false
            })
        }
        else {
            UIView.transition(
                with: self, duration: 0.2,
                options: .transitionCrossDissolve,
                animations: {
                    self.alpha = 0
            })
            // the animation will not work when hiding the object, only with alpha.
            self.isHidden = true
            self.alpha = 1
        }
    }

    func addDashedBorder(cornerRadius: CGFloat = 5,
                         dashWidth: CGFloat = 1,
                         dashColor: UIColor = .black,
                         dashLength: CGFloat = 5,
                         betweenDashesSpace: CGFloat = 3) {
        
        // Remove any existing dashed border layers
        layer.sublayers?.removeAll(where: { $0 is CAShapeLayer && $0.name == "dashedBorder" })
        
        // Create a new CAShapeLayer for the dashed border
        let dashBorder = CAShapeLayer()
        dashBorder.name = "dashedBorder"
        dashBorder.lineWidth = dashWidth
        dashBorder.strokeColor = dashColor.cgColor
        dashBorder.lineDashPattern = [dashLength, betweenDashesSpace] as [NSNumber]
        dashBorder.frame = bounds
        dashBorder.fillColor = nil
        
        // Set the path for the dashed border
        if cornerRadius > 0 {
            dashBorder.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
        } else {
            dashBorder.path = UIBezierPath(rect: bounds).cgPath
        }
        
        // Add the dashed border to the view's layer
        layer.addSublayer(dashBorder)
        
        // Set the corner radius for the view itself
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = true
    }
}

