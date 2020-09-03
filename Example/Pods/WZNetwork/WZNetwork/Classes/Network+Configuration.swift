//
//  Network+Configuration.swift
//  WZNetwork
//
//  Created by xiaobin liu on 2019/7/3.
//  Copyright © 2019 xiaobin liu. All rights reserved.
//

import WZMoya

// MARK: - 网络请求配置扩展
public extension Network {
    
    /// 配置
    class Configuration {
        
        /// 默认配置
        public static var `default`: Configuration = Configuration()
        
        /// 全局追加header头部配置
        public var addingHeaders: (TargetType) -> [String: String] = { _ in [:] }
        
        /// 更换任务
        public var replacingTask: (TargetType) -> Task = { $0.task }
        
        /// 超时时间
        public var timeoutInterval: TimeInterval = 30
        
        /// Token
        public var token: String?
        
        /// 公有参数
        public var publicParameters: [String: Any]?
        
        /// 插件
        public var plugins: [PluginType] = [NetworkIndicatorPlugin()]
        
        /// 初始化
        public init() {}
        
        /// 自定义
        public static let defaultHTTPHeaders: [String: String] = {
            
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
                    
                    return "\(executable)/\(appVersion) (\(bundle); build:\(appBuild); \(osNameVersion)) WZNetworking"
                }
                
                return "WZNetworking"
            }()
            
            return [
                "Accept-Encoding": acceptEncoding,
                "Accept-Language": acceptLanguage,
                "User-Agent": userAgent
            ]
        }()
    }
}
