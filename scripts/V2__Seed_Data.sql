
-- ============================================================================
--   HEALTHCARE CRM – DATA INSERTION SCRIPT (with JSON Questionnaires)
-- ============================================================================

-- Idempotency: clear tables safely
SET session_replication_role = replica;

TRUNCATE TABLE
  tratamientos, diagnosticos, examenes, respuestas_cuestionarios, consultas,
  citas, antecedentes, tutores, logs,
  roles_permisos, usuarios_roles, pacientes, usuarios, roles, permisos,
  horarios_laborales, horarios_especiales, cuestionarios
RESTART IDENTITY CASCADE;

SET session_replication_role = DEFAULT;

-- ============================================================================
-- PACIENTES
-- ============================================================================

INSERT INTO pacientes (nombre, fecha_nacimiento, telefono, sexo) VALUES
('Juan Pérez Martínez', '1985-03-15', '5551234567', 'Masculino'),
('María González López', '1990-07-22', '5552345678', 'Femenino'),
('Carlos Sánchez Díaz', '1980-12-10', '5553456789', 'Masculino'),
('Ana Fernández Ruiz', '1995-06-18', '5554567890', 'Femenino'),
('Pedro Ramírez Vázquez', '1987-09-25', '5555678901', 'Masculino'),
('Laura Gómez Hernández', '2000-01-30', '5556789012', 'Femenino'),
('José Gutiérrez Castro', '1978-11-12', '5557890123', 'Masculino'),
('Andrea Torres Mendoza', '1992-05-27', '5558901234', 'Femenino'),
('Miguel Rodríguez Silva', '1983-04-05', '5559012345', 'Masculino'),
('Sofía Castillo Ríos', '1998-08-14', '5550123456', 'Femenino');

INSERT INTO pacientes (nombre, fecha_nacimiento, sexo) VALUES
('Sofía Ramírez Mendoza', '2018-05-12', 'Femenino'),
('Diego Morales Castro', '2016-11-03', 'Masculino'),
('Valentina Herrera Luna', '2019-02-28', 'Femenino'),
('Mateo Navarro Ríos', '2015-07-15', 'Masculino'),
('Renata Delgado Fuentes', '2010-09-21', 'Femenino'),
('Joaquín Paredes León', '2009-04-05', 'Masculino'),
('Lucía Espinoza Vega', '2007-12-10', 'Femenino'),
('Elena Mendoza Soto', '2012-08-17', 'Femenino'),
('Adrián Rojas Campos', '2006-06-22', 'Masculino');

-- ============================================================================
-- TUTORES
-- ============================================================================

INSERT INTO tutores (paciente_id, nombre, telefono, parentesco, es_contacto_principal) VALUES
(11, 'Mariana Mendoza López', '5551122334', 'Madre', true),
(11, 'Alejandro Ramírez Pérez', '5551122335', 'Padre', false),
(12, 'Isabel Castro Méndez', '5552233445', 'Madre', true),
(13, 'Roberto Luna Díaz', '5553344556', 'Padre', true),
(13, 'Carolina Herrera Vázquez', '5553344557', 'Madre', false),
(14, 'Fernando Navarro Gómez', '5554455667', 'Padre', true),
(15, 'Patricia Fuentes Reyes', '5555566778', 'Madre', true),
(15, 'Ricardo Delgado Moreno', '5555566779', 'Padre', false),
(16, 'Gabriela León Castillo', '5556677889', 'Madre', true),
(17, 'María Vega Ortega', '5557788990', 'Madre', true),
(17, 'Jorge Espinoza Ríos', '5557788991', 'Padre', false),
(18, 'Carmen Soto Jiménez', '5559900112', 'Madre', true),
(19, 'Leticia Campos Navarro', '5550011223', 'Madre', true);

-- ============================================================================
-- ANTECEDENTES
-- ============================================================================

