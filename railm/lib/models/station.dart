class Station {
    String id;
    String name;
    String route;
    int position;

    Station(this.id, this.name, this.route, this.position);

    factory Station.fromJson(Map<String, dynamic> json) {
        return Station(
            json["id"],
            json["name"],
            json["route"],
            json["position"],
        );
    }
}
