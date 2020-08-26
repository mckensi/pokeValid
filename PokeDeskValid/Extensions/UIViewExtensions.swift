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


func getImageForType(type: String) -> UIImage{
       switch type {
       case "normal":
           return #imageLiteral(resourceName: "Normal")
       case "fighting":
           return #imageLiteral(resourceName: "Fight")
       case "flying":
           return #imageLiteral(resourceName: "Flying")
       case "poison":
           return #imageLiteral(resourceName: "Poison")
       case "ground":
           return #imageLiteral(resourceName: "Ground")
       case "rock":
           return #imageLiteral(resourceName: "Rock")
       case "bug":
           return #imageLiteral(resourceName: "Bug")
       case "ghost":
           return #imageLiteral(resourceName: "Ghost")
       case "electric":
           return #imageLiteral(resourceName: "Electric")
       case "steel":
           return #imageLiteral(resourceName: "Steel")
       case "fire":
           return #imageLiteral(resourceName: "Fire")
       case "water":
           return #imageLiteral(resourceName: "Water")
       case "grass":
           return #imageLiteral(resourceName: "Grass")
       case "psychic":
           return #imageLiteral(resourceName: "Psychic")
       case "ice":
           return #imageLiteral(resourceName: "Ice")
       case "dragon":
           return #imageLiteral(resourceName: "Dragon")
       case "dark":
           return #imageLiteral(resourceName: "Dark")
       default:
           return #imageLiteral(resourceName: "Normal")
       }
   }

func getImageMainForType(type: String) -> UIImage{
    switch type {
    case "normal":
        return #imageLiteral(resourceName: "Types-Normal")
    case "fighting":
        return #imageLiteral(resourceName: "Types-Fight")
    case "flying":
        return #imageLiteral(resourceName: "Types-Flying")
    case "poison":
        return #imageLiteral(resourceName: "Types-Poison")
    case "ground":
        return #imageLiteral(resourceName: "Types-Ground")
    case "rock":
        return #imageLiteral(resourceName: "Types-Rock")
    case "bug":
        return #imageLiteral(resourceName: "Types-Bug")
    case "ghost":
        return #imageLiteral(resourceName: "Types-Ghost")
    case "electric":
        return #imageLiteral(resourceName: "Types-Electric")
    case "steel":
        return #imageLiteral(resourceName: "Types-Steel")
    case "fire":
        return #imageLiteral(resourceName: "Types-Fire")
    case "water":
        return #imageLiteral(resourceName: "Types-Water")
    case "grass":
        return #imageLiteral(resourceName: "Grass")
    case "psychic":
        return #imageLiteral(resourceName: "Types-Psychic")
    case "ice":
        return #imageLiteral(resourceName: "Types-Dragon")
    case "dragon":
        return #imageLiteral(resourceName: "Dragon")
    case "dark":
        return #imageLiteral(resourceName: "Types-Dark")
    default:
        return #imageLiteral(resourceName: "Normal")
    }
}


