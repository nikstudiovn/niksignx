import SwiftUI
import NimbleJSON
import NimbleViews

struct ServerView: View {
    @AppStorage("Feather.ipFix") private var _ipFix: Bool = false
@AppStorage("Feather.serverMethod") private var _serverMethod: Int = 0

private let _serverMethods: [String] = [
        .localized("Fully Local"),
    .localized("Semi Local")
    ]

    private let _dataService = NBFetchService()
    private let _serverPackUrl = "https://backloop.dev/pack.json"

    var body: some View {
        NBSection(.localized("Server & SSL")) {
            Picker(.localized("Server Type"), systemImage: "server.rack", selection: $_serverMethod) {
                ForEach(_serverMethods.indices, id: \.self) { index in
                    Text(_serverMethods[index]).tag(index)
                }
            }
            .labelsHidden()

            Toggle(.localized("Only use localhost address"), systemImage: "lifepreserver", isOn: $_ipFix)
                .disabled(_serverMethod != 1)
                .animation(.easeInOut, value: _serverMethod)
           
            if _serverMethod == 1 {
                Label {
                       Text("Chế độ 'Semi Local' phục vụ qua HTTP thường, iOS sẽ từ chối cài đặt ứng dụng qua OTA với lỗi 'Unable to verify app integrity'. Chỉ dùng chế độ này nếu bạn có cách cài khác (không qua itms-services). Để cài OTA bình thường, hãy chọn 'Fully Local'.")
                        .font(.footnote)
                } icon: {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundStyle(.orange)
                }
                .foregroundStyle(.secondary)
            }
            Section {
                Button(.localized("Update SSL Certificates"), systemImage: "arrow.down.doc") {
                    FR.downloadSSLCertificates(from: _serverPackUrl) { success in
                        DispatchQueue.main.async {
                            if success {
                                UIAlertController.showAlertWithOk(
                                    title: .localized("Success"),
                                    message: .localized("SSL certificates updated successfully.")
                                )
                            } else {
                                UIAlertController.showAlertWithOk(
                                    title: .localized("Error"),
                                    message: .localized("Failed to update SSL certificates.")
                                )
                            }
                        }
                    }
                }
            }
        }
        .onChange(of: _serverMethod) { newValue in
            if newValue == 0 {
                _ipFix = false
            }
        }
    }
} 
