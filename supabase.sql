-- Lista da Cozinha | Creche Renascer | ABA
-- Pode rodar quantas vezes quiser no SQL Editor do Supabase.

create table if not exists public.cozinha_itens (
  id             uuid primary key default gen_random_uuid(),
  nome           text not null check (char_length(nome) between 2 and 60),
  categoria      text not null default 'Outros',
  status         text not null default 'ok' check (status in ('ok', 'acabando', 'falta')),
  quantidade     text not null default '' check (char_length(quantidade) <= 80),
  pedido_extra   boolean not null default false,
  ativo          boolean not null default true,
  atualizado_por text not null default '' check (char_length(atualizado_por) <= 30),
  atualizado_em  timestamptz not null default now(),
  criado_em      timestamptz not null default now()
);

-- Unidade de cada item (pct, litros, cx...). A quantidade em falta fica em "quantidade".
alter table public.cozinha_itens
  add column if not exists unidade text not null default 'un' check (char_length(unidade) <= 12);

create index if not exists cozinha_itens_ativo_idx on public.cozinha_itens (ativo, nome);

-- Acesso pelo site (publishable key): ler, adicionar e atualizar. Sem delete:
-- "remover" no sistema só marca ativo = false, então nada se perde.
alter table public.cozinha_itens enable row level security;

drop policy if exists "cozinha ler"       on public.cozinha_itens;
drop policy if exists "cozinha adicionar" on public.cozinha_itens;
drop policy if exists "cozinha atualizar" on public.cozinha_itens;

create policy "cozinha ler"       on public.cozinha_itens for select to anon using (true);
create policy "cozinha adicionar" on public.cozinha_itens for insert to anon with check (true);
create policy "cozinha atualizar" on public.cozinha_itens for update to anon using (true) with check (true);

grant select, insert, update on public.cozinha_itens to anon;

-- Itens da creche: só entram se a tabela estiver vazia.
insert into public.cozinha_itens (nome, categoria, unidade)
select * from (values
  ('Arroz', 'Mercearia', 'fardos'),
  ('Feijão', 'Mercearia', 'pct'),
  ('Feijão preto', 'Mercearia', 'pct'),
  ('Açúcar', 'Mercearia', 'pct'),
  ('Óleo', 'Mercearia', 'litros'),
  ('Sal', 'Mercearia', 'pct'),
  ('Café', 'Mercearia', 'pct'),
  ('Achocolatado', 'Mercearia', 'pct'),
  ('Macarrão padre nosso', 'Mercearia', 'pct'),
  ('Macarrão parafuso', 'Mercearia', 'pct'),
  ('Vinagre', 'Mercearia', 'litros'),
  ('Farinha de mandioca', 'Mercearia', 'pct'),
  ('Polvilho', 'Mercearia', 'pct'),
  ('Milho em lata', 'Mercearia', 'latas'),
  ('Fermento em pó', 'Mercearia', 'un'),
  ('Massa de bolo', 'Mercearia', 'pct'),
  ('Peta', 'Mercearia', 'pct'),
  ('Biscoito rosquinha', 'Mercearia', 'pct'),
  ('Leite', 'Laticínios e frios', 'cx'),
  ('Margarina', 'Laticínios e frios', 'un')
) as v(nome, categoria, unidade)
where not exists (select 1 from public.cozinha_itens);

-- Conferências da cozinha: cada vez que alguém confere e envia a lista,
-- fica registrado quem enviou, quando e quais itens e quantidades.
create table if not exists public.cozinha_envios (
  id          uuid primary key default gen_random_uuid(),
  enviado_por text not null default '' check (char_length(enviado_por) <= 30),
  enviado_em  timestamptz not null default now(),
  total_itens integer not null default 0,
  itens       jsonb not null default '[]'::jsonb
);

create index if not exists cozinha_envios_data_idx on public.cozinha_envios (enviado_em desc);

alter table public.cozinha_envios enable row level security;

drop policy if exists "envios ler"       on public.cozinha_envios;
drop policy if exists "envios registrar" on public.cozinha_envios;

create policy "envios ler"       on public.cozinha_envios for select to anon using (true);
create policy "envios registrar" on public.cozinha_envios for insert to anon with check (true);

grant select, insert on public.cozinha_envios to anon;
