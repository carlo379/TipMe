//
//  TipViewController.swift
//  TipMe
//
//  Created by Carlos Martinez on 8/15/17.
//  Copyright © 2017 Carlos Martinez. All rights reserved.
//

import UIKit

class TipViewController: UIViewController {
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var tipControl: UISegmentedControl!
    
    var tipPercentages = [Float]() {
        didSet {
            for i in 0..<tipPercentages.count {
                tipControl.setTitle(String(format: "%.0f", tipPercentages[i])+"%", forSegmentAt: i)
            }
        }
    }
    var minTip:Float!
    var maxTip:Float!
    var defaultTip:Float!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let defaults = UserDefaults.standard
        minTip =  Help().isKeyPresentInUserDefaults(key: "TIP_MIN") ? defaults.float(forKey: "TIP_MIN") : 10
        maxTip =  Help().isKeyPresentInUserDefaults(key: "TIP_MAX") ? defaults.float(forKey: "TIP_MAX") : 20
        defaultTip =  Help().isKeyPresentInUserDefaults(key: "TIP_DEFAULT") ? defaults.float(forKey: "TIP_DEFAULT") : 15
        tipPercentages = [minTip,defaultTip,maxTip]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onTap(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @IBAction func calculateTip(_ sender: Any) {
        
        let bill = Float(billField.text!) ?? 0
        let tip = bill * tipPercentages[tipControl.selectedSegmentIndex]
        let total = bill + tip
        
        tipLabel.text = String(format: "$%.2f", tip)
        totalLabel.text = String(format: "$%.2f", total)
    }
}
