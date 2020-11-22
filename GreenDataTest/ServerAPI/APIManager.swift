//
//  PersonCell.swift
//  GreenDataTest
//
//  Created by yaruncle on 06.11.2020.
//  Copyright © 2020 yaruncle. All rights reserved.
//

import UIKit

class APIManager {
    static let shared = APIManager() // shared instance
    private init() {} // Prevent creation (Thread safe)
    
    private var seed = "" // seed value for pagination (If seed changes, content changes)
    private var onRequest = false // bool value that indicates communication status
    
    private var genderFilter = ""
    private var nationalitiesFilter = ""
    
    func getUsersList(pageNo : UInt, itemCnt : UInt,
        onSuccess : @escaping ((Array<Person>)->Void), onFail : @escaping ((Error)->Void)) {
        self.onRequest = true
        
        // make request query string
        var queries = Dictionary<String, String>()
        
        // add default values
        queries[PARAM_PAGE] = String(pageNo)
        queries[PARAM_ITEM_PER_PAGE] = String(itemCnt)
        
        // add seed if exists
        if(!seed.isEmpty) {
            queries[PARAM_SEED] = seed
        }
        
        // Append filter settings
        if(!genderFilter.isEmpty) {
            queries[PARAM_FILTER_GENDER] = genderFilter
        }
        if(!nationalitiesFilter.isEmpty) {
            queries[PARAM_FILTER_NATIONALITY] = nationalitiesFilter
        }
        
        // make request object
        var request = URLRequest(url: makeRequestURL(url: BASE_URL, query: makeQuery(dict: queries)))
        request.httpMethod = "GET"
        
        // and make data task
        let task = URLSession.shared.dataTask(with: request) { (data, resp, err) in
            if(err != nil) {
                DispatchQueue.main.async {  // call delegate in main queue
                    self.onRequest = false
                    onFail(err!)
                }
            } else {
                do {
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as! JsonObj
                    self.seed = (result["info"] as! JsonObj)["seed"] as? String ?? ""
                    self.onRequest = false
                    
                    DispatchQueue.main.async { // call delegate in main queue
                        onSuccess((result["results"] as! Array<JsonObj>).map {
                            Person(dict: $0)
                        })
                    }
                }
                catch let err {
                    DispatchQueue.main.async {  // call delegate in main queue
                        self.onRequest = false
                        onFail(err)
                    }
                }
            }
        }
        
        // start task if it's not started
        task.resume()
    }
    
    private func makeQuery(dict : Dictionary<String, String>) -> String {
        return dict.reduce("") {
            return $0 + "\($1.key)=\($1.value)&"
        }
    }
    
    private func makeRequestURL(url : String, query : String) -> URL {
        return URL(string: url + "?" + query)!
    }
    
    func resetSeed() { // Reset seed for new content
        seed = ""
    }
    
    func isOnRequest() -> Bool { // Check is processing a request
        return onRequest
    }
    
    func setGenderFilter(gender : Gender) {
        switch gender {
        case .male:
            genderFilter = "male"
        
        case .female:
            genderFilter = "female"
            
        case .other:
            genderFilter = ""
        }
    }
    
    func setNationalitiesFilter(nationalities : Array<String>) {
        nationalitiesFilter = nationalities.reduce(""){return $0 + "\($1),"}
    }
    
    func resetAllFilter() {
        nationalitiesFilter = ""
        genderFilter = ""
    }
    
    func getSupportedNationalities() -> [String] { // will return supported countries list
        let countries = "AU, BR, CA, CH, DE, DK, ES, FI, FR, GB, IE, IR, NO, NL, NZ, TR, US"
        return countries.components(separatedBy: ", ")
    }
}
