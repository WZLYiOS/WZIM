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
    
    /// 日期显示
    static func wzImDateText(_ time: String) -> String {
        let string = NSString(string: time)
        let timeSta: TimeInterval = string.doubleValue
        let date = Date(timeIntervalSince1970: timeSta)
        return date.wzImDate
    }
 
    /// 时间显示
    var wzImDate: String {
        let calendar = Calendar.current
        let unit: Set<Calendar.Component> = [ .year, .month, .day]
        let nowCmps = calendar.dateComponents(unit, from: Date())
        let myCmps = calendar.dateComponents(unit, from: self)
        let dateFmt = DateFormatter()
//        let compUnit: Set<Calendar.Component> = [ .year, .month, .day, .weekday]
//        let comp = calendar.dateComponents(compUnit, from: self)
        if (nowCmps.year != myCmps.year) {
            dateFmt.dateFormat = "yyyy年MM月dd日";
        }else{
            if (nowCmps.day==myCmps.day) {
                dateFmt.dateFormat = "HH:mm"
            }else{
                dateFmt.dateFormat = "MM月dd日 HH:mm"
            }
        }
        return dateFmt.string(from: self)
    }
}
