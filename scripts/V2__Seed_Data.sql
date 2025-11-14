
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
(1, 'Control anual de presión intraocular', '2023-01-15', 1),
(1, 'Aumento de moscas volantes OD', '2023-06-22', 1),
(1, 'Revisión de campo visual', '2024-02-10', 1),
(2, 'Dolor ocular con lentes de contacto', '2023-03-08', 1),
(2, 'Seguimiento de ojo seco', '2023-09-14', 1),
(2, 'Cambio de graduación', '2024-01-05', 1),
(3, 'Fondo de ojo anual (diabetes)', '2023-02-20', 1),
(3, 'Visión borrosa persistente', '2023-11-30', 1),
(4, 'Evaluación de topografía corneal', '2023-04-12', 1),
(4, 'Picor ocular intenso', '2023-08-17', 1),
(5, 'Irritación ocular por exposición solar', '2023-05-25', 1),
(5, 'Crecimiento de pterigión OD', '2024-03-18', 1),
(6, 'Fatiga visual por estudio', '2023-07-07', 1),
(6, 'Control de hipermetropía', '2024-01-22', 1),
(7, 'Dificultad para visión nocturna', '2023-10-11', 1),
(8, 'Ojo rojo recurrente', '2023-12-05', 1);

-- ============================================================================
-- RESPUESTAS_CUESTIONARIOS (JSON RESPUESTAS)
-- ============================================================================
INSERT INTO respuestas_cuestionarios (consulta_id, cuestionario_id, respuestas) VALUES
(1, 1, '{
  "Agudeza Visual sin lentes": {"value": {"OD": 20, "OI": 20}, "comment": "Sin observaciones"},
  "Agudeza Visual con lentes": {"value": {"OD": 20, "OI": 20}, "comment": "Buena respuesta"},
  "Presión Intraocular": {"value": {"OD": 16.5, "OI": 15.0}, "comment": "Normal"},
  "Dolor": {"value": false, "comment": "Sin dolor"}
}'),
(2, 1, '{
  "Agudeza Visual sin lentes": {"value": {"OD": 40, "OI": 20}, "comment": "Desbalance OD"},
  "Agudeza Visual con lentes": {"value": {"OD": 20, "OI": 20}, "comment": "Corrige adecuadamente"},
  "Presión Intraocular": {"value": {"OD": 14.0, "OI": 15.5}, "comment": "Presión baja"},
  "Dolor": {"value": true, "comment": "Molestia leve"}
}'),
(3, 1, '{
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

INSERT INTO roles (nombre, descripcion) VALUES
('medico', 'Rol de medico: Tiene todos los permisos de manejo del programa'),
('secretario', 'Rol de secretario: Tiene los permisos que el medico designe'),
('admin', 'Superusuario del sistema: Tiene todos los permisos por defecto');

INSERT INTO permisos (nombre, descripcion) VALUES
('ver-horarios', 'Permite visualizar los horarios laborales'),
('editar-horarios', 'Permite modificar los horarios laborales o especiales'),
('manejar-usuarios', 'Permite registrar y manejar usuarios dentro del sistema'),
('ver-consultas', 'Permite ver consultas, al igual que sus tratamientos y diagnosticos'),
('manejar-consultas', 'Permite manejar consultas, al igual que sus tratamientos y diagnosticos'),
('ver-examenes', 'Permite ver examenes, al igual que descargar sus archivos adjuntos'),
('manejar-examenes', 'Permite editar examenes y subir archivos adjuntos'),
('ver-pacientes', 'Permite ver datos de pacientes, incluyendo historial medico'),
('manejar-pacientes', 'Permite manejar pacientes, incluyendo historial medico'),
('ver-cuestionarios', 'Permite ver los cuestionarios activos'),
('manejar-cuestionarios', 'Permite modificar los cuestionarios'),
('ver-citas', 'Permite ver informacion sobre citas'),
('manejar-citas', 'Permite editar, actualizar y agendar citas'),
('manejar-roles', 'Permite modificar los permisos de cada rol');

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
(3, 11),
(3, 12),
(3, 13),
(3, 14);

-- ============================================================================
-- CITAS
-- ============================================================================


INSERT INTO citas (paciente_id, nombre, fecha, duracion) VALUES
(5, (SELECT nombre FROM pacientes WHERE id = 5), '2025-11-10 09:00:00-06', 1200),
(6, (SELECT nombre FROM pacientes WHERE id = 6), '2025-11-10 09:20:00-06', 1200),
(7, (SELECT nombre FROM pacientes WHERE id = 7), '2025-11-10 09:40:00-06', 1200),
(8, (SELECT nombre FROM pacientes WHERE id = 8), '2025-11-10 10:00:00-06', 1200),

(5, (SELECT nombre FROM pacientes WHERE id = 5), '2025-11-10 15:00:00-06', 1200),
(6, (SELECT nombre FROM pacientes WHERE id = 6), '2025-11-10 15:20:00-06', 1200),
(7, (SELECT nombre FROM pacientes WHERE id = 7), '2025-11-10 15:40:00-06', 1200),
(8, (SELECT nombre FROM pacientes WHERE id = 8), '2025-11-10 16:00:00-06', 1200),
-- 📅 Tue, Nov 11 2025
(1, (SELECT nombre FROM pacientes WHERE id = 1), '2025-11-11 09:00:00-06', 1200),
(2, (SELECT nombre FROM pacientes WHERE id = 2), '2025-11-11 09:20:00-06', 1200),
(3, (SELECT nombre FROM pacientes WHERE id = 3), '2025-11-11 09:40:00-06', 1200),
(4, (SELECT nombre FROM pacientes WHERE id = 4), '2025-11-11 10:00:00-06', 1200),
(1, (SELECT nombre FROM pacientes WHERE id = 1), '2025-11-11 15:00:00-06', 1200),
(2, (SELECT nombre FROM pacientes WHERE id = 2), '2025-11-11 15:20:00-06', 1200),
(3, (SELECT nombre FROM pacientes WHERE id = 3), '2025-11-11 15:40:00-06', 1200),
(4, (SELECT nombre FROM pacientes WHERE id = 4), '2025-11-11 16:00:00-06', 1200),

-- 📅 Wed, Nov 12 2025
(1, (SELECT nombre FROM pacientes WHERE id = 1), '2025-11-12 09:00:00-06', 1200),
(3, (SELECT nombre FROM pacientes WHERE id = 3), '2025-11-12 09:20:00-06', 1200),
(2, (SELECT nombre FROM pacientes WHERE id = 2), '2025-11-12 09:40:00-06', 1200),
(4, (SELECT nombre FROM pacientes WHERE id = 4), '2025-11-12 10:00:00-06', 1200),
(1, (SELECT nombre FROM pacientes WHERE id = 1), '2025-11-12 15:00:00-06', 1200),
(2, (SELECT nombre FROM pacientes WHERE id = 2), '2025-11-12 15:20:00-06', 1200),
(3, (SELECT nombre FROM pacientes WHERE id = 3), '2025-11-12 15:40:00-06', 1200),
(4, (SELECT nombre FROM pacientes WHERE id = 4), '2025-11-12 16:00:00-06', 1200),

-- 📅 Thu, Nov 13 2025
(2, (SELECT nombre FROM pacientes WHERE id = 2), '2025-11-13 09:00:00-06', 1200),
(3, (SELECT nombre FROM pacientes WHERE id = 3), '2025-11-13 09:20:00-06', 1200),
(4, (SELECT nombre FROM pacientes WHERE id = 4), '2025-11-13 09:40:00-06', 1200),
(1, (SELECT nombre FROM pacientes WHERE id = 1), '2025-11-13 10:00:00-06', 1200),
(2, (SELECT nombre FROM pacientes WHERE id = 2), '2025-11-13 15:00:00-06', 1200),
(3, (SELECT nombre FROM pacientes WHERE id = 3), '2025-11-13 15:20:00-06', 1200),
(4, (SELECT nombre FROM pacientes WHERE id = 4), '2025-11-13 15:40:00-06', 1200),
(1, (SELECT nombre FROM pacientes WHERE id = 1), '2025-11-13 16:00:00-06', 1200),

-- 📅 Fri, Nov 14 2025
(1, (SELECT nombre FROM pacientes WHERE id = 1), '2025-11-14 09:00:00-06', 1200),
(2, (SELECT nombre FROM pacientes WHERE id = 2), '2025-11-14 09:20:00-06', 1200),
(3, (SELECT nombre FROM pacientes WHERE id = 3), '2025-11-14 09:40:00-06', 1200),
(4, (SELECT nombre FROM pacientes WHERE id = 4), '2025-11-14 10:00:00-06', 1200),
(2, (SELECT nombre FROM pacientes WHERE id = 2), '2025-11-14 15:00:00-06', 1200),
(3, (SELECT nombre FROM pacientes WHERE id = 3), '2025-11-14 15:20:00-06', 1200),
(4, (SELECT nombre FROM pacientes WHERE id = 4), '2025-11-14 15:40:00-06', 1200),
(1, (SELECT nombre FROM pacientes WHERE id = 1), '2025-11-14 16:00:00-06', 1200),

-- 📅 Sat, Nov 15 2025
(1, (SELECT nombre FROM pacientes WHERE id = 1), '2025-11-15 09:00:00-06', 1200),
(2, (SELECT nombre FROM pacientes WHERE id = 2), '2025-11-15 09:20:00-06', 1200),
(3, (SELECT nombre FROM pacientes WHERE id = 3), '2025-11-15 09:40:00-06', 1200),
(4, (SELECT nombre FROM pacientes WHERE id = 4), '2025-11-15 10:00:00-06', 1200),
(1, (SELECT nombre FROM pacientes WHERE id = 1), '2025-11-15 10:20:00-06', 1200),
(2, (SELECT nombre FROM pacientes WHERE id = 2), '2025-11-15 10:40:00-06', 1200),
(3, (SELECT nombre FROM pacientes WHERE id = 3), '2025-11-15 11:00:00-06', 1200),
(4, (SELECT nombre FROM pacientes WHERE id = 4), '2025-11-15 11:20:00-06', 1200),

-- 📅 Mon, Nov 17 2025
(1, (SELECT nombre FROM pacientes WHERE id = 1), '2025-11-17 09:00:00-06', 1200),
(2, (SELECT nombre FROM pacientes WHERE id = 2), '2025-11-17 09:20:00-06', 1200),
(3, (SELECT nombre FROM pacientes WHERE id = 3), '2025-11-17 09:40:00-06', 1200),
(4, (SELECT nombre FROM pacientes WHERE id = 4), '2025-11-17 10:00:00-06', 1200),
(2, (SELECT nombre FROM pacientes WHERE id = 2), '2025-11-17 15:00:00-06', 1200),
(3, (SELECT nombre FROM pacientes WHERE id = 3), '2025-11-17 15:20:00-06', 1200),
(4, (SELECT nombre FROM pacientes WHERE id = 4), '2025-11-17 15:40:00-06', 1200),
(1, (SELECT nombre FROM pacientes WHERE id = 1), '2025-11-17 16:00:00-06', 1200),

-- 📅 Tue, Nov 18 2025
(1, (SELECT nombre FROM pacientes WHERE id = 1), '2025-11-18 09:00:00-06', 1200),
(2, (SELECT nombre FROM pacientes WHERE id = 2), '2025-11-18 09:20:00-06', 1200),
(3, (SELECT nombre FROM pacientes WHERE id = 3), '2025-11-18 09:40:00-06', 1200),
(4, (SELECT nombre FROM pacientes WHERE id = 4), '2025-11-18 10:00:00-06', 1200),
(2, (SELECT nombre FROM pacientes WHERE id = 2), '2025-11-18 15:00:00-06', 1200),
(3, (SELECT nombre FROM pacientes WHERE id = 3), '2025-11-18 15:20:00-06', 1200),
(4, (SELECT nombre FROM pacientes WHERE id = 4), '2025-11-18 15:40:00-06', 1200),
(1, (SELECT nombre FROM pacientes WHERE id = 1), '2025-11-18 16:00:00-06', 1200),

-- 📅 Wed, Nov 19 2025
(1, (SELECT nombre FROM pacientes WHERE id = 1), '2025-11-19 09:00:00-06', 1200),
(2, (SELECT nombre FROM pacientes WHERE id = 2), '2025-11-19 09:20:00-06', 1200),
(3, (SELECT nombre FROM pacientes WHERE id = 3), '2025-11-19 09:40:00-06', 1200),
(4, (SELECT nombre FROM pacientes WHERE id = 4), '2025-11-19 10:00:00-06', 1200),
(2, (SELECT nombre FROM pacientes WHERE id = 2), '2025-11-19 15:00:00-06', 1200),
(3, (SELECT nombre FROM pacientes WHERE id = 3), '2025-11-19 15:20:00-06', 1200),
(4, (SELECT nombre FROM pacientes WHERE id = 4), '2025-11-19 15:40:00-06', 1200),
(1, (SELECT nombre FROM pacientes WHERE id = 1), '2025-11-19 16:00:00-06', 1200),

-- 📅 Thu, Nov 20 2025
(1, (SELECT nombre FROM pacientes WHERE id = 1), '2025-11-20 09:00:00-06', 1200),
(2, (SELECT nombre FROM pacientes WHERE id = 2), '2025-11-20 09:20:00-06', 1200),
(3, (SELECT nombre FROM pacientes WHERE id = 3), '2025-11-20 09:40:00-06', 1200),
(4, (SELECT nombre FROM pacientes WHERE id = 4), '2025-11-20 10:00:00-06', 1200),
(2, (SELECT nombre FROM pacientes WHERE id = 2), '2025-11-20 15:00:00-06', 1200),
(3, (SELECT nombre FROM pacientes WHERE id = 3), '2025-11-20 15:20:00-06', 1200),
(4, (SELECT nombre FROM pacientes WHERE id = 4), '2025-11-20 15:40:00-06', 1200),
(1, (SELECT nombre FROM pacientes WHERE id = 1), '2025-11-20 16:00:00-06', 1200),

-- 📅 Fri, Nov 21 2025
(1, (SELECT nombre FROM pacientes WHERE id = 1), '2025-11-21 09:00:00-06', 1200),
(2, (SELECT nombre FROM pacientes WHERE id = 2), '2025-11-21 09:20:00-06', 1200),
(3, (SELECT nombre FROM pacientes WHERE id = 3), '2025-11-21 09:40:00-06', 1200),
(4, (SELECT nombre FROM pacientes WHERE id = 4), '2025-11-21 10:00:00-06', 1200),
(2, (SELECT nombre FROM pacientes WHERE id = 2), '2025-11-21 15:00:00-06', 1200),
(3, (SELECT nombre FROM pacientes WHERE id = 3), '2025-11-21 15:20:00-06', 1200),
(4, (SELECT nombre FROM pacientes WHERE id = 4), '2025-11-21 15:40:00-06', 1200),
(1, (SELECT nombre FROM pacientes WHERE id = 1), '2025-11-21 16:00:00-06', 1200),

-- 📅 Sat, Nov 22 2025
(1, (SELECT nombre FROM pacientes WHERE id = 1), '2025-11-22 09:00:00-06', 1200),
(2, (SELECT nombre FROM pacientes WHERE id = 2), '2025-11-22 09:20:00-06', 1200),
(3, (SELECT nombre FROM pacientes WHERE id = 3), '2025-11-22 09:40:00-06', 1200),
(4, (SELECT nombre FROM pacientes WHERE id = 4), '2025-11-22 10:00:00-06', 1200),
(1, (SELECT nombre FROM pacientes WHERE id = 1), '2025-11-22 10:20:00-06', 1200),
(2, (SELECT nombre FROM pacientes WHERE id = 2), '2025-11-22 10:40:00-06', 1200),
(3, (SELECT nombre FROM pacientes WHERE id = 3), '2025-11-22 11:00:00-06', 1200),
(4, (SELECT nombre FROM pacientes WHERE id = 4), '2025-11-22 11:20:00-06', 1200);

-- ============================================================================
-- HORARIOS
-- ============================================================================

INSERT INTO horarios_laborales (
    dia_semana,
    hora_apertura,
    hora_cierre,
    abierto,
    valid_from,
    valid_to
) VALUES
    -- Monday
    (1, '09:00:00', '13:00:00', TRUE, '2000-01-01', '9999-12-31'),
    (1, '15:00:00', '18:00:00', TRUE, '2000-01-01', '9999-12-31'),

    -- Tuesday
    (2, '09:00:00', '13:00:00', TRUE, '2000-01-01', '9999-12-31'),
    (2, '15:00:00', '18:00:00', TRUE, '2000-01-01', '9999-12-31'),

    -- Wednesday
    (3, '09:00:00', '13:00:00', TRUE, '2000-01-01', '9999-12-31'),
    (3, '15:00:00', '18:00:00', TRUE, '2000-01-01', '9999-12-31'),

    -- Thursday
    (4, '09:00:00', '13:00:00', TRUE, '2000-01-01', '9999-12-31'),
    (4, '15:00:00', '18:00:00', TRUE, '2000-01-01', '9999-12-31'),

    -- Friday
    (5, '09:00:00', '13:00:00', TRUE, '2000-01-01', '9999-12-31'),
    (5, '15:00:00', '18:00:00', TRUE, '2000-01-01', '9999-12-31'),

    -- Saturday
    (6, '09:00:00', '13:00:00', TRUE, '2000-01-01', '9999-12-31'),

    -- Sunday (closed)
    (7, NULL, NULL, FALSE, '2000-01-01', '9999-12-31');
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


