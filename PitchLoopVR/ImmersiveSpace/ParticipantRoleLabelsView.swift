/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
The implementation for floating participant role labels.
*/

import SwiftUI
import RealityKit
import Spatial

struct ParticipantRoleLabelsView: View {
    @Environment(PitchLoopAppModel.self) var appModel
    
    var body: some View {
        RealityView { _ in
            
        } update: { content in
            for player in players {
                guard let pose = player.seatPose else { continue }
                
                let resolvedEntity: Entity
                if let entity = content.entities.first(where: { $0.name == player.labelEntityName }) {
                    resolvedEntity = entity
                } else {
                    guard let role = player.role else { continue }
                    
                    resolvedEntity = labelEntity(for: player.displayName, role: role)
                    resolvedEntity.name = player.labelEntityName
                    content.add(resolvedEntity)
                }
                
                resolvedEntity.position = SIMD3<Float>(pose.scorePosition)
                resolvedEntity.orientation = simd_quatf(pose.rotation)
            }
            
            content.entities.removeAll { entity in
                !players.contains(where: { $0.labelEntityName == entity.name && $0.seatPose != nil })
            }
        }
        .frame(depth: 0)
    }
    
    private var players: [ParticipantModel] {
        Array(appModel.sessionController?.players.values.filter { $0.role != nil } ?? [])
    }
    
    private func labelEntity(for name: String, role: ParticipantModel.Role) -> ModelEntity {
        let text = MeshResource.generateText(
            "\(name)\n\(role.name)",
            extrusionDepth: 0.01,
            font: .systemFont(ofSize: 0.12, weight: .semibold),
            containerFrame: CGRect(x: 0, y: 0, width: 1.4, height: 0.4),
            alignment: .center
        )
        
        return ModelEntity(
            mesh: text,
            materials: [SimpleMaterial(color: UIColor(role.color), isMetallic: false)]
        )
    }
}

private extension Pose3D {
    var scorePosition: Point3D {
        let transform = ProjectiveTransform3D(matrix)
        let forward = (transform * .forward).normalized * 0.65
        let right = (transform * .right).normalized * 0.5
        return position + forward - right
    }
}

private extension ParticipantModel {
    var displayName: String {
        name.isEmpty ? "Guest" : name
    }
    
    var labelEntityName: String {
        "\(id)-\(role?.rawValue ?? "waiting")-\(displayName)"
    }
}
