create table inscricao (
       id integer primary key,
       nome text not null,
       apelido text,
       email text not null,
       celular integer,
       codigo text,
       confirmado integer default 0
);

create table cupom (
	value text primary key,
	id_inscricao integer,
	UNIQUE (id_inscricao)
);

