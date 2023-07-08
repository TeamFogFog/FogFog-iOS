//
//  AppleLoginManager.swift
//  FogFog-iOS
//
//  Created by taekki on 2023/02/07.
//

import AuthenticationServices
import RxCocoa
import RxSwift

/// AppleUser
///
/// - id: 애플 idToken(로그인/회원가입 시 사용)
/// - email: 이메일
/// - origin: 애플 원본 Credential
struct AppleUser {
    var id: String
    var code: String
    var email: String
}

/// 애플 로그인 매니저
final class AppleLoginManager: NSObject {
    
    // 클래스 간 순환 참조 방지
    private weak var viewController: UIViewController?
    
    override init() {
        super.init()
    }
    
    convenience init(from viewController: UIViewController) {
        self.init()
        self.viewController = viewController
    }
    
    // 로그인 버튼 클릭 시 로직 수행 (request를 보내줄 controller를 생성)
    func handleAuthorizationAppleIDButtonPress() -> Observable<ASAuthorization> {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        let proxy = ASAuthorizationControllerProxy.proxy(for: authorizationController)

        authorizationController.presentationContextProvider = proxy
        authorizationController.performRequests()
        
        return proxy.didComplete
    }
    
    // 애플 로그인 상태 확인
    static func getCredentialState(completion: ((ASAuthorizationAppleIDProvider.CredentialState) -> Void)? = nil) {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        
        // TODO: 이후에 UserID 가져와서 체크
        appleIDProvider.getCredentialState(forUserID: "") { (credentialState, error) in
            switch credentialState {
            case .authorized:
                print("The Apple ID credential is valid.")
                break
            
            case .revoked:
                print("The Apple ID credential is revoked. need logout progress.")
                completion?(credentialState)
                break
                
            case .notFound:
                print("User identifier value is wrong or Apple login system has a problem.")
                completion?(credentialState)
                break
            default:
                break
            }
        }
    }
}
