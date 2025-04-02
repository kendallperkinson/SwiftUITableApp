//
//  ContentView.swift
//  TableSwiftUI
//
//  Created by Perkinson, Kendall on 3/31/25.
//

import SwiftUI
import MapKit

let data = [
    Item(name: "Back The Bobcats Block Party", location: "San Marcos", date: "8/30/24", desc: "The second annual Back The Bobcats Block Party at Zelicks to celebrate back to school season. Included live music, food & spirit rally with the TXST Strutters & Football team as well as special appearances from the college president & mascot. This event was so special to work for as it combined my love for my school in San Marcos & love for Topo Chico!", lat: 29.884674, long: -97.940186, imageName: "event1"),
    Item(name:"Vibe Artisan Market", location: "Distribution Hall, Austin", date: "7/24/24", desc: "A 2-day market at the Austin Distribution Hall showcasing 100+ exhibitors & creatives. Complimentary Sabores flavors were handed out to guests as they experienced the art gallery installations, music creators & live demo pop ups. Over 180 cases of Sabores were used at this event!", lat: 30.267153, long: -97.742771, imageName: "event2"),
    Item(name: "Urban Roots: Tour de Farm", location: "Meanwhile Brewing, Austin", date: "8/15/24", desc: "Urban Roots works with youth leaders to grow fresh food and build a community dedicated to achieving food equity. This was a farm-to-table experience supporting youth leadership and sustainable agriculture and I am so thankful to have been apart of showcasing this organization and their amazing work! ", lat: 30.281581, long: -97.7079799, imageName: "event3"),
    Item(name: "CultureMaps Tastemakers Awards", location: "The Espee, San Antonio", date: "4/26/22", desc: "An annual event celebrating top culinary talent, I met so many amazing chefs and ate delicious food, with Topo Chico to help cleanse my palette after every sample! Different awards were given out during the ceremony, such as Chef of the Year and Restaurant of the Year, and I was so honored to be apart of it. ", lat: 29.428434, long: -98.497522, imageName: "event4"),
    Item(name: "Flamin Hot Market", location: "Feliz Modern, San Antonio", date: "2/11/23", desc: "A fiery market event showcasing spicy eats, unique vendors, and Topo Chico. This market was filled with Hot Cheeto themed merchandise from earrings to hoodies, along with a stand selling the TikTok viral Hot Cheeto Pickle snack.", lat: 29.422177, long: -98.484222, imageName: "event5"),
    Item(name: "Luck Reunion: 10th Anniversary", location: "Luck Ranch, Austin", date: "3/18/22", desc: "A legendary festival featuring live music, food, and Topo Chico. The 10th anniversay celebration during SXSW was such an awesome experience to have seen live music performances from Willie Nelson, Chuck Prophet, Lucero, and Weyes Blood. There was a lot of people out of town visiting Luck, so it was so nice meeting everyone and making sure everyone was hydrated!", lat: 30.304890, long: -97.726220, imageName: "event6"),
    Item(name: "South Congress Thrift Market", location: "South Congress, Austin", date: "9/28/24", desc: "A curated thrift market with local vendors and Topo Chico. This is Austin's largest creator market with over 200 vendors creators artisans vintage curators all along South Congress. These events are always a hit and we normally sell out of our product within the first 2/3 hours!", lat: 30.253750, long: -97.759920, imageName: "event7"),
    Item(name: "Austin Coffee Festival", location: "Palmer Event Center, Austin", date: "9/29/24", desc: "A festival celebrating coffee culture with tastings and showcases the best specialty roasters and coffee shops with unique beans, delicious snacks, and live entertainment. This is definitely a one-of-a-kind coffee culture experience and I loved working it! Our Topo Chico Sabores flavors Blueberry&Hibiscus, Lime&Mint, and Tangerine&Ginger were great palette cleansers and hydrators for the coffee connoisseurs of Austin!", lat: 30.266165, long: -97.770726, imageName: "event8"),
    Item(name: "OMG Squee Lunar Year Festival", location: "OMG Squee Bakery, Austin", date: "2/8/25", desc: "OMG Squee hosted a Lunar New Year celebration and birthday bash, celebrating 5 years of the bakery. This festive celebration featured food and drink pop-ups from Lao'd Bar and Topo Chico, a lion dance, mahjong and many different vendors from jewelry to vintage items. The picture above is a selfie of me and my sweet friend Madden who came to stop by the event and grab a drink! This was such an amazing event to be a part of because I learned so much about the Chinese culture and their traditions for the new year. 2025 is the Year of the Snake, which is a year of growth and development and a time to 'shed the past' or what no longer serves you. I am so happy I got to ring in the New Year with a crisp Topo and be able to share one with others on the hottest day of February!", lat: 30.301228, long: -97.698905, imageName: "event9")
]

