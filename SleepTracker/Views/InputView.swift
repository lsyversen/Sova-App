//
//  InputView.swift
//  SleepTracker
//
//  Created by Liam Syversen on 7/22/24.
//


import SwiftUI

struct InputView: View {
    @Binding var text: String
    let title: String
    let placeholder: String
    let isSecureField: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .foregroundColor(Color(.darkGray))
                .fontWeight(.semibold)
                .font(.footnote)
            
            if isSecureField {
                SecureField(placeholder, text: $text)
                    .font(.system(size: 14))
            } else {
                TextField(placeholder, text: $text)
                    .font(.system(size: 14))
                    .disableAutocorrection(true)
            }
            
            Divider()
        }
    }
}

#Preview {
    InputView(text: .constant(""), title: "Email Address", placeholder: "name@example.com", isSecureField: false)
}

