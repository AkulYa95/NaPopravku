//
//  AuthenticationView.swift
//  LocalCloud
//
//  Created by Ярослав Акулов on 11.08.2022.
//

import SwiftUI

struct AuthenticationView: View {
    @ObservedObject var viewModel: AuthenticationViewViewModel
    var body: some View {
        ZStack {
            VStack {
                Text(viewModel.title)
                    .foregroundColor(.white)
                    .font(.title)
                Spacer()
                TextField(viewModel.emailPlaceholder, text: $viewModel.email)
                    .disableAutocorrection(true)
                Divider().ignoresSafeArea(.keyboard)
                SecureField(viewModel.passwordPlaceholder, text: $viewModel.password)
                Spacer(minLength: 10)
                Button {
                    viewModel.signIn()
                    
                } label: {
                    Text(viewModel.logInTitle)
                        .frame(maxWidth: 311, maxHeight: 48)
                        .background(.blue)
                        .cornerRadius(10)
                        .foregroundColor(.white).opacity(viewModel.buttonOpacity)
                        .shadow(radius: 10)
                }
                .disabled(!viewModel.isValid)
                Button {
                    viewModel.signUp()
                } label: {
                    Text(viewModel.registrationTitle)
                        .foregroundColor(.accentColor).opacity(viewModel.buttonOpacity)
                }
                .disabled(!viewModel.isValid)
                Spacer()
            }
            if viewModel.isLoading {
                ProgressView()
            }
        }
        .padding()
        .navigationTitle(Text("Authentication"))
        .alert(isPresented: $viewModel.isNeedAlert, content: {
            Alert(title: Text(viewModel.alertMessage),
                  dismissButton: .default(Text("OK")))
        })
    }
}

struct AuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationView(viewModel: AuthenticationViewViewModel(currentUser: UserInfo()))
    }
}
