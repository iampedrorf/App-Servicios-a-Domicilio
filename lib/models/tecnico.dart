class ServicioTecnicoModel {
  int id;
  String nombreCompleto;
  String? fotografia;

  ServicioTecnicoModel({
    required this.id,
    required this.nombreCompleto,
    this.fotografia,
  });

  // Convert the object to a map for insertion
  Map<String, dynamic> toMap() {
    return {
      'Id': id,
      'NombreCompleto': nombreCompleto,
      'Fotografia': fotografia,
    };
  }

  // Create an instance from a map (JSON)
  factory ServicioTecnicoModel.fromJson(Map<String, dynamic> json) {
    return ServicioTecnicoModel(
      id: json['Id'],
      nombreCompleto: json['NombreCompleto'],
      fotografia: json['Fotografia'],
    );
  }
}

const String ServiciosJson = ''' 
[
  {
    "Id": 1,
    "NombreCompleto": "Juan Pérez",
    "Fotografia": "'assets/l-24mdc-140.png'"
  },
  {
    "Id": 2,
    "NombreCompleto": "Ana Martínez",
    "Fotografia": "'assets/l-24mdc-140.png'"
  },
  {
    "Id": 3,
    "NombreCompleto": "Carlos Gómez",
    "Fotografia": "'assets/l-24mdc-140.png'"
  },
  {
    "Id": 4,
    "NombreCompleto": "Laura Fernández",
    "Fotografia": "'assets/l-24mdc-140.png'"
  },
  {
    "Id": 5,
    "NombreCompleto": "Pedro Rodríguez",
    "Fotografia": "'assets/l-24mdc-140.png'"
  }
]
''';

/*
Image.asset(
parcel.imageUrl ?? 'assets/l-24mdc-140.png',
height: 50,
width: 50,
fit: BoxFit.cover,
),*/
