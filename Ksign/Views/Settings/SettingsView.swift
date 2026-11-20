//
//  SettingsView.swift
//  Feather
//
//  Created by samara on 10.04.2025.
//

import SwiftUI
import NimbleViews

// MARK: - View
struct SettingsView: View {
    @AppStorage("feather.selectedCert") private var _storedSelectedCert: Int = 0
    @FetchRequest(
        entity: CertificatePair.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \CertificatePair.date, ascending: false)],
        animation: .snappy
    ) private var _certificates: FetchedResults<CertificatePair>
    
    private var selectedCertificate: CertificatePair? {
        guard
            _storedSelectedCert >= 0,
            _storedSelectedCert < _certificates.count
        else {
            return nil
        }
        return _certificates[_storedSelectedCert]
    }
    
    
	private let _donationsUrl = "https://github.com/sponsors/nyasami"
	private let _githubUrl = "https://github.com/nikstudiovn/niksignx"
    private let _discordUrl = "https://discord.gg/sfbZfQzVdQ"
	// MARK: Body
    var body: some View {
		NBNavigationView(.localized("Settings")) {
			Form {
//				#if !NIGHTLY && !DEBUG
				_niksignBrandBanner()
//				#endif
				
				_feedback()
				
				Section {
                    NavigationLink(destination: AppIconView()) {
                        Label(.localized("App Icon"), systemImage: "app.badge")
                    }
					NavigationLink(destination: AppearanceView()) {
                        Label(.localized("Appearance"), systemImage: "paintbrush")
                    }
				}
                
                NBSection(.localized("Certificates")) {
                    
                    if let cert = selectedCertificate {
                        CertificatesCellView(cert: cert)
                    } else {
                        Text(.localized("No Certificate"))
                            .font(.footnote)
                            .foregroundColor(.disabled())
                    }
                    NavigationLink(destination: CertificatesView()) {
                        Label(.localized("Certificates"), systemImage: "signature")
                    }
                 
                } footer: {
                    Text(.localized("Add and manage certificates used for signing applications."))
                }
				
				NBSection(.localized("Features")) {
                    NavigationLink(destination: LogsView(manager: LogsManager.shared)) {
                        Label(.localized("Logs"), systemImage: "apple.terminal")
                    }
					NavigationLink(destination: AppFeaturesView()) {
                        Label(.localized("App Features"), systemImage: "sparkles")
                    }
					NavigationLink(destination: ConfigurationView()) {
                        Label(.localized("Signing Options"), systemImage: "gear")
                    }
					NavigationLink(destination: ArchiveView()) {
                        Label(.localized("Archive & Extraction"), systemImage: "archivebox")
                    }
					NavigationLink(destination: InstallationView()) {
                        Label(.localized("Installation"), systemImage: "server.rack")
                    }
				}
				
				_directories()
                
                Section {
                    NavigationLink(destination: ResetView()) {
                        Label(.localized("Reset"), systemImage: "trash")
                    }
                } footer: {
                    Text("Reset the applications sources, certificates, apps, and general contents.")
                }

            }
        }
    }
}

// MARK: - View extension
extension SettingsView {
@ViewBuilder
	private func _niksignBrandBanner() -> some View {
		let cardContent = HStack(spacing: 14) {
	ZStack {
		RoundedRectangle(cornerRadius: 16, style: .continuous)
			.fill(LinearGradient(colors: [.accentColor, .accentColor.opacity(0.65)], startPoint: .topLeading, endPoint: .bottomTrailing))
			.frame(width: 56, height: 56)
		Image(systemName: "signature")
			.font(.system(size: 26, weight: .semibold))
			.foregroundStyle(.white)
	}
	VStack(alignment: .leading, spacing: 4) {
		HStack(alignment: .firstTextBaseline, spacing: 8) {
			Text("NiKSign")
				.font(.title3.bold())
			Text("v\(Bundle.main.version)")
				.font(.caption.weight(.semibold))
				.padding(.horizontal, 8)
				.padding(.vertical, 2)
				.background(.secondary.opacity(0.15), in: Capsule())
				.foregroundStyle(.secondary)
		}
		Text("Ký IPA & Tweak · Bán cục bộ (127.0.0.1)")
			.font(.footnote)
			.foregroundStyle(.secondary)
			.lineLimit(2)
	}
	Spacer(minLength: 0)
}
.padding(16)
Group {
	if #available(iOS 26.0, *) {
		cardContent
			.glassEffect(.regular, in: .rect(cornerRadius: 20))
	} else {
		cardContent
			.background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
	}
}
.listRowInsets(EdgeInsets())
.listRowBackground(Color.clear)
	}
	
	@ViewBuilder
	private func _feedback() -> some View {
		Section {
			NavigationLink(destination: AboutNyaView()) {
                Label(.localized("About"), systemImage: "info.circle")
            }
			Button(.localized("Telegram Channel"), systemImage: "paperplane.circle") {
				UIApplication.open("https://t.me/KhoinDNS")
			}
			Button(.localized("GitHub Repository"), systemImage: "safari") {
				UIApplication.open(_githubUrl)
			}
            Button(.localized("Discord Server"), systemImage: "safari") {
                UIApplication.open(_discordUrl)
            }
		}
	}
	
	@ViewBuilder
	private func _directories() -> some View {
		NBSection(.localized("Misc")) {
			Button(.localized("Open Documents"), systemImage: "folder") {
				UIApplication.open(URL.documentsDirectory.toSharedDocumentsURL()!)
			}
			Button(.localized("Open Archives"), systemImage: "folder") {
				UIApplication.open(FileManager.default.archives.toSharedDocumentsURL()!)
			}
		} footer: {
			Text(.localized("All of NiKSign files except certificates are contained in the documents directory, here are some quick links to these."))
		}
	}
}
