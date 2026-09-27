-- ═══════════════════════════════════════════════════════════════════════════
-- Email Verifications Table
-- Stores temporary OTP codes for email verification
-- ═══════════════════════════════════════════════════════════════════════════

create table if not exists public.email_verifications (
  id uuid primary key default gen_random_uuid(),
  email text not null,
  code text not null,
  expires_at timestamptz not null,
  verified boolean default false,
  created_at timestamptz default now(),
  
  -- Prevent multiple active codes per email
  constraint unique_active_email unique (email)
);

-- Index for fast lookups
create index idx_email_verifications_email on public.email_verifications(email);
create index idx_email_verifications_code on public.email_verifications(code);
create index idx_email_verifications_expires on public.email_verifications(expires_at);

-- RLS Policies
alter table public.email_verifications enable row level security;

-- Anyone can insert (for signup)
create policy "Anyone can request OTP"
  on public.email_verifications for insert
  with check (true);

-- Only allow users to read their own verification records
create policy "Users can read own verifications"
  on public.email_verifications for select
  using (email = current_setting('request.jwt.claims', true)::json->>'email');

-- Auto-delete expired codes (runs daily)
create or replace function delete_expired_otps()
returns void
language plpgsql
security definer
as $$
begin
  delete from public.email_verifications
  where expires_at < now();
end;
$$;

-- Schedule cleanup (if pg_cron is enabled)
-- select cron.schedule('cleanup-expired-otps', '0 2 * * *', 'select delete_expired_otps()');

comment on table public.email_verifications is 'Temporary storage for email verification OTP codes';
