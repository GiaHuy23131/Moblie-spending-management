//
//  Color.swift
//  DoAn
//
//  Created by CNTT on 5/24/23.
//  Copyright © 2023 fit.tdc. All rights reserved.
//

import Foundation
import UIKit

class Color {
    private var red:CGFloat
    private var green:CGFloat
    private var blue:CGFloat
    
    init(red:Float, green:Float, blue:Float){
        self.red = CGFloat(red)
        self.green = CGFloat(green)
        self.blue = CGFloat(blue)
    }
    
    init(){
        self.red = 0.0
        self.green = 0.0
        self.blue = 0.0
    }
    
    func setRed(red:Float){
        self.red = CGFloat(red)
    }
    
    func setGreen(green:Float){
        self.green = CGFloat(green)
    }
    
    func setBlue(blue:Float){
        self.blue = CGFloat(blue)
    }
    
    func getColor() -> UIColor {
        let color = UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1.0)
        
        return color
    }
    
    
    var Red:CGFloat {
        get {
            return self.red
        }
        set {
            self.red = newValue
        }
    }
    
    var Green:CGFloat {
        get {
            return self.green
        }
        set {
            self.green = newValue
        }
    }
    
    var Blue:CGFloat {
        get {
            return self.blue
        }
        set {
            self.blue = newValue
        }
    }
    
    func getString() -> String {
        let string = "Red: \(round(red))\nGreen: \(round(green))\nBlue: \(round(blue))"
        return string
    }
}
