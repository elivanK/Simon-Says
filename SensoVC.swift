
import UIKit
import AVFoundation

//For the syntax of following code I got help from the book
// Swift for Beginners: Develop and Design By Boisy G. Pitre


class SensoVC: UIViewController, AVAudioPlayerDelegate {
    //The variables
    //Var for each sound for the AVAudioPlayer.
    var sound1, sound2, sound3, sound4: AVAudioPlayer!
    
    //Array of integer, list of sounds to get random number from 1 - 4 in order to know
    //Which sound is going to be played.
    var soundList = [Int]()
    //Index to know the current sound
    var Index:Int = 0
    
    //var to know how often the user has already taped.
    var noTabs = 0
    //To know if the user is ready for input
    var userReady = false
    
    //To inform the user of his points in a text view.
    var points:Int = 0

    //The outlet for the points
    @IBOutlet weak var pointsTxt: UITextView!
    
    //The outlet and actions
   //All 4 buttons are conected to this outlet collection to change the looks
    @IBOutlet var outletButtons: [UIButton]!
    
    //All 4 buttons are connected in this action, and each is set with a sound via tag.
    @IBAction func actionButtons(_ sender: Any) {
        if userReady {
            let button = sender as! UIButton
            switch button.tag {
            case 1:
                
                highlightButton(tag: 1)
                sound1.play()
                checkIfCurrect(buttonPressed: 1)
                break
            case 2:
                
                highlightButton(tag: 2)
                sound2.play()
                checkIfCurrect(buttonPressed: 2)
                break
            case 3:
                
                highlightButton(tag: 3)
                sound3.play()
                checkIfCurrect(buttonPressed: 3)
                
                break
            case 4:
                
                highlightButton(tag: 4)
                sound4.play()
                checkIfCurrect(buttonPressed: 4)
                
                break
            default:
                break
            }
        }
    }
    
    
    //The action to start button to start the game.
    @IBAction func startGameButton(_ sender: UIButton) {
        //Set points to null
        points = 0
        pointsTxt.text = String(points)
        
        //Give a random number from 1 - 4 to play a sound
        print("button works")
        //Play a rendom sound
        let randomNumber = arc4random_uniform(UInt32(4) + 1)
        soundList.append(Int(randomNumber))
        playNext()
    }
    
    
    //The function to reset the color of the button
    func resetColorButton(){
        //Set the first button to green
        outletButtons[0].backgroundColor = UIColor(red: 0, green: 255, blue: 0, alpha: 1)
        //set to color red
        outletButtons[1].backgroundColor = UIColor(red: 255, green: 0, blue: 0, alpha: 1)
        //collor green
        outletButtons[2].backgroundColor = UIColor(red: 255, green: 255, blue: 0, alpha: 1)
        //color blue
        outletButtons[3].backgroundColor = UIColor(red: 0, green: 0, blue: 255, alpha: 1)
        
    }
    
    //The function to check if the user pressed the currect button and if not, the game will restart.
    func checkIfCurrect(buttonPressed:Int){
        if buttonPressed == soundList [noTabs] {
            print ("currect")
            //check if we have arrived at the last itme of the playlist
            if noTabs == soundList.count - 1 {
                //add one second delay before the next round
                let time = DispatchTime.now() + 1
                DispatchQueue.main.asyncAfter(deadline: time) {
                    //Play the next random sound
                    self.nextRound()
                }
                
                return
            }
            noTabs += 1
            
        } else {
            //Game over pop alert widnow to the  user and reset game
            print("GAME OVER!")
            //Invoke pop window alert
            showAlert()
            
        }
        
    }
    
    //The method to display alert contoller with the action to restart the game
    func showAlert(){
        
        let alertController = UIAlertController(title: "Opps", message: "Looks like you lost this round.... looooosssserr", preferredStyle: .alert)
        
        self.present(alertController, animated: true, completion:nil)
        
        let theAction = UIAlertAction(title: "Restart Game", style: .default, handler: {
            (UIAlertAction) in self.resetGame()
        })
        alertController.addAction(theAction)
    }
    
    //The function to higlight the button, change the alpha
    func highlightButton(tag:Int){
    switch tag {
    case 1:
        resetColorButton()
        outletButtons [tag - 1].backgroundColor = UIColor(red: 0, green: 255, blue: 0, alpha: 0.3)
        break
    case 2:
        resetColorButton()
        outletButtons[tag - 1].backgroundColor = UIColor(red: 255, green: 0, blue: 0, alpha: 0.3)
        
    case 3:
        resetColorButton()
        outletButtons[ tag - 1].backgroundColor = UIColor(red: 255, green: 255, blue: 0, alpha: 0.3)
        
    case 4:
        resetColorButton()
        outletButtons[tag - 1].backgroundColor = UIColor(red: 0, green: 0, blue: 255, alpha: 0.3)
        
    default:
        break
    }
    
  }
    override func viewDidLoad() {
    
    }
  
    override func viewDidAppear(_ animated: Bool) {
    createSound()
    }
    //The method to set and initialize the audio files.
    func createSound(){
    
    let path1 = Bundle.main.path(forResource: "s1", ofType: "mp3")
    let url1 = URL(fileURLWithPath: path1!)
    
    let path2 = Bundle.main.path(forResource:"s2", ofType: "mp3")
    let url2 = URL(fileURLWithPath: path2!)
    
    let path3 = Bundle.main.path(forResource:"s3", ofType: "mp3")
    let url3 = URL(fileURLWithPath: path3!)
    
    let path4 = Bundle.main.path(forResource:"s4", ofType: "mp3")
    let url4 = URL(fileURLWithPath: path4!)
    
    do {
        try sound1 = AVAudioPlayer (contentsOf: url1)
        //Tell the audio player that the delegate func is in the file and set the loop
        sound1.delegate = self
        sound1.numberOfLoops = 0
        
        try sound2 = AVAudioPlayer(contentsOf: url2)
        sound2.delegate = self
        sound2.numberOfLoops = 0
        
        try sound3 = AVAudioPlayer(contentsOf: url3)
        sound3.delegate = self
        sound3.numberOfLoops = 0
        
        try sound4 = AVAudioPlayer(contentsOf: url4)
        sound4.delegate = self
        sound4.numberOfLoops = 0
        //Catch an error and print it
    }catch let error as NSError{
        print (error.localizedDescription)
    }
  }
  //The function to let us know that one sound have been played.
  func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
    //If the current sound is smaller play the next sound
    // - 1 becuase of array index
    if Index <= soundList.count - 1{
        //play the next sound
        playNext()
    } else {
        userReady = true
        resetColorButton()
    }
  }
   //The function to play the next sound
   func playNext(){
    let select = soundList[Index]
    switch select {
    case 1:
        highlightButton(tag:1)
        sound1.play()
        break
    case 2:
        highlightButton(tag:2)
        sound2.play()
        
        break
    case 3:
        highlightButton(tag:3)
        sound3.play()
        break
    case 4:
        highlightButton(tag:4)
        sound4.play()
        
    default:
        break
    }
    //Increase the index to play next sound
    Index += 1
   }
    //The method to play the next sound
    func nextRound(){
    print("Next round")
    userReady = false
    points += 1
    pointsTxt.text = String(points)
    noTabs = 0
    Index = 0
    let randomNr = arc4random_uniform(UInt32(4) + 1)
    soundList.append(Int(randomNr))
    playNext()
    
   }
    //The method to reset the game
    func resetGame(){
    print("Game restarted")
    userReady = false
    points = 0
    pointsTxt.text = String(points)
    noTabs = 0
    Index = 0
    soundList = []
  }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
