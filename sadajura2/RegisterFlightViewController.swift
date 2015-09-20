//
//  RegisterFlightViewController.swift
//  sadajura
//
//  Created by 佐藤一輝 on 2015/09/19.
//  Copyright © 2015年 whomentors. All rights reserved.
//

import UIKit

class RegisterFlightViewController: UIViewController {

    //outlet
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var toLabel: UILabel!
    @IBOutlet var fromLabel: UILabel!
    @IBOutlet var dateTextField: UITextField!
    @IBOutlet var fromTextField: UITextField!
    @IBOutlet var toTextField: UITextField!
    
    //variable
    private var myUIPicker: UIPickerView!
    private var myDatePicker: UIDatePicker!
    private let myValues: NSArray = ["San Francisco","Tokyo","Corean","China"]
    var textActiveField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myDatePicker = UIDatePicker()
        myUIPicker = UIPickerView()
        
        myDatePicker.datePickerMode = UIDatePickerMode.Date
        myUIPicker.delegate = self
        myUIPicker.dataSource = self
        
        dateTextField.delegate = self
        fromTextField.delegate = self
        toTextField.delegate = self
        
        dateTextField.inputView = myDatePicker
        fromTextField.inputView = myUIPicker
        toTextField.inputView = myUIPicker
        
        let tap = UITapGestureRecognizer(target: self, action: Selector("closeKeyboard"))
        self.view.addGestureRecognizer(tap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func closeKeyboard(){
        self.view.endEditing(true)
    }
    
}

extension RegisterFlightViewController :UITextFieldDelegate{
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        textActiveField = textField
        return true
    }
}

extension RegisterFlightViewController :UIPickerViewDelegate {
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return myValues[row] as? String
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("value: \(myValues[row])")
        switch self.textActiveField{
            case self.dateTextField:
                break
            case self.fromTextField:
                self.fromTextField.text = myValues[row] as? String
                break
            case self.toTextField:
                self.toTextField.text = myValues[row] as? String
                break
            default:
                break
        }
    }
}

extension RegisterFlightViewController :UIPickerViewDataSource {
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return myValues.count
    }
}
