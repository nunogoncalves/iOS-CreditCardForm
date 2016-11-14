//
//  DatePicker.swift
//  CreditCard
//
//  Created by Nuno Gonçalves on 13/11/16.
//  Copyright © 2016 Nuno Gonçalves. All rights reserved.
//

import UIKit

class DatePicker : UIControl { //UIPickerView {
    
    fileprivate let earliestPresentedDate = Date(timeIntervalSince1970: -62167216995)  //Jan 1, 1
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
        return self.totalYears
    }()
    
    fileprivate (set) var date = Date()
    
    var minimumDate: Date? {
        didSet {
            minimumDate = minimumDate?.beginningOfMonth()
        }
    }
    var maximumDate: Date? {
        didSet {
            maximumDate = maximumDate?.endOfMonth()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
 
    func configure() {
        backgroundColor = .veryLightGray
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
        set(month: components.month!, animated: animated)
    }
}

extension DatePicker : UIPickerViewDataSource {
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
        dateLabel.textColor = .black
        
        let dateForRow = date(for: row, and: component)
        
        if !isInsideRange(dateForRow) {
            dateLabel.textColor = UIColor.lightGray
        }
        
        if component == yearComponent {
            dateLabel.text = "\(year(for: row))"
        } else {
            let monthStr = longMonthFormatter.string(from: shortMonthformatter.date(from: "\(month(for: row))")!)
            dateLabel.text = monthStr
        }
        
        return dateLabel
    }
}

extension DatePicker : UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let selectedDate = date(for: row, and: component)
        
        if !isInsideRange(selectedDate) {
            set(minimumDate!, animated: true)
            return
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
        if component == monthComponent {
            return yearMonthFormatter.date(from: "\(selectedYear.asStringPaddedWithZeros)-\(month(for: row))")!
        } else {
            return yearMonthFormatter.date(from: "\(year(for: row).asStringPaddedWithZeros)-\(selectedMonth)")!
        }
    }
    
    var selectedYear: Int {
        return picker.selectedRow(inComponent: yearComponent) + 1
    }
    
    var selectedMonth: Int {
        return month(for: picker.selectedRow(inComponent: monthComponent))
    }
    
    func set(year: Int, animated: Bool) {
        picker.selectRow(year - 1, inComponent: yearComponent, animated: animated)
    }
    
    func set(month: Int, animated: Bool) {
        picker.selectRow(selectedYear + month - 1, inComponent: monthComponent, animated: animated)
    }
    
    func year(for row: Int) -> Int {
        return row + 1
    }
    
    func month(for row: Int) -> Int {
        return (row % 12) + 1
    }
}

fileprivate extension Int {
    var asStringPaddedWithZeros: String {
        return String(format: "%04d", self)
    }
}
