-- Idempotencia del script, vamos a eliminar todos los registros
SET session_replication_role = replica;

TRUNCATE TABLE
  consultas_preguntas, tratamientos, diagnosticos, examenes, consultas,
  citas, preguntas_cuestionarios, antecedentes, tutores, logs,
  roles_permisos, usuarios_roles, pacientes, usuarios,  roles,
  permisos, horarios_laborales, horarios_especiales, preguntas, cuestionarios
RESTART IDENTITY CASCADE;

SET session_replication_role = DEFAULT;
-- Pacientes con número telefónico (Mayores de Edad)
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

-- Pacientes sin numero telefonico (Menores de edad), tambien pueden tener pero
-- para simplificar el script vamos a evitar ese campo
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

-- Tutores de los pacientes menores de edad
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

-- Antecedentes para cada paciente
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
(10, 'Ninguno', 'Padre con desprendimiento de retina', 'Miopía magna -10.00 OD/OI', 'Látex', 'Miope patológica'),
(11, 'Ninguno', 'Hermano con estrabismo', 'Ambliopía OD en tratamiento', 'Huevo', 'En terapia de parche ocular'),
(12, 'Asma infantil', 'Padre con alta miopía', 'Miopía -3.00 OD/OI', 'Ácaros, polvo', 'Usa lentes desde los 5 años'),
(13, 'Prematura (32 semanas)', 'Madre con retinopatía del prematuro', 'Estrabismo convergente alternante', 'Ninguna conocida', 'En control por oftalmopediatría'),
(14, 'Síndrome de Down', 'Sin antecedentes familiares oculares', 'Nistagmo, blefaritis crónica', 'Ninguna conocida', 'Necesidades especiales'),
(15, 'Ninguno', 'Abuela con glaucoma', 'Miopía -1.50 OD/OI progresiva', 'Ninguna conocida', 'Adolescente con mucho uso de pantallas'),
(16, 'Diabetes tipo 1', 'Padre con retinopatía diabética', 'Fondo de ojo normal último control', 'Ninguna conocida', 'Deportista, control anual requerido'),
(17, 'Ninguno', 'Madre con queratocono', 'Topografía corneal normal pero en riesgo', 'Lentes de contacto', 'Adolescente, usa lentes de contacto'),
(18, 'Parálisis cerebral', 'Sin antecedentes familiares', 'Estrabismo divergente, nistagmo', 'Ninguna conocida', 'Requiere atención multidisciplinaria'),
(19, 'Alergias estacionales', 'Padre con alta miopía', 'Miopía -2.00 OD/OI estable', 'Polen, gramíneas', 'Buena adherencia al tratamiento');

-- Cuestionarios, unicamente vamos a almacenar 2 por  motivos demostrativos
INSERT INTO cuestionarios(nombre, version, activo) VALUES
('Consulta', '1.0', false),
('Consulta', '1.1', true);

-- Consultas de pacientes
INSERT INTO consultas (paciente_id, motivo, fecha, cuestionario_id) VALUES
(1, 'Control anual de presión intraocular', '2023-01-15', 1.1),
(1, 'Aumento de moscas volantes OD', '2023-06-22', 1.1),
(1, 'Revisión de campo visual', '2024-02-10', 1.1),
(2, 'Dolor ocular con lentes de contacto', '2023-03-08', 1.1),
(2, 'Seguimiento de ojo seco', '2023-09-14', 1.1),
(2, 'Cambio de graduación', '2024-01-05', 1.1),
(3, 'Fondo de ojo anual (diabetes)', '2023-02-20', 1.1),
(3, 'Visión borrosa persistente', '2023-11-30', 1.1),
(4, 'Evaluación de topografía corneal', '2023-04-12', 1.1),
(4, 'Picor ocular intenso', '2023-08-17', 1.1),
(5, 'Irritación ocular por exposición solar', '2023-05-25', 1.1),
(5, 'Crecimiento de pterigión OD', '2024-03-18', 1.1),
(6, 'Fatiga visual por estudio', '2023-07-07', 1.1),
(6, 'Control de hipermetropía', '2024-01-22', 1.1),
(7, 'Dificultad para visión nocturna', '2023-10-11', 1.1),
(8, 'Ojo rojo recurrente', '2023-12-05', 1.1);

