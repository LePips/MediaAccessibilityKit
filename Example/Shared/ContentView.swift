import MediaAccessibilityKit
import SwiftUI

struct ContentView: View {
    @Environment(\.scenePhase)
    private var scenePhase

    @State
    private var caption = CaptionSample.short.text
    @State
    private var captionSample: CaptionSample? = .short
    @State
    private var profiles: [CaptionProfile] = []
    @State
    private var selectedProfileID: String?
    @State
    private var errorMessage: String?

    private enum CaptionSample: String, CaseIterable {
        case short = "Jaws"
        case multiline = "The Princess Bride"

        var text: String {
            switch self {
            case .short:
                "You’re gonna need a bigger boat."
            case .multiline:
                "Hello. My name is Inigo Montoya. You killed my father. Prepare to die."
            }
        }
    }

    var body: some View {
        Form {
            Section("Preview") {
                CaptionText(caption, baseSize: 28, style: selectedProfile?.style)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: 480)
                    .padding(24)
                    .frame(maxWidth: .infinity, minHeight: 180)
                    .background(.gray.opacity(0.3), in: .rect(cornerRadius: 12))

                Picker("Sample", selection: $captionSample) {
                    ForEach(CaptionSample.allCases, id: \.self) { sample in
                        Text(sample.rawValue).tag(Optional(sample))
                    }
                    Text("Custom").tag(CaptionSample?.none)
                }
                .onChange(of: captionSample) {
                    if let captionSample {
                        caption = captionSample.text
                    }
                }

                TextField("Caption", text: Binding(
                    get: { caption },
                    set: {
                        guard $0 != caption else { return }
                        caption = $0
                        captionSample = nil
                    }
                ), axis: .vertical)
                    .lineLimit(1 ... 4)
            }

            Section {
                Picker("Style", selection: $selectedProfileID) {
                    Text("Follow System").tag(String?.none)
                    ForEach(profiles) { profile in
                        Text(profile.name).tag(Optional(profile.id))
                    }
                }

                if let profile = selectedProfile {
                    Button("Use as System Caption Style") {
                        activate(profile)
                    }
                }
            } header: {
                Text("Caption Style")
            } footer: {
                if selectedProfile != nil {
                    Text(
                        "Previewing this style only affects this view. Using it as the system caption style changes captions in other apps too."
                    )
                } else {
                    Text("Follows system caption settings. Create or edit saved styles in Accessibility settings.")
                }
            }
        }
        .formStyle(.grouped)
        .navigationTitle("Caption Example")
        .task(id: scenePhase) {
            for await profiles in CaptionProfile.updates {
                self.profiles = profiles
                if selectedProfile == nil {
                    selectedProfileID = nil
                }
            }
        }
        .alert("Couldn't Change Caption Style", isPresented: Binding(
            get: { errorMessage != nil },
            set: {
                if !$0 {
                    errorMessage = nil
                }
            }
        )) {
            Button("OK", role: .cancel) { errorMessage = nil }
        } message: {
            Text(errorMessage ?? "")
        }
    }

    private var selectedProfile: CaptionProfile? {
        profiles.first { $0.id == selectedProfileID }
    }

    private func activate(_ profile: CaptionProfile) {
        do {
            try profile.activate()
            selectedProfileID = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

#Preview {
    ContentView()
}
