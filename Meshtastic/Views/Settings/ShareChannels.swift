//
//  ShareChannel.swift
//  MeshtasticApple
//
//  Copyright(c) Garth Vander Houwen 4/8/22.
//
import SwiftUI
import CoreData
import CoreImage.CIFilterBuiltins
#if canImport(TipKit)
import TipKit
#endif

struct QrCodeImage {
	let context = CIContext()

	func generateQRCode(from text: String) -> UIImage {
		var qrImage = UIImage(systemName: "xmark.circle") ?? UIImage()
		let data = Data(text.utf8)
		let filter = CIFilter.qrCodeGenerator()
		filter.setValue(data, forKey: "inputMessage")

		let transform = CGAffineTransform(scaleX: 20, y: 20)
		if let outputImage = filter.outputImage?.transformed(by: transform) {
			if let image = context.createCGImage(
				outputImage,
				from: outputImage.extent) {
				qrImage = UIImage(cgImage: image)
			}
		}
		return qrImage
	}
}

struct IncludedChannels: OptionSet, CaseIterable {
	let rawValue: Int

	static let channel0 = IncludedChannels(rawValue: 1 << 0)
	static let channel1 = IncludedChannels(rawValue: 1 << 1)
	static let channel2 = IncludedChannels(rawValue: 1 << 2)
	static let channel3 = IncludedChannels(rawValue: 1 << 3)
	static let channel4 = IncludedChannels(rawValue: 1 << 4)
	static let channel5 = IncludedChannels(rawValue: 1 << 5)
	static let channel6 = IncludedChannels(rawValue: 1 << 6)
	static let channel7 = IncludedChannels(rawValue: 1 << 7)

	static var allCases: [IncludedChannels] {
		channel0 &
		channel1 &
		channel2 &
		channel3 &
		channel4 &
		channel5 &
		channel6 &
		channel7
	}
}

struct ShareChannels: View {

	@Environment(\.managedObjectContext) var context
	@EnvironmentObject var bleManager: BLEManager
	@Environment(\.dismiss) private var dismiss
	@State var channelSet: ChannelSet = ChannelSet()

	@State var includedChannels = IncludedChannels.allCases

	var node: NodeInfoEntity?
	@State private var channelsUrl =  "https://www.meshtastic.org/e/#"
	var qrCodeImage = QrCodeImage()

	@ViewBuilder
	func makeChannelRow(
		channel: ChannelEntity,
		isOn: Binding<Bool>
	) -> some View {
		Toggle("Channel \(channel.index) Included", isOn: isOn)
			.toggleStyle(.switch)
			.labelsHidden()
			.disabled(channel.index != 0 && channel.role == 1)

		let displayName: String = {
			if let name = channel.name, !name.isEmpty {
				return name.camelCaseToWords()
			} else if channel.index == 0 {
				return "Primary"
			} else {
				return "Channel \(channel.index)"
			}
		}()
		

		Text(displayName).fixedSize()

		if channel.psk?.hexDescription.count ?? 0 < 3 {
			Image(systemName: "lock.slash")
				.foregroundColor(.red)
		} else {
			Image(systemName: "lock.fill")
				.foregroundColor(.green)
		}
	}

