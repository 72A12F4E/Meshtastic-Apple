//
//  LogDetail.swift
//  Meshtastic
//
//  Copyright(c) Garth Vander Houwen 6/5/24.
//

import SwiftUI
import MapKit
import OSLog

struct LogDetail: View {

	@Environment(\.dismiss) private var dismiss
	private var idiom: UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }
	var log: OSLogEntryLog
	var font: Font = .title2
	private let dateFormatStyle = Date.FormatStyle()
		.day(.defaultDigits)
		.month(.defaultDigits)
		.year(.twoDigits)
		.hour(.twoDigits(amPM: .omitted))
		.minute()
		.second()
		.secondFraction(.fractional(3))

	var body: some View {

		VStack {
			HStack {
				Text("OS Log Entry Details")
					.font(.largeTitle)
			}
			Divider()
			HStack(alignment: .top) {
				VStack(alignment: .leading) {
					List {
						/// Time
						Label {
							Text(NSLocalizedString("log.time", comment: "No comment provided") + ":")
								.font(idiom == .phone ? .caption : .title)
								.frame(width: idiom == .phone ? 115 : 190, alignment: .trailing)
							Text(log.date.formatted(dateFormatStyle))
								.font(idiom == .phone ? .caption : .title)
						} icon: {
							Image(systemName: "timer")
								.symbolRenderingMode(.hierarchical)
								.font(idiom == .phone ? .callout : .title)
								.frame(width: 35)
						}
						.padding(.bottom, 5)
						.listSectionSeparator(.hidden, edges: .top)
						.listSectionSeparator(.visible, edges: .bottom)
						/// Subsystem
						Label {
							Text(NSLocalizedString("log.subsystem", comment: "No comment provided") + ":")
								.font(idiom == .phone ? .caption : .title)
								.frame(width: idiom == .phone ? 115 : 190, alignment: .trailing)
							Text(log.subsystem)
								.font(idiom == .phone ? .caption : .title)
						} icon: {
							Image(systemName: "gear")
								.symbolRenderingMode(.hierarchical)
								.font(idiom == .phone ? .caption : .title)
								.frame(width: 35)
						}
						.padding(.bottom, 5)
						.listRowSeparator(.visible)
						/// Process
						Label {
							Text(NSLocalizedString("log.process", comment: "No comment provided") + ":")
								.font(idiom == .phone ? .caption : .title)
								.frame(width: idiom == .phone ? 115 : 190, alignment: .trailing)
							Text(log.process)
								.font(idiom == .phone ? .caption : .title)
						} icon: {
							Image(systemName: "tag")
								.symbolRenderingMode(.hierarchical)
								.font(idiom == .phone ? .caption : .title)
								.frame(width: 35)
						}
						.padding(.bottom, 5)
						.listRowSeparator(.visible)
						/// Category
						Label {
							Text(NSLocalizedString("log.category", comment: "No comment provided") + ":")
								.font(idiom == .phone ? .caption : .title)
								.frame(width: idiom == .phone ? 115 : 190, alignment: .trailing)
							Text(log.category)
								.font(idiom == .phone ? .caption : .title)
						} icon: {
							Image(systemName: "square.grid.2x2")
								.symbolRenderingMode(.hierarchical)
								.font(idiom == .phone ? .caption : .title)
								.frame(width: 35)
						}
						.padding(.bottom, 5)
						.listRowSeparator(.visible)
						/// Level
						Label {
							Text(NSLocalizedString("log.level", comment: "No comment provided") + ":")
								.font(idiom == .phone ? .caption : .title)
								.frame(width: idiom == .phone ? 115 : 190, alignment: .trailing)
							Text(log.level.description)
								.font(idiom == .phone ? .caption : .title)
						} icon: {
							Image(systemName: "stairs")
								.symbolRenderingMode(.hierarchical)
								.font(idiom == .phone ? .caption : .title)
								.frame(width: 35)
						}
						.padding(.bottom, 5)
						.listRowSeparator(.visible)
						/// message
						Label {
							Text(NSLocalizedString("log.message", comment: "No comment provided") + ":")
								.font(idiom == .phone ? .caption : .title)
								.frame(width: idiom == .phone ? 115 : 190, alignment: .trailing)
							Text(log.composedMessage)
								.textSelection(.enabled)
								.font(idiom == .phone ? .body : .title)
								.padding(.bottom, 5)
						} icon: {
							Image(systemName: "text.bubble")
								.symbolRenderingMode(.hierarchical)
								.font(idiom == .phone ? .callout : .title)
								.frame(width: 35)
						}
						.listRowSeparator(.hidden)

					}
					.listStyle(.plain)
				}
				Spacer()
			}
			.padding(.top)
#if targetEnvironment(macCatalyst)
			Spacer()
			Button {
				dismiss()
			} label: {
				Label("close", systemImage: "xmark")
			}
			.buttonStyle(.bordered)
			.buttonBorderShape(.capsule)
			.controlSize(.large)
			.padding(.bottom)
#endif
		}
		.monospaced()
		.presentationDetents([.fraction(0.75), .fraction(0.85), .fraction(1.0)])
		.presentationDragIndicator(.visible)
	}
}
