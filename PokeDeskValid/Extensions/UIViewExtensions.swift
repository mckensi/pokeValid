//
//  UIViewExtensions.swift
//  PokeDeskValid
//
//  Created by Daniel Steven Murcia Almanza on 25/08/20.
//  Copyright © 2020 selvamatic. All rights reserved.
//

import Foundation
import UIKit

extension UITableView{
    func registerNib(_ nibName: String) {
        let cellNib = UINib.init(nibName: nibName, bundle: nil)
        register(cellNib, forCellReuseIdentifier: nibName)
    }
}


extension UIView {
    
    /// X Origin of UIView
    @objc var xOrigin: CGFloat {
        get {
            return frame.origin.x
        }
        set(newX) {
            frame.origin.x = newX
        }
    }
    
    /// Y Origin of UIView
    @objc var yOrigin: CGFloat {
        get {
            return frame.origin.y
        }
        set(newY) {
            frame.origin.y = newY
        }
    }
    
    /// New height of the UIView
    @objc var heightValue: CGFloat {
        get {
            return self.frame.size.height
        }
        set(newHeight) {
            frame.size.height = newHeight
        }
    }
    
    /// New Width of the UIView
    @objc var widthValue: CGFloat {
        get {
            return self.frame.size.width
        }
        set(newWidth) {
            frame.size.width = newWidth
        }
    }
    
    ///  Make a UIView circular. Width and height of the UIView must be same otherwise resultant view will be oval not a circle.
    @objc @discardableResult func makeCircular() -> UIView {
        self.layer.cornerRadius = min(heightValue, widthValue) / 2.0
        self.clipsToBounds = true
        return self
    }
    
    /// Shows horizontal border by adding a sublayer at specified position on UIView.
    ///
    /// - Parameters:
    ///   - borderColor: Color to set for the border. If ignored White is used by default
    ///   - yPosition: Y Axis position where the border will be shown.
    ///   - borderHeight: Height of the border.
    @objc @discardableResult func horizontalBorder(borderColor: UIColor = UIColor.white, yPosition: CGFloat = 0, borderHeight: CGFloat = 1.0) -> UIView {
        let lowerBorder = CALayer()
        lowerBorder.backgroundColor = borderColor.cgColor
        lowerBorder.frame = CGRect(x: 0, y: yPosition, width: frame.width, height: borderHeight)
        layer.addSublayer(lowerBorder)
        clipsToBounds = true
        return self
    }
    
    /// Shows vertical border by adding a sublayer at specified position on UIView.
    ///
    /// - Parameters:
    ///   - borderColor: Color to set for the border. If ignored White is used by default
    ///   - xPosition: X Axis position where the border will be shown.
    ///   - borderWidth: Width of the border
    @objc @discardableResult func verticalBorder(borderColor: UIColor = UIColor.white, xPosition: CGFloat = 0, borderWidth: CGFloat = 1.0) -> UIView {
        let lowerBorder = CALayer()
        lowerBorder.backgroundColor = borderColor.cgColor
        lowerBorder.frame = CGRect(x: xPosition, y: 0, width: frame.width, height: borderWidth)
        layer.addSublayer(lowerBorder)
        return self
    }
    
    /// Shows dashed border around the view.
    //    func addDashedBorder() {
    //        let color = UIColor.red.cgColor
    //
    //        let shapeLayer: CAShapeLayer = CAShapeLayer()
    //        let frameSize = self.frame.size
    //        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
    //
    //        shapeLayer.bounds = shapeRect
    //        shapeLayer.position = CGPoint(x: frameSize.width / 2, y: frameSize.height / 2)
    //        shapeLayer.fillColor = UIColor.clear.cgColor
    //        shapeLayer.strokeColor = color
    //        shapeLayer.lineWidth = 2
    //        shapeLayer.lineJoin = kCALineJoinRound
    //        shapeLayer.lineDashPattern = [6, 3]
    //        shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: 5).cgPath
    //
    //        self.layer.addSublayer(shapeLayer)
    //    }
    
    /// Instantiate a view from xib.
    ///
    /// - Returns: Instantiatd view from XIB
    @objc class func instanceFromNib() -> UIView {
        return UINib(nibName: String(describing: self), bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
    
    /// Shows Imaginamos progress view
    //    @objc internal func showHUD() {
    //        ImaginamosHUD.showHUD(view: self)
    //    }
    //
    //    /// Hides Imaginamos progress view
    //    @objc internal func hideHUD() {
    //        ImaginamosHUD.hideHUD(view: self)
    //    }
    
    /// Capture screenshot of a view and return as an instance of UIImage.
    ///
    /// - Returns: screenshot of the view
    @objc internal func captureSnapshot() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
        self.drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        // old style [self.layer renderInContext:UIGraphicsGetCurrentContext()];
        let image: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    
    public func addViewController(viewController: UIViewController){
        let view = viewController.view ?? UIView()
        self.addSubview(view)
        viewController.view.frame = self.bounds
    }
    
    
    
}

/// View with Dashed border
class UIViewWithDashedLineBorder: UIView {
    override func draw(_ rect: CGRect) {
        
        let path = UIBezierPath(roundedRect: rect, cornerRadius: 0)
        
        UIColor.white.setFill()
        path.fill()
        
        UIColor.black.setStroke()
        path.lineWidth = 2
        
        let dashPattern: [CGFloat] = [10, 4]
        path.setLineDash(dashPattern, count: 2, phase: 0)
        path.stroke()
    }
}



extension UIViewController {
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    /// Creates instance of the controller from XIB file
    ///
    /// - Returns: UIViewController instance from XIB file
    internal class func instantiateFromXIB<T: UIViewController>() -> T {
        let xibName = T.stringRepresentation
        let vc = T(nibName: xibName, bundle: nil)
        return vc
    }
    
    /// Creates instance of the controller from XIB file. if No name is supplied for storyboard "Main" is assumed.
    ///
    /// - Parameter storyboardName: Name of the storyboard.
    /// - Returns: UIViewController instance from Storybaord
    
}

extension NSObject {
    
    /// Name of the class
    @objc class var stringRepresentation: String {
        let name = String(describing: self)
        return name
    }
}

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + self.lowercased().dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}

