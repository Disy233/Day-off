-- Run this ONCE in Supabase SQL Editor.
-- It adds a secure admin flag and a no-code website settings table.

alter table public.profiles
add column if not exists is_admin boolean not null default false;

create table if not exists public.site_settings (
  key text primary key,
  value text not null default '',
  updated_by uuid references public.profiles(id) on delete set null,
  updated_at timestamptz default now()
);

alter table public.site_settings enable row level security;

drop policy if exists "Public can read site settings" on public.site_settings;
create policy "Public can read site settings"
on public.site_settings for select
using (true);

drop policy if exists "Admins can insert site settings" on public.site_settings;
create policy "Admins can insert site settings"
on public.site_settings for insert to authenticated
with check (exists (select 1 from public.profiles p where p.id = auth.uid() and p.is_admin = true));

drop policy if exists "Admins can update site settings" on public.site_settings;
create policy "Admins can update site settings"
on public.site_settings for update to authenticated
using (exists (select 1 from public.profiles p where p.id = auth.uid() and p.is_admin = true))
with check (exists (select 1 from public.profiles p where p.id = auth.uid() and p.is_admin = true));

insert into public.site_settings(key,value) values
('app_name','Dayoff'),
('feed_title','For You'),
('tagline','Share moments. Chat. Go live. Enjoy your day.'),
('login_message','Share moments. Chat. Go live. Enjoy your day.'),
('announcement',''),
('right_description','A camera-first social space for sharing moments and connecting.'),
('live_enabled','true')
on conflict (key) do nothing;

-- IMPORTANT: run this separately after signing in with the account that should be the owner/admin.
-- Replace the email with YOUR admin email.
update public.profiles
set is_admin = true
where id = (select id from auth.users where email = 'YOUR-ADMIN-EMAIL@example.com');
