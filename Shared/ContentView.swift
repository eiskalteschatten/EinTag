//
//  ContentView.swift
//  Shared
//
//  Created by Alex Seifert on 12/19/20.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            Sidebar()
            List(0 ..< 20) {_ in
                Text("Book")
            }
            .navigationTitle("Book List")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Sidebar: View {
    var body: some View {
        NavigationView {
            #if os(iOS)
                SidebarContent()
                    .navigationTitle("Code")
            #else
                SidebarContent()
                    .frame(minWidth: 200, idealWidth: 250, maxWidth: 300)
            #endif
        }

    }
}

struct SidebarContent: View {
    var body: some View {
        List {
            Label("My Day", systemImage: "cloud.sun")
            Label("Planner", systemImage: "calendar")
            Label("Reminders", systemImage: "checkmark.circle")
            Label("Notes", systemImage: "note.text")
        }
        .listStyle(SidebarListStyle())
        .navigationTitle("Code")
    }
}
