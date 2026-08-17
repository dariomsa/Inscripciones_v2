import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:convert';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Inscripción de Participantes',
      home: InscripcionForm(),
    );
  }
}

class InscripcionForm extends StatefulWidget {
  const InscripcionForm({super.key});

  @override
  State<InscripcionForm> createState() => _InscripcionFormState();
}

class _InscripcionFormState extends State<InscripcionForm> {
  int currentStep = 0;
  final formKeyParticipante = GlobalKey<FormState>();
  final formKeyFacturacion = GlobalKey<FormState>();

  // Participante
  final nombresController = TextEditingController();
  final apellidosController = TextEditingController();
  String tipoDocumento = 'C';
  final numeroDocumentoController = TextEditingController();
  DateTime? fechaNacimiento;
  String genero = 'M';
  String nacionalidad = 'EC';
  String categoria = '';
  String talla = 'M';
  final celularController = TextEditingController();
  final emailController = TextEditingController();
  final ciudadController = TextEditingController();
  final emergenciaNombreController = TextEditingController();
  final emergenciaCelularController = TextEditingController();

  // Facturación
  String factTipoDocumento = 'C';
  final numeroDocFacturacionController = TextEditingController();
  final nombreFacturacionController = TextEditingController();
  final apellidoFacturacionController = TextEditingController();
  final emailFacturacionController = TextEditingController();
  final direccionFacturacionController = TextEditingController();
  final telefonoFacturacionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inscripción de Participantes'),
        backgroundColor: Colors.blue,
      ),
      body: Stepper(
        currentStep: currentStep,
        onStepContinue: () {
          if (currentStep == 0) {
            if (formKeyParticipante.currentState!.validate()) {
              setState(() => currentStep = 1);
            }
          } else if (currentStep == 1) {
            if (formKeyFacturacion.currentState!.validate()) {
              _submitForm();
            }
          }
        },
        onStepCancel: () {
          if (currentStep > 0) {
            setState(() => currentStep = currentStep - 1);
          }
        },
        steps: [
          Step(
            title: const Text('Datos del Participante'),
            content: _buildParticipanteForm(),
            isActive: currentStep >= 0,
          ),
          Step(
            title: const Text('Datos de Facturación'),
            content: _buildFacturacionForm(),
            isActive: currentStep >= 1,
          ),
        ],
      ),
    );
  }

  Widget _buildParticipanteForm() {
    return Form(
      key: formKeyParticipante,
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Fila 1: Nombres y Apellidos
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: nombresController,
                    decoration: const InputDecoration(
                      labelText: 'Nombres',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value?.isEmpty ?? true) return 'Requerido';
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: apellidosController,
                    decoration: const InputDecoration(
                      labelText: 'Apellidos',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value?.isEmpty ?? true) return 'Requerido';
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Fila 2: Tipo de Documento y Número
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: DropdownButtonFormField<String>(
                    value: tipoDocumento,
                    decoration: const InputDecoration(
                      labelText: 'Tipo de Documento',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'C', child: Text('Cédula')),
                      DropdownMenuItem(value: 'P', child: Text('Pasaporte')),
                      DropdownMenuItem(value: 'R', child: Text('RUC')),
                    ],
                    onChanged: (value) => setState(() => tipoDocumento = value ?? 'C'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    controller: numeroDocumentoController,
                    decoration: const InputDecoration(
                      labelText: 'Número de Documento',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value?.isEmpty ?? true) return 'Requerido';
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Fila 3: Fecha Nacimiento y Género
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Fecha de Nacimiento',
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: _selectDate,
                      ),
                    ),
                    controller: TextEditingController(
                      text: fechaNacimiento != null
                          ? '${fechaNacimiento!.day}/${fechaNacimiento!.month}/${fechaNacimiento!.year}'
                          : '',
                    ),
                    validator: (value) {
                      if (fechaNacimiento == null) return 'Requerido';
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: genero,
                    decoration: const InputDecoration(
                      labelText: 'Género',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'M', child: Text('Masculino')),
                      DropdownMenuItem(value: 'F', child: Text('Femenino')),
                    ],
                    onChanged: (value) => setState(() => genero = value ?? 'M'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Fila 4: Nacionalidad y Talla
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Nacionalidad',
                      border: OutlineInputBorder(),
                    ),
                    initialValue: nacionalidad,
                    validator: (value) {
                      if (value?.isEmpty ?? true) return 'Requerido';
                      return null;
                    },
                    onChanged: (value) => nacionalidad = value,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: talla,
                    decoration: const InputDecoration(
                      labelText: 'Talla',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'XS', child: Text('XS')),
                      DropdownMenuItem(value: 'S', child: Text('S')),
                      DropdownMenuItem(value: 'M', child: Text('M')),
                      DropdownMenuItem(value: 'L', child: Text('L')),
                      DropdownMenuItem(value: 'XL', child: Text('XL')),
                      DropdownMenuItem(value: 'XXL', child: Text('XXL')),
                    ],
                    onChanged: (value) => setState(() => talla = value ?? 'M'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Fila 5: Categoría (completa)
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Categoría',
                border: OutlineInputBorder(),
                hintText: 'Ej: Masculino · De 30 a 39 años',
              ),
              validator: (value) {
                if (value?.isEmpty ?? true) return 'Requerido';
                return null;
              },
              onChanged: (value) => categoria = value,
            ),
            const SizedBox(height: 12),
            // Fila 6: Celular y Email
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: celularController,
                    decoration: const InputDecoration(
                      labelText: 'Celular',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value?.isEmpty ?? true) return 'Requerido';
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value?.isEmpty ?? true) return 'Requerido';
                      if (!value!.contains('@')) return 'Email inválido';
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Fila 7: Ciudad
            TextFormField(
              controller: ciudadController,
              decoration: const InputDecoration(
                labelText: 'Ciudad',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value?.isEmpty ?? true) return 'Requerido';
                return null;
              },
            ),
            const SizedBox(height: 12),
            // Fila 8: Contacto de Emergencia
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: emergenciaNombreController,
                    decoration: const InputDecoration(
                      labelText: 'Nombre Emergencia',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value?.isEmpty ?? true) return 'Requerido';
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: emergenciaCelularController,
                    decoration: const InputDecoration(
                      labelText: 'Celular Emergencia',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value?.isEmpty ?? true) return 'Requerido';
                      return null;
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFacturacionForm() {
    return Form(
      key: formKeyFacturacion,
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Fila 1: Tipo de Documento y Número
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: DropdownButtonFormField<String>(
                    value: factTipoDocumento,
                    decoration: const InputDecoration(
                      labelText: 'Tipo de Documento',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'C', child: Text('Cédula')),
                      DropdownMenuItem(value: 'P', child: Text('Pasaporte')),
                      DropdownMenuItem(value: 'R', child: Text('RUC')),
                    ],
                    onChanged: (value) =>
                        setState(() => factTipoDocumento = value ?? 'C'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    controller: numeroDocFacturacionController,
                    decoration: const InputDecoration(
                      labelText: 'Número de Documento',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value?.isEmpty ?? true) return 'Requerido';
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Fila 2: Nombre y Apellido
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: nombreFacturacionController,
                    decoration: const InputDecoration(
                      labelText: 'Nombre',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value?.isEmpty ?? true) return 'Requerido';
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: apellidoFacturacionController,
                    decoration: const InputDecoration(
                      labelText: 'Apellido',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value?.isEmpty ?? true) return 'Requerido';
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Fila 3: Email y Teléfono
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: emailFacturacionController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value?.isEmpty ?? true) return 'Requerido';
                      if (!value!.contains('@')) return 'Email inválido';
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: telefonoFacturacionController,
                    decoration: const InputDecoration(
                      labelText: 'Teléfono',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value?.isEmpty ?? true) return 'Requerido';
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Fila 4: Dirección (completa)
            TextFormField(
              controller: direccionFacturacionController,
              decoration: const InputDecoration(
                labelText: 'Dirección',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value?.isEmpty ?? true) return 'Requerido';
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => fechaNacimiento = picked);
    }
  }

  void _submitForm() {
    _enviarInscripcion();
  }

  Future<void> _enviarInscripcion() async {
    // Mostrar diálogo de carga
    if (!mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 16),
              Text('Enviando inscripción...'),
            ],
          ),
        );
      },
    );

    try {
      // Generar UUID para idempotency_key
      const uuid = Uuid();
      String idempotencyKey = uuid.v4();

      // Construir el JSON
      final Map<String, dynamic> jsonData = {
        "idempotency_key": idempotencyKey,
        "checkout": "p2p",
        "tipo_inscripcion_id": 1,
        "forma_pago_id": 5,
        "participante": {
          "nombres": nombresController.text,
          "apellidos": apellidosController.text,
          "tipo_documento": tipoDocumento,
          "numero_documento": numeroDocumentoController.text,
          "fecha_nacimiento": fechaNacimiento != null
              ? '${fechaNacimiento!.year}-${fechaNacimiento!.month.toString().padLeft(2, '0')}-${fechaNacimiento!.day.toString().padLeft(2, '0')}'
              : '',
          "genero": genero,
          "nacionalidad": nacionalidad,
          "categoria": categoria,
          "talla": talla,
          "celular": celularController.text,
          "email": emailController.text,
          "ciudad": ciudadController.text,
          "emergencia_nombre": emergenciaNombreController.text,
          "emergencia_celular": emergenciaCelularController.text,
        },
        "facturacion": {
          "fact_tipo_documento": factTipoDocumento,
          "numero_doc_facturacion": numeroDocFacturacionController.text,
          "nombre_facturacion": nombreFacturacionController.text,
          "apellido_facturacion": apellidoFacturacionController.text,
          "email_facturacion": emailFacturacionController.text,
          "direccion_facturacion": direccionFacturacionController.text,
          "telefono_facturacion": telefonoFacturacionController.text,
        },
        "pago": {
          "referencia": "APP-TEST",
        }
      };

      // Hacer la llamada HTTP
      final response = await http.post(
        Uri.parse('https://quito15k.com/api/inscripciones'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(jsonData),
      );

      // Cerrar diálogo de carga
      if (!mounted) return;
      Navigator.pop(context);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        if (responseData['success'] == true) {
          final data = responseData['data'];
          
          // Verificar si hay URL de checkout
          if (data['checkout'] != null && data['checkout']['url'] != null) {
            if (!mounted) return;
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CheckoutScreen(
                  checkoutUrl: data['checkout']['url'],
                  inscripcionData: data,
                ),
              ),
            );
          } else {
            // Mostrar diálogo de éxito sin checkout
            if (!mounted) return;
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('¡Éxito!'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Inscripción completada correctamente'),
                      const SizedBox(height: 12),
                      Text('ID Inscripción: ${data['inscripcion_id']}'),
                      Text('ID Participante: ${data['participante_id']}'),
                      Text('ID Transacción: ${data['transaccion_id']}'),
                      Text('Total: \$${data['total']}'),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('OK'),
                    ),
                  ],
                );
              },
            );
          }
        } else {
          _mostrarError(context, 'Error: ${responseData['message'] ?? 'Error desconocido'}');
        }
      } else {
        _mostrarError(context, 'Error HTTP ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context);
      _mostrarError(context, 'Error de conexión: $e');
    }
  }

  void _mostrarError(BuildContext context, String mensaje) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(mensaje),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    nombresController.dispose();
    apellidosController.dispose();
    numeroDocumentoController.dispose();
    celularController.dispose();
    emailController.dispose();
    ciudadController.dispose();
    emergenciaNombreController.dispose();
    emergenciaCelularController.dispose();
    numeroDocFacturacionController.dispose();
    nombreFacturacionController.dispose();
    apellidoFacturacionController.dispose();
    emailFacturacionController.dispose();
    direccionFacturacionController.dispose();
    telefonoFacturacionController.dispose();
    super.dispose();
  }
}

class CheckoutScreen extends StatefulWidget {
  final String checkoutUrl;
  final Map<String, dynamic> inscripcionData;

  const CheckoutScreen({
    super.key,
    required this.checkoutUrl,
    required this.inscripcionData,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  late WebViewController _webViewController;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  void _initializeWebView() {
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() => _isLoading = true);
          },
          onPageFinished: (String url) {
            setState(() => _isLoading = false);
          },
          onWebResourceError: (WebResourceError error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error de carga: ${error.description}'),
              ),
            );
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.checkoutUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Realizar Pago'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _webViewController),
          if (_isLoading)
            Container(
              color: Colors.black26,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