-- Diagnosticos para cada consulta
INSERT INTO diagnosticos (nombre, consulta_id, recomendacion) VALUES
('Hipertensión ocular', 1, 'Control cada 6 meses, medición PIO'),
('Desprendimiento vítreo posterior OD', 2, 'Observación, acudir si aumentan moscas volantes o aparecen flashes'),
('Defecto campimétrico superior', 3, 'Repetir campo visual en 3 meses, considerar OCT fibras nervio óptico'),
('Úlcera corneal por lentes de contacto', 4, 'Suspender lentes, tratamiento con antibiótico tópico'),
('Síndrome de ojo seco severo', 5, 'Lágrimas artificiales sin conservantes cada 2 horas, omega-3 oral'),
('Miopía progresiva -1.50', 6, 'Cambio de lentes, control anual'),
('Retinopatía diabética no proliferativa', 7, 'Control trimestral, optimizar control glucémico'),
('Edema macular diabético incipiente', 8, 'Angiografía fluoresceínica, considerar anti-VEGF'),
('Astigmatismo irregular', 9, 'Topografía serial cada 6 meses, excluir queratocono'),
('Conjuntivitis alérgica severa', 10, 'Antihistamínicos tópicos, compresas frías'),
('Queratitis actínica', 11, 'Lubricantes intensivos, gafas de sol UV400'),
('Pterigión grado II OD', 12, 'Cirugía de escisión con injerto conjuntival'),
('Asthenopia acomodativa', 13, 'Regla 20-20-20, lentes con filtro azul'),
('Hipermetropía latente +2.75', 14, 'Lentes correctivos permanentes'),
('Nictalopia por deficiencia vitamina A', 15, 'Suplementos vitamínicos, revisar dieta'),
('Uveítis anterior recurrente', 16, 'Corticoides tópicos, dilatación pupilar');



-- Usuarios del programa
INSERT INTO usuarios (username, password_hash, correo) VALUES
('pcastejon', '1234', 'pcastejon@gmail.com'),
('jmerida', '1234', 'jmerida@gmail.com'),
('jlopez', '1234', 'jlopez@gmail.com'),
('admin', '$2a$05$cAi/7N7qcV/O58.JPbOVzuPSAfBa0r0UJHSoMJud8Z.Hh0GM80Tri', 'admin@gmail.com');

-- Roles
INSERT INTO roles (nombre, descripcion) VALUES
('medico', 'desc'),
('secretario', 'desc'),
('admin', 'desc');

-- Permisos
INSERT INTO permisos (nombre, descripcion) VALUES
('gestion_usuarios', 'Crear y editar usuarios y roles'),
('gestion_pacientes', 'Administrar registros de pacientes'),
('gestion_citas', 'Administrar citas');

-- Usuarios - Roles
INSERT INTO usuarios_roles (usuario_id, rol_id) VALUES
(1, 1),
(2, 3),
(3, 2);

-- Roles - permisos
INSERT INTO roles_permisos (rol_id, permiso_id) VALUES
(1, 2),
(1, 3),
(2, 2),
(3, 1),
(3, 2),
(3, 3);

-- Preguntas de los cuestionarios
INSERT INTO preguntas (nombre, tipo, bilateral) VALUES
('AV sin lentes', 'entero', true),
('AV con lentes', 'entero', true),
('Presion Ocular', 'float', true),
('Dolor', 'bool', false);

-- Tabla de cruce para preguntas y cuestionarios
INSERT INTO preguntas_cuestionarios (cuestionario_id, pregunta_id, orden) VALUES
(1, 1, 1),
(1, 2, 2),
(1, 3, 3),
(2, 1, 1),
(2, 2, 2),
(2, 3, 3),
(2, 4, 4);

