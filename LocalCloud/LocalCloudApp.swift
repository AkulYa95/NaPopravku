//
//  LocalCloudApp.swift
//  LocalCloud
//
//  Created by Ярослав Акулов on 11.08.2022.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct LocalCloudApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var user = UserInfo()
    var body: some Scene {
        WindowGroup {
            NavigationView {
                HomeView(viewModel: HomeViewViewModel(user: user))
            }
        }
    }
}
