import SwiftUI

struct JoinDreamModal: View {
    @StateObject private var userViewModel = UserVM()
    
    @Binding var code: String
    var userId: String
    var profile: String
    var name: String
    
    var body: some View {
        VStack {
            CustomTextFieldString(text: $code, placeholder: "Kode Undangan")
                .padding(.horizontal, 16)
                .padding(.vertical, 3)
            
            Button("Gabung") {
                userViewModel.joinDream(code: code, userId: userId, profile: profile, name: name)
            }
            .padding()
            
            switch userViewModel.state {
            case .idle:
                EmptyView()
            case .loading:
                ProgressView("Bergabung...")
            case .joinSuccess:
                Text("Berhasil bergabung impian!")
                    .foregroundColor(.green)
            case .joinFailed(_):
                EmptyView()
            }
        }
        .padding()
        .alert(isPresented: $userViewModel.showErrorAlert) {
            Alert(
                title: Text("Gagal bergabung tabungan"),
                message: Text(userViewModel.errorMessage ?? "Unknown error"),
                dismissButton: .default(Text("OK")) {
                    userViewModel.resetError()
                }
            )
        }
    }
}

#Preview {
    JoinDreamModal(code: .constant("434n"), userId: "123", profile: "image", name: "naela")
}
