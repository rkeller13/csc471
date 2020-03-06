//Robert J Keller
//CSC 471
//Assignment 6



//  ViewController.swift
//  rjkAssignment6
//
//  Copyright © 2020 Robert Keller. All rights reserved.
//

import UIKit

class ViewController: UIViewController {


    @IBOutlet weak var switchLabel: UILabel!
    @IBOutlet weak var sliderLabel: UILabel!
    @IBOutlet weak var channelLabel: UILabel!
    @IBOutlet weak var controlView: UIView!
    @IBOutlet weak var tvView: UIView!
    @IBOutlet weak var powerView: UIView!
    
    @IBOutlet weak var powerSwitch: UISwitch!
    @IBOutlet weak var volumeSlider: UISlider!
    
    //100 is a conditional place holder since channel inputs  can be 0 - 99
    //Also created fake channel variables for my favorite channels segmented control
    var channelStr: String = "";
    var numInput: Int = 100;
    var zeroCheck: Int = 100;
    var currentChannel: String = "";
    var currentNum:Int = 1;
    let hboChannel:String = "13";
    let espnChannel: String = "45";
    let netflixChannel: String = "99";
    let abcChannel: String = "30";
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    
    @IBAction func switchToggled(_ sender: UISwitch) {
        switchLabel.text = sender.isOn ? "On" : "Off";
        
        //Disables the controller view when the power is switched off
        if switchLabel.text == "Off" {
            controlView.isUserInteractionEnabled = false;
        } else {
            controlView.isUserInteractionEnabled = true;
        }
    }
    
    @IBAction func sliderMoved(_ sender: UISlider) {
        sliderLabel.text = "\(Int(sender.value))";
    }
    
    //Created buttons instead of stepper for +/- due to vertical layout of control on remote
    @IBAction func plusminusPressed(_ sender: UIButton) {
        currentChannel = channelLabel.text ?? "";
        currentNum = Int(currentChannel) ?? 1;
        
        if let channelStep = sender.currentTitle {
            if channelStep == "Ch+" && currentNum < 99 {
                currentNum += 1;
                channelLabel.text = "\(currentNum)"
            } else if channelStep == "Ch-" && currentNum > 1{
                currentNum -= 1;
                channelLabel.text = "\(currentNum)"
            }
        }
    }
    
    
    @IBAction func numberPressed(_ sender: UIButton) {
        
        if let channel = sender.currentTitle {
            channelStr += channel;
        }
        
        numInput = Int(channelStr) ?? 100;
        
        //Checks for the 0 button being pressed for single digit channels
        if numInput == 0 {
            zeroCheck = 0;
        }
        
        //If 0 is pressed and numInput is greater than 1 (meaning a second digit was pressed after
        // 0, then the channel is displayed and the zeroCheck and channelStr are reset
        //If 0 is pressed second, then zeroCheck is not 0, so the first conditional is correctly
        // not satisfied and the second conditional correctly is
        if zeroCheck == 0 &&  numInput > 0 {
            channelLabel.text = "\(numInput)";
            channelStr = "";
            zeroCheck = 100;
        }
        
        if  numInput >= 10 && numInput < 100 {
            channelLabel.text = "\(numInput)";
            channelStr = "";
            numInput = 100;
            zeroCheck = 100;
        }
        
    }
    
    @IBAction func favSelected(_ sender: UISegmentedControl) {
        
        if let favChannel = sender.titleForSegment(at: sender.selectedSegmentIndex) {
            switch favChannel {
            case "HBO": channelLabel.text = hboChannel;
            case "ESPN": channelLabel.text = espnChannel;
            case "NETFLIX": channelLabel.text = netflixChannel;
            case "ABC": channelLabel.text = abcChannel;
            default: channelLabel.text = "1";
            }
        }
    }
    
}