	var body: some View {
		if #available(iOS 17.0, macOS 14.0, *) {
			VStack {
				TipView(ShareChannelsTip(), arrowEdge: .bottom)
			}
		}
		GeometryReader { bounds in
			let smallest = min(bounds.size.width, bounds.size.height)
			ScrollView {
				if let myInfo = node?.myInfo {
					Grid {
						GridRow {
							Spacer()
							Text("include")
								.font(.caption)
								.fontWeight(.bold)
								.padding(.trailing)
							Text("channel")
								.font(.caption)
								.fontWeight(.bold)
								.padding(.trailing)
							Text("encrypted")
								.font(.caption)
								.fontWeight(.bold)
						}
						if let channels = myInfo.channels?.array as? [ChannelEntity],
						    let sortedChannels = channels.sorted(by: {
							    $0.index < $1.index
						    }) {
							ForEach(sortedChannels, id: \.self) { (channel: ChannelEntity) in
								GridRow {
									if channel.index == 0 || channel.role > 0 {
										Spacer()
										let includedChannel = IncludedChannels(rawValue: 1 << channel.index)
										makeChannelRow(
											channel: channel,
											isOn: Binding<Bool>(
												get: {
													$includedChannels.contains(includedChannel)
												},
												set: {
													$includedChannels = $includedChannels & includedChannel
												}
											)
										)
										Spacer()
									}
								}
							}
						}
					}

					let qrImage = qrCodeImage.generateQRCode(from: channelsUrl)
					VStack {
						if let node {
							Toggle(isOn: $replaceChannels) {
								Label(replaceChannels ? "Replace Channels" : "Add Channels", systemImage: replaceChannels ? "arrow.triangle.2.circlepath.circle" : "plus.app")
							}
							.tint(.accentColor)
							.toggleStyle(.button)
							.buttonStyle(.bordered)
							.buttonBorderShape(.capsule)
							.controlSize(.large)
							.padding(.top)
							.padding(.bottom)

							ShareLink("Share QR Code & Link",
										item: Image(uiImage: qrImage),
										subject: Text("Meshtastic Node \(node.user?.shortName ?? "????") has shared channels with you"),
										message: Text(channelsUrl),
										preview: SharePreview("Meshtastic Node \(node.user?.shortName ?? "????") has shared channels with you",
															image: Image(uiImage: qrImage))
							)
							.buttonStyle(.bordered)
							.buttonBorderShape(.capsule)
							.controlSize(.large)
							.padding(.bottom)

							Image(uiImage: qrImage)
								.resizable()
								.scaledToFit()
								.frame(
									minWidth: smallest * (UIDevice.current.userInterfaceIdiom == .phone ? 0.8 : 0.6),
									maxWidth: smallest * (UIDevice.current.userInterfaceIdiom == .phone ? 0.8 : 0.6),
									minHeight: smallest * (UIDevice.current.userInterfaceIdiom == .phone ? 0.8 : 0.6),
									maxHeight: smallest * (UIDevice.current.userInterfaceIdiom == .phone ? 0.8 : 0.6),
									alignment: .top
								)
						}
					}
				}
			}
			.navigationTitle("generate.qr.code")
			.navigationBarTitleDisplayMode(.inline)
			.navigationBarItems(
				trailing: ZStack {
					ConnectedDevice(bluetoothOn: bleManager.isSwitchedOn, deviceConnected: bleManager.connectedPeripheral != nil, name: (bleManager.connectedPeripheral != nil) ? bleManager.connectedPeripheral.shortName : "?")
				}
			)
			.onAppear {
				bleManager.context = context
				generateChannelSet()
			}
			.onChange(of: includedChannels) { _ in generateChannelSet() }
		}
	}

	func generateChannelSet() {
		channelSet = ChannelSet()
		var loRaConfig = Config.LoRaConfig()
		loRaConfig.region =  RegionCodes(rawValue: Int(node?.loRaConfig?.regionCode ?? 0))!.protoEnumValue()
		loRaConfig.modemPreset = ModemPresets(rawValue: Int(node?.loRaConfig?.modemPreset ?? 0))!.protoEnumValue()
		loRaConfig.bandwidth = UInt32(node?.loRaConfig?.bandwidth ?? 0)
		loRaConfig.spreadFactor = UInt32(node?.loRaConfig?.spreadFactor ?? 0)
		loRaConfig.codingRate = UInt32(node?.loRaConfig?.codingRate ?? 0)
		loRaConfig.frequencyOffset = node?.loRaConfig?.frequencyOffset ?? 0
		loRaConfig.hopLimit = UInt32(node?.loRaConfig?.hopLimit ?? 3)
		loRaConfig.txEnabled = node?.loRaConfig?.txEnabled ?? false
		loRaConfig.txPower = node?.loRaConfig?.txPower ?? 0
		loRaConfig.usePreset = node?.loRaConfig?.usePreset ?? true
		loRaConfig.channelNum = UInt32(node?.loRaConfig?.channelNum ?? 0)
		loRaConfig.sx126XRxBoostedGain = node?.loRaConfig?.sx126xRxBoostedGain ?? false
		loRaConfig.ignoreMqtt = node?.loRaConfig?.ignoreMqtt ?? false
		channelSet.loraConfig = loRaConfig

		if let channels = node?.myInfo?.channels?.array as? [ChannelEntity], !channels.isEmpty {
			for ch in channels where isValidChannel(ch) {
				var channelSettings = ChannelSettings()
				channelSettings.name = ch.name!
				channelSettings.psk = ch.psk!
				channelSettings.id = UInt32(ch.id)
				channelSet.settings.append(channelSettings)
			}
		}

		let settingsString = try! channelSet.serializedData().base64EncodedString()
		channelsUrl = ("https://meshtastic.org/e/#" + settingsString.base64ToBase64url() + (replaceChannels ? "" : "?add=true"))
	}

	// Determines if the channel should be included
	// in the generated channel set or not.
	private func isValidChannel(_ ch: ChannelEntity) -> Bool {
		ch.role > 0 && includedChannels.contains(
			IncludedChannels(rawValue: 1 << ch.index)
		)
	}
}
