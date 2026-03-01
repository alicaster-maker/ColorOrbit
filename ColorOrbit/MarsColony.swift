//
//  MarsColony.swift
//  ColorOrbit
//

import SwiftUI

// MARK: - Building Shape Type

enum BuildingShapeType: String, Codable, CaseIterable {
    case landingPad, habitatPod, solarArray, waterExtractor, greenhouse
    case commTower, storageDepot, researchLab, roverGarage, colonyFlag
    case drillRig, oreSmelter, conveyor, mineralSilo, minecart
    case excavator, refinery, loadingDock, controlRoom, deepShaft
    case bioDome, hydroponics, oxygenTank, waterRecycler, seedVault
    case pollinator, fishTank, compostUnit, sunlamp, treeNursery
    case labTower, telescope, serverRoom, windTunnel, chemLab
    case observatory, antennaArray, library, testChamber, dataCore
    case launchTower, fuelTank, hangar, cargoBay, radarDish
    case runwayLight, dockingArm, ticketBooth, beacon, terminalGate
    case apartment, park, clinic, school, marketplace
    case fountain, gym, cafe, garden, townHall
    case reactor, turbine, battery, transformer, coolingTower
    case solarFarm, powerLine, switchyard, capacitor, fusionCore
    case atmoProcessor, gasCollector, heater, condenser, ventStack
    case cloudSeeder, filterBank, pumpStation, thermalPipe, weatherDome
    case amphitheater, statue, gallery, musicHall, cinema
    case monument, archway, bellTower, mural, plaza
    case capitol, embassy, vault, courthouse, grandMonument
    case clockTower, senate, treasury, spire, obelisk
}

// MARK: - Mars Building

struct MarsBuilding {
    let name: String
    let shapeType: BuildingShapeType
}

// MARK: - Mars Zone

struct MarsZone {
    let name: String
    let themeColor: Color
    let buildings: [MarsBuilding]
}

// MARK: - Zone Definitions

