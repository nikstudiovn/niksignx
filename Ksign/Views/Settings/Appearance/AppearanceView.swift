//
//  AppearanceView.swift
//  Feather
//
//  Created by samara on 7.05.2025.
//

import SwiftUI
import NimbleViews

struct AppearanceView: View {
    @AppStorage("Feather.userInterfaceStyle") private var _userIntefacerStyle: Int = UIUserInterfaceStyle.unspecified.rawValue
    
	@AppStorage("Feather.libraryCellAppearance") private var _libraryCellAppearance: Int = 0
	
	private let _libraryCellAppearanceMethods: [String] = [
		.localized("Standard"),
		.localized("Pill")
	]
	
	@AppStorage("Feather.storeCellAppearance") private var _storeCellAppearance: Int = 1
	
	private let _storeCellAppearanceMethods: [String] = [
		.localized("Standard"),
		.localized("Big Description")
	]
	
	@AppStorage("Feather.accentColor") private var _selectedAccentColor: Int = 0
	@StateObject private var accentColorManager = AccentColorManager.shared
    
	private let _accentColors: [(name: String, color: Color)] = [
		(.localized("Default"), Color(red: 0x53/255, green: 0x94/255, blue: 0xF7/255)),
		(.localized("Cherry"), Color(red: 0xFF/255, green: 0x8B/255, blue: 0x92/255)),
		(.localized("Red"), .red),
		(.localized("Orange"), .orange),
		(.localized("Yellow"), .yellow),
		(.localized("Green"), .green),
		(.localized("Blue"), .blue),
		(.localized("Purple"), .purple),
		(.localized("Pink"), .pink),
		(.localized("Indigo"), .indigo),
		(.localized("Mint"), .mint),
		(.localized("Cyan"), .cyan),
		(.localized("Teal"), .teal)
	]
	
	private var currentAccentColor: Color {
		accentColorManager.currentAccentColor
	}

    var body: some View {
        NBList(.localized("Appearance")) {
            
            Section {
                Picker(.localized("Appearance"), selection: $_userIntefacerStyle) {
                    ForEach(UIUserInterfaceStyle.allCases.sorted(by: { $0.rawValue < $1.rawValue }), id: \.rawValue) { style in
                        Text(style.label).tag(style.rawValue)
                    }
                }
                .pickerStyle(.segmented)
            }
			
			NBSection(.localized("Sources")) {
                _storePreview()
				Picker(.localized("Store Cell Appearance"), selection: $_storeCellAppearance) {
					ForEach(_storeCellAppearanceMethods.indices, id: \.description) { index in
						Text(_storeCellAppearanceMethods[index]).tag(index)
					}
				}
				.pickerStyle(.inline)
                .labelsHidden()
			}
			
			NBSection(.localized("Accent Color")) {
		_accentColorPreview()
LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 5), spacing: 14) {
	ForEach(_accentColors.indices, id: \.self) { index in
		let item = _accentColors[index]
		let isSelected = _selectedAccentColor == index
		Button {
			_selectedAccentColor = index
		} label: {
			VStack(spacing: 6) {
				ZStack {
					Circle()
						.fill(item.color)
						.frame(width: 38, height: 38)
						.overlay(
							Circle()
								.strokeBorder(.white.opacity(isSelected ? 0.95 : 0.25), lineWidth: isSelected ? 3 : 1)
						)
						.shadow(color: isSelected ? item.color.opacity(0.6) : .clear, radius: 6)
					if isSelected {
						Image(systemName: "checkmark")
							.font(.system(size: 15, weight: .bold))
							.foregroundStyle(.white)
					}
				}
				Text(item.name)
					.font(.caption2)
					.foregroundStyle(isSelected ? .primary : .secondary)
					.lineLimit(1)
			}
		}
		.buttonStyle(.plain)
	}
}
.padding(.vertical, 8)
			}
		}
        .onChange(of: _userIntefacerStyle) { value in
            if let style = UIUserInterfaceStyle(rawValue: value) {
                UIApplication.topViewController()?.view.window?.overrideUserInterfaceStyle = style
            }
        }
		.onChange(of: _selectedAccentColor) { _ in
			accentColorManager.updateGlobalTintColor()
		}
    }
	
	@ViewBuilder
	private func _libraryPreview() -> some View {
		HStack(spacing: 9) {
			Image(uiImage: (UIImage(named: Bundle.main.iconFileName ?? ""))! )
				.appIconStyle(size: 57)
			
			NBTitleWithSubtitleView(
				title: Bundle.main.name,
				subtitle: "\(Bundle.main.version) • \(Bundle.main.bundleIdentifier ?? "")",
				linelimit: 0
			)
			
			FRExpirationPillView(
				title: .localized("Install"),
				showOverlay: _libraryCellAppearance == 0,
				expiration: Date.now.expirationInfo()
			).animation(.spring, value: _libraryCellAppearance)
		}
	}
    
    @ViewBuilder
    private func _storePreview() -> some View {
        VStack {
            HStack(spacing: 9) {
                Image(uiImage: (UIImage(named: Bundle.main.iconFileName ?? ""))! )
                    .appIconStyle(size: 57)
                
                NBTitleWithSubtitleView(
                    title: Bundle.main.name,
                    subtitle: "\(Bundle.main.version) • " + .localized("An awesome application"),
                    linelimit: 0
                )
            }
            
            if _storeCellAppearance != 0 {
                Text(.localized("An awesome application"))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(18)
                    .padding(.top, 2)
            }
        }
        .animation(.spring, value: _storeCellAppearance)
    }
	
	@ViewBuilder
	private func _accentColorPreview() -> some View {
		HStack(spacing: 9) {
			Circle()
				.fill(currentAccentColor)
				.frame(width: 57, height: 57)
			
			NBTitleWithSubtitleView(
				title: .localized("Accent Color"),
				subtitle: .localized("This is the current accent color"),
				linelimit: 0
			)
		}
	}
}
