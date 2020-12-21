//
//  Elements.swift
//  EinTag
//
//  Created by Alex Seifert on 12/21/20.
//

import SwiftUI

struct HeaderElement: View {
    private var text: String
    
    init(text: String) {
        self.text = text
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(self.text)
                .font(.subheadline)
                .textCase(/*@START_MENU_TOKEN@*/.uppercase/*@END_MENU_TOKEN@*/)
                .opacity(0.7)
            
            Divider()
        }
        .padding(.bottom, 8)
    }
}
