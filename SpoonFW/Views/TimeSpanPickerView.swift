//
//  TimeSpanPickerView.swift
//  TiNo
//
//  Created by Jan Löffel on 28.08.21.
//

import SwiftUI

public struct TimeSpanPickerView: View {
    @Binding var timeSpan: TimeInterval

    let minDays: Int
    let maxDays: Int
    let daysStep: Int
    let minHours: Int
    let maxHours: Int
    let hoursStep: Int
    let minMinutes: Int
    let maxMinutes: Int
    let minutesStep: Int
    let minSeconds: Int
    let maxSeconds: Int
    let secondsStep: Int

    @State private var day: Int = 0
    @State private var hour: Int = 0
    @State private var minute: Int = 0
    @State private var second: Int = 0

    public var body: some View {
        let maxTimeSpan = TimeInterval((maxDays * 24 * 60 * 60) + (maxHours * 60 * 60) + (maxMinutes * 60) + maxSeconds)

        VStack {
            HStack {
                IntegerPickerView(value: $day, min: minDays, max: maxDays, step: daysStep, unitString: String(localized: "DaysUnit"))
                IntegerPickerView(value: $hour, min: minHours, max: maxHours, step: hoursStep, unitString: String(localized: "HoursUnit"))
                IntegerPickerView(value: $minute, min: minMinutes, max: maxMinutes, step: minutesStep, unitString: String(localized: "MinutesUnit"))
                IntegerPickerView(value: $second, min: minSeconds, max: maxSeconds, step: secondsStep, unitString: String(localized: "SecondsUnit"))
            }

            Divider()

            HStack {
                Text("-1h")
                    .disabled(timeSpan < 3600)
                    .onTapGesture { timeSpan = max(0, timeSpan - 3600) }
                Text("-15m")
                    .disabled(timeSpan < 900)
                    .onTapGesture { timeSpan = max(0, timeSpan - 900) }
                Text("-1m")
                    .disabled(timeSpan < 60)
                    .onTapGesture { timeSpan = max(0, timeSpan - 60) }
                Spacer()
                Text("+1m")
                    .disabled(timeSpan > maxTimeSpan - 60)
                    .onTapGesture { timeSpan += 60 }
                Text("+15m")
                    .disabled(timeSpan > maxTimeSpan - 900)
                    .onTapGesture { timeSpan += 900 }
                Text("+1h")
                    .disabled(timeSpan > maxTimeSpan - 3600)
                    .onTapGesture { timeSpan += 3600 }
            }
            .foregroundColor(Color.accentColor)
            .font(.footnote)
            .fontWeight(.light)
        }
        .onAppear {
            calcTimeComponents()
        }
        .onChange(of: timeSpan, perform: { _ in
            calcTimeComponents()
        })
        .onChange(of: day, perform: { _ in
            timeSpan = calculateTimeSpan()
        })
        .onChange(of: hour, perform: { _ in
            timeSpan = calculateTimeSpan()
        })
        .onChange(of: minute, perform: { _ in
            timeSpan = calculateTimeSpan()
        })
        .onChange(of: second, perform: { _ in
            timeSpan = calculateTimeSpan()
        })
    }

    public init(timeSpan: Binding<TimeInterval>, minDays: Int = 0, maxDays: Int = 366, daysStep: Int = 1, minHours: Int = 0, maxHours: Int = 23, hoursStep: Int = 1, minMinutes: Int = 0, maxMinutes: Int = 59, minutesStep: Int = 1, minSeconds: Int = 0, maxSeconds: Int = 59, secondsStep: Int = 1) {
        self._timeSpan = timeSpan
        self.minDays = minDays
        self.maxDays = maxDays
        self.daysStep = daysStep
        self.minHours = minHours
        self.maxHours = maxHours
        self.hoursStep = hoursStep
        self.minMinutes = minMinutes
        self.maxMinutes = maxMinutes
        self.minutesStep = minutesStep
        self.minSeconds = minSeconds
        self.maxSeconds = maxSeconds
        self.secondsStep = secondsStep
    }

    func calcTimeComponents() {
        day = TimeInterval.getDays(timeSpan)
        hour = TimeInterval.getHours(timeSpan)
        minute = TimeInterval.getMinutes(timeSpan)
        second = TimeInterval.getSeconds(timeSpan)
    }

    func calculateTimeSpan() -> TimeInterval {
        return TimeInterval.timeSpan(day: day, hour: hour, minute: minute, second: second)
    }
}

struct TimeSpanPickerView_Previews: PreviewProvider {
    static var previews: some View {
        TimeSpanPickerView(timeSpan: .constant(TimeInterval.random(in: 1...123456)))
    }
}
