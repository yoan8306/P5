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

    /// Test addition simple
    func testGivenAddition_WhenPressEqual_ThenMakeCalculation () {
        givenAddition()

        result = pressEqual()

        XCTAssertTrue(result == "78.0")
        XCTAssertTrue(calculator.calculationIsFinish)
    }

    /// Test subtract simple
    func testGivenSubtract_WhenPressEqual_ThenMakeCalculation () {
        givenSubtract()

        result = pressEqual()

        XCTAssertTrue(result == "1.0")
    }

    /// Test division simple
    func testGivenDivision_WhenPressEqual_ThenMakeCalculation () {
        givenDivision()

        result = pressEqual()

        XCTAssertTrue(result == "23.0")
    }

    /// Test multiplication simple
    func testGivenMultiplication_WhenPressEqual_ThenMakeCalculation () {
        givenMultiplication()

        result = pressEqual()

        XCTAssertTrue(result == "100.0")
    }

    /// Test division by zero
    func testGivenDivisionByZero_WhenPressEqual_ThenResultEqualErreurAndCalculationIsFinished () {
        pressNumber(number: "8")
        pressOperator(operatorCalculation: "÷")
        pressNumber(number: "0")

        result = pressEqual()

        XCTAssertTrue(result == "Erreur")
        XCTAssertTrue(calculator.calculationIsFinish)
    }

    /// Test insert two operators
    func testGivenAddition_WhenPressTwoOperators_ThenLastOperatorIsNotInArray () {
        givenAddition()

        pressOperator(operatorCalculation: "÷")
        pressOperator(operatorCalculation: "+")

        XCTAssertTrue(calculator.arrayElement == ["34", "+", "44", "÷"])
        XCTAssertFalse(calculator.calculationIsFinish)
    }

    /// Test calculation priority
    func testGivenCalculaltionWithPriority_WhenPressEqual_ThenMakeMultiplicationFirst () {
        givenAddition()
        pressOperator(operatorCalculation: "x")
        givenDivision()

        result = pressEqual()

        XCTAssertTrue(result == "1046.0")
    }
    
    /// Test calculation with more multiplication
    func testGivenCalculationWithMultipleMultiplication_WhenPressEqual_ThenMakeMultiplication () {
        pressNumber(number: "2")
        pressOperator(operatorCalculation: "+")
        pressNumber(number: "2")
        pressOperator(operatorCalculation: "x")
        pressNumber(number: "3")
        pressOperator(operatorCalculation: "x")
        pressNumber(number: "2")
        
        result = pressEqual()
        
        XCTAssertTrue( result == "14.0")
    }

    /// Test calculation priority with division by zéro
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

    /// Test calculation invalid
    func testGivenCalculationIsIncomplete_WhenPressEqual_ThenResultIsEmpty () {
        pressNumber(number: "3")
        pressOperator(operatorCalculation: "÷")

        result = pressEqual()

        XCTAssertFalse(calculator.isCalculationValid())
        XCTAssertTrue(result == "")
        XCTAssertFalse(calculator.canAddOperator())
        XCTAssertFalse(calculator.calculationIsFinish)
    }

    /// calculation empty and press Equal
    func testGivenCalculationIsEmpty_WhenPressEqual_ThenResultIsEmptyCanAddOperatorIsFalse () {
        result = pressEqual()

        XCTAssertTrue(result == "")
        XCTAssertFalse(calculator.isCalculationValid())
        XCTAssertFalse(calculator.canAddOperator())
    }

    /// Test reset arrayElement
    func testGivenCalculationHaveAddition_WhenPressResetButton_ThenArrayElementIsEmpty () {
        givenAddition()

        calculator.resetCalculation()

        XCTAssertTrue(calculator.arrayElement == [])
        XCTAssertFalse(calculator.isCalculationValid())
    }
    
    /// Test reset calculation
    func testGivenAddition_WhenResetCalculation_ThenArrayElementIsEmpty () {
        givenAddition()

        calculator.resetCalculation()

        XCTAssertTrue(calculator.arrayElement == [])
    }
    
    /// Test transform arrayElement to String
    func testGivenAddition_WhenFormatToText_ThenResultEqualArrayElementIsAddition () {
        givenAddition()

        result = calculator.arrayElement.joined(separator: " ")

        XCTAssertTrue(calculator.formatCalculToText() == result)
    }
    
    /// Test can start new calculation after equal
    func testGivenAddition_WhenAfterResultPressAnotherNumber_ThenArrayElemntCopntainsOneElement () {
        givenAddition()
        
        result = pressEqual()
        
        pressNumber(number: "3")
        
        XCTAssertTrue(calculator.arrayElement == ["3"])
    }

// MARK: - Private function

    /// Add number in arrayElement
    /// - Parameter number: number to insert
    private func pressNumber(number: String) {
            calculator.resetCalculationIfNeed()
            calculator.addNumber(number: number)
    }

    /// add operator in arrayElement
    /// - Parameter operatorCalculation: operator to insert
    private func pressOperator(operatorCalculation: String) {
        if  calculator.canAddOperator() {
            calculator.addOperator(newOperator: operatorCalculation)
        }
    }

    /// Launch calculation
    /// - Returns: result calculation
    private func pressEqual() -> String {
       guard calculator.isCalculationValid() else {
           return ""
        }
        return calculator.equal()
    }

    /// create addition
    private func givenAddition() {
        pressNumber(number: "3")
        pressNumber(number: "4")
        pressOperator(operatorCalculation: "+")
        pressNumber(number: "4")
        pressNumber(number: "4")
    }

    /// create division
    private func givenDivision() {
        pressNumber(number: "4")
        pressNumber(number: "6")
        pressOperator(operatorCalculation: "÷")
        pressNumber(number: "2")
    }

    /// create subtract
    private func givenSubtract() {
        pressNumber(number: "3")
        pressOperator(operatorCalculation: "-")
        pressNumber(number: "2")
    }

    /// create multiplication
    private func givenMultiplication() {
        pressNumber(number: "5")
        pressNumber(number: "0")
        pressOperator(operatorCalculation: "x")
        pressNumber(number: "2")
    }
}
