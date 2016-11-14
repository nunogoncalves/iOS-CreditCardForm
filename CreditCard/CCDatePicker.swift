//
//  CCDatePicker.swift
//  CreditCard
//
//  Created by Nuno Gonçalves on 13/11/16.
//  Copyright © 2016 Nuno Gonçalves. All rights reserved.
//

import UIKit

class CCDatePicker : UIControl { //UIPickerView {
    
    fileprivate let earliestPresentedDate = Date(timeIntervalSince1970: 0)
    fileprivate lazy var earliestComponents: DateComponents = {
        return self.calendar.dateComponents([.year, .month], from: self.earliestPresentedDate)
    }()
    
    fileprivate lazy var earliestYear: Int = {
        return self.calendar.dateComponents([.year], from: self.earliestPresentedDate).year!
    }()
    
    fileprivate lazy var earliestMonth: Int = {
        return self.calendar.dateComponents([.month], from: self.earliestPresentedDate).month!
    }()
    
    let shortMonthformatter = DateFormatter(format: "MM")
    let longMonthFormatter = DateFormatter(format: "MMMM")
    fileprivate let yearMonthFormatter = DateFormatter(format: "yyyy-MM")
    
    fileprivate var calendar: Calendar!
    fileprivate var picker: UIPickerView!
    
    fileprivate let monthComponent = 0
    fileprivate let yearComponent = 1
    
    fileprivate lazy var totalYears: Int = {
        return 10000 - self.earliestYear
    }()

    fileprivate lazy var totalMonths: Int = {
        return self.totalYears * 12
    }()
    
    fileprivate (set) var date = Date()
    
    var minimumDate: Date?
    var maximumDate: Date?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
 
    func configure() {
        backgroundColor = .lightGray
        calendar = Calendar(identifier: .gregorian)
        picker = UIPickerView()
        addSubview(picker)
        picker.topAnchor.constraint(equalTo: topAnchor).isActive = true
        picker.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        picker.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        picker.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        picker.translatesAutoresizingMaskIntoConstraints = false
        
        picker.dataSource = self
        picker.delegate = self
        
        set(date, animated: true)
    }

    
    func set(_ date: Date, animated: Bool) {
        let components: DateComponents = calendar.dateComponents([.year, .month], from: date)
       
        set(year: components.year!, animated: animated)
        set(month: components.month!, with: components.year!, animated: animated)
    }
}

extension CCDatePicker : UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == yearComponent {
            return totalYears
        } else {
            return totalMonths
        }
    }
   
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let dateLabel = UILabel()
        dateLabel.font = UIFont.systemFont(ofSize: 22)
        dateLabel.textAlignment = .center
        
        let dateForRow = date(for: row, and: component)
        if component == monthComponent {
            print("view: ", row, row % 12)
            print(dateForRow)
        }
        dateLabel.textColor = UIColor.black
        
//        if !isInsideRange(dateForRow) {
//            dateLabel.textColor = UIColor.darkGray
//        }
        
        if component == yearComponent {
            dateLabel.text = "\(earliestYear + row)"
        } else {
            let month = row % 12 + 1
            let monthStr = longMonthFormatter.string(from: shortMonthformatter.date(from: "\(month)")!)
            dateLabel.text = monthStr
        }
        
        return dateLabel
    }
}

extension CCDatePicker : UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let selectedDate: Date
        if component == yearComponent {
            let selectedMonth = month(for: pickerView.selectedRow(inComponent: monthComponent))
            selectedDate = yearMonthFormatter.date(from: "\(year(for: row))-\(selectedMonth)")!
        } else {
            let selectedYear = year(for: pickerView.selectedRow(inComponent: yearComponent))
            let selectedMonth = month(for: row)
            selectedDate = yearMonthFormatter.date(from: "\(selectedYear)-\(selectedMonth)")!
        }
        
        if isBeforeMinimum(selectedDate) {
            set(minimumDate!, animated: true)
            return
        }
        
        if isAfterMaximum(selectedDate) {
            set(maximumDate!, animated: true)
        }

        date = selectedDate
        sendActions(for: UIControlEvents.valueChanged)
        
    }
    
    func isBeforeMinimum(_ date: Date) -> Bool {
        guard let minimumDate = minimumDate else { return false }
        return minimumDate.timeIntervalSinceNow > date.timeIntervalSinceNow
    }
    
    func isAfterMaximum(_ date: Date) -> Bool {
        guard let maximumDate = maximumDate else { return false }
        return maximumDate.timeIntervalSinceNow < date.timeIntervalSinceNow
    }
    
    func isInsideRange(_ date: Date) -> Bool {
        return !isAfterMaximum(date) && !isBeforeMinimum(date)
    }

    func date(for row: Int, and component: Int) -> Date {
        
        let _year: Int
        let _month: Int
        
        if component == monthComponent {
            _year = year(for: row / 12)
            _month = month(for: row)
        } else {
            _year = year(for: row)
            _month = (row % 12) + 1
        }
        return yearMonthFormatter.date(from: "\(_year)-\(_month)")!
    }
    
    func selectedYear() -> Int {
        return year(for: picker.selectedRow(inComponent: yearComponent))
    }
    
    func selectedMonth() -> Int {
        return month(for: picker.selectedRow(inComponent: monthComponent))
    }
    
    func set(year: Int, animated: Bool) {
        let row = year - earliestYear
        picker.selectRow(row, inComponent: yearComponent, animated: animated)
    }
    
    func set(month: Int, with year: Int, animated: Bool) {
        picker.selectRow((((year - earliestYear) * 12) + month - 1), inComponent: monthComponent, animated: animated)
    }
    
    func year(for row: Int) -> Int {
        return earliestYear + row
    }
    
    func month(for row: Int) -> Int {
        return (row % 12) + 1
    }
}
