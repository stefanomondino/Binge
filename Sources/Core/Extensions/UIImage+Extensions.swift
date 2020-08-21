//
//  UIImage+Extensions.swift
//  App
//
//  Created by Stefano Mondino on 16/12/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

#if os(iOS) || os(tvOS)
    import Foundation
    import UIKit

    private struct AssociatedKeys {
        static var downloadtime = "imageDownloader_downloadtime"
    }

    extension Core.Image {
        /// How long must take an image to be available in order to be considered "downloaded"
        var downloadTimeThreshold: TimeInterval { return 0.2 }

        /// Total amount of time that took this image to be "downloaded"
        /// This is useful to decide if, in the UI, an image should fade-in when presented or not
        /// Defaults to 0.0
        public var downloadTime: TimeInterval {
            get { return objc_getAssociatedObject(self, &AssociatedKeys.downloadtime) as? TimeInterval ?? 0.0 }
            set {
                objc_setAssociatedObject(self, &AssociatedKeys.downloadtime, newValue, .OBJC_ASSOCIATION_COPY)
            }
        }

        /// Defaults to false
        public var isDownloaded: Bool {
            return downloadTime > downloadTimeThreshold
        }
    }

    public extension UIImage {
        static func shape(with bezier: UIBezierPath, strokeColor: UIColor = .clear, fillColor: UIColor = .clear, lineWidth: CGFloat = 0) -> UIImage {
            UIGraphicsBeginImageContextWithOptions(bezier.bounds.insetBy(dx: lineWidth, dy: lineWidth).size, false, UIScreen.main.scale)
            fillColor.setFill()
            bezier.fill()
            if lineWidth > 0 {
                strokeColor.setStroke()
                bezier.stroke()
            }
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return image ?? UIImage()
        }

        static func rectangle(rect: CGRect, strokeColor: UIColor = .clear, fillColor: UIColor = .clear, lineWidth: CGFloat = 0, cornerRadius: CGFloat = 0) -> UIImage {
            let bezier: UIBezierPath
            if cornerRadius > 0 {
                bezier = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius)
            } else {
                bezier = UIBezierPath(rect: rect)
            }
            return shape(with: bezier, strokeColor: strokeColor, fillColor: fillColor, lineWidth: lineWidth)
        }

        static func circle(radius: CGFloat, strokeColor: UIColor = .clear, fillColor: UIColor = .clear, lineWidth: CGFloat = 0) -> UIImage {
            let bezier = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: radius * 2, height: radius * 2))
            return shape(with: bezier, strokeColor: strokeColor, fillColor: fillColor, lineWidth: lineWidth)
        }

        static func oval(rect: CGRect, strokeColor: UIColor = .clear, fillColor: UIColor = .clear, lineWidth: CGFloat = 0) -> UIImage {
            let bezier = UIBezierPath(ovalIn: rect)
            return shape(with: bezier, strokeColor: strokeColor, fillColor: fillColor, lineWidth: lineWidth)
        }

        static func background(color: UIColor = .clear) -> UIImage {
            let width: CGFloat = 1
            let bezier = UIBezierPath(rect: CGRect(x: 0, y: 0, width: width * 2, height: width * 2))
            return shape(with: bezier, fillColor: color)
                .resizableImage(withCapInsets: UIEdgeInsets(top: width, left: width, bottom: width, right: width), resizingMode: .stretch)
        }

        func masked(by shape: UIBezierPath) -> UIImage {
            guard !size.isEmpty else { return self }
            let rect = shape.bounds // CGRect(x: 0, y: 0, width: dimension, height: dimension)
            UIGraphicsBeginImageContextWithOptions(rect.size, false, scale)
            let point = CGPoint(x: (rect.size.width - size.width) / 2, y: (rect.size.height - size.height) / 2)
            shape.addClip()
            draw(at: point)
            let image = UIGraphicsGetImageFromCurrentImageContext() ?? self
            UIGraphicsEndImageContext()
            return image
        }

        var fillRect: CGRect {
            let dimension = min(size.width, size.height)
            return CGRect(x: 0, y: 0, width: dimension, height: dimension)
        }

        var fitRect: CGRect {
            let dimension = max(size.width, size.height)
            return CGRect(x: 0, y: 0, width: dimension, height: dimension)
        }

        func circled() -> UIImage {
            return masked(by: UIBezierPath(ovalIn: fillRect))
        }

        func squared(with cornerRadius: CGFloat = 0.0) -> UIImage {
            return masked(by: UIBezierPath(roundedRect: fillRect, cornerRadius: cornerRadius))
        }

        func tinted(with color: UIColor) -> UIImage {
            var image = withRenderingMode(.alwaysTemplate)
            UIGraphicsBeginImageContextWithOptions(size, false, scale)
            color.set()
            image.draw(in: CGRect(origin: .zero, size: size))
            image = UIGraphicsGetImageFromCurrentImageContext() ?? self
            UIGraphicsEndImageContext()
            return image
        }

        func overlaying(_ image: UIImage, at point: CGPoint? = nil) -> UIImage {
            UIGraphicsBeginImageContextWithOptions(size, false, scale)
            draw(at: .zero)
            let point = point ?? CGPoint(x: (size.width - image.size.width) / 2, y: (size.height - image.size.height) / 2)
            image.draw(at: point)
            let image = UIGraphicsGetImageFromCurrentImageContext() ?? self
            UIGraphicsEndImageContext()
            return image
        }

        func resized(to newSize: CGSize) -> UIImage {
            let finalSize: CGSize
            if size.ratio > 1 {
                let height = newSize.width / size.ratio
                finalSize = CGSize(width: newSize.width, height: height)
            } else {
                let width = newSize.height / size.ratio
                finalSize = CGSize(width: width, height: newSize.height)
            }
            UIGraphicsBeginImageContextWithOptions(finalSize, false, scale)
            draw(in: .init(origin: .zero, size: finalSize))
            let image = UIGraphicsGetImageFromCurrentImageContext() ?? self
            UIGraphicsEndImageContext()
            return image
        }
    }
#endif
