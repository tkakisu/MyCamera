//
//  ContentView.swift
//  MyCamera
//
//  Created by takahiro kakisu on 2025/08/24.
//

import SwiftUI

struct ContentView: View {
    // 撮影した写真を保持する状態変数
    @State var captureImage: UIImage? = nil
    
    // 撮影画面（sheet）の開閉状態を管理
    @State var isShowSheet = false
    
    var body: some View {
        VStack {
            Spacer()
            
            // 撮影した写真があるとき
            if let captureImage {
                // 撮影写真を表示
                Image(uiImage: captureImage)
                    .resizable()
                    .scaledToFit()
            }
            
            Spacer()
            
            // 「カメラを起動する」ボタン
            Button {
                // カメラが利用可能かチェック
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    print("カメラは利用できます")
                    
                    isShowSheet.toggle()
                } else {
                    print("カメラは利用できません")
                }
            } label: {
                Text("カメラを起動する")
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .foregroundStyle(Color.white)
            }
            .padding()
            .sheet(isPresented: $isShowSheet) {
                // UIImagePickerController（写真撮影）を表示
                ImagePickerView(isShowSheet: $isShowSheet, captureImage: $captureImage)
            }
            
            // captureImageをアンラップする
            if let captureImage {
                // captureImageから共有する画像を生成する
                let shareImage = Image(uiImage: captureImage)
                
                // 共有シート
                ShareLink(item: shareImage, subject: nil, message: nil, preview: SharePreview("Photo", image: shareImage)) {
                    
                    Text("SNSに投稿する")
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.blue)
                        .foregroundStyle(Color.white)
                        .padding()
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
