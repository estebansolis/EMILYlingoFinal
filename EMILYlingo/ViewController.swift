//
//  ViewController.swift
//  EMILYlingo
//
//  Created by Esteban Solis on 3/31/16.
//  Copyright © 2016 EMILYlingo. All rights reserved.
//

import UIKit
import RealmSwift
import AVFoundation

class ViewController: UIViewController, UITextFieldDelegate, AVAudioRecorderDelegate{
    
    //------------------------------------------------------------------------------
    // MARK: Properties
    //------------------------------------------------------------------------------
    var phrases: Phrases!
    
    @IBOutlet weak var navigationHam: UIBarButtonItem!
    @IBOutlet weak var waveformView: SiriWaveformView!
    @IBOutlet weak var RecordButton: UIButton!
    @IBOutlet weak var TimerLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var saveView: UIView!
    @IBOutlet weak var savePhraseButton: UIButton!
    @IBOutlet weak var cancelPhraseButton: UIButton!
    
    @IBOutlet weak var languageField: UITextField!

    @IBOutlet weak var nameField: UITextField!
    
    @IBOutlet weak var genderField: UISegmentedControl!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var languageLabel: UILabel!
    
    @IBOutlet weak var genderLabel: UILabel!
    let realm = try! Realm()
    
    var audioURL: NSURL!
    var recordingSession: AVAudioSession!
    var audioPlayer: AVAudioPlayer?
    var audioRecorder: AVAudioRecorder!
    var tempTimer = 0
    var timer = 30
    var count = 2
    var check = false;
    var TimerControl = NSTimer()
    var isRecording = false;
    
