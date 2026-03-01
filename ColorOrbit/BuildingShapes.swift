//
//  BuildingShapes.swift
//  ColorOrbit
//

import SwiftUI

// MARK: - Building Renderer

struct BuildingView: View {
    let shapeType: BuildingShapeType
    let unlocked: Bool

    var body: some View {
        Group {
            switch shapeType {
            // Zone 0: Landing Site
            case .landingPad:       landingPadShape
            case .habitatPod:       habitatPodShape
            case .solarArray:       solarArrayShape
            case .waterExtractor:   waterExtractorShape
            case .greenhouse:       greenhouseShape
            case .commTower:        commTowerShape
            case .storageDepot:     storageDepotShape
            case .researchLab:      researchLabShape
            case .roverGarage:      roverGarageShape
            case .colonyFlag:       colonyFlagShape
            // Zone 1: Mining
            case .drillRig:         drillRigShape
            case .oreSmelter:       oreSmelterShape
            case .conveyor:         conveyorShape
            case .mineralSilo:      mineralSiloShape
            case .minecart:         minecartShape
            case .excavator:        excavatorShape
            case .refinery:         refineryShape
            case .loadingDock:      loadingDockShape
            case .controlRoom:      controlRoomShape
            case .deepShaft:        deepShaftShape
            // Zone 2: Bio-Dome
            case .bioDome:          bioDomeShape
            case .hydroponics:      hydroponicsShape
            case .oxygenTank:       oxygenTankShape
            case .waterRecycler:    waterRecyclerShape
            case .seedVault:        seedVaultShape
            case .pollinator:       pollinatorShape
            case .fishTank:         fishTankShape
            case .compostUnit:      compostUnitShape
            case .sunlamp:          sunlampShape
            case .treeNursery:      treeNurseryShape
            // Zone 3: Research
            case .labTower:         labTowerShape
            case .telescope:        telescopeShape
            case .serverRoom:       serverRoomShape
            case .windTunnel:       windTunnelShape
            case .chemLab:          chemLabShape
            case .observatory:      observatoryShape
            case .antennaArray:     antennaArrayShape
            case .library:          libraryShape
            case .testChamber:      testChamberShape
            case .dataCore:         dataCoreShape
            // Zone 4: Spaceport
            case .launchTower:      launchTowerShape
            case .fuelTank:         fuelTankShape
            case .hangar:           hangarShape
            case .cargoBay:         cargoBayShape
            case .radarDish:        radarDishShape
            case .runwayLight:      runwayLightShape
            case .dockingArm:       dockingArmShape
            case .ticketBooth:      ticketBoothShape
            case .beacon:           beaconShape
            case .terminalGate:     terminalGateShape
            // Zone 5: Residential
            case .apartment:        apartmentShape
            case .park:             parkShape
            case .clinic:           clinicShape
            case .school:           schoolShape
            case .marketplace:      marketplaceShape
            case .fountain:         fountainShape
            case .gym:              gymShape
            case .cafe:             cafeShape
            case .garden:           gardenShape
            case .townHall:         townHallShape
            // Zone 6: Power Grid
            case .reactor:          reactorShape
            case .turbine:          turbineShape
            case .battery:          batteryShape
            case .transformer:      transformerShape
            case .coolingTower:     coolingTowerShape
            case .solarFarm:        solarFarmShape
            case .powerLine:        powerLineShape
            case .switchyard:       switchyardShape
            case .capacitor:        capacitorShape
            case .fusionCore:       fusionCoreShape
            // Zone 7: Terraforming
            case .atmoProcessor:    atmoProcessorShape
            case .gasCollector:     gasCollectorShape
            case .heater:           heaterShape
            case .condenser:        condenserShape
            case .ventStack:        ventStackShape
            case .cloudSeeder:      cloudSeederShape
            case .filterBank:       filterBankShape
            case .pumpStation:      pumpStationShape
            case .thermalPipe:      thermalPipeShape
            case .weatherDome:      weatherDomeShape
            // Zone 8: Cultural
            case .amphitheater:     amphitheaterShape
            case .statue:           statueShape
            case .gallery:          galleryShape
            case .musicHall:        musicHallShape
            case .cinema:           cinemaShape
            case .monument:         monumentShape
            case .archway:          archwayShape
            case .bellTower:        bellTowerShape
            case .mural:            muralShape
            case .plaza:            plazaShape
            // Zone 9: Capital
            case .capitol:          capitolShape
            case .embassy:          embassyShape
            case .vault:            vaultShape
            case .courthouse:       courthouseShape
            case .grandMonument:    grandMonumentShape
            case .clockTower:       clockTowerShape
            case .senate:           senateShape
            case .treasury:         treasuryShape
            case .spire:            spireShape
            case .obelisk:          obeliskShape
            }
        }
        .opacity(unlocked ? 1.0 : 0.15)
    }

    // MARK: - Zone 0: Landing Site

    private var landingPadShape: some View {
        ZStack(alignment: .bottom) {
            // Pad base
            RoundedRectangle(cornerRadius: 2)
                .fill(gradient(.gray, .init(white: 0.5)))
                .frame(width: 28, height: 5)
            // Circle marker
            Circle()
                .fill(unlocked ? Color.red.opacity(0.8) : Color.gray.opacity(0.3))
                .frame(width: 8, height: 8)
                .offset(y: -6)
        }
        .frame(width: 28, height: 18)
    }

    private var habitatPodShape: some View {
        ZStack(alignment: .bottom) {
            // Base
            Rectangle()
                .fill(gradient(.init(white: 0.6), .init(white: 0.4)))
                .frame(width: 20, height: 10)
            // Dome
            halfDome(width: 20, height: 12, color1: .init(white: 0.8), color2: .init(white: 0.5))
                .offset(y: -10)
        }
        .frame(width: 20, height: 24)
    }

    private var solarArrayShape: some View {
        ZStack(alignment: .bottom) {
            // Stick
            Rectangle()
                .fill(Color(white: 0.5))
                .frame(width: 2, height: 16)
            // Panels
            Rectangle()
                .fill(gradient(.blue, .init(red: 0.2, green: 0.3, blue: 0.7)))
                .frame(width: 22, height: 6)
                .rotationEffect(.degrees(-15))
                .offset(y: -18)
        }
        .frame(width: 24, height: 26)
    }

    private var waterExtractorShape: some View {
        ZStack(alignment: .bottom) {
            // Cylinder
            RoundedRectangle(cornerRadius: 3)
                .fill(gradient(.cyan.opacity(0.6), .init(red: 0.2, green: 0.4, blue: 0.5)))
                .frame(width: 10, height: 22)
            // Pipe
            Rectangle()
                .fill(Color(white: 0.5))
                .frame(width: 14, height: 3)
                .offset(x: 4, y: -8)
        }
        .frame(width: 22, height: 24)
    }

