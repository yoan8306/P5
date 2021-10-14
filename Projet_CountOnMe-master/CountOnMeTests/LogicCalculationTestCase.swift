//
//  LogicCalculationTestCase.swift
//  CountOnMeTests
//
//  Created by Yoan on 08/10/2021.
//  Copyright © 2021 Vincent Saluzzo. All rights reserved.
//

import XCTest
@testable import CountOnMe

class LogicCalculationTestCase: XCTestCase {

    var calculator: LogicCalculation!
    var result: String!

    override func setUp() {
        super.setUp()
        calculator = LogicCalculation()
        result = ""
    }

    func testGivenAddition_WhenPressEqual_ThenMakeCalculation () {
        givenAddition()

        result = pressEqual()

        XCTAssertTrue(result == "78.0")
        XCTAssertTrue(calculator.calculationIsFinish)
    }

    func testGivenSubtract_WhenPressEqual_ThenMakeCalculation () {
        givenSubtract()

        result = pressEqual()

        XCTAssertTrue(result == "1.0")
    }

    func testGivenDivision_WhenPressEqual_ThenMakeCalculation () {
        givenDivision()

        result = pressEqual()

        XCTAssertTrue(result == "23.0")
    }

    func testGivenMultiplication_WhenPressEqual_ThenMakeCalculation () {
        givenMultiplication()

        result = pressEqual()

        XCTAssertTrue(result == "100.0")
    }

    func testGivenAddition_WhenPressTwoOperators_ThenLastOperatorIsNotInArray () {
        givenAddition()

        pressOperator(operatorCalculation: "÷")
        pressOperator(operatorCalculation: "+")

        XCTAssertTrue(calculator.arrayElement == ["34", "+", "44", "÷"])
        XCTAssertFalse(calculator.calculationIsFinish)
    }

    func testGivenDivisionByZero_WhenPressEqual_ThenResultEqualErreurAndCalculationIsFinished () {
        pressNumber(number: "8")
        pressOperator(operatorCalculation: "÷")
        pressNumber(number: "0")

        result = pressEqual()

        XCTAssertTrue(result == "Erreur")
        XCTAssertTrue(calculator.calculationIsFinish)
    }

    func testGivenCalculaltionWithPriority_WhenPressEqual_ThenMakeMultiplicationFirst () {
        givenAddition()
        pressOperator(operatorCalculation: "x")
        givenDivision()

        result = pressEqual()

        XCTAssertTrue(result == "1046.0")
    }

    func testGivenCalculationPriorityWithDivisionByZero_WhenPressEqual_ThenResultEqualErreur () {
        givenAddition()
        pressOperator(operatorCalculation: "x")
        givenAddition()
        pressOperator(operatorCalculation: "÷")
        pressNumber(number: "0")
        pressOperator(operatorCalculation: "+")
        givenAddition()

        result = pressEqual()

        XCTAssertTrue(result == "Erreur")
        XCTAssertTrue(calculator.calculationIsFinish)
    }

    func testGivenCalculationIsIncomplete_WhenPressEqual_ThenResultIsEmpty () {
        pressNumber(number: "3")
        pressOperator(operatorCalculation: "÷")

        result = pressEqual()

        XCTAssertFalse(calculator.isCalculationValid())
        XCTAssertTrue(result == "")
        XCTAssertFalse(calculator.canAddOperator())
        XCTAssertFalse(calculator.calculationIsFinish)
    }

    func testGivenCalculationIsEmpty_WhenPressEqual_ThenResultIsEmptyCanAddOperatorIsFalse () {
        result = pressEqual()

        XCTAssertTrue(result == "")
        XCTAssertFalse(calculator.isCalculationValid())
        XCTAssertFalse(calculator.canAddOperator())
    }

    func testGivenCalculationHaveAddition_WhenPressResetButton_ThenArrayElementIsEmpty () {
        givenAddition()

        calculator.resetCalculation()

        XCTAssertTrue(calculator.arrayElement == [])
        XCTAssertFalse(calculator.isCalculationValid())
    }

    private func pressNumber(number: String) {
            calculator.resetCalculationIfNeed()
            calculator.addNumber(number: number)
    }

    private func pressOperator(operatorCalculation: String) {
        if  calculator.canAddOperator() {
            calculator.addOperator(newOperator: operatorCalculation)
        }
    }

    private func pressEqual() -> String {
        if calculator.isCalculationValid() {
            return calculator.equal()
        }
       return ""
    }

    private func givenAddition() {
        pressNumber(number: "3")
        pressNumber(number: "4")
        pressOperator(operatorCalculation: "+")
        pressNumber(number: "4")
        pressNumber(number: "4")
    }

    private func givenDivision() {
        pressNumber(number: "4")
        pressNumber(number: "6")
        pressOperator(operatorCalculation: "÷")
        pressNumber(number: "2")
    }

    private func givenSubtract() {
        pressNumber(number: "3")
        pressOperator(operatorCalculation: "-")
        pressNumber(number: "2")
    }

    private func givenMultiplication() {
        pressNumber(number: "5")
        pressNumber(number: "0")
        pressOperator(operatorCalculation: "x")
        pressNumber(number: "2")
    }
}
