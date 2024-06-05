import SwiftUI

struct JoinDreamModal: View {
    @StateObject private var userViewModel = ProfileVM()
    
    @Binding var code: String
    var userId: String
    var profile: String
    var name: String
    
    var body: some View {
        VStack {
            CustomTextFieldString(text: $code, placeholder: "Kode Undangan")
                .padding(.horizontal, 16)
                .padding(.vertical, 3)
            
            Button {
                userViewModel.joinDream(code: code, userId: userId, profile: profile, name: name)
            } label: {
                HStack {
                    Spacer()
                    Text("Gabung")
                        .foregroundStyle(.white)
                    Spacer()
                }
                
            }
            .padding()
            .frame(height: 50)
            .background(.teal700)
            .cornerRadius(8)
            .padding(.horizontal, 16)
            .padding(.top, 10)
            
            Spacer()
            
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
        .padding(.top, 30)
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