func getColorTypePokemon(type: String) -> [CGColor]{
       switch type {
       case "normal":
           return [#colorLiteral(red: 0.5725490196, green: 0.5960784314, blue: 0.6431372549, alpha: 1).cgColor,#colorLiteral(red: 0.6392156863, green: 0.6431372549, blue: 0.6196078431, alpha: 1).cgColor]
       case "fighting":
           return [#colorLiteral(red: 0.3333333333, green: 0.6196078431, blue: 0.8745098039, alpha: 1).cgColor,#colorLiteral(red: 0.3333333333, green: 0.6196078431, blue: 0.8745098039, alpha: 1).cgColor]
       case "flying":
           return [#colorLiteral(red: 0.5647058824, green: 0.6549019608, blue: 0.8549019608, alpha: 1).cgColor,#colorLiteral(red: 0.6509803922, green: 0.7607843137, blue: 0.9490196078, alpha: 1).cgColor]
       case "poison":
           return [#colorLiteral(red: 0.6588235294, green: 0.3921568627, blue: 0.7803921569, alpha: 1).cgColor,#colorLiteral(red: 0.7607843137, green: 0.3803921569, blue: 0.831372549, alpha: 1).cgColor]
       case "ground":
           return [#colorLiteral(red: 0.862745098, green: 0.4588235294, blue: 0.2705882353, alpha: 1).cgColor,#colorLiteral(red: 0.8235294118, green: 0.5803921569, blue: 0.3882352941, alpha: 1).cgColor]
       case "rock":
           return [#colorLiteral(red: 0.7725490196, green: 0.7058823529, blue: 0.537254902, alpha: 1).cgColor,#colorLiteral(red: 0.8431372549, green: 0.8039215686, blue: 0.5647058824, alpha: 1).cgColor]
       case "bug":
           return [#colorLiteral(red: 0.5725490196, green: 0.737254902, blue: 0.1725490196, alpha: 1).cgColor,#colorLiteral(red: 0.6862745098, green: 0.7843137255, blue: 0.2117647059, alpha: 1).cgColor]
       case "ghost":
           return [#colorLiteral(red: 0.3176470588, green: 0.4156862745, blue: 0.6745098039, alpha: 1).cgColor,#colorLiteral(red: 0.4666666667, green: 0.4509803922, blue: 0.831372549, alpha: 1).cgColor]
       case "electric":
           return [#colorLiteral(red: 0.9294117647, green: 0.8352941176, blue: 0.2431372549, alpha: 1).cgColor,#colorLiteral(red: 0.9843137255, green: 0.8862745098, blue: 0.4509803922, alpha: 1).cgColor]
       case "steel":
           return [#colorLiteral(red: 0.3215686275, green: 0.5254901961, blue: 0.6156862745, alpha: 1).cgColor,#colorLiteral(red: 0.3450980392, green: 0.6509803922, blue: 0.6666666667, alpha: 1).cgColor]
       case "fire":
           return [#colorLiteral(red: 0.9843137255, green: 0.6078431373, blue: 0.3176470588, alpha: 1).cgColor,#colorLiteral(red: 0.9843137255, green: 0.6823529412, blue: 0.2745098039, alpha: 1).cgColor]
       case "water":
           return [#colorLiteral(red: 0.3333333333, green: 0.6196078431, blue: 0.8745098039, alpha: 1).cgColor,#colorLiteral(red: 0.3333333333, green: 0.6196078431, blue: 0.8745098039, alpha: 1).cgColor]
       case "grass":
           return [#colorLiteral(red: 0.3725490196, green: 0.737254902, blue: 0.3176470588, alpha: 1).cgColor,#colorLiteral(red: 0.3529411765, green: 0.7568627451, blue: 0.4705882353, alpha: 1).cgColor]
       case "psychic":
           return [#colorLiteral(red: 0.9647058824, green: 0.4352941176, blue: 0.4431372549, alpha: 1).cgColor,#colorLiteral(red: 0.9960784314, green: 0.6235294118, blue: 0.5725490196, alpha: 1).cgColor]
       case "ice":
           return [#colorLiteral(red: 0.4392156863, green: 0.8, blue: 0.7411764706, alpha: 1).cgColor,#colorLiteral(red: 0.5490196078, green: 0.8666666667, blue: 0.831372549, alpha: 1).cgColor]
       case "dragon":
           return [#colorLiteral(red: 0.04705882353, green: 0.4117647059, blue: 0.7843137255, alpha: 1).cgColor,#colorLiteral(red: 0.003921568627, green: 0.5019607843, blue: 0.7803921569, alpha: 1).cgColor]
       case "dark":
           return [#colorLiteral(red: 0.3490196078, green: 0.3411764706, blue: 0.3803921569, alpha: 1).cgColor,#colorLiteral(red: 0.431372549, green: 0.4588235294, blue: 0.5294117647, alpha: 1).cgColor]
       default:
           return [#colorLiteral(red: 0.5725490196, green: 0.5960784314, blue: 0.6431372549, alpha: 1).cgColor,#colorLiteral(red: 0.6392156863, green: 0.6431372549, blue: 0.6196078431, alpha: 1).cgColor]
       }
   }
