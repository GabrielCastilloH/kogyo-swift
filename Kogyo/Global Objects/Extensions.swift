//
//  Extensions.swift
//  App1
//
//  Created by Gabriel Castillo on 6/6/24.
//

import UIKit
import Photos

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


class CustomDashedView: UIView {

    var cornerRadius: CGFloat = 10 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    var dashWidth: CGFloat = 2
    var dashColor: UIColor = .black
    var dashLength: CGFloat = 8
    var betweenDashesSpace: CGFloat = 4

    var dashBorder: CAShapeLayer?

    override func layoutSubviews() {
        super.layoutSubviews()
        dashBorder?.removeFromSuperlayer()
        let dashBorder = CAShapeLayer()
        dashBorder.lineWidth = dashWidth
        dashBorder.strokeColor = dashColor.cgColor
        dashBorder.lineDashPattern = [dashLength, betweenDashesSpace] as [NSNumber]
        dashBorder.frame = bounds
        dashBorder.fillColor = nil
        if cornerRadius > 0 {
            dashBorder.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
        } else {
            dashBorder.path = UIBezierPath(rect: bounds).cgPath
        }
        layer.addSublayer(dashBorder)
        self.dashBorder = dashBorder
    }
}

extension AVAsset {

    func generateThumbnail(completion: @escaping (UIImage) -> Void) {
        DispatchQueue.global().async {
            let imageGenerator = AVAssetImageGenerator(asset: self)
            let times = [NSValue(time: CMTime(seconds: 0.0, preferredTimescale: 600))]
            imageGenerator.appliesPreferredTrackTransform = true
            imageGenerator.generateCGImagesAsynchronously(forTimes: times, completionHandler: { _, image, aaa, bbb, ccc in
                if let image = image {
                    completion(UIImage(cgImage: image))
                } else {
                    completion(UIImage(systemName: "video")!)
                }
            })
        }
    }
}
