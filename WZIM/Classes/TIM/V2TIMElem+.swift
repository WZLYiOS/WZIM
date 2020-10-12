//
//  TIMElem+.swift
//  WZLY
//
//  Created by qiuqixiang on 2020/8/23.
//  Copyright © 2020 我主良缘. All rights reserved.
//

import Foundation
import CleanJSON
import ImSDK

// MARK - 自定义
extension V2TIMElem {
    
    /// 获取当前的
    func getElem() -> WZMessageElem {
        switch self {
        case is V2TIMTextElem:
            return .text(self as! V2TIMTextElem)
        case is V2TIMSoundElem:
            return .sound(self as! V2TIMSoundElem)
        case is V2TIMCustomElem:
            let custom = self as! V2TIMCustomElem
            
            /// 将所有JSON 格式的字符串自动转成 Codable 对象或数组
            let decoder = CleanJSONDecoder()
            decoder.jsonStringDecodingStrategy = .all
            
            if let model = try? decoder.decode(WZIMCustomElem.self, from: custom.data), model.type != .none {
                return model.msgElem
            }else if let model = try? decoder.decode(WZSignalingElem.self, from: custom.data), model.actionType != .none {
                
                if model.data.callEnd > 0 {
                    model.actionType = .end
                }
                
                return .signaling(model)
            }
            return .unknown
        case is V2TIMFaceElem:
            let face = self as! V2TIMFaceElem
            let model = try! CleanJSONDecoder().decode(WZIMFaceCustomMarkModel.self, from: face.data)
            return .face(model)
        case is V2TIMImageElem:
            return .img(self as! V2TIMImageElem)
        default:
            return .unknown
        }
    }
}

// MARK - 遵循文字
extension V2TIMTextElem: WZIMTextProtocol {
    
    public func getText() -> String {
        return text
    }
}

// MARK - 音频
extension V2TIMSoundElem: WZIMVoiceProtocol {
    
    public func wzSecond() -> Int {
        return Int(duration)
    }
    
    public func wzGetSound(sucess: ((String) -> Void)?, fail: ((Error) -> Void)?) {
        
        /// 路径
        let oPath = wzPath()
        
        /// 判断是否已下载
        if FileManager.default.fileExists(atPath: wzPath()) {
            sucess?(oPath)
            return
        }
        
        downloadSound(oPath, progress: nil) {
            sucess?(oPath)
        } fail: { (code, msg) in
            fail?(NSError(domain: msg ?? "", code: Int(code), userInfo: nil))
            debugPrint("音频下载失败：\(String(describing: oPath))")
        }
    }

    /// 播放路径
    public func wzPath() -> String {
        
        /// 自己上传
        if path.count > 0 {
            let mPath = "\(WZIMToolAppearance.getDBPath(name: "voice"))\((path as NSString).lastPathComponent)"
            if FileManager.default.fileExists(atPath: mPath) {
                return mPath
            }
        }
        /// 下载
        let oPath = WZIMToolAppearance.getVoicePathMp3(userId: TIMManager.sharedInstance()!.getLoginUser(), uuid: uuid)
        return  oPath
    }
}

extension V2TIMImageElem: WZIMImageElemProtocol {
   
    public var filePath: String {
        return self.path
    }
    
    public var uuid: String {
        return imageList.first?.uuid ?? ""
    }
    
    public var size: Int {
        return Int(imageList.first?.size ?? 0)
    }
    
    public var width: Int {
        return Int(imageList.first?.width ?? 150)
    }
    
    public var height: Int {
        return Int(imageList.first?.height ?? 150)
    }
    
    public var url: String {
        return imageList.first?.url ?? ""
    }
    
    
}