-- Respuestas para consultas_preguntas (versión simplificada)
INSERT INTO consultas_preguntas (consulta_id, pregunta_id, valores_enteros, valor_booleano, comentario) VALUES
(1, 1, ARRAY[20, 20], NULL, 'AV normal'),
(1, 2, ARRAY[20, 20], NULL, NULL),
(1, 3, ARRAY[16.5, 15.0], NULL, 'PIO normal'),
(1, 4, NULL, false, 'Sin dolor'),
(2, 1, ARRAY[40, 20], NULL, 'OD disminuida'),
(2, 2, ARRAY[20, 20], NULL, NULL),
(2, 3, ARRAY[14.0, 15.5], NULL, NULL),
(2, 4, NULL, true, 'Molestias OD'),
(3, 1, ARRAY[20, 20], NULL, NULL),
(3, 2, ARRAY[20, 20], NULL, NULL),
(3, 3, ARRAY[22.0, 21.5], NULL, 'PIO elevada'),
(3, 4, NULL, false, NULL),
(4, 1, ARRAY[30, 25], NULL, NULL),
(4, 2, ARRAY[20, 20], NULL, NULL),
(4, 3, ARRAY[12.0, 13.0], NULL, NULL),
(4, 4, NULL, true, 'OD irritado'),
(5, 1, ARRAY[20, 20], NULL, NULL),
(5, 2, ARRAY[20, 20], NULL, NULL),
(5, 3, ARRAY[14.0, 14.5], NULL, NULL),
(5, 4, NULL, true, 'Ojo seco'),
(6, 1, ARRAY[50, 40], NULL, 'AV disminuida'),
(6, 2, ARRAY[20, 20], NULL, NULL),
(6, 3, ARRAY[15.0, 16.0], NULL, NULL),
(6, 4, NULL, false, NULL),
(7, 1, ARRAY[25, 25], NULL, NULL),
(7, 2, ARRAY[20, 20], NULL, NULL),
(7, 3, ARRAY[19.0, 18.5], NULL, NULL),
(7, 4, NULL, false, NULL),
(8, 1, ARRAY[60, 60], NULL, 'AV muy baja'),
(8, 2, ARRAY[40, 40], NULL, NULL),
(8, 3, ARRAY[21.0, 22.0], NULL, 'PIO elevada'),
(8, 4, NULL, true, 'Queja principal'),
(9, 1, ARRAY[20, 20], NULL, NULL),
(9, 2, ARRAY[20, 20], NULL, NULL),
(9, 3, ARRAY[10.5, 11.0], NULL, 'PIO baja'),
(9, 4, NULL, false, NULL),
(10, 1, ARRAY[20, 20], NULL, NULL),
(10, 2, ARRAY[20, 20], NULL, NULL),
(10, 3, ARRAY[14.0, 14.0], NULL, NULL),
(10, 4, NULL, true, 'Alérgico'),
(11, 1, ARRAY[30, 30], NULL, NULL),
(11, 2, ARRAY[20, 20], NULL, NULL),
(11, 3, ARRAY[13.0, 13.0], NULL, NULL),
(11, 4, NULL, true, 'Queratitis'),
(12, 1, ARRAY[25, 20], NULL, 'OD afectado'),
(12, 2, ARRAY[20, 20], NULL, NULL),
(12, 3, ARRAY[14.0, 14.0], NULL, NULL),
(12, 4, NULL, true, 'Pterigión'),
(13, 1, ARRAY[40, 40], NULL, NULL),
(13, 2, ARRAY[20, 20], NULL, NULL),
(13, 3, ARRAY[15.0, 15.0], NULL, NULL),
(13, 4, NULL, true, 'Asthenopia'),
(14, 1, ARRAY[70, 70], NULL, 'AV muy baja'),
(14, 2, ARRAY[20, 20], NULL, 'Mejora con lentes'),
(14, 3, ARRAY[16.0, 16.0], NULL, NULL),
(14, 4, NULL, false, NULL),
(15, 1, ARRAY[80, 80], NULL, 'Mala visión'),
(15, 2, ARRAY[30, 30], NULL, NULL),
(15, 3, ARRAY[12.0, 12.0], NULL, NULL),
(15, 4, NULL, false, 'Nictalopia'),
(16, 1, ARRAY[20, 20], NULL, NULL),
(16, 2, ARRAY[20, 20], NULL, NULL),
(16, 3, ARRAY[24.0, 24.0], NULL, 'PIO elevada'),
(16, 4, NULL, true, 'Uveítis');

INSERT INTO citas (paciente_id, nombre, fecha, duracion)
VALUES
(1, (SELECT nombre FROM pacientes WHERE id = 1), '2025-05-16 09:00:00-06', 1200), -- 1200 seconds
(1, (SELECT nombre FROM pacientes WHERE id = 1), '2025-05-22 14:30:00-06', 1200),
(1, (SELECT nombre FROM pacientes WHERE id = 1), '2025-05-09 10:15:00-06', 1200),
(2, (SELECT nombre FROM pacientes WHERE id = 2), '2025-05-08 15:45:00-06', 1200),
(2, (SELECT nombre FROM pacientes WHERE id = 2), '2025-05-14 11:00:00-06', 1200),
(2, (SELECT nombre FROM pacientes WHERE id = 2), '2025-05-05 08:30:00-06', 1200),
(3, (SELECT nombre FROM pacientes WHERE id = 3), '2025-05-20 16:00:00-06', 1200),
(3, (SELECT nombre FROM pacientes WHERE id = 3), '2025-05-30 09:30:00-06', 1200),
(4, (SELECT nombre FROM pacientes WHERE id = 4), '2025-05-12 14:00:00-06', 1200),
(4, (SELECT nombre FROM pacientes WHERE id = 4), '2025-05-17 10:45:00-06', 1200),
(5, (SELECT nombre FROM pacientes WHERE id = 5), '2025-05-25 17:00:00-06', 1200),
(5, (SELECT nombre FROM pacientes WHERE id = 5), '2025-05-18 08:15:00-06', 1200),
(6, (SELECT nombre FROM pacientes WHERE id = 6), '2025-05-07 15:00:00-06', 1200),
(6, (SELECT nombre FROM pacientes WHERE id = 6), '2025-05-22 11:30:00-06', 1200),
(7, (SELECT nombre FROM pacientes WHERE id = 7), '2025-05-11 16:45:00-06', 1200),
(8, (SELECT nombre FROM pacientes WHERE id = 8), '2025-05-05 09:00:00-06', 1200);