    private var greenhouseShape: some View {
        halfDome(width: 24, height: 16, color1: .green.opacity(0.5), color2: .init(red: 0.1, green: 0.4, blue: 0.2))
            .frame(width: 24, height: 18)
    }

    private var commTowerShape: some View {
        ZStack(alignment: .bottom) {
            // Tower
            Path { p in
                p.move(to: CGPoint(x: 10, y: 30))
                p.addLine(to: CGPoint(x: 14, y: 0))
                p.addLine(to: CGPoint(x: 18, y: 30))
                p.closeSubpath()
            }
            .fill(gradient(.init(white: 0.7), .init(white: 0.4)))
            .frame(width: 28, height: 30)
            // Dish
            Circle()
                .fill(Color.white.opacity(0.6))
                .frame(width: 6, height: 6)
                .offset(x: 0, y: -26)
        }
        .frame(width: 28, height: 32)
    }

    private var storageDepotShape: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 2)
                .fill(gradient(.init(white: 0.5), .init(white: 0.35)))
                .frame(width: 26, height: 12)
            // Stripes
            ForEach(0..<3, id: \.self) { i in
                Rectangle()
                    .fill(Color.orange.opacity(0.3))
                    .frame(width: 26, height: 1)
                    .offset(y: CGFloat(i * 4) - 4)
            }
        }
        .frame(width: 26, height: 14)
    }

    private var researchLabShape: some View {
        ZStack(alignment: .bottom) {
            // Building
            Rectangle()
                .fill(gradient(.init(white: 0.6), .init(white: 0.4)))
                .frame(width: 20, height: 16)
            // Dome on top
            halfDome(width: 12, height: 8, color1: .init(white: 0.8), color2: .init(white: 0.5))
                .offset(y: -16)
        }
        .frame(width: 20, height: 26)
    }

    private var roverGarageShape: some View {
        ZStack(alignment: .bottom) {
            // Building
            Rectangle()
                .fill(gradient(.init(white: 0.5), .init(white: 0.35)))
                .frame(width: 24, height: 14)
            // Open front
            Rectangle()
                .fill(Color.black.opacity(0.5))
                .frame(width: 16, height: 8)
                .offset(y: -1)
        }
        .frame(width: 24, height: 16)
    }

    private var colonyFlagShape: some View {
        ZStack(alignment: .bottom) {
            // Pole
            Rectangle()
                .fill(Color(white: 0.7))
                .frame(width: 2, height: 28)
            // Flag
            Rectangle()
                .fill(gradient(.red, .orange))
                .frame(width: 14, height: 9)
                .offset(x: 7, y: -22)
        }
        .frame(width: 22, height: 30)
    }

    // MARK: - Zone 1: Mining Outpost

    private var drillRigShape: some View {
        ZStack(alignment: .bottom) {
            Path { p in
                p.move(to: CGPoint(x: 6, y: 28))
                p.addLine(to: CGPoint(x: 12, y: 0))
                p.addLine(to: CGPoint(x: 18, y: 28))
                p.closeSubpath()
            }
            .fill(gradient(.brown, .init(red: 0.4, green: 0.25, blue: 0.1)))
            .frame(width: 24, height: 28)
            Rectangle().fill(Color(white: 0.5)).frame(width: 2, height: 8).offset(y: -26)
        }
        .frame(width: 24, height: 34)
    }

    private var oreSmelterShape: some View {
        ZStack(alignment: .bottom) {
            RoundedRectangle(cornerRadius: 3)
                .fill(gradient(.init(red: 0.6, green: 0.3, blue: 0.1), .init(red: 0.4, green: 0.2, blue: 0.05)))
                .frame(width: 20, height: 16)
            Rectangle().fill(Color.orange.opacity(0.6)).frame(width: 4, height: 6).offset(x: 6, y: -14)
        }
        .frame(width: 24, height: 22)
    }

    private var conveyorShape: some View {
        ZStack(alignment: .bottom) {
            Rectangle()
                .fill(gradient(.init(white: 0.5), .init(white: 0.35)))
                .frame(width: 28, height: 4)
            ForEach(0..<4, id: \.self) { i in
                Circle()
                    .fill(Color(white: 0.6))
                    .frame(width: 4, height: 4)
                    .offset(x: CGFloat(i * 7) - 10, y: -5)
            }
        }
        .frame(width: 28, height: 12)
    }

    private var mineralSiloShape: some View {
        ZStack(alignment: .bottom) {
            RoundedRectangle(cornerRadius: 4)
                .fill(gradient(.init(red: 0.5, green: 0.4, blue: 0.3), .init(red: 0.35, green: 0.25, blue: 0.15)))
                .frame(width: 14, height: 22)
            halfDome(width: 14, height: 6, color1: .init(red: 0.6, green: 0.5, blue: 0.4), color2: .init(red: 0.4, green: 0.3, blue: 0.2))
                .offset(y: -22)
        }
        .frame(width: 14, height: 30)
    }

    private var minecartShape: some View {
        ZStack(alignment: .bottom) {
            Path { p in
                p.move(to: CGPoint(x: 2, y: 0))
                p.addLine(to: CGPoint(x: 0, y: 10))
                p.addLine(to: CGPoint(x: 24, y: 10))
                p.addLine(to: CGPoint(x: 22, y: 0))
                p.closeSubpath()
            }
            .fill(gradient(.init(white: 0.5), .init(white: 0.35)))
            .frame(width: 24, height: 10)
            HStack(spacing: 12) {
                Circle().fill(Color(white: 0.4)).frame(width: 5, height: 5)
                Circle().fill(Color(white: 0.4)).frame(width: 5, height: 5)
            }.offset(y: -1)
        }
        .frame(width: 24, height: 16)
    }

    private var excavatorShape: some View {
        ZStack(alignment: .bottom) {
            Rectangle()
                .fill(gradient(.yellow.opacity(0.7), .init(red: 0.6, green: 0.5, blue: 0.1)))
                .frame(width: 18, height: 12)
            Rectangle()
                .fill(Color.yellow.opacity(0.5))
                .frame(width: 14, height: 3)
                .offset(x: 8, y: -10)
        }
        .frame(width: 28, height: 16)
    }

    private var refineryShape: some View {
        ZStack(alignment: .bottom) {
            RoundedRectangle(cornerRadius: 2)
                .fill(gradient(.init(white: 0.5), .init(white: 0.35)))
                .frame(width: 22, height: 18)
            Rectangle().fill(Color(white: 0.6)).frame(width: 4, height: 8).offset(x: -6, y: -18)
            Rectangle().fill(Color(white: 0.6)).frame(width: 4, height: 12).offset(x: 6, y: -18)
        }
        .frame(width: 26, height: 32)
    }

    private var loadingDockShape: some View {
        ZStack(alignment: .bottom) {
            Rectangle()
                .fill(gradient(.init(white: 0.45), .init(white: 0.3)))
                .frame(width: 26, height: 10)
            Rectangle()
                .fill(Color.init(white: 0.6))
                .frame(width: 26, height: 2)
                .offset(y: -10)
        }
        .frame(width: 26, height: 14)
    }

    private var controlRoomShape: some View {
        ZStack(alignment: .bottom) {
            Rectangle()
                .fill(gradient(.init(white: 0.55), .init(white: 0.4)))
                .frame(width: 18, height: 14)
            Rectangle()
                .fill(Color.cyan.opacity(0.3))
                .frame(width: 10, height: 5)
                .offset(y: -10)
        }
        .frame(width: 18, height: 18)
    }

    private var deepShaftShape: some View {
        ZStack(alignment: .bottom) {
            Rectangle()
                .fill(Color.black.opacity(0.5))
                .frame(width: 10, height: 6)
            Path { p in
                p.move(to: CGPoint(x: 0, y: 26))
                p.addLine(to: CGPoint(x: 10, y: 0))
                p.addLine(to: CGPoint(x: 20, y: 26))
                p.closeSubpath()
            }
            .fill(gradient(.init(white: 0.6), .init(white: 0.35)))
            .frame(width: 20, height: 26)
        }
        .frame(width: 20, height: 28)
    }

    // MARK: - Zone 2: Bio-Dome (reuses dome/rect combos)

    private var bioDomeShape: some View {
        halfDome(width: 26, height: 18, color1: .green.opacity(0.4), color2: .init(red: 0.1, green: 0.5, blue: 0.2))
            .frame(width: 26, height: 20)
    }

    private var hydroponicsShape: some View {
        ZStack(alignment: .bottom) {
            Rectangle().fill(gradient(.init(red: 0.2, green: 0.5, blue: 0.3), .init(red: 0.1, green: 0.3, blue: 0.15))).frame(width: 22, height: 14)
            ForEach(0..<3, id: \.self) { i in
                Rectangle().fill(Color.green.opacity(0.4)).frame(width: 22, height: 1).offset(y: CGFloat(i * 4) - 5)
            }
        }
        .frame(width: 22, height: 16)
    }

    private var oxygenTankShape: some View {
        RoundedRectangle(cornerRadius: 5)
            .fill(gradient(.init(white: 0.8), .init(white: 0.5)))
            .frame(width: 12, height: 20)
    }

    private var waterRecyclerShape: some View {
        ZStack(alignment: .bottom) {
            Circle().fill(gradient(.cyan.opacity(0.5), .init(red: 0.1, green: 0.3, blue: 0.4))).frame(width: 18, height: 18)
            Rectangle().fill(Color(white: 0.4)).frame(width: 4, height: 6).offset(y: -16)
        }
        .frame(width: 18, height: 24)
    }

    private var seedVaultShape: some View {
        ZStack(alignment: .bottom) {
            RoundedRectangle(cornerRadius: 2)
                .fill(gradient(.init(red: 0.3, green: 0.5, blue: 0.3), .init(red: 0.2, green: 0.35, blue: 0.2)))
                .frame(width: 16, height: 14)
            Rectangle().fill(Color.green.opacity(0.3)).frame(width: 10, height: 3).offset(y: -6)
        }
        .frame(width: 16, height: 16)
    }

    private var pollinatorShape: some View {
        ZStack(alignment: .bottom) {
            halfDome(width: 16, height: 12, color1: .yellow.opacity(0.5), color2: .init(red: 0.4, green: 0.4, blue: 0.1))
            Circle().fill(Color.yellow.opacity(0.6)).frame(width: 4, height: 4).offset(y: -14)
        }
        .frame(width: 16, height: 18)
    }

    private var fishTankShape: some View {
        RoundedRectangle(cornerRadius: 3)
            .fill(gradient(.cyan.opacity(0.3), .init(red: 0.1, green: 0.2, blue: 0.4)))
            .frame(width: 20, height: 14)
    }

    private var compostUnitShape: some View {
        RoundedRectangle(cornerRadius: 2)
            .fill(gradient(.brown.opacity(0.6), .init(red: 0.3, green: 0.2, blue: 0.1)))
            .frame(width: 18, height: 12)
    }

    private var sunlampShape: some View {
        ZStack(alignment: .bottom) {
            Rectangle().fill(Color(white: 0.5)).frame(width: 2, height: 20)
            Circle().fill(gradient(.yellow, .orange)).frame(width: 10, height: 10).offset(y: -22)
        }
        .frame(width: 12, height: 28)
    }

    private var treeNurseryShape: some View {
        ZStack(alignment: .bottom) {
            Rectangle().fill(Color.brown.opacity(0.5)).frame(width: 3, height: 10)
            halfDome(width: 18, height: 14, color1: .green, color2: .init(red: 0.0, green: 0.4, blue: 0.1))
                .offset(y: -10)
        }
        .frame(width: 18, height: 26)
    }

    // MARK: - Zone 3: Research Campus

    private var labTowerShape: some View {
        ZStack(alignment: .bottom) {
            RoundedRectangle(cornerRadius: 2)
                .fill(gradient(.init(white: 0.65), .init(white: 0.4)))
                .frame(width: 14, height: 24)
            Rectangle().fill(Color.cyan.opacity(0.3)).frame(width: 8, height: 4).offset(y: -18)
        }
        .frame(width: 14, height: 26)
    }

    private var telescopeShape: some View {
        ZStack(alignment: .bottom) {
            Rectangle().fill(Color(white: 0.5)).frame(width: 3, height: 18)
            Capsule().fill(gradient(.init(white: 0.7), .init(white: 0.4))).frame(width: 16, height: 8).rotationEffect(.degrees(-30)).offset(y: -20)
        }
        .frame(width: 22, height: 30)
    }

    private var serverRoomShape: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 2)
                .fill(gradient(.init(white: 0.45), .init(white: 0.3)))
                .frame(width: 20, height: 16)
            ForEach(0..<4, id: \.self) { i in
                Circle().fill(Color.green.opacity(0.5)).frame(width: 2, height: 2)
                    .offset(x: CGFloat(i * 4) - 6, y: -3)
            }
        }
        .frame(width: 20, height: 18)
    }

    private var windTunnelShape: some View {
        Capsule()
            .fill(gradient(.init(white: 0.55), .init(white: 0.35)))
            .frame(width: 26, height: 12)
    }

    private var chemLabShape: some View {
        ZStack(alignment: .bottom) {
            Rectangle().fill(gradient(.init(white: 0.55), .init(white: 0.38))).frame(width: 18, height: 14)
            Circle().fill(Color.purple.opacity(0.4)).frame(width: 6, height: 6).offset(x: 4, y: -14)
        }
        .frame(width: 18, height: 20)
    }

    private var observatoryShape: some View {
        ZStack(alignment: .bottom) {
            Rectangle().fill(gradient(.init(white: 0.55), .init(white: 0.38))).frame(width: 16, height: 12)
            halfDome(width: 20, height: 14, color1: .init(white: 0.7), color2: .init(white: 0.45))
                .offset(y: -12)
        }
        .frame(width: 20, height: 28)
    }

    private var antennaArrayShape: some View {
        HStack(spacing: 3) {
            ForEach(0..<3, id: \.self) { _ in
                VStack(spacing: 0) {
                    Circle().fill(Color(white: 0.6)).frame(width: 4, height: 4)
                    Rectangle().fill(Color(white: 0.5)).frame(width: 1.5, height: 14)
                }
            }
        }
        .frame(width: 22, height: 20)
    }

    private var libraryShape: some View {
        ZStack(alignment: .bottom) {
            Rectangle().fill(gradient(.init(red: 0.5, green: 0.4, blue: 0.3), .init(red: 0.35, green: 0.25, blue: 0.15))).frame(width: 22, height: 16)
            Path { p in
                p.move(to: CGPoint(x: 0, y: 6))
                p.addLine(to: CGPoint(x: 13, y: 0))
                p.addLine(to: CGPoint(x: 26, y: 6))
                p.closeSubpath()
            }
            .fill(gradient(.init(red: 0.55, green: 0.45, blue: 0.35), .init(red: 0.4, green: 0.3, blue: 0.2)))
            .frame(width: 26, height: 6)
            .offset(y: -16)
        }
        .frame(width: 26, height: 24)
    }

    private var testChamberShape: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 4)
                .fill(gradient(.init(white: 0.5), .init(white: 0.35)))
                .frame(width: 18, height: 18)
            Circle().fill(Color.yellow.opacity(0.3)).frame(width: 8, height: 8)
        }
        .frame(width: 18, height: 20)
    }

    private var dataCoreShape: some View {
        ZStack(alignment: .bottom) {
            RoundedRectangle(cornerRadius: 6)
                .fill(gradient(.cyan.opacity(0.5), .init(red: 0.1, green: 0.2, blue: 0.5)))
                .frame(width: 16, height: 20)
            ForEach(0..<3, id: \.self) { i in
                Rectangle().fill(Color.cyan.opacity(0.3)).frame(width: 10, height: 1).offset(y: CGFloat(i * 5) - 7)
            }
        }
        .frame(width: 16, height: 22)
    }

    // MARK: - Zone 4: Spaceport

    private var launchTowerShape: some View {
        ZStack(alignment: .bottom) {
            Rectangle().fill(gradient(.init(white: 0.6), .init(white: 0.4))).frame(width: 8, height: 30)
            Path { p in
                p.move(to: CGPoint(x: 0, y: 8))
                p.addLine(to: CGPoint(x: 6, y: 0))
                p.addLine(to: CGPoint(x: 12, y: 8))
                p.closeSubpath()
            }
            .fill(gradient(.red.opacity(0.7), .init(red: 0.5, green: 0.1, blue: 0.1)))
            .frame(width: 12, height: 8)
            .offset(y: -30)
        }
        .frame(width: 14, height: 40)
    }

    private var fuelTankShape: some View {
        RoundedRectangle(cornerRadius: 6)
            .fill(gradient(.init(white: 0.7), .init(white: 0.45)))
            .frame(width: 14, height: 22)
    }

    private var hangarShape: some View {
        ZStack(alignment: .bottom) {
            halfDome(width: 28, height: 16, color1: .init(white: 0.55), color2: .init(white: 0.35))
            Rectangle().fill(Color.black.opacity(0.4)).frame(width: 18, height: 6)
        }
        .frame(width: 28, height: 18)
    }

    private var cargoBayShape: some View {
        RoundedRectangle(cornerRadius: 2)
            .fill(gradient(.init(white: 0.5), .init(white: 0.3)))
            .frame(width: 24, height: 14)
    }

    private var radarDishShape: some View {
        ZStack(alignment: .bottom) {
            Rectangle().fill(Color(white: 0.5)).frame(width: 2, height: 16)
            halfDome(width: 16, height: 8, color1: .init(white: 0.7), color2: .init(white: 0.45))
                .rotationEffect(.degrees(180))
                .offset(y: -20)
        }
        .frame(width: 16, height: 28)
    }

    private var runwayLightShape: some View {
        ZStack(alignment: .bottom) {
            Rectangle().fill(Color(white: 0.45)).frame(width: 2, height: 10)
            Circle().fill(unlocked ? Color.yellow : Color(white: 0.3)).frame(width: 6, height: 6).offset(y: -11)
        }
        .frame(width: 8, height: 18)
    }

    private var dockingArmShape: some View {
        ZStack(alignment: .bottom) {
            Rectangle().fill(Color(white: 0.5)).frame(width: 4, height: 16)
            Rectangle().fill(Color(white: 0.55)).frame(width: 16, height: 3).offset(y: -16)
        }
        .frame(width: 18, height: 22)
    }

    private var ticketBoothShape: some View {
        ZStack(alignment: .bottom) {
            Rectangle().fill(gradient(.init(white: 0.55), .init(white: 0.38))).frame(width: 14, height: 12)
            Rectangle().fill(Color.cyan.opacity(0.3)).frame(width: 8, height: 5).offset(y: -4)
        }
        .frame(width: 14, height: 14)
    }

    private var beaconShape: some View {
        ZStack(alignment: .bottom) {
            Path { p in
                p.move(to: CGPoint(x: 4, y: 22))
                p.addLine(to: CGPoint(x: 8, y: 0))
                p.addLine(to: CGPoint(x: 12, y: 22))
                p.closeSubpath()
            }
            .fill(gradient(.init(white: 0.6), .init(white: 0.4)))
            .frame(width: 16, height: 22)
            Circle().fill(unlocked ? Color.red.opacity(0.8) : Color(white: 0.3)).frame(width: 5, height: 5).offset(y: -22)
        }
        .frame(width: 16, height: 28)
    }

    private var terminalGateShape: some View {
        ZStack(alignment: .bottom) {
            Rectangle().fill(gradient(.init(white: 0.55), .init(white: 0.38))).frame(width: 24, height: 16)
            Rectangle().fill(Color.black.opacity(0.4)).frame(width: 10, height: 10)
        }
        .frame(width: 24, height: 18)
    }

    // MARK: - Zone 5: Residential District

    private var apartmentShape: some View {
        ZStack(alignment: .bottom) {
            RoundedRectangle(cornerRadius: 2)
                .fill(gradient(.init(red: 0.7, green: 0.55, blue: 0.35), .init(red: 0.5, green: 0.38, blue: 0.2)))
                .frame(width: 16, height: 26)
            ForEach(0..<3, id: \.self) { i in
                Rectangle().fill(Color.yellow.opacity(0.3)).frame(width: 6, height: 3).offset(y: CGFloat(i * -7) - 3)
            }
        }
        .frame(width: 16, height: 28)
    }

    private var parkShape: some View {
        ZStack(alignment: .bottom) {
            // Ground
            Capsule().fill(Color.green.opacity(0.3)).frame(width: 26, height: 4)
            // Tree
            halfDome(width: 14, height: 10, color1: .green, color2: .init(red: 0.0, green: 0.4, blue: 0.1))
                .offset(y: -8)
            Rectangle().fill(Color.brown.opacity(0.5)).frame(width: 3, height: 6).offset(y: -3)
        }
        .frame(width: 26, height: 22)
    }

    private var clinicShape: some View {
        ZStack(alignment: .bottom) {
            Rectangle().fill(gradient(.init(white: 0.75), .init(white: 0.55))).frame(width: 18, height: 14)
            // Cross
            Rectangle().fill(Color.red.opacity(0.6)).frame(width: 6, height: 2).offset(y: -10)
            Rectangle().fill(Color.red.opacity(0.6)).frame(width: 2, height: 6).offset(y: -10)
        }
        .frame(width: 18, height: 16)
    }

    private var schoolShape: some View {
        ZStack(alignment: .bottom) {
            Rectangle().fill(gradient(.init(red: 0.6, green: 0.45, blue: 0.3), .init(red: 0.4, green: 0.3, blue: 0.18))).frame(width: 22, height: 14)
            Path { p in
                p.move(to: CGPoint(x: 0, y: 6))
                p.addLine(to: CGPoint(x: 13, y: 0))
                p.addLine(to: CGPoint(x: 26, y: 6))
                p.closeSubpath()
            }
            .fill(gradient(.init(red: 0.65, green: 0.5, blue: 0.35), .init(red: 0.45, green: 0.32, blue: 0.2)))
            .frame(width: 26, height: 6).offset(y: -14)
        }
        .frame(width: 26, height: 22)
    }

    private var marketplaceShape: some View {
        ZStack(alignment: .bottom) {
            Rectangle().fill(gradient(.init(white: 0.55), .init(white: 0.38))).frame(width: 26, height: 10)
            // Awning
            Path { p in
                p.move(to: CGPoint(x: 0, y: 4))
                p.addLine(to: CGPoint(x: 15, y: 0))
                p.addLine(to: CGPoint(x: 30, y: 4))
                p.closeSubpath()
            }
            .fill(gradient(.orange.opacity(0.5), .init(red: 0.6, green: 0.3, blue: 0.1)))
            .frame(width: 30, height: 4).offset(y: -10)
        }
        .frame(width: 30, height: 16)
    }

    private var fountainShape: some View {
        ZStack(alignment: .bottom) {
            // Basin
            Path { p in
                p.move(to: CGPoint(x: 2, y: 0))
                p.addLine(to: CGPoint(x: 0, y: 8))
                p.addLine(to: CGPoint(x: 22, y: 8))
                p.addLine(to: CGPoint(x: 20, y: 0))
                p.closeSubpath()
            }
            .fill(gradient(.init(white: 0.55), .init(white: 0.4)))
            .frame(width: 22, height: 8)
            // Spout
            Rectangle().fill(Color(white: 0.5)).frame(width: 2, height: 10).offset(y: -8)
            Circle().fill(Color.cyan.opacity(0.4)).frame(width: 6, height: 6).offset(y: -14)
        }
        .frame(width: 22, height: 22)
    }

    private var gymShape: some View {
        ZStack(alignment: .bottom) {
            RoundedRectangle(cornerRadius: 2).fill(gradient(.init(white: 0.5), .init(white: 0.35))).frame(width: 20, height: 14)
            Rectangle().fill(Color.orange.opacity(0.3)).frame(width: 12, height: 3).offset(y: -8)
        }
        .frame(width: 20, height: 16)
    }

    private var cafeShape: some View {
        ZStack(alignment: .bottom) {
            Rectangle().fill(gradient(.init(red: 0.5, green: 0.35, blue: 0.2), .init(red: 0.35, green: 0.22, blue: 0.1))).frame(width: 16, height: 12)
            halfDome(width: 10, height: 5, color1: .orange.opacity(0.4), color2: .init(red: 0.4, green: 0.25, blue: 0.1))
                .offset(y: -12)
        }
        .frame(width: 16, height: 20)
    }

    private var gardenShape: some View {
        HStack(spacing: 2) {
            ForEach(0..<4, id: \.self) { i in
                VStack(spacing: 0) {
                    Circle().fill(Color.green.opacity(0.5)).frame(width: 5, height: 5)
                    Rectangle().fill(Color.green.opacity(0.3)).frame(width: 1, height: CGFloat(3 + i))
                }
            }
        }
        .frame(width: 24, height: 14)
    }

    private var townHallShape: some View {
        ZStack(alignment: .bottom) {
            Rectangle().fill(gradient(.init(white: 0.6), .init(white: 0.42))).frame(width: 24, height: 18)
            // Columns
            HStack(spacing: 6) {
                ForEach(0..<3, id: \.self) { _ in
                    Rectangle().fill(Color(white: 0.7)).frame(width: 2, height: 12)
                }
            }.offset(y: -2)
            Path { p in
                p.move(to: CGPoint(x: 0, y: 5))
                p.addLine(to: CGPoint(x: 14, y: 0))
                p.addLine(to: CGPoint(x: 28, y: 5))
                p.closeSubpath()
            }
            .fill(gradient(.init(white: 0.65), .init(white: 0.45)))
            .frame(width: 28, height: 5).offset(y: -18)
        }
        .frame(width: 28, height: 26)
    }

    // MARK: - Zone 6: Power Grid

    private var reactorShape: some View {
        ZStack(alignment: .bottom) {
            RoundedRectangle(cornerRadius: 4)
                .fill(gradient(.init(red: 0.3, green: 0.5, blue: 0.3), .init(red: 0.2, green: 0.35, blue: 0.2)))
                .frame(width: 18, height: 20)
            Circle().fill(unlocked ? Color.yellow.opacity(0.5) : Color(white: 0.2)).frame(width: 8, height: 8).offset(y: -8)
        }
        .frame(width: 18, height: 22)
    }

    private var turbineShape: some View {
        ZStack(alignment: .bottom) {
            Rectangle().fill(Color(white: 0.5)).frame(width: 3, height: 20)
            // Blades
            ForEach(0..<3, id: \.self) { i in
                Capsule().fill(Color(white: 0.65)).frame(width: 3, height: 10)
                    .offset(y: -5)
                    .rotationEffect(.degrees(Double(i) * 120))
                    .offset(y: -18)
            }
        }
        .frame(width: 22, height: 30)
    }

    private var batteryShape: some View {
        ZStack(alignment: .bottom) {
            RoundedRectangle(cornerRadius: 3)
                .fill(gradient(.init(white: 0.5), .init(white: 0.35)))
                .frame(width: 14, height: 18)
            Rectangle().fill(Color.green.opacity(0.4)).frame(width: 8, height: 10).offset(y: -2)
        }
        .frame(width: 14, height: 20)
    }

    private var transformerShape: some View {
        ZStack(alignment: .bottom) {
            Rectangle().fill(gradient(.init(white: 0.5), .init(white: 0.35))).frame(width: 16, height: 14)
            Circle().fill(Color.yellow.opacity(0.3)).frame(width: 8, height: 8).offset(y: -6)
        }
        .frame(width: 16, height: 16)
    }

    private var coolingTowerShape: some View {
        ZStack(alignment: .bottom) {
            Path { p in
                p.move(to: CGPoint(x: 3, y: 24))
                p.addQuadCurve(to: CGPoint(x: 5, y: 12), control: CGPoint(x: 0, y: 18))
                p.addQuadCurve(to: CGPoint(x: 3, y: 0), control: CGPoint(x: 3, y: 6))
                p.addLine(to: CGPoint(x: 17, y: 0))
                p.addQuadCurve(to: CGPoint(x: 15, y: 12), control: CGPoint(x: 17, y: 6))
                p.addQuadCurve(to: CGPoint(x: 17, y: 24), control: CGPoint(x: 20, y: 18))
                p.closeSubpath()
            }
            .fill(gradient(.init(white: 0.6), .init(white: 0.4)))
            .frame(width: 20, height: 24)
        }
        .frame(width: 20, height: 26)
    }

    private var solarFarmShape: some View {
        HStack(spacing: 2) {
            ForEach(0..<3, id: \.self) { _ in
                VStack(spacing: 0) {
                    Rectangle().fill(gradient(.blue.opacity(0.6), .init(red: 0.15, green: 0.2, blue: 0.5))).frame(width: 7, height: 5).rotationEffect(.degrees(-15))
                    Rectangle().fill(Color(white: 0.45)).frame(width: 1, height: 6)
                }
            }
        }
        .frame(width: 28, height: 16)
    }

    private var powerLineShape: some View {
        ZStack(alignment: .bottom) {
            Rectangle().fill(Color(white: 0.5)).frame(width: 2, height: 22)
            Rectangle().fill(Color(white: 0.55)).frame(width: 16, height: 2).offset(y: -20)
        }
        .frame(width: 18, height: 24)
    }

    private var switchyardShape: some View {
        ZStack(alignment: .bottom) {
            Rectangle().fill(gradient(.init(white: 0.45), .init(white: 0.3))).frame(width: 24, height: 8)
            HStack(spacing: 4) {
                ForEach(0..<3, id: \.self) { _ in
                    Rectangle().fill(Color(white: 0.55)).frame(width: 2, height: 12)
                }
            }.offset(y: -8)
        }
        .frame(width: 24, height: 22)
    }

    private var capacitorShape: some View {
        RoundedRectangle(cornerRadius: 4)
            .fill(gradient(.init(red: 0.3, green: 0.3, blue: 0.5), .init(red: 0.2, green: 0.2, blue: 0.35)))
            .frame(width: 12, height: 18)
    }

    private var fusionCoreShape: some View {
        ZStack {
            Circle()
                .fill(gradient(.init(red: 0.4, green: 0.6, blue: 0.9), .init(red: 0.2, green: 0.3, blue: 0.6)))
                .frame(width: 22, height: 22)
            Circle()
                .fill(unlocked ? Color.cyan.opacity(0.5) : Color(white: 0.2))
                .frame(width: 10, height: 10)
        }
        .frame(width: 22, height: 24)
    }

    // MARK: - Zone 7: Terraforming Station

    private var atmoProcessorShape: some View {
        ZStack(alignment: .bottom) {
            RoundedRectangle(cornerRadius: 3)
                .fill(gradient(.init(red: 0.3, green: 0.5, blue: 0.5), .init(red: 0.2, green: 0.35, blue: 0.35)))
                .frame(width: 20, height: 18)
            Rectangle().fill(Color(white: 0.5)).frame(width: 6, height: 8).offset(y: -18)
        }
        .frame(width: 20, height: 28)
    }

    private var gasCollectorShape: some View {
        ZStack(alignment: .bottom) {
            halfDome(width: 18, height: 14, color1: .init(red: 0.5, green: 0.7, blue: 0.7), color2: .init(red: 0.25, green: 0.4, blue: 0.4))
            Rectangle().fill(Color(white: 0.45)).frame(width: 3, height: 8).offset(y: -14)
        }
        .frame(width: 18, height: 24)
    }

    private var heaterShape: some View {
        ZStack(alignment: .bottom) {
            RoundedRectangle(cornerRadius: 2)
                .fill(gradient(.init(red: 0.6, green: 0.3, blue: 0.2), .init(red: 0.4, green: 0.2, blue: 0.1)))
                .frame(width: 16, height: 16)
            Circle().fill(unlocked ? Color.orange.opacity(0.5) : Color(white: 0.2)).frame(width: 8, height: 8).offset(y: -6)
        }
        .frame(width: 16, height: 18)
    }

    private var condenserShape: some View {
        RoundedRectangle(cornerRadius: 5)
            .fill(gradient(.cyan.opacity(0.4), .init(red: 0.15, green: 0.3, blue: 0.4)))
            .frame(width: 16, height: 20)
    }

    private var ventStackShape: some View {
        ZStack(alignment: .bottom) {
            Rectangle().fill(gradient(.init(white: 0.55), .init(white: 0.38))).frame(width: 8, height: 24)
            Circle().fill(Color(white: 0.3)).frame(width: 10, height: 4).offset(y: -24)
        }
        .frame(width: 12, height: 28)
    }

    private var cloudSeederShape: some View {
        ZStack(alignment: .bottom) {
            Rectangle().fill(Color(white: 0.5)).frame(width: 2, height: 18)
            halfDome(width: 14, height: 8, color1: .init(white: 0.7), color2: .init(white: 0.45))
                .rotationEffect(.degrees(180))
                .offset(y: -22)
        }
        .frame(width: 16, height: 30)
    }

    private var filterBankShape: some View {
        HStack(spacing: 2) {
            ForEach(0..<3, id: \.self) { _ in
                RoundedRectangle(cornerRadius: 2)
                    .fill(gradient(.init(white: 0.5), .init(white: 0.35)))
                    .frame(width: 6, height: 16)
            }
        }
        .frame(width: 24, height: 18)
    }

    private var pumpStationShape: some View {
        ZStack(alignment: .bottom) {
            Rectangle().fill(gradient(.init(white: 0.5), .init(white: 0.35))).frame(width: 20, height: 12)
            Circle().fill(Color.cyan.opacity(0.3)).frame(width: 10, height: 10).offset(y: -8)
        }
        .frame(width: 20, height: 18)
    }

    private var thermalPipeShape: some View {
        ZStack(alignment: .bottom) {
            Capsule().fill(gradient(.orange.opacity(0.4), .init(red: 0.4, green: 0.2, blue: 0.1))).frame(width: 8, height: 22)
            Capsule().fill(Color.orange.opacity(0.2)).frame(width: 4, height: 22)
        }
        .frame(width: 10, height: 24)
    }

    private var weatherDomeShape: some View {
        halfDome(width: 24, height: 18, color1: .init(red: 0.4, green: 0.6, blue: 0.7), color2: .init(red: 0.2, green: 0.35, blue: 0.4))
            .frame(width: 24, height: 20)
    }

    // MARK: - Zone 8: Cultural Center

    private var amphitheaterShape: some View {
        ZStack(alignment: .bottom) {
            Path { p in
                p.move(to: CGPoint(x: 0, y: 0))
                p.addLine(to: CGPoint(x: 4, y: 10))
                p.addLine(to: CGPoint(x: 24, y: 10))
                p.addLine(to: CGPoint(x: 28, y: 0))
                p.closeSubpath()
            }
            .fill(gradient(.init(white: 0.55), .init(white: 0.38)))
            .frame(width: 28, height: 10)
        }
        .frame(width: 28, height: 12)
    }

    private var statueShape: some View {
        ZStack(alignment: .bottom) {
            Rectangle().fill(Color(white: 0.5)).frame(width: 12, height: 5)
            // Figure
            VStack(spacing: 0) {
                Circle().fill(Color(white: 0.65)).frame(width: 6, height: 6)
                Rectangle().fill(Color(white: 0.6)).frame(width: 4, height: 12)
            }.offset(y: -5)
        }
        .frame(width: 14, height: 26)
    }

    private var galleryShape: some View {
        ZStack(alignment: .bottom) {
            Rectangle().fill(gradient(.init(white: 0.6), .init(white: 0.42))).frame(width: 24, height: 14)
            HStack(spacing: 3) {
                ForEach(0..<3, id: \.self) { i in
                    Rectangle().fill(Color(hue: Double(i) * 0.3, saturation: 0.4, brightness: 0.6)).frame(width: 4, height: 4).offset(y: -6)
                }
            }
        }
        .frame(width: 24, height: 16)
    }

    private var musicHallShape: some View {
        ZStack(alignment: .bottom) {
            Rectangle().fill(gradient(.init(red: 0.5, green: 0.35, blue: 0.45), .init(red: 0.35, green: 0.2, blue: 0.3))).frame(width: 22, height: 16)
            halfDome(width: 22, height: 8, color1: .init(red: 0.6, green: 0.4, blue: 0.55), color2: .init(red: 0.4, green: 0.25, blue: 0.35))
                .offset(y: -16)
        }
        .frame(width: 22, height: 26)
    }

    private var cinemaShape: some View {
        ZStack(alignment: .bottom) {
            Rectangle().fill(gradient(.init(white: 0.45), .init(white: 0.3))).frame(width: 22, height: 16)
            Rectangle().fill(Color.white.opacity(0.15)).frame(width: 14, height: 8).offset(y: -5)
        }
        .frame(width: 22, height: 18)
    }

    private var monumentShape: some View {
        ZStack(alignment: .bottom) {
            Rectangle().fill(Color(white: 0.5)).frame(width: 14, height: 4)
            Path { p in
                p.move(to: CGPoint(x: 3, y: 20))
                p.addLine(to: CGPoint(x: 7, y: 0))
                p.addLine(to: CGPoint(x: 11, y: 20))
                p.closeSubpath()
            }
            .fill(gradient(.init(white: 0.7), .init(white: 0.45)))
            .frame(width: 14, height: 20).offset(y: -4)
        }
        .frame(width: 14, height: 26)
    }

    private var archwayShape: some View {
        ZStack(alignment: .bottom) {
            // Pillars
            HStack(spacing: 14) {
                Rectangle().fill(Color(white: 0.55)).frame(width: 3, height: 18)
                Rectangle().fill(Color(white: 0.55)).frame(width: 3, height: 18)
            }
            // Arch top
            halfDome(width: 20, height: 6, color1: .init(white: 0.6), color2: .init(white: 0.42))
                .offset(y: -18)
        }
        .frame(width: 22, height: 26)
    }

    private var bellTowerShape: some View {
        ZStack(alignment: .bottom) {
            Rectangle().fill(gradient(.init(white: 0.55), .init(white: 0.38))).frame(width: 10, height: 24)
            halfDome(width: 14, height: 6, color1: .init(white: 0.65), color2: .init(white: 0.45))
                .offset(y: -24)
            Circle().fill(unlocked ? Color.yellow.opacity(0.5) : Color(white: 0.25)).frame(width: 4, height: 4).offset(y: -20)
        }
        .frame(width: 14, height: 32)
    }

    private var muralShape: some View {
        ZStack {
            Rectangle().fill(gradient(.init(white: 0.5), .init(white: 0.35))).frame(width: 24, height: 16)
            // Colorful patches
            HStack(spacing: 1) {
                ForEach(0..<5, id: \.self) { i in
                    Rectangle().fill(Color(hue: Double(i) * 0.2, saturation: 0.5, brightness: 0.5)).frame(width: 4, height: 10)
                }
            }
        }
        .frame(width: 24, height: 18)
    }

    private var plazaShape: some View {
        ZStack(alignment: .bottom) {
            RoundedRectangle(cornerRadius: 2)
                .fill(gradient(.init(white: 0.45), .init(white: 0.32)))
                .frame(width: 28, height: 6)
            Circle().fill(Color(white: 0.5)).frame(width: 8, height: 8).offset(y: -6)
        }
        .frame(width: 28, height: 16)
    }

    // MARK: - Zone 9: Capital City

    private var capitolShape: some View {
        ZStack(alignment: .bottom) {
            Rectangle().fill(gradient(.init(white: 0.65), .init(white: 0.45))).frame(width: 26, height: 18)
            halfDome(width: 14, height: 10, color1: .init(red: 0.8, green: 0.7, blue: 0.3), color2: .init(red: 0.6, green: 0.5, blue: 0.2))
                .offset(y: -18)
            HStack(spacing: 5) {
                ForEach(0..<4, id: \.self) { _ in
                    Rectangle().fill(Color(white: 0.7)).frame(width: 2, height: 14)
                }
            }.offset(y: -1)
        }
        .frame(width: 26, height: 30)
    }

    private var embassyShape: some View {
        ZStack(alignment: .bottom) {
            Rectangle().fill(gradient(.init(white: 0.6), .init(white: 0.42))).frame(width: 22, height: 16)
            Rectangle().fill(Color(white: 0.65)).frame(width: 22, height: 3).offset(y: -16)
        }
        .frame(width: 22, height: 20)
    }

    private var vaultShape: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 4)
                .fill(gradient(.init(white: 0.5), .init(white: 0.32)))
                .frame(width: 18, height: 16)
            Circle().fill(Color(white: 0.4)).frame(width: 8, height: 8)
        }
        .frame(width: 18, height: 18)
    }

    private var courthouseShape: some View {
        ZStack(alignment: .bottom) {
            Rectangle().fill(gradient(.init(white: 0.6), .init(white: 0.42))).frame(width: 24, height: 16)
            Path { p in
                p.move(to: CGPoint(x: 0, y: 5))
                p.addLine(to: CGPoint(x: 14, y: 0))
                p.addLine(to: CGPoint(x: 28, y: 5))
                p.closeSubpath()
            }
            .fill(gradient(.init(white: 0.65), .init(white: 0.45)))
            .frame(width: 28, height: 5).offset(y: -16)
        }
        .frame(width: 28, height: 24)
    }

    private var grandMonumentShape: some View {
        ZStack(alignment: .bottom) {
            Rectangle().fill(Color(white: 0.5)).frame(width: 18, height: 5)
            Path { p in
                p.move(to: CGPoint(x: 2, y: 28))
                p.addLine(to: CGPoint(x: 8, y: 0))
                p.addLine(to: CGPoint(x: 14, y: 28))
                p.closeSubpath()
            }
            .fill(gradient(.init(red: 0.8, green: 0.7, blue: 0.3), .init(red: 0.6, green: 0.5, blue: 0.2)))
            .frame(width: 16, height: 28).offset(y: -5)
        }
        .frame(width: 18, height: 36)
    }

    private var clockTowerShape: some View {
        ZStack(alignment: .bottom) {
            Rectangle().fill(gradient(.init(white: 0.55), .init(white: 0.38))).frame(width: 12, height: 28)
            Circle().fill(Color(white: 0.7)).frame(width: 8, height: 8).offset(y: -22)
            Path { p in
                p.move(to: CGPoint(x: 0, y: 5))
                p.addLine(to: CGPoint(x: 8, y: 0))
                p.addLine(to: CGPoint(x: 16, y: 5))
                p.closeSubpath()
            }
            .fill(gradient(.init(white: 0.6), .init(white: 0.42)))
            .frame(width: 16, height: 5).offset(y: -28)
        }
        .frame(width: 16, height: 36)
    }

    private var senateShape: some View {
        ZStack(alignment: .bottom) {
            Rectangle().fill(gradient(.init(white: 0.6), .init(white: 0.42))).frame(width: 26, height: 16)
            HStack(spacing: 4) {
                ForEach(0..<5, id: \.self) { _ in
                    Rectangle().fill(Color(white: 0.7)).frame(width: 2, height: 12)
                }
            }.offset(y: -1)
        }
        .frame(width: 26, height: 18)
    }

    private var treasuryShape: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 2)
                .fill(gradient(.init(red: 0.6, green: 0.5, blue: 0.2), .init(red: 0.4, green: 0.33, blue: 0.12)))
                .frame(width: 20, height: 16)
            Rectangle().fill(Color(white: 0.5)).frame(width: 2, height: 10)
            Rectangle().fill(Color(white: 0.5)).frame(width: 10, height: 2)
        }
        .frame(width: 20, height: 18)
    }

    private var spireShape: some View {
        ZStack(alignment: .bottom) {
            Rectangle().fill(gradient(.init(white: 0.55), .init(white: 0.38))).frame(width: 6, height: 22)
            Path { p in
                p.move(to: CGPoint(x: 0, y: 10))
                p.addLine(to: CGPoint(x: 5, y: 0))
                p.addLine(to: CGPoint(x: 10, y: 10))
                p.closeSubpath()
            }
            .fill(gradient(.init(red: 0.8, green: 0.7, blue: 0.3), .init(red: 0.6, green: 0.5, blue: 0.2)))
            .frame(width: 10, height: 10).offset(y: -22)
        }
        .frame(width: 10, height: 34)
    }

    private var obeliskShape: some View {
        ZStack(alignment: .bottom) {
            Rectangle().fill(Color(white: 0.5)).frame(width: 16, height: 4)
            Path { p in
                p.move(to: CGPoint(x: 2, y: 32))
                p.addLine(to: CGPoint(x: 5, y: 0))
                p.addLine(to: CGPoint(x: 8, y: 0))
                p.addLine(to: CGPoint(x: 11, y: 32))
                p.closeSubpath()
            }
            .fill(gradient(.init(white: 0.7), .init(white: 0.45)))
            .frame(width: 13, height: 32).offset(y: -4)
        }
        .frame(width: 16, height: 38)
    }

    // MARK: - Helpers

    private func gradient(_ c1: Color, _ c2: Color) -> LinearGradient {
        LinearGradient(colors: [c1, c2], startPoint: .top, endPoint: .bottom)
    }

    private func halfDome(width: CGFloat, height: CGFloat, color1: Color, color2: Color) -> some View {
        Path { p in
            p.move(to: CGPoint(x: 0, y: height))
            p.addQuadCurve(
                to: CGPoint(x: width, y: height),
                control: CGPoint(x: width / 2, y: -height * 0.3)
            )
            p.closeSubpath()
        }
        .fill(LinearGradient(colors: [color1, color2], startPoint: .top, endPoint: .bottom))
        .frame(width: width, height: height)
    }
}
