//
//  MyTripsView.swift
//  SleepTracker
//
//  Created by Liam Syversen on 7/26/24.
//
import SwiftUI

struct MyTripsView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    let user: User

    var body: some View {
        VStack(alignment: .leading, spacing: -16) {
            
            HStack {
                VStack(alignment: .leading) {
                    Button {
                        mode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "arrow.left")
                            .font(.title)
                            .imageScale(.medium)
                            .padding()
                            .foregroundColor(.black)
                    }
                    
                    Text("My Trips")
                        .font(.title)
                        .fontWeight(.semibold)
                        .padding(.leading)
                }
                Spacer()
            }
            .padding(.leading, 4)
            .padding(.bottom)
            .background(.white)
            
            ScrollView {
            }
            .padding(.top, 44)
            .ignoresSafeArea()
        }
        .padding(.bottom)
        .background(Color.backgroundColor)
        .navigationBarHidden(true)
    }
}

struct MyTripsView_Previews: PreviewProvider {
    static var previews: some View {
        MyTripsView(user: dev.mockPassenger)
    }
}
