//
//  SmokePlace.swift
//  FogFog-iOS
//
//  Created by taekki on 2022/11/20.
//

import UIKit

/// 흡연구역에 대한 상세 정보
/// - placeImage: 흡연구역 이미지(서버에서 받아온 url 변환해서 사용)
/// - distance: 현재 위치 기준으로 떨어진 거리
/// - placeTitle: 흡연구역명
/// - placeAddress: 흡연구역 상세주소
struct SmokePlace {
    let placeImage: UIImage
    let distance: Int
    let placeTitle: String
    let placeAddress: String
}
