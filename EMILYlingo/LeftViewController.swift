//
//  LeftViewController.swift
//  EMILYlingo
//
//  Created by ali.anish91 on 4/13/16.
//  Copyright © 2016 EMILYlingo. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift

class LeftViewController: UIViewController {
    

    @IBOutlet weak var arabicButton: UIButton!
    @IBOutlet weak var englishButton: UIButton!
    @IBOutlet weak var spanishButton: UIButton!
    
    let defaults = NSUserDefaults.standardUserDefaults()

    var mainViewController: UIViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func changeEnglish(sender: AnyObject) {
        defaults.setObject("English", forKey: "Language")
    }
    

    @IBAction func changeSpanish(sender: AnyObject) {
        defaults.setObject("Spanish", forKey: "Language")
    }
    
    @IBAction func changeArabic(sender: AnyObject) {
        defaults.setObject("Arabic", forKey: "Language")
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
