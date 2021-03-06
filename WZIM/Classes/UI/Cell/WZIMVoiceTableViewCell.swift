//
//  WZIMVoiceTableViewCell.swift
//  Pods-WZIMUI_Example
//
//  Created by qiuqixiang on 2020/8/20.
//

import UIKit
import SnapKit

// MARK - 音频
@objc public class WZIMVoiceTableViewCell: WZIMBaseTableViewCell {

    private weak var delegate: WZIMVoiceTableViewCellDelegate?
    
    /// 数据源
    var dataModel: WZIMVoiceProtocol!
    
    /// 事件
    private lazy var controll: UIControl = {
        $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapAction)))
        $0.backgroundColor = UIColor.clear
        return $0
    }(UIControl())
    
    /// 播放动画
    public lazy var playImageView: UIImageView = {
        $0.backgroundColor = UIColor.clear
        $0.animationDuration = 1
        $0.isUserInteractionEnabled = true
        return $0
    }(UIImageView())
    
    /// 播放时间
    private lazy var playTimeLabel: UILabel = {
        $0.backgroundColor = UIColor.clear
        $0.font = UIFont.boldSystemFont(ofSize: 15)
        $0.isUserInteractionEnabled = true
        return $0
    }(UILabel())
    
    /// 未读红点
    private lazy var unReadImageView: UIImageView = {
        $0.image = UIImage(named: "chat_icon_remind")
        $0.isHidden = true
        return $0
    }(UIImageView())
    
    public override func configView() {
        super.configView()
        bubbleImageView.bubbleView.addSubview(playImageView)
        bubbleImageView.bubbleView.addSubview(playTimeLabel)
        contentView.addSubview(unReadImageView)
        bubbleImageView.addSubview(controll)
        
    }
    
    public override func configViewLocation() {
        super.configViewLocation()
        controll.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    public override func reload(model: WZMessageProtocol, cDelegate: WZIMTableViewCellDelegate) {
        super.reload(model: model, cDelegate: cDelegate)
        
        if case let .sound(elem) = model.currentElem {
            dataModel = elem
            delegate = cDelegate as? WZIMVoiceTableViewCellDelegate
            
            var textColor = model.loaction == .right ? UIColor.white : WZIMToolAppearance.hexadecimal(rgb: "0x3C3C3C")
            if let color = delegate?.voiceTableViewCell?(textColor: self) {
                textColor = color
            }
            
            playTimeLabel.textColor = textColor
            playTimeLabel.text = "\(elem.wzSecond())\""
            
            let animationImages = delegate?.voiceTableViewCell?(getImages: self) ?? []
            playImageView.animationImages  = animationImages.count > 0 ? animationImages : getNomarAnimationImages(type: model.loaction)
            switch model.loaction {
            case .right:
                unReadImageView.isHidden = message.customInt > 0 ? true : false
                playImageView.snp.remakeConstraints { (make) in
                    make.right.equalToSuperview()
                    make.centerY.equalToSuperview()
                }
                playTimeLabel.snp.remakeConstraints { (make) in
                    make.right.equalTo(playImageView.snp.left)
                    make.centerY.equalToSuperview()
                    make.left.equalToSuperview()
                }
            case .lelft:
                unReadImageView.isHidden = true
                
                playImageView.snp.remakeConstraints { (make) in
                    make.left.equalToSuperview()
                    make.centerY.equalToSuperview()
                }
                playTimeLabel.snp.remakeConstraints { (make) in
                    make.left.equalTo(playImageView.snp.right)
                    make.centerY.equalToSuperview()
                    make.right.equalToSuperview()
                }
            default: break
            }
            playImageView.image = playImageView.animationImages?.first
            let playState =  delegate?.isPlayIngVoiceTableViewCell(cell: self, elem: dataModel)
            if playState == true {
                if !playImageView.isAnimating {
                    playImageView.startAnimating()
                }
            }else{
                if playImageView.isAnimating {
                    playImageView.stopAnimating()
                }
            }
        }
    }
    
    /// 获取默认
    private func getNomarAnimationImages(type: WZMessageLocation) -> [UIImage] {
        
        if type == .right {
            return [UIImage(named: "Cell.bundle/ic_chat_speaker_six")!,
                    UIImage(named: "Cell.bundle/ic_chat_speaker_four")!,
                    UIImage(named: "Cell.bundle/ic_chat_speaker_five")!,
                    UIImage(named: "Cell.bundle/ic_chat_speaker_six")!]
        }
        return [UIImage(named: "Cell.bundle/ic_talk_inputbox_voice_style_step3")!,
                UIImage(named: "Cell.bundle/ic_talk_inputbox_voice_style_step1")!,
                UIImage(named: "Cell.bundle/ic_talk_inputbox_voice_style_step2")!,
                UIImage(named: "Cell.bundle/ic_talk_inputbox_voice_style_step3")!]
    }
    
    /// 点击播放
    @objc private func tapAction(){
        
        message.customInt = 1
        dataModel.wzGetSound(sucess: { [weak self](path) in
            guard let self = self else { return }
            self.delegate?.startPlayerVoiceTableViewCell(cell: self, path: path)
        }) { (error) in
        }
    }
}

// MARK - WZIMVoiceTableViewCellDelegate
@objc public protocol WZIMVoiceTableViewCellDelegate: class {
    
    /// 获取播放状态
    func isPlayIngVoiceTableViewCell(cell: WZIMVoiceTableViewCell, elem: WZIMVoiceProtocol) -> Bool
    
    /// 开始播放
    func startPlayerVoiceTableViewCell(cell: WZIMVoiceTableViewCell, path: String)
    
    /// 获取播放文件
    @objc optional func voiceTableViewCell(getImages cell: WZIMVoiceTableViewCell) -> [UIImage]
    
    /// 获取字体颜色
    @objc optional func voiceTableViewCell(textColor cell: WZIMVoiceTableViewCell) -> UIColor?
}


