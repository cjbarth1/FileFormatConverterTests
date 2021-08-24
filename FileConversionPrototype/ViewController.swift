//
//  ViewController.swift
//  FileConversionPrototype
//
//  Created by Casey Barth on 8/24/21.
//

import UIKit
import Foundation
import AVKit

class ViewController: UIViewController, PhotoPickerConversionDelegate {
    @IBOutlet weak var readoutLabel: UILabel!
    
    lazy var photoPicker: PhotoPicker = {
        return PhotoPicker(presenter: self, delegate: self)
    }()
    
    @IBAction func photosTapped(_ sender: Any) {
        present(photoPicker.picker, animated: true, completion: nil)
    }
    
    func didCompleteConversion(fileSize: String, conversionTime: TimeInterval) {
        readoutLabel.text = "File Size Converted: \(fileSize)\nTime To Convert: \(conversionTime)"
    }
    
    func didErrorConversion() {
        readoutLabel.text = "Error converting file"
    }
}
