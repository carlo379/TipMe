//
//  Help.swift
//  TipMe
//
//  Created by Carlos Martinez on 8/15/17.
//  Copyright © 2017 Carlos Martinez. All rights reserved.
//

import Foundation

class Help {
    
    func isKeyPresentInUserDefaults(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
}
