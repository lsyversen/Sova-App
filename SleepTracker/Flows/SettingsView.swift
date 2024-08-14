//
//  SettingsView.swift
//  SleepTracker
//
//  Created by Liam Syversen on 8/3/24.
//
import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var showSignOutAlert = false
    @State private var showDeleteAccountAlert = false
    
    var body: some View {
        VStack {
            List {
                Section("Tracker") {
                    SettingsRowView(imageName: "bell", title: "Sleep Reminder", tintColor: Color.primaryTextColor)
                    SettingsRowView(imageName: "alarm.fill", title: "Smart Alarm", tintColor: Color.primaryTextColor)
                }
                
                Section("Account") {
                    SettingsRowView(imageName: "arrow.left.circle.fill", title: "Sign Out", tintColor: Color.primaryTextColor)
                        .onTapGesture {
                            showSignOutAlert = true
                        }
                        .alert(isPresented: $showSignOutAlert) {
                            Alert(
                                title: Text("Are you sure?"),
                                message: Text("Do you really want to sign out?"),
                                primaryButton: .destructive(Text("Yes")) {
                                    viewModel.signOut()
                                },
                                secondaryButton: .cancel()
                            )
                        }
                    
                    SettingsRowView(imageName: "trash.fill", title: "Delete Account", tintColor: Color.primaryTextColor)
                        .onTapGesture {
                            showDeleteAccountAlert = true
                        }
                        .alert(isPresented: $showDeleteAccountAlert) {
                            Alert(
                                title: Text("Are you sure?"),
                                message: Text("Do you really want to delete your account?"),
                                primaryButton: .destructive(Text("Yes")) {
                                    viewModel.deleteAccount()
                                },
                                secondaryButton: .cancel()
                            )
                        }
                }

                Section("Other") {
                    SettingsRowView(imageName: "questionmark.circle", title: "FAQ", tintColor: Color.primaryTextColor)
                    SettingsRowView(imageName: "shield", title: "Privacy Policy", tintColor: Color.primaryTextColor)
                    SettingsRowView(imageName: "doc.text", title: "Terms of Service", tintColor: Color.primaryTextColor)
                    SettingsRowView(imageName: "bubble.left.and.bubble.right", title: "Feedback", tintColor: Color.primaryTextColor)
                }
            }
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.large)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView().environmentObject(AuthViewModel())
    }
}

