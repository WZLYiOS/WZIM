//
//  WZIMPictureTableViewCell.swift
//  Pods-WZIMUI_Example
//
//  Created by qiuqixiang on 2020/8/20.
//

import UIKit
import SnapKit

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
        return $0
    }(UIImageView())
    
    /// 进度
    private lazy var percentMaskLabel: UILabel = {
        $0.backgroundColor = UIColor.init(red: 176/255.0, green: 176/255.0, blue: 176/255.0, alpha: 0.5)
        $0.textAlignment = .center
        $0.textColor = UIColor.white
        $0.font = UIFont.systemFont(ofSize: 13)
        $0.isUserInteractionEnabled = true
        $0.isHidden = true
        return $0
    }(UILabel())

    private lazy var controll: UIButton = {
        $0.addTarget(self, action: #selector(photoImageViewTapAction), for: .touchUpInside)
        $0.backgroundColor = UIColor.clear
        return $0
    }(UIButton())
    
    public override func configView() {
        super.configView()
        bubbleImageView.addSubview(photoImageView)
        bubbleImageView.addSubview(percentMaskLabel)
        bubbleImageView.addSubview(controll)
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
        controll.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    public override func reload(model: WZMessageProtocol, cDelegate: WZIMTableViewCellDelegate) {
       super.reload(model: model, cDelegate: cDelegate)

        guard case let .img(elem) = model.currentElem else {
            return
        }
        delegate = cDelegate as? WZIMPictureTableViewCellDelegate
        dataMarkModel = elem
        
        var size = CGSize(width: UIScreen.main.bounds.size.width * 0.4, height: UIScreen.main.bounds.size.width * 0.6)
        
        if let data = try? Data(contentsOf: URL(fileURLWithPath: elem.filePath)),
           let image = UIImage(data: data) {
            
            photoImageView.image = image
            size = imageSize(image.size.width, image.size.height)
        }else{
            size = imageSize(CGFloat(elem.width), CGFloat(elem.height))
            if elem.url.count > 0 {
                pDelegate.baseTableViewCell(cell: self, imageView: photoImageView, url: elem.url, placeholder: nil)
            }
        }

        percentMaskLabel.isHidden = message.sendStatus == .sending ? false : true
        photoImageView.snp.updateConstraints { (make) in
            make.size.equalTo(size)
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
    
    public override func upload(progress: Float) {
        super.upload(progress: progress)
        let xx = Int(progress)
        percentMaskLabel.text = "\(xx)%"
        percentMaskLabel.isHidden = progress >= 100 ? true : false
    }
    
    @objc private func photoImageViewTapAction(tap: UIControl) {
        delegate?.pictureCell(cell: self, tapImageView: photoImageView)
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


