//
//  ViewController.swift
//  Currency converter
//
//  Created by Павел Собянин on 20.02.17.
//  Copyright © 2017 pavel.sobyanin. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var pickerFrom: UIPickerView!
    @IBOutlet weak var pickerTo: UIPickerView!
    @IBOutlet weak var activityIndecator: UIActivityIndicatorView!
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView === pickerTo {
            return self.currenciesExceptBase().count
        }
        return currencies.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView === pickerTo {
            return self.currenciesExceptBase()[row]
        }
        return currencies[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView === pickerFrom{
            self.pickerTo.reloadAllComponents()
        }
        
        //self.requestCurrentCurrencyRate()
        calculateCurrencyRate()
        

    }
    
    func calculateCurrencyRate(/*baseCurrency: String, toCurrency: String*/) {
        //var value: Double = 0
        let baseCurrencyIndex = self.pickerFrom.selectedRow(inComponent: 0)
        let toCurrencyIndex = self.pickerTo.selectedRow(inComponent: 0)
        
        let baseCurrency = self.currencies[baseCurrencyIndex]
        let toCurrency = self.currenciesExceptBase()[toCurrencyIndex]
        
        if let rateToCurrency = rates[toCurrency], let rateBaseCurrency = rates[baseCurrency] {
            let ratio = rateToCurrency / rateBaseCurrency
            let value = numberFomatter.string(from: NSNumber(value: ratio))
            self.label.text = value
        }
        else {
            requestCurrentCurrencyRate()
        }
        
    }
    
    var currencies = ["RUB", "USD", "EUR", "GBP", "CNY", "AUD"]
    var rates = [String: Double]()
    
    let numberFomatter: NumberFormatter = {
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        nf.minimumFractionDigits = 0
        nf.maximumFractionDigits = 3
        nf.roundingMode = .down
        return nf
    }()

    //var currencies = [String]()
    
    
    func requestCurrentCurrencyRate(/*baseCurrency: String, toCurrency: String*/) {
        
        self.activityIndecator.startAnimating()
        self.label.text = ""
        //self.label.text = "NULL"
        //self.label.textColor = self.label.backgroundColor
        
        
        self.retrieveCurrencyRate(/*baseCurrency: baseCurrency, toCurrency: toCurrency*/) {[ weak self] (value) in
            DispatchQueue.main.async (
                execute: {
                    if let strongSelf = self {
                        strongSelf.label.text = value
                        strongSelf.activityIndecator.stopAnimating()
                    }
                }
            )
        }
    }
    
    func retrieveCurrencyRate (/*baseCurrency: String, toCurrency: String,*/ completion: @escaping (String) -> Void) {
        self.requestCurrencyRates() {[weak self] (data, error) in
            var string = "No currency retrieved"
            
            if let currentError = error {
                string = currentError.localizedDescription
            }
            else {
                if let strongSelf = self {
                    string = strongSelf.parseCurrencyRateResponse(data: data /*, toCurrency: toCurrency*/)
                }
            }
            
            completion(string)
        }
    }
    
    func requestCurrencyRates (parseHandler: @escaping (Data?, Error?) -> Void) {
        //let url = URL(string: "https://api.fixer.io/latest?base=" + baseCurrency)!
        
        let url = URL(string: "https://api.fixer.io/latest")!
        
        let dataTask = URLSession.shared.dataTask(with: url) {
            (dataRecieved, response, error) in
            parseHandler(dataRecieved, error)
        }
        dataTask.resume()

    }
    
    func parseCurrencyRateResponse (data: Data? /*, toCurrency: String*/) -> String {
        var value: String
        do {
            let json = try JSONSerialization.jsonObject(with: data!, options: []) as? Dictionary<String, Any>
            
            if let parsedJSON = json {
                //print ("\(parsedJSON)")
                //print("\(toCurrency)")
                if let rates = parsedJSON["rates"] as? Dictionary<String, Double> {
                    
                    self.rates = rates
                    self.rates["EUR"] = 1

                    self.currencies = self.rates.keys.sorted()
                    
                    self.pickerFrom.reloadAllComponents()
                    if let rate = rates[currencies[0]]
                    {
                        value = "\(rate)"
                    }
                    else {
                        value = "No rate for curreny USD found"
                    }
                }
                else {
                    value = "No rates field found"
                }
            }
            else {
                value = "No JSON field parsed"
            }
        }
        catch {
            value = error.localizedDescription
        }
        
        return value
    }
    
    
    func currenciesExceptBase() -> [String] {
        var currenciesExceptBase = currencies
        currenciesExceptBase.remove(at: pickerFrom.selectedRow(inComponent: 0))
        
        return currenciesExceptBase
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.pickerTo.dataSource = self
        self.pickerFrom.dataSource = self
        
        self.pickerTo.delegate = self
        self.pickerFrom.delegate = self
 
        self.activityIndecator.hidesWhenStopped = true
        //self.requestCurrentCurrencyRate()
        //calculateCurrencyRate()
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        requestCurrentCurrencyRate()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

