import SwiftUI

struct UpdateDreamForm: View {
    @EnvironmentObject var createDreamVM: CreateDreamVM
    @EnvironmentObject var detailDreamViewModel: DreamDetailVM
    
    @ObservedObject var DreamsVM = DreamsViewModel()
    @Environment(\.dismiss) var dismiss
    
    @State var userData: UserData
    let user: Users
    var dream: Dreams
    
    var onComplete: () -> Void
    
    @State private var selectedColor = "#ABD3DB"
    @State private var selectedEmoticon = ""
    @State private var selectedEmoticonURL: URL? = nil
    
    @State private var name: String = ""
    @State private var target: Double? = nil
    @State private var scheduler_rate: Double? = nil
    @State private var scheduler: String = ""
    
    @State private var showingColorPicker = false
    @State private var showingEmoticon = false
    
    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Sesuaikan Impianmu")
                            .font(.title3)
                        Text("Berikan nama, emoji, color, dan target.")
                            .font(.subheadline)
                    }
                    Spacer()
                }
                .padding(.top, 20)
                .padding(.bottom, 2)
                
                HStack {
                    Button {
                        showingEmoticon = true
                    } label: {
                        Image(systemName: "photo.circle.fill")
                            .resizable()
                            .frame(width: 32, height: 32)
                            .foregroundStyle(.teal700)
                            .padding(2)
                    }
                    
                    Spacer()
                    
                    if selectedEmoticonURL != nil {
                        EmoticonItem(url: $selectedEmoticonURL)
                            .frame(width: 100, height: 100)
                            .background(Color(hex: selectedColor))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .padding()
                        
                    } else {
                        Image(systemName: "photo")
                            .frame(width: 100, height: 100)
                            .background(Color(hex: selectedColor))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .padding()
                    }
                    
                    Spacer()
                    
                    Button {
                        showingColorPicker = true
                    } label: {
                        Image(systemName: "eyedropper.full")
                            .foregroundStyle(.white)
                            .frame(width: 32, height: 32)
                            .background(.teal700)
                            .clipShape(Circle())
                            .padding(2)
                    }
                }
                
                CustomTextFieldString(text: $name, placeholder: "Nama Impian")
                    .padding(.vertical, 3)
                
                CustomTextFieldDouble(text: $target, placeholder: "Nominal Target", formatter: NumberFormatter())
                    .padding(.vertical, 3)
                
                CustomButton(scheduler: $scheduler)
                    .padding()
                
                CustomTextFieldDouble(text: $scheduler_rate, placeholder: "Nominal Pengisian", formatter: NumberFormatter())
                    .padding(.top, 3)
                
                VStack {
                    let targetDate = createDreamVM.calculateTargetDate(target: target ?? 0, scheduler: scheduler, schedulerRate: scheduler_rate ?? 0)
                    Text(targetDate)
                        .font(.caption2)
                        .foregroundStyle(.gray)
                    
                    Button {
                        Task {
                            do {
                                try await detailDreamViewModel.updateDream(dreamId: dream.id, userId: userData.uid, profile: selectedEmoticon, background: selectedColor, name: name, target: target!, scheduler: scheduler, schedulerRate: scheduler_rate!)
    
                                onComplete()

                                dismiss()
                            } catch {
                                print(error)
                            }
                        }
                    } label: {
                        Text("Simpan")
                            .foregroundColor(.white)
                            .font(.system(size: 16, weight: .semibold))
                            .frame(maxWidth: .infinity, minHeight: 42)
                            .background(.teal700)
                            .cornerRadius(10)
                    }
                }
                .padding(.vertical, 2)
                Spacer()
                
            }
            .padding(.horizontal, 16)
        }
        .onAppear {
            selectedColor = dream.background
            selectedEmoticon = dream.profile
            if let url = EmoticonService.getEmoticonURL(for: dream.profile) {
                selectedEmoticonURL = url
            }
            name = dream.name
            target = dream.target
            scheduler_rate = dream.schedulerRate
            scheduler = dream.scheduler
        }
        .sheet(isPresented: $showingColorPicker) {
            CustomColorPicker(selectedColor: $selectedColor)
                .presentationDetents([.large, .medium, .fraction(0.5)])
        }
        .sheet(isPresented: $showingEmoticon) {
            EmoticonView(selectedEmoticon: $selectedEmoticon, selectedEmoticonURL: $selectedEmoticonURL)
                .presentationDetents([.large, .medium, .fraction(0.5)])
        }
    }
}

//#Preview {
//    CreateDreamForm(tabBarVisibility: .constant(.visible), userData: .init(uid: "", email: ""), user: Users(id: "", email: "", profile: "", name: "", gender: "", day_of_birth: "", is_active: true, created: 0, updated: 0), onDreamCreated: <#() -> Void#>)
//        .environmentObject(CreateDreamVM())
//}
