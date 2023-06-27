//
//  InfoView.swift
//  Slot Machine
//
//  Created by kirshi on 6/26/23.
//

import SwiftUI

struct InfoView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            LogoView()
            
            Spacer()
            
            Form {
                Section(header: Text("About the application")) {
                    FormRowView(firstItem: "Application", secontItem: "Slot Machine")
                    FormRowView(firstItem: "Platform", secontItem: "iPhone, iPad, Mac")
                    FormRowView(firstItem: "Developer", secontItem: "Chitraarasu K")
                    FormRowView(firstItem: "Version", secontItem: "1.0.0")
                }
            }
            .font(.system(.body, design: .rounded))
        }
        .padding(.top, 40)
        .overlay(
            Button {
                audioPlayer?.stop()
                presentationMode.wrappedValue.dismiss()
            } label: {
                Image(systemName: "xmark.circle")
                    .font(.title)
            }
                .padding(.top, 30)
                .padding(.trailing, 20)
            , alignment: .topTrailing
        )
        .onAppear {
            playSound(sound: "background-music", type: "mp3")
        }
    }
}

struct FormRowView: View {
    var firstItem: String
    var secontItem: String
    
    var body: some View {
        HStack {
            Text(firstItem).foregroundColor(.gray)
            
            Spacer()
            
            Text(secontItem)
        }
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView()
    }
}
