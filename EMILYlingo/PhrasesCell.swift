//
//  PhrasesCell.swift
//  EMILYlingo
//
//  Created by Esteban Solis on 4/4/16.
//  Copyright © 2016 EMILYlingo. All rights reserved.
//

import UIKit

class PhrasesCell: UITableViewCell {
    
    @IBOutlet weak var phraseNameLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var emojiLabel: UILabel!

    var phrase: Phrases!{
        didSet{
            phraseNameLabel.text = phrase.phraseName
            languageLabel.text = phrase.language
            timeLabel.text = phrase.time
            var value = ""
            if(phrase.gender == "male"){
                value = "👨"
            }
            else{
                value = "👩"
            }
            if(phrase.language == "Greek" || phrase.language == "greek"){
                value += "🇬🇷"
            }
            if(phrase.language == "English" || phrase.language == "english"){
                value += "🇺🇸"
            }
            if(phrase.language == "Arabic" || phrase.language == "arabic"){
                value += "🇹🇷"
            }
            
            emojiLabel.text = value
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }


}
