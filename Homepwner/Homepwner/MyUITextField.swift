//
//  MyUITextFiled.swift
//  Homepwner
//
//  Created by Павел Собянин on 23.10.17.
//  Copyright © 2017 pavel.sobyanin. All rights reserved.
//

import UIKit

class MyUITextField: UITextField {
    
    //var label: UITextField
    
    override func becomeFirstResponder() -> Bool {
        super.becomeFirstResponder()
        
        self.borderStyle = .line
        return true
    }
    
    override func resignFirstResponder() -> Bool {
        super.resignFirstResponder()
        
        self.borderStyle = .roundedRect
        return true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
