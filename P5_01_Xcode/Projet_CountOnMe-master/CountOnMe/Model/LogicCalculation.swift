//
//  LogicCalculation.swift
//  CountOnMe
//
//  Created by Yoan on 20/09/2021.
//  Copyright © 2021 Vincent Saluzzo. All rights reserved.
//

import Foundation
import CoreVideo

class LogicCalculation {
    var arrayElement: [String] = []
    var calculationIsFinish = false
    private  let listOperator = Operator.allCases

    /// Add number in array Element
    /// - Parameter number: number enter by user
    func addNumber(number: String) {
        guard let lastElement = arrayElement.last else {
            arrayElement.append(number)
            return
        }

        if lastElementIsOperator(lastElement: lastElement) {
            arrayElement.append(number)
        } else {
            arrayElement.removeLast()
            arrayElement.append(lastElement + number)
        }
    }

    /// Add operator in array Element
    /// - Parameter newOperator: Operator enter by user
    func addOperator(newOperator: String) {
        arrayElement.append(newOperator)
    }

    /// Make calculation
    /// - Returns: return result in String
    func equal() -> String {
        checkPriority()
        return makeCalculation()
    }

    /// Check if expression for calculation is correct
    /// - Returns: return true if correct or false if incorrect
    func isCalculationValid() -> Bool {
        guard let lastElement = arrayElement.last else {
            return false
        }
        return arrayElement.count >= 3 && !lastElementIsOperator(lastElement: lastElement)
    }

    /// check can add operator
    /// - Returns: true if can add operator or false if can't add operator
    func canAddOperator() -> Bool {
        guard !calculationIsFinish, let lastElement = arrayElement.last else {
            return false
        }

        return !lastElementIsOperator(lastElement: lastElement)
    }

    /// if calculation is finish empty arrayElement and start new calculation
    func resetCalculationIfNeed() {
        guard calculationIsFinish else {
            return
        }
        resetCalculation()
    }

    /// empty arrayElement and start new calculation
    func resetCalculation() {
        arrayElement = []
        calculationIsFinish = false
    }

    /// transform arrayElement to string for textView
    /// - Returns: arrayElement to string
    func formatCalculToText() -> String {
        return arrayElement.joined(separator: " ")
    }

    // MARK: - private func

    /// check if last element in array is operator
    /// - Parameter lastElement: element in arrayElement
    /// - Returns: true if last element is operator and false if isn't it
    private func lastElementIsOperator(lastElement: String) -> Bool {
        for element in listOperator where element.rawValue == lastElement {
            return true
        }
        return false
    }

    /// check if calculation need calcul priority
    private  func checkPriority() {
        
        if (arrayElement.contains(Operator.multiplication.rawValue) ||
             arrayElement.contains(Operator.division.rawValue)) {

            calculationPriority(operation: .multiplication)
            calculationPriority(operation: .division)
        }
    }

    /// make calcul priority multiplication or division
    /// - Parameter operation: make operation multiplication or division
    private func calculationPriority(operation: Operator) {
        var max = arrayElement.count - 1
        var index = 0
        var result: Float = 0.0
        var newElement = ""

        while index < max {
            if arrayElement[index] == operation.rawValue {
                guard let left = Float(arrayElement[index - 1]), let right = Float(arrayElement[index + 1]) else {
                    index += 1
                    continue
                }

                switch operation {
                case .multiplication:
                    result = makeMultiplication(leftNumber: left, rightNumber: right)
                case .division:
                    guard let calculation = makeDivision(leftNumber: left, rightNumber: right)  else {
                        return
                    }
                    result = calculation

                default: break
                }

                newElement = String(result)
                arrayElement.removeSubrange(index - 1 ... index + 1)
                arrayElement.insert(newElement, at: index - 1)
                max = arrayElement.count
            } else {
                index += 1
            }
        }
    }

    /// calcule all Element in arrayElement without priority
    /// - Returns: return sum total all elements
    private func makeCalculation() -> String {
        var result: Float = 0.0
        var index = 0
        let max = arrayElement.count - 2

        guard arrayElement.count > 1 else {
            calculationIsFinish = true
            return formatCalculToText()
        }

        while index < max {
            
            if  let left = Float(arrayElement[index]), let right = Float(arrayElement[index + 2]),
                let operation = Operator(rawValue: arrayElement[index + 1]) {

                switch operation {
                case .addition:
                    result += makeAddition(leftNumber: left, rightNumber: right)
                case .subtract:
                    result += makeSubtraction(leftNumber: left, rightNumber: right)
                case .division:
                    guard let calculation = makeDivision(leftNumber: left, rightNumber: right) else {
                        calculationIsFinish = true
                        return "Erreur"
                    }
                    result += calculation
                case .multiplication:
                    result += makeMultiplication(leftNumber: left, rightNumber: right)
                }
            }
            index += 1
        }
        calculationIsFinish = true
        return String(result)
    }

    /// make addition
    /// - Parameters:
    ///   - leftNumber: number before operator
    ///   - rightNumber: number after operator
    /// - Returns: return result of addition
    private func makeAddition(leftNumber: Float, rightNumber: Float) -> Float {
        return leftNumber + rightNumber
    }

    /// make subtraction
    /// - Parameters:
    ///   - leftNumber: number before operator
    ///   - rightNumber: number after operator
    /// - Returns: return result of subtraction
    private func makeSubtraction(leftNumber: Float, rightNumber: Float) -> Float {
        return leftNumber - rightNumber
    }

    /// make division
    /// - Parameters:
    ///   - leftNumber: number before operator
    ///   - rightNumber: number after operator
    /// - Returns: return result of division if possible
    private func makeDivision(leftNumber: Float, rightNumber: Float) -> Float? {
        guard rightNumber != 0 else {
            return nil
        }
        return leftNumber / rightNumber
    }

    /// make multiplication
    /// - Parameters:
    ///   - leftNumber: number before operator
    ///   - rightNumber: number after operator
    /// - Returns: return result of multiplication
    private func makeMultiplication(leftNumber: Float, rightNumber: Float) -> Float {
        return leftNumber * rightNumber
    }
}
