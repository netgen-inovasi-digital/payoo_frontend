import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:payoo/app/components/custom_snackbar.dart';
import 'package:payoo/app/data/models/Toko_model.dart';
import 'package:payoo/app/data/models/keranjang_model.dart';
import 'package:payoo/app/data/models/produk_model.dart';
import 'package:payoo/app/modules/produk/controllers/produk_controller.dart';
import 'package:payoo/app/modules/toko/controllers/toko_controller.dart';
import 'package:payoo/app/services/api_response.dart';
import 'package:payoo/config/utils/storage_manager.dart';

import '../../../../config/utils/constant.dart';
import '../../../services/api_call_status.dart';
import '../../../services/base_client.dart';

class StrukController extends GetxController {
var status = ApiCallStatus.holding.obs;
var order = Rx<KeranjangModel?>(null);
TokoController tokoController = Get.find<TokoController>();
var totalHarga = 0.0.obs;
var returnAmount = 0.0.obs;
var totalItem = 0.obs;
var error = ''.obs;
var shopId = 0.obs;
var userId = 0.obs;
var toko = <Toko?>[].obs;
ProdukController produkController =
    Get.put<ProdukController>(ProdukController());
List<Produk> produkList = <Produk>[].obs;

// State update
var statusUpdate = ApiCallStatus.holding.obs;
var errorUpdate = ''.obs;

// Printer
var connectedDevice = Rx<BluetoothInfo?>(null);
var isPrinting = false.obs;

Future<bool> getOrderById({required int orderId}) async {
  status.value = ApiCallStatus.loading;
  error.value = '';
  final url = Constants.baseUrl +
      Constants.ORDER_BY_ID.replaceFirst('{id}', orderId.toString());
  final token = StorageManager().read<String>('token');

  bool success = false;
  await BaseClient.safeApiCall(
    url,
    RequestType.get,
    headers: token != null ? {'Authorization': 'Bearer $token'} : null,
    onSuccess: (response) async {
      try {
        final parsed = ApiResponse<KeranjangModel>.fromJson(
          response.data,
          (json) => KeranjangModel.fromJson(json),
        );
        if (parsed.data != null) {
          order.value = parsed.data;
          shopId.value = int.tryParse('${order.value?.shopId}') ?? 0;
          userId.value = int.tryParse('${order.value?.userId}') ?? 0;
          await tokoController.fetchTokoById(shopId.value);
          calculateTotalHargaAndItem();
          produkList.clear();

          // Load all products in parallel
          final productIds = order.value?.orderItems
                  .map((item) => item.productId)
                  .toList() ??
              [];

          // Fetch products one by one and add them to the list
          final products = await Future.wait(
            productIds.map((id) async {
              await produkController.fetchProdukById(id);
              return produkController.produk.value;
            }),
          );
          produkList.assignAll(products.whereType<Produk>());
        }

        status.value = ApiCallStatus.success;
        success = true;
      } catch (e) {
        error.value = 'Parsing error: ${e.toString()}';
        status.value = ApiCallStatus.error;
      }
    },
    onError: (e) {
      error.value = e.toString();
      status.value = ApiCallStatus.error;
    },
  );

  if (status.value == ApiCallStatus.loading) {
    status.value = ApiCallStatus.error;
  }
  return success;
}

void calculateTotalHargaAndItem() {
  totalHarga.value = 0.0;
  totalItem.value = 0; // reset first
  if (order.value?.orderItems != null) {
    for (var item in order.value!.orderItems) {
      totalHarga.value += item.price * item.quantity;
      totalItem.value += item.quantity;
    }
  }
}

// Printer Methods
Future<bool> checkAndRequestBluetoothPermissions() async {
  try {
    // Check if permissions are granted
    Map<Permission, PermissionStatus> statuses = await [
      Permission.bluetooth,
      Permission.bluetoothConnect,
      Permission.bluetoothScan,
      // Permission.location,
    ].request();

    bool allGranted = statuses.values.every((status) => status.isGranted);
    
    if (!allGranted) {
      CustomSnackBar.showCustomErrorSnackBar(
        title: 'Permission Required',
        message: 'Bluetooth permissions are required for printing. Please enable in settings.',
      );
      
      // Buka settings jika permission ditolak permanent
      if (statuses.values.any((status) => status.isPermanentlyDenied)) {
        await openAppSettings();
      }
    }
    
    return allGranted;
  } catch (e) {
    CustomSnackBar.showCustomErrorSnackBar(
      title: 'Permission Error',
      message: 'Failed to request permissions: $e',
    );
    return false;
  }
}

Future<List<BluetoothInfo>> getBluetoothDevices() async {
  try {
    return await PrintBluetoothThermal.pairedBluetooths;
  } catch (e) {
    CustomSnackBar.showCustomErrorSnackBar(
      title: 'Error',
      message: 'Failed to get Bluetooth devices: $e',
    );
    return [];
  }
}

Future<void> connectToPrinter(BluetoothInfo device) async {
  try {
    bool connected = await PrintBluetoothThermal.connect(macPrinterAddress: device.macAdress);
    if (connected) {
      connectedDevice.value = device;
      CustomSnackBar.showCustomSnackBar(
        title: 'Success',
        message: 'Connected to ${device.name}',
      );
    } else {
      throw Exception('Connection failed');
    }
  } catch (e) {
    CustomSnackBar.showCustomErrorSnackBar(
      title: 'Connection Failed',
      message: 'Failed to connect: $e',
    );
  }
}

Future<void> printReceipt() async {
  bool isConnected = await PrintBluetoothThermal.connectionStatus;
  if (!isConnected) {
    CustomSnackBar.showCustomErrorSnackBar(
      title: 'Printer Not Connected',
      message: 'Please connect to a printer first',
    );
    return;
  }

  try {
    isPrinting.value = true;

    String receipt = '';
    
    // Header
    receipt += '${tokoController.toko.value?.name ?? 'Nama Toko'}\n';
    receipt += '${tokoController.toko.value?.address ?? 'Alamat Toko'}\n';
    receipt += '${tokoController.toko.value?.phone ?? 'No Telepon'}\n';
    receipt += '\n';
    receipt += '================================\n';
    
    // Transaction Info
    final now = DateTime.now();
    receipt += 'Date: ${now.toString().split(' ')[0]}  Time: ${now.toString().split(' ')[1].substring(0, 5)}\n';
    receipt += 'Transaction ID: ${order.value?.id.toString() ?? '0'}\n';
    receipt += '\n';
    
    // Items
    receipt += 'Items:\n';
    receipt += '--------------------------------\n';
    
    for (int i = 0; i < (order.value?.orderItems.length ?? 0); i++) {
      if (i < produkList.length) {
        final item = order.value!.orderItems[i];
        final produk = produkList[i];
        receipt += '${produk.name}\n';
        
        // Format quantity x price aligned to right with total
        String qtyPrice = '${item.quantity}x${item.price.toStringAsFixed(0)}';
        String total = 'Rp. ${(item.quantity * item.price).toStringAsFixed(0)}';
        int spaces = 32 - qtyPrice.length - total.length;
        if (spaces < 1) spaces = 1;
        receipt += '$qtyPrice${' ' * spaces}$total\n';
      }
    }
    
    receipt += '--------------------------------\n';
    
    // Summary
    String totalItemText = 'Total Item:';
    String totalItemValue = totalItem.value.toString();
    int spaces1 = 32 - totalItemText.length - totalItemValue.length;
    if (spaces1 < 1) spaces1 = 1;
    receipt += '$totalItemText${' ' * spaces1}$totalItemValue\n';
    
    String subTotalText = 'Sub Total:';
    String subTotalValue = 'Rp. ${totalHarga.value.toStringAsFixed(0)}';
    int spaces2 = 32 - subTotalText.length - subTotalValue.length;
    if (spaces2 < 1) spaces2 = 1;
    receipt += '$subTotalText${' ' * spaces2}$subTotalValue\n';
    
    String totalText = 'Total:';
    String totalValue = 'Rp. ${totalHarga.value.toStringAsFixed(0)}';
    int spaces3 = 32 - totalText.length - totalValue.length;
    if (spaces3 < 1) spaces3 = 1;
    receipt += '$totalText${' ' * spaces3}$totalValue\n';
    
    String paidText = 'Paid:';
    String paidValue = 'Rp. ${order.value?.amountPaid.toStringAsFixed(0) ?? '0'}';
    int spaces4 = 32 - paidText.length - paidValue.length;
    if (spaces4 < 1) spaces4 = 1;
    receipt += '$paidText${' ' * spaces4}$paidValue\n';
    
    String changeText = 'Change:';
    String changeValue = 'Rp. ${((order.value?.amountPaid ?? 0) - totalHarga.value).toStringAsFixed(0)}';
    int spaces5 = 32 - changeText.length - changeValue.length;
    if (spaces5 < 1) spaces5 = 1;
    receipt += '$changeText${' ' * spaces5}$changeValue\n';
    
    receipt += '\n';
    receipt += '================================\n';
    receipt += 'Thank you for your purchase!\n';
    receipt += '\n\n\n';
    
    // Print the receipt using bytes conversion
    await PrintBluetoothThermal.writeBytes(receipt.codeUnits);
    
    CustomSnackBar.showCustomSnackBar(
      title: 'Success',
      message: 'Receipt printed successfully!',
    );
  } catch (e) {
    CustomSnackBar.showCustomErrorSnackBar(
      title: 'Print Failed',
      message: 'Failed to print: $e',
    );
  } finally {
    isPrinting.value = false;
  }
}

Future<void> showPrinterDialog() async {
  try {
    // Check permissions first
    bool hasPermissions = await checkAndRequestBluetoothPermissions();
    if (!hasPermissions) {
      return;
    }

    // Check if Bluetooth is enabled
    bool isEnabled = await PrintBluetoothThermal.bluetoothEnabled;
    if (!isEnabled) {
      CustomSnackBar.showCustomErrorSnackBar(
        title: 'Bluetooth Disabled',
        message: 'Please enable Bluetooth and try again.',
      );
      return;
    }

    // Get paired devices
    final devices = await getBluetoothDevices();
    if (devices.isEmpty) {
      CustomSnackBar.showCustomErrorSnackBar(
        title: 'No Printers Found',
        message: 'No paired Bluetooth devices found. Please pair a printer first.',
      );
      return;
    }

    // Show device selection dialog
    Get.dialog(
      AlertDialog(
        title: const Text('Select Printer'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: devices.length,
            itemBuilder: (context, index) {
              final device = devices[index];
              return ListTile(
                leading: const Icon(Icons.bluetooth),
                title: Text(device.name),
                subtitle: Text(device.macAdress),
                onTap: () async {
                  Get.back();
                  await connectToPrinter(device);
                  if (connectedDevice.value != null) {
                    await printReceipt();
                  }
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  } catch (e) {
    CustomSnackBar.showCustomErrorSnackBar(
      title: 'Error',
      message: 'Failed to show printer dialog: $e',
    );
  }
}

@override
void onClose() {
  super.onClose();
}
}
