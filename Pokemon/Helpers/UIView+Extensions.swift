import UIKit

extension UIView {
    func dlgpicker_setupRoundCorners() {
        self.layer.cornerRadius = min(bounds.size.height, bounds.size.width) / 2
    }
            
        func setGradientBackground(topColor: CGColor, bottomColor: CGColor) {
            let colorTop =  topColor
            let colorBottom = bottomColor
            
            let gradientLayer = CAGradientLayer()
            gradientLayer.colors = [colorTop, colorBottom]
    //        gradientLayer.locations = [0.0, 1.0]
            gradientLayer.frame = self.bounds
            
            self.layer.insertSublayer(gradientLayer, at: 0)
        }
        
        /**
         * Rounds only corners top left, top right and bottom left of self.
         *
         * - parameter value: The radius to use for rounding the corners.
         */
        func roundCornersForOutBubbleContent(_ value: CGFloat){
            
            let corners: UIRectCorner = [.topLeft, .topRight, .bottomLeft]
            let cornerRadii = CGSize(width: value, height: value)
            
            let path = UIBezierPath(roundedRect: self.bounds,
                                    byRoundingCorners: corners,
                                    cornerRadii: cornerRadii).cgPath
            
            let rectShape = CAShapeLayer()
                rectShape.bounds = self.frame
                rectShape.position = self.center
                rectShape.path = path
            
            self.layer.mask = rectShape
        }
        
        /**
         * Rounds only corners top left, top right and bottom right of self.
         *
         * - parameter value: The radius to use for rounding the corners.
         */
        func roundCornersForInBubbleContent(_ value: CGFloat)
        {
            let corners: UIRectCorner = [.topLeft, .topRight, .bottomRight]
            let cornerRadii = CGSize(width: value, height: value)
            
            let path = UIBezierPath(roundedRect: self.bounds,
                                    byRoundingCorners: corners,
                                    cornerRadii: cornerRadii).cgPath
            
            let rectShape = CAShapeLayer()
                rectShape.bounds = self.frame
                rectShape.position = self.center
                rectShape.path = path
            
            self.layer.mask = rectShape
        }
        
      
        func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
            let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            self.layer.mask = mask
        }
        
        
        
        func dropShadow(color:UIColor,
                        opacity:Float = 0.5,
                        offSet:CGSize,
                        radius:CGFloat = 1,
                        scale:Bool = true) {
        
            layer.masksToBounds = false
            layer.shadowColor = color.cgColor
            layer.shadowOpacity = opacity
            layer.shadowOffset = offSet
            layer.shadowRadius = radius
        
            print(self.bounds)
                
            layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
            layer.shouldRasterize = true
            layer.rasterizationScale = scale ? UIScreen.main.scale : 1
        
        }
        
        
       
        func applyShadow(color: UIColor = .black,
                         alpha: Float = 0.5,
                         x: CGFloat = 0,
                         y: CGFloat = 2,
                         blur: CGFloat = 4,
                         spread: CGFloat = 0)  {
        
        
            //change it to .height if you need spread for height
        
            let radius: CGFloat = layer.frame.width / 2.0
        
            print(bounds)
        
            let shadowPath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: spread * radius, height: layer.frame.height))
            layer.shadowOffset = CGSize.init(width: x, height: y)
            layer.shadowColor = color.cgColor
            layer.shadowOpacity = alpha
            layer.shadowRadius = blur
            layer.masksToBounds = false
            layer.shadowPath = shadowPath.cgPath
        
        }
        
        
        
        func drawStroke(width: CGFloat, color: UIColor) {
        
       
            let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height), cornerRadius: layer.cornerRadius)
       
            let shapeLayer = CAShapeLayer ()
        
            shapeLayer.path = path.cgPath
       
            shapeLayer.fillColor = UIColor.clear.cgColor
        
            shapeLayer.strokeColor = color.cgColor
        
            shapeLayer.lineWidth = width
       
            self.layer.addSublayer(shapeLayer)
        }
}

@IBDesignable
extension UIView {
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            let color = UIColor(cgColor: layer.borderColor!)
            return color
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
        
    @IBInspectable
    /// Shadow color of view; also inspectable from Storyboard.
    public var shadowColor: UIColor? {
        get {
            guard let color = layer.shadowColor else {
                return nil
            }
            return UIColor(cgColor: color)
        }
        set {
            layer.shadowColor = newValue?.cgColor
        }
    }
    
    @IBInspectable
    /// Shadow offset of view; also inspectable from Storyboard.
    public var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    /// Shadow opacity of view; also inspectable from Storyboard.
    public var shadowOpacity: Double {
        get {
            return Double(layer.shadowOpacity)
        }
        set {
            layer.shadowOpacity = Float(newValue)
        }
    }
    
    @IBInspectable
    /// Shadow radius of view; also inspectable from Storyboard.
    public var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    /// Shadow path of view; also inspectable from Storyboard.
    public var shadowPath: CGPath? {
        get {
            return layer.shadowPath
        }
        set {
            layer.shadowPath = newValue
        }
    }
    
    @IBInspectable
    /// Should shadow rasterize of view; also inspectable from Storyboard.
    /// cache the rendered shadow so that it doesn't need to be redrawn
    public var shadowShouldRasterize: Bool {
        get {
            return layer.shouldRasterize
        }
        set {
            layer.shouldRasterize = newValue
        }
    }
    
    @IBInspectable
    /// Should shadow rasterize of view; also inspectable from Storyboard.
    /// cache the rendered shadow so that it doesn't need to be redrawn
    public var shadowRasterizationScale: CGFloat {
        get {
            return layer.rasterizationScale
        }
        set {
            layer.rasterizationScale = newValue
        }
    }
    
    @IBInspectable
    /// Corner radius of view; also inspectable from Storyboard.
    public var maskToBounds: Bool {
        get {
            return false
        }
        set {
            layer.masksToBounds = false
        }
    }
    
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.6
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        layer.add(animation, forKey: "shake")
    }
    
    
    func pushTransition(_ duration:CFTimeInterval) {
        let animation:CATransition = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name:
            CAMediaTimingFunctionName.easeInEaseOut)
        animation.type = CATransitionType.push
        animation.subtype = CATransitionSubtype.fromTop
        animation.duration = duration
        layer.add(animation, forKey: CATransitionType.push.rawValue)
    }
    
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }

}

