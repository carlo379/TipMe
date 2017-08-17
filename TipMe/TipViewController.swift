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
        
        // Restore Bill if recent
        restoreBillIfRecent()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Get values from UsersDefaults when comming from Settings
        let tips = getTipRangeFromUsersDefaults()
        
        // Set Calculator Range Values (Min, Default, Max)
        tipCalc.setTipRangeValues(min:tips.min, def:tips.defVal, max:tips.max)
        
        // Set Segmented Control Values and Labels
        setSegmentedControl(tipControl, withValues: tips)
        
        // Make the bill field the first responder
        billField.becomeFirstResponder()
    }
    
    // MARK: - IBActions
    @IBAction func calculateTip(_ sender: Any) {
        
        // Calculate Tip and Bill Total
        let (tip,total) = tipCalc.getTipAndTotal(fromBill: Float(billField.text!) ?? 0,
                                                 andPercentage: tipCalc.tipRangeValues[tipControl.selectedSegmentIndex])
        
        // Update UI with calculated information
        tipLabel.text = tip.asLocalizedCurrency
        totalLabel.text = total.asLocalizedCurrency
    }
    
     // MARK: - Navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.Segue.tipToSettings {
            if let settingsVC = segue.destination as? SettingsViewController {
                
                // Inject 'tipCalc' into settings view controller
                settingsVC.tipCalc = tipCalc
            }
        }
     }
    
    // MARK: - View Controller Helper Functions
    private func setSegmentedControl(_ segmentedControl: UISegmentedControl, withValues values:(Float,Float,Float)){
        segmentedControl.setTitle(String(format: K.StringFormat.segmentCtrl, values.0)+"%", forSegmentAt: TipRange.min.rawValue)
        segmentedControl.setTitle(String(format: K.StringFormat.segmentCtrl, values.1)+"%", forSegmentAt: TipRange.def.rawValue)
        segmentedControl.setTitle(String(format: K.StringFormat.segmentCtrl, values.2)+"%", forSegmentAt: TipRange.max.rawValue)
    }
    
    private func getTipRangeFromUsersDefaults()->(min:Float,defVal:Float,max:Float) {
        let defaults = UserDefaults.standard
        
        // Get user stored values or default values
        // Using Constants (K) from 'Constants.swift' file
        let minTip =  Help().isKeyPresentInUserDefaults(key: K.KeyUserDefault.min) ? defaults.float(forKey: K.KeyUserDefault.min) : K.TipDefault.min
        let defTip =  Help().isKeyPresentInUserDefaults(key: K.KeyUserDefault.def) ? defaults.float(forKey: K.KeyUserDefault.def) : K.TipDefault.def
        let maxTip =  Help().isKeyPresentInUserDefaults(key: K.KeyUserDefault.max) ? defaults.float(forKey: K.KeyUserDefault.max) : K.TipDefault.max
        
        // return values in a tuple
        return (minTip, defTip, maxTip)
    }
    
    private func restoreBillIfRecent(){
        let defaults = UserDefaults.standard

        // Check if Keys exists
        if  let dateInactive = defaults.object(forKey: K.KeyUserDefault.dateInactive) as? Date,
            let bill = defaults.string(forKey: K.KeyUserDefault.bill){
            
            if let diff = Calendar.current.dateComponents([.minute], from: dateInactive, to: Date()).minute, diff < K.Time.rememberBill {
                billField.text = bill
                calculateTip(self)
            } else {
                defaults.removeObject(forKey:K.KeyUserDefault.dateInactive)
                defaults.removeObject(forKey:K.KeyUserDefault.bill)
            }
        }
    }
}