INSERT INTO antecedentes (paciente_id, medicos, familiares, oculares, alergicos, otros) VALUES
(1, 'Hipertensión controlada', 'Abuelo con glaucoma', 'Miopía -5.00 OD/OI desde los 20 años', 'Penicilina', 'Fumador ocasional'),
(2, 'Migrañas frecuentes', 'Madre con degeneración macular', 'Ojo seco moderado', 'Ninguna conocida', 'Usuaria de lentes de contacto'),
(3, 'Diabetes tipo 2', 'Padre y tío con retinopatía diabética', 'Catarata incipiente OD', 'Sulfas', 'Trabaja con pantallas 10h/día'),
(4, 'Asma leve', 'Hermana con queratocono', 'Astigmatismo -2.50 OD/OI', 'Ácaros del polvo', 'Alérgica a mascotas'),
(5, 'Colesterol alto', 'Abuela con DMAE', 'Pterigión nasal OD', 'Mariscos', 'Ex-fumador, trabaja al aire libre'),
(6, 'Ninguno', 'Primo con estrabismo', 'Hipermetropía +3.00 OD/OI', 'Ninguna conocida', 'Estudiante de medicina'),
(7, 'Hipertensión, apnea del sueño', 'Madre con catarata precoz a los 50', 'Glaucoma sospecha, PIO 22mmHg OD', 'Polen', 'Chofer profesional'),
(8, 'Artritis reumatoide', 'Abuelo ciego por trauma', 'Uveítis recurrente', 'Antiinflamatorios no esteroideos', 'Vegetariana'),
(9, 'Depresión controlada', 'Familia sin antecedentes oculares', 'Conjuntivitis alérgica estacional', 'Ninguna conocida', 'Trabaja en minería'),
(10, 'Ninguno', 'Padre con desprendimiento de retina', 'Miopía magna -10.00 OD/OI', 'Látex', 'Miope patológica');

-- ============================================================================
-- CUESTIONARIOS (JSON SCHEMA)
-- ============================================================================

INSERT INTO cuestionarios (nombre, version, activo, schema) VALUES
('Consulta', '1.1', true, '{
  "title": "Evaluación Ocular 2025",
  "questions": [
    {
      "label": "Agudeza Visual sin lentes",
      "type": "bilateral",
      "data_type": "int",
      "order": 1
    },
    {
      "label": "Agudeza Visual con lentes",
      "type": "bilateral",
      "data_type": "int",
      "order": 2
    },
    {
      "label": "Presión Intraocular",
      "type": "bilateral",
      "data_type": "float",
      "order": 3
    },
    {
      "label": "Dolor",
      "type": "unilateral",
      "data_type": "bool",
      "order": 4
    }
  ]
}');

-- ============================================================================
-- CONSULTAS
-- ============================================================================

INSERT INTO consultas (paciente_id, motivo, fecha, cuestionario_id) VALUES
(1, 'Control anual de presión intraocular', '2023-01-15', 2),
(1, 'Aumento de moscas volantes OD', '2023-06-22', 2),
(1, 'Revisión de campo visual', '2024-02-10', 2),
(2, 'Dolor ocular con lentes de contacto', '2023-03-08', 2),
(2, 'Seguimiento de ojo seco', '2023-09-14', 2),
(2, 'Cambio de graduación', '2024-01-05', 2),
(3, 'Fondo de ojo anual (diabetes)', '2023-02-20', 2),
(3, 'Visión borrosa persistente', '2023-11-30', 2),
(4, 'Evaluación de topografía corneal', '2023-04-12', 2),
(4, 'Picor ocular intenso', '2023-08-17', 2),
(5, 'Irritación ocular por exposición solar', '2023-05-25', 2),
(5, 'Crecimiento de pterigión OD', '2024-03-18', 2),
(6, 'Fatiga visual por estudio', '2023-07-07', 2),
(6, 'Control de hipermetropía', '2024-01-22', 2),
(7, 'Dificultad para visión nocturna', '2023-10-11', 2),
(8, 'Ojo rojo recurrente', '2023-12-05', 2);

