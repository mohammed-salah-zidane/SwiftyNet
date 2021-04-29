//
//  Data+Extensions.swift
//  SwiftyNet
//
//  Created by prog_zidane on 4/29/21.
//

import Foundation

public enum MimeTypeSignatures {
    case jpeg
    case png
    case gif
    case pdf
    case tiff
    case video
    case vnd
    case text
    
    var mimeType: String {
        switch self {
        case .jpeg:
            return "image/jpeg"
        case .png:
            return "image/png"
        case .gif:
            return "image/gif"
        case .pdf:
            return "application/pdf"
        case .tiff:
            return "image/tiff"
        case .text:
            return "text/plain"
        case .vnd:
            return "application/vnd"
        case .video:
            return "video/mp4"
        
        }
    }
    
    var fileName: String {
        switch self {
        case .jpeg:
            return "\(UUID().uuidString).jpeg"
        case .png:
            return "\(UUID().uuidString).png"
        case .gif:
            return "\(UUID().uuidString).gif"
        case .pdf:
            return "\(UUID().uuidString).pdf"
        case .tiff:
            return "\(UUID().uuidString).tiff"
        case .text:
            return "\(UUID().uuidString).txt"
        case .vnd:
            return "\(UUID().uuidString).vnd"
        case .video:
            return "\(UUID().uuidString).mp4"
        }
    }
}

extension Data {
    
    var format: MimeTypeSignatures {
        let array = [UInt8](self)
        switch array[0] {
        case 0xFF:
            return .jpeg
        case 0x89:
            return .png
        case 0x47:
            return .gif
        case 0x49, 0x4D :
            return .tiff
        case 0x25:
            return .pdf
        case 0xD0:
            return .vnd
        case 0x46:
            return .text
        default:
            return .video
        }
        
    }
}
