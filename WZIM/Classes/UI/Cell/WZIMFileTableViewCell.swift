//
//  WZIMFileTableViewCell.swift
//  WZIM
//
//  Created by qiuqixiang on 2021/1/5.
//

import UIKit

// MARK - 文件管理cell
public class WZIMFileTableViewCell: WZIMBaseTableViewCell {

    /// 数据源
    public var dataModel: WZIMFileProtocol!
    
    /// 代理
    public weak var delegate: WZIMFileTableViewCellDelagte?
    
    /// 是否下载中
    private var isDownLoadIng: Bool = false
    
    /// 文件名
    private lazy var nameLabel: UILabel = {
        $0.textColor = UIColor(red: 0.24, green: 0.24, blue: 0.24,alpha:1)
        $0.font = UIFont.boldSystemFont(ofSize: 15)
        $0.lineBreakMode = .byTruncatingMiddle
        return $0
    }(UILabel())
    
    /// 大小
    private lazy var sizeLabel: UILabel = {
        $0.font = UIFont.systemFont(ofSize: 12)
        $0.textColor = UIColor(red: 0.67, green: 0.67, blue: 0.67,alpha:1)
        return $0
    }(UILabel())
    
    /// 图片
    private lazy var rightImageView: UIImageView = {
        $0.image = UIImage(named: "Cell.bundle/ic_chat_file")
        $0.isUserInteractionEnabled = true
        return $0
    }(UIImageView())
    
    /// 进度条
    private lazy var progressView: UIProgressView = {
        $0.layer.cornerRadius = 1
        $0.layer.masksToBounds = true
        $0.backgroundColor = UIColor.clear
        $0.progressTintColor = WZIMToolAppearance.hexadecimal(rgb: "0xFB4D38")
        $0.trackTintColor = WZIMToolAppearance.hexadecimal(rgb: "0xE6E6E6")
        $0.isHidden = true
        $0.progress = 0.1
        return $0
    }(UIProgressView())
    
    /// 底部视图
    private lazy var bgImageView: UIView = {
        $0.isUserInteractionEnabled = true
        return $0
    }(UIView())
    
    public override func configView() {
        super.configView()
        bubbleImageView.addSubview(bgImageView)
        bgImageView.addSubview(nameLabel)
        bgImageView.addSubview(sizeLabel)
        bgImageView.addSubview(rightImageView)
        bgImageView.addSubview(nameLabel)
        bgImageView.addSubview(progressView)
        bubbleImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(bubbleImageViewAction)))
    }
    
    public override func configViewLocation() {
        super.configViewLocation()
    
        bgImageView.snp.makeConstraints { (make) in
            make.leading.equalTo(0)
            make.right.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(15)
            make.top.equalToSuperview().offset(17)
            make.width.equalTo(WZIMConfig.maxWidth-80)
        }
        rightImageView.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel.snp.right).offset(23)
            make.top.equalToSuperview().offset(11)
            make.right.equalToSuperview().offset(-15)
        }
        sizeLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(15)
            make.top.equalTo(nameLabel.snp.bottom).offset(6)
        }
        progressView.snp.makeConstraints { (make) in
            make.leading.equalTo(15)
            make.right.equalToSuperview().offset(-15)
            make.height.equalTo(2)
            make.top.equalTo(rightImageView.snp.bottom).offset(7.5)
            make.bottom.equalToSuperview().offset(-10)
        }
    }
    
    public override func reload(model: WZMessageProtocol, cDelegate: WZIMTableViewCellDelegate) {
        super.reload(model: model, cDelegate: cDelegate)
        self.delegate = cDelegate as? WZIMFileTableViewCellDelagte
        if model.loaction == .right {
            bubbleImageView.image = UIImage(named: "Cell.bundle/ic_chat_windowtwowhite")?.wzStretchableImage()
        }
        
        bgImageView.snp.updateConstraints { (make) in
            make.leading.equalTo(model.loaction == .right ? 0 : 5)
            make.right.equalToSuperview().offset(model.loaction == .right ? -5 : 0)
        }
     
        if case let .file(elem) = message.currentElem {
            dataModel = elem
            nameLabel.text = elem.wzFilename
            uploadSize()
            if message.loaction == .right {
                progressView.isHidden = message.sendStatus == .sending ? false : true
            }else{
                progressView.isHidden = (dataModel.wzProgress > 0 && dataModel.wzProgress < 1) ? false : true
                if dataModel.getWzIsDownloaded(path: dataModel.getDownloadPath(messageId: message.wzMessageId)) {
                    progressView.isHidden = true
                }
            }
            progressView.progress = elem.wzProgress
        }
    }
    
    @objc func bubbleImageViewAction(tap: UITapGestureRecognizer){
        
        /// 已经下载
        if dataModel.getWzIsDownloaded(path: dataModel.getDownloadPath(messageId: message.wzMessageId)) {
            self.delegate?.fileTableViewCell(diselect: self, path: dataModel.wzPath)
            return
        }
        
        /// 已经下载
        if isDownLoadIng {
            return
        }
        isDownLoadIng = true
        dataModel.wzDownloadFile(path: dataModel.getDownloadPath(messageId: message.wzMessageId)) { [weak self](curSize, totalSize) in
            guard let self = self else { return }
            DispatchQueue.main.sync {
                self.upload(progress: Float(curSize/totalSize))
            }
        } sucess: { [weak self](path) in
            guard let self = self else { return }
            self.progressView.isHidden = true
            self.uploadSize()
            self.isDownLoadIng = false
        } fail: { [weak self](error) in
            guard let self = self else { return }
            self.progressView.isHidden = true
            self.uploadSize()
            self.isDownLoadIng = false
        }
    }
    
    func getText() -> String {
        if message.loaction == .lelft {
            if dataModel.getWzIsDownloaded(path: dataModel.getDownloadPath(messageId: message.wzMessageId)) {
                return "已下载"
            }
            if dataModel.wzProgress > 0 && dataModel.wzProgress < 1 {
                return "下载中"
            }
            return dataModel.wzProgress == 1 ? "已下载" : "未下载"
        }
        
        switch message.sendStatus {
        case .pending:
             return ""
        case .sending:
            return "发送中"
        case .sucess:
            return "已发送"
        default:
            return "发送失败"
        }
    }
    
    public override func upload(progress: Float) {
        super.upload(progress: progress)
        dataModel.wzProgress = Float(progress/100)
        progressView.progress = Float(progress/100)
        uploadSize()
    }

    func uploadSize() {
        if getText().count > 0 {
            sizeLabel.text = WZIMToolAppearance.getDataLeng(size: dataModel.wzFileSize) + " / " + getText()
        }else{
            sizeLabel.text = WZIMToolAppearance.getDataLeng(size: dataModel.wzFileSize)
        }
    }
}

/// MARK - 代理
public protocol WZIMFileTableViewCellDelagte: class {
    
    /// 点击
    func fileTableViewCell(diselect cell: WZIMFileTableViewCell, path: String)
}
