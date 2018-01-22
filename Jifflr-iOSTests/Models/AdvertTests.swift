//
//  AdvertTests.swift
//  Ad-M8-iOSTests
//
//  Created by James Shaw on 31/10/2017.
//  Copyright © 2017 The Distance. All rights reserved.
//

import XCTest
import Parse
@testable import Ad_M8_iOS

class AdvertTests: XCTestCase {

    var advert: Advert!
    var feedbackType: FeedbackType!
    var feedbackQuestion: FeedbackQuestion!
    
    override func setUp() {
        super.setUp()

        self.feedbackType = FeedbackType()

        self.feedbackQuestion = FeedbackQuestion()
        self.feedbackQuestion.question = "What is your name?"

        self.advert = Advert()
        self.advert.feedbackType = self.feedbackType
        self.advert.feedbackQuestion = self.feedbackQuestion
    }
    
    override func tearDown() {
        self.advert = nil
        self.feedbackType = nil
        self.feedbackQuestion = nil

        super.tearDown()
    }

    func testAdvertGetters() {
        XCTAssertEqual(self.advert.feedbackQuestion, self.feedbackQuestion)
        XCTAssertEqual(self.advert.feedbackType, self.feedbackType)
    }

    func testFeedbackQuestionGetters() {
        XCTAssertEqual(self.feedbackQuestion.question, "What is your name?")
    }
}
