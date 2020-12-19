//
//  MyDayView.swift
//  EinTag
//
//  Created by Alex Seifert on 12/19/20.
//

import SwiftUI

struct MyDayView: View {
    #if !os(macOS)
    @Environment(\.horizontalSizeClass) var sizeClass
    #endif
    
    var body: some View {
        VStack(alignment: .leading) {
            AdaptiveStack(verticalAlignment: .top) {
                Text(getLocalizedDate())
                    .font(.system(size: 35.0))
                
                #if os(macOS)
                Spacer()
                #else
                if sizeClass != .compact {
                    Spacer()
                }
                #endif
                
                MyDayWeatherView()
            }
            .padding()
            Spacer()
        }
        .frame(
            minWidth: 400,
            maxWidth: .infinity,
            minHeight: 200,
            maxHeight: .infinity,
            alignment: .topLeading
        )
    }
}

struct MyDayView_Previews: PreviewProvider {
    static var previews: some View {
        MyDayView()
    }
}

struct MyDayWeatherView: View {
    var body: some View {
        HStack(alignment: .bottom, spacing: 6) {
            Image(systemName: "cloud.sun.bolt.fill")
                .font(.system(size: 60.0))
            
            Text("5°C")
                .font(.title)
                .padding()
        }
    }
}
