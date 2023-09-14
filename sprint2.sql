--Ejercicio 1

--Primero creamos la facultad--

CREATE TABLE facultad
(
    id_facultad integer NOT NULL,
    nombre character varying(50),
    libro_trad character varying(25),
    libro_audio character varying(25),
    revistas character varying(25),
    CONSTRAINT facultad_pkey PRIMARY KEY (id_facultad)
);

CREATE TABLE carrera
(
    id_carrera integer NOT NULL,
    nombre_carrera character varying(100),
    CONSTRAINT carrera_pkey PRIMARY KEY (id_carrera)
);

--Se crea la editorial junto con la tabla ejemplar--

CREATE TABLE editorial
(
    id_editorial integer NOT NULL,
    nombre_editorial character varying(100),
    mail character varying(100),
    pagina_of character varying(100),
    CONSTRAINT editorial_pkey PRIMARY KEY (id_editorial)
);

CREATE TABLE ejemplar
(
    id_ejemplar integer NOT NULL,
    isbn character varying(13) NOT NULL,
    titulo character varying(255),
    lengua_origen character varying(100),
    lengua_escritura character varying(100),
    cant_paginas integer,
    resumen text,
    editorial_id integer,
    etiqueta character varying(50),
    dias_max_prestado integer,
    facultad integer,
    CONSTRAINT ejemplar_pkey PRIMARY KEY (isbn),
    CONSTRAINT ejemplar_editorial_id_fkey FOREIGN KEY (editorial_id) REFERENCES public.editorial (id_editorial) 
		ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT valores_etiqueta CHECK (etiqueta IN ('prestado', 'retirado'))
);

--Creamos las personas--

CREATE TABLE persona2
(
    dni character varying(11) NOT NULL,
    nombre character varying(50),
    apellido character varying(50),
    tipo character varying(50),
    CONSTRAINT persona_pkey PRIMARY KEY (dni),
    CONSTRAINT valores_tipo CHECK(tipo IN('ALUMNO', 'DOCENTE', 'AUTOR', 'EMPLEADO'))
    
);

CREATE TABLE alumno
(
    dni character varying(11) NOT NULL,
    cursa character varying(50),
    suspensiones integer,
    foto bytea,
    nro_libreta integer,
    fecha_inscripcion date,
    CONSTRAINT alumno_pkey PRIMARY KEY (dni),
    CONSTRAINT alumno_fkey FOREIGN KEY (dni) REFERENCES public.persona2 (dni) 
		ON UPDATE CASCADE
    	ON DELETE CASCADE
);

CREATE TABLE docente
(
    dni character varying(11) NOT NULL,
    faltas integer,
    nro_legajo integer NOT NULL,
    fecha_inscripcion date,
    CONSTRAINT docente_pkey PRIMARY KEY (nro_legajo),
    CONSTRAINT docente_dni_fkey FOREIGN KEY (dni) REFERENCES public.persona2 (dni)
		ON UPDATE CASCADE
   	 	ON DELETE CASCADE
);

CREATE TABLE autor
(
    dni_autor character varying(11) NOT NULL,
    nacionalidad character varying(100),
    CONSTRAINT autor_pkey PRIMARY KEY (dni_autor),
	CONSTRAINT autor_fkey FOREIGN KEY (dni_autor) REFERENCES public.persona2(dni)
		ON UPDATE CASCADE
    	ON DELETE CASCADE
);

CREATE TABLE empleado
(
    dni_empleado character varying(11) NOT NULL,
    codigo_empleado character(1),
    descripcion character varying(20),
    observacion character varying(30),
    CONSTRAINT empleado_pkey PRIMARY KEY (dni_empleado),
    CONSTRAINT empleado_dni_empleado_fkey FOREIGN KEY (dni_empleado) REFERENCES public.persona2 (dni)
		ON UPDATE CASCADE
    	ON DELETE CASCADE
);

--Relacion de muchos a muchos, muchos libros pueden ser escritos por muchos autores y muchos autores pueden escribir muchos libros--

