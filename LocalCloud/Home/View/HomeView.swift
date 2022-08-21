//
//  ContentView.swift
//  LocalCloud
//
//  Created by Ярослав Акулов on 11.08.2022.
//

import SwiftUI

struct HomeView: View {
    @StateObject var viewModel: HomeViewViewModel
    var body: some View {
        Group {
            if viewModel.user.token != nil {
                ContentView(viewModel: ContentViewViewModel(currentUser: viewModel.user,
                                                            parentFolder: viewModel.rootFolder))
            } else {
                AuthenticationView(viewModel: AuthenticationViewViewModel(currentUser: viewModel.user))
            }
        }
        .onAppear {
            viewModel.fetchUser()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        let context = CoreDataManager.shared.viewContext
        HomeView(viewModel: HomeViewViewModel(user: UserInfo()))
    }
}
