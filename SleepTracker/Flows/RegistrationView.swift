//
//  RegistrationView.swift
//  SleepTracker
//
//  Created by Liam Syversen on 7/22/24.
//

import SwiftUI

struct RegistrationView: View {
    @State var email = ""
    @State var fullname = ""
    @State var password = ""
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @EnvironmentObject var viewModel: AuthViewModel

    var body: some View {
        ZStack {
            Color(.black)
                .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 20) {
                Button {
                    mode.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "arrow.left")
                        .font(.title)
                        .imageScale(.medium)
                        .padding()
                }
                
                Text("Create new account")
                    .font(.system(size: 40))
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.leading)
                    .frame(width: 250)
                
                Spacer()

                VStack {
                    VStack(spacing: 56) {
                        CustomInputField(text: $fullname, title: "Full Name", placeholder: "Enter your name")
                        CustomInputField(text: $email, title: "Email Address", placeholder: "name@exmaple.com")
                            .autocapitalization(.none)
                        CustomInputField(text: $password, title: "Create Password", placeholder: "Enter your password", isSecureField: true)
                    }
                    .padding(.leading)
                    
                    Spacer()
                    
                    Button {
                        viewModel.registerUser(withEmail: email, password: password, fullName: fullname)
                    } label: {
                        Text("Sign Up")
                            .fontWeight(.semibold)
                            .frame(width: UIScreen.main.bounds.width - 32, height: 50)
                            .background(.white)
                            .cornerRadius(10)
                            .foregroundColor(.black)
                            .shadow(color: .white, radius: 2, x: 0, y: 0)
                    }
                    
                    Spacer()
                }
                
                Spacer()
            }
            .navigationBarHidden(true)
            .ignoresSafeArea()
            .foregroundColor(.white)
            .padding(.top, 32)
            
            //if viewModel.isAuthenticating {
               // CustomProgressView()
            //}
        }
    }
}

struct CustomInputField: View {
    @Binding var text: String
    let title: String
    let placeholder: String
    var isSecureField: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .fontWeight(.semibold)
                .font(.footnote)
                .foregroundColor(Color(.init(white: 1, alpha: 0.9)))
            
            ZStack(alignment: .leading) {
                if text.isEmpty {
                    Text(placeholder)
                        .foregroundColor(Color(.init(white: 1, alpha: 0.6)))
                }
                
                if isSecureField {
                    SecureField("", text: $text)
                } else {
                    TextField("", text: $text)
                }
            }
            .foregroundColor(.white)
            
            Rectangle()
                .foregroundColor(Color(.init(white: 1, alpha: 0.3)))
                .frame(width: UIScreen.main.bounds.width - 32, height: 0.7)
        }
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
    }
}
