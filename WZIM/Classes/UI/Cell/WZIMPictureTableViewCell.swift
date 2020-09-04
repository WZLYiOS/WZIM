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
    
    /// 图片
    private lazy var photoImageView: UIImageView = {
        $0.contentMode = .scaleAspectFill
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
            let size = imageSize(elem: elem)
            let url = URL(string: elem.url)
            photoImageView.kf.setImage(with: url)
            photoImageView.snp.updateConstraints { (make) in
                make.size.equalTo(size)
            }
            
            let imageViewMask = UIImageView(image: bubbleImageView.image)
            imageViewMask.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            photoImageView.layer.mask = imageViewMask.layer
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
}


