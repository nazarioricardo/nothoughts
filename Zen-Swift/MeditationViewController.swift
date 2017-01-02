//
//  MeditationViewController.swift
//  Zen-Swift
//
//  Created by Ricardo Nazario on 1/2/17.
//  Copyright © 2017 Ricardo Nazario. All rights reserved.
//

import UIKit
import AudioKit

class MeditationViewController: UIViewController {
    
    var meditationTime: Double = Double()
    var timeElapsed: Int = Int()
    
    var oscillator: AKOscillator!
    var envelope: AKAmplitudeEnvelope!
    var delay: AKDelay!
    var reverb: AKReverb!
    
    @IBAction func endPressed(_ sender: Any) {
        
        oscillator.stop()
        delay.stop()
        reverb.stop()
        self.dismiss(animated: true, completion: nil)
    }
    
    func initializeBell() {
        
        // Init oscillator
        oscillator = AKOscillator()
        oscillator.stop()
        oscillator.amplitude = 0.9
        oscillator.frequency = random(300.0, 500.0)
        
        // Init envelope
        envelope = AKAmplitudeEnvelope(oscillator)
        envelope.stop()
        envelope.attackDuration = 0.05
        envelope.decayDuration = 0.1
        envelope.sustainLevel = oscillator.amplitude
        envelope.releaseDuration = random(0.5, 0.8)
        
        // Init delay for chorusing
        delay = AKDelay(envelope)
        delay.stop()
        delay.time = random(0.01, 0.05)
        delay.dryWetMix = 1.0
        delay.feedback = 0.3
        
        // Init reverb
        reverb = AKReverb(delay)
        reverb.stop()
        reverb.dryWetMix = random(0.4, 0.7)
        reverb.loadFactoryPreset(AVAudioUnitReverbPreset.cathedral)
        
        // Start audio
        AudioKit.stop()
        AudioKit.output = reverb
        AudioKit.start()
        oscillator.start()
        envelope.start()
        delay.start()
        reverb.start()
        
        Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false, block: {(timer) in self.envelope.stop()})
    }
    
    func meditation() {
        
        self.initializeBell()
        
        //Init timer
        Timer.scheduledTimer(withTimeInterval: meditationTime, repeats: false, block: { (timer) in self.endMeditation()})
        
    }
    
    func endMeditation() {
        
        self.initializeBell()
        
        
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false, block: { (timer) in self.meditation()})
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}