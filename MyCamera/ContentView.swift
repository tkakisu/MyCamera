//
//  ContentView.swift
//  MyCamera
//
//  Created by takahiro kakisu on 2025/08/24.
//

import SwiftUI
import PhotosUI

struct ContentView: View {
    // 撮影した写真を保持する状態変数
    @State var captureImage: UIImage? = nil
    
    // 撮影画面（sheet）の開閉状態を管理
    @State var isShowSheet = false
    
    // フォトライブラリーで選択した写真を管理
    @State var photoPickerSelectedImage: PhotosPickerItem? = nil
    
    var body: some View {
        VStack {
            Spacer()
            
            // 「カメラを起動する」ボタン
            Button {
                // カメラが利用可能かチェック
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    print("カメラは利用できます")
                    
                    // 撮影写真を初期化する
                    captureImage = nil
                    
                    // カメラが使えるなら、isShowSheetをtrue
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
                if let captureImage {
                    // 撮影した写真がある→EffectViewを表示する
                    EffectView(isShowSheet: $isShowSheet, captureImage: captureImage)
                } else {
                    // UIImagePickerController（写真撮影）を表示
                    ImagePickerView(isShowSheet: $isShowSheet, captureImage: $captureImage)
                }
            }
            
            // フォトライブラリーから選択する
            PhotosPicker(selection: $photoPickerSelectedImage, matching: .images, preferredItemEncoding: .automatic, photoLibrary: .shared()) {
                
                Text("フォトライブラリーから選択する")
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color.blue)
                    .foregroundStyle(Color.white)
                    .padding()
            }
            // 選択した写真情報を元に写真を取り出す
            .onChange(of: photoPickerSelectedImage, initial: true, { oldValue, newValue in
                // 選択した写真があるとき
                if let newValue {
                    newValue.loadTransferable(type: Data.self) { result in
                        switch result {
                        case .success(let data):
                            // 写真があるとき
                            if let data {
                                // 写真をcaptureImageに保存
                                captureImage = UIImage(data: data)
                            }
                        case .failure:
                            return
                        }
                    }
                }
            })
        }
        // 撮影した写真を保持する状態変数が変化したら実行する
        .onChange(of: captureImage, initial: true, { oldValue, newValue in
            if let _ = newValue {
                // 撮影した写真がある→EffectViewを表示する
                isShowSheet.toggle()
            }
        })
    }
}

#Preview {
    ContentView()
}
