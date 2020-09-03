//
//  NetworkConfig.swift
//  WZLY
//
//  Created by xiaobin liu on 2019/10/23.
//  Copyright © 2019 我主良缘. All rights reserved.
//

import WZMoya
import DeviceKit
import WZNetwork
import Foundation
import WZEncryption

/// MARK - 网络配置
public func networkConfig() {
    
        Network.Configuration.default.timeoutInterval = 30
        Network.Configuration.default.publicParameters = ["request_agent": "ios",
                                                          "imei": UUID().uuidString ,
                                                          "app_version": Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "4.0.0"]
        Network.Configuration.default.plugins = [NetworkIndicatorPlugin()]
        Network.Configuration.default.addingHeaders = { _ in
            return defaultHTTPHeaders
        }
        Network.Configuration.default.replacingTask = { target in
            
            var totenParameters: [String: Any] = [:]
            /// 这边先这样子判断
            if let temToken = UserSession.shared.tokenConfig?.token {
                totenParameters = ["token": temToken]
            }
            
            switch target.task {
            case let .requestParameters(parameters, encoding):
                return .requestParameters(parameters: parameters.merge(withDictionary: totenParameters)
                        .merge(withDictionary: Network.Configuration.default.publicParameters ?? [:]), encoding: encoding)
            case .requestPlain:
                return .requestParameters(parameters: (Network.Configuration.default.publicParameters ?? [:]).merge(withDictionary: totenParameters), encoding: WZMoya.URLEncoding.methodDependent)
            case let .requestEncryption(parameters, encoding):
                return .requestEncryption(parameters: parameters.merge(withDictionary: totenParameters).merge(withDictionary: Network.Configuration.default.publicParameters ?? [:]).encryption, encoding: encoding)
            case let .uploadCompositeMultipart(multipartFormData, urlParameters):
                return .uploadCompositeMultipart(multipartFormData, urlParameters: urlParameters.merge(withDictionary: totenParameters))
            default:
                return target.task
            }
        }
}


/// 自定义
private let defaultHTTPHeaders: [String: String] = {
    
    let acceptEncoding: String = "gzip;q=1.0, compress;q=0.5"
    let acceptLanguage = Locale.preferredLanguages.prefix(6).enumerated().map { index, languageCode in
        let quality = 1.0 - (Double(index) * 0.1)
        return "\(languageCode);q=\(quality)"
        }.joined(separator: ", ")
    
    let userAgent: String = {
        if let info = Bundle.main.infoDictionary {
            let executable = info[kCFBundleExecutableKey as String] as? String ?? "Unknown"
            let bundle = info[kCFBundleIdentifierKey as String] as? String ?? "Unknown"
            let appVersion = info["CFBundleShortVersionString"] as? String ?? "Unknown"
            let appBuild = info[kCFBundleVersionKey as String] as? String ?? "Unknown"
            
            let osNameVersion: String = {
                let version = ProcessInfo.processInfo.operatingSystemVersion
                let versionString = "\(version.majorVersion).\(version.minorVersion).\(version.patchVersion)"
                
                let osName: String = {
                    #if os(iOS)
                    return "iOS"
                    #elseif os(watchOS)
                    return "watchOS"
                    #elseif os(tvOS)
                    return "tvOS"
                    #elseif os(macOS)
                    return "OS X"
                    #elseif os(Linux)
                    return "Linux"
                    #else
                    return "Unknown"
                    #endif
                }()
                
                return "\(osName) \(versionString)"
            }()
            
            return "\(executable)/\(appVersion) (\(bundle); build:\(appBuild); \(Device.current.description): \(osNameVersion)) WZNetworking"
        }
        
        return "WZNetworking"
    }()
    
    return [
        "Accept-Encoding": acceptEncoding,
        "Accept-Language": acceptLanguage,
        "User-Agent": userAgent
    ]
}()

// MARK: - 加密编码
private extension Dictionary {
    
    /// 加密后的字典(这个接口比较特殊)
    var encryption: [String: Any] {
        
        var temDic: [String: Any] = [:]
        self.forEach { (result) in
            temDic["\(result.key)"] = WZDES3.encrypt("\(result.value)", key: "www.7799520.com/wzly/wZLy520?#@", iv: "01234567")
        }
        //加上版本号
        temDic["api_version"] = "2.1.1"
        return temDic
    }
}

/// 合并协议
public protocol Mergable {
    func merge(withOther:Self) -> Self
}

// MARK: - 字典合并
public extension Dictionary where Value : Mergable {
    func merge(withDictionary: Dictionary) -> Dictionary {
        var returnDictionary = withDictionary
        for (key, value) in self {
            if let withDictionaryValue = withDictionary[key] {
                returnDictionary[key] = value.merge(withOther: withDictionaryValue)
            } else {
                returnDictionary[key] = value
            }
        }
        return returnDictionary
    }
}


// MARK: - <#Description#>
public extension Dictionary {
    func merge(withDictionary: Dictionary) -> Dictionary {
        var returnDictionary = withDictionary
        keys.forEach {returnDictionary[$0] = self[$0]}
        return returnDictionary
    }
}
