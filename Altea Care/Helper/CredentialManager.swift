//
//  CredentialManager.swift
//  Altea Care
//
//  Created by Hedy on 24/08/21.
//

import Foundation

struct UserCredential: Codable {
    let id: String //means patientId
    var email: String
    let accessToken: String
    let refreshToken: String
    let userName : String
}

class CredentialManager {
    static let shared = CredentialManager()
    private init() { }
    
    func getCredentials() -> [UserCredential] {
        return Preference.structArrayData(UserCredential.self, forKey: .UserCredentials)
    }
    
    func addUserCredential(_ creds: UserCredential) {
        var current = self.getCredentials()
        let target = current.filter { $0.email == creds.email }
        if target.isEmpty {
            current.append(creds)
            Preference.setStructArray(current, forKey: .UserCredentials)
        }
    }
    
    func removeUserCredentialFrom(email: String) {
        var current = self.getCredentials()
        guard let target = current.firstIndex(where: { $0.email == email }) else { return }
        current.remove(at: target)
        Preference.setStructArray(current, forKey: .UserCredentials)
    }
    
    func changeEmailUserCredential(newEmail: String, oldEmail: String) {
        var current = self.getCredentials()
        if let row = current.firstIndex(where: {$0.email == oldEmail}) {
            current[row].email = newEmail
        }
        Preference.setStructArray(current, forKey: .UserCredentials)
    }
    
    func setPrimaryCredentialFrom(email: String) -> Bool {
        guard let target = self.getCredentials().first(where: { $0.email == email }) else { return false }
        HTTPAuth.shared.saveBearer(token: target.accessToken)
        HTTPAuth.shared.saveRefresh(token: target.refreshToken)
        return true
    }
}
