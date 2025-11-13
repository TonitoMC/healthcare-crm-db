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
    sexo VARCHAR NOT NULL CHECK (sexo IN ('Masculino', 'Femenino'))
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
    schema JSONB NOT NULL,  -- holds the full definition of questions & metadata
    CONSTRAINT unique_nombre_version UNIQUE (nombre, version)
);

CREATE UNIQUE INDEX idx_cuestionario_unico_activo
ON cuestionarios (nombre)
WHERE (activo = true);

ALTER TABLE cuestionarios
ADD CONSTRAINT check_schema_object CHECK (jsonb_typeof(schema) = 'object');


CREATE TABLE consultas (
    id SERIAL PRIMARY KEY,
    paciente_id INTEGER NOT NULL REFERENCES pacientes(id),
    motivo VARCHAR NOT NULL DEFAULT 'Consulta General',
    cuestionario_id INTEGER REFERENCES cuestionarios(id),
    fecha DATE NOT NULL DEFAULT CURRENT_DATE,
    completada BOOL NOT NULL DEFAULT FALSE
);

CREATE TABLE respuestas_cuestionarios (
    id SERIAL PRIMARY KEY,
    paciente_id INTEGER REFERENCES pacientes(id),
    cuestionario_id INTEGER REFERENCES cuestionarios(id),
    consulta_id INTEGER REFERENCES consultas(id),
    respuestas JSONB NOT NULL,
    fecha TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uq_cuestionario_consulta UNIQUE (consulta_id, cuestionario_id),
    CONSTRAINT check_respuestas_object CHECK (jsonb_typeof(respuestas) = 'object')
);

CREATE TABLE diagnosticos (
    id SERIAL PRIMARY KEY,
    recomendacion VARCHAR,
    nombre VARCHAR NOT NULL,
    consulta_id INTEGER NOT NULL REFERENCES consultas(id)
);

CREATE TABLE tratamientos (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR NOT NULL,
    componente_activo VARCHAR NOT NULL,
    presentacion VARCHAR NOT NULL,
    dosificacion TEXT NOT NULL,
    tiempo VARCHAR NOT NULL,
    frecuencia VARCHAR NOT NULL,
    diagnostico_id INTEGER NOT NULL REFERENCES diagnosticos(id)
);

CREATE TABLE examenes (
    id SERIAL PRIMARY KEY,
    paciente_id INTEGER NOT NULL REFERENCES pacientes(id),
    consulta_id INTEGER REFERENCES consultas(id),
    tipo VARCHAR NOT NULL,
    fecha DATE DEFAULT CURRENT_DATE,
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
    nombre VARCHAR UNIQUE NOT NULL,
    descripcion VARCHAR NOT NULL
);

CREATE TABLE permisos (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR UNIQUE NOT NULL,
    descripcion VARCHAR NOT NULL
);

CREATE TABLE roles_permisos (
    id SERIAL PRIMARY KEY,
    rol_id INTEGER NOT NULL REFERENCES roles(id) ON DELETE CASCADE,
    permiso_id INTEGER NOT NULL REFERENCES permisos(id),
    CONSTRAINT uq_roles_permisos UNIQUE (rol_id, permiso_id)
);

CREATE TABLE usuarios (
    id SERIAL PRIMARY KEY,
    username VARCHAR UNIQUE NOT NULL,
    password_hash VARCHAR NOT NULL,
    correo VARCHAR UNIQUE NOT NULL
);

CREATE TABLE usuarios_roles (
    id SERIAL PRIMARY KEY,
    usuario_id INTEGER NOT NULL REFERENCES usuarios(id) ON DELETE CASCADE,
    rol_id INTEGER NOT NULL REFERENCES roles(id),
    CONSTRAINT uq_usuarios_roles UNIQUE (usuario_id, rol_id)
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
    dia_semana INTEGER NOT NULL CHECK (dia_semana BETWEEN 1 AND 7),
    hora_apertura TIME,
    hora_cierre TIME,
    abierto BOOLEAN NOT NULL DEFAULT TRUE,
    valid_from DATE NOT NULL DEFAULT CURRENT_DATE,
    valid_to   DATE NOT NULL DEFAULT '9999-12-31',
    CHECK (
        (abierto = TRUE AND hora_apertura IS NOT NULL AND hora_cierre IS NOT NULL)
        OR (abierto = FALSE AND hora_apertura IS NULL AND hora_cierre IS NULL)
    )
);

CREATE TABLE horarios_especiales (
    id SERIAL PRIMARY KEY,
    fecha DATE NOT NULL,
    hora_apertura TIME,
    hora_cierre TIME,
    abierto BOOLEAN NOT NULL DEFAULT TRUE,
    CHECK (
        (abierto = TRUE AND hora_apertura IS NOT NULL AND hora_cierre IS NOT NULL)
        OR (abierto = FALSE AND hora_apertura IS NULL AND hora_cierre IS NULL)
    )
);


CREATE EXTENSION IF NOT EXISTS btree_gist;

ALTER TABLE horarios_especiales
ADD CONSTRAINT no_overlap_especiales
EXCLUDE USING gist (
  fecha WITH =,
  numrange(extract(epoch from hora_apertura),
           extract(epoch from hora_cierre),
           '[]') WITH &&
)
WHERE (abierto);

CREATE TABLE recordatorios (
    id SERIAL PRIMARY KEY,
    usuario_id INTEGER REFERENCES usuarios(id) ON DELETE SET NULL,
    descripcion VARCHAR NOT NULL,
    global BOOLEAN NOT NULL DEFAULT FALSE,
    fecha_creacion TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_completado TIMESTAMPTZ
);
