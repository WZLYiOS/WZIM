//
//  WZAVAudioPlayer.swift
//  WZLY
//
//  Created by qiuqixiang on 2020/8/28.
//  Copyright © 2020 我主良缘. All rights reserved.
//

import Foundation
import AVFoundation

// MARK - 音频播放
public class WZAVAudioPlayer: NSObject {
    
    /// 代理
    public weak var delegate: WZAVAudioPlayerDelegate?
    
    /// 音频播放器
    public var wzPlayer: AVAudioPlayer?
        
    /// 播放某个音频
    public func play(aFilePath: String) {
        
        if !FileManager.default.fileExists(atPath: aFilePath) {
            delegate?.audioPlayerDecodeErrorDidOccur(self, error: NSError(domain: "文件未找到", code: -1002, userInfo: nil))
            return
        }
        
        if wzPlayer?.isPlaying ?? false {
            stopCurrentPlaying()
        }
        
        try? AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
        UIDevice.current.isProximityMonitoringEnabled = true

        let url = URL(fileURLWithPath: aFilePath)
        wzPlayer = try? AVAudioPlayer(contentsOf: url, fileTypeHint: nil)
        wzPlayer?.delegate = self
        wzPlayer?.prepareToPlay()
        wzPlayer?.play()
        if wzPlayer == nil {
            delegate?.audioPlayerDecodeErrorDidOccur(self, error: NSError(domain: "文件未找到", code: -1002, userInfo: nil))
        }
    }
    
    /// 停止播放
    public func stopCurrentPlaying() {
        UIDevice.current.isProximityMonitoringEnabled = false
        if wzPlayer?.isPlaying ?? false {
            wzPlayer?.stop()
        }
        wzPlayer?.delegate = nil
        wzPlayer = nil
    }
    
    /// 是否播放中
    public func isPlaying() -> Bool {
        return wzPlayer?.isPlaying ?? false
    }
    
    /// 是否相同
    public func isSame(path: String) -> Bool {
        if wzPlayer == nil {
            return false
        }
        let url = URL(fileURLWithPath: path)
        let playUrl = wzPlayer!.url
        if url == playUrl {
            return true
        }
        return false
    }
    
    deinit {
        if wzPlayer?.isPlaying ?? false {
            wzPlayer?.stop()
        }
        wzPlayer?.delegate = nil
        wzPlayer = nil
        debugPrint("")
    }
}

// MARK - WZAVAudioPlayerDelegate
public protocol WZAVAudioPlayerDelegate: class {
    
    /// 播放结束
    func audioPlayerDidFinishPlaying(_ player: WZAVAudioPlayer, successfully flag: Bool)
    
    /// 播放错误
    func audioPlayerDecodeErrorDidOccur(_ player: WZAVAudioPlayer, error: Error?)
}

/// MARK - AVAudioPlayerDelegate
extension WZAVAudioPlayer: AVAudioPlayerDelegate {
    
    public func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        stopCurrentPlaying()
        delegate?.audioPlayerDidFinishPlaying(self, successfully: flag)
    }
    
    public func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {

        stopCurrentPlaying()
        delegate?.audioPlayerDecodeErrorDidOccur(self, error: error)
    }
}
