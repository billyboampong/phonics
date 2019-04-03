//
//  VowelsVC.swift
//  Phonics-N
//
//  Created by Billy Boampong on 03/03/2019.
//  Copyright © 2019 BB++. All rights reserved.
//

import UIKit
import AVFoundation


// UIColor extension code for using RGB hex codes
extension UIColor {
    
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}

class VowelsVC: UIViewController {
    
    
    var audioPlayer : AVAudioPlayer?
    var selectedSoundFileName : String = ""
    var playedVowel : String = ""
    var randomVowelIndex : Int = 0
    var vowelArray = ["A", "E", "I", "O", "U"]

    @IBOutlet weak var vowelAnswerLabel: UILabel!
    
    @IBOutlet weak var vowelFace01: UIButton!
    @IBOutlet weak var vowelFace02: UIButton!
    @IBOutlet weak var vowelFace03: UIButton!
    @IBOutlet weak var vowelFace04: UIButton!
    @IBOutlet weak var vowelFace05: UIButton!
   
    
// Selects a random vowel for the question
    func randomVowel() {
        randomVowelIndex = Int.random(in: 0 ... 4)
    }
 
// Plays audio based on 'selectedSoundFileName' input
    func playAudio() {
        let path = Bundle.main.path(forResource: selectedSoundFileName, ofType:nil)!
        let url = URL(fileURLWithPath: path)
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        } catch {
            print("Couldn't load audio") }
    }
    
    
    // Check answer function
    func checkAnswer (sender: UIButton) {
        let vowelFaces = [vowelFace01, vowelFace02, vowelFace03, vowelFace04, vowelFace05]
        let tag = sender.tag - 1
        if vowelFaces[tag]!.currentTitle == playedVowel {
            rightAnswer(sender: vowelFaces[tag]!)
            refreshVowelsWithDelay()
        }
        else {
            wrongAnswer(sender: vowelFaces[tag]!)
        }
        
    }
    
    
// Plays 'correct' audio, highlights 'correct' button and disables/enables 'correct' button
    func rightAnswer (sender: UIButton) {
        selectedSoundFileName = "ThatsCorrect.mp3"
        playAudio()
        vowelAnswerLabel.text = "CORRECT!"
        vowelAnswerLabel.textColor = UIColor(rgb: 0x39ff14)
        let vowelFaces = [vowelFace01, vowelFace02, vowelFace03, vowelFace04, vowelFace05]
        let tag = sender.tag - 1
        vowelFaces[tag]!.layer.cornerRadius = 5
        vowelFaces[tag]!.layer.borderColor = UIColor(rgb: 0x39ff14).cgColor
        vowelFaces[tag]!.layer.borderWidth = 8.0
        vowelFaces[tag]!.isUserInteractionEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
            vowelFaces[tag]!.layer.borderWidth = 0
            vowelFaces[tag]!.isUserInteractionEnabled = true
        })
    }
    
    
// Plays 'wrong' audio and highlights 'wrong' button
    func wrongAnswer (sender: UIButton) {
        selectedSoundFileName = "Uhoh.mp3"
        playAudio()
        vowelAnswerLabel.text = "WRONG :("
        vowelAnswerLabel.textColor = UIColor(rgb: 0xFB2B11)
        let vowelFaces = [vowelFace01, vowelFace02, vowelFace03, vowelFace04, vowelFace05]
        let tag = sender.tag - 1
        vowelFaces[tag]!.layer.cornerRadius = 5
        vowelFaces[tag]!.layer.borderColor = UIColor(rgb: 0xFB2B11).cgColor
        vowelFaces[tag]!.layer.borderWidth = 8.0
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.3, execute: {
            self.vowelAnswerLabel.text = ""
            vowelFaces[tag]!.layer.borderWidth = 0
        })
    }

// New question audio setup and play
    func newQuestion() {
        randomVowel()
        selectedSoundFileName = "WhichOneIs.mp3"
        playAudio()
        let when = DispatchTime.now() + 1.7
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.selectedSoundFileName = self.vowelArray[self.randomVowelIndex]+".mp3"
            self.playAudio()
        }
    }
    
// Vowel button faces refresh function
    func newFaces() {
        let vowelFaces = [vowelFace01, vowelFace02, vowelFace03, vowelFace04, vowelFace05]
        for (vowelFace, vowel) in zip(vowelFaces, vowelArray.shuffled()) {
            vowelFace?.setTitle(vowel, for: .normal)
        }
    }
    
// Establishes correct answer based on vowel audio played
    func newAnswer() {
        playedVowel = vowelArray[randomVowelIndex]
        print(playedVowel)
    }
    
// Combines functions to refresh the whole question and views
    func refreshVowelsWithDelay() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
            self.newQuestion()
            self.newAnswer()
            self.newFaces()
            self.vowelAnswerLabel.text = ""
        })
    }
    
    
// Local VC back button function
    @IBAction func dismissVowelVC(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
// Local refresh button function (replays vowel audio)
    @IBAction func refreshVowelAudio(_ sender: Any) {
        selectedSoundFileName = "\(playedVowel).mp3"
        playAudio()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newQuestion()
        newAnswer()
        newFaces()

    }
    
    
// Vowel button press answer check functions
    @IBAction func vowelFace01Pressed(_ sender: UIButton) {
       checkAnswer(sender: vowelFace01)
    }
    
    @IBAction func vowelFace02Pressed(_ sender: UIButton) {
        checkAnswer(sender: vowelFace02)
    }
    
    @IBAction func vowelFace03Pressed(_ sender: UIButton) {
        checkAnswer(sender: vowelFace03)
    }
    
    @IBAction func vowelFace04Pressed(_ sender: UIButton) {
        checkAnswer(sender: vowelFace04)
    }
    
    @IBAction func vowelFace05Pressed(_ sender: UIButton) {
        checkAnswer(sender: vowelFace05)
    }
    
}

// TO DO
// add "good job" and "try again" as alternative soundbites
