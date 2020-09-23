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
    public var dataMarkModel: WZIMImageElemProtocol!
    
    /// 图片
    private lazy var photoImageView: UIImageView = {
        $0.contentMode = .scaleAspectFill
        $0.isUserInteractionEnabled = true
        $0.backgroundColor = WZIMToolAppearance.hexadecimal(rgb: "0xE5E5E5")
        $0.layer.cornerRadius = 5
        $0.layer.masksToBounds = true
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
    
    public override func reload(model: WZMessageProtocol, cDelegate: WZIMTableViewCellDelegate) {
       super.reload(model: model, cDelegate: cDelegate)
        
        if case let .img(elem) = model.currentElem {
            
            delegate = cDelegate as? WZIMPictureTableViewCellDelegate
            percentMaskLabel.isHidden = true
            dataMarkModel = elem
            
            var size = CGSize(width: UIScreen.main.bounds.size.width * 0.4, height: UIScreen.main.bounds.size.width * 0.6)
            
            if let data = try? Data(contentsOf: URL(fileURLWithPath: elem.filePath)),
               let image = UIImage(data: data) {
                
                photoImageView.image = image
                size = imageSize(image.size.width, image.size.height)
            }else{
                size = imageSize(CGFloat(elem.width), CGFloat(elem.height))
                photoImageView.kf.setImage(with: URL(string: elem.url))
            }

            percentMaskLabel.isHidden = message.sendStatus == .sending ? false : true
            photoImageView.snp.updateConstraints { (make) in
                make.size.equalTo(size)
            }
        }
    }
    
    /// 图片尺寸
    private func imageSize( _ width: CGFloat ,_ height: CGFloat) -> CGSize {
        
        /// 最大宽度
        let maxWith: CGFloat = UIScreen.main.bounds.size.width * 0.4
        
        if width < maxWith {
            return CGSize(width: width, height: height)
        }
        
        if height > width {
            return CGSize(width: width/height*maxWith, height: maxWith)
        }
        return CGSize(width: maxWith, height: height/width*maxWith)
    }
    
    /// 更新进度
    public func upload(percent: CGFloat) {
        percentMaskLabel.text = String(format: "%.0f%%", percent)
        percentMaskLabel.isHidden = percent >= 100 ? true : false
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
    /// - Parameters:
    ///   - name: 文件名
    ///   - image: 图片
    /// - Returns: 路径
    static func storeDisk(imageData: Data, compleHandler: ((_ path:  String) -> Void)?) {
     
        let name = "WZIM/image/\(Int(NSDate().timeIntervalSince1970))"
        ImageCache.default.storeToDisk(imageData, forKey: name, processorIdentifier: "", expiration: nil, callbackQueue: .mainAsync) { (result) in
            let filePath = ImageCache.default.cachePath(forKey: name)
            compleHandler?(filePath)
        }
    }
    
    /// 从磁盘加载图片
    func setImageView(filePath: String, imageView: UIImageView) {
        ImageCache.default.retrieveImageInDiskCache(forKey: filePath, options: nil, callbackQueue: .mainAsync) { (result) in
            let imx = try? result.get()
            imageView.image = imx
        }
    }
}
