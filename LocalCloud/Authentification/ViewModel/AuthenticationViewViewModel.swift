//
//  AuthenticationViewViewModel.swift
//  LocalCloud
//
//  Created by Ярослав Акулов on 11.08.2022.
//

import Combine
import FirebaseAuth

class AuthenticationViewViewModel: ObservableObject {
    // Input
    @Published var email = ""
    @Published var password = ""
    
    // Output
    @Published var isValid = false
    @Published var isNeedAlert = false
    @Published var alertMessage = ""
    @Published var isLoading = false
    
    var currentUser: UserInfo
    var emailPlaceholder = "Email"
    var passwordPlaceholder = "Password"
    var logInTitle = "LOG IN"
    var registrationTitle = "REGISTRATION"
    var title = "Authentication"
    var buttonOpacity: Double {
        return isValid ? 1.0 : 0.5
    }
    private let auth = Auth.auth()
    private var cancellableSet: Set<AnyCancellable> = []
    private var isEmailEmptyPublisher: AnyPublisher<Bool, Never> {
        $email
            .map({ !$0.isEmpty })
            .eraseToAnyPublisher()
    }
    private var isPasswordEmptyPublisher: AnyPublisher<Bool, Never> {
        $password
            .map { !$0.isEmpty }
            .eraseToAnyPublisher()
    }
    private var isValidPublisher: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest(isEmailEmptyPublisher, isPasswordEmptyPublisher)
            .map { $0 == true && $1 == true }
            .eraseToAnyPublisher()
    }
    
    init(currentUser: UserInfo) {
        self.currentUser = currentUser
        isValidPublisher
            .receive(on: RunLoop.main)
            .assign(to: \.isValid, on: self)
            .store(in: &cancellableSet)
    }
    
    func signIn() {
        isLoading.toggle()
        auth.signIn(withEmail: email, password: password) { result, error in
            
            self.isLoading.toggle()
            guard error == nil else {
                self.alertMessage = error?.localizedDescription ?? "UnknownError"
                self.isNeedAlert.toggle()
                return
            }
            
            guard result != nil else {
                self.alertMessage = error?.localizedDescription ?? "UnknownError"
                self.isNeedAlert.toggle()
                return
            }

            self.currentUser.getToken { error in
                guard error == nil else { return }
                self.currentUser.userID = result?.user.uid
                self.currentUser.email = result?.user.email
            }
        }
    }
    
    func signUp() {
        isLoading.toggle()
        auth.createUser(withEmail: email, password: password) { result, error in
            self.isLoading.toggle()
            guard error == nil else {
                self.alertMessage = error?.localizedDescription ?? "UnknownError"
                self.isNeedAlert.toggle()
                return
            }
            guard result != nil else {
                self.alertMessage = error?.localizedDescription ?? "UnknownError"
                self.isNeedAlert.toggle()
                return
            }
            
            self.alertMessage = "Your Account has been successfully created"
            self.isNeedAlert.toggle()
        }
    }
    
}
