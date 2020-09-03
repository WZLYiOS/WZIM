//
//  NetworkIndicatorPlugin.swift
//  WZNetwork
//
//  Created by xiaobin liu on 2019/7/3.
//  Copyright © 2019 xiaobin liu. All rights reserved.
//

import WZMoya


/// MARK - 网络指示器插件
public final class NetworkIndicatorPlugin: PluginType {
    
    /// 请求数量
    private static var numberOfRequests: Int = 0 {
        didSet {
            if numberOfRequests > 1 { return }
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = self.numberOfRequests > 0
            }
        }
    }
    
    
    /// 将要开始发送请求
    ///
    /// - Parameters:
    ///   - request: request
    ///   - target: target
    public func willSend(_ request: RequestType, target: TargetType) {
        NetworkIndicatorPlugin.numberOfRequests += 1
    }
    
    
    /// 收到请求
    ///
    /// - Parameters:
    ///   - result: result
    ///   - target: target
    public func didReceive(_ result: Result<WZMoya.Response, MoyaError>, target: TargetType) {
        NetworkIndicatorPlugin.numberOfRequests -= 1
    }
    
    
    /// 初始化
    public init() {}
}

