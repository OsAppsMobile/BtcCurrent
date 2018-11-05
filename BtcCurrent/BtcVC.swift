//
//  ViewController.swift
//  BtcCurrent
//
//  Created by Osman Dönmez on 5.11.2018.
//  Copyright © 2018 Osman Dönmez. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class BtcVC: UIViewController {

    
    typealias CompletionHandler = (_ Success: Bool) -> ()
    
    @IBOutlet weak var currencyPicker: UIPickerView!
    @IBOutlet weak var bitcoinPriceLabel: UILabel!
    
    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","TRY","ZAR"]
    let currencySymbolArray = ["$", "R$", "$", "¥", "€", "£", "$", "Rp", "₪", "₹", "¥", "$", "kr", "$", "zł", "lei", "₽", "kr", "$", "$","₺","R"]
    var finalURL = ""
    var btcValue: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
    }

    func getBtcValueOfSelectedCurrency(url: String, completion: @escaping CompletionHandler) {
        
        Alamofire.request(url, method: .get).responseJSON { (response) in
            if response.result.error == nil {
                guard let json = response.result.value as? Dictionary<String, AnyObject> else { return }
                let value = json["last"] as! Double
                self.btcValue = String(describing: value)
                //self.bitcoinPriceLabel.text = String(describing: value)
                completion(true)
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
}

extension BtcVC: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        finalURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC\(currencyArray[row])"
        getBtcValueOfSelectedCurrency(url: finalURL) { (success) in
            if success {
                self.bitcoinPriceLabel.text = self.currencySymbolArray[row] + self.btcValue
            } else {
                print("Connection Error!")
            }
        }
    }
}
