import SwiftUI

struct AudioControlButton<AudioService: AudioPlaying>: View where AudioService: ObservableObject {
    let fileName: String?
    let label: String?
    @ObservedObject var audioService: AudioService
    let actionLabel: String
    var accessibilityIdentifier: String? = nil
    @Environment(\.appAccessibilitySettings) private var accessibilitySettings

    var body: some View {
        Button {
            guard let fileName else { return }
            if audioService.currentFileName == fileName {
                if audioService.isPlaying {
                    audioService.pause()
                } else {
                    audioService.resume()
                }
            } else {
                audioService.play(fileName: fileName)
            }
        } label: {
            HStack(spacing: AppSpacing.small) {
                Image(systemName: iconName)
                    .font(.system(size: 16, weight: .semibold))

                if let label {
                    Text(label)
                        .font(AppTypography.button)
                }
            }
            .foregroundStyle(foregroundColor)
            .frame(minHeight: 44)
            .padding(.horizontal, AppSpacing.medium)
            .background(backgroundColor, in: RoundedRectangle(cornerRadius: AppSpacing.small))
        }
        .disabled(fileName == nil)
        .accessibilityLabel(accessibilityLabel)
        .accessibilityHint(String(localized: "audio.button.hint", defaultValue: "Plays or pauses audio playback."))
        .accessibilityIdentifier(accessibilityIdentifier ?? "audio.controlButton")
    }

    private var iconName: String {
        guard let fileName else { return "speaker.slash.fill" }
        if audioService.currentFileName == fileName, audioService.isPlaying {
            return "pause.fill"
        }
        return "play.fill"
    }

    private var accessibilityLabel: String {
        guard let fileName else {
            return String(localized: "audio.button.unavailable", defaultValue: "\(actionLabel) unavailable")
        }

        if audioService.currentFileName == fileName, audioService.isPlaying {
            return String(localized: "audio.button.pause", defaultValue: "Pause \(actionLabel)")
        }

        return String(localized: "audio.button.play", defaultValue: "Play \(actionLabel)")
    }

    private var backgroundColor: Color {
        fileName == nil ? AppColors.secondaryText.opacity(0.14) : AppColors.selectionFill(using: accessibilitySettings)
    }

    private var foregroundColor: Color {
        fileName == nil ? AppColors.secondaryText : AppColors.forest
    }
}

#Preview("Audio Button") {
    final class PreviewService: ObservableObject, AudioPlaying {
        @Published var isPlaying = false
        @Published var currentFileName: String? = nil

        func play(fileName: String) {}
        func pause() {}
        func resume() {}
        func stop() {}
    }

    return VStack(spacing: AppSpacing.medium) {
        AudioControlButton(
            fileName: "identify_animal_instruction",
            label: "Play narration",
            audioService: PreviewService(),
            actionLabel: "narration",
            accessibilityIdentifier: "audio.previewButton"
        )

        AudioControlButton(
            fileName: nil,
            label: "Play narration",
            audioService: PreviewService(),
            actionLabel: "narration",
            accessibilityIdentifier: "audio.previewButtonDisabled"
        )
    }
    .padding()
    .background(AppColors.background)
}
