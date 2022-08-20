//
//  HomeViewViewModel.swift
//  LocalCloud
//
//  Created by Ярослав Акулов on 17.08.2022.
//

import Foundation
import CoreData

class HomeViewViewModel: ObservableObject {
    
    @Published var user: UserInfo
    
    func fetchUser() {
//        user.getToken()
    }

    init(user: UserInfo) {
        self.user = user
    }
}
