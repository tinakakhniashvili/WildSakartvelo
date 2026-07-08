import SwiftUI

struct ParentGateView: View {
    let onUnlocked: () -> Void

    @Environment(\.appAccessibilitySettings) private var accessibilitySettings
    @Environment(\.accessibilityReduceMotion) private var systemReduceMotion
    @EnvironmentObject private var appState: AppState
    @State private var isHolding = false
    @State private var holdStartedAt: Date?
    @State private var holdProgress = 0.0

    private let holdDuration: TimeInterval = 3
    private let timer = Timer.publish(every: 0.05, on: .main, in: .common).autoconnect()

    private var reduceMotion: Bool {
        appState.reducedMotionEnabled || systemReduceMotion
    }

    var body: some View {
        VStack(spacing: AppSpacing.large) {
            Spacer(minLength: AppSpacing.large)

            Image(systemName: "hand.raised.fill")
                .font(.system(size: 54, weight: .semibold))
                .foregroundStyle(AppColors.forest)
                .accessibilityHidden(true)

            VStack(spacing: AppSpacing.small) {
                Text(String.localized("parent.gate.title", for: appState.currentLanguage))
                    .font(AppTypography.screenTitleFont(using: accessibilitySettings))
                    .foregroundStyle(AppColors.primaryText)
                    .multilineTextAlignment(.center)

                Text(String.localized("parent.gate.instructions", for: appState.currentLanguage))
                    .font(AppTypography.bodyFont(using: accessibilitySettings))
                    .foregroundStyle(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
            }

            VStack(spacing: AppSpacing.medium) {
                ProgressView(value: holdProgress, total: 1)
                    .tint(AppColors.forest)
                    .accessibilityLabel(String.localized("parent.gate.progress.label", for: appState.currentLanguage))
                    .accessibilityValue(String.localizedFormat("parent.gate.progress.value", for: appState.currentLanguage, Int(holdProgress * 100)))

                Button {
                } label: {
                    Label(String.localized("parent.gate.holdButton", for: appState.currentLanguage), systemImage: "lock.open.fill")
                        .font(AppTypography.buttonFont(using: accessibilitySettings))
                        .frame(maxWidth: .infinity)
                        .frame(minHeight: 56)
                }
                .buttonStyle(.borderedProminent)
                .tint(AppColors.forest)
                .simultaneousGesture(
                    LongPressGesture(minimumDuration: holdDuration, maximumDistance: 48)
                        .onChanged { _ in
                            startHolding()
                        }
                        .onEnded { _ in
                            completeHold()
                        }
                )
                .simultaneousGesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { _ in startHolding() }
                        .onEnded { _ in
                            if holdProgress < 1 {
                                cancelHold()
                            }
                        }
                )
                .accessibilityHint(String.localized("parent.gate.holdButton.hint", for: appState.currentLanguage))
                .accessibilityAction(named: String.localized("parent.gate.voiceOverAction", for: appState.currentLanguage)) {
                    unlockForAccessibility()
                }
            }

            Text(String.localized("parent.gate.notice", for: appState.currentLanguage))
                .font(AppTypography.captionFont(using: accessibilitySettings))
                .foregroundStyle(AppColors.secondaryText)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)

            Spacer(minLength: AppSpacing.large)
        }
        .padding(AppSpacing.medium)
        .background(AppColors.background)
        .onReceive(timer) { now in
            guard isHolding, let holdStartedAt else { return }
            let progress = min(now.timeIntervalSince(holdStartedAt) / holdDuration, 1)
            updateProgress(progress)
            if progress >= 1 {
                completeHold()
            }
        }
    }

    private func startHolding() {
        guard !isHolding else { return }
        isHolding = true
        holdStartedAt = Date()
        updateProgress(0)
    }

    private func cancelHold() {
        isHolding = false
        holdStartedAt = nil
        updateProgress(0)
    }

    private func completeHold() {
        guard isHolding || holdProgress >= 1 else { return }
        isHolding = false
        holdStartedAt = nil
        updateProgress(1)
        onUnlocked()
    }

    private func unlockForAccessibility() {
        isHolding = false
        holdStartedAt = nil
        updateProgress(1)
        onUnlocked()
    }

    private func updateProgress(_ value: Double) {
        if reduceMotion {
            holdProgress = value
        } else {
            withAnimation(.linear(duration: 0.05)) {
                holdProgress = value
            }
        }
    }
}

#Preview("Parent Gate") {
    ParentGateView {}
        .environmentObject(AppState())
        .environment(\.appAccessibilitySettings, AppAccessibilitySettings.defaultValue)
}
