//
//  TipViewController.swift
//  TipMe
//
//  Created by Carlos Martinez on 8/15/17.
//  Copyright © 2017 Carlos Martinez. All rights reserved.
//

import UIKit
import GameKit

class TipViewController: UIViewController {
    // MARK: - Properties
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var billField: UITextField!
    
    @IBOutlet weak var tipTitleLb: UILabel!
    @IBOutlet weak var billTitleLb: UILabel!
    @IBOutlet weak var totalTitleLb: UILabel!
    
    @IBOutlet weak var tipLineView: UIView!
    @IBOutlet weak var totalLineView: UIView!
    @IBOutlet weak var billLineView: UIView!
    
    @IBOutlet weak var settingBtn: UIBarButtonItem!
    
    
    // Tip Labels
    @IBOutlet weak var sadLb: UILabel!
    @IBOutlet weak var okLb: UILabel!
    @IBOutlet weak var happyLb: UILabel!
    @IBOutlet weak var randLb: UILabel!
    var tipLabels:[UILabel]!    // Unwrapped because it is initialized on 'viewDidLoad'
    
    // Tip Buttons
    @IBOutlet weak var sadBtn: UIButton!
    @IBOutlet weak var okBtn: UIButton!
    @IBOutlet weak var happyBtn: UIButton!
    @IBOutlet weak var randBtn: UIButton!
    
    var tipCalc:TipCalc!    // Unwrapped because it is initialized on 'viewDidLoad'
    var selectedBtnFrame: CGRect?
    var selectedBtn: UIButton? {
        didSet {
            if oldValue == nil {
                okLb.font = UIFont.systemFont(ofSize:12)
            }
        }
    }
    
    @IBOutlet var backgroundView: UIView!
    
    // MARK: - View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get values from UsersDefaults on first launch
        let tips = getTipRangeFromUsersDefaults()
        
        // Initialize Calculator Model
        tipCalc = TipCalc(withMinTip: tips.min, maxTip: tips.max, defaultTip: tips.defVal)
        
        // Restore Bill if recent
        restoreBillIfRecent()
        
        // Store Tip Labels in property arrray
        tipLabels = [sadLb,okLb,happyLb,randLb]
        
        // Set Theme from UsersDefaults if available
        themeChanged(toTheme: ThemeManager.currentTheme())
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Get values from UsersDefaults when comming from Settings
        let tips = getTipRangeFromUsersDefaults()
        
        // Set Calculator Range Values (Min, Default, Max)
        tipCalc.setTipRangeValues(min:tips.min, def:tips.defVal, max:tips.max)
        
        // Set Segmented Control Values and Labels
        setTipButtonsAndLbs(withValues: tips)
        
