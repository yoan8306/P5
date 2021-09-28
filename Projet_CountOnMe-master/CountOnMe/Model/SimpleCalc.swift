//
//  Addition.swift
//  CountOnMe
//
//  Created by Yoan on 20/09/2021.
//  Copyright © 2021 Vincent Saluzzo. All rights reserved.
//

import Foundation

class SimpleCalc {
    var element: [String] = []
    
    func operation() {
        while element.count > 1 {
            let left = Int(element[0])!
            let operand = element[1]
            let right = Int(element[2])!
            
            let result: Int
            switch operand {
            case "+": result = left + right
            case "-": result = left - right
            case "x": result = left * right
            case "÷": result = left / right
            default: fatalError("Unknown operator !")
            }
            element = Array(element.dropFirst(3))
            element.insert("\(result)", at: 0)
        }
    }
}

