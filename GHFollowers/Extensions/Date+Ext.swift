//
//  Date+Ext.swift
//  GHFollowers
//
//  Created by Pratyusha Joginipally on 11/8/23.
//

import Foundation

extension Date {

  func convertToMonthYearFormat() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MMM yyyy"
    return dateFormatter.string(from: self)
  }
}
