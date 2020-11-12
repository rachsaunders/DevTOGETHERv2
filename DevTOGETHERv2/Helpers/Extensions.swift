//
//  Extensions.swift
//  DevTOGETHERv2
//
//  Created by Rachel Saunders on 12/11/2020.
//

import Foundation
import UIKit

extension Date {
    
    func longDate() -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MM yyyy"
        return dateFormatter.string(from: self)
    }
    
    func stringDate() -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MM yyyy"
        return dateFormatter.string(from: self)
    }
}

extension UIColor {
    
    func primary() -> UIColor {
        
        return UIColor(red: 20/255, green: 45/255, blue: 85/255, alpha: 1)
    }
    
    func tabBarUnselected() -> UIColor {
        
        return UIColor(red: 255/255, green: 216/255, blue: 223/255, alpha: 1)
    }
    
}
