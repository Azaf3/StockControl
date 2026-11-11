-- Lista da Cozinha | Creche Renascer | ABA
-- Rodar uma vez no SQL Editor do Supabase.

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

create index if not exists cozinha_itens_ativo_idx on public.cozinha_itens (ativo, nome);

-- Acesso pelo site (chave anon): ler, adicionar e atualizar. Sem delete:
-- "remover" no sistema só marca ativo = false, então nada se perde.
alter table public.cozinha_itens enable row level security;

create policy "cozinha ler"       on public.cozinha_itens for select to anon using (true);
create policy "cozinha adicionar" on public.cozinha_itens for insert to anon with check (true);
create policy "cozinha atualizar" on public.cozinha_itens for update to anon using (true) with check (true);

grant select, insert, update on public.cozinha_itens to anon;

-- Itens da lista de compras da Creche Renascer.
insert into public.cozinha_itens (nome, categoria) values
  ('Arroz', 'Mercearia'),
  ('Feijão', 'Mercearia'),
  ('Feijão preto', 'Mercearia'),
  ('Açúcar', 'Mercearia'),
  ('Óleo', 'Mercearia'),
  ('Sal', 'Mercearia'),
  ('Café', 'Mercearia'),
  ('Achocolatado', 'Mercearia'),
  ('Macarrão padre nosso', 'Mercearia'),
  ('Macarrão parafuso', 'Mercearia'),
  ('Vinagre', 'Mercearia'),
  ('Farinha de mandioca', 'Mercearia'),
  ('Polvilho', 'Mercearia'),
  ('Milho em lata', 'Mercearia'),
  ('Fermento em pó', 'Mercearia'),
  ('Massa de bolo', 'Mercearia'),
  ('Peta', 'Mercearia'),
  ('Biscoito rosquinha', 'Mercearia'),
  ('Leite', 'Laticínios e frios'),
  ('Margarina', 'Laticínios e frios');
