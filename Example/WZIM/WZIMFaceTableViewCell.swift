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
        $0.errorImage = UIImage(named: "common_ic_load_failure")
        return $0
    }(DTImageView())
    
    override func configView() {
        super.configView()
        bubbleImageView.addSubview(dotImageView)
    }
    
    override func configViewLocation() {
        super.configViewLocation()
        dotImageView.snp.remakeConstraints { (make) in
            make.leading.equalTo(0)
            make.right.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().offset(20)
            make.size.equalTo(CGSize(width: 120, height: 120))
        }
    }
    
    override func reload(model: WZMessageProtocol, cDelegate: WZIMTableViewCellDelegate) {
        super.reload(model: model, cDelegate: cDelegate)
        
        if case let .face(elem) = model.currentElem {
            
            dotImageView.prepareForReuse()
            let with = elem.expressionData.with == 0 ? 120 : elem.expressionData.with
            let height = elem.expressionData.height == 0 ? 120 : elem.expressionData.height
            
            let size = DTImageView.size(forImageSize: CGSize(width: with, height: height), imgMaxSize: CGSize(width: 200, height: 150))
            dotImageView.snp.updateConstraints { (make) in
                make.size.equalTo(size)
            }
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
