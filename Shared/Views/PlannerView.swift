//
//  PlannerView.swift
//  EinTag
//
//  Created by Alex Seifert on 12/19/20.
//

import SwiftUI

struct PlannerView: View {
    var body: some View {
        List(0 ..< 20) {_ in
            Text("Book")
        }
    }
}

struct PlannerView_Previews: PreviewProvider {
    static var previews: some View {
        PlannerView()
    }
}
