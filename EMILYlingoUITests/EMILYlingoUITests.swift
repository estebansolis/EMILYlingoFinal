//
//  EMILYlingoUITests.swift
//  EMILYlingoUITests
//
//  Created by Esteban Solis on 3/31/16.
//  Copyright © 2016 EMILYlingo. All rights reserved.
//

import XCTest

class EMILYlingoUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testRecord() {
        let app = XCUIApplication()
        
        sleep(2)
        
        //Lead to Recording screen
        let toRecordScreenButton = app.navigationBars["EMILYlingo.PhrasesView"].buttons["Item"]
        toRecordScreenButton.tap()
        
        //Start Recording, wait for 5 seconds
        sleep(2)
        let recordButtonStart = app.buttons["RecordOff"]
        recordButtonStart.tap()
        
        sleep(5)
        
        //Stop the Recording, leading to save screen
        let recordButtonStop = app.buttons["RecordingOn"]
        recordButtonStop.tap()
        sleep(2)
        
        //Once Recording is done, agree to save by 'Save' Button
        let agreeButton = app.childrenMatchingType(.Window).elementBoundByIndex(0).childrenMatchingType(.Other).element.childrenMatchingType(.Other).elementBoundByIndex(1).childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element
        agreeButton.tap()
        if(agreeButton.childrenMatchingType(.Button)["Save"].exists)
        {
            agreeButton.childrenMatchingType(.Button)["Save"].tap()
        }
        else if(agreeButton.childrenMatchingType(.Button)["abroar"].exists)
        {
            agreeButton.childrenMatchingType(.Button)["abroar"].tap()
        }
        
        sleep(2)
        
        let fieldBox = agreeButton.childrenMatchingType(.Other).elementBoundByIndex(1)
        fieldBox.childrenMatchingType(.TextField).elementBoundByIndex(0).tap()
        fieldBox.childrenMatchingType(.TextField).elementBoundByIndex(0).typeText("yoyoyo")
        
        let textField = fieldBox.childrenMatchingType(.TextField).elementBoundByIndex(1)
        app.buttons["👩"].tap()
        textField.tap()
        //textField.tap()
        fieldBox.childrenMatchingType(.TextField).elementBoundByIndex(1).typeText("Polish")
        //Debug fails to enter language.
        //app.buttons["👩"].tap()
        fieldBox.buttons["Save"].tap()
        
        sleep(2)
    }
    
    func testSwapLanguage() {
        
        let app = XCUIApplication()
        
        
        let buttonLanguage = app.navigationBars["EMILYlingo.PhrasesView"].childrenMatchingType(.Button).elementBoundByIndex(0)
        sleep(1)
        buttonLanguage.tap()
        app.buttons["English"].tap()
        sleep(1)
        buttonLanguage.tap()
        app.buttons["Spanish"].tap()
        sleep(1)
        buttonLanguage.tap()
        app.buttons["Arabic"].tap()
        sleep(1)
        buttonLanguage.tap()
        app.buttons["English"].tap()
        sleep(1)
    }
    
    func testRecordReject() {
        
        let app = XCUIApplication()
        
        //To Recording Screen
        app.navigationBars["EMILYlingo.PhrasesView"].buttons["Item"].tap()
        sleep(1)
        
        //Set Recording
        app.buttons["RecordOff"].tap()
        sleep(3)
        app.buttons["RecordingOn"].tap()
        
        //Choose to save
        let agreeButton = app.childrenMatchingType(.Window).elementBoundByIndex(0).childrenMatchingType(.Other).element.childrenMatchingType(.Other).elementBoundByIndex(1).childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element
        agreeButton.childrenMatchingType(.Button)["Save"].tap()
        sleep(1)
        
        //Reject and Head Back
        agreeButton.childrenMatchingType(.Other).elementBoundByIndex(1).buttons["Cancel"].tap()
        sleep(1)
        app.navigationBars["EMILYlingo.View"].buttons["-"].tap()
        sleep(2)
        
    }
    
    func testSetSort() {
        
        let app = XCUIApplication()
        let buttonSort = app.navigationBars["EMILYlingo.PhrasesView"].childrenMatchingType(.Button).elementBoundByIndex(0)
        sleep(2)
        buttonSort.tap()
        app.buttons["Alphabetically"].tap()
        sleep(2)
        buttonSort.tap()
        app.buttons["By Date"].tap()
        sleep(2)
        
    }

    
}
