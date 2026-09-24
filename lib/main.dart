import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';

void main() {
  runApp(const FreeFireOptimizerApp());
}

class FreeFireOptimizerApp extends StatelessWidget {
  const FreeFireOptimizerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FF Spec & Sensitivity & DPI',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.deepOrange,
        scaffoldBackgroundColor: const Color(0xFF121212),
      ),
      home: const OptimizerHomePage(),
    );
  }
}

class OptimizerHomePage extends StatefulWidget {
  const OptimizerHomePage({super.key});

  @override
  State<OptimizerHomePage> createState() => _OptimizerHomePageState();
}

class _OptimizerHomePageState extends State<OptimizerHomePage> {
  String deviceName = "جاري فحص العتاد...";
  String systemVersion = "...";
  String processorType = "جاري تحليل المعالج...";
  String recommendedGraphics = "Medium / 60 FPS";
  
  // قيم الحساسية الافتراضية والـ DPI
  int generalSens = 95;
  int redDotSens = 90;
  int scope2x = 88;
  int scope4x = 85;
  int awmSens = 50;
  int dpiValue = 410; // قيمة الـ DPI الافتراضية

  @override
  void initState() {
    super.initState();
    _getDeviceSpecifications();
  }

  // دالة لجلب معلومات الجهاز الحقيقية وتحديد الـ DPI المناسب
  Future<void> _getDeviceSpecifications() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        setState(() {
          deviceName = "${androidInfo.brand.toUpperCase()} ${androidInfo.model}";
          systemVersion = "Android ${androidInfo.version.release}";
          processorType = androidInfo.hardware.isNotEmpty ? androidInfo.hardware : "Octa-core Gaming CPU";
          
          String modelName = androidInfo.model.toLowerCase();
          
          // تحليل ذكي لاختيار الحساسية وقيمة الـ DPI المناسبة للهاتف
          if (modelName.contains("samsung") || modelName.contains("galaxy") || modelName.contains("a")) {
            // هواتف سامسونج (تعمل بـ DPI أعلى قليلاً لثبات الهيدشوت)
            setSensAndDpi(94, 91, 87, 85, 45, 480);
            recommendedGraphics = "Standard / High FPS";
          } else if (modelName.contains("redmi") || modelName.contains("poco") || modelName.contains("xiaomi")) {
            // هواتف شاومي وبوكو (ممتازة للألعاب، تحتاج سرعة استجابة)
            setSensAndDpi(98, 95, 92, 90, 52, 540);
            recommendedGraphics = "Ultra / High FPS";
          } else if (modelName.contains("oppo") || modelName.contains("realme") || modelName.contains("vivo")) {
            // هواتف أوبو وريلمي
            setSensAndDpi(96, 93, 89, 88, 48, 510);
            recommendedGraphics = "Standard / High FPS";
          } else {
            // الهواتف الاقتصادية أو العامة
            setSensAndDpi(90, 85, 82, 80, 40, 410);
            recommendedGraphics = "Smooth / Standard";
          }
        });
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        setState(() {
          deviceName = iosInfo.name;
          systemVersion = iosInfo.systemName;
          processorType = iosInfo.utsname.machine;
          recommendedGraphics = "Max / 90-120 FPS";
          setSensAndDpi(88, 85, 82, 80, 40, 0); // الآيفون لا يدعم تغيير DPI النظام
        });
      }
    } catch (e) {
      setState(() {
        deviceName = "هاتف ذكي (معالج غير محدد)";
      });
    }
  }

  void setSensAndDpi(int gen, int rd, int s2, int s4, int awm, int dpi) {
    generalSens = gen;
    redDotSens = rd;
    scope2x = s2;
    scope4x = s4;
    awmSens = awm;
    dpiValue = dpi;
  }

  void _copyToClipboard(String text, String message) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.deepOrange),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('محلل الأداء وحساسية فري فاير (مع DPI)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1F1F1F),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // بطاقة معلومات الهاتف والرسوميات
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.deepOrange.withOpacity(0.5)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.phone_android, color: Colors.deepOrange),
                      SizedBox(width: 8),
                      Text("فحص عتاد الهاتف", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const Divider(color: Colors.grey),
                  const SizedBox(height: 8),
                  Text("الجهاز: $deviceName", style: const TextStyle(fontSize: 15)),
                  const SizedBox(height: 6),
                  Text("المعالج: $processorType", style: const TextStyle(fontSize: 14, color: Colors.grey)),
                  const SizedBox(height: 6),
                  Text("الجرافيك المناسب للعبة: $recommendedGraphics", style: const TextStyle(fontSize: 14, color: Colors.greenAccent)),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // عنوان قسم الحساسية
            const Text(
              "🎯 إعدادات الحساسية والـ DPI المناسبة",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.deepOrange),
            ),
            const SizedBox(height: 10),

            // كروت الحساسية
            _buildSensitivityCard("العام (General)", generalSens),
            _buildSensitivityCard("النقطة الحمراء (Red Dot)", redDotSens),
            _buildSensitivityCard("منظار 2x", scope2x),
            _buildSensitivityCard("منظار 4x", scope4x),
            _buildSensitivityCard("القناص AWM", awmSens),
            
            // عرض بطاقة الـ DPI خصيصاً لأجهزة أندرويد
            if (Platform.isAndroid)
              Container(
                margin: const EdgeInsets.symmetric(vertical: 6),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFF2A1A1A),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.redAccent.withOpacity(0.6)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("قيمة الـ DPI المقترحة", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.redAccent)),
                        SizedBox(height: 2),
                        Text("لتعديل سرعة الشاشة وثبات الهيدشوت", style: TextStyle(fontSize: 11, color: Colors.grey)),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.redAccent.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            "$dpiValue",
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.redAccent),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.copy, size: 20, color: Colors.redAccent),
                          onPressed: () => _copyToClipboard("$dpiValue", "تم نسخ قيمة الـ DPI بنجاح!"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 20),

            // زر نسخ الكل
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () {
                  String summary = "=== إعدادات فري فاير ===\nGeneral: $generalSens\nRed Dot: $redDotSens\n2x: $scope2x\n4x: $scope4x\nAWM: $awmSens";
                  if (Platform.isAndroid) summary += "\nDPI: $dpiValue";
                  _copyToClipboard(summary, "تم نسخ كافة الإعدادات والـ DPI بنجاح!");
                },
                icon: const Icon(Icons.copy_all, color: Colors.white),
                label: const Text("نسخ جميع الإعدادات مع الـ DPI", style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSensitivityCard(String title, int value) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 15)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.deepOrange.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              "$value",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.deepOrange),
            ),
          ),
        ],
      ),
    );
  }
}
