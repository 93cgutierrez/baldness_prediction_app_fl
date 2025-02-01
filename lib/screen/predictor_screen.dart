import 'dart:convert';

import 'package:baldness_prediction_app/util/dialog_util.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';

class PredictorScreen extends StatefulWidget {
  const PredictorScreen({super.key});

  @override
  _PredictorScreenState createState() => _PredictorScreenState();
}

class _PredictorScreenState extends State<PredictorScreen> {
  // Controladores de IP y puerto
  final TextEditingController ipController =
      TextEditingController(text: "54.225.49.131");
  final TextEditingController portController =
      TextEditingController(text: "3010");

  // Features
  bool genetics = false;
  bool hormonalChanges = false;
  int? medicalCondition;
  int? medication;
  int? nutritionalDeficiency;
  int? stressLevel;
  int? age;
  bool poorHairCare = false;
  bool environmentalFactors = false;
  bool smoking = false;
  bool weightLoss = false;

  // Resultado
  String? predictionMessage;
  String? predictionImage;
  Color? predictionColor;
  String? predictionAnimation;

  //Estado de la petición
  bool loading = false;

  // Opciones de dropdowns
  final medicalConditions = [
    {"label": "Sin datos", "value": 5},
    {"label": "Alopecia Areata", "value": 0},
    {"label": "Psoriasis", "value": 6},
    {"label": "Problemas de tiroides", "value": 10},
    {"label": "Alopecia androgenética", "value": 1},
    {"label": "Dermatitis", "value": 2},
    {"label": "Dermatosis", "value": 3},
    {"label": "Dermatitis seborreica", "value": 9},
    {"label": "Infección del cuero cabelludo", "value": 8},
    {"label": "Eccema", "value": 4},
    {"label": "Tiña", "value": 7},
  ];

  final medications = [
    {"label": "Sin datos", "value": 8},
    {"label": "Rogaine", "value": 9},
    {"label": "Antidepresivos", "value": 2},
    {"label": "Esteroides", "value": 10},
    {"label": "Medicamentos para el corazón", "value": 6},
    {"label": "Accutane", "value": 0},
    {"label": "Antibióticos", "value": 1},
    {"label": "Crema antifúngica", "value": 3},
    {"label": "Quimioterapia", "value": 5},
    {"label": "Medicamentos para la presión arterial", "value": 4},
    {"label": "Inmunomoduladores", "value": 7},
  ];

  final nutritionalDeficiencies = [
    {"label": "Sin datos", "value": 3},
    {"label": "Deficiencia de zinc", "value": 10},
    {"label": "Deficiencia de vitamina D", "value": 8},
    {"label": "Deficiencia de biotina", "value": 0},
    {"label": "Deficiencia de vitamina A", "value": 7},
    {"label": "Ácidos grasos omega-3", "value": 4},
    {"label": "Deficiencia de proteínas", "value": 5},
    {"label": "Deficiencia de magnesio", "value": 2},
    {"label": "Deficiencia de vitamina E", "value": 9},
    {"label": "Deficiencia de selenio", "value": 6},
    {"label": "Deficiencia de hierro", "value": 1},
  ];

  final stressLevels = [
    {"label": "Moderado", "value": 2},
    {"label": "Bajo", "value": 1},
    {"label": "Alto", "value": 0},
  ];

  final Duration timeout =
      const Duration(seconds: 10); // Timeout de 10 segundos

  Future<void> handlePredict() async {
    //close keyboard and remove focus
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() {
      loading = true;
    });
    if (await Connectivity().checkConnectivity() == ConnectivityResult.none) {
      DialogUtil.simpleDialog(
        context: context,
        title: "Error",
        content: "Por favor, verifica tu conexión a Internet.",
        primaryButtonText: "OK",
      );
      setState(() {
        loading = false;
      });
      return;
    }

    if (age == null || age! < 18 || age! > 100) {
      DialogUtil.simpleDialog(
        context: context,
        title: "Error",
        content: "Tu edad debe ser un número entre 18 y 100.",
        primaryButtonText: "OK",
      );
      setState(() {
        loading = false;
      });
      return;
    }

