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
    let listOperator = ["+", "-", "x", "÷"]

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

    func addOperator(newOperator: String) -> Bool {
        if canAddOperator() {
            arrayElement.append(newOperator)
            return true
        }
        return false
    }

    func equal() -> String? {
        var result: Int

        guard arrayElement.count >= 3 && !listOperator.contains(arrayElement.last ?? "+") else {
            return nil
        }

        checkPriority()
        result = makeCalculation()

        arrayElement = []
        return String(result)
    }

    private func makeCalculation() -> Int {
        var operation = ""
        var result = 0
        var firstNumber = ""
        var secondNumber = ""
        var index = 0
        var max = arrayElement.count

        while index < max {
            firstNumber = arrayElement[0]
            operation = arrayElement[1]
            secondNumber = arrayElement[2]

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
                    break
                }

                arrayElement = Array(arrayElement.dropFirst(3))
                arrayElement.insert("\(result)", at: 0)
            }
            max = arrayElement.count
            index += 1
        }
        return result
    }

    // MARK: - private func

    private  func canAddOperator() -> Bool {
        guard let lastElement = arrayElement.last else {
            return false
        }

        if listOperator.contains(lastElement) {
            return false
        }
        return true
    }

    private  func checkPriority() {
        if arrayElement.contains("-") || arrayElement.contains("+") ||
            arrayElement.contains("÷") && arrayElement.contains("x") {
            calculationPriority()
        }
    }

    private func calculationPriority() {
        var max = arrayElement.count - 1
        var index = 0
        var result = 0
        var newElement = ""

        while index < max {
            if arrayElement[index] == "x" {
                if let leftNumber = Int(arrayElement[index - 1]), let rightNumber = Int(arrayElement[index + 1]) {
                    result = leftNumber * rightNumber
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