struct Item: Identifiable {
    let id = UUID()
    let name: String
    let location: String
    let date: String
    let desc: String
    let lat: Double
    let long: Double
    let imageName: String
}

struct ContentView: View {
    
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 30.295190, longitude: -97.726220), span: MKCoordinateSpan(latitudeDelta: 0.07, longitudeDelta: 0.07))
    
    @State private var selectedLocation: String = "All Locations"
    let locations = ["All Locations", "Austin", "San Antonio", "San Marcos"]
    var filteredData: [Item] {
        if selectedLocation == "All Locations" {
            return data
        } else {
            return data.filter { $0.location.contains(selectedLocation) }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Picker("Filter by Location", selection: $selectedLocation) {
                    ForEach(locations, id: \.self) { location in
                        Text(location).tag(location)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
             
                List(filteredData, id: \.name) { item in
                    NavigationLink(destination: DetailView(item: item)) {
                        HStack {
                            Image(item.imageName)
                                .resizable()
                                .frame(width: 50, height: 50)
                                .cornerRadius(10)
                            
                            VStack(alignment: .leading) {
                                Text(item.name)
                                    .font(.headline)
                                Text(item.date)
                                    .font(.subheadline)
                            }
                        }
                    }
                }
                .listStyle(PlainListStyle())
                
            
                Map(coordinateRegion: $region, annotationItems: filteredData) { item in
                    MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: item.lat, longitude: item.long)) {
                        Image(systemName: "mappin.circle.fill")
                            .foregroundColor(.red)
                            .font(.title)
                            .overlay(
                                Text(item.name)
                                    .font(.subheadline)
                                    .foregroundColor(.black)
                                    .fixedSize(horizontal: true, vertical: false)
                                    .offset(y: 25)
                            )
                    }
                }
                .frame(height: 300)
                .padding(.bottom, -30)
            }
            .navigationTitle("Topo Chico Events")
        }
    }
}


struct DetailView: View {
    @State private var region: MKCoordinateRegion
    
    init(item: Item) {
        self.item = item
        _region = State(initialValue: MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: item.lat, longitude: item.long), span: MKCoordinateSpan(latitudeDelta: 0.20, longitudeDelta: 0.20)))
    }
    
    let item: Item
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                
             
                Image(item.imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 250)
                    .clipped()
                    .cornerRadius(15)
                    .shadow(radius: 10)
                    .padding([.top, .horizontal])
                
         
                Text(item.name)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.horizontal)
                
          
                HStack {
                    Text("Location: \(item.location)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Spacer()
                    Text("Date: \(item.date)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding([.horizontal, .top])
                
         
                Text(item.desc)
                    .font(.body)
                    .padding([.horizontal, .bottom])
                    .foregroundColor(.primary)
                
        
                VStack {
                    Text("Event Location")
                        .font(.headline)
                        .padding([.horizontal, .top])
                    
                    Map(coordinateRegion: $region, annotationItems: [item]) { item in
                        MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: item.lat, longitude: item.long)) {
                            Image(systemName: "mappin.circle.fill")
                                .foregroundColor(.red)
                                .font(.title)
                                .overlay(
                                    Text(item.name)
                                        .font(.subheadline)
                                        .foregroundColor(.black)
                                        .fixedSize(horizontal: true, vertical: false)
                                        .offset(y: 25)
                                )
                        }
                    }
                    .frame(height: 300)
                    .cornerRadius(15)
                    .shadow(radius: 10)
                    .padding(.horizontal)
                }
            }
            .background(Color.yellow)
            .cornerRadius(15)
            .shadow(radius: 10)
            .padding()
        }
        .navigationTitle(item.name)
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(UIColor.systemGray6))
    }
}


#Preview {
    ContentView()
}
