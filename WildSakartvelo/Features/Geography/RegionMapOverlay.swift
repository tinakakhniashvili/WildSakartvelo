import MapKit
import SwiftUI

struct RegionMapOverlay: View {
    let regions: [GeorgiaRegion]
    let selectedRegionID: String?
    let language: AppLanguage
    let onSelect: (GeorgiaRegion) -> Void
    @State private var cameraPosition: MapCameraPosition = .region(GeorgiaMapCamera.defaultRegion)
    @Environment(\.appAccessibilitySettings) private var accessibilitySettings

    var body: some View {
        map
            .mapStyle(.standard(elevation: .realistic, pointsOfInterest: .excludingAll, showsTraffic: false))
            .mapControls {
                MapScaleView()
            }
            .clipShape(RoundedRectangle(cornerRadius: AppRadius.largeCard))
            .overlay {
                RoundedRectangle(cornerRadius: AppRadius.largeCard)
                    .stroke(AppColors.cardBorder(using: accessibilitySettings), lineWidth: 1)
            }
            .aspectRatio(1.45, contentMode: .fit)
    }

    private var map: some View {
        Map(position: $cameraPosition, interactionModes: [.pan, .zoom]) {
            ForEach(regions) { region in
                regionAnnotation(region)
            }
        }
    }

    @MapContentBuilder
    private func regionAnnotation(_ region: GeorgiaRegion) -> some MapContent {
        Annotation(
            region.name.displayText(for: language),
            coordinate: GeorgiaMapCamera.coordinate(for: region),
            anchor: .bottom
        ) {
            Button {
                onSelect(region)
            } label: {
                regionMarker(for: region, isSelected: region.id == selectedRegionID)
            }
            .buttonStyle(.plain)
            .accessibilityLabel(region.name.displayText(for: language))
            .accessibilityHint(region.administrativeCenter.displayText(for: language))
            .accessibilityAddTraits(region.id == selectedRegionID ? [.isSelected] : [])
        }
    }

    private func regionMarker(for region: GeorgiaRegion, isSelected: Bool) -> some View {
        VStack(spacing: 4) {
            ZStack {
                Circle()
                    .fill(isSelected ? AppColors.sunshine : AppColors.forest)
                    .frame(width: isSelected ? 34 : 26, height: isSelected ? 34 : 26)
                    .shadow(color: .black.opacity(0.22), radius: 4, x: 0, y: 2)

                Image(systemName: region.id == "tbilisi" ? "star.fill" : "mappin")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(isSelected ? AppColors.primaryText : .white)
            }

            if isSelected {
                Text(region.name.displayText(for: language))
                    .font(AppTypography.caption.weight(.semibold))
                    .foregroundStyle(AppColors.primaryText)
                    .lineLimit(1)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(AppColors.surface.opacity(0.94), in: Capsule())
                    .shadow(color: .black.opacity(0.12), radius: 4, x: 0, y: 2)
            }
        }
    }
}

struct GeorgiaMapThumbnailView: View {
    let regions: [GeorgiaRegion]
    private let cameraPosition: MapCameraPosition = .region(GeorgiaMapCamera.defaultRegion)

    var body: some View {
        Map(position: .constant(cameraPosition), interactionModes: []) {
            ForEach(regions) { region in
                Marker(region.name.displayText(for: .english), coordinate: GeorgiaMapCamera.coordinate(for: region))
                    .tint(region.id == "tbilisi" ? AppColors.sunshine : AppColors.forest)
            }
        }
        .mapStyle(.standard(elevation: .realistic, pointsOfInterest: .excludingAll, showsTraffic: false))
        .allowsHitTesting(false)
        .aspectRatio(1.45, contentMode: .fit)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.thumbnail))
    }
}

private enum GeorgiaMapCamera {
    static let defaultRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 42.10, longitude: 43.70),
        span: MKCoordinateSpan(latitudeDelta: 2.95, longitudeDelta: 5.75)
    )

    static func coordinate(for region: GeorgiaRegion) -> CLLocationCoordinate2D {
        switch region.id {
        case "adjara":
            return CLLocationCoordinate2D(latitude: 41.6168, longitude: 41.6367)
        case "guria":
            return CLLocationCoordinate2D(latitude: 41.9244, longitude: 42.0068)
        case "samegrelo-zemo-svaneti":
            return CLLocationCoordinate2D(latitude: 42.5088, longitude: 41.8709)
        case "racha-lechkhumi-kvemo-svaneti":
            return CLLocationCoordinate2D(latitude: 42.5211, longitude: 43.1622)
        case "imereti":
            return CLLocationCoordinate2D(latitude: 42.2679, longitude: 42.6946)
        case "samtskhe-javakheti":
            return CLLocationCoordinate2D(latitude: 41.6390, longitude: 42.9826)
        case "shida-kartli":
            return CLLocationCoordinate2D(latitude: 41.9842, longitude: 44.1158)
        case "mtskheta-mtianeti":
            return CLLocationCoordinate2D(latitude: 41.8451, longitude: 44.7188)
        case "tbilisi":
            return CLLocationCoordinate2D(latitude: 41.7151, longitude: 44.8271)
        case "kvemo-kartli":
            return CLLocationCoordinate2D(latitude: 41.5495, longitude: 44.9932)
        case "kakheti":
            return CLLocationCoordinate2D(latitude: 41.9167, longitude: 45.4733)
        default:
            return CLLocationCoordinate2D(
                latitude: 43.40 - (region.mapPosition.y * 2.9),
                longitude: 40.95 + (region.mapPosition.x * 5.9)
            )
        }
    }
}
