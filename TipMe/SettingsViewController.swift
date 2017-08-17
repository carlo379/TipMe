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
        
        if  let min = tipCalc?.tipRangeValues[0],
            let def = tipCalc?.tipRangeValues[1],
            let max = tipCalc?.tipRangeValues[2] {
            
            minTF.text = String(format: "%.0f",min)
            maxTF.text = String(format: "%.0f",max)
            defaultTipLb.text = String(format: "%.0f", def)+"%"
        } else {
            _ = navigationController?.popViewController(animated: true)
        }
    }
    
    // MARK: - IBActions
    @IBAction func sliderChanged(_ sender: Any) {
        if let minText = minTF.text, let min = Float(minText) {
            tipCalc?.tipRangeValues[0] = min
            tipSlider.minimumValue = min
        } else {
            minTF.text = ""
        }
        
        if let maxText = maxTF.text, let max = Float(maxText) {
            tipCalc?.tipRangeValues[2] = max
            tipSlider.maximumValue = max
        } else {
            maxTF.text = ""
        }
        
        tipCalc?.tipRangeValues[1] = round(tipSlider.value / incrementStep) * incrementStep
        tipSlider.value = (tipCalc?.tipRangeValues[1])!
        defaultTipLb.text = String(format: "%.0f", tipSlider.value)+"%"
        
        let defaults = UserDefaults.standard
        defaults.set(tipCalc?.tipRangeValues[0], forKey: "TIP_MIN")
        defaults.set(tipCalc?.tipRangeValues[2], forKey: "TIP_MAX")
        defaults.set(tipCalc?.tipRangeValues[1], forKey: "TIP_DEFAULT")
        defaults.synchronize()
        
    }

}
