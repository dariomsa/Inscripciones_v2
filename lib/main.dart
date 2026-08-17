import 'package:flutter/material.dart';

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
  final formKey = GlobalKey<FormState>();

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
            if (formKey.currentState!.validate()) {
              setState(() => currentStep = 1);
            }
          } else if (currentStep == 1) {
            if (formKey.currentState!.validate()) {
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
      key: formKey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            TextFormField(
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
            const SizedBox(height: 12),
            TextFormField(
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
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
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
            const SizedBox(height: 12),
            TextFormField(
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
            const SizedBox(height: 12),
            TextFormField(
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
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
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
            const SizedBox(height: 12),
            TextFormField(
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
            const SizedBox(height: 12),
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
            DropdownButtonFormField<String>(
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
            const SizedBox(height: 12),
            TextFormField(
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
            const SizedBox(height: 12),
            TextFormField(
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
            const SizedBox(height: 12),
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
            TextFormField(
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
            const SizedBox(height: 12),
            TextFormField(
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
          ],
        ),
      ),
    );
  }

  Widget _buildFacturacionForm() {
    return Form(
      key: formKey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            DropdownButtonFormField<String>(
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
            const SizedBox(height: 12),
            TextFormField(
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
            const SizedBox(height: 12),
            TextFormField(
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
            const SizedBox(height: 12),
            TextFormField(
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
            const SizedBox(height: 12),
            TextFormField(
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
            const SizedBox(height: 12),
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
            const SizedBox(height: 12),
            TextFormField(
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
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('¡Inscripción completada exitosamente!'),
        backgroundColor: Colors.green,
      ),
    );

    // Aquí puedes enviar los datos a un backend
    print('=== DATOS DEL PARTICIPANTE ===');
    print('Nombres: ${nombresController.text}');
    print('Apellidos: ${apellidosController.text}');
    print('Documento: $tipoDocumento-${numeroDocumentoController.text}');
    print('Email: ${emailController.text}');
    print('Celular: ${celularController.text}');
    print('\n=== DATOS DE FACTURACIÓN ===');
    print('Nombre: ${nombreFacturacionController.text}');
    print('Email: ${emailFacturacionController.text}');
    print('Dirección: ${direccionFacturacionController.text}');
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
