//
//  CustomProgressView.swift
//  SleepTracker
//
//  Created by Liam Syversen on 7/22/24.
//

import SwiftUI

struct CustomProgressView: View {
    var body: some View {
        ProgressView()
            .progressViewStyle(.circular)
            .accentColor(.white)
            .scaleEffect(x: 2, y: 2, anchor: .center)
            .frame(width: 96, height: 96)
            .background(Color(.systemGray4))
            .cornerRadius(20)
    }
}

struct CustomProgressView_Previews: PreviewProvider {
    static var previews: some View {
        CustomProgressView()
    }
}

