//
//  HomeRepositoryImpl.swift
//  Carely
//
//  Created by Mina on 22/07/2026.
//

import Foundation
 
final class HomeRepositoryImpl: HomeRepositoryProtocol {
 
    private let simulatedDelayNanoseconds: UInt64 = 600_000_000
 
    init() {}
 
    // MARK: - Greeting
 
    func fetchGreetingName() async throws -> String {
        try await Task.sleep(nanoseconds: simulatedDelayNanoseconds)
        return "Elena"
    }
 
    // MARK: - Categories
 
    func fetchServiceCategories() async throws -> [ServiceCategory] {
        try await Task.sleep(nanoseconds: simulatedDelayNanoseconds)
        return Self.allCategories
    }
 
    func searchServiceCategories(query: String) async throws -> [ServiceCategory] {
        try await Task.sleep(nanoseconds: simulatedDelayNanoseconds / 2)
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return Self.allCategories }
        return Self.allCategories.filter {
            $0.title.localizedCaseInsensitiveContains(trimmed) ||
            $0.subtitle.localizedCaseInsensitiveContains(trimmed)
        }
    }
 
    // MARK: - Bookings
 
    func fetchUpcomingBookings() async throws -> [UpcomingBooking] {
        try await Task.sleep(nanoseconds: simulatedDelayNanoseconds)
        return [
            UpcomingBooking(
                id: "booking-1",
                providerName: "Nurse Sarah Jenkins",
                providerImageName: "person.crop.circle.fill",
                serviceName: "General Nursing Care",
                status: .confirmed,
                dateTimeText: "Today, 02:30 PM"
            )
        ]
    }
 
    // MARK: - Service Detail
 
    func fetchServiceDetail(id: String) async throws -> ServiceDetail {
        try await Task.sleep(nanoseconds: simulatedDelayNanoseconds)
        guard let detail = Self.serviceDetails[id] else {
            throw HomeError.serviceNotFound
        }
        return detail
    }
 
    // MARK: - Mock Data Source
 
    /// Canonical list of categories, shared by the Home preview grid
    /// (first N items) and the full Service Categories screen.
    static let allCategories: [ServiceCategory] = [
        ServiceCategory(
            id: "general-nursing",
            title: "General Nursing",
            subtitle: "Routine checks & wellness",
            iconName: "cross.case.fill",
            layout: .featured,
            accent: .primary
        ),
        ServiceCategory(
            id: "injection",
            title: "Injection",
            subtitle: "Home dosage",
            iconName: "cross.vial.fill",
            layout: .standard,
            accent: .neutral
        ),
        ServiceCategory(
            id: "physical-therapy",
            title: "Physical Therapy",
            subtitle: "Mobility aid",
            iconName: "figure.walk",
            layout: .standard,
            accent: .neutral
        ),
        ServiceCategory(
            id: "wound-care",
            title: "Wound Care",
            subtitle: "Post-surgery",
            iconName: "bandage.fill",
            layout: .standard,
            accent: .neutral
        ),
        ServiceCategory(
            id: "lab-tests",
            title: "Lab Tests",
            subtitle: "Sample collection at home",
            iconName: "testtube.2",
            layout: .wide,
            accent: .secondary
        ),
        ServiceCategory(
            id: "elderly-care",
            title: "Elderly Care",
            subtitle: "Daily support",
            iconName: "figure.walk.circle.fill",
            layout: .standard,
            accent: .neutral
        ),
        ServiceCategory(
            id: "post-natal",
            title: "Post-Natal",
            subtitle: "Mother & baby",
            iconName: "heart.circle.fill",
            layout: .standard,
            accent: .neutral
        ),
        ServiceCategory(
            id: "vaccinations",
            title: "Vaccinations",
            subtitle: "All age groups",
            iconName: "shield.lefthalf.filled",
            layout: .standard,
            accent: .neutral
        ),
        ServiceCategory(
            id: "iv-drip",
            title: "IV Drip",
            subtitle: "Hydration therapy",
            iconName: "drop.triangle.fill",
            layout: .standard,
            accent: .neutral
        ),
        ServiceCategory(
            id: "chronic-care",
            title: "Chronic Care",
            subtitle: "Diabetes, Hypertension & more",
            iconName: "heart.text.square.fill",
            layout: .wide,
            accent: .tertiary
        )
    ]
 
    static let serviceDetails: [String: ServiceDetail] = [
        "general-nursing": ServiceDetail(
            id: "general-nursing",
            title: "General Nursing",
            subtitle: "Routine health checks in the comfort of home.",
            badgeText: "Clinical Grade",
            heroIconName: "cross.case.fill",
            priceText: "$79.00",
            durationText: "30-45 min",
            aboutDescription: "A registered nurse visits your home to perform routine health checks, medication management, and wellness monitoring tailored to your care plan.",
            includedItems: [
                "In-home visit by a Registered Nurse",
                "Vital signs monitoring and health screening",
                "Medication administration and review",
                "Written visit summary for your records"
            ],
            noteText: "Please have any current medications available for review during the visit."
        ),
        "injection": ServiceDetail(
            id: "injection",
            title: "Injection Service",
            subtitle: "Safe, prescribed injections at home.",
            badgeText: "Nurse Administered",
            heroIconName: "cross.vial.fill",
            priceText: "$35.00",
            durationText: "15-20 min",
            aboutDescription: "A qualified nurse administers your prescribed injection at home, following your doctor's instructions with full attention to safety and hygiene.",
            includedItems: [
                "In-home visit by a Registered Nurse",
                "Administration of prescribed injection",
                "Post-injection observation for reactions",
                "Disposable, single-use medical supplies"
            ],
            noteText: "Please have your prescription and medication ready before the nurse arrives."
        ),
        "physical-therapy": ServiceDetail(
            id: "physical-therapy",
            title: "Physical Therapy",
            subtitle: "Guided mobility and rehabilitation sessions.",
            badgeText: "Licensed Therapist",
            heroIconName: "figure.walk",
            priceText: "$99.00",
            durationText: "45-60 min",
            aboutDescription: "A licensed physical therapist works with you at home on mobility, strength, and rehabilitation exercises tailored to your recovery goals.",
            includedItems: [
                "In-home visit by a licensed Physical Therapist",
                "Personalized mobility assessment",
                "Guided rehabilitation exercises",
                "Take-home exercise plan"
            ],
            noteText: "Please wear comfortable clothing that allows freedom of movement."
        ),
        "wound-care": ServiceDetail(
            id: "wound-care",
            title: "Wound Care",
            subtitle: "Professional dressing for post-surgery wounds.",
            badgeText: "Sterile Technique",
            heroIconName: "bandage.fill",
            priceText: "$65.00",
            durationText: "20-30 min",
            aboutDescription: "A trained nurse cleans, assesses, and re-dresses surgical or chronic wounds using sterile technique to support healing and prevent infection.",
            includedItems: [
                "In-home visit by a Registered Nurse",
                "Wound assessment and cleaning",
                "Sterile dressing and bandaging",
                "Infection risk monitoring"
            ],
            noteText: "Please keep the wound area accessible and avoid applying new dressings before the visit."
        ),
        "lab-tests": ServiceDetail(
            id: "lab-tests",
            title: "Lab Tests",
            subtitle: "Sample collection at home, results delivered digitally.",
            badgeText: "Certified Lab",
            heroIconName: "testtube.2",
            priceText: "$45.00",
            durationText: "10-15 min",
            aboutDescription: "A phlebotomist visits your home to collect blood or other samples, which are then processed at a certified partner laboratory.",
            includedItems: [
                "In-home visit by a certified phlebotomist",
                "Sample collection (blood, urine, or as prescribed)",
                "Secure, temperature-controlled transport",
                "Digital results delivered within 24-48 hours"
            ],
            noteText: "Fasting may be required for certain tests; please confirm with your doctor beforehand."
        ),
        "elderly-care": ServiceDetail(
            id: "elderly-care",
            title: "Elderly Care",
            subtitle: "Compassionate daily support for seniors.",
            badgeText: "Trained Caregiver",
            heroIconName: "figure.walk.circle.fill",
            priceText: "$25.00/hr",
            durationText: "Flexible",
            aboutDescription: "A trained caregiver provides daily living support for elderly patients, including mobility assistance, companionship, and personal care.",
            includedItems: [
                "Assistance with daily living activities",
                "Mobility and fall-prevention support",
                "Medication reminders",
                "Companionship and wellbeing checks"
            ],
            noteText: "Care plans can be customized to hourly, daily, or recurring schedules."
        ),
        "post-natal": ServiceDetail(
            id: "post-natal",
            title: "Post-Natal Care",
            subtitle: "Support for new mothers and their babies.",
            badgeText: "Maternal Care",
            heroIconName: "heart.circle.fill",
            priceText: "$89.00",
            durationText: "45-60 min",
            aboutDescription: "A specialized nurse supports new mothers with recovery monitoring, breastfeeding guidance, and newborn health checks at home.",
            includedItems: [
                "Maternal recovery and vitals check",
                "Newborn health and weight monitoring",
                "Breastfeeding and lactation guidance",
                "Postpartum wellbeing consultation"
            ],
            noteText: "Feel free to prepare any questions about newborn care for the nurse."
        ),
        "vaccinations": ServiceDetail(
            id: "vaccinations",
            title: "Vaccinations",
            subtitle: "Immunizations for all age groups.",
            badgeText: "WHO Approved",
            heroIconName: "shield.lefthalf.filled",
            priceText: "$40.00",
            durationText: "15-20 min",
            aboutDescription: "A licensed nurse administers routine or travel vaccinations at home, following approved immunization schedules for all age groups.",
            includedItems: [
                "In-home visit by a Registered Nurse",
                "Vaccine administration",
                "Post-vaccination observation",
                "Digital immunization record update"
            ],
            noteText: "Please bring any existing vaccination records to your appointment."
        ),
        "iv-drip": ServiceDetail(
            id: "iv-drip",
            title: "IV Hydration Therapy",
            subtitle: "Personalized hydration and vitamin infusion.",
            badgeText: "Clinical Grade",
            heroIconName: "drop.triangle.fill",
            priceText: "$189.00",
            durationText: "45-60 min",
            aboutDescription: "Our IV Therapy is administered by certified medical professionals in the comfort of your home. This treatment rapidly restores fluid balance and delivers essential vitamins directly into your bloodstream for maximum absorption.",
            includedItems: [
                "In-home travel & setup by a Registered Nurse",
                "Vital signs monitoring and health screening",
                "1000ml Saline / Lactated Ringer solution",
                "Custom vitamin booster (B-Complex + Vitamin C)",
                "Disposable high-quality medical supplies"
            ],
            noteText: "Please note: a brief health questionnaire is required before the arrival of your specialist to ensure safety."
        ),
        "chronic-care": ServiceDetail(
            id: "chronic-care",
            title: "Chronic Care Management",
            subtitle: "Ongoing support for diabetes, hypertension & more.",
            badgeText: "Long-Term Care",
            heroIconName: "heart.text.square.fill",
            priceText: "$120.00/mo",
            durationText: "Recurring visits",
            aboutDescription: "A dedicated care team manages ongoing chronic conditions such as diabetes and hypertension, combining regular monitoring with lifestyle guidance.",
            includedItems: [
                "Recurring in-home nurse visits",
                "Blood pressure and glucose monitoring",
                "Medication adherence tracking",
                "Personalized lifestyle and diet guidance"
            ],
            noteText: "Care plans are reviewed monthly with your primary physician's input."
        )
    ]
}