-- ============================================================================
-- RESPUESTAS_CUESTIONARIOS (JSON RESPUESTAS)
-- ============================================================================
INSERT INTO respuestas_cuestionarios (consulta_id, cuestionario_id, respuestas) VALUES
(1, 2, '{
  "Agudeza Visual sin lentes": {"value": {"OD": 20, "OI": 20}, "comment": "Sin observaciones"},
  "Agudeza Visual con lentes": {"value": {"OD": 20, "OI": 20}, "comment": "Buena respuesta"},
  "Presión Intraocular": {"value": {"OD": 16.5, "OI": 15.0}, "comment": "Normal"},
  "Dolor": {"value": false, "comment": "Sin dolor"}
}'),
(2, 2, '{
  "Agudeza Visual sin lentes": {"value": {"OD": 40, "OI": 20}, "comment": "Desbalance OD"},
  "Agudeza Visual con lentes": {"value": {"OD": 20, "OI": 20}, "comment": "Corrige adecuadamente"},
  "Presión Intraocular": {"value": {"OD": 14.0, "OI": 15.5}, "comment": "Presión baja"},
  "Dolor": {"value": true, "comment": "Molestia leve"}
}'),
(3, 2, '{
  "Agudeza Visual sin lentes": {"value": {"OD": 20, "OI": 20}, "comment": ""},
  "Agudeza Visual con lentes": {"value": {"OD": 20, "OI": 20}, "comment": ""},
  "Presión Intraocular": {"value": {"OD": 22.0, "OI": 21.5}, "comment": "Ligeramente elevada"},
  "Dolor": {"value": false, "comment": "Asintomático"}
}');

-- ============================================================================
-- DIAGNOSTICOS
-- ============================================================================

INSERT INTO diagnosticos (nombre, consulta_id, recomendacion) VALUES
('Hipertensión ocular', 1, 'Control cada 6 meses, medición PIO'),
('Desprendimiento vítreo posterior OD', 2, 'Observación, acudir si aumentan moscas volantes o aparecen flashes'),
('Defecto campimétrico superior', 3, 'Repetir campo visual en 3 meses, considerar OCT fibras nervio óptico');

-- ============================================================================
-- TRATAMIENTOS
-- ============================================================================

INSERT INTO tratamientos (nombre, componente_activo, presentacion, dosificacion, tiempo, frecuencia, diagnostico_id) VALUES
('Timoptic', 'Timolol 0.5%', 'Colirio', '1 gota en cada ojo afectado', '6 meses', 'cada 12 horas', 1),
('Systane Ultra', 'Lágrimas artificiales sin conservantes', 'Solución oftálmica', '1 gota en OD cada 4 horas', '3 meses', 'cada 4 horas', 1),
('Seguimiento clínico', 'N/A', 'Consulta de control', 'Revisar en caso de síntomas nuevos', '6 meses', 'sin frecuencia establecida', 2),
('Humphrey 30-2', 'N/A', 'Evaluación campimétrica', 'Repetir campo visual con técnica estandarizada', '3 meses', 'sin frecuencia establecida', 3);

-- ============================================================================
-- USUARIOS / ROLES / PERMISOS
-- ============================================================================

INSERT INTO usuarios (username, password_hash, correo) VALUES
('pcastejon', '1234', 'pcastejon@gmail.com'),
('jmerida', '1234', 'jmerida@gmail.com'),
('jlopez', '1234', 'jlopez@gmail.com');

INSERT INTO roles (nombre, descripcion) VALUES
('medico', 'Rol de medico: Tiene todos los permisos de manejo del programa'),
('secretario', 'Rol de secretario: Tiene los permisos que el medico designe'),
('admin', 'Superusuario del sistema: Tiene todos los permisos por defecto');

