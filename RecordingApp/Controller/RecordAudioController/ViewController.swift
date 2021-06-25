//
//  ViewController.swift
//  RecordingApp
//
//  Created by Nguyen Huu Thao on 6/18/21.
//

import UIKit
import AVFoundation

class ViewController: BaseViewController,AudioDelegate {
    enum Status {
        case Save
        case Delete
    }
    
    @IBOutlet weak var settingButton        : UIButton!
    @IBOutlet weak var faqButton            : UIButton!
    @IBOutlet weak var recordingButton      : UIButton!
    @IBOutlet weak var countTime            : UILabel!
    @IBOutlet weak var flagButton           : UIButton!
    @IBOutlet weak var menuAndFinishButton  : UIButton!
    var counter             : Timer?
    var second              : Int = 0
    var minutes             : Int = 0
    var count               : Int = 0
    var totalTimeInSecond   : Int = 0

    var UserFileName        : String  = ""
    var recordStatus        : Status?
    var audioManager        : MicrophoneMonitor?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupData()
    
    }
    override func setupData() {
        audioManager = MicrophoneMonitor(delegate: self, controller: self)
    }
    override func setupUI() {
        recordingButton.setImage(UIImage(named: Constants.recordImage), for: .normal)
        menuAndFinishButton.setImage(UIImage(named: Constants.menuImage), for: .normal)
        countTime.text = "00 : 00 : 00"
    }
    func updateUI(minutes: Int, second: Int, milisecons: Int) {
        totalTimeInSecond = minutes * 60 + second
        DispatchQueue.main.async {
            let secondtext  = String(format: "%.2d", second)
            let minutestext = String(format: "%.2d", minutes)
            self.countTime.text  = "\(minutestext) : \(secondtext) : \(milisecons)"
        }
    }
 
    @IBAction func DidTapFaqButton(_ sender: Any) {
    
    }
   
    @IBAction func DidTapRecording(_ sender: UIButton) {
     
        if sender.currentImage == UIImage(named: Constants.pauseImage) {
            stopTimerAndRecorder()
            recordingButton.setImage(UIImage(named: Constants.recordImage), for: .normal)
        }
        else if sender.currentImage == UIImage(named: Constants.recordImage) {
            continueTimerAndRecorder()
            recordingButton.setImage(UIImage(named: Constants.pauseImage), for: .normal)
            
            if menuAndFinishButton.currentImage != UIImage(named: Constants.checkImage){
                menuAndFinishButton.setImage(UIImage(named: Constants.checkImage), for: .normal)
            }
        }
   
    }
    func resetUI()  {
        counter             = nil
        totalTimeInSecond   = 0
        count               = 0
        minutes             = 0
        second              = 0
        countTime.text      = "00 : 00 : 00"
        recordingButton    .setImage(UIImage(named: Constants.recordImage), for: .normal)
        menuAndFinishButton.setImage(UIImage(named: Constants.menuImage)  , for: .normal)
    }
    
    func stopTimerAndRecorder() {
//        soundRecorder.pause()
//        counter?.invalidate()
        audioManager?.pause()
    }
    
    func continueTimerAndRecorder() {
        audioManager?.startRecording()
    }
    
    func stopRecorder()  {
        audioManager?.stop()
        //soundRecorder.stop()
    }
    
    @IBAction func DidTapMenu(_ sender: UIButton) {
        if sender.currentImage == UIImage(named: Constants.menuImage){
            let vc = ListRecordController()
            navigationController?.pushViewController(vc, animated: true)
        }
        else if sender.currentImage == UIImage(named: Constants.checkImage){
            stopTimerAndRecorder()
            let alertController = UIAlertController(title: "Saved your record", message: "Enter your record name", preferredStyle: .alert)
            alertController.addTextField()
            let submitAction = UIAlertAction(title: "OK", style: .default) { [unowned alertController] _ in
                let answer = alertController.textFields![0]
                
                if answer.text != ""{
                    self.UserFileName = (answer.text as String?)!
                } else {
                    self.UserFileName = UUID().uuidString
                }
                
                self.recordStatus = .Save
                self.stopRecorder()
                
            }
            let cancelAction = UIAlertAction(title: "Delete", style: .destructive) { (UIAlertAction) in
                self.recordStatus = .Delete
                self.stopRecorder()
            }
            alertController.addAction(submitAction)
            alertController.addAction(cancelAction)
            present(alertController, animated: false)
        }
            
    }
    @IBAction func DidTapSettingButton(_ sender: Any) {
        print("Setting click")
       
    }
}

//MARK: - Recording sound delegate

extension ViewController : AVAudioRecorderDelegate{
   
    

    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        switch recordStatus {
            case .Save:
                Constants.changeFileName(newFileName: self.UserFileName, currentURL: self.audioManager!.getURL())
                if self.totalTimeInSecond == 0 {
                    self.totalTimeInSecond = 1
                }
                RealmHelper.insert(filename: UserFileName, duration: self.totalTimeInSecond, createDate: Date())
                self.resetUI()
            case .Delete:
                Constants.removeFileAt(path: self.audioManager!.getURL().path)
                self.resetUI()
            default:
                print("Nothing to do :)")
            
            
        }
       
    }
}