INSERT INTO horarios_laborales (dia_semana, hora_apertura, hora_cierre) VALUES
(1, '09:00:00', '13:00:00'),  -- Lunes
(2, '09:00:00', '13:00:00'),  -- Martes
(3, '09:00:00', '13:00:00'),  -- Miércoles
(4, '09:00:00', '13:00:00'),  -- Jueves
(5, '09:00:00', '13:00:00'),  -- Viernes

-- Lunes a Viernes (tarde)
(1, '15:00:00', '18:00:00'),   -- Lunes
(2, '15:00:00', '18:00:00'),   -- Martes
(3, '15:00:00', '18:00:00'),   -- Miércoles
(4, '15:00:00', '18:00:00'),   -- Jueves
(5, '15:00:00', '18:00:00'),   -- Viernes

-- Sábado (solo mañana)
(6, '09:00:00', '13:00:00');   -- Sábado

INSERT INTO horarios_especiales (fecha, hora_apertura, hora_cierre) VALUES
('2024-10-23', '09:00:00', '12:00:00'),
('2024-12-24', '09:00:00', '13:00:00'),
('2024-09-16', '15:00:00', '19:00:00'),
('2024-07-15', '10:00:00', '14:00:00'),
('2024-11-08', '08:00:00', '12:00:00');

INSERT INTO examenes (paciente_id, consulta_id, tipo, fecha, s3_key, file_size, mime_type) VALUES
(1, 1, 'Tonometría de aire', '2023-01-15', 'examenes/1/20230115_tonometria_aire.pdf', 892640, 'application/pdf'),
(1, 3, 'Campo visual 30-2', '2024-02-10', 'examenes/1/20240210_campo_visual_30_2.pdf', 2458720, 'application/pdf'),
(2, 4, 'Topografía corneal', '2023-03-08', 'examenes/2/20230308_topografia_corneal.pdf', 1572864, 'application/pdf'),
(2, 5, 'Test de Schirmer', '2023-09-14', 'examenes/2/20230914_test_schirmer.pdf', 651240, 'application/pdf'),
(3, 7, 'Retinografía', '2023-02-20', 'examenes/3/20230220_retinografia.pdf', 1245184, 'application/pdf'),
(3, 8, 'OCT macular', '2023-11-30', 'examenes/3/20231130_oct_macular.pdf', 3145728, 'application/pdf'),
(4, 9, 'Topografía corneal Pentacam', '2023-04-12', 'examenes/4/20230412_pentacam.pdf', 1945728, 'application/pdf'),
(5, 12, 'Biomicroscopía anterior', '2024-03-18', 'examenes/5/20240318_biomicroscopia_anterior.pdf', 2097152, 'application/pdf'),
(6, 14, 'Retinoscopía', '2024-01-22', 'examenes/6/20240122_retinoscopia.pdf', 1048576, 'application/pdf'),
(7, 15, 'Adaptometría', '2023-10-11', 'examenes/7/20231011_adaptometria.pdf', 756240, 'application/pdf');

INSERT INTO examenes (paciente_id, consulta_id, tipo, fecha, s3_key, file_size, mime_type) VALUES
(1, NULL, 'Paquimetría', '2025-10-20', NULL, NULL, NULL), -- Patient 1, scheduled for Oct 2024
(2, NULL, 'Refracción ciclopléjica', '2025-01-05', NULL, NULL, NULL), -- Patient 2, scheduled for Jan 2025
(3, NULL, 'Curva de tensión ocular', '2025-07-01', NULL, NULL, NULL); -- Patient 3, scheduled for July 2024
