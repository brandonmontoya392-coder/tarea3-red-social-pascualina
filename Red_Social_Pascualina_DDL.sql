-- Tarea 3: Modelo físico de la Red Social Pascualina
-- SGBD seleccionado: PostgreSQL
-- Script DDL: crea las tablas, claves primarias, claves foráneas y restricciones.

BEGIN;

CREATE TABLE estudiante (
    id_estudiante INTEGER GENERATED ALWAYS AS IDENTITY,
    nombre VARCHAR(80) NOT NULL,
    apellido VARCHAR(80) NOT NULL,
    correo VARCHAR(150) NOT NULL,
    contrasena VARCHAR(255) NOT NULL,
    programa_academico VARCHAR(120) NOT NULL,
    semestre SMALLINT,
    biografia TEXT,
    fecha_registro TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_estudiante PRIMARY KEY (id_estudiante),
    CONSTRAINT uq_estudiante_correo UNIQUE (correo),
    CONSTRAINT ck_estudiante_semestre CHECK (semestre IS NULL OR semestre BETWEEN 1 AND 20)
);

CREATE TABLE publicacion (
    id_publicacion INTEGER GENERATED ALWAYS AS IDENTITY,
    id_estudiante INTEGER NOT NULL,
    contenido TEXT NOT NULL,
    tipo VARCHAR(30) NOT NULL,
    fecha_publicacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_publicacion PRIMARY KEY (id_publicacion),
    CONSTRAINT fk_publicacion_estudiante FOREIGN KEY (id_estudiante)
        REFERENCES estudiante (id_estudiante) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT ck_publicacion_tipo CHECK (tipo IN ('pregunta', 'recurso', 'noticia', 'meme', 'otro'))
);

