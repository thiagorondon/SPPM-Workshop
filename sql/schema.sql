create table inscricao (
       id integer primary key,
       nome text not null,
       cpf text not null,
       apelido text,
       email text not null,
       celular integer not null,
       confirmado integer default 0
);
