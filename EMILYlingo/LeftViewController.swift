//
//  LeftViewController.swift
//  EMILYlingo
//
//  Created by ali.anish91 on 4/13/16.
//  Copyright © 2016 EMILYlingo. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift
import RealmSwift

class LeftViewController: UIViewController {
    

    @IBOutlet weak var alphabeticallyButton: UIButton!
    @IBOutlet weak var byDateButton: UIButton!
    @IBOutlet weak var arabicButton: UIButton!
    @IBOutlet weak var englishButton: UIButton!
    @IBOutlet weak var spanishButton: UIButton!
    let realm = try! Realm()
    var phrases = [Phrases]()
    
    let defaults = NSUserDefaults.standardUserDefaults()
    let mySpecialNotificationKey = "changeData"
    
    var mainViewController: UIViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    func loadPhrases(){
        let ph = realm.objects(Phrases)
        
        phrases = Array(ph)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func changeEnglish(sender: AnyObject) {
        defaults.setObject("English", forKey: "Language")
        NSNotificationCenter.defaultCenter().postNotificationName(mySpecialNotificationKey, object: self)
        self.slideMenuController()?.closeLeft()
    }
    

    @IBAction func changeSpanish(sender: AnyObject) {
        defaults.setObject("Arabic", forKey: "Language")
        NSNotificationCenter.defaultCenter().postNotificationName(mySpecialNotificationKey, object: self)
        self.slideMenuController()?.closeLeft()
    }
    
    @IBAction func changeArabic(sender: AnyObject) {
        defaults.setObject("Greek", forKey: "Language")
        NSNotificationCenter.defaultCenter().postNotificationName(mySpecialNotificationKey, object: self)
        self.slideMenuController()?.closeLeft()
    }
    
    @IBAction func sortAlphabetically(sender: AnyObject) {
        defaults.setObject("Alphabetically", forKey: "Sorting")
        NSNotificationCenter.defaultCenter().postNotificationName(mySpecialNotificationKey, object: self)
        self.slideMenuController()?.closeLeft()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
