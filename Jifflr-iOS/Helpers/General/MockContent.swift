//
//  MockContent.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 16/02/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import UIKit
import Parse

class MockContent: NSObject {
    
    func createUser() -> PFUser {
        let user = PFUser()
        user.username = "james.shaw@thedistance.co.uk"
        user.email = "james.shaw@thedistance.co.uk"
        user.password = "testtest"
        user.details = self.createUserDetails()

        return user
    }

    func createLocationStatus() -> LocationStatus {
        let locationStatus = LocationStatus()
        locationStatus.name = "Active"
        locationStatus.type = 1

        return locationStatus
    }

    func createLocation() -> Location {
        let location = Location()
        location.isoCountryCode = "GB"
        location.name = "United Kingdom"
        location.locationStatus = self.createLocationStatus()

        return location
    }

    func createUserDetails() -> UserDetails {

        let userDetails = UserDetails()
        userDetails.firstName = "James"
        userDetails.lastName = "Shaw"
        userDetails.dateOfBirth = Date()
        userDetails.gender = "Male"
        userDetails.emailVerified = false
        userDetails.location = self.createLocation()
        userDetails.geoPoint = PFGeoPoint(latitude: 51.1, longitude: -0.87)
        userDetails.displayLocation = "York, United Kingdom"
        userDetails.invitationCode = "UiuIIsdf"

        return userDetails
    }

    func createGraphData() -> [Graph] {
        return [self.createGraphPoint(x: 0.0, y: 0.0),
                self.createGraphPoint(x: 10.0, y: 7.0),
                self.createGraphPoint(x: 20.0, y: 26.0),
                self.createGraphPoint(x: 30.0, y: 34.0),
                self.createGraphPoint(x: 40.0, y: 50.0),
                self.createGraphPoint(x: 50.0, y: 55.0),
                self.createGraphPoint(x: 60.0, y: 55.0),
                self.createGraphPoint(x: 70.0, y: 75.0),
                self.createGraphPoint(x: 80.0, y: 81.0),
                self.createGraphPoint(x: 90.0, y: 101.0),
                self.createGraphPoint(x: 100.0, y: 110.0),
                self.createGraphPoint(x: 110.0, y: 132.0),
                self.createGraphPoint(x: 120.0, y: 141.0),
                self.createGraphPoint(x: 130.0, y: 142.0),
                self.createGraphPoint(x: 140.0, y: 156.0),
                self.createGraphPoint(x: 150.0, y: 181.0),
                self.createGraphPoint(x: 160.0, y: 182.0),
                self.createGraphPoint(x: 170.0, y: 190.0),
                self.createGraphPoint(x: 180.0, y: 201.0),
                self.createGraphPoint(x: 190.0, y: 205.0),
                self.createGraphPoint(x: 200.0, y: 220.0)]
    }

    func createTargetGraphData() -> [Graph] {
        return [self.createGraphPoint(x: 0.0, y: 0.0),
                self.createGraphPoint(x: 10.0, y: 10.0),
                self.createGraphPoint(x: 20.0, y: 20.0),
                self.createGraphPoint(x: 30.0, y: 30.0),
                self.createGraphPoint(x: 40.0, y: 40.0),
                self.createGraphPoint(x: 50.0, y: 50.0),
                self.createGraphPoint(x: 60.0, y: 60.0),
                self.createGraphPoint(x: 70.0, y: 70.0),
                self.createGraphPoint(x: 80.0, y: 80.0),
                self.createGraphPoint(x: 90.0, y: 90.0),
                self.createGraphPoint(x: 100.0, y: 100.0),
                self.createGraphPoint(x: 110.0, y: 110.0),
                self.createGraphPoint(x: 120.0, y: 120.0),
                self.createGraphPoint(x: 130.0, y: 130.0),
                self.createGraphPoint(x: 140.0, y: 140.0),
                self.createGraphPoint(x: 150.0, y: 150.0),
                self.createGraphPoint(x: 160.0, y: 160.0),
                self.createGraphPoint(x: 170.0, y: 170.0),
                self.createGraphPoint(x: 180.0, y: 180.0),
                self.createGraphPoint(x: 190.0, y: 190.0),
                self.createGraphPoint(x: 200.0, y: 200.0)]
    }

    func createGraphPoint(x: Double, y: Double) -> Graph {
        let point = Graph()
        point.x = x
        point.y = y
        return point
    }

    func createPendingUser() -> PendingUser {
        let pendingUser = PendingUser()
        pendingUser.email = "bob@smith.com"
        pendingUser.sender = self.createUser()
        pendingUser.name = "Bob Smith"
        pendingUser.isSignedUp = false

        return pendingUser
    }

    func createMyTeamJSON() -> [String: Any]? {
        var myTeamJSON:[String: Any] = [:]
        myTeamJSON["graph"] = self.createGraphData()
        myTeamJSON["teamSize"] = 1000
        myTeamJSON["friends"] = [(self.createUser(), 10), (self.createUser(), 54), (self.createUser(), 56)]
        myTeamJSON["pendingFriends"] = [(self.createPendingUser(), true), (self.createPendingUser(), false), (self.createPendingUser(), true)]

        return myTeamJSON
    }

    func createDefaultAdvert() -> Advert {
        let advert = Advert()
        advert.isCMS = false
        return advert
    }

    func createQuestionType() -> QuestionType {
        let questionType = QuestionType()
        questionType.type = AdvertQuestionType.Swipe
        questionType.name = "Swipe"
        return questionType
    }

    func createQuestion() -> Question {
        let question = Question()
        question.active = true
        question.type = self.createQuestionType()
        question.text = "Do you like Fish and Chips?"
        return question
    }
}
