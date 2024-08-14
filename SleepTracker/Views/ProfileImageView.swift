//
//  ProfileImageView.swift
//  SleepTracker
//
//  Created by Liam Syversen on 7/26/24.
//

import SwiftUI
import Kingfisher

struct ProfileImageView: View {
    let imageUrl: String?
    var body: some View {
        
        ZStack {
            if let imageUrl = imageUrl {
                KFImage(URL(string: imageUrl))
                    .resizable()
                    .scaledToFill()
                    .clipped()
//                    .frame(width: 64, height: 64)
                    .clipShape(Circle())
                    .padding(.bottom, 16)
            } else {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .scaledToFill()
                    .clipped()
//                    .frame(width: 64, height: 64)
                    .clipShape(Circle())
                    .padding(.bottom, 16)
                    .foregroundColor(Color(.systemGray4))
            }
        }
    }
}

struct ProfileImageView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileImageView(imageUrl: "https://firebasestorage.googleapis.com:443/v0/b/uberswiftui.appspot.com/o/profile_images%2F25278BB7-63BF-4278-9EBE-A6CD1EA6B584?alt=media&token=19419f9e-64bb-4f87-a5e7-d42d88113de5")
    }
}
