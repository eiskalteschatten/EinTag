//
//  MyDayView.swift
//  EinTag
//
//  Created by Alex Seifert on 12/19/20.
//

import SwiftUI

struct MyDayView: View {
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(getLocalizedDate())
                    .font(.system(size: 35.0))
                Spacer()
                MyDayWeatherView()
            }
            .padding()
            Spacer()
        }
        .frame(
            minWidth: 0,
            maxWidth: .infinity,
            minHeight: 0,
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
        Image(systemName: "cloud.sun.bolt.fill")
            .font(.system(size: 60.0))
    }
}
