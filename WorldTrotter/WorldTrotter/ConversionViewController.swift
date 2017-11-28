//
//  ConversionViewController.swift
//  WorldTrotter
//
//  Created by Павел Собянин on 09.02.17.
//  Copyright © 2017 pavel.sobyanin. All rights reserved.
//

import UIKit

class ConversionViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var celsiusLabel: UILabel!
    @IBOutlet var textField: UITextField!
    
    func textField (_ textField: UITextField,
                    shouldChangeCharactersIn range: NSRange,
                    replacementString string: String) -> Bool {
        //print ("Current text: \(textField.text)")
        //print ("Replacement text: \(string)")
        
        //return true
        
        //let nonDecimals = NSCharacterSet.decimalDigits.inverted
        let decimals = NSCharacterSet.decimalDigits
        //let controls = NSCharacterSet.controlCharacters
        
        
        
        let currentLocale = Locale.current
        let decimalSeparator = currentLocale.decimalSeparator ?? "."
        
        let existingTextHasDecimalSeparator = textField.text?.range(of: decimalSeparator)
        let replacementTextHasDecimalSeparator = string.range(of: decimalSeparator)
        
        let replacementTextHasDecimal = string.rangeOfCharacter(from: decimals)
        if existingTextHasDecimalSeparator != nil, replacementTextHasDecimalSeparator != nil {
            return false
        }
        
        if replacementTextHasDecimal != nil || string.isEmpty || replacementTextHasDecimalSeparator != nil {
            return true
        }
        
        return false
        //let
    }
    
    let numberFomatter: NumberFormatter = {
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        nf.minimumFractionDigits = 0
        nf.maximumFractionDigits = 2
        return nf
    }()
    
    var fahrenheitValue: Measurement<UnitTemperature>? {
        //didSet {
        didSet {
            updateCelsiusLabel()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Conversion Controller loaded its view")
        
        updateCelsiusLabel()
    }
    
   /* override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // var backgroundcolor = self.view.backgroundColor
        
        let currentSecond = Calendar.current.component(.second, from: Date())
        print(currentSecond)
        
        view.backgroundColor = currentSecond % 2 != 0 ? UIColor.darkGray : UIColor.blue
        
        updateCelsiusLabel()
        
    } */
    
    var celsiusValue: Measurement<UnitTemperature>? {
        if let fahrenheitValue = fahrenheitValue {
            return fahrenheitValue.converted(to: .celsius)
        }
        else {
            return nil
        }
    }
    
    func updateCelsiusLabel() {
        if let celsiusValue = celsiusValue {
            //celsiusLabel.text = "\(celsiusValue.value)"
            celsiusLabel.text = numberFomatter.string(from: NSNumber(value: celsiusValue.value))
        }
        else {
            celsiusLabel.text = "???"
            //celsiusLabel.text.textColor = celsiusLabel.backgroundColor
            //celsiusLabel.textColor = UIColor.lightGray
        }
    }
    
    @IBAction func fahrenheitFieldEditingChanged(_ textField: UITextField) {
        // celsiusLabel.text = textField.text
        
        /*if let text = textField.text, !text.isEmpty {
            celsiusLabel.text = textField.text
        }
        else {
            celsiusLabel.text = "NULL"
        } */
        
        if let text = textField.text, let value = numberFomatter.number(from: text) {
            fahrenheitValue = Measurement(value: value.doubleValue, unit: .fahrenheit)
        }
        else {
            fahrenheitValue = nil
        }
    }
    
    @IBAction func dismissKeyboard (_ sender: UIGestureRecognizer) {
        textField.resignFirstResponder()
    }
    
}
