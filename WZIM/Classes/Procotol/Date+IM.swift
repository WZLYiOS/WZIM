//
//  Date+IM.swift
//  WZIM
//
//  Created by qiuqixiang on 2020/9/16.
//

import Foundation

/// IM 时间显示
public extension Date {
    
    /// 时间戳转时间
    /// - Parameter stringTime: 时间戳
    /// - Parameter formatterStr: 时间格式
    static func wzImTimeStampToString(timeStamp: String, formatterStr: String = "yyyy年MM月dd日") ->String {
        let string = NSString(string: timeStamp)
        let timeSta: TimeInterval = string.doubleValue
        let dfmatter = DateFormatter()
        dfmatter.dateFormat = formatterStr
        let date = Date(timeIntervalSince1970: timeSta)
        return dfmatter.string(from: date)
    }
    
    /// 当前时间转化成时间戳：秒
    static func wzImGetTimeStamp(date: Date = Date()) ->Int {
        let timeInterval: TimeInterval = date.timeIntervalSince1970
        let timeStamp = Int(timeInterval)
        return timeStamp
    }
}
