//
//  DVRViewController.swift
//  rjkAssignment6
//
//  Created by Robert Keller on 2/25/20.
//  Copyright © 2020 Robert Keller. All rights reserved.
//

import UIKit

class DVRViewController: UIViewController {

    @IBOutlet weak var DVRView: UIView!
    @IBOutlet weak var controlView: UIView!
    @IBOutlet weak var powerView: UIView!
    @IBOutlet weak var powerLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var ffButton: UIButton!
    @IBOutlet weak var rewindButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    
    let States = ["Play", "Stop", "Pause", "Fast Forward", "Rewind", "Record"];
    var stateDisplay = "Stopped";
    var priorDisplay = "Stopped";
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //Switches back to MY TV View
    @IBAction func switchToTV(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil);
    }
    
    @IBAction func powerSwitchToggled(_ sender: UISwitch) {
        powerLabel.text = sender.isOn ? "On" : "Off";
        
        //Disables the controller view when the power is switched off
        //Brings the current state to Stopped
        if powerLabel.text == "Off" {
            controlView.isUserInteractionEnabled = false;
            stateLabel.text = "Stopped";
        } else {
            controlView.isUserInteractionEnabled = true;
        }
    }
    
    //The button label pressed is sent to the function stateActionDisplay
    //Then the prior button pressed is checked with the current button to see if the current command is valid
    //If the current command is not valid, the buttonAlert function is called
    //The prior state is sent as an argument so that the stateDisplay can be reverted if the user chooses "No"
    //New state is diplayed and saved as the prior display for the next button press
    @IBAction func statePressed(_ sender: UIButton) {
        stateDisplay = stateActionDisplay(currentState: sender.currentTitle ?? "Stop");
        if ((stateDisplay == "Rewinding" || stateDisplay == "Fast Forwarding" || stateDisplay == "Paused") && priorDisplay != "Playing") {
            buttonAlert(display: priorDisplay);
        }
        if priorDisplay == "Recording" && stateDisplay != "Stopped" {
            buttonAlert(display: priorDisplay);
        }
        if stateDisplay == "Recording" && priorDisplay != "Stopped" {
            buttonAlert(display: priorDisplay);
        }
        stateLabel.text = stateDisplay;
        priorDisplay = stateDisplay;
    }
    
    //Function to check for the current state in the array and return the action verb corresponding to it
    func stateActionDisplay(currentState: String) -> String {
        var stateAction = "";
    
        for _ in States {
            switch currentState {
            case "Play": stateAction = "Playing";
            case "Stop": stateAction = "Stopped";
            case "Pause": stateAction = "Paused";
            case "Fast Forward": stateAction = "Fast Forwarding";
            case "Rewind": stateAction = "Rewinding";
            case "Record": stateAction = "Recording";
            default: stateAction = "Stopped";
            }
        }
        return stateAction;
    }
    
    //Action sheet style alert to give the user a continue or cancel option
    //Cancel or "No" reverts the current display back to the prior display, also have to include the
    // self.priorDisplay assignment because if the user chooses "No" twice in a row, the first invalid
    // command would be displayed if this statement was not included
    //Continue or "Yes" first changes the state to Stopped, then calls the continueAlert function
    @IBAction func buttonAlert(display: String) {
        let alertController = UIAlertController(title: "Continue?", message: "Continuing will stop the current DVR action", preferredStyle: .actionSheet);
        let alertNo = UIAlertAction(title: "No", style: .default, handler: {action in
            self.stateLabel.text = display;
            self.priorDisplay = display;
        });
        let alertYes = UIAlertAction(title: "Yes", style: .default, handler: {action in
            self.stateLabel.text = "Stopped";
            self.continueAlert();
        });
        alertController.addAction(alertNo);
        alertController.addAction(alertYes);
        present(alertController, animated: true, completion: nil);
    }
    
    //This function creates another alert popup that tells the user that the current state is stopping
    // and that the new state will be the user's requested command
    @IBAction func continueAlert() {
        let alertController = UIAlertController(title: "Current Operation Stopped", message: "Continuing with the requested operation", preferredStyle: .alert);
        let alertContinue = UIAlertAction(title: "Got It", style: .default, handler: {action in
            self.stateLabel.text = self.priorDisplay;
        });
        alertController.addAction(alertContinue);
        present(alertController, animated: true, completion: nil);
    }

}
