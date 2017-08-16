//
//  SettingsViewController.swift
//  TipMe
//
//  Created by Carlos Martinez on 8/15/17.
//  Copyright © 2017 Carlos Martinez. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var defaultTipLb: UILabel!
    @IBOutlet weak var minTF: UITextField!
    @IBOutlet weak var maxTF: UITextField!
    @IBOutlet weak var tipSlider: UISlider!
    var incrementStep = Float(1)
    
    //  Unwrapping because are init on 'viewDidLoad'
    var minTip:Float!
    var maxTip:Float!
    var defaultTip:Float! {
        didSet {
            defaultTipLb.text = String(format: "%.0f", defaultTip)+"%"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard
        minTip =  Help().isKeyPresentInUserDefaults(key: "TIP_MIN") ? defaults.float(forKey: "TIP_MIN") : 10
        minTF.text = String(format: "%.0f",minTip)
        
        maxTip =  Help().isKeyPresentInUserDefaults(key: "TIP_MAX") ? defaults.float(forKey: "TIP_MAX") : 20
        maxTF.text = String(format: "%.0f",maxTip)
        
        defaultTip =  Help().isKeyPresentInUserDefaults(key: "TIP_DEFAULT") ? defaults.float(forKey: "TIP_DEFAULT") : 15
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sliderChanged(_ sender: Any) {
        minTip = Float(minTF.text!) ?? 10
        maxTip = Float(maxTF.text!) ?? 20
        
        tipSlider.maximumValue = maxTip
        tipSlider.minimumValue = minTip
        
        if let slider = sender as? UISlider {
            defaultTip = round(slider.value / incrementStep) * incrementStep
            slider.value = defaultTip
        }
        
        let defaults = UserDefaults.standard
        defaults.set(minTip, forKey: "TIP_MIN")
        defaults.set(maxTip, forKey: "TIP_MAX")
        defaults.set(defaultTip, forKey: "TIP_DEFAULT")
        defaults.synchronize()
        
    }

}
