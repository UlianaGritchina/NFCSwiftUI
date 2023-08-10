//
//  View + Extension.swift
//  NFCSwiftUI
//
//  Created by Ульяна Гритчина on 10.08.2023.
//

import SwiftUI

extension View {
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
}