        // Make the bill field the first responder
        billField.becomeFirstResponder()
    }
    
    // MARK: - IBActions
    @IBAction func calculateTip(_ sender: AnyObject) {

        // Animate Selection of Buttons
        if sender is UIButton {
            animateSelection(ofButton:sender as! UIButton)
        }
        
        var percentage:Float!   // Unwrapped because all possible cases covered in switch
        
        switch sender.tag {
        case 0,1,2:
            percentage = tipCalc.tipRangeValues[sender.tag]
        case 3:
            percentage = randTip()
            tipCalc.tipRangeValues[TipRange.rand.rawValue] = Float(percentage)
            randLb.text = String(format: K.StringFormat.tipLabels, Float(percentage))+"%"

        default:
            percentage = selectedBtn != nil ? tipCalc.tipRangeValues[(selectedBtn!.tag)] : tipCalc.tipRangeValues[TipRange.def.rawValue]
        }

        guard let text = billField.text, let bill = Float(text) else { return }

        // Calculate Tip and Bill Total
        let (tip,total) = tipCalc.getTipAndTotal(fromBill: bill, andPercentage: percentage)
        
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
                settingsVC.delegate = self
            }
        }
     }
    
    // MARK: - View Controller Helper Functions
    private func setTipButtonsAndLbs(withValues values:(Float,Float,Float)){
        sadLb.text = String(format: K.StringFormat.tipLabels, values.0)+"%"
        okLb.text = String(format: K.StringFormat.tipLabels, values.1)+"%"
        happyLb.text = String(format: K.StringFormat.tipLabels, values.2)+"%"
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
    
    private func randTip()->Float {
        let min = Int(tipCalc.tipRangeValues[TipRange.def.rawValue]!)
        let max = Int(tipCalc.tipRangeValues[TipRange.max.rawValue]!)
        
        let randomNum = GKRandomDistribution(lowestValue:min , highestValue:max ).nextInt()
        return Float(randomNum)
    }
    
    private func animateSelection(ofButton button: UIButton) {
        
        let regFrame = button.frame

        // Restore previously selected button to origina state
        if  let frame = self.selectedBtnFrame,
            let selBtn = self.selectedBtn,
            let label = self.tipLabels?[selBtn.tag] {
            
            UIView.animate(withDuration: 0.5, animations: {
                
                selBtn.frame = frame
                label.font = UIFont.systemFont(ofSize: 12)
                
            }, completion: { (done) in
                self.selectedBtn = button
                self.selectedBtnFrame = regFrame
                if selBtn.tag == TipRange.rand.rawValue {
                    self.randLb.text = K.Percentage.unknown
                }
            })
        }

        let deltaSmall = CGFloat(2)
        let smallFrame = CGRect(x: regFrame.origin.x + deltaSmall,
                                y: regFrame.origin.y + deltaSmall,
                                width: regFrame.width - (deltaSmall * 2),
                                height: regFrame.height - (deltaSmall * 2))
        
        let deltaLarge = CGFloat(4)
        let largeFrame = CGRect(x: regFrame.origin.x - deltaLarge,
                                y: regFrame.origin.y - deltaLarge,
                                width: regFrame.width + (deltaLarge * 2),
                                height: regFrame.height + (deltaLarge * 2))
        
        let deltaHighlight = CGFloat(4)
        let highlightFrame = CGRect(x: regFrame.origin.x - deltaHighlight,
                                    y: regFrame.origin.y - deltaHighlight,
                                    width: regFrame.width + (deltaHighlight * 2),
                                    height: regFrame.height + (deltaHighlight * 2))

        // Animate in stages
        UIView.animateKeyframes(withDuration: 0.5, delay: 0, options: .calculationModeCubic, animations: {
            
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: (0.5/3)) {
                button.frame = smallFrame
            }
            
            UIView.addKeyframe(withRelativeStartTime: (0.5/3), relativeDuration: (0.5/3)) {
                button.frame = largeFrame
            }
            
            UIView.addKeyframe(withRelativeStartTime: (1/3), relativeDuration: (0.5/3)) {
                button.frame = highlightFrame
            }
            
        }, completion: { (done) in

            
            self.selectedBtn = button
            self.selectedBtnFrame = regFrame
            
            if let label = self.tipLabels?[button.tag] {
                
                DispatchQueue.main.async {
                    label.font = UIFont.boldSystemFont(ofSize: 16)
                }
            }
        })
    }
}

extension TipViewController: TipCalculatorThemeDelegate {
    
    func themeChanged(toTheme theme:Theme){
        // Bkg Colors
        backgroundView.backgroundColor = theme.mainColor
        sadBtn.backgroundColor = theme.mainColor
        okBtn.backgroundColor = theme.mainColor
        happyBtn.backgroundColor = theme.mainColor
        randBtn.backgroundColor = theme.mainColor
        billField.backgroundColor = theme.mainColor

        // Change Text Color
        tipLabel.textColor = theme.textColor
        totalLabel.textColor = theme.textColor
        billField.textColor = theme.textColor
        sadLb.textColor = theme.textColor
        okLb.textColor = theme.textColor
        happyLb.textColor = theme.textColor
        randLb.textColor = theme.textColor
        sadBtn.tintColor = theme.textColor
        okBtn.tintColor = theme.textColor
        happyBtn.tintColor = theme.textColor
        randBtn.tintColor = theme.textColor
        tipTitleLb.textColor = theme.textColor
        billTitleLb.textColor = theme.textColor
        totalTitleLb.textColor = theme.textColor
        tipLineView.backgroundColor = theme.textColor
        totalLineView.backgroundColor = theme.textColor
        billLineView.backgroundColor = theme.textColor
        billField.keyboardAppearance = theme == .light ?  UIKeyboardAppearance.light : UIKeyboardAppearance.dark
    }

}
