//
//  AuthViewModel.swift
//  SleepTracker
//
//  Created by Liam Syversen on 7/22/24.
import SwiftUI
import Foundation
import Firebase

class AuthViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    @Published var isAuthenticating = false
    @Published var error: Error?
    @Published var user: User?
    
    init() {
        userSession = Auth.auth().currentUser
        fetchUser()
    }
    
    func signIn(withEmail email: String, password: String) {
        self.isAuthenticating = true
        
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                print("DEBUG: Failed to sign in with error: \(error.localizedDescription)")
                self.isAuthenticating = false
                self.error = error
                return
            }
            
            self.isAuthenticating = false
            self.userSession = result?.user
            self.fetchUser()
        }
    }
    
    func registerUser(withEmail email: String, password: String, fullName: String) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                print("DEBUG: Failed to sign up with error \(error.localizedDescription)")
                return
            }
            
            print("DEBUG: Registered user successfully")
         
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.userSession = nil
            self.user = nil
            print("DEBUG: Signed out")
        } catch let error {
            print("DEBUG: Failed to sign out with error \(error.localizedDescription)")
        }
    }
    
    func fetchUser() {
        guard let uid = userSession?.uid else { return }
        
        UserService.fetchUser(withUid: uid) { user in
            self.user = user
        }
    }
    
    func deleteAccount() {
        guard let user = Auth.auth().currentUser else { return }
        
        user.delete { error in
            if let error = error {
                print("DEBUG: Failed to delete user with error \(error.localizedDescription)")
                self.error = error
                return
            }
            
            self.userSession = nil
            self.user = nil
            print("DEBUG: User account deleted successfully")
        }
    }
}

