//
//  Styles.swift
//  App
//
//  Created by Alberto Bo on 12/03/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import SwiftRichString
import ViewModel

extension Identifiers.Styles: Bootstrappable {
    
    static var defaultStyle: Style = {
        return Style {
            $0.font = Fonts.main(.regular).font(size: 12)
            $0.color = UIColor.black
            
        }
    }()
    
    private var main: Style { return Identifiers.Styles.defaultStyle }
    
    var style: Style {
        
        switch self {
   
        case .mainBoldStyle: return main.byAdding { $0.font = Fonts.main(.bold).font(size: 20.0) }
        
        case .mainEmptyButton: return main.byAdding {
            $0.font = Fonts.main(.bold).font(size: 22.0)
            $0.color = Color.blue
            }
            
        case .mainFilledButton: return main.byAdding {
            $0.font = Fonts.main(.bold).font(size: 22.0)
            $0.color = Color.white
            }

        case .placeholderSmall: return Style {
            $0.font = Fonts.main(.semibold).font(size: 12)
            }
            
        case .placeholderBig: return Style {
            $0.font = Fonts.main(.semibold).font(size: 18)
            }
        case .mainRegularStyle: return Style {
            $0.font = Fonts.main(.semibold).font(size: 18)
            }
            
        default:  return main
        }
    }
    
    static func bootstrap() {
        self.allCases.forEach {
            StylesManager.shared.register($0.rawValue, style: $0.style)
        }
    }
}
