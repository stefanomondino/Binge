//
//  String+Extensions.swift
//  App
//
//  Created by Stefano Mondino on 16/12/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import UIKit
import Model

extension String {
    
    public func generateQRCode(with size: CGSize) -> Image? {
        let data = self.data(using: String.Encoding.isoLatin1, allowLossyConversion: false)
        
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            filter.setValue("M", forKey: "inputCorrectionLevel")
            
            if let output = filter.outputImage {
                let scaleX = size.width / output.extent.size.width
                let scaleY = size.height / output.extent.size.height
                let transformedImage = output.transformed(by: CGAffineTransform(scaleX: scaleX, y: scaleY))
                return Image(ciImage: transformedImage)
            }
        }
        return nil
    }
}
