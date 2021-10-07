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
    private  let listOperator = ["+", "-", "x", "÷"]
    private var calculationIsFinish = true

    func addNumber(number: String) {
        var stringNumber = ""
        guard let lastElement = arrayElement.last else {
            arrayElement.append(number)
            return
        }
        if listOperator.contains(lastElement) {
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
        return arrayElement.count >= 3 && !listOperator.contains(arrayElement.last ?? "+")
    }

    func canAddOperator() -> Bool {
        guard !calculationIsFinish else {
            return false
        }

        if listOperator.contains(arrayElement.last ?? "+") {
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
        var operation = ""
        var result: Float = 0.0
        var firstNumber = ""
        var secondNumber = ""
        var index = 0
        var max = arrayElement.count

        while index < max {
            firstNumber = arrayElement[0]
            operation = arrayElement[1]
            secondNumber = arrayElement[2]

            if  let left = Float(firstNumber), let right = Float(secondNumber) {

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
                    break
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
        if (arrayElement.contains("-") || arrayElement.contains("+"))
            && (arrayElement.contains("x") || arrayElement.contains("÷")) {
            calculationPriority(operation: "x")
            calculationPriority(operation: "÷")
        }
    }

    private func calculationPriority(operation: String) {
        var max = arrayElement.count - 1
        var index = 0
        var result: Float = 0.0
        var newElement = ""

        while index < max {
            if arrayElement[index] == operation {
                if let leftNumber = Float(arrayElement[index - 1]), let rightNumber = Float(arrayElement[index + 1]) {

                    switch operation {
                    case "x":
                        result = leftNumber * rightNumber
                    case "÷":
                        result = leftNumber/rightNumber
                    default:
                        break
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

}
