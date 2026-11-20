import SwiftUI

struct ServerView: View {
    var body: some View {
        Section {
            HStack {
                Label("Chế độ máy chủ", systemImage: "server.rack")
                Spacer()
                Text("Bán cục bộ (127.0.0.1)")
                    .foregroundColor(.secondary)
            }
        } header: {
            Text("Máy chủ & SSL")
        } footer: {
            Text("NiKSign mặc định dùng Bán cục bộ (127.0.0.1) để đảm bảo cài đặt ổn định trên cả Wi-Fi và 4G/5G.")
        }
    }
}
