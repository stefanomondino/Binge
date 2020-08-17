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
            UIGraphicsBeginImageContext(bezier.bounds.insetBy(dx: lineWidth, dy: lineWidth).size)
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

        func circled() -> UIImage {
            guard !size.isEmpty else { return self }
            let dimension = min(size.width, size.height)
            let rect = CGRect(x: 0, y: 0, width: dimension, height: dimension)
            UIGraphicsBeginImageContext(rect.size)
            let point = CGPoint(x: (rect.size.width - size.width) / 2, y: (rect.size.height - size.height) / 2)
            UIBezierPath(ovalIn: rect).addClip()
            draw(at: point)

            let image = UIGraphicsGetImageFromCurrentImageContext() ?? self
            UIGraphicsEndImageContext()
            return image
        }
    }
#endif
