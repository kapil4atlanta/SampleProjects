//
//  SportsDataManager.swift
//  20180101-KapilRathan-NYCSchools
//
//  Created by Kapil Rathan on 8/21/18.
//  Copyright © 2018 Kapil Rathan. All rights reserved.
//

import Foundation

enum Urls:String {
    case schoolListDataHost = "https://data.cityofnewyork.us/resource/97mf-9njv.json"
    case schoolDetailsDataHost = "https://data.cityofnewyork.us/resource/734v-jeq5.json"
}

class SchoolDataManager {
    
    public static let shared = SchoolDataManager()
    
    private var schoolDetailsObject = SchoolDescriptions()
    private var schoolListObject = Schools()
    
    fileprivate init(){
    }
    
    public func getSchoolListObject() -> Schools?{
        if self.schoolListObject.schools != nil{
            return self.schoolListObject
        }
        return nil
    }
    
    public func getSchoolDetailsObject() -> SchoolDescriptions?{
        if self.schoolDetailsObject.schoolsDescriptions != nil{
            return self.schoolDetailsObject
        }
        return nil
    }
    
    // MARK: - Get API Data
    
    public func getSchoolListData(completion: @escaping (Bool) -> Void){
        
        //Fetch All Schedules
        
        HttpHandler.HttpHandlerMakeRequest(urlString: Urls.schoolListDataHost.rawValue) { [weak self] (data, error) in
            guard let strongSelf = self, let data = data else {
                completion(false)
                return
            }
            
            if error != nil{
                completion(false)
            }
            else{
                do{
                    let decoder = JSONDecoder()
                    let schools = try decoder.decode([School].self, from: data)
                    strongSelf.schoolListObject.schools = schools
                    completion(true)
                }catch let error{
                    completion(false)
                    print (error.localizedDescription)
                }
            }
        }
        
    }
    
    public func getSchoolDetails(completion: @escaping (Bool) -> Void){
        
        HttpHandler.HttpHandlerMakeRequest(urlString: Urls.schoolDetailsDataHost.rawValue) { [weak self] (data, error) in
            guard let strongSelf = self, let data = data else {
                completion(false)
                return
            }
            
            if error == nil{
                do {
                    let decoder = JSONDecoder()
                    let json = try decoder.decode([SchoolDescription].self, from: data)
                    strongSelf.schoolDetailsObject.schoolsDescriptions = json
                    completion(true)
                    
                }catch let error{
                    print (error.localizedDescription)
                }
                
            }else{
                completion(false)
            }
        }
    }
    
}
