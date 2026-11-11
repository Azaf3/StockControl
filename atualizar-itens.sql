-- Troca os itens de exemplo pela lista real da Creche Renascer.
-- Rodar uma vez no SQL Editor do Supabase.
delete from public.cozinha_itens;

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
