//
//  MainView.swift
//  QuitDrink
//
//  Created by Georgii Fesenko on 17.02.2024.
//

import SwiftUI

struct MainView: View {
    @State private var showingAlert = false
    @State private var showingDatePickerSheet = false

    @State private var numberOfDays: Int = 0
    @State private var lastDrinkingDate: Date = (UserDefaults.standard.object(forKey: Constants.soberDaysCountKey) as? Date) ?? .init()
    
    var body: some View {
        VStack {
            Spacer()
            VStack(spacing: 10) {
                Text(getDaysSoberString())
                    .font(.title)
                Text("\(NSLocalizedString("MainScreen.SoberStartDate.Title", comment: "")) \(getSoberStartDateFormatted())")
            }
            Spacer()
            RoundedButton(title: "Common.Reset".localized()) {
                showingAlert = true
            }
            .alert(
                "MainScreen.Alert.Message",
                isPresented: $showingAlert,
                actions: {
                    Button {
                        UserDefaults.standard.removeObject(forKey: Constants.soberDaysCountKey)
                        showingDatePickerSheet = true
                    } label: {
                        Text("Common.Yes")
                    }

                    Button(role: .cancel) { } label: {
                        Text("MainScreen.Alert.CancelAction")
                    }
                }
            )
        }
        .padding()
        .onAppear {
            if isFirstLaunch() {
                showingDatePickerSheet = true
            } else {
                lastDrinkingDate = getSoberStartDate()
                calculateNumberOfDays()
            }
        }
        .onChange(of: lastDrinkingDate) { newValue in
            UserDefaults.standard.set(newValue, forKey: Constants.soberDaysCountKey)
            calculateNumberOfDays()
        }
        .sheet(
            isPresented: $showingDatePickerSheet) {
                DatePickerView(selectedDate: $lastDrinkingDate)
            }
    }
    
    private func calculateNumberOfDays() {
        numberOfDays = calculateNumberOfSoberDays(
            startOfSobriety: getSoberStartDate()
        )
    }
    
    private func isFirstLaunch() -> Bool {
        UserDefaults.standard.object(forKey: Constants.soberDaysCountKey) == nil
    }
    
    private func getSoberStartDate() -> Date {
        if let date = UserDefaults.standard.object(forKey: Constants.soberDaysCountKey) as? Date {
            return date
        }
        let date = Date()
        UserDefaults.standard.set(date, forKey: Constants.soberDaysCountKey)
        return date
    }
    
    private func getSoberStartDateFormatted() -> String {
        let soberStartDate = UserDefaults.standard.object(forKey: Constants.soberDaysCountKey) as? Date
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: soberStartDate ?? .init())
    }
    
    private func getDaysSoberString() -> String {
        let localized = NSLocalizedString("sober_count", comment: "")
        let formatted = String(format: localized, numberOfDays)
        return formatted
    }
    
    private func calculateNumberOfSoberDays(startOfSobriety: Date) -> Int {
        let calendar = Calendar.current

        let date1 = calendar.startOfDay(for: startOfSobriety)
        let date2 = calendar.startOfDay(for: Date())

        let components = calendar.dateComponents([.day], from: date1, to: date2)
        
        return components.day ?? 0
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

enum Constants {
    static let soberDaysCountKey = "sober.key"
}

extension String {
    func localized() -> String {
        NSLocalizedString(
            self,
            bundle: .current,
            comment: ""
        )
    }
}

extension Bundle {
    static var current: Bundle {
        class __ { }
        return Bundle(for: __.self)
    }
}
