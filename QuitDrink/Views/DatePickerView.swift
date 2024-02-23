//
//  DatePickerView.swift
//  QuitDrink
//
//  Created by Georgii Fesenko on 23.02.2024.
//

import SwiftUI

struct DatePickerView: View {
    @Environment(\.dismiss) var dismiss

    @Binding var selectedDate: Date

    var body: some View {
        VStack(alignment: .center, spacing: 50) {
            Text("DatePickerView.Title".localized())
                .font(.title)
                .bold()
            DatePicker(
                "",
                selection: $selectedDate,
                in: ...Date(),
                displayedComponents: [.date]
            )
            .datePickerStyle(.graphical)
            RoundedButton(title: "DatePickerView.Action".localized()) {
                dismiss()
            }
        }
        .padding()
    }
}

struct DatePickerViewPreviews: PreviewProvider {
    static var previews: some View {
        DatePickerView(selectedDate: .constant(.init()))
    }
}
