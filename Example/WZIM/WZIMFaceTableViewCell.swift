//
//  WZIMFaceTableViewCell.swift
//  Pods-WZIMUI_Example
//
//  Created by qiuqixiang on 2020/8/20.
//

import UIKit
import WZIM

// MARK - 表情
class WZIMFaceTableViewCell: WZIMBaseTableViewCell {

    private lazy var dotImageView: DTImageView = {
        $0.layer.masksToBounds = true
        $0.isUserInteractionEnabled = false
        return $0
    }(DTImageView())
    
    override func configView() {
        super.configView()
        bubbleImageView.addSubview(dotImageView)
    }
    
    override func configViewLocation() {
        super.configViewLocation()
        let size = DTImageView.size(forImageSize: CGSize(width: 120, height: 120), imgMaxSize: CGSize(width: 120, height: 120))
        dotImageView.snp.remakeConstraints { (make) in
            make.leading.equalTo(0)
            make.right.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.size.equalTo(size)
        }
    }
    
    override func reload(model: WZIMMessageProtocol, cDelegate: WZIMTableViewCellDelegate) {
        super.reload(model: model, cDelegate: cDelegate)
        
        if case let .face(elem) = model.wzCurrentElem() {
            
            bubbleImageView.image = nil
            switch elem.messageType {
            case .nomar: break
            case .face:
                dotImageView.setImageWithEmojiCode(elem.expressionData.code)
            case .gif:
                dotImageView.setImageWithDTUrl(elem.expressionData.image, gifId: elem.expressionData.gifId)
            }
        }
    }
}

