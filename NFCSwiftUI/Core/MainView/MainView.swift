//
//  ContentView.swift
//  NFCSwiftUI
//
//  Created by Ульяна Гритчина on 10.08.2023.
//

import SwiftUI

struct MainView: View {
    @StateObject var vm = MainViewModel()
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                
                urlTextField
                
                Spacer()
                
                writeToTagButton
            }
            .padding()
            .navigationTitle("NFC")
        }
        .onTapGesture {
            hideKeyboard()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

extension MainView {
    
    private var urlTextField: some View {
        TextField("Url", text: $vm.stringURL)
            .padding()
            .background(
                Color.secondary
                    .opacity(0.15)
                    .cornerRadius(10)
            )
    }
    
    private var writeToTagButton: some View {
        Button(action: vm.writeToTag) {
            Text("Write to tag")
                .foregroundColor(.white)
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue.cornerRadius(10))
        }
    }
    
}