let marsZones: [MarsZone] = [
    // Area 1: Mars Landing Zone (0–100)
    MarsZone(name: "Mars Landing Zone", themeColor: Color(red: 0.8, green: 0.3, blue: 0.2), buildings: [
        MarsBuilding(name: "Landing Marks & Flag", shapeType: .colonyFlag),
        MarsBuilding(name: "Habitat Tent", shapeType: .habitatPod),
        MarsBuilding(name: "Second Habitat Tent", shapeType: .greenhouse),
        MarsBuilding(name: "Solar Panel Array", shapeType: .solarArray),
        MarsBuilding(name: "Cargo Crates", shapeType: .storageDepot),
        MarsBuilding(name: "Rover Vehicle", shapeType: .roverGarage),
        MarsBuilding(name: "Antenna Tower", shapeType: .commTower),
        MarsBuilding(name: "Tent Lights", shapeType: .landingPad),
        MarsBuilding(name: "Ground Platform", shapeType: .waterExtractor),
        MarsBuilding(name: "Supply Rocket", shapeType: .launchTower),
    ]),
    // Area 2: Early Colony (100–200)
    MarsZone(name: "Early Colony", themeColor: Color(red: 0.6, green: 0.4, blue: 0.3), buildings: [
        MarsBuilding(name: "Habitat Module", shapeType: .controlRoom),
        MarsBuilding(name: "Oxygen Tank Cluster", shapeType: .oxygenTank),
        MarsBuilding(name: "Walkway Paths", shapeType: .conveyor),
        MarsBuilding(name: "Greenhouse Dome", shapeType: .bioDome),
        MarsBuilding(name: "Service Robot", shapeType: .excavator),
        MarsBuilding(name: "Energy Generator", shapeType: .reactor),
        MarsBuilding(name: "Colony Lights", shapeType: .beacon),
        MarsBuilding(name: "Additional Habitat", shapeType: .researchLab),
        MarsBuilding(name: "Ground Detailing", shapeType: .loadingDock),
        MarsBuilding(name: "Cargo Shuttle", shapeType: .fuelTank),
    ]),
    // Area 3: Growing Base (200–300)
    MarsZone(name: "Growing Base", themeColor: Color(red: 0.5, green: 0.5, blue: 0.6), buildings: [
        MarsBuilding(name: "Command Hub", shapeType: .townHall),
        MarsBuilding(name: "Larger Solar Field", shapeType: .solarFarm),
        MarsBuilding(name: "Rover Parking Bay", shapeType: .hangar),
        MarsBuilding(name: "Comm Dish Upgrade", shapeType: .radarDish),
        MarsBuilding(name: "Oxygen Pipes", shapeType: .thermalPipe),
        MarsBuilding(name: "Storage Building", shapeType: .cargoBay),
        MarsBuilding(name: "Interior Lights", shapeType: .runwayLight),
        MarsBuilding(name: "Additional Greenhouse", shapeType: .treeNursery),
        MarsBuilding(name: "Colony Expansion", shapeType: .apartment),
        MarsBuilding(name: "Heavy Transport Rocket", shapeType: .drillRig),
    ]),
    // Area 4: Industrial Outpost (300–400)
    MarsZone(name: "Industrial Outpost", themeColor: Color(red: 0.6, green: 0.4, blue: 0.2), buildings: [
        MarsBuilding(name: "Mining Drill Platform", shapeType: .deepShaft),
        MarsBuilding(name: "Resource Storage Tanks", shapeType: .mineralSilo),
        MarsBuilding(name: "Conveyor System", shapeType: .refinery),
        MarsBuilding(name: "Industrial Generator", shapeType: .turbine),
        MarsBuilding(name: "Worker Robot Units", shapeType: .minecart),
        MarsBuilding(name: "Expanded Power Grid", shapeType: .powerLine),
        MarsBuilding(name: "Dust Control Towers", shapeType: .ventStack),
        MarsBuilding(name: "Industrial Lighting", shapeType: .switchyard),
        MarsBuilding(name: "Reinforced Ground Pads", shapeType: .amphitheater),
        MarsBuilding(name: "Automated Cargo Launch", shapeType: .oreSmelter),
    ]),
    // Area 5: Power & Energy Hub (400–500)
    MarsZone(name: "Power & Energy Hub", themeColor: Color(red: 1.0, green: 0.8, blue: 0.0), buildings: [
        MarsBuilding(name: "Fusion Reactor Core", shapeType: .fusionCore),
        MarsBuilding(name: "Cooling Tower Units", shapeType: .coolingTower),
        MarsBuilding(name: "Energy Distribution Lines", shapeType: .antennaArray),
        MarsBuilding(name: "Backup Power Modules", shapeType: .battery),
        MarsBuilding(name: "Reactor Glow", shapeType: .transformer),
        MarsBuilding(name: "Shield Emitters", shapeType: .cloudSeeder),
        MarsBuilding(name: "High-Energy Cables", shapeType: .filterBank),
        MarsBuilding(name: "Power Hub Expansion", shapeType: .pumpStation),
        MarsBuilding(name: "Environment Lighting", shapeType: .capacitor),
        MarsBuilding(name: "Energy Surge Event", shapeType: .weatherDome),
    ]),
    // Area 6: Advanced Colony (500–600)
    MarsZone(name: "Advanced Colony", themeColor: Color(red: 0.9, green: 0.7, blue: 0.4), buildings: [
        MarsBuilding(name: "Residential Dome", shapeType: .observatory),
        MarsBuilding(name: "Interior City Lights", shapeType: .sunlamp),
        MarsBuilding(name: "Transport Rover Lanes", shapeType: .windTunnel),
        MarsBuilding(name: "Decoration Elements", shapeType: .fountain),
        MarsBuilding(name: "Civilian Service Robots", shapeType: .pollinator),
        MarsBuilding(name: "Expanded Habitat Ring", shapeType: .musicHall),
        MarsBuilding(name: "Atmospheric Processors", shapeType: .atmoProcessor),
        MarsBuilding(name: "Dome Lighting Upgrade", shapeType: .labTower),
        MarsBuilding(name: "Colony Density", shapeType: .gallery),
        MarsBuilding(name: "Passenger Shuttle", shapeType: .embassy),
    ]),
    // Area 7: High-Tech Labs (600–700)
    MarsZone(name: "High-Tech Labs", themeColor: Color(red: 0.3, green: 0.5, blue: 0.9), buildings: [
        MarsBuilding(name: "Research Lab Dome", shapeType: .testChamber),
        MarsBuilding(name: "Satellite Uplink Tower", shapeType: .telescope),
        MarsBuilding(name: "Robotics Facility", shapeType: .serverRoom),
        MarsBuilding(name: "Holographic Displays", shapeType: .dataCore),
        MarsBuilding(name: "Advanced Antenna Array", shapeType: .gasCollector),
        MarsBuilding(name: "Lab Lighting Effects", shapeType: .chemLab),
        MarsBuilding(name: "Experimental Modules", shapeType: .hydroponics),
        MarsBuilding(name: "Data Center Block", shapeType: .library),
        MarsBuilding(name: "Tech Glow", shapeType: .heater),
        MarsBuilding(name: "Science Vessel Lands", shapeType: .cinema),
    ]),
    // Area 8: Orbital Preparation (700–800)
    MarsZone(name: "Orbital Preparation", themeColor: Color(red: 0.4, green: 0.8, blue: 0.8), buildings: [
        MarsBuilding(name: "Launch Pad Construction", shapeType: .courthouse),
        MarsBuilding(name: "Fuel Storage Tanks", shapeType: .waterRecycler),
        MarsBuilding(name: "Service Gantry Tower", shapeType: .clockTower),
        MarsBuilding(name: "Cargo Loaders", shapeType: .marketplace),
        MarsBuilding(name: "Launch Lights Activate", shapeType: .seedVault),
        MarsBuilding(name: "Heavy Transport Vehicle", shapeType: .fishTank),
        MarsBuilding(name: "Pad Reinforcement", shapeType: .compostUnit),
        MarsBuilding(name: "Pre-Launch Energy Build", shapeType: .condenser),
        MarsBuilding(name: "Countdown Beacons", shapeType: .dockingArm),
        MarsBuilding(name: "Major Rocket Launch", shapeType: .grandMonument),
    ]),
    // Area 9: Orbital Gateway (800–900)
    MarsZone(name: "Orbital Gateway", themeColor: Color(red: 0.8, green: 0.4, blue: 0.8), buildings: [
        MarsBuilding(name: "Orbital Platform Frame", shapeType: .capitol),
        MarsBuilding(name: "Docking Ring", shapeType: .vault),
        MarsBuilding(name: "Solar Wings Deploy", shapeType: .monument),
        MarsBuilding(name: "Cargo Modules Attach", shapeType: .archway),
        MarsBuilding(name: "Traffic Lights in Orbit", shapeType: .bellTower),
        MarsBuilding(name: "Station Expansion", shapeType: .senate),
        MarsBuilding(name: "Communication Arrays", shapeType: .statue),
        MarsBuilding(name: "Habitat Ring in Orbit", shapeType: .mural),
        MarsBuilding(name: "Station Fully Lit", shapeType: .plaza),
        MarsBuilding(name: "Interplanetary Ship Docks", shapeType: .terminalGate),
    ]),
    // Area 10: Deep Space Expansion (900–1000)
    MarsZone(name: "Deep Space Expansion", themeColor: Color(red: 0.9, green: 0.75, blue: 0.3), buildings: [
        MarsBuilding(name: "Deep Space Shipyard", shapeType: .ticketBooth),
        MarsBuilding(name: "Long-Range Antennas", shapeType: .spire),
        MarsBuilding(name: "Exploration Vessels", shapeType: .park),
        MarsBuilding(name: "Navigation Beacons", shapeType: .obelisk),
        MarsBuilding(name: "Starfield Density", shapeType: .clinic),
        MarsBuilding(name: "Large Carrier Ship", shapeType: .school),
        MarsBuilding(name: "Fleet Formation", shapeType: .gym),
        MarsBuilding(name: "Space Traffic", shapeType: .cafe),
        MarsBuilding(name: "Jump Gate Charging", shapeType: .garden),
        MarsBuilding(name: "First Warp Jump", shapeType: .treasury),
    ]),
]

// MARK: - Pure Functions

func marsZoneIndex(for level: Int) -> Int {
    guard level > 0 else { return 0 }
    return ((level - 1) / 100) % marsZones.count
}

func marsZone(for level: Int) -> MarsZone {
    marsZones[marsZoneIndex(for: level)]
}

func marsBuildingsUnlocked(for level: Int) -> Int {
    guard level > 0 else { return 0 }
    let positionInZone = ((level - 1) % 100) + 1
    return min(positionInZone / 10, 10)
}

func marsIsZoneComplete(for level: Int) -> Bool {
    guard level > 0 else { return false }
    return level % 100 == 0
}

func marsIsMilestone(level: Int) -> Bool {
    level > 0 && level % 10 == 0
}

func marsNewBuildingName(for level: Int) -> String? {
    guard marsIsMilestone(level: level) else { return nil }
    let zone = marsZone(for: level)
    let buildingIndex = marsBuildingsUnlocked(for: level) - 1
    guard buildingIndex >= 0 && buildingIndex < zone.buildings.count else { return nil }
    return zone.buildings[buildingIndex].name
}
