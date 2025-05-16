import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:async';
import '../services/lugar_service.dart';
import '../models/lugar_model.dart';

class MapaInteractivo extends StatefulWidget {
  const MapaInteractivo({super.key});

  @override
  State<MapaInteractivo> createState() => _MapaInteractivoState();
}

class _MapaInteractivoState extends State<MapaInteractivo> {
  final MapController _mapController = MapController();
  final List<Marker> _markers = [];
  final LugarService _lugarService = LugarService();
  // Coordenadas exactas de Calle Alemania 10, Valencia
  static const double ALEMANIA_LAT = 39.482554;
  static const double ALEMANIA_LON = -0.355268;
  LatLng _currentPosition = LatLng(ALEMANIA_LAT, ALEMANIA_LON);
  Lugar? _selectedLugar;
  Location? _location;
  StreamSubscription<LocationData>? _locationSubscription;

  @override
  void initState() {
    super.initState();
    _cargarLugares();
    _initializeLocation();
  }

  @override
  void dispose() {
    _locationSubscription?.cancel();
    super.dispose();
  }

  Future<void> _initializeLocation() async {
    _location = Location();
    
    // Solicitar permisos de ubicación
    bool serviceEnabled = await _location!.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location!.requestService();
      if (!serviceEnabled) {
        print('Los servicios de ubicación están deshabilitados');
        return;
      }
    }

    PermissionStatus permission = await _location!.hasPermission();
    if (permission == PermissionStatus.denied) {
      permission = await _location!.requestPermission();
      if (permission == PermissionStatus.denied) {
        print('Los permisos de ubicación están denegados');
        return;
      }
    }

    // Obtener ubicación inicial
    await _getCurrentLocation();

    // Configurar actualización en tiempo real
    _locationSubscription = _location!.onLocationChanged.listen((LocationData locationData) {
      setState(() {
        _currentPosition = LatLng(
          locationData.latitude ?? ALEMANIA_LAT,
          locationData.longitude ?? ALEMANIA_LON,
        );
        
        // Actualizar o añadir el marcador de ubicación actual
        _updateCurrentLocationMarker();
      });
    });
  }

  void _updateCurrentLocationMarker() {
    // Eliminar el marcador de ubicación actual si existe
    _markers.removeWhere((marker) => marker.key == const ValueKey('current_location'));
    
    // Añadir el nuevo marcador de ubicación actual
    _markers.add(
      Marker(
        key: const ValueKey('current_location'),
        point: _currentPosition,
        width: 48,
        height: 48,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFF3B9EE6), width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.18),
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipOval(
            child: Image.asset(
              'assets/images/login1.png',
              width: 44,
              height: 44,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _cargarLugares() async {
    try {
      // Primero añadimos el marcador de Alemania con las coordenadas exactas
      _markers.add(
        Marker(
          point: LatLng(ALEMANIA_LAT, ALEMANIA_LON),
          width: 40,
          height: 40,
          child: GestureDetector(
            onTap: () => _mostrarInfoLugar(
              Lugar(
                id: 1,
                tipo: 'tienda',
                nombre: 'Calle Alemania 10',
                idRuta: 1,
                latitud: ALEMANIA_LAT,
                longitud: ALEMANIA_LON,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.shopping_bag,
                color: Color(0xFFFF7E1B),
                size: 30,
              ),
            ),
          ),
        ),
      );

      // Luego cargamos el resto de lugares
      final lugares = await _lugarService.getLugares();
      setState(() {
        for (var lugar in lugares) {
          if (lugar.nombre != 'Calle Alemania 10') { // Evitamos duplicados
            _markers.add(
              Marker(
                point: LatLng(lugar.latitud, lugar.longitud),
                width: 40,
                height: 40,
                child: GestureDetector(
                  onTap: () => _mostrarInfoLugar(lugar),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: lugar.tipo.toLowerCase() == 'tienda'
                        ? const Icon(
                            Icons.shopping_bag,
                            color: Color(0xFFFF7E1B),
                            size: 30,
                          )
                        : Icon(
                            _getIconForTipo(lugar.tipo),
                            color: const Color(0xFFFF7E1B),
                            size: 30,
                          ),
                  ),
                ),
              ),
            );
          }
        }
      });
    } catch (e) {
      print('Error al cargar lugares: $e');
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      final locationData = await _location!.getLocation();
      setState(() {
        _currentPosition = LatLng(
          locationData.latitude ?? ALEMANIA_LAT,
          locationData.longitude ?? ALEMANIA_LON,
        );
        _updateCurrentLocationMarker();
      });
      _mapController.move(_currentPosition, 15);
    } catch (e) {
      print('Error al obtener la ubicación: $e');
    }
  }

  void _mostrarInfoLugar(Lugar lugar) {
    setState(() {
      _selectedLugar = lugar;
    });
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  _getIconForTipo(lugar.tipo),
                  color: const Color(0xFFFF7E1B),
                  size: 30,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    lugar.nombre,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF14448A),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Text(
              'Tipo: ${_capitalizeFirst(lugar.tipo)}',
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF14448A),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Dirección: Calle Alemania 10, 46010 Valencia',
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF14448A),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  // Aquí puedes agregar la navegación a la página específica del negocio
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF7E1B),
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Ver Detalles',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconForTipo(String tipo) {
    switch (tipo.toLowerCase()) {
      case 'tienda':
        return Icons.shopping_bag;
      case 'restaurante':
        return Icons.restaurant;
      case 'servicio':
        return Icons.miscellaneous_services;
      default:
        return Icons.location_on;
    }
  }

  String _capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF9F6),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              center: _currentPosition,
              zoom: 15,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: const ['a', 'b', 'c'],
                userAgentPackageName: 'com.example.mi_app',
              ),
              MarkerLayer(markers: _markers),
            ],
          ),
          Positioned(
            top: 40,
            left: 16,
            child: GestureDetector(
              onTap: () => Navigator.pushReplacementNamed(context, '/home'),
              child: Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      spreadRadius: 2,
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Center(
                  child: SvgPicture.asset(
                    'assets/svg/back-svgrepo-com_naranja.svg',
                    width: 28,
                    height: 28,
                    colorFilter: const ColorFilter.mode(Color(0xFFFF7E1B), BlendMode.srcIn),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    spreadRadius: 2,
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: FloatingActionButton(
                onPressed: () async {
                  await _getCurrentLocation();
                },
                backgroundColor: Colors.white,
                elevation: 0,
                child: const Icon(Icons.my_location, color: Color(0xFF3B9EE6), size: 28),
              ),
            ),
          ),
        ],
      ),
    );
  }
} 