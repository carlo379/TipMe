//
//  SettingsViewController.swift
//  TipMe
//
//  Created by Carlos Martinez on 8/15/17.
//  Copyright © 2017 Carlos Martinez. All rights reserved.
//

import UIKit

protocol TipCalculatorThemeDelegate: class {
    func themeChanged(toTheme theme:Theme)
}

class SettingsViewController: UIViewController {
    // MARK: - Properties
    @IBOutlet weak var minTF: UITextField!
    @IBOutlet weak var maxTF: UITextField!
    @IBOutlet weak var tipSlider: UISlider!
    
    @IBOutlet weak var defaultTipLb: UILabel!
    @IBOutlet weak var titleLb: UILabel!
    @IBOutlet weak var minLb: UILabel!
    @IBOutlet weak var maxLb: UILabel!
    @IBOutlet weak var themeLb: UILabel!
    
    var tipCalc:TipCalc?
    let incrementStep = Float(1)
    
    @IBOutlet weak var themeSC: UISegmentedControl!
    @IBOutlet var backgroundView: UIView!
    // MARK: Protocol Delegate
    weak var delegate: TipCalculatorThemeDelegate?
    
    // MARK: - View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set Theme from UsersDefaults if available
        themeChanged(toTheme: ThemeManager.currentTheme())
        
        if  let min = tipCalc?.tipRangeValues[TipRange.min.rawValue],
            let def = tipCalc?.tipRangeValues[TipRange.def.rawValue],
            let max = tipCalc?.tipRangeValues[TipRange.max.rawValue] {
            
            minTF.text = String(format: K.StringFormat.tipLabels, min)
            maxTF.text = String(format: K.StringFormat.tipLabels, max)
            defaultTipLb.text = String(format: K.StringFormat.tipLabels, def)+"%"
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
        defaultTipLb.text = String(format: K.StringFormat.tipLabels, tipSlider.value)+"%"
        
        let defaults = UserDefaults.standard
        defaults.set(tipCalc?.tipRangeValues[TipRange.min.rawValue], forKey: K.KeyUserDefault.min)
        defaults.set(tipCalc?.tipRangeValues[TipRange.def.rawValue], forKey: K.KeyUserDefault.def)
        defaults.set(tipCalc?.tipRangeValues[TipRange.max.rawValue], forKey: K.KeyUserDefault.max)

        defaults.synchronize()
        
    }

    @IBAction func themeChanged(_ sender: UISegmentedControl) {
        view.endEditing(true)
        if let theme = Theme(rawValue: themeSC.selectedSegmentIndex) {
            delegate?.themeChanged(toTheme: theme)
            ThemeManager.storeThemeSelection(theme)
            themeChanged(toTheme: theme)
        }
    }
    
    private func themeChanged(toTheme theme:Theme){
        backgroundView.backgroundColor = theme.mainColor
        themeSC.backgroundColor = theme.mainColor
        minTF.backgroundColor = theme.mainColor
        maxTF.backgroundColor = theme.mainColor
        minTF.keyboardAppearance = theme == .light ?  UIKeyboardAppearance.light : UIKeyboardAppearance.dark
        maxTF.keyboardAppearance = theme == .light ?  UIKeyboardAppearance.light : UIKeyboardAppearance.dark
        
        maxTF.tintColor = theme.textColor
        minTF.tintColor = theme.textColor
        minTF.textColor = theme.textColor
        maxTF.textColor = theme.textColor
        tipSlider.thumbTintColor = theme.textColor
        defaultTipLb.textColor = theme.textColor
        titleLb.textColor = theme.textColor
        minLb.textColor = theme.textColor
        maxLb.textColor = theme.textColor
        themeLb.textColor = theme.textColor
        themeSC.tintColor = theme.textColor
    }
}
