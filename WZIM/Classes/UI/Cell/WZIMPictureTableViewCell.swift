//
//  WZIMPictureTableViewCell.swift
//  Pods-WZIMUI_Example
//
//  Created by qiuqixiang on 2020/8/20.
//

import UIKit
import SnapKit
import Kingfisher

// MARK - 图片
public class WZIMPictureTableViewCell: WZIMBaseTableViewCell {
    
    /// 代理
    weak var delegate: WZIMPictureTableViewCellDelegate?
    
    /// 数据源
    public var dataMarkModel: WZIMImageCustomElem!
    
    /// 图片
    private lazy var photoImageView: UIImageView = {
        $0.contentMode = .scaleAspectFill
        $0.isUserInteractionEnabled = true
        $0.backgroundColor = WZIMToolAppearance.hexadecimal(rgb: 0xE5E5E5)
        $0.addGestureRecognizer(UIGestureRecognizer(target: self, action: #selector(photoImageViewTapAction)))
        return $0
    }(UIImageView())
    
    /// 进度
    private lazy var percentMaskLabel: UILabel = {
        $0.backgroundColor = UIColor.init(red: 176, green: 176, blue: 176, alpha: 0.5)
        $0.textAlignment = .center
        $0.textColor = UIColor.white
        $0.font = UIFont.systemFont(ofSize: 13)
        $0.text = "0.1%"
        $0.isHidden = true
        return $0
    }(UILabel())

    public override func configView() {
        super.configView()
        bubbleImageView.addSubview(photoImageView)
        bubbleImageView.addSubview(percentMaskLabel)
    }
    
    public override func configViewLocation() {
        super.configViewLocation()
        photoImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            make.size.equalTo(CGSize(width: 150, height: 150))
        }
        percentMaskLabel.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    public override func reload(model: WZIMMessageProtocol, cDelegate: WZIMTableViewCellDelegate) {
       super.reload(model: model, cDelegate: cDelegate)
        
        if case let .img(elem) = model.wzCurrentElem() {
            
            delegate = cDelegate as? WZIMPictureTableViewCellDelegate
            percentMaskLabel.isHidden = true
            dataMarkModel = elem
            let size = imageSize(elem: elem)
            let url = URL(string: elem.url)
            photoImageView.kf.setImage(with: url)
            photoImageView.snp.updateConstraints { (make) in
                make.size.equalTo(size)
            }
            
            let imageViewMask = UIImageView(image: bubbleImageView.image)
            imageViewMask.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            photoImageView.layer.mask = imageViewMask.layer
            if message.wzLoaction() == .right {
                
                
                let newTime = Int(NSDate().timeIntervalSince1970)
                /// wzCustomInt  发送中：2  发送失败：1 成功：0
                /// 异常处理：未等回调就退出详情页，根据上传间隔10s处理
                if let dataTime = message.wzCustomData,
                    let time = String(data: dataTime, encoding: String.Encoding.utf8),
                    (newTime - (Int(time) ?? 0)) > 10,
                    message.wzCustomInt == 2 {
                    sendFailButton.isHidden = false
                    percentMaskLabel.isHidden = true
                }else{
                    if message.wzCustomInt == 1 {
                        sendFailButton.isHidden = false
                    }else{
                        sendFailButton.isHidden = true
                    }
                    percentMaskLabel.isHidden = message.wzCustomInt == 2 ? false : true
                }
                readButton.isHidden = !sendFailButton.isHidden
            }
        }
    }
    
    /// 图片尺寸
    func imageSize(elem: WZIMImageCustomElem) -> CGSize {
        let scale = min(200/elem.heigth, 120/elem.width)
        let picThumbHeight = elem.heigth * scale
        let picThumbWidth = elem.width * scale
        let thumbnailSize = picThumbHeight * picThumbWidth > 150 * 150 ? CGSize(width: 150, height: 150) : CGSize(width: picThumbWidth, height: picThumbHeight)
        return thumbnailSize
    }
    
    /// 更新进度
    public func upload(percent: CGFloat) {
        percentMaskLabel.text = String(format: "%.0f%%", percent*100)
        percentMaskLabel.isHidden = percent >= 1 ? true : false
    }
    
    @objc private func photoImageViewTapAction(tap: UIGestureRecognizer) {
        delegate?.pictureCell(cell: self, tapImageView: tap.view as! UIImageView)
    }
}

// MARK - WZIMPictureTableViewCellDelegate
public protocol WZIMPictureTableViewCellDelegate: WZIMTableViewCellDelegate {
    
    /// 图片点击
    /// - Parameters:
    ///   - cell: cell
    ///   - tapImageView: 被点击图片
    func pictureCell(cell: WZIMPictureTableViewCell, tapImageView: UIImageView)
}

/// MARK - 扩展
public extension WZIMPictureTableViewCell {
    
    /// 把图片存入磁盘
    static func storeDisk(filePath: String, image: UIImage) {
        ImageCache.default.store(image, forKey: filePath)
    }
    
    /// 从磁盘加载图片
    func setImageView(filePath: String, imageView: UIImageView) {
        ImageCache.default.retrieveImageInDiskCache(forKey: filePath, options: nil, callbackQueue: .mainAsync) { (result) in
            let imx = try? result.get()
            imageView.image = imx
        }
    }
}
