import 'package:collection/collection.dart';
import '../../../core/models/geospatial/coordinate_utils.dart';
import '../../../core/models/geospatial/road_segment.dart';
import '../../../core/models/geospatial/safety_feature.dart';
import '../../safety/services/safety_intelligence_engine.dart';

class RoadEdge {
  final Coordinate from;
  final Coordinate to;
  final RoadSegment segment;
  
  RoadEdge({
    required this.from,
    required this.to,
    required this.segment,
  });
}

class RoutingEngine {
  final Map<Coordinate, List<RoadEdge>> _graph = {};
  
  void buildGraph(List<RoadSegment> segments) {
    _graph.clear();
    for (final segment in segments) {
      if (segment.geometry.length < 2) continue;
      
      final start = segment.geometry.first;
      final end = segment.geometry.last;
      
      // Assuming bidirectional for simplicity in this baseline
      _addEdge(start, end, segment);
      _addEdge(end, start, segment);
    }
  }
  
  void _addEdge(Coordinate from, Coordinate to, RoadSegment segment) {
    _graph.putIfAbsent(from, () => []).add(RoadEdge(
      from: from,
      to: to,
      segment: segment,
    ));
  }

  /// Finds the fastest route optimizing strictly for travel time
  List<RoadSegment>? findFastestRoute(Coordinate origin, Coordinate destination) {
    return _dijkstra(
      origin: origin,
      destination: destination,
      costFunction: (edge) => (edge.segment.estimatedTravelTimeSeconds ?? 60).toDouble(),
    );
  }
  
  /// Finds the safest route optimizing for a blend of time and safety score
  List<RoadSegment>? findSafestRoute(
    Coordinate origin, 
    Coordinate destination,
    Map<String, SafetyFeature> safetyFeatures, // segment.id -> SafetyFeature
    SafetyIntelligenceEngine safetyEngine,
  ) {
    return _dijkstra(
      origin: origin,
      destination: destination,
      costFunction: (edge) {
        final time = (edge.segment.estimatedTravelTimeSeconds ?? 60).toDouble();
        final feature = safetyFeatures[edge.segment.id];
        
        final riskPenalty = safetyEngine.evaluateSegmentCost(feature);
        return time * riskPenalty;
      },
    );
  }

  List<RoadSegment>? _dijkstra({
    required Coordinate origin,
    required Coordinate destination,
    required double Function(RoadEdge) costFunction,
  }) {
    if (!_graph.containsKey(origin) || !_graph.containsKey(destination)) {
      return null;
    }

    final distances = <Coordinate, double>{};
    final previousEdge = <Coordinate, RoadEdge>{};
    final pq = PriorityQueue<_QueueNode>((a, b) => a.cost.compareTo(b.cost));

    distances[origin] = 0.0;
    pq.add(_QueueNode(origin, 0.0));

    while (pq.isNotEmpty) {
      final current = pq.removeFirst();

      if (current.coordinate == destination) {
        break; // Found the shortest path
      }

      if (current.cost > (distances[current.coordinate] ?? double.infinity)) {
        continue;
      }

      final edges = _graph[current.coordinate] ?? [];
      for (final edge in edges) {
        final newCost = current.cost + costFunction(edge);
        
        if (newCost < (distances[edge.to] ?? double.infinity)) {
          distances[edge.to] = newCost;
          previousEdge[edge.to] = edge;
          pq.add(_QueueNode(edge.to, newCost));
        }
      }
    }

    if (!previousEdge.containsKey(destination)) {
      return null; // No path found
    }

    // Reconstruct path
    final path = <RoadSegment>[];
    Coordinate curr = destination;
    while (curr != origin) {
      final edge = previousEdge[curr]!;
      path.add(edge.segment);
      curr = edge.from;
    }
    
    return path.reversed.toList();
  }
}

class _QueueNode {
  final Coordinate coordinate;
  final double cost;
  
  _QueueNode(this.coordinate, this.cost);
}
