import UIKit
import ViewModel

extension UIImage {
    
    func tinted(_ tintColor: UIColor) -> UIImage {
        let rect: CGRect = CGRect(origin: CGPoint(x: 0.0, y: 0.0), size: CGSize(width: self.size.width, height: self.size.height))
        
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        self.draw(in: rect)
        let context = UIGraphicsGetCurrentContext()
        context?.setBlendMode(CGBlendMode.sourceIn)
        
        tintColor.setFill()
        UIColor.green.setStroke()
        let shape = UIBezierPath.init(rect: rect)
        shape.fill()
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image ?? self
    }
    func highlighted(_ tintColor: UIColor = UIColor.black) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        self.draw(at: .zero, blendMode: .normal, alpha: 0.25)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image ?? self
    }
    
    func resizedImage(toScale scale: CGFloat) -> UIImage {
        // Guard newSize is different
        let newSize = size.applying(CGAffineTransform(scaleX: scale, y: scale))
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    static func navbar(alpha: CGFloat = 1.0) -> UIImage {
        let alpha = min(0.99, alpha)
        return UIImage.rectangle(ofSize: CGSize(width: 2, height: 2), color: UIColor.black.withAlphaComponent(alpha))
            .resizableImage(withCapInsets: UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1), resizingMode: .stretch)
            ?? UIImage()
    }
    static func rectangle(ofSize size: CGSize, color: UIColor, borderColor: UIColor? = nil, borderWidth: CGFloat = 0, cornerRadius: CGFloat = 0) -> UIImage {
        let bigRect =  CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(bigRect.size, false, 0.0)
        let context = UIGraphicsGetCurrentContext()
        context!.setAllowsAntialiasing(true)
        context!.setShouldAntialias(true)
        let path = UIBezierPath(roundedRect: bigRect.insetBy(dx: borderWidth, dy: borderWidth), cornerRadius: cornerRadius)
        context!.setFillColor(color.cgColor)
        path.fill()
        
        if (borderColor != nil) {
            context!.setLineWidth(borderWidth)
            context!.setStrokeColor(borderColor!.cgColor)
            path.stroke()
        }
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image ?? UIImage.init()
    }
    
    static func oval(ofSize size: CGSize, color: UIColor, borderColor: UIColor? = nil, borderWidth: CGFloat = 0, cornerRadius: CGFloat = 0) -> UIImage {
        let bigRect =  CGRect(x: 0, y: 0, width: size.width, height:
            
            size.height)
        UIGraphicsBeginImageContextWithOptions(bigRect.size, false, 0.0)
        let context = UIGraphicsGetCurrentContext()
        context!.setAllowsAntialiasing(true)
        context!.setShouldAntialias(true)
        let path = UIBezierPath(ovalIn: bigRect.insetBy(dx: borderWidth, dy: borderWidth))
        context!.setFillColor(color.cgColor)
        path.fill()
        
        if (borderColor != nil) {
            context!.setLineWidth(borderWidth)
            context!.setStrokeColor(borderColor!.cgColor)
            path.stroke()
        }
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image ?? UIImage.init()
    }
}
