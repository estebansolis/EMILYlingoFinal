//
//  PhrasesViewController.swift
//  EMILYlingo
//
//  Created by Esteban Solis on 4/4/16.
//  Copyright © 2016 EMILYlingo. All rights reserved.
//

import UIKit
import RealmSwift
import AVFoundation
import SlideMenuControllerSwift

class PhrasesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    var phrases = [Phrases]()
    @IBOutlet weak var tableView: UITableView!
    var dictionary: [String:String]!
    var phrase: Phrases!
    var audioPlayer: AVAudioPlayer?
    let realm = try! Realm()
    var soundFileURL: NSURL!
    var count = 1
    var sound: AVAudioPlayer?
    var index: Int!
    
    var searchActive : Bool = false
    var filtered:[Phrases] = []
    
    @IBOutlet weak var searchPhraseBar: UISearchBar!
    @IBOutlet weak var phraseLabel: UILabel!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var rewindButton: UIButton!
    @IBOutlet weak var forwardButton: UIButton!
    @IBOutlet weak var progress: UIProgressView!
    @IBOutlet weak var totalDuration: UILabel!
    @IBOutlet weak var currentTimer: UILabel!
    @IBOutlet weak var emojiLabel: UILabel!
    
    @IBOutlet weak var saveEditButton: UIButton!
    @IBOutlet weak var cancelEditButton: UIButton!
    @IBOutlet weak var nameEditLabel: UILabel!
    @IBOutlet weak var languageEditLabel: UILabel!
    @IBOutlet weak var genderEditLabel: UILabel!
    @IBOutlet weak var nameEditField: UITextField!
    @IBOutlet weak var languageEditField: UITextField!
    
    @IBOutlet weak var genderEditSegment: UISegmentedControl!
    
    @IBOutlet weak var editView: UIView!
    
    @IBOutlet weak var volumeSlider: UISlider!
    var Name: String?
    var language: String?
    var gender: String?
    var editUrl: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        tap.cancelsTouchesInView = false
        navigationController!.navigationBar.barTintColor = UIColor(red:  240/255.0, green: 128/255.0, blue: 128/255.0, alpha: 100.0/100.0)
        editView.hidden = true
        //volumeSlider.frame = CGRect(x: 9, y: 36, width: 305, height: 1)
        self.volumeSlider.setThumbImage(UIImage(named: "slider"), forState: UIControlState.Normal)
        let defaults = NSUserDefaults.standardUserDefaults()
        if let language = defaults.stringForKey("Language"){
            if(language == "English"){
               searchPhraseBar.placeholder = "Search"
            }
            if(language == "Turkish"){
                searchPhraseBar.placeholder = "Arama"
                
            }
            if(language == "Greek"){
                searchPhraseBar.placeholder = "Έρευνα"
            }
        }
        tableView.delegate = self
        tableView.dataSource = self
        tableView.sectionHeaderHeight = 0
        searchPhraseBar.delegate = self
