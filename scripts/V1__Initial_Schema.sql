--   Healthcare CRM — Database Schema (PostgreSQL)

-- Drop old tables
DROP SCHEMA public CASCADE;
CREATE SCHEMA public;
SET search_path TO public;

-- ========== TABLE DEFINITIONS ==========

CREATE TABLE pacientes (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    telefono VARCHAR UNIQUE,
    sexo VARCHAR NOT NULL
);

CREATE TABLE antecedentes (
    id SERIAL PRIMARY KEY,
    paciente_id INTEGER NOT NULL UNIQUE REFERENCES pacientes(id),
    medicos VARCHAR,
    familiares VARCHAR,
    oculares VARCHAR,
    alergicos VARCHAR,
    otros VARCHAR
);

CREATE TABLE citas (
    id SERIAL PRIMARY KEY,
    paciente_id INTEGER REFERENCES pacientes(id),
    fecha TIMESTAMPTZ NOT NULL,
    duracion BIGINT NOT NULL DEFAULT 1200,
    nombre VARCHAR
);

CREATE TABLE cuestionarios (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR NOT NULL,
    version VARCHAR NOT NULL,
    activo BOOLEAN NOT NULL DEFAULT FALSE,
    CONSTRAINT unique_nombre_version UNIQUE (nombre, version)
);

CREATE UNIQUE INDEX idx_cuestionario_unico_activo
ON cuestionarios (nombre)
WHERE (activo = true);

CREATE TABLE preguntas (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR NOT NULL,
    tipo VARCHAR NOT NULL,
    bilateral BOOLEAN NOT NULL,
    CONSTRAINT unique_name_type UNIQUE (nombre, tipo)
);

CREATE TABLE preguntas_cuestionarios (
    id SERIAL PRIMARY KEY,
    cuestionario_id INTEGER NOT NULL REFERENCES cuestionarios(id),
    pregunta_id INTEGER NOT NULL REFERENCES preguntas(id),
    orden INTEGER NOT NULL,
    CONSTRAINT unique_cuestionario_pregunta UNIQUE (cuestionario_id, pregunta_id)
);

CREATE TABLE consultas (
    id SERIAL PRIMARY KEY,
    paciente_id INTEGER NOT NULL REFERENCES pacientes(id),
    motivo VARCHAR NOT NULL DEFAULT 'Consulta General',
    cuestionario_id INTEGER REFERENCES cuestionarios(id),
    fecha DATE NOT NULL
);

CREATE TABLE consultas_preguntas (
    id SERIAL PRIMARY KEY,
    consulta_id INTEGER NOT NULL REFERENCES consultas(id),
    pregunta_id INTEGER NOT NULL REFERENCES preguntas(id),
    valor_texto VARCHAR,
    valor_entero INTEGER,
    valor_booleano BOOLEAN,
    comentario VARCHAR(150),
    valores_textos VARCHAR[],
    valores_enteros INTEGER[],
    valores_booleanos BOOLEAN[],
    CONSTRAINT unique_consulta_pregunta UNIQUE (consulta_id, pregunta_id),
    CONSTRAINT check_textos_max2 CHECK (array_length(valores_textos, 1) IS NULL OR array_length(valores_textos, 1) <= 2),
    CONSTRAINT check_enteros_max2 CHECK (array_length(valores_enteros, 1) IS NULL OR array_length(valores_enteros, 1) <= 2),
    CONSTRAINT check_booleanos_max2 CHECK (array_length(valores_booleanos, 1) IS NULL OR array_length(valores_booleanos, 1) <= 2)
);

CREATE TABLE diagnosticos (
    id SERIAL PRIMARY KEY,
    recomendacion VARCHAR,
    nombre VARCHAR NOT NULL,
    consulta_id INTEGER NOT NULL REFERENCES consultas(id)
);

CREATE TABLE tratamientos (
    id SERIAL PRIMARY KEY,
    componente_activo VARCHAR NOT NULL,
    presentacion VARCHAR NOT NULL,
    dosificacion TEXT NOT NULL,
    tiempo INTERVAL NOT NULL,
    frecuencia INTERVAL NOT NULL,
    diagnostico_id INTEGER NOT NULL REFERENCES diagnosticos(id)
);

CREATE TABLE examenes (
    id SERIAL PRIMARY KEY,
    paciente_id INTEGER NOT NULL REFERENCES pacientes(id),
    consulta_id INTEGER REFERENCES consultas(id),
    tipo VARCHAR NOT NULL,
    fecha DATE,
    s3_key VARCHAR(255),
    file_size BIGINT,
    mime_type VARCHAR(50),
    CONSTRAINT check_mime_type CHECK (mime_type = 'application/pdf')
);

CREATE TABLE tutores (
    id SERIAL PRIMARY KEY,
    paciente_id INTEGER NOT NULL REFERENCES pacientes(id),
    nombre VARCHAR NOT NULL,
    telefono VARCHAR NOT NULL,
    parentesco VARCHAR NOT NULL,
    es_contacto_principal BOOLEAN NOT NULL
);

CREATE TABLE roles (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR NOT NULL,
    descripcion VARCHAR NOT NULL
);

CREATE TABLE permisos (
    id SERIAL PRIMARY KEY,
    name VARCHAR NOT NULL,
    descripcion VARCHAR NOT NULL
);

CREATE TABLE roles_permisos (
    id SERIAL PRIMARY KEY,
    rol_id INTEGER NOT NULL REFERENCES roles(id),
    permiso_id INTEGER NOT NULL REFERENCES permisos(id)
);

CREATE TABLE usuarios (
    id SERIAL PRIMARY KEY,
    username VARCHAR NOT NULL,
    password_hash VARCHAR NOT NULL,
    correo VARCHAR NOT NULL
);

CREATE TABLE usuarios_roles (
    id SERIAL PRIMARY KEY,
    usuario_id INTEGER NOT NULL REFERENCES usuarios(id),
    rol_id INTEGER NOT NULL REFERENCES roles(id)
);

CREATE TABLE logs (
    id SERIAL PRIMARY KEY,
    usuario_id INTEGER NOT NULL REFERENCES usuarios(id),
    accion VARCHAR NOT NULL,
    objeto VARCHAR NOT NULL,
    objeto_id INTEGER NOT NULL,
    fecha_hora TIMESTAMP NOT NULL
);

CREATE TABLE horarios_laborales (
    id SERIAL PRIMARY KEY,
    hora_apertura TIME NOT NULL,
    hora_cierre TIME NOT NULL,
    dia_semana INTEGER NOT NULL
);

CREATE TABLE horarios_especiales (
    id SERIAL PRIMARY KEY,
    fecha DATE NOT NULL,
    hora_apertura TIME NOT NULL,
    hora_cierre TIME NOT NULL
);
