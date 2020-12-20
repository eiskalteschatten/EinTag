//
//  MiniCalendarView.swift
//  EinTag
//
//  Created by Alex Seifert on 12/20/20.
//

import SwiftUI

fileprivate extension DateFormatter {
    static var monthAndYear: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        formatter.locale = Locale.autoupdatingCurrent
        return formatter
    }
}

fileprivate extension Calendar {
    func generateDates(
        inside interval: DateInterval,
        matching components: DateComponents
    ) -> [Date] {
        var dates: [Date] = []
        dates.append(interval.start)

        enumerateDates(
            startingAfter: interval.start,
            matching: components,
            matchingPolicy: .nextTime
        ) { date, _, stop in
            if let date = date {
                if date < interval.end {
                    dates.append(date)
                }
                else {
                    stop = true
                }
            }
        }

        return dates
    }
}

struct MiniCalendarView: View {
    @Environment(\.calendar) var calendar

   private var month: DateInterval {
       calendar.dateInterval(of: .month, for: Date())!
   }
    
    var body: some View {
        VStack {
            MiniCalendarIntervalView(interval: month)
        }
    }
}

struct MiniCalendarIntervalView: View {
    @Environment(\.calendar) var calendar

    let interval: DateInterval
    let showHeaders: Bool
    let today = Date()
    
    #if os(macOS)
    let daySize: CGFloat = 20
    #else
    let daySize: CGFloat = 30
    #endif
    
    init(interval: DateInterval, showHeaders: Bool = true) {
        self.interval = interval
        self.showHeaders = showHeaders
    }

    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(), count: 7)) {
            ForEach(months, id: \.self) { month in
                Section(header: header(for: month)) {
                    ForEach(daysOfTheWeek()) { dayOfTheWeek in
                        Text(dayOfTheWeek.name)
                            .frame(width: daySize, height: daySize, alignment: .center)
                            .padding(.vertical, 2)
                            .opacity(0.4)
                    }
                    Group {
                        ForEach(days(for: month), id: \.self) { date in
                            Text(String(self.calendar.component(.day, from: date)))
                                .frame(width: daySize, height: daySize, alignment: .center)
                                .padding(.vertical, 2)
                                .if(date.isInToday) { $0.background(Color.red) }
                                .if(date.isInToday) { $0.foregroundColor(Color.white) }
                                .if(!date.isInSameMonth(as: today)) { $0.opacity(0.2) }
                                .clipShape(Circle())
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 10)
    }

    private var months: [Date] {
        calendar.generateDates(
            inside: interval,
            matching: DateComponents(day: 1, hour: 0, minute: 0, second: 0)
        )
    }

    private func header(for month: Date) -> some View {
        return Group {
            if showHeaders {
                Text(DateFormatter.monthAndYear.string(from: month))
                    .font(.title2)
                    .padding(.bottom)
            }
        }
    }

    private func days(for month: Date) -> [Date] {
        guard
            let monthInterval = calendar.dateInterval(of: .month, for: month),
            let monthFirstWeek = calendar.dateInterval(of: .weekOfMonth, for: monthInterval.start),
            let monthLastWeek = calendar.dateInterval(of: .weekOfMonth, for: monthInterval.end)
        else { return [] }
        return calendar.generateDates(
            inside: DateInterval(start: monthFirstWeek.start, end: monthLastWeek.end),
            matching: DateComponents(hour: 0, minute: 0, second: 0)
        )
    }
    
    struct DayOfTheWeek: Identifiable {
        var id: Int
        var name: String
    }
    
    private func daysOfTheWeek() -> [DayOfTheWeek] {
        var localeCalendar = calendar
        localeCalendar.locale = Locale.autoupdatingCurrent
        let symbols = localeCalendar.veryShortWeekdaySymbols
        let localizedWeekdays: [String] = Array(symbols[Calendar.current.firstWeekday - 1 ..< Calendar.current.veryShortWeekdaySymbols.count] + symbols[0 ..< Calendar.current.firstWeekday - 1])
        return localizedWeekdays.enumerated().map { (index, element) in
            DayOfTheWeek(
                id: index,
                name: element
            )
        }
    }
}


struct MiniCalendarView_Previews: PreviewProvider {
    static var previews: some View {
        MiniCalendarView()
    }
}
