//
//  UIView+Extension.swift
//  AsteroidNeoApp
//

import UIKit
import Foundation

// MARK: - extension UIView
//---------------------------------------------------------------------------------------------------------------------------------------------

extension UIView {
        
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {

        get {
            return self.layer.borderWidth
        }
        set {
            self.layer.borderWidth = newValue
        }
    }


    @IBInspectable var borderColor: CGColor {
        get {
            return self.layer.borderColor ?? UIColor.clear.cgColor
        }
        set {
            self.layer.borderColor = newValue
        }
    }

}
