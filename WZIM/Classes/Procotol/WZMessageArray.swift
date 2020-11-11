//
//  WZMessageArray.swift
//  WZIM
//
//  Created by qiuqixiang on 2020/11/11.
//

import Foundation

/// 自定义数据的ID
public protocol WZMessageCustomProtocol {
    
    /// 唯一Id
    func getMessageId() -> String
}

/// 消息详情自定义枚举
public enum WZMessageData {
    case msg(WZMessageProtocol)
    case time(WZIMTimeCustomElem)
    case custom(WZMessageCustomProtocol)
}

// MARK - 会话详情数组，处理时间
open class WZMessageArray {
    
    /// 数组
    public var array: [WZMessageData] = []
    
    /// 时间间隔：秒
    public var timeInterval: Int = 300
    
    /// 初始化
    public init(timeInterval: Int = 300) {
        self.timeInterval = timeInterval
    }
    
    /// 添加元素
    @discardableResult
    open func append(_ message: WZMessageData) -> [IndexPath] {
        
        /// 数组为空
        guard let last = array.last else {
            let list = [creatTime(date: Date()), message]
            array.append(contentsOf: list)
            return [array.count-2, array.count-1].indexPaths()
        }
        
        /// 时间间隔为5分钟
        if case let .msg(msg) = message, case let .msg(lastMsg) = last,isTimeinterval(current: msg.timeTamp, last: lastMsg.timeTamp) {
            let list = [creatTime(date: msg.timeTamp), message]
            array.append(contentsOf: list)
            return [array.count-2, array.count-1].indexPaths()
        }
        
        /// 时间间隔未有5分钟
        array.append(message)
        return [array.count-1].indexPaths()
    }
    
    /// 插入数据
    @discardableResult
    open func insert(contentsOf: [WZMessageData], at: Int) -> [WZMessageData] {
        
        var result = [WZMessageData]()
        for (index, item) in contentsOf.enumerated() {
            
            let last = index == 0 ? nil : contentsOf[index-1]
            
            if last == nil, case let .msg(elem) = item  {
                result.append(creatTime(date: elem.timeTamp))
            }else if case let .msg(msg) = item, case let .msg(lastMsg) = last, isTimeinterval(current: msg.timeTamp, last: lastMsg.timeTamp) {
                result.append(creatTime(date: lastMsg.timeTamp))
            }
            result.append(item)
        }
        array.insert(contentsOf: result, at: at)
        return result
    }
    
    /// 判断时间间隔
    private func isTimeinterval(current: Date, last: Date) -> Bool {
        let interval = Date.wzImGetTimeStamp(date: current) - Date.wzImGetTimeStamp(date: last)
        if interval > timeInterval {
            return true
        }
        return false
    }
    
    /// 移除数据 如果未找到返回NSNotFound
    @discardableResult
    open func remove(message: WZMessageData) -> [Int]{
        
        guard let row = firstIndex(message: message) else {
            return []
        }
        
        if row > 0, case .time = array[row-1] {
            array.remove(at: row)
            array.remove(at: row-1)
            
            return [row-1, row]
        }
        array.remove(at: row)
        return [row]
    }
    
    /// 根据消息查找位置
    open func firstIndex(message: WZMessageData) -> Int? {
    
        for (index, item) in array.enumerated() {
    
            if case let .msg(elem) = item, case let .msg(xelem) = message, elem.wzMessageId == xelem.wzMessageId {
                return index
            }else if case let .time(time) = item, case let .time(xtime) = message, time.time == xtime.time {
                return index
            }else if case let .custom(custom) = item, case let .custom(xcustom) = message, custom.getMessageId() == xcustom.getMessageId() {
                return index
            }
        }
        return nil
    }
    
    /// 判断是否含有某元素
    open func isContains(message: WZMessageData) -> Bool {
        
        if firstIndex(message: message) != nil {
            return true
        }
        return false
    }
    
    /// 创建时间
    func creatTime(date: Date) -> WZMessageData {
        let elem = WZIMTimeCustomElem(time: "\((date as  NSDate).timeIntervalSince1970)")
        return .time(elem)
    }
}