INSERT INTO permisos (nombre, descripcion) VALUES
('ver-horarios', 'Permite visualizar los horarios laborales'),
('editar-horarios', 'Permite modificar los horarios laborales o especiales'),
('manejar-usuarios', 'Permite registrar y manejar usuarios dentro del sistema'),
('ver-consultas', 'Permite ver consultas'),
('manejar-consultas', 'Permite manejar consultas'),
('ver-examenes', 'Permite ver examenes'),
('manejar-examenes', 'Permite manejar examenes'),
('ver-pacientes', 'Permite ver datos de pacientes'),
('manejar-pacientes', 'Permite manejar pacientes'),
('ver-cuestionarios', 'Permite ver cuestionarios'),
('manejar-cuestionarios', 'Permite manejar cuestionarios');

INSERT INTO usuarios_roles (usuario_id, rol_id) VALUES
(1, 1),
(2, 3),
(3, 2);

INSERT INTO roles_permisos (rol_id, permiso_id) VALUES
(1, 2),
(1, 3),
(2, 1),
(3, 1),
(3, 2),
(3, 3),
(3, 4),
(3, 5),
(3, 6),
(3, 7),
(3, 8),
(3, 9),
(3, 10),
(3, 11);

-- ============================================================================
-- CITAS
-- ============================================================================

INSERT INTO citas (paciente_id, nombre, fecha, duracion) VALUES
(1, (SELECT nombre FROM pacientes WHERE id = 1), '2025-05-16 09:00:00-06', 1200),
(2, (SELECT nombre FROM pacientes WHERE id = 2), '2025-05-08 15:45:00-06', 1200),
(3, (SELECT nombre FROM pacientes WHERE id = 3), '2025-05-20 16:00:00-06', 1200);

-- ============================================================================
-- HORARIOS
-- ============================================================================

INSERT INTO horarios_laborales (dia_semana, hora_apertura, hora_cierre, abierto) VALUES
(1, '09:00:00', '13:00:00', TRUE),
(2, '09:00:00', '13:00:00', TRUE),
(3, '09:00:00', '13:00:00', TRUE),
(4, '09:00:00', '13:00:00', TRUE),
(5, '09:00:00', '13:00:00', TRUE),
(1, '15:00:00', '18:00:00', TRUE),
(2, '15:00:00', '18:00:00', TRUE),
(3, '15:00:00', '18:00:00', TRUE),
(4, '15:00:00', '18:00:00', TRUE),
(5, '15:00:00', '18:00:00', TRUE),
(6, '09:00:00', '13:00:00', TRUE),
(7, NULL, NULL, FALSE);

INSERT INTO horarios_especiales (fecha, hora_apertura, hora_cierre, abierto) VALUES
('2025-11-04', '09:00:00', '12:00:00', TRUE),
('2025-11-05', NULL, NULL, FALSE),
('2025-11-06', '12:00:00', '13:00:00', TRUE),
('2025-11-06', '15:00:00', '19:00:00', TRUE),
('2025-11-08', '10:00:00', '14:00:00', TRUE),
('2025-11-09', NULL, NULL, FALSE);

-- ============================================================================
-- EXÁMENES
-- ============================================================================

INSERT INTO examenes (paciente_id, consulta_id, tipo, fecha, s3_key, file_size, mime_type) VALUES
(1, 1, 'Tonometría de aire', '2023-01-15', 'examenes/1/20230115_tonometria_aire.pdf', 892640, 'application/pdf'),
(1, 3, 'Campo visual 30-2', '2024-02-10', 'examenes/1/20240210_campo_visual_30_2.pdf', 2458720, 'application/pdf'),
(2, 4, 'Topografía corneal', '2023-03-08', 'examenes/2/20230308_topografia_corneal.pdf', 1572864, 'application/pdf'),
(3, 7, 'Retinografía', '2023-02-20', 'examenes/3/20230220_retinografia.pdf', 1245184, 'application/pdf');

INSERT INTO examenes (paciente_id, tipo, fecha) VALUES
(1, 'Paquimetría', '2025-10-20'),
(2, 'Refracción ciclopléjica', '2025-01-05'),
(3, 'Curva de tensión ocular', '2025-07-01');