CREATE TABLE autores_ejemplar
(
    dni_autor character varying(11) NOT NULL,
    ejemplar_id integer NOT NULL,
    CONSTRAINT autores_ejemplar_pkey PRIMARY KEY (dni_autor, ejemplar_id),
    CONSTRAINT autores_ejemplar_dni_autor_fkey FOREIGN KEY (dni_autor) REFERENCES public.autor (dni_autor)
		ON UPDATE CASCADE
    	ON DELETE CASCADE
);

--Se crea cada tipo de ejemplar--
CREATE TABLE audiolibro
(
    isbn character varying(13) NOT NULL,
    ejemplar_id integer,
    carrera_id integer,
    CONSTRAINT audiolibro_pkey PRIMARY KEY (isbn),
    CONSTRAINT audiolibro_ejemplar_id_key UNIQUE (ejemplar_id),
    CONSTRAINT audiolibro_carrera_id_fkey FOREIGN KEY (carrera_id) REFERENCES public.carrera (id_carrera)
		ON UPDATE CASCADE
        ON DELETE CASCADE
);

CREATE TABLE libro
(
    isbn character varying(13) NOT NULL,
    ejemplar_id integer,
    carrera_id integer,
    CONSTRAINT libro_pkey PRIMARY KEY (isbn),
    CONSTRAINT libro_ejemplar_id_key UNIQUE (ejemplar_id),
    CONSTRAINT libro_carrera_id_fkey FOREIGN KEY (carrera_id) REFERENCES public.carrera (id_carrera)
		ON UPDATE CASCADE
        ON DELETE CASCADE
);

CREATE TABLE revista
(
    isbn character varying(13) NOT NULL,
    num_edicion integer,
    periodo character varying(100),
    carrera_id integer,
    CONSTRAINT revista_pkey PRIMARY KEY (isbn),
    CONSTRAINT revista_carrera_id_fkey FOREIGN KEY (carrera_id) REFERENCES public.carrera (id_carrera)
	ON UPDATE CASCADE
    ON DELETE CASCADE,
    CONSTRAINT valores_periodos CHECK (periodo IN ('mensual', 'anual', 'semestral'))
);

--Creamos el padron, el cual no se relaciona a las demas tablas--
CREATE TABLE padron_parana
(
    dni_persona integer NOT NULL,
    CONSTRAINT padron_parana_pkey PRIMARY KEY (dni_persona)
);

--Creamos las tablas prestamos--
CREATE TABLE prestamo
(
    id_prestamo integer NOT NULL,
    dni_empleado character varying(11),
	dni_alumno character varying(11),
	legajo_docente integer,
    fecha_retiro date,
    fecha_vencimiento date,
    fecha_devolucion date,
    libro_id integer,
	cant_ejemplares integer,
    CONSTRAINT prestamo_pkey PRIMARY KEY (id_prestamo),
    CONSTRAINT prestamo_dni_empleado_fkey FOREIGN KEY (dni_empleado) REFERENCES public.empleado (dni_empleado)
	ON UPDATE CASCADE
    ON DELETE CASCADE,
	CONSTRAINT prestamo_dni_alumno_fkey FOREIGN KEY (dni_alumno) REFERENCES public.alumno (dni) 
	ON UPDATE CASCADE
    ON DELETE CASCADE ,
	CONSTRAINT prestamo_legajo_docente_fkey FOREIGN KEY (legajo_docente) REFERENCES public.docente (nro_legajo)
	ON UPDATE CASCADE
    ON DELETE CASCADE
);

--Creamos las notificaciones para los alumnos y los docentes--
CREATE TABLE notificaciones_doc
(
    legajo_docente integer NOT NULL,
    CONSTRAINT notif_pkey PRIMARY KEY (legajo_docente),
    CONSTRAINT notif_fkey FOREIGN KEY (legajo_docente) REFERENCES public.docente (nro_legajo)
	ON UPDATE CASCADE
    ON DELETE CASCADE
);



--Ejercicio 2
--SELECT dni_alumno
--FROM prestamo
--WHERE fecha_retiro BETWEEN '01-01-2023' AND '12-31-2023'
--GROUP BY dni_alumno
--HAVING COUNT(*) > 3;

--Ejercicio 3
--UPDATE persona2
--SET nombre = SUBSTRING(nombre FROM 1 FOR 40)
--WHERE tipo = 'ALUMNO';
--ALTER TABLE persona2
--ALTER COLUMN nombre TYPE VARCHAR(40);