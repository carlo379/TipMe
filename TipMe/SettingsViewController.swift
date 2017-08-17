//
//  SettingsViewController.swift
//  TipMe
//
//  Created by Carlos Martinez on 8/15/17.
//  Copyright © 2017 Carlos Martinez. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    // MARK: - Properties
    @IBOutlet weak var defaultTipLb: UILabel!
    @IBOutlet weak var minTF: UITextField!
    @IBOutlet weak var maxTF: UITextField!
    @IBOutlet weak var tipSlider: UISlider!
    
    var tipCalc:TipCalc?
    let incrementStep = Float(1)
    
    // MARK: - View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if  let min = tipCalc?.tipRangeValues[TipRange.min.rawValue],
            let def = tipCalc?.tipRangeValues[TipRange.def.rawValue],
            let max = tipCalc?.tipRangeValues[TipRange.max.rawValue] {
            
            minTF.text = String(format: K.StringFormat.segmentCtrl, min)
            maxTF.text = String(format: K.StringFormat.segmentCtrl, max)
            defaultTipLb.text = String(format: K.StringFormat.segmentCtrl, def)+"%"
        } else {
            _ = navigationController?.popViewController(animated: true)
        }
    }
    
    // MARK: - IBActions
    @IBAction func sliderChanged(_ sender: Any) {
        if let minText = minTF.text, let min = Float(minText) {
            tipCalc?.tipRangeValues[TipRange.min.rawValue] = min
            tipSlider.minimumValue = min
        } else {
            minTF.text = ""
        }
        
        if let maxText = maxTF.text, let max = Float(maxText) {
            tipCalc?.tipRangeValues[TipRange.max.rawValue] = max
            tipSlider.maximumValue = max
        } else {
            maxTF.text = ""
        }
        
        tipCalc?.tipRangeValues[TipRange.def.rawValue] = round(tipSlider.value / incrementStep) * incrementStep
        tipSlider.value = (tipCalc?.tipRangeValues[TipRange.def.rawValue])!
        defaultTipLb.text = String(format: K.StringFormat.segmentCtrl, tipSlider.value)+"%"
        
        let defaults = UserDefaults.standard
        defaults.set(tipCalc?.tipRangeValues[TipRange.min.rawValue], forKey: K.KeyUserDefault.min)
        defaults.set(tipCalc?.tipRangeValues[TipRange.def.rawValue], forKey: K.KeyUserDefault.def)
        defaults.set(tipCalc?.tipRangeValues[TipRange.max.rawValue], forKey: K.KeyUserDefault.max)

        defaults.synchronize()
        
    }

}
