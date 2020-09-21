//
//  WZMMessageList.swift
//  WZIM
//
//  Created by qiuqixiang on 2020/9/16.
//

import Foundation

// MARK - 会话详情数组，处理时间
open class WZMMessageArray {
    
    /// 代理
    public var delegete: WZMMessageArrayDelegate!
    
    /// 数组
    public var array: [WZMessageProtocol] = []
    
    /// 时间间隔：秒
    public var timeInterval: Int = 300
    
    /// 初始化
    public init(delegete: WZMMessageArrayDelegate) {
        self.delegete = delegete
    }
    
    /// 添加元素
    @discardableResult
    open func append(_ message: WZMessageProtocol) -> [IndexPath] {
        
        /// 数组为空
        guard let last = array.last else {
            let list = [delegete.messageArray(arry: self, date: Date()), message]
            array.append(contentsOf: list)
            return [array.count-2, array.count-1].indexPaths()
        }
        
        /// 时间间隔为5分钟
        if isTimeinterval(current: message.timeTamp, last: last.timeTamp) {
            let list = [delegete.messageArray(arry: self, date: message.timeTamp), message]
            array.append(contentsOf: list)
            return [array.count-2, array.count-1].indexPaths()
        }
        
        /// 时间间隔未有5分钟
        array.append(message)
        return [array.count-1].indexPaths()
    }
    
    /// 插入数据
    @discardableResult
    open func insert(contentsOf: [WZMessageProtocol], at: Int) -> [WZMessageProtocol] {
        
        var result = [WZMessageProtocol]()
        for (index, item) in contentsOf.enumerated() {
            
            let last = index == 0 ? nil : contentsOf[index-1]
            
            if last == nil {
                result.append(delegete.messageArray(arry: self, date: item.timeTamp))
            }else{

                if isTimeinterval(current: item.timeTamp, last: last!.timeTamp) {
                    result.append(delegete.messageArray(arry: self, date: item.timeTamp))
                }
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
    open func remove(message: WZMessageProtocol){
        
        guard let row = firstIndex(message: message) else {
            return
        }
        
        if row > 0 {
            let lastMsg = array[row-1]
            if case .time = lastMsg.currentElem {
                array.remove(at: row-1)
                delegete.messageArray(arry: self, remove: row-1)
            }
        }
        array.remove(at: row)
        delegete.messageArray(arry: self, remove: row)
    }
    
    /// 根据消息查找位置
    open func firstIndex(message: WZMessageProtocol) -> Int? {
    
        guard let row = array.firstIndex(where: {$0.messageId == message.messageId}) else {
            return nil
        }
        return row
    }
    
    /// 判断是否含有某元素
    open func isContains(message: WZMessageProtocol) -> Bool {
        
        let isContains = array.contains(where: { (mess) -> Bool in
            return mess.messageId == message.messageId
        })
        return isContains
    }
}

// MARK - 会话详情数组代理
public protocol WZMMessageArrayDelegate: class {
    
    /// 获取时间对象
    func messageArray(arry: WZMMessageArray, date: Date) -> WZMessageProtocol
    
    /// 移除某个元素
    func messageArray(arry: WZMMessageArray, remove row: Int)
}

/// MARK - 扩展
public extension Array where Element == Int {
    
    /// 根据数量获取indpath
    func indexPaths(section: Int = 0) -> [IndexPath] {
        return self.map { IndexPath(row: $0, section: section) }
    }
    
}




