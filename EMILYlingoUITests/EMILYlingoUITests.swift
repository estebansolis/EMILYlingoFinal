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
        
        //To Recording Screen
        app.navigationBars["EMILYlingo"].buttons["wave icon"].tap()
        app.buttons["RecordOff"].tap()
        sleep(5)
        app.buttons["RecordingOn"].tap()
        sleep(2)
        
        //Agree on Recording
        let element = app.childrenMatchingType(.Window).elementBoundByIndex(0).childrenMatchingType(.Other).element.childrenMatchingType(.Other).elementBoundByIndex(1).childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element
        
        if(element.childrenMatchingType(.Button)["Save"].exists)
        {
            element.childrenMatchingType(.Button)["Save"].tap()
        }
        else if(element.childrenMatchingType(.Button)["αποθηκεύσετε"].exists)
        {
            element.childrenMatchingType(.Button)["αποθηκεύσετε"].tap()
        }
        else if(element.childrenMatchingType(.Button)["Kaydet"].exists)
        {
            element.childrenMatchingType(.Button)["Kaydet"].tap()
        }
        
        //Fill Meta-Data
        let element2 = element.childrenMatchingType(.Other).elementBoundByIndex(1)
        element2.childrenMatchingType(.TextField).elementBoundByIndex(0).tap()
        element2.childrenMatchingType(.TextField).elementBoundByIndex(0).typeText("Please Sit Down")
        let textField = element2.childrenMatchingType(.TextField).elementBoundByIndex(1)
        textField.tap()
        element2.childrenMatchingType(.TextField).elementBoundByIndex(1).typeText("Arabic")
        app.buttons["👱"].tap()
        
        //Save
        if(element2.buttons["Save"].exists)
        {
            element2.buttons["Save"].tap()
        }
        else if(element2.buttons["αποθηκεύσετε"].exists)
        {
            element2.buttons["αποθηκεύσετε"].tap()
        }
        else if(element2.buttons["Kaydet"].exists)
        {
            element2.buttons["Kaydet"].tap()
        }
        
    }
    
    func testLangSwap(){
        
        let app = XCUIApplication()
        let settingsIconButton = app.navigationBars["EMILYlingo"].buttons["settings icon"]
        settingsIconButton.tap()
        app.buttons["English"].tap()
        settingsIconButton.tap()
        app.buttons["Turkish"].tap()
        settingsIconButton.tap()
        app.buttons["Greek"].tap()
        
    }
    
    func testCancelRecording(){
        
        let app = XCUIApplication()
        
        //To Recording Page
        app.navigationBars["EMILYlingo"].buttons["wave icon"].tap()
        
        app.buttons["RecordOff"].tap()
        sleep(2)
        app.buttons["RecordingOn"].tap()
        
        //Agree to Recording
        let element = app.childrenMatchingType(.Window).elementBoundByIndex(0).childrenMatchingType(.Other).element.childrenMatchingType(.Other).elementBoundByIndex(1).childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element
        if(element.childrenMatchingType(.Button)["Save"].exists)
        {
            element.childrenMatchingType(.Button)["Save"].tap()
        }
        else if(element.childrenMatchingType(.Button)["αποθηκεύσετε"].exists)
        {
            element.childrenMatchingType(.Button)["αποθηκεύσετε"].tap()
        }
        else if(element.childrenMatchingType(.Button)["Kaydet"].exists)
        {
            element.childrenMatchingType(.Button)["Kaydet"].tap()
        }
        
        //Changed Mind lol
        if(element.childrenMatchingType(.Other).elementBoundByIndex(1).buttons["ματαίωση"].exists)
        {
            element.childrenMatchingType(.Other).elementBoundByIndex(1).buttons["ματαίωση"].tap()
        }
        else if(element.childrenMatchingType(.Other).elementBoundByIndex(1).buttons["Iptal"].exists)
        {
            element.childrenMatchingType(.Other).elementBoundByIndex(1).buttons["Iptal"].tap()
        }
        else if(element.childrenMatchingType(.Other).elementBoundByIndex(1).buttons["Cancel"].exists)
        {
            element.childrenMatchingType(.Other).elementBoundByIndex(1).buttons["Cancel"].tap()
        }
        
        app.navigationBars["EMILYlingo.View"].buttons["list button"].tap()
        
        sleep(3)
        
    }
    
    
    func testPlayandPause(){
        let staticText = XCUIApplication().tables.staticTexts["Please Sit Down"]
        let playButtonButton = XCUIApplication().buttons["play button"]
        staticText.tap()
        sleep(1)
        playButtonButton.tap()
        sleep(1)
        playButtonButton.tap()
        sleep(5)
    }
    
    func testSearch(){
        //Run testRecording Before Running This
        let app = XCUIApplication()
        
        if(app.searchFields["Έρευνα"].exists)
        {
            app.searchFields["Έρευνα"].tap()
            app.searchFields["Έρευνα"].typeText("Please")
        }
        else if(app.searchFields["Search"].exists)
        {
            app.searchFields["Search"].tap()
            app.searchFields["Search"].typeText("Please")
        }
        else if(app.searchFields["Arama"].exists)
        {
            app.searchFields["Arama"].tap()
            app.searchFields["Arama"].typeText("Please")
        }
        app.tables.staticTexts["Please Sit Down"].tap()
        sleep(7)
    }
    
    
    
}
