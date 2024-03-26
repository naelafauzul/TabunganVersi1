
//  SignInGoogle.swift
//  Tabungan
//
//  Created by Naela Fauzul Muna on 16/03/24.


import Foundation
import GoogleSignIn
import CryptoKit

@MainActor
class SignInGoogle {
    
    func startSignInWithGoogleFlow() async throws -> SignInGoogleResult{
        try await withCheckedThrowingContinuation { continuation in
            self.SignInWithGoogleFlow { result in
                continuation.resume(with: result)
            }
        }
    }
    
    func SignInWithGoogleFlow(completion: @escaping (Result<SignInGoogleResult, Error>) -> Void) {
        guard let topVC = UIApplication.getTopViewController() else {
            completion(.failure(NSError()))
            return
        }
        _ = randomNonceString()
        GIDSignIn.sharedInstance.signIn(
            withPresenting: topVC) { signInResult, error in
                guard let user = signInResult?.user, let idToken = user.idToken else {
                    completion(.failure(NSError()))
                    return
                }
                print(user)
                completion(.success(.init(idToken: idToken.tokenString, nonce: self.randomNonceString())))
            }
    }
    
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        var randomBytes = [UInt8](repeating: 0, count: length)
        let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
        if errorCode != errSecSuccess {
            fatalError(
                "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
            )
        }
        
        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        
        let nonce = randomBytes.map { byte in
            // Pick a random character from the set, wrapping around if needed.
            charset[Int(byte) % charset.count]
        }
        
        return String(nonce)
    }
    
}

extension UIApplication {
    
    class func getTopViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        
        if let nav = base as? UINavigationController {
            return getTopViewController(base: nav.visibleViewController)
            
        } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return getTopViewController(base: selected)
            
        } else if let presented = base?.presentedViewController {
            return getTopViewController(base: presented)
        }
        return base
    }
}
