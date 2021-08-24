//
//  PhotoPicker.swift
//  FileConversionPrototype
//
//  Created by Casey Barth on 8/24/21.
//

import Foundation
import UIKit

protocol PhotoPickerConversionDelegate: class {
    func didCompleteConversion(fileSize: String, conversionTime: TimeInterval)
    func didErrorConversion()
}

class PhotoPicker: NSObject, UINavigationControllerDelegate {
    weak var delegate: PhotoPickerConversionDelegate?
    weak var presenter: UIViewController?
    
    init(presenter: UIViewController, delegate: PhotoPickerConversionDelegate) {
        self.delegate = delegate
        self.presenter = presenter
    }
    
    enum MediaType: String {
        case video = "public.movie"
    }
    
    lazy var picker: UIImagePickerController = {
        let uiPicker = UIImagePickerController()
        uiPicker.mediaTypes = [MediaType.video.rawValue]
        uiPicker.delegate = self
        return uiPicker
    }()
    
    func present() {
        presenter?.present(picker, animated: true, completion: nil)
    }
}

extension PhotoPicker: UIImagePickerControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        presenter?.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        presenter?.dismiss(animated: true, completion: nil)
        
        switch info[.mediaType] as? String {
        case MediaType.video.rawValue: handleSelectionInfo(info)
        default: break
        }
    }

    func handleSelectionInfo(_ info: [UIImagePickerController.InfoKey: Any]) {
        let urlKey: UIImagePickerController.InfoKey = .mediaURL
        guard let url = info[urlKey] as? URL else {
            delegate?.didErrorConversion()
            return
        }
        
        FileConverter().convertMovType(at: url) { (url, error, timeToConvert, fileSize) in
            self.delegate?.didCompleteConversion(fileSize: fileSize ?? "", conversionTime: timeToConvert ?? 0)
        }
    }
}

