//
//  WZDocumentPicker.swift
//  WZIM
//
//  Created by qiuqixiang on 2021/1/6.
//

import UIKit

// AMRK - 文件选取
public class WZDocumentPickerViewController: UIDocumentPickerViewController {

    /// 回调
    public typealias HandlercompleBlock = ((_ fileSize: Int, _ fileName: String, _ filePath: String) -> Void)?
    
    /// 回调
    private var handlerBlock: HandlercompleBlock
    
    public init(documentTypes: [String] = ["public.data"], in mode: UIDocumentPickerMode = .open, compleBlock: HandlercompleBlock = nil) {
        handlerBlock = compleBlock
        super.init(documentTypes: documentTypes, in: mode)
        delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension WZDocumentPickerViewController: UIDocumentPickerDelegate {
    
    public func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
    
        getDocumentCoordinate(url: url) { [weak self](size, name, path) in
            guard let self = self else { return }
            self.handlerBlock?(size, name, path)
        }
        controller.dismiss(animated: true, completion: nil)
    }
    
    /// 获取document 下文件
    public func getDocumentCoordinate(url: URL, compleBlock: (_ fileSize: Int, _ fileName: String, _ filePath: String) -> Void) {
        
        _  = url.startAccessingSecurityScopedResource()
        let coordinator = NSFileCoordinator()
        let error: NSErrorPointer = nil

        coordinator.coordinate(readingItemAt: url, options: NSFileCoordinator.ReadingOptions(rawValue: 0), error: error) { (newUrl) in
            let fileData = try? Data(contentsOf: url)
            let name = url.lastPathComponent
            let path = WZIMToolAppearance.DBType.file.getPath(userId: name)
            FileManager.default.createFile(atPath: path, contents: fileData, attributes: nil)
            /// 数据存入沙盒
            if FileManager.default.fileExists(atPath: path) {
                let attributesOfItem = try? FileManager.default.attributesOfItem(atPath: path)
                let size: Int = attributesOfItem?[FileAttributeKey.size] as? Int ?? 0
                compleBlock(size, name, path)
            }else{
                compleBlock(0, "", "")
            }
        }
        url.stopAccessingSecurityScopedResource()
    }
}
