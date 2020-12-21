//
//  Elements.swift
//  EinTag
//
//  Created by Alex Seifert on 12/21/20.
//

import SwiftUI

struct HeaderElement: View {
    private var text: String
    private var showDivider: Bool
    
    init(text: String, showDivider: Bool = true) {
        self.text = text
        self.showDivider = showDivider
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(self.text)
                .font(.subheadline)
                .textCase(/*@START_MENU_TOKEN@*/.uppercase/*@END_MENU_TOKEN@*/)
                .opacity(0.7)
            
            if showDivider {
                Divider()
            }
        }
        .padding(.bottom, 8)
    }
}
