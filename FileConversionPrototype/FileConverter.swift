//
//  FileConverter.swift
//  FileConversionPrototype
//
//  Created by Casey Barth on 8/24/21.
//

import Foundation
import AVKit

class FileConverter {
    func convertMovType(at url: URL, completionHandler: @escaping (URL?, Error?, TimeInterval?, String?) -> Void) {
        let avAsset = AVURLAsset(url: url, options: nil)
        let startDate = Date()
        let session = AVAssetExportSession(asset: avAsset, presetName: AVAssetExportPresetPassthrough)
        
        guard let exportSession = session else {
            completionHandler(nil, nil, nil, nil)
            return
        }
            
        let filePath = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("converted-video.mp4")
        
        if FileManager.default.fileExists(atPath: filePath.path) {
            do {
                try FileManager.default.removeItem(at: filePath)
            } catch {
                completionHandler(nil, error, nil, nil)
            }
        }
            
        exportSession.outputURL = filePath
        exportSession.outputFileType = .mp4
        exportSession.timeRange = CMTimeRangeMake(
            start: CMTimeMakeWithSeconds(0.0, preferredTimescale: 0),
            duration: avAsset.duration
        )
        
        exportSession.exportAsynchronously {
            switch exportSession.status {
            case .failed:
                print(exportSession.error as Any)
                
            case .cancelled:
                print("Conversion Cancelled")
                
            case .completed:
                let endDate = Date()
                let time = endDate.timeIntervalSince(startDate)
                
                DispatchQueue.main.async {
                    completionHandler(exportSession.outputURL, nil, time, avAsset.fileSize)
                }
                
            default: break
            }
        }
    }
}

extension AVURLAsset {
    var fileSize: String {
        let keys: Set<URLResourceKey> = [.totalFileSizeKey, .fileSizeKey]
        let resourceValues = try? url.resourceValues(forKeys: keys)
        let bytes = resourceValues?.fileSize ?? resourceValues?.totalFileSize ?? 0
        return ByteCountFormatter.string(fromByteCount: Int64(bytes), countStyle: .file)
    }
}
