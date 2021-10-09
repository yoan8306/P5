//
//  Addition.swift
//  CountOnMe
//
//  Created by Yoan on 20/09/2021.
//  Copyright © 2021 Vincent Saluzzo. All rights reserved.
//

import Foundation

class LogicCalculation {
    var arrayElement: [String] = []
    private  let listOperator = ListingOperator.allCases
    private var calculationIsFinish = true
    
    func addNumber(number: String) {
        var stringNumber = ""
        guard let lastElement = arrayElement.last else {
            arrayElement.append(number)
            return
        }
        
        if checkLastElementIsOperator(lastElement: lastElement) {
            arrayElement.append(number)
        } else {
            stringNumber  = lastElement + number
            arrayElement.removeLast()
            arrayElement.append(stringNumber)
        }
    }
    
    func addOperator(newOperator: String) {
        arrayElement.append(newOperator)
    }
    
    func equal() -> String {
        var result: Float
        checkPriority()
        result = makeCalculation()
        
        return String(result)
    }
    
    func isCalculationValid() -> Bool {
        return arrayElement.count >= 3 && !checkLastElementIsOperator(lastElement: arrayElement.last ?? "+")
    }
    
    func canAddOperator() -> Bool {
        guard !calculationIsFinish else {
            return false
        }
        
        if checkLastElementIsOperator(lastElement: arrayElement.last ?? "+") {
            return false
        }
        return true
    }
    
    func resetCalculationIfNeed() -> Bool {
        if calculationIsFinish {
            arrayElement = []
            calculationIsFinish = false
            return true
        }
        return false
    }
    
    // MARK: - private func
    private func makeCalculation() -> Float {
        var operation: ListingOperator = .addition
        var result: Float = 0.0
        var firstNumber = ""
        var secondNumber = ""
        var index = 0
        var max = arrayElement.count
        
        while index < max {
            firstNumber = arrayElement[0]
            secondNumber = arrayElement[2]
            
            for element in listOperator where element.rawValue == arrayElement[1] {
                operation = element
            }
            
            if  let left = Float(firstNumber), let right = Float(secondNumber) {
                
                switch operation {
                case .addition:
                    result = left + right
                case .subtract:
                    result = left - right
                case .division:
                    result = left / right
                case .multiplication:
                    result = left * right
                }
                
                arrayElement = Array(arrayElement.dropFirst(3))
                arrayElement.insert("\(result)", at: 0)
            }
            max = arrayElement.count
            index += 1
        }
        calculationIsFinish = true
        return result
    }
    
    private  func checkPriority() {
        
        if (arrayElement.contains(ListingOperator.subtract.rawValue) ||
            arrayElement.contains(ListingOperator.addition.rawValue)) &&
            (arrayElement.contains(ListingOperator.multiplication.rawValue) ||
             arrayElement.contains(ListingOperator.division.rawValue)) {
            
            calculationPriority(operation: .multiplication)
            calculationPriority(operation: .division)
        }
    }
    
    private func calculationPriority(operation: ListingOperator) {
        var max = arrayElement.count - 1
        var index = 0
        var result: Float = 0.0
        var newElement = ""
        
        while index < max {
            if arrayElement[index] == operation.rawValue {
                if let leftNumber = Float(arrayElement[index - 1]), let rightNumber = Float(arrayElement[index + 1]) {
                    
                    switch operation {
                    case .multiplication:
                        result = leftNumber * rightNumber
                    case .division:
                        result = leftNumber/rightNumber
                    default: break
                    }
                    
                    newElement = String(result)
                    arrayElement.removeSubrange(index - 1 ... index + 1)
                    arrayElement.insert(newElement, at: index - 1)
                    max = arrayElement.count - 1
                }
            }
            index += 1
        }
        
    }
    
    private func checkLastElementIsOperator(lastElement: String) -> Bool {
        for element in listOperator where element.rawValue == lastElement {
            return true
        }
        return false
    }
    
}
