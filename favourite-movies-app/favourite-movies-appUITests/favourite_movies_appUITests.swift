//
//  favourite_movies_appUITests.swift
//  favourite-movies-appUITests
//
//  Created by Kapil Rathan on 4/19/18.
//  Copyright © 2018 Kapil Rathan. All rights reserved.
//

import XCTest

class favourite_movies_appUITests: XCTestCase {
        
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
    
    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
    }
    
    func testInputText(){
        
        let app = XCUIApplication()
        app.buttons["Find Movie"].tap()
        let searchTextField = app.textFields["searchTextField"]
        searchTextField.tap()
        searchTextField.typeText("star wars")
        
        app.buttons["Search"].tap()
        let searchtableTable = app.tables["searchTable"]
        searchtableTable.children(matching: .cell).element(boundBy: 0).buttons["Fav"].tap()
        app.navigationBars["Search Movies"].buttons["FAV Movies"].tap()
        
        
    }
    
    func testSearchMovieAddFavourite(){
        
        let app = XCUIApplication()
        app.buttons["Find Movie"].tap()
        let searchTextField = app.textFields["searchTextField"]
        searchTextField.tap()
        searchTextField.typeText("star wars")
        app.buttons["Search"].tap()
        
        let favButton = app.tables["searchTable"]/*@START_MENU_TOKEN@*/.buttons["Fav"]/*[[".cells.buttons[\"Fav\"]",".buttons[\"Fav\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        favButton.tap()
        favButton.tap()
        app.alerts["Favourites"].buttons["OK"].tap()
        app.navigationBars["Search Movies"].buttons["FAV Movies"].tap()
        
    }
}
