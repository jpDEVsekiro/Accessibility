/*
// Example Usage
Map<String, dynamic> map = jsonDecode(<myJSONString>);
var myRootNode = Root.fromJson(map);
*/
class Geometry {
  Location? location;
  Viewport? viewport;

  Geometry({this.location, this.viewport});

  Geometry.fromJson(Map<String, dynamic> json) {
    location = json['location'] != null ? Location?.fromJson(json['location']) : null;
    viewport = json['viewport'] != null ? Viewport?.fromJson(json['viewport']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['location'] = location!.toJson();
    data['viewport'] = viewport!.toJson();
    return data;
  }
}

class Location {
  double? lat;
  double? lng;

  Location({this.lat, this.lng});

  Location.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    lng = json['lng'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['lat'] = lat;
    data['lng'] = lng;
    return data;
  }
}

class Northeast {
  double? lat;
  double? lng;

  Northeast({this.lat, this.lng});

  Northeast.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    lng = json['lng'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['lat'] = lat;
    data['lng'] = lng;
    return data;
  }
}

class Photo {
  int? height;
  String? photoreference;
  int? width;

  Photo({this.height, this.photoreference, this.width});

  Photo.fromJson(Map<String, dynamic> json) {
    height = json['height'];
    photoreference = json['photo_reference'];
    width = json['width'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['height'] = height;
    data['photo_reference'] = photoreference;
    data['width'] = width;
    return data;
  }
}

class PlusCode {
  String? compoundcode;
  String? globalcode;

  PlusCode({this.compoundcode, this.globalcode});

  PlusCode.fromJson(Map<String, dynamic> json) {
    compoundcode = json['compound_code'];
    globalcode = json['global_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['compound_code'] = compoundcode;
    data['global_code'] = globalcode;
    return data;
  }
}

class Place {
  String? businessstatus;
  Geometry? geometry;
  String? icon;
  String? iconbackgroundcolor;
  String? iconmaskbaseuri;
  String? name;
  List<Photo?>? photos;
  String? placeid;
  PlusCode? pluscode;
  double? rating;
  String? reference;
  String? scope;
  int? userratingstotal;
  String? vicinity;
  String? website;
  String? internationalPhoneNumber;

  Place({
    this.businessstatus,
    this.geometry,
    this.icon,
    this.iconbackgroundcolor,
    this.iconmaskbaseuri,
    this.name,
    this.photos,
    this.placeid,
    this.pluscode,
    this.rating,
    this.reference,
    this.scope,
    this.userratingstotal,
    this.vicinity,
    this.website,
    this.internationalPhoneNumber,
  });

  List<Place> fromListJson(List json) {
    List<Place> places = [];
    for (var item in json) {
      places.add(Place.fromJson(item));
    }
    return places;
  }

  Place.fromJson(Map<String, dynamic> json) {
    businessstatus = json['business_status'];
    geometry = json['geometry'] != null ? Geometry?.fromJson(json['geometry']) : null;
    icon = json['icon'];
    iconbackgroundcolor = json['icon_background_color'];
    iconmaskbaseuri = json['icon_mask_base_uri'];
    name = json['name'];
    if (json['photos'] != null) {
      photos = <Photo>[];
      json['photos'].forEach((v) {
        photos!.add(Photo.fromJson(v));
      });
    } else {
      photos = [];
    }
    placeid = json['place_id'];
    pluscode = json['plus_code'] != null ? PlusCode?.fromJson(json['plus_code']) : null;
    rating = json['rating']?.toDouble();
    reference = json['reference'];
    scope = json['scope'];
    userratingstotal = json['user_ratings_total'];
    vicinity = json['vicinity'];
    website = json['website'];
    internationalPhoneNumber = json['international_phone_number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['business_status'] = businessstatus;
    data['geometry'] = geometry!.toJson();
    data['icon'] = icon;
    data['icon_background_color'] = iconbackgroundcolor;
    data['icon_mask_base_uri'] = iconmaskbaseuri;
    data['name'] = name;
    data['photos'] = photos != null ? photos!.map((v) => v?.toJson()).toList() : null;
    data['place_id'] = placeid;
    data['plus_code'] = pluscode!.toJson();
    data['rating'] = rating;
    data['reference'] = reference;
    data['scope'] = scope;
    data['user_ratings_total'] = userratingstotal;
    data['vicinity'] = vicinity;
    data['international_phone_number'] = internationalPhoneNumber;
    return data;
  }
}

class Southwest {
  double? lat;
  double? lng;

  Southwest({this.lat, this.lng});

  Southwest.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    lng = json['lng'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['lat'] = lat;
    data['lng'] = lng;
    return data;
  }
}

class Viewport {
  Northeast? northeast;
  Southwest? southwest;

  Viewport({this.northeast, this.southwest});

  Viewport.fromJson(Map<String, dynamic> json) {
    northeast = json['northeast'] != null ? Northeast?.fromJson(json['northeast']) : null;
    southwest = json['southwest'] != null ? Southwest?.fromJson(json['southwest']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['northeast'] = northeast!.toJson();
    data['southwest'] = southwest!.toJson();
    return data;
  }
}
