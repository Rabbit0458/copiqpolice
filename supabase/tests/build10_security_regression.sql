-- Run as postgres. All fixtures and changes are rolled back, including gifts.
begin;
do $$
declare
  uid uuid; founder uuid; category uuid; post uuid:=gen_random_uuid(); comment_id uuid:=gen_random_uuid();
  staff uuid:=gen_random_uuid(); report jsonb; affected integer;
  room uuid:=gen_random_uuid(); message_id uuid:=gen_random_uuid();
  test_space text; test_category uuid; test_post uuid;
begin
  select user_id into uid from public.user_profiles where email='kaiswinston2@gmail.com' and role::text<>'owner';
  select auth_uid into founder from public.admin_users where role='owner' and not disabled limit 1;
  select id into category from public.community_categories where space_id='gpx_exam' and is_active and posting_role='user' limit 1;
  if uid is null or founder is null or category is null then raise exception 'Test fixture missing'; end if;
  if exists(select 1 from public.admin_users where auth_uid=uid) then raise exception 'Test account must not already be staff'; end if;
  foreach test_space in array array['gpx_exam','pa_exam','gpx_school','pa_school'] loop
    update public.user_profiles set user_track=split_part(test_space,'_',1),user_mode=split_part(test_space,'_',2) where user_id=uid;
    select id into test_category from public.community_categories where space_id=test_space and is_active and posting_role='user' limit 1;
    if test_category is null then raise exception 'Missing forum category: %',test_space; end if;
    test_post:=gen_random_uuid();
    perform set_config('request.jwt.claims',jsonb_build_object('sub',uid,'role','authenticated','aal','aal2')::text,true);
    execute 'set local role authenticated';
    insert into public.community_posts(id,author_id,space_id,category_id,title,content)
      values(test_post,uid,test_space,test_category,'Test des quatre parcours','Publication temporaire de verification de tous les parcours.');
    update public.community_posts set content='Modification normale pour le parcours de verification.' where id=test_post;
    update public.community_posts set status='deleted_by_author',deleted_at=now() where id=test_post;
    get diagnostics affected=row_count;
    if affected<>1 then raise exception 'Forum author flow failed: %',test_space; end if;
    execute 'reset role';
  end loop;
  update public.user_profiles set user_mode='exam',user_track='gpx' where user_id=uid;
  insert into public.community_posts(id,author_id,space_id,category_id,title,content)
    values(post,uid,'gpx_exam',category,'Regression build dix','Contenu temporaire pour les tests de securite du build dix.');
  insert into public.community_comments(id,author_id,post_id,content)
    values(comment_id,uid,post,'Commentaire temporaire pour verification.');
  insert into public.community_rooms(id,created_by,space_id,kind) values(room,uid,'gpx_exam','group');
  insert into public.community_room_members(room_id,user_id) values(room,uid);
  insert into public.community_messages(id,client_id,room_id,sender_id,content)
    values(message_id,gen_random_uuid(),room,uid,'Message temporaire de verification.');
  perform set_config('request.jwt.claims',jsonb_build_object('sub',uid,'role','authenticated','aal','aal2')::text,true);
  execute 'set local role authenticated';
  update public.community_posts set content='Contenu modifie normalement par son auteur pour ce test.' where id=post;
  get diagnostics affected=row_count;
  if affected<>1 then raise exception 'Own post edit blocked'; end if;
  update public.community_comments set content='Commentaire modifie normalement.' where id=comment_id;
  get diagnostics affected=row_count;
  if affected<>1 then raise exception 'Own comment edit blocked'; end if;
  update public.community_messages set content='Message modifie normalement.' where id=message_id;
  get diagnostics affected=row_count;
  if affected<>1 then raise exception 'Own message edit blocked'; end if;
  begin
    update public.community_posts set is_pinned=true where id=post;
    raise exception 'FAIL author pin allowed';
  exception when insufficient_privilege then null; end;
  begin
    perform public.community_moderate_post(post,'hide','Test non autorise');
    raise exception 'FAIL user moderation allowed';
  exception when insufficient_privilege then null; end;
  begin
    perform public.admin_subscription_sources();
    raise exception 'FAIL user billing access allowed';
  exception when insufficient_privilege then null; end;
  execute 'reset role';
  update public.community_posts set status='hidden' where id=post;
  update public.community_comments set status='hidden' where id=comment_id;
  execute 'set local role authenticated';
  begin
    update public.community_posts set status='published' where id=post;
    raise exception 'FAIL author restore allowed';
  exception when insufficient_privilege then null; end;
  begin
    update public.community_comments set status='published' where id=comment_id;
    raise exception 'FAIL comment restore allowed';
  exception when insufficient_privilege then null; end;
  execute 'reset role';
  insert into public.admin_users(id,email,role,auth_uid,disabled,permissions)
    values(staff,'build10-regression@example.invalid','moderator',uid,false,'{"quiz.write":true,"subscriptions.write":true,"cas_pratiques":true}'::jsonb);
  insert into public.community_moderator_scopes(user_id,space_id,role,granted_by) values(uid,'gpx_exam','moderator',founder);
  execute 'set local role authenticated';
  if public.has_admin_permission('quiz.write') or public.has_admin_permission('subscriptions.write')
    or public.has_admin_permission('cas_pratiques') or public.is_admin(uid) then
    raise exception 'FAIL moderator has app powers';
  end if;
  perform public.community_moderate_post(post,'restore','Restauration autorisee pour verification');
  begin
    perform public.admin_grant_access(uid,'premium',30);
    raise exception 'FAIL moderator can grant premium';
  exception when insufficient_privilege then null; end;
  execute 'reset role';
  update public.admin_users set role='admin' where id=staff;
  perform set_config('copiq.role_change_authorized','true',true);
  update public.user_profiles set role='admin' where user_id=uid;
  execute 'set local role authenticated';
  begin
    perform public.set_user_role(founder,'user');
    raise exception 'FAIL admin demoted founder';
  exception when insufficient_privilege then null; end;
  begin
    perform public.admin_revoke_access(uid);
    raise exception 'FAIL admin can revoke premium';
  exception when insufficient_privilege then null; end;
  execute 'reset role';
  delete from public.community_moderator_scopes where user_id=uid;
  update public.community_comments set status='published' where id=comment_id;
  insert into public.community_sanctions(user_id,space_id,kind,status,reason,ends_at,imposed_by)
    values(uid,'gpx_exam','suspension','active','Sanction temporaire de verification',now()+interval '1 day',founder);
  execute 'set local role authenticated';
  begin
    update public.community_posts set content='Tentative de contournement par une ancienne publication.' where id=post;
    raise exception 'FAIL sanctioned post edit allowed';
  exception when insufficient_privilege then null; end;
  begin
    update public.community_comments set content='Contournement par un ancien commentaire.' where id=comment_id;
    raise exception 'FAIL sanctioned comment edit allowed';
  exception when insufficient_privilege then null; end;
  update public.community_comments set status='deleted_by_author',content='[supprimé]',deleted_at=now() where id=comment_id;
  get diagnostics affected=row_count;
  if affected<>1 then raise exception 'Sanctioned author deletion blocked'; end if;
  update public.community_posts set status='deleted_by_author',deleted_at=now() where id=post;
  get diagnostics affected=row_count;
  if affected<>1 then raise exception 'Sanctioned author post deletion blocked'; end if;
  begin
    update public.community_messages set content='Contournement via message.' where id=message_id;
    raise exception 'FAIL sanctioned message edit allowed';
  exception when insufficient_privilege then null; end;
  update public.community_messages set status='deleted_by_author',content='[supprimé]',deleted_at=now() where id=message_id;
  get diagnostics affected=row_count;
  if affected<>1 then raise exception 'Sanctioned message deletion blocked'; end if;
  execute 'reset role';
  perform set_config('request.jwt.claims',jsonb_build_object('sub',founder,'role','authenticated','aal','aal2')::text,true);
  execute 'set local role authenticated';
  report:=public.admin_subscription_sources(uid::text,null,10,0);
  if jsonb_array_length(report)<>1 then raise exception 'Founder overview failed'; end if;
  perform public.admin_grant_access(uid,'premium',1);
  perform public.admin_revoke_access(uid);
  execute 'reset role';
  -- Test purchases remain separate from gifts and cannot grant access unless
  -- production or an explicitly authorized sandbox tester.
  perform set_config('request.jwt.claims','{}',true);
  delete from public.store_entitlements where user_id=uid;
  delete from public.store_sandbox_testers where user_id=uid;
  insert into public.store_entitlements(user_id,environment,product_id,store,plan,expires_at,revoked,verified_at)
    values(uid,'SANDBOX','build10-test-month','app_store','month',now()+interval '1 day',false,now());
  perform set_config('request.jwt.claims',jsonb_build_object('sub',founder,'role','authenticated','aal','aal2')::text,true);
  execute 'set local role authenticated';
  if public.is_user_premium(uid) then raise exception 'FAIL unauthorized sandbox premium'; end if;
  report:=public.admin_subscription_sources(uid::text,null,10,0);
  if not (report->0->'sources' @> '[{"source":"APP_STORE","environment":"SANDBOX","grants_access":false}]'::jsonb) then
    raise exception 'FAIL sandbox source display';
  end if;
  execute 'reset role';
  perform set_config('request.jwt.claims','{}',true);
  insert into public.store_entitlements(user_id,environment,product_id,store,plan,expires_at,revoked,verified_at)
    values(uid,'PRODUCTION','build10-test-year','play_store','year',now()+interval '1 day',false,now());
  perform set_config('request.jwt.claims',jsonb_build_object('sub',founder,'role','authenticated','aal','aal2')::text,true);
  execute 'set local role authenticated';
  perform public.admin_grant_access(uid,'premium',1);
  perform public.admin_revoke_access(uid);
  if not public.is_user_premium(uid) then raise exception 'FAIL gift removal revoked store purchase'; end if;
  report:=public.admin_subscription_sources(uid::text,null,10,0);
  if not (report->0->'sources' @> '[{"source":"PLAY_STORE","environment":"PRODUCTION","grants_access":true}]'::jsonb) then
    raise exception 'FAIL Google production source display';
  end if;
  execute 'reset role';
  if (select count(*) from public.admin_users where role='owner' and not disabled)=1 then
    begin
      update public.admin_users set role='admin' where auth_uid=founder;
      raise exception 'FAIL last panel founder removed';
    exception when insufficient_privilege then null; end;
  end if;
  if (select count(*) from public.user_profiles where role::text='owner')=1 then
    begin
      perform public.set_user_role(founder,'admin');
      raise exception 'FAIL last profile founder removed';
    exception when insufficient_privilege then null; end;
  end if;
end $$;
select 'Build 10 security regression: PASS (all fixtures rolled back)' as result;
rollback;
