//
//  PlacemarkView.swift
//  SpoonFW
//
//  Created by Jan Löffel on 11.10.22.
//

import SwiftUI
import MapKit
public struct PlacemarkView: View {
    @Binding var latitude: Double
    @Binding var longitude: Double
    @Binding var locationName: String
    
    @ObservedObject var geoController: GeoController
    @State private var mapRegion: MKCoordinateRegion = MKCoordinateRegion()
    @State private var annotations: [LocationAnnotation] = []
    
    public init(latitude: Binding<Double>, longitude: Binding<Double>, locationName: Binding<String>, geoController: GeoController) {
        self._latitude = latitude
        self._longitude = longitude
        self._locationName = locationName
        self.geoController = geoController
    }
    
    public var body: some View {
        List {
            Section {
                Label {
                    Text(LocalizedStringKey("PlacemarkViewTitle"))
                    Spacer()
                    Text(locationName)
                } icon: {
                    Image(systemName: "mappin.square")
                }
                
                GeometryReader(content: { proxy in
                    Map(coordinateRegion: $mapRegion, annotationItems: annotations, annotationContent: { annotation in
                        MapMarker(coordinate: annotation.coordinate)
                    })
                    .onTapGesture { location in
                        let generator = UIImpactFeedbackGenerator(style: .light)
                        let newCoordinates = GeoController.convertTap(at: location, for: proxy.size, in: mapRegion)
                        longitude = newCoordinates.longitude
                        latitude = newCoordinates.latitude
                        withAnimation {
                            mapRegion.center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                        }
                        annotations = [LocationAnnotation(coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), title: locationName)]
                        geoController.lookUpLocation(location: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), completionHandler: { placemark in
                            self.locationName = placemark?.name ?? ""
                        })
                        generator.impactOccurred()
                    }
                    .onLongPressGesture {
                        let generator = UINotificationFeedbackGenerator()
                        longitude = geoController.location?.coordinate.longitude ?? 0
                        latitude = geoController.location?.coordinate.latitude ?? 0
                        withAnimation {
                            mapRegion.center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                        }
                        annotations = [LocationAnnotation(coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), title: locationName)]
                        geoController.lookUpLocation(location: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), completionHandler: { placemark in
                            self.locationName = placemark?.name ?? ""
                        })
                        generator.notificationOccurred(.success)
                    }
                })
                .frame(minHeight: 300)
                .padding(.vertical)
            } footer: {
                Label(LocalizedStringKey("PlacemarkViewFooter"), systemImage: "info.circle")
            }
            
        }
        .onAppear {
            mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), latitudinalMeters: 500, longitudinalMeters: 500)
            annotations = [LocationAnnotation(coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), title: locationName)]
        }
    }
}

struct PlacemarkView_Previews: PreviewProvider {
    static var previews: some View {
        PlacemarkView(latitude: .constant(0), longitude: .constant(0), locationName: .constant("PlacemarkName"), geoController: GeoController())
    }
}

