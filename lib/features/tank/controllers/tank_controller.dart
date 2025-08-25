import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flow_360/features/tank/models/tank_model.dart';
import 'package:flow_360/features/tank/models/tank_audit_model.dart';
import 'package:flow_360/features/tank/repository/tank_repository.dart';
import 'package:flow_360/features/auth/controllers/auth_controller.dart';
import 'package:flow_360/features/fuel/services/fuel_service.dart';
import 'package:get_it/get_it.dart';

class TankController extends GetxController {
  final TankRepository _tankRepository = GetIt.instance<TankRepository>();
  final AuthController _authController = Get.find<AuthController>();
  final FuelService _fuelService = FuelService();

  // Observable data
  final RxList<TankModel> tanks = <TankModel>[].obs;
  final RxList<TankAuditModel> tankAuditTrail = <TankAuditModel>[].obs;
  final RxList<Map<String, dynamic>> fuelTypes = <Map<String, dynamic>>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isRefreshing = false.obs;
  final RxString errorMessage = ''.obs;

  // Selected tank for detailed view
  final Rx<TankModel?> selectedTank = Rx<TankModel?>(null);

  TankController();

  @override
  void onInit() {
    super.onInit();
    // Load fuel types and wait for user data to be available before loading tanks
    loadFuelTypes();
    _waitForUserAndLoadTanks();
  }

  Future<void> loadFuelTypes() async {
    try {
      final fuels = await _fuelService.getFuels();
      fuelTypes.value = fuels;
    } catch (e) {
      print('Failed to load fuel types: ${e.toString()}');
      // Don't show error to user for fuel types, just log it
    }
  }

  Future<void> _waitForUserAndLoadTanks() async {
    // Wait a bit for AuthController to initialize
    await Future.delayed(const Duration(milliseconds: 100));
    
    // Check if user is available, if not wait and retry
    if (_authController.currentUser.value?.user.station == null) {
      // Wait for user data to be loaded
      await Future.delayed(const Duration(milliseconds: 500));
      
      // If still no user data, don't load tanks yet
      if (_authController.currentUser.value?.user.station == null) {
        return;
      }
    }
    
    // Now load tanks
    await loadTanks();
  }

  Future<void> loadTanks() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final currentUser = _authController.currentUser.value;
      if (currentUser?.user.station == null) {
        errorMessage.value = 'No station assigned to user. Please contact your administrator.';
        return;
      }

      final stationId = currentUser!.user.station!;
      
      // Try to load from cache first
      final cachedTanks = await _tankRepository.getCachedTanks(
        stationId: stationId,
      );
      
      if (cachedTanks != null) {
        tanks.value = cachedTanks;
      }

      // Load from network
      final networkTanks = await _tankRepository.getTanks(
        stationId: stationId,
      );
      
      tanks.value = networkTanks;
      print('DEBUG: Loaded ${networkTanks.length} tanks');
      for (final tank in networkTanks) {
        print('DEBUG: Tank ${tank.name} - Fuel type: ${tank.fuelTypeName}, KRA code: ${tank.fuelTypeKraCode}');
      }
    } catch (e) {
      errorMessage.value = 'Failed to load tanks: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshTanks() async {
    try {
      isRefreshing.value = true;
      await loadTanks();
    } finally {
      isRefreshing.value = false;
    }
  }

  // Method to load tanks when user data becomes available
  Future<void> loadTanksIfUserAvailable() async {
    final currentUser = _authController.currentUser.value;
    if (currentUser?.user.station != null) {
      await loadTanks();
    }
  }

  Future<void> createTank(Map<String, dynamic> tankData) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final newTank = await _tankRepository.createTank(data: tankData);
      tanks.add(newTank);
      
      // Success - UI will handle showing snackbar and closing dialog
    } catch (e) {
      errorMessage.value = 'Failed to create tank: ${e.toString()}';
      // Error - UI will handle showing snackbar
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateTank(String tankId, Map<String, dynamic> tankData) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final updatedTank = await _tankRepository.updateTank(
        tankId: tankId,
        data: tankData,
      );
      
      final index = tanks.indexWhere((tank) => tank.id == tankId);
      if (index != -1) {
        tanks[index] = updatedTank;
      }
      
      // Success - UI will handle showing snackbar and closing dialog
    } catch (e) {
      errorMessage.value = 'Failed to update tank: ${e.toString()}';
      // Error - UI will handle showing snackbar
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addFuelToTank(String tankId, double litres, String reason) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final auditEntry = await _tankRepository.addFuelToTank(
        tankId: tankId,
        litres: litres,
        reason: reason,
      );
      
      // Refresh tanks to get updated levels
      await loadTanks();
      
      // Add to audit trail if viewing that tank
      if (selectedTank.value?.id == tankId) {
        tankAuditTrail.insert(0, auditEntry);
      }
      
      // Success - UI will handle showing snackbar and closing dialog
    } catch (e) {
      errorMessage.value = 'Failed to add fuel: ${e.toString()}';
      // Error - UI will handle showing snackbar
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> adjustTankLevel(String tankId, double newLevel, String reason) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final auditEntry = await _tankRepository.adjustTankLevel(
        tankId: tankId,
        newLevel: newLevel,
        reason: reason,
      );
      
      // Refresh tanks to get updated levels
      await loadTanks();
      
      // Add to audit trail if viewing that tank
      if (selectedTank.value?.id == tankId) {
        tankAuditTrail.insert(0, auditEntry);
      }
      
      // Success - UI will handle showing snackbar and closing dialog
    } catch (e) {
      errorMessage.value = 'Failed to adjust tank level: ${e.toString()}';
      // Error - UI will handle showing snackbar
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadTankAuditTrail(String tankId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Try to load from cache first
      final cachedAudits = await _tankRepository.getCachedTankAuditTrail(
        tankId: tankId,
      );
      
      if (cachedAudits != null) {
        tankAuditTrail.value = cachedAudits;
      }

      // Load from network
      final networkAudits = await _tankRepository.getTankAuditTrail(
        tankId: tankId,
      );
      
      tankAuditTrail.value = networkAudits;
    } catch (e) {
      rethrow;
      errorMessage.value = 'Failed to load audit trail: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  void selectTank(TankModel tank) {
    selectedTank.value = tank;
    loadTankAuditTrail(tank.id);
  }

  void clearSelectedTank() {
    selectedTank.value = null;
    tankAuditTrail.clear();
  }

  // Helper methods
  List<TankModel> get activeTanks => tanks.where((tank) => tank.isActive).toList();
  List<TankModel> get lowFuelTanks => tanks.where((tank) => tank.hasLowFuel).toList();
  List<TankModel> get mediumFuelTanks => tanks.where((tank) => tank.hasMediumFuel).toList();
  List<TankModel> get goodFuelTanks => tanks.where((tank) => tank.hasGoodFuel).toList();
}
