//
//  Phrases.swift
//  EMILYlingo
//
//  Created by Esteban Solis on 4/4/16.
//  Copyright © 2016 EMILYlingo. All rights reserved.
//

import UIKit
import RealmSwift

class Phrases: Object {
    dynamic var phraseName : String?
    dynamic var language : String?
    dynamic var time : String?
    dynamic var flag : String?
    dynamic var gender : String?
    dynamic var url: String?
    
    
     convenience init(dictionary: NSDictionary){
        self.init()
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
        let link = dictionary["url"] as? String
        if link != nil{
            url = link
        }else {
            url = "/fkda/dfjiad"
        }
    }
    
   /* required init() {
        fatalError("init() has not been implemented")
    }*/
    
    
     class func phrases(array array: [NSDictionary]) -> [Phrases] {
        var phrases = [Phrases]()
        for dictionary in array {
            let phrase = Phrases(dictionary: dictionary)
            phrases.append(phrase)
        }
        return phrases
    }
    
    
}
