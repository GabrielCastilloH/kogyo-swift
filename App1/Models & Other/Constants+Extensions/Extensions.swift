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
}
