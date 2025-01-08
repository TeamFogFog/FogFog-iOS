//
//  ModernHttpStatusCode.swift
//  FogFog-iOS
//
//  Created by MEGA_Mac on 1/8/25.
//

/// ModernNetworkError의 HTTP 상태 코드를 정의하고 관리
/// - Note: 서버 응답의 상태 코드에 따른 NetworkError 생성
/// - Author: seungchan
public enum ModernHTTPStatusCode: Int {
   /// 400: 잘못된 요청 (Bad Request)
   /// - 클라이언트의 요청이 유효하지 않은 경우
   case invalidRequest = 400
   
   /// 401: 인증 실패 (Unauthorized)
   /// - 소셜 로그인 토큰이 없거나 유효하지 않은 경우
   case unauthorized = 401
   
   /// 403: 접근 권한 없음 (Forbidden)
   /// - 요청 id와 accessToken 정보가 매칭되지 않는 경우
   case forbidden = 403
   
   /// 404: 리소스를 찾을 수 없음 (Not Found)
   /// - 유효한 유저 정보가 없는 경우
   case notFound = 404
   
   /// 409: 리소스 충돌 (Conflict)
   /// - 중복된 닉네임일 경우
   case duplicated = 409
   
   /// 500: 서버 내부 오류 (Internal Server Error)
   /// - 서버에서 처리 중 예기치 않은 오류가 발생한 경우
   case serverError = 500
   
   /// HTTP 상태 코드에 해당하는 NetworkError를 생성
   /// - Parameter data: 서버로부터 받은 에러 응답 데이터
   /// - Returns: 상태 코드와 에러 메시지를 포함한 NetworkError
   public func createError(with data: Data) -> NetworkError {
       let message = getErrorMessage(from: data)
       switch self {
       case .invalidRequest: return .invalidRequest(message: message)
       case .unauthorized: return .unauthorized(message: message)
       case .forbidden: return .forbidden(message: message)
       case .notFound: return .notFound(message: message)
       case .duplicated: return .duplicated(message: message)
       case .serverError: return .serverError(message: message)
       }
   }
   
   /// 서버 응답 데이터에서 에러 메시지를 추출
   /// - Parameter data: 서버로부터 받은 에러 응답 데이터
   /// - Returns: 에러 메시지 문자열. 디코딩 실패 시 nil 반환
   private func getErrorMessage(from data: Data) -> String? {
       try? JSONDecoder().decode(ErrorResponse.self, from: data).message
   }
}
