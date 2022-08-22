//
//  User.swift
//  LocalCloud
//
//  Created by Ярослав Акулов on 13.08.2022.
//

import Foundation
import Firebase

class UserInfo: ObservableObject {
    
    @Published var userID: String? = {
        let auth = Auth.auth()
        return auth.currentUser?.uid
    }()
    
    var email: String? = {
        let auth = Auth.auth()
        return auth.currentUser?.email
    }()
    
    @Published var token: String? 
    
    func getToken(completion: @escaping (Error?) -> Void = { _ in }) {
        let auth = Auth.auth()
        auth.currentUser?.getIDToken(completion: { token, error in
            guard error == nil else {
                completion(error)
                return
            }
            self.token = token
            completion(nil)
        })
    }
}
