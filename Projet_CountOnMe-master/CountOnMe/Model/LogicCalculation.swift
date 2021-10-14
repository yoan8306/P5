//
//  Addition.swift
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

    func addOperator(newOperator: String) {
        arrayElement.append(newOperator)
    }

    func equal() -> String {
        checkPriority()
        return makeCalculation()
    }

    func isCalculationValid() -> Bool {
        guard let lastElement = arrayElement.last else {
            return false
        }
        return arrayElement.count >= 3 && !lastElementIsOperator(lastElement: lastElement)
    }

    func canAddOperator() -> Bool {
        guard !calculationIsFinish, let lastElement = arrayElement.last else {
            return false
        }

        return !lastElementIsOperator(lastElement: lastElement)
    }

    func resetCalculationIfNeed() {
        guard calculationIsFinish else {
            return
        }
        arrayElement = []
        calculationIsFinish = false
    }

    func resetCalculation() {
        arrayElement = []
        calculationIsFinish = false
    }

    func formatCalculToText() -> String {
        return arrayElement.joined(separator: " ")
    }

    // MARK: - private func
    private func makeCalculation() -> String {

        var result: Float = 0.0
        var index = 0
        let max = arrayElement.count - 2

        while index < max {
            if  let left = Float(arrayElement[index]), let right = Float(arrayElement[index + 2]),
                let operation = Operator(rawValue: arrayElement[index + 1]) {

                switch operation {
                case .addition:
                    result += makeAddition(leftNumber: left, rightNumber: right)
                case .subtract:
                    result += makeSubtract(leftNumber: left, rightNumber: right)
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

    private func makeAddition(leftNumber: Float, rightNumber: Float) -> Float {
        return leftNumber + rightNumber
    }

    private func makeSubtract(leftNumber: Float, rightNumber: Float) -> Float {
        return leftNumber - rightNumber
    }

    private func makeDivision(leftNumber: Float, rightNumber: Float) -> Float? {
        guard rightNumber != 0 else {
            return nil
        }
        return leftNumber / rightNumber
    }

    private func makeMultiplication(leftNumber: Float, rightNumber: Float) -> Float {
        return leftNumber * rightNumber
    }

    private  func checkPriority() {

        if (arrayElement.contains(Operator.subtract.rawValue) ||
            arrayElement.contains(Operator.addition.rawValue)) &&
            (arrayElement.contains(Operator.multiplication.rawValue) ||
             arrayElement.contains(Operator.division.rawValue)) {

            calculationPriority(operation: .multiplication)
            calculationPriority(operation: .division)
        }
    }

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
                max = arrayElement.count - 1
            }
            index += 1
        }
    }

    private func lastElementIsOperator(lastElement: String) -> Bool {
        for element in listOperator where element.rawValue == lastElement {
            return true
        }
        return false
    }

}
