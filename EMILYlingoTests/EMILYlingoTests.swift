//
//  EMILYlingoTests.swift
//  EMILYlingoTests
//
//  Created by Esteban Solis on 3/31/16.
//  Copyright © 2016 EMILYlingo. All rights reserved.
//

import XCTest
@testable import EMILYlingo

class EMILYlingoTests: XCTestCase {
    var vc: ViewController!
    override func setUp() {
        super.setUp()
        
        //let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        //  vc = storyboard.instantiateInitialViewController() as! ViewController
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    //func testSize(){
    //func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string:String) -> Bool {
    //let maxLength = 16
    //let currentString: NSString = textField.text!
    //let newString: NSString = currentString.stringByReplacingCharactersInRange(range, withString: string)
    //return newString.length <= maxLength
    //}
    
    //let s = vs.textField(
    
    //}
    
    func testLabel(){
        let rand = String.random(8)
        let num = rand.characters.count
        XCTAssert(num == 8)
    }
    
    func testDefaultMetaData(){
        var dictionary: NSDictionary
        dictionary = [:]
        let phrases = Phrases(dictionary: dictionary)
        
        XCTAssertEqual(phrases.phraseName, "Esteban")
        XCTAssertEqual(phrases.language, "English")
        XCTAssertEqual(phrases.time, "0")
        XCTAssertEqual(phrases.flag, "0")
        XCTAssertEqual(phrases.gender, "Male")
        XCTAssertEqual(phrases.url, "/fkda/dfjiad")
    }
    
    func testCustomMetaData(){
        var dictionary: NSDictionary
        dictionary = ["phraseName": "Howdy", "language": "Texan", "time": "12", "flag": "Texas", "gender": "Male", "url": "/qwe/qwerty"]
        let phrases = Phrases(dictionary: dictionary)
        
        XCTAssertEqual(phrases.phraseName, "Howdy")
        XCTAssertEqual(phrases.language, "Texan")
        XCTAssertEqual(phrases.time, "12")
        XCTAssertEqual(phrases.flag, "Texas")
        XCTAssertEqual(phrases.gender, "Male")
        XCTAssertEqual(phrases.url, "/qwe/qwerty")
    }
    
    
}
