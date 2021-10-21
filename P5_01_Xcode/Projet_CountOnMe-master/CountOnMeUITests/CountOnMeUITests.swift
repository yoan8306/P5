//
//  CountOnMeUITests.swift
//  CountOnMeUITests
//
//  Created by Yoan on 08/10/2021.
//  Copyright © 2021 Vincent Saluzzo. All rights reserved.
//

import XCTest

class CountOnMeUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGivenAddition_WhenPressEqual_ThenTextViewShowResult() {
        let app = XCUIApplication()
        let button1 = app.buttons["1"]
        let button2 = app.buttons["2"]

        app.launch()
        app.buttons["AC"].tap()
        button1.tap()
        button2.tap()
        app/*@START_MENU_TOKEN@*/.staticTexts["+"]/*[[".buttons[\"+\"].staticTexts[\"+\"]",".staticTexts[\"+\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app/*@START_MENU_TOKEN@*/.staticTexts["5"]/*[[".buttons[\"5\"].staticTexts[\"5\"]",".staticTexts[\"5\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()

        app/*@START_MENU_TOKEN@*/.staticTexts["="]/*[[".buttons[\"=\"].staticTexts[\"=\"]",".staticTexts[\"=\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()

        XCTAssertTrue((app.textViews.firstMatch.value as? String) == "12 + 5 = 17.0")
    }
}
