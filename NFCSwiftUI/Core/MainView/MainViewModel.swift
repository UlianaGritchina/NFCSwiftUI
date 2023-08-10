//
//  MainViewModel.swift
//  NFCSwiftUI
//
//  Created by Ульяна Гритчина on 10.08.2023.
//

import Foundation

final class MainViewModel: ObservableObject {
    
    @Published var stringURL: String = ""
    
    private let nfcWriter = NFCManager()
    
    func writeToTag() {
        nfcWriter.scan(actualData: stringURL)
    }
}
