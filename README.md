![폭폭 대표사진](https://github.com/TeamFogFog/FogFog-iOS/assets/63277563/d36deffe-2dd5-415d-bc60-bba1c7da6e50)
> **내 근처 가까운 흡연구역, 포그포그**   
> 공공데이터를 활용한 흡연구역 지도 서비스
>
> **21th SOPT-Term Project 인기상 🏆**    
> 프로젝트 기간: 2022.10 ~ 2022.11    
> 앱스토어 출시 준비 중

## iOS Developers
<img src="https://github.com/TeamFogFog/FogFog-iOS/assets/63277563/e694b13e-92e8-460f-915a-b33e48e93941" width="200"> | <img src="https://github.com/TeamFogFog/FogFog-iOS/assets/63277563/0f5e7272-0642-45b1-9dcd-3f386f5a5bc1" width="200"> | <img src="https://github.com/TeamFogFog/FogFog-iOS/assets/63277563/9ea75f32-3315-4d8a-948f-7ae57fb563c1" width="200"> |
 :---------:|:----------:|:---------:|
 김승찬 | 김태현 | 최은주
 [@seungchan2](https://github.com/seungchan2) | [@Taehyeon-Kim](https://github.com/Taehyeon-Kim) | [@jane1choi](https://github.com/jane1choi) | 

## 프로젝트 소개
### 주요 기능
<img src="https://github.com/TeamFogFog/FogFog-iOS/assets/63277563/eb1f8d52-8d36-4d3c-8269-f3bded5e3b9e.jpg" width="240"> <img src="https://github.com/TeamFogFog/FogFog-iOS/assets/63277563/64c7e954-ea20-43cc-9ce9-76971caff968.jpg" width="240"> <img src="https://github.com/TeamFogFog/FogFog-iOS/assets/63277563/cbd19d84-c1b2-4afc-a4c5-c83d070579a4.jpg" width="240"> <img src="https://github.com/TeamFogFog/FogFog-iOS/assets/63277563/c2416b69-ebee-4b49-a513-dd35ce8b2cf6.jpg" width="240">

- **현재 위치에서 가까운 흡연구역 찾기**   
  지도를 통해 현재 위치에서 가까운 흡연구역을 빠르게 찾을 수 있습니다.
- **흡연구역 정보 확인하기**   
  가까운 흡연구역까지의 거리, 상세 주소 등 기본적인 정보를 빠르게 확인할 수 있으며 길 찾기 기능을 통해 쉽게 찾아갈 수 있습니다.
- **사이드 바를 활용한 부가 기능**    
  사이드 바에서 길 찾기 시 연결할 지도 앱을 설정하고, 앱 내 등록되어 있지 않은 흡연구역을 제보할 수 있습니다.

### 개발 환경
<p align="left">
<img src ="https://img.shields.io/badge/Swift-5.7-ff69b4">
<img src ="https://img.shields.io/badge/Xcode-14.0-blue">
<img src ="https://img.shields.io/badge/iOS-15.5-orange">
<img src ="https://img.shields.io/badge/SPM-0.6.0-green">
<img src ="https://img.shields.io/badge/CocoaPods-1.11.3-yellow">
<br>

### 라이브러리
| 라이브러리(Library) | 버전(Version) | 사용목적(Purpose) |
|:---|:----------|:---|
| SnapKit| 5.6.0 | Layout |
| Then | 3.0.0 | Layout |
| FlexLayout| 1.3.33 | Layout |
| PinLayout| 1.10.4 | Layout |
| RxSwift | 6.5.0 | 비동기 처리 |
| Moya| 15.0.0 | 서버 통신 |
| GoogleMaps| 6.1.0 | 구글 지도 |
| KakaoOpenSDK| 2.15.0 | 카카오 소셜 로그인 |
<br>

## 프로젝트 구조
### App Architecture: MVVM-C
<img width="950" alt="MVVM-C" src="https://github.com/TeamFogFog/FogFog-iOS/assets/63277563/4b6c561b-5ba1-4029-be48-eebddc3ae4b1">

### 폴더 구조
```
FogFog-iOS
 ┣ 📂App
 ┃ ┣ AppDelegate.swift
 ┃ ┗ SceneDelegate.swift
 ┣ 📂Manager
 ┣ 📂Models
 ┣ 📂Networking
 ┃ ┣ 📂APIServices
 ┃ ┣ 📂APIs
 ┃ ┣ 📂Foundation
 ┃ ┣ 📂Models
 ┃ ┗ 📂Monitoring
 ┣ 📂OAuth
 ┣ 📂Presentation
 ┃ ┣ 📂Common
 ┃ ┣ 📂ExternalMap
 ┃ ┣ 📂Login
 ┃ ┣ 📂Map
 ┃ ┣ 📂Setting
 ┃ ┣ 📂SideBar
 ┃ ┣ 📂SmokingArea
 ┃ ┗ 📂Splash
 ┣ 📂Resources
 ┃ ┣ LaunchScreen.storyboard
 ┃ ┣ 📂Colors
 ┃ ┣ 📂Fonts
 ┃ ┗ 📂Image
 ┣ 📂Supports
 ┃ ┣ Config.xcconfig
 ┃ ┣ GoogleMap.plist
 ┃ ┗ Info.plist
 ┗ 📂Utils
   ┣ 📂Analytics
   ┣ 📂Base
   ┣ 📂Class
   ┣ 📂Contstant
   ┣ 📂Extension
   ┣ 📂Logging
   ┣ 📂UIComponents
   ┗ 📂Wrapper
```
