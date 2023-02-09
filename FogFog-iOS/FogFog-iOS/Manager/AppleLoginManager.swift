//
//  AppleLoginManager.swift
//  FogFog-iOS
//
//  Created by taekki on 2023/02/07.
//

import AuthenticationServices

/// AppleUser
///
/// - id: 애플 idToken(로그인/회원가입 시 사용)
/// - email: 이메일
/// - origin: 애플 원본 Credential
struct AppleUser {
    var id: String
    var email: String
    var origin: Any
    
    init(credential: ASAuthorizationAppleIDCredential) {
        self.id = credential.user
        self.email = credential.email ?? ""
        self.origin = credential
    }
}

/// 애플 로그인 매니저
final class AppleLoginManager: NSObject {
    
    // 클래스 간 순환 참조 방지
    private weak var viewController: UIViewController?
    var loggedIn: ((_ status: Bool, _ message: String, _ user: AppleUser?) -> Void)?
    
    override init() {
        super.init()
    }
    
    convenience init(from viewController: UIViewController) {
        self.init()
        self.viewController = viewController
    }
    
    convenience init(with button: UIButton, from viewController: UIViewController) {
        self.init()
        button.addTarget(self, action: #selector(handleAuthorizationAppleIDButtonPress), for: .touchUpInside)
        self.viewController = viewController
    }
    
    // 로그인 버튼 클릭 시 로직 수행
    @objc func handleAuthorizationAppleIDButtonPress() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
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

// MARK: ASAuthorizationControllerDelegate
extension AppleLoginManager: ASAuthorizationControllerDelegate {
    
    // Apple 로그인 성공
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            let appleUser = AppleUser(credential: appleIDCredential)
            loggedIn?(true, "", appleUser)
            
        default:
            loggedIn?(false, "Apple credential is not found", nil)
        }
    }
    
    // Apple 로그인 실패
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        loggedIn?(false, error.localizedDescription, nil)
    }
}

// MARK: ASWebAuthenticationPresentationContextProviding
extension AppleLoginManager: ASAuthorizationControllerPresentationContextProviding {
    
    // Apple 로그인 모달 시트
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return viewController!.view.window!
    }
}
