//
//  Phrases.swift
//  EMILYlingo
//
//  Created by Esteban Solis on 4/4/16.
//  Copyright © 2016 EMILYlingo. All rights reserved.
//

import UIKit

class Phrases: NSObject {
    var phraseName : String?
    var language : String?
    var time : String?
    var flag : String?
    var gender : String?
    
    init?(dictionary: NSDictionary){
        let name = dictionary["phraseName"] as? String
        if name != nil {
            phraseName = name
        }else{
            phraseName = "Esteban"
        }
        
        let lang = dictionary["language"] as? String
        if lang != nil {
            language = lang
        }else{
            language = "English"
        }
        
        let seconds = dictionary["time"] as? String
        if seconds != nil{
            time = seconds
        }else {
            time = "0"
        }
        // images
        let country = dictionary["flag"] as? String
        if country != nil{
            flag = country
        }else {
            flag = "0"
        }
        let sex = dictionary["gender"] as? String
        if sex != nil{
            gender = sex
        }else {
            gender = "Male"
        }
        
    }
    
    class func phrases(array array: [NSDictionary]) -> [Phrases] {
        var phrases = [Phrases]()
        for dictionary in array {
            let phrase = Phrases(dictionary: dictionary)
            phrases.append(phrase!)
        }
        return phrases
    }
    
    
}