    var dictionary: [String:String] = [
        "zero" : "zero"
    ]
    //------------------------------------------------------------------------------
    // MARK: Status Bar Style
    //------------------------------------------------------------------------------
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent;
    }

    //------------------------------------------------------------------------------
    // MARK: View Lifecycle
    //------------------------------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController!.navigationBar.barTintColor = UIColor(red:  0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 100.0/100.0)
        waveformView.waveColor = UIColor.whiteColor()
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, withOptions: AVAudioSessionCategoryOptions.DefaultToSpeaker)
        
        let defaults = NSUserDefaults.standardUserDefaults()
        if let language = defaults.stringForKey("Language"){
            if(language == "English"){
                savePhraseButton.setTitle("Save", forState: .Normal)
                cancelPhraseButton.setTitle("Cancel", forState: .Normal)
                nameLabel.text = "Name:"
                languageLabel.text = "Language:"
                genderLabel.text = "Gender:"
                
            }
            if(language == "Turkish"){
                savePhraseButton.setTitle("Kaydet", forState: .Normal)
                cancelPhraseButton.setTitle("Iptal", forState: .Normal)
                nameLabel.text = "Isim:"
                languageLabel.text = "Dil:"
                genderLabel.text = "Cinsiyet:"
            }
            if(language == "Greek"){
                savePhraseButton.setTitle("αποθηκεύσετε", forState: .Normal)
                cancelPhraseButton.setTitle("ματαίωση", forState: .Normal)
                nameLabel.text = "Όνομα:"
                languageLabel.text = "Γλώσσα:"
                genderLabel.text = "γένος:"
                
            }
        }
        self.slideMenuController()?.removeLeftGestures()
        cancelButton.hidden = true
        saveButton.hidden = true
        saveView.hidden = true
        
        recordingSession = AVAudioSession.sharedInstance()
        
        do {
            
            nameField.delegate = self
            languageField.delegate = self
            try recordingSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission(){[unowned self] (allowed: Bool) -> Void in
                dispatch_async(dispatch_get_main_queue()){
                    if allowed {
                        self.loadRecordingUI()
                    }else {
                        
                    }
                }
            }
        }catch {
            
        }
        
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 16
        let currentString: NSString = textField.text!
        let newString: NSString = currentString.stringByReplacingCharactersInRange(range, withString: string)
        return newString.length <= maxLength
    }
    
    func loadRecordingUI(){
        if count == 1 {
            check = true
            if let image = UIImage(named: "recordingOn.png") {
                navigationHam.enabled = false
                TimerControl = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(ViewController.countdown), userInfo: nil, repeats: true)
                count = 2
                RecordButton.setImage(image, forState: .Normal)
                startRecording()
            }
        }else {
            if let image = UIImage(named: "recordOff.png") {
                count = 1
                tempTimer = timer
                timer = 30
                TimerLabel.text = "0:"+String(timer)
                TimerControl.invalidate()
                RecordButton.setImage(image, forState: .Normal)
                if(check == true){
                    finishRecording()
                }
            }
        }
    }
    
    func finishRecording(){
        isRecording = false
        audioRecorder.meteringEnabled = false
        audioRecorder.stop()
        navigationHam.enabled = false
        audioRecorder = nil
        RecordButton.hidden = true
        cancelButton.hidden = false
        saveButton.hidden = false
        TimerLabel.hidden = true
        check = false
        
        do {
            let session = AVAudioSession.sharedInstance()
            try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, withOptions: AVAudioSessionCategoryOptions.DefaultToSpeaker)
            let sound = try AVAudioPlayer(contentsOfURL: audioURL)
            audioPlayer = sound
            sound.play()
            RecordButton.enabled = false
        }catch{
            
        }
        
    }
    
    func startRecording(){
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsDirectory = paths[0]
        let randomURL = "/"+String.random()
        let audioFilename = documentsDirectory.stringByAppendingString(randomURL + ".m4a")
        audioURL = NSURL(fileURLWithPath: audioFilename)
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000.0,
            AVNumberOfChannelsKey: 1 as NSNumber,
            AVEncoderAudioQualityKey: AVAudioQuality.Max.rawValue
        ]
        
        do {
            isRecording = true
            audioRecorder = try AVAudioRecorder(URL: audioURL, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()
            waveformView.waveColor = UIColor.whiteColor()
            audioRecorder.meteringEnabled = true
            let displayLink = CADisplayLink(target: self, selector: #selector(ViewController.updateMeters))
            displayLink.addToRunLoop(NSRunLoop.currentRunLoop(), forMode: NSRunLoopCommonModes)
            
        }catch {
            finishRecording()
        }
    }
    
    func updateMeters(){
        if isRecording == true {
            audioRecorder.updateMeters()
            let normalizeValue = pow(10, audioRecorder.averagePowerForChannel(0)/20)
            waveformView.updateWithLevel(CGFloat(normalizeValue))
        }
    }
    
    @IBAction func RecordAndStop(sender: AnyObject) {
        loadRecordingUI()
    }
    
    @IBAction func confirmButton(sender: AnyObject) {
        saveButton.hidden = true
        cancelButton.hidden = true
        saveView.hidden = false
    }
    @IBAction func discardButton(sender: AnyObject) {
        navigationHam.enabled = true
        cancelButton.hidden = true
        saveButton.hidden = true
        RecordButton.hidden = false
        TimerLabel.hidden = false
        RecordButton.enabled = true
        do{
            let sound = try AVAudioPlayer(contentsOfURL: audioURL)
            audioPlayer = sound
            sound.stop()
        }
        catch{
            
        }
        
    }
    @IBAction func saveButton(sender: AnyObject) {
        
    }
    
    @IBAction func cancelButton(sender: AnyObject) {
        languageField.text = ""
        nameField.text = ""
        saveView.hidden = true
        RecordButton.hidden = false
        TimerLabel.hidden = false
        RecordButton.enabled = true
        navigationHam.enabled = true
        self.view.endEditing(true)
    }
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording()
        }
    }
    
    func countdown(){
        if(timer > 0){
            timer = timer - 1
            if(timer < 10){
                TimerLabel.text = "0:0"+String(timer)
            }else {
                TimerLabel.text = "0:"+String(timer)
            }
        }else {
            if let image = UIImage(named: "RecordOff.png") {
                count = 1
                tempTimer = timer
                timer = 30
                TimerLabel.text = "0:"+String(timer)
                TimerControl.invalidate()
                RecordButton.setImage(image, forState: .Normal)
                if(check == true){
                    finishRecording()
                }
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "segueIdentifer"{
            let date = NSDate()
            let datesFormatter = NSDateFormatter()
            datesFormatter.dateFormat = "MM:dd:hh:mm"
            languageField.text = ""
            nameField.text = ""
            saveView.hidden = true
            RecordButton.hidden = false
            TimerLabel.hidden = false
            if let destination = segue.destinationViewController as? PhrasesViewController {
                dictionary["phraseName"] = nameField.text
                dictionary["language"] = languageField.text
                if ((30-tempTimer) >= 10) {
                    dictionary["time"] = "0:"+String(30-tempTimer)
                }else{
                    dictionary["time"] = "0:0"+String(30 - tempTimer)
                }
                
                dictionary["flag"] = languageField.text
                switch genderField.selectedSegmentIndex
                {
                case 0:
                    dictionary["gender"] = "female"
                case 1:
                    dictionary["gender"] = "male"
                default:
                    break;
                }
                let audioFileName = audioURL.lastPathComponent
                dictionary["url"] = audioFileName
                dictionary["date"] = datesFormatter.stringFromDate(date)
                var phrase: Phrases!
                phrase = Phrases(dictionary: dictionary)
                destination.phrase = phrase
                try! realm.write {
                    realm.add(phrase)
                }
            }
           
        
        }
        
    }
    
    func showErrorAlert(title: String, msg: String){
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .Alert)
        let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }
}

extension String {
    
    static func random(length: Int = 8) -> String {
        
        let base = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var randomString: String = ""
        
        for _ in 0..<length {
            let randomValue = arc4random_uniform(UInt32(base.characters.count))
            randomString += "\(base[base.startIndex.advancedBy(Int(randomValue))])"
        }
        
        return randomString
    }
}