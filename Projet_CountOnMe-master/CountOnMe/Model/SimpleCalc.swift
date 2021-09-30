//
//  Addition.swift
//  CountOnMe
//
//  Created by Yoan on 20/09/2021.
//  Copyright © 2021 Vincent Saluzzo. All rights reserved.
//

import Foundation

class SimpleCalc {
    
    var arrayElement: [String] = []
    private let arrayOperator = ["+", "-", "÷", "x"]
    private var firstNumber = ""
    private var secondNumber = ""
    private var operation = ""
    private var result = 0
    
    public func addNumber(element: String) {
        arrayElement.append(element)
        if operation.isEmpty {
            firstNumber = firstNumber + element
        } else {
            secondNumber = secondNumber + element
        }
    }
    
    public func addOperator(addOperation: String) -> Bool {
        guard expressionIsCorrect(element: addOperation) else {
            return false
        }
        if operation.isEmpty {
            arrayElement.append(addOperation)
            operation = addOperation
        } else if expressionIsCorrect(element: addOperation) {
            arrayElement.append(addOperation)
            if let calculation = calcul() {
                firstNumber = String(calculation)
            }
            secondNumber = ""
            operation = addOperation
        } else {
            return false
        }
        return true
    }
    
    public func equal() -> Int? {
        guard let verify = arrayElement.last, expressionIsCorrect(element: verify) else {
            return nil
        }
        if calcul() != nil {
            return calcul()
        }
        return nil
    }
    
    public func resetCalcul() {
        arrayElement = []
        firstNumber = ""
        secondNumber = ""
        operation = ""
        result = 0
    }
    
    private  func expressionIsCorrect(element: String) -> Bool {
        guard let verify = arrayElement.last else {
            return false
        }
        return !arrayOperator.contains(verify)
    }
    
    private func calcul() -> Int? {
        if  let left = Int(firstNumber), let right = Int(secondNumber) {
            switch operation {
            case "+":
                result = left + right
            case "-":
                result = left - right
            case "÷":
                result = left / right
            case "x":
                result = left * right
            default:
                print("error")
            }
        } else {
            print("Veuillez entrer un opérateur et un autre chiffre pour le calcul")
            return nil
        }
        return result
    }
}