//        dictionary["phraseName"] = "Sit Down"
//        dictionary["language"] = "Arabic"
//        dictionary["time"] = "5"
//        dictionary["flag"] = "usflag"
//        dictionary["gender"] = "male"
//        phrases.append(Phrases(dictionary: dictionary)!)
        
       
        loadPhrases()
        //sorting()
        tableView.reloadData()
        // Do any additional setup after loading the view.
    }

    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    func sorting(){
        let defaults = NSUserDefaults.standardUserDefaults()
        if let sort = defaults.stringForKey("Sorting"){
            if(sort == "By Date"){
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "MM:dd:hh:mm"
              //  let date = dateFormatter.dateFromString()
                phrases.sortInPlace({dateFormatter.dateFromString($0.currentDate!)!.compare(dateFormatter.dateFromString($1.currentDate!)!) == .OrderedDescending })
               // tableView.reloadData();
            }
            if(sort == "Alphabetically"){
                phrases.sortInPlace({ $0.phraseName < $1.phraseName })
               // tableView.reloadData();
            }
        }
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBarItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sliderMenu(sender: AnyObject) {
        self.slideMenuController()?.openRight()
    }
    func loadPhrases(){
        // query realm and add it to our phrase array to view 
        let ph = realm.objects(Phrases)
        
        phrases = Array(ph)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searchActive){
            return filtered.count
        }
        return phrases.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PhrasesCell", forIndexPath: indexPath) as! PhrasesCell
        if(searchActive){
            cell.phrase = filtered[indexPath.row]
        }else {
            sorting()
            cell.phrase = phrases[indexPath.row]
        }
        
        //let defaults = NSUserDefaults.standardUserDefaults()
        /*if let sort = defaults.stringForKey("Sorting"){
            if(sort == "By Date"){
                phrases = phrases.reverse()
//                tableView.reloadData();
            }
            if(sort == "Alphabetically"){
                phrases.sortInPlace({ $1.phraseName > $0.phraseName })
                //tableView.reloadData();
            }
        }*/
        //cell.phrase = phrases[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var selectedCell:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        let row = indexPath.row;
        let cell = phrases[row]
        let toAppendString = cell.url!
        let label = cell.phraseName!
        let duration = cell.time!
        index = indexPath.row
        let documentsDirectory = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
        soundFileURL = documentsDirectory.URLByAppendingPathComponent(toAppendString)
        do {
            phraseLabel.text = label
//            duration = Int((sound?.duration)!)
//            if Int((sound?.duration)!) > 10 {
//                totalDuration.text = "0:"+duration
//            }else{
//                totalDuration.text = "0:0"+duration
//            }
            selectedCell.contentView.backgroundColor = UIColor(red:  245/255.0, green: 183/255.0, blue: 177/255.0, alpha: 100.0/100.0)
            totalDuration.text = duration
            sound = try AVAudioPlayer(contentsOfURL: soundFileURL)
            audioPlayer = sound
            sound!.play()
            NSTimer.scheduledTimerWithTimeInterval(0.001, target: self, selector: #selector(PhrasesViewController.updateAudioProgressView), userInfo: nil, repeats: true)
            // sound.pause()
            let image = UIImage(named: "pause-button.png")
            playPauseButton.setImage(image, forState: .Normal)
            count = 1
            
        } catch let error as NSError {
            print(error)
        }
    }
    
     func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
 
    }
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]?  {
        var editAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Edit" , handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            let row = indexPath.row
            let cell = self.phrases[row]
            self.editUrl = cell.url!
            self.editView.hidden = false
      
     

    })
        var deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Delete" , handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            let row = indexPath.row
            let cell = self.phrases[row]
            self.phrases.removeAtIndex(row)
            try! self.realm.write {
                self.realm.delete(cell)
            }
            tableView.reloadData()
            
        })
    
        return [editAction,deleteAction]
    }
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchActive = true
    }
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchActive = false
    }
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchActive = false
    }
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchActive = false
    }
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String){
        filtered = phrases.filter({ (text) -> Bool in
            let tmp: NSString = String(text)
            let range = tmp.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
            return range.location != NSNotFound
        })
        if(filtered.count == 0){
            searchActive = false
        }else {
            searchActive = true
        }
        self.tableView.reloadData()
    }
    
    
    
    @IBAction func playButtonAction(sender: AnyObject) {
        if(count == 1){
            if((sound?.play()) != nil)
            {
                count = 2
                let image = UIImage(named: "play-button.png")
                sound!.pause()
                playPauseButton.setImage(image, forState: .Normal)
            }
        }
        else{
            if((sound?.play()) != nil)
            {
                count = 1
                let image = UIImage(named: "pause-button.png")
                sound!.play()
                playPauseButton.setImage(image, forState: .Normal)
            }
        }
    }

    func updateAudioProgressView(){
        if ((audioPlayer?.playing) != nil) {
            if (Int((sound?.currentTime)!)) < 10 {
                currentTimer.text = "0:0"+String(Int((sound?.currentTime)!))
            }else {
                currentTimer.text = "0:"+String(Int((sound?.currentTime)!))
            }
            progress.setProgress(Float((sound?.currentTime)!/(sound?.duration)!), animated: true)
        }
    }
    
    @IBAction func editButton(sender: AnyObject) {
        editView.hidden = false
        self.view.endEditing(true)
    }
    

    @IBAction func cancelActionButton(sender: AnyObject) {
        editView.hidden = true
        self.view.endEditing(true)
    }
    

    @IBAction func saveActionButton(sender: AnyObject) {
        self.Name = self.nameEditField.text
        self.language = self.languageEditField.text
        switch self.genderEditSegment.selectedSegmentIndex
        {
        case 0:
            self.gender = "male"
        case 1:
            self.gender = "female"
        default:
            break;
        }
        let url = editUrl!
        dispatch_async(dispatch_queue_create("background", nil)) {
            let realm = try! Realm()
            let predicate = NSPredicate(format: "url BEGINSWITH %@", url)
            let thePhrase = realm.objects(Phrases).filter(predicate).first
                try! realm.write {
                   thePhrase!.phraseName = self.Name
                   thePhrase!.language = self.language
                   thePhrase!.gender = self.gender
                }
            //self.tableView.reloadData()

        }
        editView.hidden = true
    
    }
    
    @IBAction func forwardAction(sender: AnyObject) {
        if(index+1 == phrases.count+1){
        let cell = phrases[index+1]
        index = index+1
        let toAppendString = cell.url!
        let label = cell.phraseName!
        let duration = cell.time!
        let documentsDirectory = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
        soundFileURL = documentsDirectory.URLByAppendingPathComponent(toAppendString)
        do {
            phraseLabel.text = label
            //            duration = Int((sound?.duration)!)
            //            if Int((sound?.duration)!) > 10 {
            //                totalDuration.text = "0:"+duration
            //            }else{
            //                totalDuration.text = "0:0"+duration
            //            }
            totalDuration.text = duration
            sound = try AVAudioPlayer(contentsOfURL: soundFileURL)
            audioPlayer = sound
            sound!.play()
            NSTimer.scheduledTimerWithTimeInterval(0.001, target: self, selector: #selector(PhrasesViewController.updateAudioProgressView), userInfo: nil, repeats: true)
            // sound.pause()
            
        } catch let error as NSError {
            print(error)
        }
        }
        
        
    }
    
    @IBAction func volume(sender: AnyObject) {
        audioPlayer?.volume = sender.value
    }
    
    @IBAction func rewindAction(sender: AnyObject) {
        if(index-1 == 0){
            print ("this is index \(index)")
        let cell = phrases[index-1]
        index = index-1
        let toAppendString = cell.url!
        let label = cell.phraseName!
        let duration = cell.time!
        let documentsDirectory = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
        soundFileURL = documentsDirectory.URLByAppendingPathComponent(toAppendString)
        do {
            phraseLabel.text = label
            //            duration = Int((sound?.duration)!)
            //            if Int((sound?.duration)!) > 10 {
            //                totalDuration.text = "0:"+duration
            //            }else{
            //                totalDuration.text = "0:0"+duration
            //            }
            totalDuration.text = duration
            sound = try AVAudioPlayer(contentsOfURL: soundFileURL)
            audioPlayer = sound
            sound!.play()
            NSTimer.scheduledTimerWithTimeInterval(0.001, target: self, selector: #selector(PhrasesViewController.updateAudioProgressView), userInfo: nil, repeats: true)
            // sound.pause()
            
        } catch let error as NSError {
            print(error)
        }
        }

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
