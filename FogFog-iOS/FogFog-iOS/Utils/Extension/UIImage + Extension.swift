//
//  UIImage + Extension.swift
//  FogFog-iOS
//
//  Created by 김승찬 on 2023/11/22.
//

import UIKit.UIImage

extension UIImage {
  func resizedImage(sizeImage: CGSize) -> UIImage? {
    let frame = CGRect(origin: CGPoint.zero, size: CGSize(width: sizeImage.width, height: sizeImage.height))
    UIGraphicsBeginImageContextWithOptions(frame.size, false, 0)
    draw(in: frame)
    let resizedImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    withRenderingMode(.alwaysOriginal)
    return resizedImage
  }
}
