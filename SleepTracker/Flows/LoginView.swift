//
//  LoginView.swift
//  SleepTracker
//
//  Created by Liam Syversen on 7/22/24.
//


import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @EnvironmentObject var authViewModel: AuthViewModel
    var body: some View {
        NavigationView {
            ZStack {
                Color(.black)
                    .ignoresSafeArea()
                
                VStack {
                    VStack(spacing: -16) {
                        Image("sova-icon")
                            .resizable()
                            .frame(width: 200, height: 200)
                            .scaledToFill()
                        
                        Text("SOVA")
                            .foregroundColor(.white)
                            .font(.largeTitle)
                    }
                    
                    VStack(spacing: 32) {
                        CustomInputField(text: $email, title: "Email Address", placeholder: "name@example.com")
                            .padding(.leading)
                            .autocapitalization(.none)
                        
                        CustomInputField(text: $password, title: "Password", placeholder: "Enter your password", isSecureField: true)
                            .padding(.leading)
                        
                        HStack {
                            Spacer()
                            Button(action: {
                            }, label: {
                                Text("Forgot Password?")
                                    .font(.system(size: 13, weight: .semibold))
                                    .foregroundColor(.white)
                                    .padding(.top)
                                    .padding(.trailing, 28)
                            })
                        }

                    }
                    .padding(.top, 12)
                    
                    SocialSignUpView()
                    
                    Spacer()
                                    
                    Button {
                        authViewModel.signIn(withEmail: email, password: password)
                    } label: {
                        HStack {
                            Text("SIGN IN")
                                .foregroundColor(.black)
                            
                            Image(systemName: "arrow.right")
                                .foregroundColor(.black)
                            
                        }
                        .frame(width: UIScreen.main.bounds.width - 32, height: 50)
                        .background((Color.white))
                        .cornerRadius(10)
                    }
                    .padding(.bottom, 32)

                    
                    NavigationLink(
                        destination: RegistrationView().navigationBarBackButtonHidden(true),
                        label: {
                            HStack {
                                Text("Don't have an account?")
                                    .font(.system(size: 14))
                                Text("Sign Up")
                                    .font(.system(size: 14, weight: .semibold))
                            }
                            .foregroundColor(.white)
                        }).padding(.bottom, 24)

                }
                //.blur(radius: viewModel.isAuthenticating ? 4 : 0)
                
                //if viewModel.isAuthenticating {
                  //  CustomProgressView()
                //}
                
            }
            .navigationBarHidden(true)
        }
    }
}

struct TextFieldModifier: ViewModifier {
    
    func body(content: Content) -> some View {
            content
            .padding()
            .background(Color(.init(white: 1, alpha: 0.15)))
            .cornerRadius(10)
            .foregroundColor(.white)
            .padding(.horizontal)
        }
    
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
