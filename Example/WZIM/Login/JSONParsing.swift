//
//  JSONParsing.swift
//  WZLY
//
//  Created by xiaobin liu on 2019/10/23.
//  Copyright © 2019 我主良缘. All rights reserved.
//

import UIKit
import WZMoya
import RxSwift
import CleanJSON
import Foundation



// MARK: - PrimitiveSequence + JSONParsing
public extension PrimitiveSequence where Trait == SingleTrait, Element == Response {
    
    /// MARK - 转换数据为Result实体
    ///
    /// - Parameter type: 类型
    /// - Returns: Result
    private func mapResult<T: Decodable>(_ type: T.Type,
                                 isDebug: Bool = false) -> Observable<WZResult<T>> {
        
        return asObservable()
            .filterSuccessfulStatusCodes()
            .map { response in
                
                /// 因为服务端把所有的类型都以字符串来传递。。。。。。
                let decoder = CleanJSONDecoder()
                decoder.valueNotFoundDecodingStrategy = .custom(CustomAdapter())
                
                do {
                    let value = try decoder.decode(WZResult<T>.self, from: response.data)
                    if isDebug {
                        response.showApiDebug()
                    }
                    return value
                } catch {
                    #if DEBUG
                    response.showApiDebug()
                    WZToast.showText(withStatus: "解析错误: URL地址:\(response.request?.url?.absoluteString ?? "") 数据:\(String(data: response.data, encoding: .utf8) ?? "")")
                    #endif
                    throw WZLYError.responseFailed(reason: .dataParsingFailed(T.self, response.data, error))
                }
        }
    }
    
    
    /// 转换为单独的实体
    ///
    /// - Parameter type: type description
    /// - Returns: return value description
    func mapModel<T: Decodable>(_ type: T.Type,
                                isDebug: Bool = false) -> Observable<T> {
        
        return mapResult(T.self, isDebug: isDebug)
            .map { result -> T in
                
                try self.checkCode(result.code, msg: result.msg)
                guard let temData = result.data else {
                    throw WZLYError.responseFailed(reason: .emptyData)
                }
                return temData
        }
    }
    
    /// 转换为整个实体(不过错误编码逻辑也已经处理)
    ///
    /// - Parameter type: type description
    /// - Returns: return value description
    func mapResultModel<T: Decodable>(_ type: T.Type,
                                isDebug: Bool = false) -> Observable<(code: Int, msg: String, data: T)> {
        
        return mapResult(T.self, isDebug: isDebug)
            .map { (result) -> (code: Int, msg: String, data: T) in
                
            try self.checkCode(result.code, msg: result.msg)
            guard let data = result.data else {
                throw WZLYError.responseFailed(reason: .emptyData)
            }
            return (result.code, result.msg, data)
        }
    }
    
    
    /// 判断成功
    ///
    /// - Returns: 观察者成功
    func mapSuccess(isDebug: Bool = false) -> Observable<Bool> {
        
        return mapResult(String.self, isDebug: isDebug)
            .map { result -> Bool in
                try self.checkCode(result.code, msg: result.msg)
                return true
        }
    }
    
    
    /// 校验编码
    ///
    /// - Parameters:
    ///   - code: 编码
    ///   - msg: 信息
    /// - Throws: throws value description
    private func checkCode(_ code: Int, msg: String) throws {
        
        guard code == 0 else {
            throw WZLYError.businessFailed(reason: .customError(code: code, reason: msg))
        }
    }
}

struct CustomAdapter: JSONAdapter {
    
    // 由于 Swift 布尔类型不是非 0 即 true，所以默认没有提供类型转换。
    // 如果想实现 Int 转 Bool 可以自定义解码。
    func adapt(_ decoder: CleanDecoder) throws -> Bool {
        // 值为 null
        if decoder.decodeNil() {
            return false
        }
        
        if let intValue = try decoder.decodeIfPresent(Int.self) {
            // 类型不匹配，期望 Bool 类型，实际是 Int 类型
            return intValue != 0
        }
        
        if let intValue = try decoder.decodeIfPresent(String.self) {
            // 类型不匹配，期望 Bool 类型，实际是 Int 类型
            return intValue != "0"
        }
        
        return false
    }
}

/// MARK - 响应数据
public extension Response {
    
    func showApiDebug() {
        
        debugPrint(">>>>>>请求信息调试<<<<<<")
        
        debugPrint(">>>>>>请求地址<<<<<<")
        if let urlStr = self.request?.url?.absoluteString {
            debugPrint(urlStr)
        }
        
        debugPrint(">>>>>>请求头<<<<<<")
        if let header = self.request?.allHTTPHeaderFields {
            debugPrint(header)
        }
        
        debugPrint(">>>>>>请求参数<<<<<<")
        
        if let paramsData = self.request?.httpBody {
            if  let a = try? JSONSerialization.jsonObject(with: paramsData, options: JSONSerialization.ReadingOptions.fragmentsAllowed) {
                debugPrint(a)
            } else {
                let obj = String(data: paramsData, encoding: String.Encoding.utf8) ?? "无请求参数"//
                debugPrint(obj)
            }
        } else if let absoluteString = self.request?.url?.absoluteString,
            let urlComponents = NSURLComponents(string: absoluteString),
            let queryItems = urlComponents.queryItems {
            queryItems.forEach { debugPrint("\($0.name) = \($0.value ?? "")") }
        } else {
            debugPrint("无请求参数")
        }
        
        debugPrint(">>>>>>响应状态码<<<<<<")
        debugPrint(response?.statusCode ?? 200)
        
        debugPrint(">>>>>>响应数据<<<<<<")
        if let a = try? JSONSerialization.jsonObject(with: self.data, options: JSONSerialization.ReadingOptions.fragmentsAllowed) {
            debugPrint(a)
        } else {
            let obj = String(data: self.data, encoding: String.Encoding.utf8) ?? "无返回信息"
            debugPrint(obj)
        }
        debugPrint(">>>>>>请求信息调试完成<<<<<<")
    }
}