CREATE TABLE comentario (
    id_comentario INTEGER GENERATED ALWAYS AS IDENTITY,
    id_estudiante INTEGER NOT NULL,
    id_publicacion INTEGER NOT NULL,
    contenido TEXT NOT NULL,
    fecha_comentario TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_comentario PRIMARY KEY (id_comentario),
    CONSTRAINT fk_comentario_estudiante FOREIGN KEY (id_estudiante)
        REFERENCES estudiante (id_estudiante) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_comentario_publicacion FOREIGN KEY (id_publicacion)
        REFERENCES publicacion (id_publicacion) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE interes (
    id_interes INTEGER GENERATED ALWAYS AS IDENTITY,
    nombre VARCHAR(100) NOT NULL,
    CONSTRAINT pk_interes PRIMARY KEY (id_interes),
    CONSTRAINT uq_interes_nombre UNIQUE (nombre)
);

CREATE TABLE habilidad (
    id_habilidad INTEGER GENERATED ALWAYS AS IDENTITY,
    nombre VARCHAR(100) NOT NULL,
    CONSTRAINT pk_habilidad PRIMARY KEY (id_habilidad),
    CONSTRAINT uq_habilidad_nombre UNIQUE (nombre)
);

CREATE TABLE grupo (
    id_grupo INTEGER GENERATED ALWAYS AS IDENTITY,
    nombre VARCHAR(120) NOT NULL,
    descripcion TEXT,
    fecha_creacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    id_creador INTEGER NOT NULL,
    CONSTRAINT pk_grupo PRIMARY KEY (id_grupo),
    CONSTRAINT fk_grupo_creador FOREIGN KEY (id_creador)
        REFERENCES estudiante (id_estudiante) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE evento (
    id_evento INTEGER GENERATED ALWAYS AS IDENTITY,
    nombre VARCHAR(150) NOT NULL,
    descripcion TEXT,
    fecha DATE NOT NULL,
    hora TIME NOT NULL,
    lugar VARCHAR(180) NOT NULL,
    id_creador INTEGER NOT NULL,
    CONSTRAINT pk_evento PRIMARY KEY (id_evento),
    CONSTRAINT fk_evento_creador FOREIGN KEY (id_creador)
        REFERENCES estudiante (id_estudiante) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE estudiante_interes (
    id_estudiante_interes INTEGER GENERATED ALWAYS AS IDENTITY,
    id_estudiante INTEGER NOT NULL,
    id_interes INTEGER NOT NULL,
    CONSTRAINT pk_estudiante_interes PRIMARY KEY (id_estudiante_interes),
    CONSTRAINT fk_estudiante_interes_estudiante FOREIGN KEY (id_estudiante)
        REFERENCES estudiante (id_estudiante) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_estudiante_interes_interes FOREIGN KEY (id_interes)
        REFERENCES interes (id_interes) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT uq_estudiante_interes UNIQUE (id_estudiante, id_interes)
);

CREATE TABLE estudiante_habilidad (
    id_estudiante_habilidad INTEGER GENERATED ALWAYS AS IDENTITY,
    id_estudiante INTEGER NOT NULL,
    id_habilidad INTEGER NOT NULL,
    nivel VARCHAR(30) NOT NULL,
    CONSTRAINT pk_estudiante_habilidad PRIMARY KEY (id_estudiante_habilidad),
    CONSTRAINT fk_estudiante_habilidad_estudiante FOREIGN KEY (id_estudiante)
        REFERENCES estudiante (id_estudiante) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_estudiante_habilidad_habilidad FOREIGN KEY (id_habilidad)
        REFERENCES habilidad (id_habilidad) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT uq_estudiante_habilidad UNIQUE (id_estudiante, id_habilidad),
    CONSTRAINT ck_estudiante_habilidad_nivel CHECK (nivel IN ('basico', 'intermedio', 'avanzado', 'experto'))
);

CREATE TABLE miembro_grupo (
    id_miembro INTEGER GENERATED ALWAYS AS IDENTITY,
    id_estudiante INTEGER NOT NULL,
    id_grupo INTEGER NOT NULL,
    fecha_ingreso DATE NOT NULL DEFAULT CURRENT_DATE,
    rol VARCHAR(30) NOT NULL DEFAULT 'miembro',
    CONSTRAINT pk_miembro_grupo PRIMARY KEY (id_miembro),
    CONSTRAINT fk_miembro_grupo_estudiante FOREIGN KEY (id_estudiante)
        REFERENCES estudiante (id_estudiante) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_miembro_grupo_grupo FOREIGN KEY (id_grupo)
        REFERENCES grupo (id_grupo) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT uq_miembro_grupo UNIQUE (id_estudiante, id_grupo),
    CONSTRAINT ck_miembro_grupo_rol CHECK (rol IN ('miembro', 'administrador', 'moderador'))
);

CREATE TABLE participacion_evento (
    id_participacion INTEGER GENERATED ALWAYS AS IDENTITY,
    id_estudiante INTEGER NOT NULL,
    id_evento INTEGER NOT NULL,
    fecha_inscripcion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    estado VARCHAR(30) NOT NULL DEFAULT 'inscrito',
    CONSTRAINT pk_participacion_evento PRIMARY KEY (id_participacion),
    CONSTRAINT fk_participacion_evento_estudiante FOREIGN KEY (id_estudiante)
        REFERENCES estudiante (id_estudiante) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_participacion_evento_evento FOREIGN KEY (id_evento)
        REFERENCES evento (id_evento) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT uq_participacion_evento UNIQUE (id_estudiante, id_evento),
    CONSTRAINT ck_participacion_evento_estado CHECK (estado IN ('inscrito', 'confirmado', 'asistio', 'cancelado'))
);

CREATE TABLE seguimiento (
    id_seguimiento INTEGER GENERATED ALWAYS AS IDENTITY,
    id_seguidor INTEGER NOT NULL,
    id_seguido INTEGER NOT NULL,
    fecha_seguimiento TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_seguimiento PRIMARY KEY (id_seguimiento),
    CONSTRAINT fk_seguimiento_seguidor FOREIGN KEY (id_seguidor)
        REFERENCES estudiante (id_estudiante) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_seguimiento_seguido FOREIGN KEY (id_seguido)
        REFERENCES estudiante (id_estudiante) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT uq_seguimiento UNIQUE (id_seguidor, id_seguido),
    CONSTRAINT ck_seguimiento_no_propio CHECK (id_seguidor <> id_seguido)
);

CREATE TABLE mentoria (
    id_mentoria INTEGER GENERATED ALWAYS AS IDENTITY,
    id_mentor INTEGER NOT NULL,
    id_mentoreado INTEGER NOT NULL,
    fecha_inicio DATE NOT NULL DEFAULT CURRENT_DATE,
    estado VARCHAR(30) NOT NULL DEFAULT 'activa',
    descripcion TEXT,
    CONSTRAINT pk_mentoria PRIMARY KEY (id_mentoria),
    CONSTRAINT fk_mentoria_mentor FOREIGN KEY (id_mentor)
        REFERENCES estudiante (id_estudiante) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_mentoria_mentoreado FOREIGN KEY (id_mentoreado)
        REFERENCES estudiante (id_estudiante) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT ck_mentoria_no_propia CHECK (id_mentor <> id_mentoreado),
    CONSTRAINT ck_mentoria_estado CHECK (estado IN ('activa', 'finalizada', 'cancelada'))
);

-- Índices para facilitar consultas frecuentes por claves foráneas.
CREATE INDEX ix_publicacion_estudiante ON publicacion (id_estudiante);
CREATE INDEX ix_comentario_estudiante ON comentario (id_estudiante);
CREATE INDEX ix_comentario_publicacion ON comentario (id_publicacion);
CREATE INDEX ix_grupo_creador ON grupo (id_creador);
CREATE INDEX ix_evento_creador ON evento (id_creador);
CREATE INDEX ix_miembro_grupo_grupo ON miembro_grupo (id_grupo);
CREATE INDEX ix_participacion_evento_evento ON participacion_evento (id_evento);
CREATE INDEX ix_seguimiento_seguido ON seguimiento (id_seguido);
CREATE INDEX ix_mentoria_mentoreado ON mentoria (id_mentoreado);

COMMIT;
