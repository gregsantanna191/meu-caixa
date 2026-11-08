-- Meu caixa: tabela dos dados de cada pessoa.
-- Cole tudo no Supabase em SQL Editor > New query e clique em Run.

create table if not exists public.documentos (
  user_id uuid not null references auth.users (id) on delete cascade,
  doc_id text not null,
  body jsonb not null,
  updated_at timestamptz not null default now(),
  primary key (user_id, doc_id)
);

-- Cada pessoa só enxerga e altera os próprios dados.
alter table public.documentos enable row level security;

create policy "ler os próprios dados" on public.documentos
  for select using (auth.uid() = user_id);
create policy "criar os próprios dados" on public.documentos
  for insert with check (auth.uid() = user_id);
create policy "alterar os próprios dados" on public.documentos
  for update using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "apagar os próprios dados" on public.documentos
  for delete using (auth.uid() = user_id);
