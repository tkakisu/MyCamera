//
//  UIImageExtension.swift
//  MyCamera
//
//  Created by takahiro kakisu on 2025/09/02.
//

import Foundation
import UIKit

extension UIImage {
    func resized() -> UIImage? {
        // リサイズの比率を計算
        let rate = 1024.0 / self.size.width
        // リサイズ後の画像サイズを計算
        let targetSize = CGSize(width: self.size.width * rate, height: self.size.height * rate)
        // 新しいサイズに基づいて画像レンダラーを作成
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        // 新しいサイズに基づいて元の画像を描画
        return renderer.image { _ in
            draw(in: CGRect(origin: .zero, size: targetSize))
        }
    }
}
