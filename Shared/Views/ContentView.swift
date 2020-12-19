//
//  ContentView.swift
//  Shared
//
//  Created by Alex Seifert on 12/19/20.
//

import SwiftUI

enum Screen: Hashable {
   case myDay, planner, reminders, notes, news
}

struct ContentView: View {
    @State var screen: Screen? = .myDay
    
    var body: some View {
        NavigationView {
            MainSidebar(screen: $screen)
            MyDayView()
        }
        .navigationViewStyle(DoubleColumnNavigationViewStyle())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
                .previewDevice("iPad Air (4th generation)")
                .preferredColorScheme(.dark)
            ContentView()
                .preferredColorScheme(.dark)
                .previewDevice("iPhone 11")
        }
    }
}

struct MainSidebar: View {
    @Binding var screen: Screen?
    
    var body: some View {
        #if os(macOS)
        MainSidebarContent(state: $screen)
            .frame(minWidth: 200, idealWidth: 250, maxWidth: 300)
        #else
        MainSidebarContent(state: $screen)
        #endif
    }
}

struct MainSidebarContent: View {
    @Binding var state: Screen?
    
    var body: some View {
        List {
            NavigationLink(
                destination: MyDayView().navigationTitle("My Day"),
                tag: Screen.myDay,
                selection: $state,
                label: {
                    Label("My Day", systemImage: "cloud.sun")
                }
            )
            NavigationLink(
                destination: PlannerView().navigationTitle("Planner"),
                tag: Screen.planner,
                selection: $state,
                label: {
                    Label("Planner", systemImage: "calendar")
                }
            )
            NavigationLink(
                destination: RemindersView().navigationTitle("Reminders"),
                tag: Screen.reminders,
                selection: $state,
                label: {
                    Label("Reminders", systemImage: "checkmark.circle")
                }
            )
//            NavigationLink(
//                destination: PlannerView().navigationTitle("Notes"),
//                tag: Screen.notes,
//                selection: $state,
//                label: {
//                    Label("Notes", systemImage: "note.text")
//                }
//            )
//            NavigationLink(
//                destination: RemindersView().navigationTitle("News"),
//                tag: Screen.news,
//                selection: $state,
//                label: {
//                    Label("News", systemImage: "newspaper")
//                }
//            )
        }
        .listStyle(SidebarListStyle())
    }
}
