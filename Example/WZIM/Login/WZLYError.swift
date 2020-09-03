//
//  WZLYError.swift
//  WZLY
//
//  Created by xiaobin liu on 2019/10/23.
//  Copyright © 2019 我主良缘. All rights reserved.
//

import Foundation


/// MARK - 我主良缘错误编码
public enum WZLYError: Swift.Error {
    
    /// 请求错误原因(错误编码2011001开始)
    ///
    /// - missingURL: 对象在编码请求时丢失 code: 2011001
    /// - lackOfAccessToken: 缺少访问令牌 code: 2011002
    public enum RequestErrorReason {
        case missingURL
        case lackOfAccessToken
    }
    
    /// 响应错误原因(错误编码从2012001开始)
    ///
    /// - dataParsingFailed: 数据解析错误 code: 2012001
    /// - emptyData: 空的数据 code： 2012002
    public enum ResponseErrorReason {
        
        case dataParsingFailed(Any.Type, Data, Error)
        case emptyData
    }
    
    
    /// 业务错误原因(错误编码由服务端下发)
    ///
    /// - tokenExpired: token过期
    /// - emptyListData: 空列表数据
    /// - customError: 自定义错误
    public enum BusinessErrorReason {
        case tokenExpired
        case emptyListData(reason: String)
        case customError(code: Int, reason: String)
    }
    
    
    /// 未知错误原因
    ///
    /// - unknown: 完全未知
    /// - systemError: 系统的错误
    public enum UnknownErrorReason {
        case unknown
        case systemError(code: Int, reason: String)
    }
    
    case requestFailed(reason: RequestErrorReason)
    case responseFailed(reason: ResponseErrorReason)
    case businessFailed(reason: BusinessErrorReason)
    case unknownFailed(reason: UnknownErrorReason)
}


// MARK: - LocalizedError
extension WZLYError: LocalizedError {

    public var errorDescription: String? {
        switch self {
        case .requestFailed(reason: let reason): return reason.errorDescription
        case .responseFailed(reason: let reason): return reason.errorDescription
        case .businessFailed(reason: let reason): return reason.errorDescription
        case .unknownFailed(reason: let reason): return reason.errorDescription
        }
    }
    
    public var debugDescription: String? {
        switch self {
        case .requestFailed(reason: let reason): return reason.debugDescription
        case .responseFailed(reason: let reason): return reason.debugDescription
        case .businessFailed(reason: let reason): return reason.debugDescription
        case .unknownFailed(reason: let reason): return reason.debugDescription
        }
    }
}


// MARK: - CustomNSError
extension WZLYError: CustomNSError {

    public var errorCode: Int {
        switch self {
        case .requestFailed(reason: let reason): return reason.errorCode
        case .responseFailed(reason: let reason): return reason.errorCode
        case .businessFailed(reason: let reason): return reason.errorCode
        case .unknownFailed(reason: let reason): return reason.errorCode
        }
    }

    public var errorUserInfo: [String : Any] {
        var userInfo: [String: Any] = [:]
//        #if DEBUG
//        userInfo[NSLocalizedDescriptionKey] = "\([errorCode])\(String(describing: debugDescription ?? ""))"
//        #else
//        userInfo[NSLocalizedDescriptionKey] = errorDescription ?? ""
//        #endif
        userInfo[NSLocalizedDescriptionKey] = errorDescription ?? ""
        return userInfo
    }
}


// MARK: - Private Definition
extension WZLYError.RequestErrorReason {
    
    var debugDescription: String? {
        switch self {
        case .missingURL:
            return "URL在编码请求时丢失"
        case .lackOfAccessToken:
            return "请求需要一个访问令牌，但是没有"
        }
    }
    
    var errorDescription: String? {
        return "程序服务异常，请联系在线客服"
    }
    
    var errorCode: Int {
        switch self {
        case .missingURL:         return 2011001
        case .lackOfAccessToken:  return 2011002
        }
    }
}


// MARK: - Private Definition
extension WZLYError.ResponseErrorReason {
    
    var debugDescription: String? {
        switch self {
        case .dataParsingFailed(let type, let data, let error):
            let result = "解析响应数据到 \(type) 错误: \(error)."
            if let text = String(data: data, encoding: .utf8) {
                return result + "\n原始: \(text)"
            } else {
                return result
            }
        case .emptyData:
            return "空数据"
        }
    }
    
    var errorDescription: String? {
        return "程序服务异常，请联系在线客服"
    }
    
    var errorCode: Int {
        switch self {
        case .dataParsingFailed:         return 2012001
        case .emptyData:                 return 2012002
        }
    }
}

// MARK: - Private Definition
extension WZLYError.BusinessErrorReason {
    
    var debugDescription: String? {
        switch self {
        case .tokenExpired:
            return "登录信息已经失效，请重新登录"
        case .emptyListData(let reason):
            return reason
        case .customError(_, reason: let reason):
            return reason
        }
    }
    
    var errorDescription: String? {
        switch self {
        case .tokenExpired:
            return "登录信息已经失效，请重新登录"
        case .emptyListData(let reason):
            return reason
        case .customError(_, reason: let reason):
            return reason
        }
    }
    
    var errorCode: Int {
        switch self {
        case .tokenExpired:             return 2013001
        case .emptyListData:            return 2013002
        case .customError(let code, _): return code
        }
    }
}


// MARK: - 未知错误扩展
extension WZLYError.UnknownErrorReason {
    
    var defaultMsg: String {
        return "网络异常"
    }
    
    var debugDescription: String? {
        switch self {
        case .unknown:
            return defaultMsg
        case .systemError(_, let  reason):
            return reason
        }
    }
    
    var errorDescription: String? {
        switch self {
        case .unknown:
            return defaultMsg
        case .systemError:
            return defaultMsg
        }
    }
    
    var errorCode: Int {
        switch self {
        case .unknown:                      return 00000
        case .systemError(let code, _):     return code
        }
    }
}

