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
            MainSidebar()
            PlannerView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct MainSidebar: View {
    var body: some View {
        NavigationView {
            #if os(macOS)
            MainSidebarContent()
                .frame(minWidth: 200, idealWidth: 250, maxWidth: 300)
            #else
            MainSidebarContent()
                .navigationTitle("View")
            #endif
        }
    }
}

struct MainSidebarContent: View {
    var body: some View {
        List {
            Label("My Day", systemImage: "cloud.sun")
            Label("Planner", systemImage: "calendar")
            Label("Reminders", systemImage: "checkmark.circle")
//            Label("Notes", systemImage: "note.text")
        }
        .listStyle(SidebarListStyle())
    }
}
