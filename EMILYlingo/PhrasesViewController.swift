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

class PhrasesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
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
    var indexPathToInt: NSIndexPath!
    
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
    let mySpecialNotificationKey = "changeData"
    
    var languages = ["English", "Greek", "Arabic"]
    var picker = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        picker.delegate = self
        picker.dataSource = self
        languageEditField.inputView = picker
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, withOptions: AVAudioSessionCategoryOptions.DefaultToSpeaker)
        
        tap.cancelsTouchesInView = false
        navigationController!.navigationBar.barTintColor = UIColor(red:  240/255.0, green: 128/255.0, blue: 128/255.0, alpha: 100.0/100.0)
        editView.hidden = true
        self.volumeSlider.setThumbImage(UIImage(named: "slider"), forState: UIControlState.Normal)
        searchPhraseBar.delegate = self
        let defaults = NSUserDefaults.standardUserDefaults()
        if let language = defaults.stringForKey("Language"){
            if(language == "English"){
               searchPhraseBar.placeholder = "Search"
            }
            if(language == "Arabic"){
                searchPhraseBar.placeholder = "Arama"
                
            }
            if(language == "Greek"){
                searchPhraseBar.placeholder = "Έρευνα"
            }
        }
        tableView.delegate = self
        tableView.dataSource = self
        tableView.sectionHeaderHeight = 0
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadData", name: mySpecialNotificationKey, object: nil)

       
        loadPhrases()
        tableView.reloadData()
    }
    
    // returns the number of 'columns' to display.
    
    internal func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int{
        return 1
    }
    
    // returns the # of rows in each component..
    
    internal func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return languages.count
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        languageEditField.text = languages[row]
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return languages[row]
    }
    


    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func reloadData(){
        tableView.reloadData()
        viewDidLoad()
        
        
    }
    
    func sorting(){
        let defaults = NSUserDefaults.standardUserDefaults()
        if let sort = defaults.stringForKey("Sorting"){
            if(sort == "Alphabetically"){
                phrases.sortInPlace({ $0.phraseName < $1.phraseName })
            }
        }
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        searchPhraseBar.delegate = self
        self.setNavigationBarItem()
    }

    
    @IBAction func sliderMenu(sender: AnyObject) {
        self.slideMenuController()?.openRight()
    }
    func loadPhrases(){
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
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedCell:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        let row = indexPath.row;
        indexPathToInt = indexPath
        let cell = phrases[row]
        let toAppendString = cell.url!
        let label = cell.phraseName!
        let duration = cell.time!
        index = indexPath.row
        let documentsDirectory = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
        soundFileURL = documentsDirectory.URLByAppendingPathComponent(toAppendString)
        do {
            phraseLabel.text = label
            selectedCell.contentView.backgroundColor = UIColor(red:  232/255.0, green: 161/255.0, blue: 161/255.0, alpha: 100.0/100.0)
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
    
        editAction.backgroundColor = UIColor.grayColor()
        return [deleteAction,editAction]
    }
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchActive = true
    }
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchBar.text = "";
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
                if(CGFloat((sound?.currentTime)!) > 0){
                count = 2
                let image = UIImage(named: "play-button.png")
                sound!.pause()
                playPauseButton.setImage(image, forState: .Normal)
                }
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
            if(((Int((sound?.currentTime)!)) < 10) && (CGFloat((sound?.currentTime)!)) > 0){
                if(count == 1){
                let image = UIImage(named: "pause-button.png")
                playPauseButton.setImage(image, forState: .Normal)
                currentTimer.text = "0:0"+String(Int((sound?.currentTime)!))
                }
                
            }else if(sound?.currentTime == 0){
                let image = UIImage(named: "play-button.png")
                playPauseButton.setImage(image, forState: .Normal)
                currentTimer.text = "0:0"+String(Int((sound?.currentTime)!))
            }
            else {
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
        self.nameEditField.text = ""
        self.languageEditField.text = ""
        self.view.endEditing(true)
    }
    

    @IBAction func saveActionButton(sender: AnyObject) {
        self.Name = self.nameEditField.text
        self.language = self.languageEditField.text
        switch self.genderEditSegment.selectedSegmentIndex
        {
        case 0:
            self.gender = "👱"
        case 1:
            self.gender = "👩"
        default:
            break;
        }
        let url = editUrl!
        dispatch_async(dispatch_get_main_queue()) {
            let realm = try! Realm()
            let predicate = NSPredicate(format: "url BEGINSWITH %@", url)
            let thePhrase = realm.objects(Phrases).filter(predicate).first
                try! realm.write {
                   thePhrase!.phraseName = self.Name
                   thePhrase!.language = self.language
                   thePhrase!.gender = self.gender
                }
        }
        self.tableView.reloadData()
        self.nameEditField.text = ""
        self.languageEditField.text = ""
        editView.hidden = true
    }
    
    @IBAction func forwardAction(sender: AnyObject) {
        if(sound?.play() != nil){
            if(index+1 <= phrases.count-1){
                let cell = phrases[index+1]
                index = index+1
                let toAppendString = cell.url!
                let label = cell.phraseName!
                let duration = cell.time!
                let documentsDirectory = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
                soundFileURL = documentsDirectory.URLByAppendingPathComponent(toAppendString)
                
                do {
                    phraseLabel.text = label
                    totalDuration.text = duration
                    sound = try AVAudioPlayer(contentsOfURL: soundFileURL)
                    audioPlayer = sound
                    sound!.play()
                    NSTimer.scheduledTimerWithTimeInterval(0.001, target: self, selector: #selector(PhrasesViewController.updateAudioProgressView), userInfo: nil, repeats: true)
                    
                } catch let error as NSError {
                    print(error)
                }
            }
        }
    }
    
    @IBAction func volume(sender: AnyObject) {
        audioPlayer?.volume = sender.value
    }
    
    @IBAction func rewindAction(sender: AnyObject) {
        if(sound?.play() != nil){
            if(index-1 >= 0){
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
                    totalDuration.text = duration
                    sound = try AVAudioPlayer(contentsOfURL: soundFileURL)
                    audioPlayer = sound
                    sound!.play()
                    NSTimer.scheduledTimerWithTimeInterval(0.001, target: self, selector: #selector(PhrasesViewController.updateAudioProgressView), userInfo: nil, repeats: true)
                    
                } catch let error as NSError {
                    print(error)
                }
            }

        }
    }
}