    //validar dropdown tengan valores
    if (medicalCondition == null ||
        medication == null ||
        nutritionalDeficiency == null ||
        stressLevel == null) {
      DialogUtil.simpleDialog(
        context: context,
        title: "Error",
        content: "Por favor, selecciona una opción en todos los campos.",
        primaryButtonText: "OK",
      );
      setState(() {
        loading = false;
      });
      return;
    }

    final url = 'http://${ipController.text}:${portController.text}/predict';
    final body = {
      'genetica': genetics ? 1 : 0,
      'cambios_hormonales': hormonalChanges ? 1 : 0,
      'condiciones_medicas': medicalCondition,
      'medicamentos_tratamientos': medication,
      'deficiencias_nutricionales': nutritionalDeficiency,
      'estres': stressLevel,
      'edad': age,
      'malos_habitos_cuidado_capilar': poorHairCare ? 1 : 0,
      'factores_ambientales': environmentalFactors ? 1 : 0,
      'tabaquismo': smoking ? 1 : 0,
      'perdida_peso': weightLoss ? 1 : 0,
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode(body),
        headers: {"Content-Type": "application/json"},
      ).timeout(timeout);

      final data = json.decode(response.body);
      final prediction = data['prediction'];

      setState(() {
        loading = false;
        predictionMessage = prediction == 0
            ? "No sufres o sufrirás de pérdida de cabello."
            : "Sufres o sufrirás de pérdida de cabello.";
        predictionImage =
            prediction == 0 ? "assets/hair.png" : "assets/billiard_ball.png";
        predictionColor = prediction == 0 ? Colors.green : Colors.red;
        predictionAnimation =
            prediction == 0 ? 'assets/zen.json' : 'assets/foca.json';

        DialogUtil.simpleDialog(
          context: context,
          title: "Predicción",
          content: predictionMessage ?? 'Error',
          backgroundColor: predictionColor ?? Colors.black,
          primaryButtonText: "OK",
          //image: predictionImage,
          animation: predictionAnimation ?? '',
        );
      });
    } catch (error) {
      DialogUtil.simpleDialog(
        context: context,
        title: "Error",
        content: "No se pudo conectar con el servidor: $error",
        primaryButtonText: "OK",
      );
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            loading || predictionColor == null ? null : predictionColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Predictor pérdida de Cabello",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: loading || predictionColor == null
                    ? Colors.black
                    : Colors.white,
              ),
            ),
            loading || predictionAnimation == null
                ? Image.asset(
                    "assets/logo.png",
                    width: 40,
                    height: 40,
                  )
                : Lottie.asset(
                    repeat: true,
                    backgroundLoading: true,
                    predictionAnimation!,
                    width: 40,
                  ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Entrada de IP y puerto
            TextField(
              controller: ipController,
              decoration:
                  const InputDecoration(labelText: "IP/Host del servidor"),
              enabled: !loading,
            ),
            TextField(
              controller: portController,
              decoration:
                  const InputDecoration(labelText: "Puerto del servidor"),
              keyboardType: TextInputType.number,
              enabled: !loading,
            ),
            // Otros Switches y Dropdowns
            SwitchListTile(
              title: const Text("¿Tienes antecedentes familiares de calvicie?"),
              value: genetics,
              onChanged:
                  loading ? null : (value) => setState(() => genetics = value),
            ),
            SwitchListTile(
              title: const Text("¿Has tenido cambios hormonales?"),
              value: hormonalChanges,
              onChanged: loading
                  ? null
                  : (value) => setState(() => hormonalChanges = value),
            ),
            DropdownButtonFormField<int>(
              decoration: const InputDecoration(
                labelText: "¿Tienes alguna condición médica?",
                labelStyle: TextStyle(
                  // Estilo para la etiqueta
                  fontSize: 13, // Tamaño de fuente más pequeño
                ),
              ),
              items: medicalConditions
                  .map((item) => DropdownMenuItem<int>(
                        value: item["value"] as int,
                        child: Text(item["label"] as String),
                      ))
                  .toList(),
              onChanged: loading
                  ? null
                  : (value) => setState(() => medicalCondition = value),
            ),
            DropdownButtonFormField<int>(
              decoration: const InputDecoration(
                labelText: "¿Has tomado medicamentos o tratamientos?",
                labelStyle: TextStyle(
                  // Estilo para la etiqueta
                  fontSize: 13, // Tamaño de fuente más pequeño
                ),
              ),
              items: medications
                  .map((item) => DropdownMenuItem<int>(
                        value: item["value"] as int,
                        child: Text(item["label"] as String),
                      ))
                  .toList(),
              onChanged: loading
                  ? null
                  : (value) => setState(() => medication = value),
            ),
            DropdownButtonFormField<int>(
              decoration: const InputDecoration(
                labelText:
                    "¿Tienes o has tenido alguna deficiencia nutricional?",
                labelStyle: TextStyle(
                  // Estilo para la etiqueta
                  fontSize: 13, // Tamaño de fuente más pequeño
                ),
              ),
              items: nutritionalDeficiencies
                  .map((item) => DropdownMenuItem<int>(
                        value: item["value"] as int,
                        child: Text(item["label"] as String),
                      ))
                  .toList(),
              onChanged: loading
                  ? null
                  : (value) => setState(() => nutritionalDeficiency = value),
            ),
            DropdownButtonFormField<int>(
              decoration: const InputDecoration(
                labelText: "¿Que nivel de estrés manejas comunmente?",
                labelStyle: TextStyle(
                  // Estilo para la etiqueta
                  fontSize: 13, // Tamaño de fuente más pequeño
                ),
              ),
              items: stressLevels
                  .map((item) => DropdownMenuItem<int>(
                        value: item["value"] as int,
                        child: Text(item["label"] as String),
                      ))
                  .toList(),
              onChanged: loading
                  ? null
                  : (value) => setState(() => stressLevel = value),
            ),
            TextField(
              decoration: const InputDecoration(labelText: "Tu edad"),
              keyboardType: TextInputType.number,
              onChanged: loading
                  ? null
                  : (value) => setState(() => age = int.tryParse(value)),
              enabled: !loading,
            ),
            SwitchListTile(
              title:
                  const Text("¿Tienes malos hábitos de cuidado del cabello?"),
              value: poorHairCare,
              onChanged: loading
                  ? null
                  : (value) => setState(() => poorHairCare = value),
            ),
            SwitchListTile(
              title: const Text("¿Has estado expuesto a factores ambientales?"),
              value: environmentalFactors,
              onChanged: loading
                  ? null
                  : (value) => setState(() => environmentalFactors = value),
            ),
            SwitchListTile(
              title: const Text("¿Fumas?"),
              value: smoking,
              onChanged:
                  loading ? null : (value) => setState(() => smoking = value),
            ),
            SwitchListTile(
              title: const Text("¿Has perdido peso recientemente?"),
              value: weightLoss,
              onChanged: loading
                  ? null
                  : (value) => setState(() => weightLoss = value),
            ),
            const SizedBox(height: 16),
            if (predictionMessage != null &&
                predictionColor != null &&
                !loading) ...[
              predictionImage != null
                  ? Image.asset(
                      predictionImage!,
                      width: 100,
                      height: 100,
                    )
                  : Container(),
              const SizedBox(height: 16),
              Text(
                predictionMessage!,
                style: TextStyle(
                    color: predictionColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ],
            const SizedBox(height: 16),
            /*                loading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Colors.amberAccent,
                          strokeWidth: 5.0,
                        ),
                      )
                    : ElevatedButton(
                        onPressed: handlePredict,
                        child: const Text("PREDECIR"),
                      ),*/
            const SizedBox(height: 16),
            const Text("© 2025 by Carlos Gutierrez"),
          ],
        ),
      ),
      //floating action button extended with button "PREDECIR", el boton debera cambiar de icono y color de fondo al dar click y texto
      floatingActionButton: loading
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.amberAccent,
                strokeWidth: 5.0,
              ),
            )
          : FloatingActionButton.extended(
              onPressed: handlePredict,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
                side: const BorderSide(color: Colors.amberAccent),
              ),
              label: const Text("PREDECIR"),
/*              child: Icon(
                loading ? Icons.refresh : Icons.play_arrow,
                color: loading ? Colors.amberAccent : Colors.white,
              ),*/
            ),
    );
  }
}
