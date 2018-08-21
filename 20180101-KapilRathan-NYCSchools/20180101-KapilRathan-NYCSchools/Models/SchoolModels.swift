//
//  school.swift
//  20180101-KapilRathan-NYCSchools
//
//  Created by Kapil Rathan on 8/19/18.
//  Copyright © 2018 Kapil Rathan. All rights reserved.
//

import Foundation

    // MARK: - Schools Model

public struct Schools: Codable{
    public var schools: [School]?
    func getSchoolfromDBN(dbn: String) -> School?{
        guard let schools = schools else {
            return nil
        }
        for school in schools {
            if school.dbn == dbn{
                return school
            }
        }
        return nil
    }
    
    subscript(index: Int) -> School? {
        get {
            guard let schools = schools else {
                return nil
            }
            return schools[index]
        }
    }
}
public struct School: Codable{
    public let school_name: String
    public let primary_address_line_1: String
    public let city: String
    public let state_code: String
    public let zip: String
    public let dbn: String
}

    // MARK: - SchoolDescriptions Model

public struct SchoolDescriptions: Codable{
    public var schoolsDescriptions: [SchoolDescription]?
    func getSchoolDescriptionfromDBN(dbn: String) -> SchoolDescription?{
        guard let schoolsDescriptions = schoolsDescriptions else {
            return nil
        }
        for schoolDesc in schoolsDescriptions {
            if schoolDesc.dbn == dbn{
                return schoolDesc
            }
        }
        return nil
    }
}

public struct SchoolDescription: Codable{
    public var sat_critical_reading_avg_score: String
    public var sat_math_avg_score: String
    public var sat_writing_avg_score: String
    public var school_name: String
    public var dbn: String
}
