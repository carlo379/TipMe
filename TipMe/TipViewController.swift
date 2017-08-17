//
//  TipViewController.swift
//  TipMe
//
//  Created by Carlos Martinez on 8/15/17.
//  Copyright © 2017 Carlos Martinez. All rights reserved.
//

import UIKit

class TipViewController: UIViewController {
    // MARK: - Properties
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var tipControl: UISegmentedControl!
    
    var tipCalc:TipCalc! // Unwrapped because it is initialized on 'viewDidLoad'
    
    // MARK: - View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get values from UsersDefaults on first launch
        let tips = getTipRangeFromUsersDefaults()
        
        // Initialize Calculator Model
        tipCalc = TipCalc(withMinTip: tips.min, maxTip: tips.max, defaultTip: tips.defVal)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Get values from UsersDefaults when comming from Settings
        let tips = getTipRangeFromUsersDefaults()
        
        // Set Calculator Range Values (Min, Default, Max)
        tipCalc.setTipRangeValues(min:tips.min, def:tips.defVal, max:tips.max)
        
        // Set Segmented Control Values and Labels
        setSegmentedControl(tipControl, withValues: tips)
    }
    
    // MARK: - IBActions
    @IBAction func onTap(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @IBAction func calculateTip(_ sender: Any) {
        
        // Calculate Tip and Bill Total
        let (tip,total) = tipCalc.getTipAndTotal(fromBill: Float(billField.text!) ?? 0,
                                                 andPercentage: tipCalc.tipRangeValues[tipControl.selectedSegmentIndex])
        
        // Update UI with calculated information
        tipLabel.text = String(format: "$%.2f", tip)
        totalLabel.text = String(format: "$%.2f", total)
        
    }
    
     // MARK: - Navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TipToSettingsSegue" {
            if let settingsVC = segue.destination as? SettingsViewController {
                
                // Inject 'tipCalc' into settings view controller
                settingsVC.tipCalc = tipCalc
            }
        }
     }
 
    
    // MARK: - View Controller Helper Functions
    private func setSegmentedControl(_ segmentedControl: UISegmentedControl, withValues values:(Float,Float,Float)){
        segmentedControl.setTitle(String(format: "%.0f", values.0)+"%", forSegmentAt: 0)
        segmentedControl.setTitle(String(format: "%.0f", values.1)+"%", forSegmentAt: 1)
        segmentedControl.setTitle(String(format: "%.0f", values.2)+"%", forSegmentAt: 2)
    }
    
    private func getTipRangeFromUsersDefaults()->(min:Float,defVal:Float,max:Float) {
        let defaults = UserDefaults.standard
        
        // Get user stored values or default values
        let minTip =  Help().isKeyPresentInUserDefaults(key: "TIP_MIN") ? defaults.float(forKey: "TIP_MIN") : 10
        let maxTip =  Help().isKeyPresentInUserDefaults(key: "TIP_MAX") ? defaults.float(forKey: "TIP_MAX") : 20
        let defTip =  Help().isKeyPresentInUserDefaults(key: "TIP_DEFAULT") ? defaults.float(forKey: "TIP_DEFAULT") : 15
        
        // return values in a tuple
        return (minTip, defTip, maxTip)
    }
}
