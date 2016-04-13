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

    @IBOutlet weak var tableView: UITableView!
    var languages = ["English","Spanish","Arabic"]
    var mainViewController: UIViewController!
    override func viewDidLoad() {
        super.viewDidLoad()
        loadLanguages()
        tableView.reloadData()
        // Do any additional setup after loading the view.
    }

    func loadLanguages(){
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
