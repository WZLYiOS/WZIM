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
    
                return .signaling(model)
            }
            return .unknown
        case is V2TIMFaceElem:
            let face = self as! V2TIMFaceElem
            let model = try! CleanJSONDecoder().decode(WZIMFaceCustomMarkModel.self, from: face.data)
            return .face(model)
        case is V2TIMImageElem:
            return .img(self as! V2TIMImageElem)
        case is V2TIMFileElem:
            return .file(self as! V2TIMFileElem)
        default:
            return .unknown
        }
    }
}

// MARK - 遵循文字
extension V2TIMTextElem: WZIMTextProtocol {
    
    public func getText() -> String {
        if text == nil || text == "null" {
            return ""
        }
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
        downloadSound(oPath, progress: { (messageId, msg) in
            
        }, succ: {
            sucess?(oPath)
        }) { (code, msg) in
            fail?(NSError(domain: msg ?? "", code: Int(code), userInfo: nil))
            debugPrint("音频下载失败：\(String(describing: oPath))")
        }
    }

    /// 播放路径
    public func wzPath() -> String {
        
        /// 自己上传
        if path.count > 0 {
            let mPath = "\(WZIMToolAppearance.DBType.voice.getPath())\((path as NSString).lastPathComponent)"
            if FileManager.default.fileExists(atPath: mPath) {
                return mPath
            }
        }
        /// 下载
        let oPath = WZIMToolAppearance.DBType.voice.getPath(userId: TIMManager.sharedInstance()!.getLoginUser(), uuid: uuid)
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

/// 遵守协议
extension V2TIMOfflinePushInfo: WZIMOfflinePushInfoProtocol {
    
}

/// MARK - 文件消息
extension V2TIMFileElem: WZIMFileProtocol {
   
    
    public var wzPath: String {
        let mPath = "\(WZIMToolAppearance.DBType.file.getPath())\((path as NSString).lastPathComponent)"
        return mPath
    }
    
    public var wzUuid: String {
        return uuid
    }
    
    public var wzFilename: String {
        return filename
    }
    
    public var wzFileSize: Int {
        return Int(fileSize)
    }

    public func getWzIsDownloaded(path: String) -> Bool {
        if FileManager.default.fileExists(atPath: path)  {
            return true
        }
        return false
    }
    
    public func wzGetUrl(urlBlock: ((String) -> Void)?) {
        getUrl { (url) in
            urlBlock?(url ?? "")
        }
    }
    
    public func getDownloadPath(messageId: String) -> String {
        return WZIMToolAppearance.DBType.file.getPath(userId: TIMManager.sharedInstance()!.getLoginUser(),uuid: messageId)
    }
    
    public func wzDownloadFile(path: String, progress: ((Int, Int) -> Void)?, sucess: ((String) -> Void)?, fail: ((Error) -> Void)?) {
        /// 判断本地有无
        if FileManager.default.fileExists(atPath: path)  {
            sucess?(path)
            return
        }
        downloadFile(path) { (cur, total) in
            progress?(cur, total)
        } succ: {
            sucess?(path)
        } fail: { (code, msg) in
            fail?(NSError(domain: msg ?? "", code: Int(code), userInfo: nil))
        }
    }
}
