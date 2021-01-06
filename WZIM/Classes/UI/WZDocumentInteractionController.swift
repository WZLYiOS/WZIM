//
//  WZDocumentInteractionController.swift
//  WZIM
//
//  Created by qiuqixiang on 2021/1/6.
//

import UIKit

// MARK - 文件查看器
public class WZDocumentInteractionController: NSObject {

    /// 父控制器
    public var superController: UIViewController!
    
    /// 文件控制器
    public var documentController: UIDocumentInteractionController!
    
    public init(path: String, controller: UIViewController) {
        super.init()
        self.superController = controller
        self.documentController = UIDocumentInteractionController.init(url: URL(fileURLWithPath: path))
        self.documentController.delegate = self
    }
    
    public func presentPreview(animated: Bool) {
       let xxx = documentController.presentPreview(animated: animated)
        if xxx == false {
            documentController.presentOptionsMenu(from: superController.view.frame, in: superController.view, animated: true)
        }
    }
}

/// MARK - UIDocumentInteractionControllerDelegate
extension WZDocumentInteractionController: UIDocumentInteractionControllerDelegate {
    
    public func documentInteractionControllerViewForPreview(_ controller: UIDocumentInteractionController) -> UIView? {
        return superController.view
    }
    
    public func documentInteractionControllerRectForPreview(_ controller: UIDocumentInteractionController) -> CGRect {
        return superController.view.frame
    }
    
    public func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return superController
    }
}
