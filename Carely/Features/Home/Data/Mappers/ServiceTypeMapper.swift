//
//  ServiceTypeMapper.swift
//  Carely
//
//  Created by Mina on 28/07/2026.
//

import Foundation

// MARK: - Icon Mapping

enum ServiceTypeIconMapper {
    /// Maps a backend `category` string to an SF Symbol name.
    /// Falls back to a sensible default for categories we don't recognize yet.
    static func icon(forCategory category: String) -> String {
        switch category.lowercased() {
        case let value where value.contains("injection"):
            return "cross.vial.fill"
        case let value where value.contains("iv") || value.contains("drip") || value.contains("hydration"):
            return "drop.triangle.fill"
        case let value where value.contains("wound") || value.contains("dressing"):
            return "bandage.fill"
        case let value where value.contains("blood") || value.contains("lab") || value.contains("sample"):
            return "testtube.2"
        case let value where value.contains("elderly"):
            return "figure.walk.circle.fill"
        case let value where value.contains("physio") || value.contains("therapy") || value.contains("mobility"):
            return "figure.strengthtraining.traditional"
        case let value where value.contains("vaccin"):
            return "shield.lefthalf.filled"
        case let value where value.contains("natal") || value.contains("maternal"):
            return "heart.circle.fill"
        case let value where value.contains("chronic"):
            return "heart.text.square.fill"
        case let value where value.contains("nursing") || value.contains("general"):
            return "cross.case.fill"
        default:
            return "cross.case.fill"
        }
    }
}

// MARK: - Layout / Accent Mapping (UI-only, backend has no equivalent)

enum ServiceCategoryLayoutMapper {
    static func layout(at index: Int) -> ServiceCategoryLayout {
        if index == 0 { return .featured }
        if (index + 1).isMultiple(of: 4) { return .wide }
        return .standard
    }

    static func accent(at index: Int) -> ServiceCategoryAccent {
        if index == 0 { return .primary }
        if (index + 1).isMultiple(of: 4) { return index.isMultiple(of: 2) ? .secondary : .tertiary }
        return .neutral
    }
}

// MARK: - Formatting

enum ServiceTypeFormatter {
    static func priceText(_ value: Double) -> String {
        String(format: "$%.2f", value)
    }

    static func durationText(minimum: Int, estimated: Int?) -> String {
        if let estimated = estimated {
            return "\(minimum)-\(estimated) min"
        } else {
            return "\(minimum)+ min" 
        }
    }
}

// MARK: - ServiceCategory

extension ServiceCategory {
    init(serviceType dto: ServiceTypeDTO, index: Int) {
        self.init(
            id: dto.id,
            title: dto.name.capitalized,
            subtitle: dto.description ?? "",
            iconName: ServiceTypeIconMapper.icon(forCategory: dto.category),
            layout: ServiceCategoryLayoutMapper.layout(at: index),
            accent: ServiceCategoryLayoutMapper.accent(at: index),
            imageUrl: dto.imageUrl
        )
    }
}


extension ServiceDetail {
    init(serviceType dto: ServiceTypeDTO) {
        self.init(
            id: dto.id,
            title: dto.name.capitalized,
            subtitle: dto.description ?? "",
            badgeText: dto.category.capitalized,
            heroIconName: ServiceTypeIconMapper.icon(forCategory: dto.category),
            priceText: ServiceTypeFormatter.priceText(dto.basePrice),
            durationText: ServiceTypeFormatter.durationText(
                minimum: dto.minimumDurationMinutes,
                estimated: dto.estimatedDurationMinutes
            ),
            aboutDescription: dto.description ?? "No description available.",
            includedItems: dto.includedItems ?? [],
            
            noteText: dto.preparationNote ?? "",
            imageUrl: dto.imageUrl
        )
    }
}

// MARK: - CareService

extension CareService {
    init(serviceType dto: ServiceTypeDTO) {
        self.init(
            id: dto.id,
            title: dto.name.capitalized,
            icon: ServiceTypeIconMapper.icon(forCategory: dto.category)
        )
    }
}
