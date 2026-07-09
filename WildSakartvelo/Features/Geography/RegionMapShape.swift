import SwiftUI

struct RegionMapShape: Shape {
    let region: GeorgiaRegion

    func path(in rect: CGRect) -> Path {
        MapPathBuilder.path(for: points(for: region.mapShapeID), in: rect)
    }

    private func points(for id: String) -> [CGPoint] {
        switch id {
        case "adjara":
            return [
                CGPoint(x: 0.09, y: 0.63),
                CGPoint(x: 0.18, y: 0.63),
                CGPoint(x: 0.27, y: 0.70),
                CGPoint(x: 0.21, y: 0.78),
                CGPoint(x: 0.12, y: 0.72)
            ]
        case "guria":
            return [
                CGPoint(x: 0.18, y: 0.56),
                CGPoint(x: 0.29, y: 0.57),
                CGPoint(x: 0.32, y: 0.65),
                CGPoint(x: 0.27, y: 0.70),
                CGPoint(x: 0.18, y: 0.63)
            ]
        case "samegrelo-zemo-svaneti":
            return [
                CGPoint(x: 0.08, y: 0.52),
                CGPoint(x: 0.12, y: 0.43),
                CGPoint(x: 0.23, y: 0.33),
                CGPoint(x: 0.35, y: 0.29),
                CGPoint(x: 0.37, y: 0.43),
                CGPoint(x: 0.30, y: 0.52),
                CGPoint(x: 0.18, y: 0.56)
            ]
        case "racha-lechkhumi-kvemo-svaneti":
            return [
                CGPoint(x: 0.35, y: 0.29),
                CGPoint(x: 0.48, y: 0.24),
                CGPoint(x: 0.58, y: 0.28),
                CGPoint(x: 0.55, y: 0.41),
                CGPoint(x: 0.45, y: 0.45),
                CGPoint(x: 0.37, y: 0.43)
            ]
        case "imereti":
            return [
                CGPoint(x: 0.30, y: 0.52),
                CGPoint(x: 0.37, y: 0.43),
                CGPoint(x: 0.45, y: 0.45),
                CGPoint(x: 0.50, y: 0.54),
                CGPoint(x: 0.44, y: 0.63),
                CGPoint(x: 0.32, y: 0.65),
                CGPoint(x: 0.29, y: 0.57)
            ]
        case "samtskhe-javakheti":
            return [
                CGPoint(x: 0.27, y: 0.70),
                CGPoint(x: 0.32, y: 0.65),
                CGPoint(x: 0.44, y: 0.63),
                CGPoint(x: 0.58, y: 0.66),
                CGPoint(x: 0.62, y: 0.77),
                CGPoint(x: 0.48, y: 0.80),
                CGPoint(x: 0.34, y: 0.75)
            ]
        case "shida-kartli":
            return [
                CGPoint(x: 0.45, y: 0.45),
                CGPoint(x: 0.55, y: 0.41),
                CGPoint(x: 0.64, y: 0.45),
                CGPoint(x: 0.65, y: 0.55),
                CGPoint(x: 0.58, y: 0.63),
                CGPoint(x: 0.50, y: 0.54)
            ]
        case "mtskheta-mtianeti":
            return [
                CGPoint(x: 0.58, y: 0.28),
                CGPoint(x: 0.67, y: 0.27),
                CGPoint(x: 0.74, y: 0.34),
                CGPoint(x: 0.69, y: 0.45),
                CGPoint(x: 0.64, y: 0.45),
                CGPoint(x: 0.55, y: 0.41)
            ]
        case "tbilisi":
            return [
                CGPoint(x: 0.64, y: 0.51),
                CGPoint(x: 0.68, y: 0.49),
                CGPoint(x: 0.71, y: 0.53),
                CGPoint(x: 0.68, y: 0.57),
                CGPoint(x: 0.64, y: 0.55)
            ]
        case "kvemo-kartli":
            return [
                CGPoint(x: 0.65, y: 0.55),
                CGPoint(x: 0.69, y: 0.45),
                CGPoint(x: 0.78, y: 0.50),
                CGPoint(x: 0.86, y: 0.61),
                CGPoint(x: 0.72, y: 0.72),
                CGPoint(x: 0.58, y: 0.66),
                CGPoint(x: 0.58, y: 0.63)
            ]
        case "kakheti":
            return [
                CGPoint(x: 0.69, y: 0.45),
                CGPoint(x: 0.74, y: 0.34),
                CGPoint(x: 0.84, y: 0.34),
                CGPoint(x: 0.94, y: 0.44),
                CGPoint(x: 0.91, y: 0.56),
                CGPoint(x: 0.86, y: 0.61),
                CGPoint(x: 0.78, y: 0.50)
            ]
        default:
            let center = CGPoint(x: region.mapPosition.x, y: region.mapPosition.y)
            return [
                CGPoint(x: center.x - 0.05, y: center.y - 0.04),
                CGPoint(x: center.x + 0.05, y: center.y - 0.04),
                CGPoint(x: center.x + 0.05, y: center.y + 0.04),
                CGPoint(x: center.x - 0.05, y: center.y + 0.04)
            ]
        }
    }
}

struct GeorgiaCountryShape: Shape {
    func path(in rect: CGRect) -> Path {
        MapPathBuilder.path(
            for: [
                CGPoint(x: 0.06, y: 0.54),
                CGPoint(x: 0.10, y: 0.43),
                CGPoint(x: 0.19, y: 0.34),
                CGPoint(x: 0.31, y: 0.28),
                CGPoint(x: 0.46, y: 0.23),
                CGPoint(x: 0.61, y: 0.23),
                CGPoint(x: 0.74, y: 0.28),
                CGPoint(x: 0.87, y: 0.35),
                CGPoint(x: 0.96, y: 0.45),
                CGPoint(x: 0.93, y: 0.57),
                CGPoint(x: 0.84, y: 0.65),
                CGPoint(x: 0.72, y: 0.72),
                CGPoint(x: 0.59, y: 0.79),
                CGPoint(x: 0.46, y: 0.81),
                CGPoint(x: 0.34, y: 0.76),
                CGPoint(x: 0.25, y: 0.78),
                CGPoint(x: 0.16, y: 0.70),
                CGPoint(x: 0.09, y: 0.64)
            ],
            in: rect
        )
    }
}

private enum MapPathBuilder {
    static func path(for normalizedPoints: [CGPoint], in rect: CGRect) -> Path {
        var path = Path()
        guard let firstPoint = normalizedPoints.first else { return path }

        path.move(to: denormalize(firstPoint, in: rect))
        for point in normalizedPoints.dropFirst() {
            path.addLine(to: denormalize(point, in: rect))
        }
        path.closeSubpath()
        return path
    }

    private static func denormalize(_ point: CGPoint, in rect: CGRect) -> CGPoint {
        CGPoint(
            x: rect.minX + rect.width * point.x,
            y: rect.minY + rect.height * point.y
        )
    }
}
