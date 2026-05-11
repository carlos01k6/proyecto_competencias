--
-- PostgreSQL database dump
--

\restrict i0bFTnZNCYkMxHmeYMeD0ADAZugiTUWelCJCcaL1BrBubquJfZ9dknrvoBAR9kA

-- Dumped from database version 17.6
-- Dumped by pg_dump version 18.3

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: auth; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA auth;


ALTER SCHEMA auth OWNER TO supabase_admin;

--
-- Name: extensions; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA extensions;


ALTER SCHEMA extensions OWNER TO postgres;

--
-- Name: graphql; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA graphql;


ALTER SCHEMA graphql OWNER TO supabase_admin;

--
-- Name: graphql_public; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA graphql_public;


ALTER SCHEMA graphql_public OWNER TO supabase_admin;

--
-- Name: pgbouncer; Type: SCHEMA; Schema: -; Owner: pgbouncer
--

CREATE SCHEMA pgbouncer;


ALTER SCHEMA pgbouncer OWNER TO pgbouncer;

--
-- Name: realtime; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA realtime;


ALTER SCHEMA realtime OWNER TO supabase_admin;

--
-- Name: storage; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA storage;


ALTER SCHEMA storage OWNER TO supabase_admin;

--
-- Name: vault; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA vault;


ALTER SCHEMA vault OWNER TO supabase_admin;

--
-- Name: pg_stat_statements; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_stat_statements WITH SCHEMA extensions;


--
-- Name: EXTENSION pg_stat_statements; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_stat_statements IS 'track planning and execution statistics of all SQL statements executed';


--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA extensions;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- Name: supabase_vault; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS supabase_vault WITH SCHEMA vault;


--
-- Name: EXTENSION supabase_vault; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION supabase_vault IS 'Supabase Vault Extension';


--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA extensions;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


--
-- Name: aal_level; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.aal_level AS ENUM (
    'aal1',
    'aal2',
    'aal3'
);


ALTER TYPE auth.aal_level OWNER TO supabase_auth_admin;

--
-- Name: code_challenge_method; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.code_challenge_method AS ENUM (
    's256',
    'plain'
);


ALTER TYPE auth.code_challenge_method OWNER TO supabase_auth_admin;

--
-- Name: factor_status; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.factor_status AS ENUM (
    'unverified',
    'verified'
);


ALTER TYPE auth.factor_status OWNER TO supabase_auth_admin;

--
-- Name: factor_type; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.factor_type AS ENUM (
    'totp',
    'webauthn',
    'phone'
);


ALTER TYPE auth.factor_type OWNER TO supabase_auth_admin;

--
-- Name: oauth_authorization_status; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.oauth_authorization_status AS ENUM (
    'pending',
    'approved',
    'denied',
    'expired'
);


ALTER TYPE auth.oauth_authorization_status OWNER TO supabase_auth_admin;

--
-- Name: oauth_client_type; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.oauth_client_type AS ENUM (
    'public',
    'confidential'
);


ALTER TYPE auth.oauth_client_type OWNER TO supabase_auth_admin;

--
-- Name: oauth_registration_type; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.oauth_registration_type AS ENUM (
    'dynamic',
    'manual'
);


ALTER TYPE auth.oauth_registration_type OWNER TO supabase_auth_admin;

--
-- Name: oauth_response_type; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.oauth_response_type AS ENUM (
    'code'
);


ALTER TYPE auth.oauth_response_type OWNER TO supabase_auth_admin;

--
-- Name: one_time_token_type; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.one_time_token_type AS ENUM (
    'confirmation_token',
    'reauthentication_token',
    'recovery_token',
    'email_change_token_new',
    'email_change_token_current',
    'phone_change_token'
);


ALTER TYPE auth.one_time_token_type OWNER TO supabase_auth_admin;

--
-- Name: action; Type: TYPE; Schema: realtime; Owner: supabase_admin
--

CREATE TYPE realtime.action AS ENUM (
    'INSERT',
    'UPDATE',
    'DELETE',
    'TRUNCATE',
    'ERROR'
);


ALTER TYPE realtime.action OWNER TO supabase_admin;

--
-- Name: equality_op; Type: TYPE; Schema: realtime; Owner: supabase_admin
--

CREATE TYPE realtime.equality_op AS ENUM (
    'eq',
    'neq',
    'lt',
    'lte',
    'gt',
    'gte',
    'in'
);


ALTER TYPE realtime.equality_op OWNER TO supabase_admin;

--
-- Name: user_defined_filter; Type: TYPE; Schema: realtime; Owner: supabase_admin
--

CREATE TYPE realtime.user_defined_filter AS (
	column_name text,
	op realtime.equality_op,
	value text
);


ALTER TYPE realtime.user_defined_filter OWNER TO supabase_admin;

--
-- Name: wal_column; Type: TYPE; Schema: realtime; Owner: supabase_admin
--

CREATE TYPE realtime.wal_column AS (
	name text,
	type_name text,
	type_oid oid,
	value jsonb,
	is_pkey boolean,
	is_selectable boolean
);


ALTER TYPE realtime.wal_column OWNER TO supabase_admin;

--
-- Name: wal_rls; Type: TYPE; Schema: realtime; Owner: supabase_admin
--

CREATE TYPE realtime.wal_rls AS (
	wal jsonb,
	is_rls_enabled boolean,
	subscription_ids uuid[],
	errors text[]
);


ALTER TYPE realtime.wal_rls OWNER TO supabase_admin;

--
-- Name: buckettype; Type: TYPE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TYPE storage.buckettype AS ENUM (
    'STANDARD',
    'ANALYTICS',
    'VECTOR'
);


ALTER TYPE storage.buckettype OWNER TO supabase_storage_admin;

--
-- Name: email(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.email() RETURNS text
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.email', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'email')
  )::text
$$;


ALTER FUNCTION auth.email() OWNER TO supabase_auth_admin;

--
-- Name: FUNCTION email(); Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON FUNCTION auth.email() IS 'Deprecated. Use auth.jwt() -> ''email'' instead.';


--
-- Name: jwt(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.jwt() RETURNS jsonb
    LANGUAGE sql STABLE
    AS $$
  select 
    coalesce(
        nullif(current_setting('request.jwt.claim', true), ''),
        nullif(current_setting('request.jwt.claims', true), '')
    )::jsonb
$$;


ALTER FUNCTION auth.jwt() OWNER TO supabase_auth_admin;

--
-- Name: role(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.role() RETURNS text
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.role', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'role')
  )::text
$$;


ALTER FUNCTION auth.role() OWNER TO supabase_auth_admin;

--
-- Name: FUNCTION role(); Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON FUNCTION auth.role() IS 'Deprecated. Use auth.jwt() -> ''role'' instead.';


--
-- Name: uid(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.uid() RETURNS uuid
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.sub', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'sub')
  )::uuid
$$;


ALTER FUNCTION auth.uid() OWNER TO supabase_auth_admin;

--
-- Name: FUNCTION uid(); Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON FUNCTION auth.uid() IS 'Deprecated. Use auth.jwt() -> ''sub'' instead.';


--
-- Name: grant_pg_cron_access(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.grant_pg_cron_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF EXISTS (
    SELECT
    FROM pg_event_trigger_ddl_commands() AS ev
    JOIN pg_extension AS ext
    ON ev.objid = ext.oid
    WHERE ext.extname = 'pg_cron'
  )
  THEN
    grant usage on schema cron to postgres with grant option;

    alter default privileges in schema cron grant all on tables to postgres with grant option;
    alter default privileges in schema cron grant all on functions to postgres with grant option;
    alter default privileges in schema cron grant all on sequences to postgres with grant option;

    alter default privileges for user supabase_admin in schema cron grant all
        on sequences to postgres with grant option;
    alter default privileges for user supabase_admin in schema cron grant all
        on tables to postgres with grant option;
    alter default privileges for user supabase_admin in schema cron grant all
        on functions to postgres with grant option;

    grant all privileges on all tables in schema cron to postgres with grant option;
    revoke all on table cron.job from postgres;
    grant select on table cron.job to postgres with grant option;
  END IF;
END;
$$;


ALTER FUNCTION extensions.grant_pg_cron_access() OWNER TO supabase_admin;

--
-- Name: FUNCTION grant_pg_cron_access(); Type: COMMENT; Schema: extensions; Owner: supabase_admin
--

COMMENT ON FUNCTION extensions.grant_pg_cron_access() IS 'Grants access to pg_cron';


--
-- Name: grant_pg_graphql_access(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.grant_pg_graphql_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $_$
DECLARE
    func_is_graphql_resolve bool;
BEGIN
    func_is_graphql_resolve = (
        SELECT n.proname = 'resolve'
        FROM pg_event_trigger_ddl_commands() AS ev
        LEFT JOIN pg_catalog.pg_proc AS n
        ON ev.objid = n.oid
    );

    IF func_is_graphql_resolve
    THEN
        -- Update public wrapper to pass all arguments through to the pg_graphql resolve func
        DROP FUNCTION IF EXISTS graphql_public.graphql;
        create or replace function graphql_public.graphql(
            "operationName" text default null,
            query text default null,
            variables jsonb default null,
            extensions jsonb default null
        )
            returns jsonb
            language sql
        as $$
            select graphql.resolve(
                query := query,
                variables := coalesce(variables, '{}'),
                "operationName" := "operationName",
                extensions := extensions
            );
        $$;

        -- This hook executes when `graphql.resolve` is created. That is not necessarily the last
        -- function in the extension so we need to grant permissions on existing entities AND
        -- update default permissions to any others that are created after `graphql.resolve`
        grant usage on schema graphql to postgres, anon, authenticated, service_role;
        grant select on all tables in schema graphql to postgres, anon, authenticated, service_role;
        grant execute on all functions in schema graphql to postgres, anon, authenticated, service_role;
        grant all on all sequences in schema graphql to postgres, anon, authenticated, service_role;
        alter default privileges in schema graphql grant all on tables to postgres, anon, authenticated, service_role;
        alter default privileges in schema graphql grant all on functions to postgres, anon, authenticated, service_role;
        alter default privileges in schema graphql grant all on sequences to postgres, anon, authenticated, service_role;

        -- Allow postgres role to allow granting usage on graphql and graphql_public schemas to custom roles
        grant usage on schema graphql_public to postgres with grant option;
        grant usage on schema graphql to postgres with grant option;
    END IF;

END;
$_$;


ALTER FUNCTION extensions.grant_pg_graphql_access() OWNER TO supabase_admin;

--
-- Name: FUNCTION grant_pg_graphql_access(); Type: COMMENT; Schema: extensions; Owner: supabase_admin
--

COMMENT ON FUNCTION extensions.grant_pg_graphql_access() IS 'Grants access to pg_graphql';


--
-- Name: grant_pg_net_access(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.grant_pg_net_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF EXISTS (
    SELECT 1
    FROM pg_event_trigger_ddl_commands() AS ev
    JOIN pg_extension AS ext
    ON ev.objid = ext.oid
    WHERE ext.extname = 'pg_net'
  )
  THEN
    IF NOT EXISTS (
      SELECT 1
      FROM pg_roles
      WHERE rolname = 'supabase_functions_admin'
    )
    THEN
      CREATE USER supabase_functions_admin NOINHERIT CREATEROLE LOGIN NOREPLICATION;
    END IF;

    GRANT USAGE ON SCHEMA net TO supabase_functions_admin, postgres, anon, authenticated, service_role;

    IF EXISTS (
      SELECT FROM pg_extension
      WHERE extname = 'pg_net'
      -- all versions in use on existing projects as of 2025-02-20
      -- version 0.12.0 onwards don't need these applied
      AND extversion IN ('0.2', '0.6', '0.7', '0.7.1', '0.8', '0.10.0', '0.11.0')
    ) THEN
      ALTER function net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) SECURITY DEFINER;
      ALTER function net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) SECURITY DEFINER;

      ALTER function net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) SET search_path = net;
      ALTER function net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) SET search_path = net;

      REVOKE ALL ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) FROM PUBLIC;
      REVOKE ALL ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) FROM PUBLIC;

      GRANT EXECUTE ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) TO supabase_functions_admin, postgres, anon, authenticated, service_role;
      GRANT EXECUTE ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) TO supabase_functions_admin, postgres, anon, authenticated, service_role;
    END IF;
  END IF;
END;
$$;


ALTER FUNCTION extensions.grant_pg_net_access() OWNER TO supabase_admin;

--
-- Name: FUNCTION grant_pg_net_access(); Type: COMMENT; Schema: extensions; Owner: supabase_admin
--

COMMENT ON FUNCTION extensions.grant_pg_net_access() IS 'Grants access to pg_net';


--
-- Name: pgrst_ddl_watch(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.pgrst_ddl_watch() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  cmd record;
BEGIN
  FOR cmd IN SELECT * FROM pg_event_trigger_ddl_commands()
  LOOP
    IF cmd.command_tag IN (
      'CREATE SCHEMA', 'ALTER SCHEMA'
    , 'CREATE TABLE', 'CREATE TABLE AS', 'SELECT INTO', 'ALTER TABLE'
    , 'CREATE FOREIGN TABLE', 'ALTER FOREIGN TABLE'
    , 'CREATE VIEW', 'ALTER VIEW'
    , 'CREATE MATERIALIZED VIEW', 'ALTER MATERIALIZED VIEW'
    , 'CREATE FUNCTION', 'ALTER FUNCTION'
    , 'CREATE TRIGGER'
    , 'CREATE TYPE', 'ALTER TYPE'
    , 'CREATE RULE'
    , 'COMMENT'
    )
    -- don't notify in case of CREATE TEMP table or other objects created on pg_temp
    AND cmd.schema_name is distinct from 'pg_temp'
    THEN
      NOTIFY pgrst, 'reload schema';
    END IF;
  END LOOP;
END; $$;


ALTER FUNCTION extensions.pgrst_ddl_watch() OWNER TO supabase_admin;

--
-- Name: pgrst_drop_watch(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.pgrst_drop_watch() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  obj record;
BEGIN
  FOR obj IN SELECT * FROM pg_event_trigger_dropped_objects()
  LOOP
    IF obj.object_type IN (
      'schema'
    , 'table'
    , 'foreign table'
    , 'view'
    , 'materialized view'
    , 'function'
    , 'trigger'
    , 'type'
    , 'rule'
    )
    AND obj.is_temporary IS false -- no pg_temp objects
    THEN
      NOTIFY pgrst, 'reload schema';
    END IF;
  END LOOP;
END; $$;


ALTER FUNCTION extensions.pgrst_drop_watch() OWNER TO supabase_admin;

--
-- Name: set_graphql_placeholder(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.set_graphql_placeholder() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $_$
    DECLARE
    graphql_is_dropped bool;
    BEGIN
    graphql_is_dropped = (
        SELECT ev.schema_name = 'graphql_public'
        FROM pg_event_trigger_dropped_objects() AS ev
        WHERE ev.schema_name = 'graphql_public'
    );

    IF graphql_is_dropped
    THEN
        create or replace function graphql_public.graphql(
            "operationName" text default null,
            query text default null,
            variables jsonb default null,
            extensions jsonb default null
        )
            returns jsonb
            language plpgsql
        as $$
            DECLARE
                server_version float;
            BEGIN
                server_version = (SELECT (SPLIT_PART((select version()), ' ', 2))::float);

                IF server_version >= 14 THEN
                    RETURN jsonb_build_object(
                        'errors', jsonb_build_array(
                            jsonb_build_object(
                                'message', 'pg_graphql extension is not enabled.'
                            )
                        )
                    );
                ELSE
                    RETURN jsonb_build_object(
                        'errors', jsonb_build_array(
                            jsonb_build_object(
                                'message', 'pg_graphql is only available on projects running Postgres 14 onwards.'
                            )
                        )
                    );
                END IF;
            END;
        $$;
    END IF;

    END;
$_$;


ALTER FUNCTION extensions.set_graphql_placeholder() OWNER TO supabase_admin;

--
-- Name: FUNCTION set_graphql_placeholder(); Type: COMMENT; Schema: extensions; Owner: supabase_admin
--

COMMENT ON FUNCTION extensions.set_graphql_placeholder() IS 'Reintroduces placeholder function for graphql_public.graphql';


--
-- Name: graphql(text, text, jsonb, jsonb); Type: FUNCTION; Schema: graphql_public; Owner: supabase_admin
--

CREATE FUNCTION graphql_public.graphql("operationName" text DEFAULT NULL::text, query text DEFAULT NULL::text, variables jsonb DEFAULT NULL::jsonb, extensions jsonb DEFAULT NULL::jsonb) RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
            DECLARE
                server_version float;
            BEGIN
                server_version = (SELECT (SPLIT_PART((select version()), ' ', 2))::float);

                IF server_version >= 14 THEN
                    RETURN jsonb_build_object(
                        'errors', jsonb_build_array(
                            jsonb_build_object(
                                'message', 'pg_graphql extension is not enabled.'
                            )
                        )
                    );
                ELSE
                    RETURN jsonb_build_object(
                        'errors', jsonb_build_array(
                            jsonb_build_object(
                                'message', 'pg_graphql is only available on projects running Postgres 14 onwards.'
                            )
                        )
                    );
                END IF;
            END;
        $$;


ALTER FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) OWNER TO supabase_admin;

--
-- Name: get_auth(text); Type: FUNCTION; Schema: pgbouncer; Owner: supabase_admin
--

CREATE FUNCTION pgbouncer.get_auth(p_usename text) RETURNS TABLE(username text, password text)
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO ''
    AS $_$
  BEGIN
      RAISE DEBUG 'PgBouncer auth request: %', p_usename;

      RETURN QUERY
      SELECT
          rolname::text,
          CASE WHEN rolvaliduntil < now()
              THEN null
              ELSE rolpassword::text
          END
      FROM pg_authid
      WHERE rolname=$1 and rolcanlogin;
  END;
  $_$;


ALTER FUNCTION pgbouncer.get_auth(p_usename text) OWNER TO supabase_admin;

--
-- Name: apply_rls(jsonb, integer); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer DEFAULT (1024 * 1024)) RETURNS SETOF realtime.wal_rls
    LANGUAGE plpgsql
    AS $$
declare
-- Regclass of the table e.g. public.notes
entity_ regclass = (quote_ident(wal ->> 'schema') || '.' || quote_ident(wal ->> 'table'))::regclass;

-- I, U, D, T: insert, update ...
action realtime.action = (
    case wal ->> 'action'
        when 'I' then 'INSERT'
        when 'U' then 'UPDATE'
        when 'D' then 'DELETE'
        else 'ERROR'
    end
);

-- Is row level security enabled for the table
is_rls_enabled bool = relrowsecurity from pg_class where oid = entity_;

subscriptions realtime.subscription[] = array_agg(subs)
    from
        realtime.subscription subs
    where
        subs.entity = entity_
        -- Filter by action early - only get subscriptions interested in this action
        -- action_filter column can be: '*' (all), 'INSERT', 'UPDATE', or 'DELETE'
        and (subs.action_filter = '*' or subs.action_filter = action::text);

-- Subscription vars
roles regrole[] = array_agg(distinct us.claims_role::text)
    from
        unnest(subscriptions) us;

working_role regrole;
claimed_role regrole;
claims jsonb;

subscription_id uuid;
subscription_has_access bool;
visible_to_subscription_ids uuid[] = '{}';

-- structured info for wal's columns
columns realtime.wal_column[];
-- previous identity values for update/delete
old_columns realtime.wal_column[];

error_record_exceeds_max_size boolean = octet_length(wal::text) > max_record_bytes;

-- Primary jsonb output for record
output jsonb;

begin
perform set_config('role', null, true);

columns =
    array_agg(
        (
            x->>'name',
            x->>'type',
            x->>'typeoid',
            realtime.cast(
                (x->'value') #>> '{}',
                coalesce(
                    (x->>'typeoid')::regtype, -- null when wal2json version <= 2.4
                    (x->>'type')::regtype
                )
            ),
            (pks ->> 'name') is not null,
            true
        )::realtime.wal_column
    )
    from
        jsonb_array_elements(wal -> 'columns') x
        left join jsonb_array_elements(wal -> 'pk') pks
            on (x ->> 'name') = (pks ->> 'name');

old_columns =
    array_agg(
        (
            x->>'name',
            x->>'type',
            x->>'typeoid',
            realtime.cast(
                (x->'value') #>> '{}',
                coalesce(
                    (x->>'typeoid')::regtype, -- null when wal2json version <= 2.4
                    (x->>'type')::regtype
                )
            ),
            (pks ->> 'name') is not null,
            true
        )::realtime.wal_column
    )
    from
        jsonb_array_elements(wal -> 'identity') x
        left join jsonb_array_elements(wal -> 'pk') pks
            on (x ->> 'name') = (pks ->> 'name');

for working_role in select * from unnest(roles) loop

    -- Update `is_selectable` for columns and old_columns
    columns =
        array_agg(
            (
                c.name,
                c.type_name,
                c.type_oid,
                c.value,
                c.is_pkey,
                pg_catalog.has_column_privilege(working_role, entity_, c.name, 'SELECT')
            )::realtime.wal_column
        )
        from
            unnest(columns) c;

    old_columns =
            array_agg(
                (
                    c.name,
                    c.type_name,
                    c.type_oid,
                    c.value,
                    c.is_pkey,
                    pg_catalog.has_column_privilege(working_role, entity_, c.name, 'SELECT')
                )::realtime.wal_column
            )
            from
                unnest(old_columns) c;

    if action <> 'DELETE' and count(1) = 0 from unnest(columns) c where c.is_pkey then
        return next (
            jsonb_build_object(
                'schema', wal ->> 'schema',
                'table', wal ->> 'table',
                'type', action
            ),
            is_rls_enabled,
            -- subscriptions is already filtered by entity
            (select array_agg(s.subscription_id) from unnest(subscriptions) as s where claims_role = working_role),
            array['Error 400: Bad Request, no primary key']
        )::realtime.wal_rls;

    -- The claims role does not have SELECT permission to the primary key of entity
    elsif action <> 'DELETE' and sum(c.is_selectable::int) <> count(1) from unnest(columns) c where c.is_pkey then
        return next (
            jsonb_build_object(
                'schema', wal ->> 'schema',
                'table', wal ->> 'table',
                'type', action
            ),
            is_rls_enabled,
            (select array_agg(s.subscription_id) from unnest(subscriptions) as s where claims_role = working_role),
            array['Error 401: Unauthorized']
        )::realtime.wal_rls;

    else
        output = jsonb_build_object(
            'schema', wal ->> 'schema',
            'table', wal ->> 'table',
            'type', action,
            'commit_timestamp', to_char(
                ((wal ->> 'timestamp')::timestamptz at time zone 'utc'),
                'YYYY-MM-DD"T"HH24:MI:SS.MS"Z"'
            ),
            'columns', (
                select
                    jsonb_agg(
                        jsonb_build_object(
                            'name', pa.attname,
                            'type', pt.typname
                        )
                        order by pa.attnum asc
                    )
                from
                    pg_attribute pa
                    join pg_type pt
                        on pa.atttypid = pt.oid
                where
                    attrelid = entity_
                    and attnum > 0
                    and pg_catalog.has_column_privilege(working_role, entity_, pa.attname, 'SELECT')
            )
        )
        -- Add "record" key for insert and update
        || case
            when action in ('INSERT', 'UPDATE') then
                jsonb_build_object(
                    'record',
                    (
                        select
                            jsonb_object_agg(
                                -- if unchanged toast, get column name and value from old record
                                coalesce((c).name, (oc).name),
                                case
                                    when (c).name is null then (oc).value
                                    else (c).value
                                end
                            )
                        from
                            unnest(columns) c
                            full outer join unnest(old_columns) oc
                                on (c).name = (oc).name
                        where
                            coalesce((c).is_selectable, (oc).is_selectable)
                            and ( not error_record_exceeds_max_size or (octet_length((c).value::text) <= 64))
                    )
                )
            else '{}'::jsonb
        end
        -- Add "old_record" key for update and delete
        || case
            when action = 'UPDATE' then
                jsonb_build_object(
                        'old_record',
                        (
                            select jsonb_object_agg((c).name, (c).value)
                            from unnest(old_columns) c
                            where
                                (c).is_selectable
                                and ( not error_record_exceeds_max_size or (octet_length((c).value::text) <= 64))
                        )
                    )
            when action = 'DELETE' then
                jsonb_build_object(
                    'old_record',
                    (
                        select jsonb_object_agg((c).name, (c).value)
                        from unnest(old_columns) c
                        where
                            (c).is_selectable
                            and ( not error_record_exceeds_max_size or (octet_length((c).value::text) <= 64))
                            and ( not is_rls_enabled or (c).is_pkey ) -- if RLS enabled, we can't secure deletes so filter to pkey
                    )
                )
            else '{}'::jsonb
        end;

        -- Create the prepared statement
        if is_rls_enabled and action <> 'DELETE' then
            if (select 1 from pg_prepared_statements where name = 'walrus_rls_stmt' limit 1) > 0 then
                deallocate walrus_rls_stmt;
            end if;
            execute realtime.build_prepared_statement_sql('walrus_rls_stmt', entity_, columns);
        end if;

        visible_to_subscription_ids = '{}';

        for subscription_id, claims in (
                select
                    subs.subscription_id,
                    subs.claims
                from
                    unnest(subscriptions) subs
                where
                    subs.entity = entity_
                    and subs.claims_role = working_role
                    and (
                        realtime.is_visible_through_filters(columns, subs.filters)
                        or (
                          action = 'DELETE'
                          and realtime.is_visible_through_filters(old_columns, subs.filters)
                        )
                    )
        ) loop

            if not is_rls_enabled or action = 'DELETE' then
                visible_to_subscription_ids = visible_to_subscription_ids || subscription_id;
            else
                -- Check if RLS allows the role to see the record
                perform
                    -- Trim leading and trailing quotes from working_role because set_config
                    -- doesn't recognize the role as valid if they are included
                    set_config('role', trim(both '"' from working_role::text), true),
                    set_config('request.jwt.claims', claims::text, true);

                execute 'execute walrus_rls_stmt' into subscription_has_access;

                if subscription_has_access then
                    visible_to_subscription_ids = visible_to_subscription_ids || subscription_id;
                end if;
            end if;
        end loop;

        perform set_config('role', null, true);

        return next (
            output,
            is_rls_enabled,
            visible_to_subscription_ids,
            case
                when error_record_exceeds_max_size then array['Error 413: Payload Too Large']
                else '{}'
            end
        )::realtime.wal_rls;

    end if;
end loop;

perform set_config('role', null, true);
end;
$$;


ALTER FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) OWNER TO supabase_admin;

--
-- Name: broadcast_changes(text, text, text, text, text, record, record, text); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text DEFAULT 'ROW'::text) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
    -- Declare a variable to hold the JSONB representation of the row
    row_data jsonb := '{}'::jsonb;
BEGIN
    IF level = 'STATEMENT' THEN
        RAISE EXCEPTION 'function can only be triggered for each row, not for each statement';
    END IF;
    -- Check the operation type and handle accordingly
    IF operation = 'INSERT' OR operation = 'UPDATE' OR operation = 'DELETE' THEN
        row_data := jsonb_build_object('old_record', OLD, 'record', NEW, 'operation', operation, 'table', table_name, 'schema', table_schema);
        PERFORM realtime.send (row_data, event_name, topic_name);
    ELSE
        RAISE EXCEPTION 'Unexpected operation type: %', operation;
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Failed to process the row: %', SQLERRM;
END;

$$;


ALTER FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text) OWNER TO supabase_admin;

--
-- Name: build_prepared_statement_sql(text, regclass, realtime.wal_column[]); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) RETURNS text
    LANGUAGE sql
    AS $$
      /*
      Builds a sql string that, if executed, creates a prepared statement to
      tests retrive a row from *entity* by its primary key columns.
      Example
          select realtime.build_prepared_statement_sql('public.notes', '{"id"}'::text[], '{"bigint"}'::text[])
      */
          select
      'prepare ' || prepared_statement_name || ' as
          select
              exists(
                  select
                      1
                  from
                      ' || entity || '
                  where
                      ' || string_agg(quote_ident(pkc.name) || '=' || quote_nullable(pkc.value #>> '{}') , ' and ') || '
              )'
          from
              unnest(columns) pkc
          where
              pkc.is_pkey
          group by
              entity
      $$;


ALTER FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) OWNER TO supabase_admin;

--
-- Name: cast(text, regtype); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime."cast"(val text, type_ regtype) RETURNS jsonb
    LANGUAGE plpgsql IMMUTABLE
    AS $$
declare
  res jsonb;
begin
  if type_::text = 'bytea' then
    return to_jsonb(val);
  end if;
  execute format('select to_jsonb(%L::'|| type_::text || ')', val) into res;
  return res;
end
$$;


ALTER FUNCTION realtime."cast"(val text, type_ regtype) OWNER TO supabase_admin;

--
-- Name: check_equality_op(realtime.equality_op, regtype, text, text); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) RETURNS boolean
    LANGUAGE plpgsql IMMUTABLE
    AS $$
      /*
      Casts *val_1* and *val_2* as type *type_* and check the *op* condition for truthiness
      */
      declare
          op_symbol text = (
              case
                  when op = 'eq' then '='
                  when op = 'neq' then '!='
                  when op = 'lt' then '<'
                  when op = 'lte' then '<='
                  when op = 'gt' then '>'
                  when op = 'gte' then '>='
                  when op = 'in' then '= any'
                  else 'UNKNOWN OP'
              end
          );
          res boolean;
      begin
          execute format(
              'select %L::'|| type_::text || ' ' || op_symbol
              || ' ( %L::'
              || (
                  case
                      when op = 'in' then type_::text || '[]'
                      else type_::text end
              )
              || ')', val_1, val_2) into res;
          return res;
      end;
      $$;


ALTER FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) OWNER TO supabase_admin;

--
-- Name: is_visible_through_filters(realtime.wal_column[], realtime.user_defined_filter[]); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) RETURNS boolean
    LANGUAGE sql IMMUTABLE
    AS $_$
    /*
    Should the record be visible (true) or filtered out (false) after *filters* are applied
    */
        select
            -- Default to allowed when no filters present
            $2 is null -- no filters. this should not happen because subscriptions has a default
            or array_length($2, 1) is null -- array length of an empty array is null
            or bool_and(
                coalesce(
                    realtime.check_equality_op(
                        op:=f.op,
                        type_:=coalesce(
                            col.type_oid::regtype, -- null when wal2json version <= 2.4
                            col.type_name::regtype
                        ),
                        -- cast jsonb to text
                        val_1:=col.value #>> '{}',
                        val_2:=f.value
                    ),
                    false -- if null, filter does not match
                )
            )
        from
            unnest(filters) f
            join unnest(columns) col
                on f.column_name = col.name;
    $_$;


ALTER FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) OWNER TO supabase_admin;

--
-- Name: list_changes(name, name, integer, integer); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) RETURNS TABLE(wal jsonb, is_rls_enabled boolean, subscription_ids uuid[], errors text[], slot_changes_count bigint)
    LANGUAGE sql
    SET log_min_messages TO 'fatal'
    AS $$
  WITH pub AS (
    SELECT
      concat_ws(
        ',',
        CASE WHEN bool_or(pubinsert) THEN 'insert' ELSE NULL END,
        CASE WHEN bool_or(pubupdate) THEN 'update' ELSE NULL END,
        CASE WHEN bool_or(pubdelete) THEN 'delete' ELSE NULL END
      ) AS w2j_actions,
      coalesce(
        string_agg(
          realtime.quote_wal2json(format('%I.%I', schemaname, tablename)::regclass),
          ','
        ) filter (WHERE ppt.tablename IS NOT NULL AND ppt.tablename NOT LIKE '% %'),
        ''
      ) AS w2j_add_tables
    FROM pg_publication pp
    LEFT JOIN pg_publication_tables ppt ON pp.pubname = ppt.pubname
    WHERE pp.pubname = publication
    GROUP BY pp.pubname
    LIMIT 1
  ),
  -- MATERIALIZED ensures pg_logical_slot_get_changes is called exactly once
  w2j AS MATERIALIZED (
    SELECT x.*, pub.w2j_add_tables
    FROM pub,
         pg_logical_slot_get_changes(
           slot_name, null, max_changes,
           'include-pk', 'true',
           'include-transaction', 'false',
           'include-timestamp', 'true',
           'include-type-oids', 'true',
           'format-version', '2',
           'actions', pub.w2j_actions,
           'add-tables', pub.w2j_add_tables
         ) x
  ),
  -- Count raw slot entries before apply_rls/subscription filter
  slot_count AS (
    SELECT count(*)::bigint AS cnt
    FROM w2j
    WHERE w2j.w2j_add_tables <> ''
  ),
  -- Apply RLS and filter as before
  rls_filtered AS (
    SELECT xyz.wal, xyz.is_rls_enabled, xyz.subscription_ids, xyz.errors
    FROM w2j,
         realtime.apply_rls(
           wal := w2j.data::jsonb,
           max_record_bytes := max_record_bytes
         ) xyz(wal, is_rls_enabled, subscription_ids, errors)
    WHERE w2j.w2j_add_tables <> ''
      AND xyz.subscription_ids[1] IS NOT NULL
  )
  -- Real rows with slot count attached
  SELECT rf.wal, rf.is_rls_enabled, rf.subscription_ids, rf.errors, sc.cnt
  FROM rls_filtered rf, slot_count sc

  UNION ALL

  -- Sentinel row: always returned when no real rows exist so Elixir can
  -- always read slot_changes_count. Identified by wal IS NULL.
  SELECT null, null, null, null, sc.cnt
  FROM slot_count sc
  WHERE NOT EXISTS (SELECT 1 FROM rls_filtered)
$$;


ALTER FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) OWNER TO supabase_admin;

--
-- Name: quote_wal2json(regclass); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.quote_wal2json(entity regclass) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $$
      select
        (
          select string_agg('' || ch,'')
          from unnest(string_to_array(nsp.nspname::text, null)) with ordinality x(ch, idx)
          where
            not (x.idx = 1 and x.ch = '"')
            and not (
              x.idx = array_length(string_to_array(nsp.nspname::text, null), 1)
              and x.ch = '"'
            )
        )
        || '.'
        || (
          select string_agg('' || ch,'')
          from unnest(string_to_array(pc.relname::text, null)) with ordinality x(ch, idx)
          where
            not (x.idx = 1 and x.ch = '"')
            and not (
              x.idx = array_length(string_to_array(nsp.nspname::text, null), 1)
              and x.ch = '"'
            )
          )
      from
        pg_class pc
        join pg_namespace nsp
          on pc.relnamespace = nsp.oid
      where
        pc.oid = entity
    $$;


ALTER FUNCTION realtime.quote_wal2json(entity regclass) OWNER TO supabase_admin;

--
-- Name: send(jsonb, text, text, boolean); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean DEFAULT true) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
  generated_id uuid;
  final_payload jsonb;
BEGIN
  BEGIN
    -- Generate a new UUID for the id
    generated_id := gen_random_uuid();

    -- Check if payload has an 'id' key, if not, add the generated UUID
    IF payload ? 'id' THEN
      final_payload := payload;
    ELSE
      final_payload := jsonb_set(payload, '{id}', to_jsonb(generated_id));
    END IF;

    -- Set the topic configuration
    EXECUTE format('SET LOCAL realtime.topic TO %L', topic);

    -- Attempt to insert the message
    INSERT INTO realtime.messages (id, payload, event, topic, private, extension)
    VALUES (generated_id, final_payload, event, topic, private, 'broadcast');
  EXCEPTION
    WHEN OTHERS THEN
      -- Capture and notify the error
      RAISE WARNING 'ErrorSendingBroadcastMessage: %', SQLERRM;
  END;
END;
$$;


ALTER FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean) OWNER TO supabase_admin;

--
-- Name: subscription_check_filters(); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.subscription_check_filters() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    /*
    Validates that the user defined filters for a subscription:
    - refer to valid columns that the claimed role may access
    - values are coercable to the correct column type
    */
    declare
        col_names text[] = coalesce(
                array_agg(c.column_name order by c.ordinal_position),
                '{}'::text[]
            )
            from
                information_schema.columns c
            where
                format('%I.%I', c.table_schema, c.table_name)::regclass = new.entity
                and pg_catalog.has_column_privilege(
                    (new.claims ->> 'role'),
                    format('%I.%I', c.table_schema, c.table_name)::regclass,
                    c.column_name,
                    'SELECT'
                );
        filter realtime.user_defined_filter;
        col_type regtype;

        in_val jsonb;
    begin
        for filter in select * from unnest(new.filters) loop
            -- Filtered column is valid
            if not filter.column_name = any(col_names) then
                raise exception 'invalid column for filter %', filter.column_name;
            end if;

            -- Type is sanitized and safe for string interpolation
            col_type = (
                select atttypid::regtype
                from pg_catalog.pg_attribute
                where attrelid = new.entity
                      and attname = filter.column_name
            );
            if col_type is null then
                raise exception 'failed to lookup type for column %', filter.column_name;
            end if;

            -- Set maximum number of entries for in filter
            if filter.op = 'in'::realtime.equality_op then
                in_val = realtime.cast(filter.value, (col_type::text || '[]')::regtype);
                if coalesce(jsonb_array_length(in_val), 0) > 100 then
                    raise exception 'too many values for `in` filter. Maximum 100';
                end if;
            else
                -- raises an exception if value is not coercable to type
                perform realtime.cast(filter.value, col_type);
            end if;

        end loop;

        -- Apply consistent order to filters so the unique constraint on
        -- (subscription_id, entity, filters) can't be tricked by a different filter order
        new.filters = coalesce(
            array_agg(f order by f.column_name, f.op, f.value),
            '{}'
        ) from unnest(new.filters) f;

        return new;
    end;
    $$;


ALTER FUNCTION realtime.subscription_check_filters() OWNER TO supabase_admin;

--
-- Name: to_regrole(text); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.to_regrole(role_name text) RETURNS regrole
    LANGUAGE sql IMMUTABLE
    AS $$ select role_name::regrole $$;


ALTER FUNCTION realtime.to_regrole(role_name text) OWNER TO supabase_admin;

--
-- Name: topic(); Type: FUNCTION; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE FUNCTION realtime.topic() RETURNS text
    LANGUAGE sql STABLE
    AS $$
select nullif(current_setting('realtime.topic', true), '')::text;
$$;


ALTER FUNCTION realtime.topic() OWNER TO supabase_realtime_admin;

--
-- Name: allow_any_operation(text[]); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.allow_any_operation(expected_operations text[]) RETURNS boolean
    LANGUAGE sql STABLE
    AS $$
  WITH current_operation AS (
    SELECT storage.operation() AS raw_operation
  ),
  normalized AS (
    SELECT CASE
      WHEN raw_operation LIKE 'storage.%' THEN substr(raw_operation, 9)
      ELSE raw_operation
    END AS current_operation
    FROM current_operation
  )
  SELECT EXISTS (
    SELECT 1
    FROM normalized n
    CROSS JOIN LATERAL unnest(expected_operations) AS expected_operation
    WHERE expected_operation IS NOT NULL
      AND expected_operation <> ''
      AND n.current_operation = CASE
        WHEN expected_operation LIKE 'storage.%' THEN substr(expected_operation, 9)
        ELSE expected_operation
      END
  );
$$;


ALTER FUNCTION storage.allow_any_operation(expected_operations text[]) OWNER TO supabase_storage_admin;

--
-- Name: allow_only_operation(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.allow_only_operation(expected_operation text) RETURNS boolean
    LANGUAGE sql STABLE
    AS $$
  WITH current_operation AS (
    SELECT storage.operation() AS raw_operation
  ),
  normalized AS (
    SELECT
      CASE
        WHEN raw_operation LIKE 'storage.%' THEN substr(raw_operation, 9)
        ELSE raw_operation
      END AS current_operation,
      CASE
        WHEN expected_operation LIKE 'storage.%' THEN substr(expected_operation, 9)
        ELSE expected_operation
      END AS requested_operation
    FROM current_operation
  )
  SELECT CASE
    WHEN requested_operation IS NULL OR requested_operation = '' THEN FALSE
    ELSE COALESCE(current_operation = requested_operation, FALSE)
  END
  FROM normalized;
$$;


ALTER FUNCTION storage.allow_only_operation(expected_operation text) OWNER TO supabase_storage_admin;

--
-- Name: can_insert_object(text, text, uuid, jsonb); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.can_insert_object(bucketid text, name text, owner uuid, metadata jsonb) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
  INSERT INTO "storage"."objects" ("bucket_id", "name", "owner", "metadata") VALUES (bucketid, name, owner, metadata);
  -- hack to rollback the successful insert
  RAISE sqlstate 'PT200' using
  message = 'ROLLBACK',
  detail = 'rollback successful insert';
END
$$;


ALTER FUNCTION storage.can_insert_object(bucketid text, name text, owner uuid, metadata jsonb) OWNER TO supabase_storage_admin;

--
-- Name: enforce_bucket_name_length(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.enforce_bucket_name_length() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
begin
    if length(new.name) > 100 then
        raise exception 'bucket name "%" is too long (% characters). Max is 100.', new.name, length(new.name);
    end if;
    return new;
end;
$$;


ALTER FUNCTION storage.enforce_bucket_name_length() OWNER TO supabase_storage_admin;

--
-- Name: extension(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.extension(name text) RETURNS text
    LANGUAGE plpgsql IMMUTABLE
    AS $$
DECLARE
    _parts text[];
    _filename text;
BEGIN
    -- Split on "/" to get path segments
    SELECT string_to_array(name, '/') INTO _parts;
    -- Get the last path segment (the actual filename)
    SELECT _parts[array_length(_parts, 1)] INTO _filename;
    -- Extract extension: reverse, split on '.', then reverse again
    RETURN reverse(split_part(reverse(_filename), '.', 1));
END
$$;


ALTER FUNCTION storage.extension(name text) OWNER TO supabase_storage_admin;

--
-- Name: filename(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.filename(name text) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
_parts text[];
BEGIN
	select string_to_array(name, '/') into _parts;
	return _parts[array_length(_parts,1)];
END
$$;


ALTER FUNCTION storage.filename(name text) OWNER TO supabase_storage_admin;

--
-- Name: foldername(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.foldername(name text) RETURNS text[]
    LANGUAGE plpgsql IMMUTABLE
    AS $$
DECLARE
    _parts text[];
BEGIN
    -- Split on "/" to get path segments
    SELECT string_to_array(name, '/') INTO _parts;
    -- Return everything except the last segment
    RETURN _parts[1 : array_length(_parts,1) - 1];
END
$$;


ALTER FUNCTION storage.foldername(name text) OWNER TO supabase_storage_admin;

--
-- Name: get_common_prefix(text, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.get_common_prefix(p_key text, p_prefix text, p_delimiter text) RETURNS text
    LANGUAGE sql IMMUTABLE
    AS $$
SELECT CASE
    WHEN position(p_delimiter IN substring(p_key FROM length(p_prefix) + 1)) > 0
    THEN left(p_key, length(p_prefix) + position(p_delimiter IN substring(p_key FROM length(p_prefix) + 1)))
    ELSE NULL
END;
$$;


ALTER FUNCTION storage.get_common_prefix(p_key text, p_prefix text, p_delimiter text) OWNER TO supabase_storage_admin;

--
-- Name: get_size_by_bucket(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.get_size_by_bucket() RETURNS TABLE(size bigint, bucket_id text)
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
    return query
        select sum((metadata->>'size')::bigint)::bigint as size, obj.bucket_id
        from "storage".objects as obj
        group by obj.bucket_id;
END
$$;


ALTER FUNCTION storage.get_size_by_bucket() OWNER TO supabase_storage_admin;

--
-- Name: list_multipart_uploads_with_delimiter(text, text, text, integer, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.list_multipart_uploads_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer DEFAULT 100, next_key_token text DEFAULT ''::text, next_upload_token text DEFAULT ''::text) RETURNS TABLE(key text, id text, created_at timestamp with time zone)
    LANGUAGE plpgsql
    AS $_$
BEGIN
    RETURN QUERY EXECUTE
        'SELECT DISTINCT ON(key COLLATE "C") * from (
            SELECT
                CASE
                    WHEN position($2 IN substring(key from length($1) + 1)) > 0 THEN
                        substring(key from 1 for length($1) + position($2 IN substring(key from length($1) + 1)))
                    ELSE
                        key
                END AS key, id, created_at
            FROM
                storage.s3_multipart_uploads
            WHERE
                bucket_id = $5 AND
                key ILIKE $1 || ''%'' AND
                CASE
                    WHEN $4 != '''' AND $6 = '''' THEN
                        CASE
                            WHEN position($2 IN substring(key from length($1) + 1)) > 0 THEN
                                substring(key from 1 for length($1) + position($2 IN substring(key from length($1) + 1))) COLLATE "C" > $4
                            ELSE
                                key COLLATE "C" > $4
                            END
                    ELSE
                        true
                END AND
                CASE
                    WHEN $6 != '''' THEN
                        id COLLATE "C" > $6
                    ELSE
                        true
                    END
            ORDER BY
                key COLLATE "C" ASC, created_at ASC) as e order by key COLLATE "C" LIMIT $3'
        USING prefix_param, delimiter_param, max_keys, next_key_token, bucket_id, next_upload_token;
END;
$_$;


ALTER FUNCTION storage.list_multipart_uploads_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer, next_key_token text, next_upload_token text) OWNER TO supabase_storage_admin;

--
-- Name: list_objects_with_delimiter(text, text, text, integer, text, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.list_objects_with_delimiter(_bucket_id text, prefix_param text, delimiter_param text, max_keys integer DEFAULT 100, start_after text DEFAULT ''::text, next_token text DEFAULT ''::text, sort_order text DEFAULT 'asc'::text) RETURNS TABLE(name text, id uuid, metadata jsonb, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone)
    LANGUAGE plpgsql STABLE
    AS $_$
DECLARE
    v_peek_name TEXT;
    v_current RECORD;
    v_common_prefix TEXT;

    -- Configuration
    v_is_asc BOOLEAN;
    v_prefix TEXT;
    v_start TEXT;
    v_upper_bound TEXT;
    v_file_batch_size INT;

    -- Seek state
    v_next_seek TEXT;
    v_count INT := 0;

    -- Dynamic SQL for batch query only
    v_batch_query TEXT;

BEGIN
    -- ========================================================================
    -- INITIALIZATION
    -- ========================================================================
    v_is_asc := lower(coalesce(sort_order, 'asc')) = 'asc';
    v_prefix := coalesce(prefix_param, '');
    v_start := CASE WHEN coalesce(next_token, '') <> '' THEN next_token ELSE coalesce(start_after, '') END;
    v_file_batch_size := LEAST(GREATEST(max_keys * 2, 100), 1000);

    -- Calculate upper bound for prefix filtering (bytewise, using COLLATE "C")
    IF v_prefix = '' THEN
        v_upper_bound := NULL;
    ELSIF right(v_prefix, 1) = delimiter_param THEN
        v_upper_bound := left(v_prefix, -1) || chr(ascii(delimiter_param) + 1);
    ELSE
        v_upper_bound := left(v_prefix, -1) || chr(ascii(right(v_prefix, 1)) + 1);
    END IF;

    -- Build batch query (dynamic SQL - called infrequently, amortized over many rows)
    IF v_is_asc THEN
        IF v_upper_bound IS NOT NULL THEN
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND o.name COLLATE "C" >= $2 ' ||
                'AND o.name COLLATE "C" < $3 ORDER BY o.name COLLATE "C" ASC LIMIT $4';
        ELSE
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND o.name COLLATE "C" >= $2 ' ||
                'ORDER BY o.name COLLATE "C" ASC LIMIT $4';
        END IF;
    ELSE
        IF v_upper_bound IS NOT NULL THEN
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND o.name COLLATE "C" < $2 ' ||
                'AND o.name COLLATE "C" >= $3 ORDER BY o.name COLLATE "C" DESC LIMIT $4';
        ELSE
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND o.name COLLATE "C" < $2 ' ||
                'ORDER BY o.name COLLATE "C" DESC LIMIT $4';
        END IF;
    END IF;

    -- ========================================================================
    -- SEEK INITIALIZATION: Determine starting position
    -- ========================================================================
    IF v_start = '' THEN
        IF v_is_asc THEN
            v_next_seek := v_prefix;
        ELSE
            -- DESC without cursor: find the last item in range
            IF v_upper_bound IS NOT NULL THEN
                SELECT o.name INTO v_next_seek FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" >= v_prefix AND o.name COLLATE "C" < v_upper_bound
                ORDER BY o.name COLLATE "C" DESC LIMIT 1;
            ELSIF v_prefix <> '' THEN
                SELECT o.name INTO v_next_seek FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" >= v_prefix
                ORDER BY o.name COLLATE "C" DESC LIMIT 1;
            ELSE
                SELECT o.name INTO v_next_seek FROM storage.objects o
                WHERE o.bucket_id = _bucket_id
                ORDER BY o.name COLLATE "C" DESC LIMIT 1;
            END IF;

            IF v_next_seek IS NOT NULL THEN
                v_next_seek := v_next_seek || delimiter_param;
            ELSE
                RETURN;
            END IF;
        END IF;
    ELSE
        -- Cursor provided: determine if it refers to a folder or leaf
        IF EXISTS (
            SELECT 1 FROM storage.objects o
            WHERE o.bucket_id = _bucket_id
              AND o.name COLLATE "C" LIKE v_start || delimiter_param || '%'
            LIMIT 1
        ) THEN
            -- Cursor refers to a folder
            IF v_is_asc THEN
                v_next_seek := v_start || chr(ascii(delimiter_param) + 1);
            ELSE
                v_next_seek := v_start || delimiter_param;
            END IF;
        ELSE
            -- Cursor refers to a leaf object
            IF v_is_asc THEN
                v_next_seek := v_start || delimiter_param;
            ELSE
                v_next_seek := v_start;
            END IF;
        END IF;
    END IF;

    -- ========================================================================
    -- MAIN LOOP: Hybrid peek-then-batch algorithm
    -- Uses STATIC SQL for peek (hot path) and DYNAMIC SQL for batch
    -- ========================================================================
    LOOP
        EXIT WHEN v_count >= max_keys;

        -- STEP 1: PEEK using STATIC SQL (plan cached, very fast)
        IF v_is_asc THEN
            IF v_upper_bound IS NOT NULL THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" >= v_next_seek AND o.name COLLATE "C" < v_upper_bound
                ORDER BY o.name COLLATE "C" ASC LIMIT 1;
            ELSE
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" >= v_next_seek
                ORDER BY o.name COLLATE "C" ASC LIMIT 1;
            END IF;
        ELSE
            IF v_upper_bound IS NOT NULL THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" < v_next_seek AND o.name COLLATE "C" >= v_prefix
                ORDER BY o.name COLLATE "C" DESC LIMIT 1;
            ELSIF v_prefix <> '' THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" < v_next_seek AND o.name COLLATE "C" >= v_prefix
                ORDER BY o.name COLLATE "C" DESC LIMIT 1;
            ELSE
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" < v_next_seek
                ORDER BY o.name COLLATE "C" DESC LIMIT 1;
            END IF;
        END IF;

        EXIT WHEN v_peek_name IS NULL;

        -- STEP 2: Check if this is a FOLDER or FILE
        v_common_prefix := storage.get_common_prefix(v_peek_name, v_prefix, delimiter_param);

        IF v_common_prefix IS NOT NULL THEN
            -- FOLDER: Emit and skip to next folder (no heap access needed)
            name := rtrim(v_common_prefix, delimiter_param);
            id := NULL;
            updated_at := NULL;
            created_at := NULL;
            last_accessed_at := NULL;
            metadata := NULL;
            RETURN NEXT;
            v_count := v_count + 1;

            -- Advance seek past the folder range
            IF v_is_asc THEN
                v_next_seek := left(v_common_prefix, -1) || chr(ascii(delimiter_param) + 1);
            ELSE
                v_next_seek := v_common_prefix;
            END IF;
        ELSE
            -- FILE: Batch fetch using DYNAMIC SQL (overhead amortized over many rows)
            -- For ASC: upper_bound is the exclusive upper limit (< condition)
            -- For DESC: prefix is the inclusive lower limit (>= condition)
            FOR v_current IN EXECUTE v_batch_query USING _bucket_id, v_next_seek,
                CASE WHEN v_is_asc THEN COALESCE(v_upper_bound, v_prefix) ELSE v_prefix END, v_file_batch_size
            LOOP
                v_common_prefix := storage.get_common_prefix(v_current.name, v_prefix, delimiter_param);

                IF v_common_prefix IS NOT NULL THEN
                    -- Hit a folder: exit batch, let peek handle it
                    v_next_seek := v_current.name;
                    EXIT;
                END IF;

                -- Emit file
                name := v_current.name;
                id := v_current.id;
                updated_at := v_current.updated_at;
                created_at := v_current.created_at;
                last_accessed_at := v_current.last_accessed_at;
                metadata := v_current.metadata;
                RETURN NEXT;
                v_count := v_count + 1;

                -- Advance seek past this file
                IF v_is_asc THEN
                    v_next_seek := v_current.name || delimiter_param;
                ELSE
                    v_next_seek := v_current.name;
                END IF;

                EXIT WHEN v_count >= max_keys;
            END LOOP;
        END IF;
    END LOOP;
END;
$_$;


ALTER FUNCTION storage.list_objects_with_delimiter(_bucket_id text, prefix_param text, delimiter_param text, max_keys integer, start_after text, next_token text, sort_order text) OWNER TO supabase_storage_admin;

--
-- Name: operation(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.operation() RETURNS text
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
    RETURN current_setting('storage.operation', true);
END;
$$;


ALTER FUNCTION storage.operation() OWNER TO supabase_storage_admin;

--
-- Name: protect_delete(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.protect_delete() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Check if storage.allow_delete_query is set to 'true'
    IF COALESCE(current_setting('storage.allow_delete_query', true), 'false') != 'true' THEN
        RAISE EXCEPTION 'Direct deletion from storage tables is not allowed. Use the Storage API instead.'
            USING HINT = 'This prevents accidental data loss from orphaned objects.',
                  ERRCODE = '42501';
    END IF;
    RETURN NULL;
END;
$$;


ALTER FUNCTION storage.protect_delete() OWNER TO supabase_storage_admin;

--
-- Name: search(text, text, integer, integer, integer, text, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.search(prefix text, bucketname text, limits integer DEFAULT 100, levels integer DEFAULT 1, offsets integer DEFAULT 0, search text DEFAULT ''::text, sortcolumn text DEFAULT 'name'::text, sortorder text DEFAULT 'asc'::text) RETURNS TABLE(name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb)
    LANGUAGE plpgsql STABLE
    AS $_$
DECLARE
    v_peek_name TEXT;
    v_current RECORD;
    v_common_prefix TEXT;
    v_delimiter CONSTANT TEXT := '/';

    -- Configuration
    v_limit INT;
    v_prefix TEXT;
    v_prefix_lower TEXT;
    v_is_asc BOOLEAN;
    v_order_by TEXT;
    v_sort_order TEXT;
    v_upper_bound TEXT;
    v_file_batch_size INT;

    -- Dynamic SQL for batch query only
    v_batch_query TEXT;

    -- Seek state
    v_next_seek TEXT;
    v_count INT := 0;
    v_skipped INT := 0;
BEGIN
    -- ========================================================================
    -- INITIALIZATION
    -- ========================================================================
    v_limit := LEAST(coalesce(limits, 100), 1500);
    v_prefix := coalesce(prefix, '') || coalesce(search, '');
    v_prefix_lower := lower(v_prefix);
    v_is_asc := lower(coalesce(sortorder, 'asc')) = 'asc';
    v_file_batch_size := LEAST(GREATEST(v_limit * 2, 100), 1000);

    -- Validate sort column
    CASE lower(coalesce(sortcolumn, 'name'))
        WHEN 'name' THEN v_order_by := 'name';
        WHEN 'updated_at' THEN v_order_by := 'updated_at';
        WHEN 'created_at' THEN v_order_by := 'created_at';
        WHEN 'last_accessed_at' THEN v_order_by := 'last_accessed_at';
        ELSE v_order_by := 'name';
    END CASE;

    v_sort_order := CASE WHEN v_is_asc THEN 'asc' ELSE 'desc' END;

    -- ========================================================================
    -- NON-NAME SORTING: Use path_tokens approach (unchanged)
    -- ========================================================================
    IF v_order_by != 'name' THEN
        RETURN QUERY EXECUTE format(
            $sql$
            WITH folders AS (
                SELECT path_tokens[$1] AS folder
                FROM storage.objects
                WHERE objects.name ILIKE $2 || '%%'
                  AND bucket_id = $3
                  AND array_length(objects.path_tokens, 1) <> $1
                GROUP BY folder
                ORDER BY folder %s
            )
            (SELECT folder AS "name",
                   NULL::uuid AS id,
                   NULL::timestamptz AS updated_at,
                   NULL::timestamptz AS created_at,
                   NULL::timestamptz AS last_accessed_at,
                   NULL::jsonb AS metadata FROM folders)
            UNION ALL
            (SELECT path_tokens[$1] AS "name",
                   id, updated_at, created_at, last_accessed_at, metadata
             FROM storage.objects
             WHERE objects.name ILIKE $2 || '%%'
               AND bucket_id = $3
               AND array_length(objects.path_tokens, 1) = $1
             ORDER BY %I %s)
            LIMIT $4 OFFSET $5
            $sql$, v_sort_order, v_order_by, v_sort_order
        ) USING levels, v_prefix, bucketname, v_limit, offsets;
        RETURN;
    END IF;

    -- ========================================================================
    -- NAME SORTING: Hybrid skip-scan with batch optimization
    -- ========================================================================

    -- Calculate upper bound for prefix filtering
    IF v_prefix_lower = '' THEN
        v_upper_bound := NULL;
    ELSIF right(v_prefix_lower, 1) = v_delimiter THEN
        v_upper_bound := left(v_prefix_lower, -1) || chr(ascii(v_delimiter) + 1);
    ELSE
        v_upper_bound := left(v_prefix_lower, -1) || chr(ascii(right(v_prefix_lower, 1)) + 1);
    END IF;

    -- Build batch query (dynamic SQL - called infrequently, amortized over many rows)
    IF v_is_asc THEN
        IF v_upper_bound IS NOT NULL THEN
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND lower(o.name) COLLATE "C" >= $2 ' ||
                'AND lower(o.name) COLLATE "C" < $3 ORDER BY lower(o.name) COLLATE "C" ASC LIMIT $4';
        ELSE
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND lower(o.name) COLLATE "C" >= $2 ' ||
                'ORDER BY lower(o.name) COLLATE "C" ASC LIMIT $4';
        END IF;
    ELSE
        IF v_upper_bound IS NOT NULL THEN
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND lower(o.name) COLLATE "C" < $2 ' ||
                'AND lower(o.name) COLLATE "C" >= $3 ORDER BY lower(o.name) COLLATE "C" DESC LIMIT $4';
        ELSE
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND lower(o.name) COLLATE "C" < $2 ' ||
                'ORDER BY lower(o.name) COLLATE "C" DESC LIMIT $4';
        END IF;
    END IF;

    -- Initialize seek position
    IF v_is_asc THEN
        v_next_seek := v_prefix_lower;
    ELSE
        -- DESC: find the last item in range first (static SQL)
        IF v_upper_bound IS NOT NULL THEN
            SELECT o.name INTO v_peek_name FROM storage.objects o
            WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" >= v_prefix_lower AND lower(o.name) COLLATE "C" < v_upper_bound
            ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
        ELSIF v_prefix_lower <> '' THEN
            SELECT o.name INTO v_peek_name FROM storage.objects o
            WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" >= v_prefix_lower
            ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
        ELSE
            SELECT o.name INTO v_peek_name FROM storage.objects o
            WHERE o.bucket_id = bucketname
            ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
        END IF;

        IF v_peek_name IS NOT NULL THEN
            v_next_seek := lower(v_peek_name) || v_delimiter;
        ELSE
            RETURN;
        END IF;
    END IF;

    -- ========================================================================
    -- MAIN LOOP: Hybrid peek-then-batch algorithm
    -- Uses STATIC SQL for peek (hot path) and DYNAMIC SQL for batch
    -- ========================================================================
    LOOP
        EXIT WHEN v_count >= v_limit;

        -- STEP 1: PEEK using STATIC SQL (plan cached, very fast)
        IF v_is_asc THEN
            IF v_upper_bound IS NOT NULL THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" >= v_next_seek AND lower(o.name) COLLATE "C" < v_upper_bound
                ORDER BY lower(o.name) COLLATE "C" ASC LIMIT 1;
            ELSE
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" >= v_next_seek
                ORDER BY lower(o.name) COLLATE "C" ASC LIMIT 1;
            END IF;
        ELSE
            IF v_upper_bound IS NOT NULL THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" < v_next_seek AND lower(o.name) COLLATE "C" >= v_prefix_lower
                ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
            ELSIF v_prefix_lower <> '' THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" < v_next_seek AND lower(o.name) COLLATE "C" >= v_prefix_lower
                ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
            ELSE
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" < v_next_seek
                ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
            END IF;
        END IF;

        EXIT WHEN v_peek_name IS NULL;

        -- STEP 2: Check if this is a FOLDER or FILE
        v_common_prefix := storage.get_common_prefix(lower(v_peek_name), v_prefix_lower, v_delimiter);

        IF v_common_prefix IS NOT NULL THEN
            -- FOLDER: Handle offset, emit if needed, skip to next folder
            IF v_skipped < offsets THEN
                v_skipped := v_skipped + 1;
            ELSE
                name := split_part(rtrim(storage.get_common_prefix(v_peek_name, v_prefix, v_delimiter), v_delimiter), v_delimiter, levels);
                id := NULL;
                updated_at := NULL;
                created_at := NULL;
                last_accessed_at := NULL;
                metadata := NULL;
                RETURN NEXT;
                v_count := v_count + 1;
            END IF;

            -- Advance seek past the folder range
            IF v_is_asc THEN
                v_next_seek := lower(left(v_common_prefix, -1)) || chr(ascii(v_delimiter) + 1);
            ELSE
                v_next_seek := lower(v_common_prefix);
            END IF;
        ELSE
            -- FILE: Batch fetch using DYNAMIC SQL (overhead amortized over many rows)
            -- For ASC: upper_bound is the exclusive upper limit (< condition)
            -- For DESC: prefix_lower is the inclusive lower limit (>= condition)
            FOR v_current IN EXECUTE v_batch_query
                USING bucketname, v_next_seek,
                    CASE WHEN v_is_asc THEN COALESCE(v_upper_bound, v_prefix_lower) ELSE v_prefix_lower END, v_file_batch_size
            LOOP
                v_common_prefix := storage.get_common_prefix(lower(v_current.name), v_prefix_lower, v_delimiter);

                IF v_common_prefix IS NOT NULL THEN
                    -- Hit a folder: exit batch, let peek handle it
                    v_next_seek := lower(v_current.name);
                    EXIT;
                END IF;

                -- Handle offset skipping
                IF v_skipped < offsets THEN
                    v_skipped := v_skipped + 1;
                ELSE
                    -- Emit file
                    name := split_part(v_current.name, v_delimiter, levels);
                    id := v_current.id;
                    updated_at := v_current.updated_at;
                    created_at := v_current.created_at;
                    last_accessed_at := v_current.last_accessed_at;
                    metadata := v_current.metadata;
                    RETURN NEXT;
                    v_count := v_count + 1;
                END IF;

                -- Advance seek past this file
                IF v_is_asc THEN
                    v_next_seek := lower(v_current.name) || v_delimiter;
                ELSE
                    v_next_seek := lower(v_current.name);
                END IF;

                EXIT WHEN v_count >= v_limit;
            END LOOP;
        END IF;
    END LOOP;
END;
$_$;


ALTER FUNCTION storage.search(prefix text, bucketname text, limits integer, levels integer, offsets integer, search text, sortcolumn text, sortorder text) OWNER TO supabase_storage_admin;

--
-- Name: search_by_timestamp(text, text, integer, integer, text, text, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.search_by_timestamp(p_prefix text, p_bucket_id text, p_limit integer, p_level integer, p_start_after text, p_sort_order text, p_sort_column text, p_sort_column_after text) RETURNS TABLE(key text, name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb)
    LANGUAGE plpgsql STABLE
    AS $_$
DECLARE
    v_cursor_op text;
    v_query text;
    v_prefix text;
BEGIN
    v_prefix := coalesce(p_prefix, '');

    IF p_sort_order = 'asc' THEN
        v_cursor_op := '>';
    ELSE
        v_cursor_op := '<';
    END IF;

    v_query := format($sql$
        WITH raw_objects AS (
            SELECT
                o.name AS obj_name,
                o.id AS obj_id,
                o.updated_at AS obj_updated_at,
                o.created_at AS obj_created_at,
                o.last_accessed_at AS obj_last_accessed_at,
                o.metadata AS obj_metadata,
                storage.get_common_prefix(o.name, $1, '/') AS common_prefix
            FROM storage.objects o
            WHERE o.bucket_id = $2
              AND o.name COLLATE "C" LIKE $1 || '%%'
        ),
        -- Aggregate common prefixes (folders)
        -- Both created_at and updated_at use MIN(obj_created_at) to match the old prefixes table behavior
        aggregated_prefixes AS (
            SELECT
                rtrim(common_prefix, '/') AS name,
                NULL::uuid AS id,
                MIN(obj_created_at) AS updated_at,
                MIN(obj_created_at) AS created_at,
                NULL::timestamptz AS last_accessed_at,
                NULL::jsonb AS metadata,
                TRUE AS is_prefix
            FROM raw_objects
            WHERE common_prefix IS NOT NULL
            GROUP BY common_prefix
        ),
        leaf_objects AS (
            SELECT
                obj_name AS name,
                obj_id AS id,
                obj_updated_at AS updated_at,
                obj_created_at AS created_at,
                obj_last_accessed_at AS last_accessed_at,
                obj_metadata AS metadata,
                FALSE AS is_prefix
            FROM raw_objects
            WHERE common_prefix IS NULL
        ),
        combined AS (
            SELECT * FROM aggregated_prefixes
            UNION ALL
            SELECT * FROM leaf_objects
        ),
        filtered AS (
            SELECT *
            FROM combined
            WHERE (
                $5 = ''
                OR ROW(
                    date_trunc('milliseconds', %I),
                    name COLLATE "C"
                ) %s ROW(
                    COALESCE(NULLIF($6, '')::timestamptz, 'epoch'::timestamptz),
                    $5
                )
            )
        )
        SELECT
            split_part(name, '/', $3) AS key,
            name,
            id,
            updated_at,
            created_at,
            last_accessed_at,
            metadata
        FROM filtered
        ORDER BY
            COALESCE(date_trunc('milliseconds', %I), 'epoch'::timestamptz) %s,
            name COLLATE "C" %s
        LIMIT $4
    $sql$,
        p_sort_column,
        v_cursor_op,
        p_sort_column,
        p_sort_order,
        p_sort_order
    );

    RETURN QUERY EXECUTE v_query
    USING v_prefix, p_bucket_id, p_level, p_limit, p_start_after, p_sort_column_after;
END;
$_$;


ALTER FUNCTION storage.search_by_timestamp(p_prefix text, p_bucket_id text, p_limit integer, p_level integer, p_start_after text, p_sort_order text, p_sort_column text, p_sort_column_after text) OWNER TO supabase_storage_admin;

--
-- Name: search_v2(text, text, integer, integer, text, text, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.search_v2(prefix text, bucket_name text, limits integer DEFAULT 100, levels integer DEFAULT 1, start_after text DEFAULT ''::text, sort_order text DEFAULT 'asc'::text, sort_column text DEFAULT 'name'::text, sort_column_after text DEFAULT ''::text) RETURNS TABLE(key text, name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb)
    LANGUAGE plpgsql STABLE
    AS $$
DECLARE
    v_sort_col text;
    v_sort_ord text;
    v_limit int;
BEGIN
    -- Cap limit to maximum of 1500 records
    v_limit := LEAST(coalesce(limits, 100), 1500);

    -- Validate and normalize sort_order
    v_sort_ord := lower(coalesce(sort_order, 'asc'));
    IF v_sort_ord NOT IN ('asc', 'desc') THEN
        v_sort_ord := 'asc';
    END IF;

    -- Validate and normalize sort_column
    v_sort_col := lower(coalesce(sort_column, 'name'));
    IF v_sort_col NOT IN ('name', 'updated_at', 'created_at') THEN
        v_sort_col := 'name';
    END IF;

    -- Route to appropriate implementation
    IF v_sort_col = 'name' THEN
        -- Use list_objects_with_delimiter for name sorting (most efficient: O(k * log n))
        RETURN QUERY
        SELECT
            split_part(l.name, '/', levels) AS key,
            l.name AS name,
            l.id,
            l.updated_at,
            l.created_at,
            l.last_accessed_at,
            l.metadata
        FROM storage.list_objects_with_delimiter(
            bucket_name,
            coalesce(prefix, ''),
            '/',
            v_limit,
            start_after,
            '',
            v_sort_ord
        ) l;
    ELSE
        -- Use aggregation approach for timestamp sorting
        -- Not efficient for large datasets but supports correct pagination
        RETURN QUERY SELECT * FROM storage.search_by_timestamp(
            prefix, bucket_name, v_limit, levels, start_after,
            v_sort_ord, v_sort_col, sort_column_after
        );
    END IF;
END;
$$;


ALTER FUNCTION storage.search_v2(prefix text, bucket_name text, limits integer, levels integer, start_after text, sort_order text, sort_column text, sort_column_after text) OWNER TO supabase_storage_admin;

--
-- Name: update_updated_at_column(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.update_updated_at_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW; 
END;
$$;


ALTER FUNCTION storage.update_updated_at_column() OWNER TO supabase_storage_admin;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: audit_log_entries; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.audit_log_entries (
    instance_id uuid,
    id uuid NOT NULL,
    payload json,
    created_at timestamp with time zone,
    ip_address character varying(64) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE auth.audit_log_entries OWNER TO supabase_auth_admin;

--
-- Name: TABLE audit_log_entries; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.audit_log_entries IS 'Auth: Audit trail for user actions.';


--
-- Name: custom_oauth_providers; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.custom_oauth_providers (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    provider_type text NOT NULL,
    identifier text NOT NULL,
    name text NOT NULL,
    client_id text NOT NULL,
    client_secret text NOT NULL,
    acceptable_client_ids text[] DEFAULT '{}'::text[] NOT NULL,
    scopes text[] DEFAULT '{}'::text[] NOT NULL,
    pkce_enabled boolean DEFAULT true NOT NULL,
    attribute_mapping jsonb DEFAULT '{}'::jsonb NOT NULL,
    authorization_params jsonb DEFAULT '{}'::jsonb NOT NULL,
    enabled boolean DEFAULT true NOT NULL,
    email_optional boolean DEFAULT false NOT NULL,
    issuer text,
    discovery_url text,
    skip_nonce_check boolean DEFAULT false NOT NULL,
    cached_discovery jsonb,
    discovery_cached_at timestamp with time zone,
    authorization_url text,
    token_url text,
    userinfo_url text,
    jwks_uri text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT custom_oauth_providers_authorization_url_https CHECK (((authorization_url IS NULL) OR (authorization_url ~~ 'https://%'::text))),
    CONSTRAINT custom_oauth_providers_authorization_url_length CHECK (((authorization_url IS NULL) OR (char_length(authorization_url) <= 2048))),
    CONSTRAINT custom_oauth_providers_client_id_length CHECK (((char_length(client_id) >= 1) AND (char_length(client_id) <= 512))),
    CONSTRAINT custom_oauth_providers_discovery_url_length CHECK (((discovery_url IS NULL) OR (char_length(discovery_url) <= 2048))),
    CONSTRAINT custom_oauth_providers_identifier_format CHECK ((identifier ~ '^[a-z0-9][a-z0-9:-]{0,48}[a-z0-9]$'::text)),
    CONSTRAINT custom_oauth_providers_issuer_length CHECK (((issuer IS NULL) OR ((char_length(issuer) >= 1) AND (char_length(issuer) <= 2048)))),
    CONSTRAINT custom_oauth_providers_jwks_uri_https CHECK (((jwks_uri IS NULL) OR (jwks_uri ~~ 'https://%'::text))),
    CONSTRAINT custom_oauth_providers_jwks_uri_length CHECK (((jwks_uri IS NULL) OR (char_length(jwks_uri) <= 2048))),
    CONSTRAINT custom_oauth_providers_name_length CHECK (((char_length(name) >= 1) AND (char_length(name) <= 100))),
    CONSTRAINT custom_oauth_providers_oauth2_requires_endpoints CHECK (((provider_type <> 'oauth2'::text) OR ((authorization_url IS NOT NULL) AND (token_url IS NOT NULL) AND (userinfo_url IS NOT NULL)))),
    CONSTRAINT custom_oauth_providers_oidc_discovery_url_https CHECK (((provider_type <> 'oidc'::text) OR (discovery_url IS NULL) OR (discovery_url ~~ 'https://%'::text))),
    CONSTRAINT custom_oauth_providers_oidc_issuer_https CHECK (((provider_type <> 'oidc'::text) OR (issuer IS NULL) OR (issuer ~~ 'https://%'::text))),
    CONSTRAINT custom_oauth_providers_oidc_requires_issuer CHECK (((provider_type <> 'oidc'::text) OR (issuer IS NOT NULL))),
    CONSTRAINT custom_oauth_providers_provider_type_check CHECK ((provider_type = ANY (ARRAY['oauth2'::text, 'oidc'::text]))),
    CONSTRAINT custom_oauth_providers_token_url_https CHECK (((token_url IS NULL) OR (token_url ~~ 'https://%'::text))),
    CONSTRAINT custom_oauth_providers_token_url_length CHECK (((token_url IS NULL) OR (char_length(token_url) <= 2048))),
    CONSTRAINT custom_oauth_providers_userinfo_url_https CHECK (((userinfo_url IS NULL) OR (userinfo_url ~~ 'https://%'::text))),
    CONSTRAINT custom_oauth_providers_userinfo_url_length CHECK (((userinfo_url IS NULL) OR (char_length(userinfo_url) <= 2048)))
);


ALTER TABLE auth.custom_oauth_providers OWNER TO supabase_auth_admin;

--
-- Name: flow_state; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.flow_state (
    id uuid NOT NULL,
    user_id uuid,
    auth_code text,
    code_challenge_method auth.code_challenge_method,
    code_challenge text,
    provider_type text NOT NULL,
    provider_access_token text,
    provider_refresh_token text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    authentication_method text NOT NULL,
    auth_code_issued_at timestamp with time zone,
    invite_token text,
    referrer text,
    oauth_client_state_id uuid,
    linking_target_id uuid,
    email_optional boolean DEFAULT false NOT NULL
);


ALTER TABLE auth.flow_state OWNER TO supabase_auth_admin;

--
-- Name: TABLE flow_state; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.flow_state IS 'Stores metadata for all OAuth/SSO login flows';


--
-- Name: identities; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.identities (
    provider_id text NOT NULL,
    user_id uuid NOT NULL,
    identity_data jsonb NOT NULL,
    provider text NOT NULL,
    last_sign_in_at timestamp with time zone,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    email text GENERATED ALWAYS AS (lower((identity_data ->> 'email'::text))) STORED,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


ALTER TABLE auth.identities OWNER TO supabase_auth_admin;

--
-- Name: TABLE identities; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.identities IS 'Auth: Stores identities associated to a user.';


--
-- Name: COLUMN identities.email; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.identities.email IS 'Auth: Email is a generated column that references the optional email property in the identity_data';


--
-- Name: instances; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.instances (
    id uuid NOT NULL,
    uuid uuid,
    raw_base_config text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone
);


ALTER TABLE auth.instances OWNER TO supabase_auth_admin;

--
-- Name: TABLE instances; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.instances IS 'Auth: Manages users across multiple sites.';


--
-- Name: mfa_amr_claims; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.mfa_amr_claims (
    session_id uuid NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    authentication_method text NOT NULL,
    id uuid NOT NULL
);


ALTER TABLE auth.mfa_amr_claims OWNER TO supabase_auth_admin;

--
-- Name: TABLE mfa_amr_claims; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.mfa_amr_claims IS 'auth: stores authenticator method reference claims for multi factor authentication';


--
-- Name: mfa_challenges; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.mfa_challenges (
    id uuid NOT NULL,
    factor_id uuid NOT NULL,
    created_at timestamp with time zone NOT NULL,
    verified_at timestamp with time zone,
    ip_address inet NOT NULL,
    otp_code text,
    web_authn_session_data jsonb
);


ALTER TABLE auth.mfa_challenges OWNER TO supabase_auth_admin;

--
-- Name: TABLE mfa_challenges; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.mfa_challenges IS 'auth: stores metadata about challenge requests made';


--
-- Name: mfa_factors; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.mfa_factors (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    friendly_name text,
    factor_type auth.factor_type NOT NULL,
    status auth.factor_status NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    secret text,
    phone text,
    last_challenged_at timestamp with time zone,
    web_authn_credential jsonb,
    web_authn_aaguid uuid,
    last_webauthn_challenge_data jsonb
);


ALTER TABLE auth.mfa_factors OWNER TO supabase_auth_admin;

--
-- Name: TABLE mfa_factors; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.mfa_factors IS 'auth: stores metadata about factors';


--
-- Name: COLUMN mfa_factors.last_webauthn_challenge_data; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.mfa_factors.last_webauthn_challenge_data IS 'Stores the latest WebAuthn challenge data including attestation/assertion for customer verification';


--
-- Name: oauth_authorizations; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.oauth_authorizations (
    id uuid NOT NULL,
    authorization_id text NOT NULL,
    client_id uuid NOT NULL,
    user_id uuid,
    redirect_uri text NOT NULL,
    scope text NOT NULL,
    state text,
    resource text,
    code_challenge text,
    code_challenge_method auth.code_challenge_method,
    response_type auth.oauth_response_type DEFAULT 'code'::auth.oauth_response_type NOT NULL,
    status auth.oauth_authorization_status DEFAULT 'pending'::auth.oauth_authorization_status NOT NULL,
    authorization_code text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    expires_at timestamp with time zone DEFAULT (now() + '00:03:00'::interval) NOT NULL,
    approved_at timestamp with time zone,
    nonce text,
    CONSTRAINT oauth_authorizations_authorization_code_length CHECK ((char_length(authorization_code) <= 255)),
    CONSTRAINT oauth_authorizations_code_challenge_length CHECK ((char_length(code_challenge) <= 128)),
    CONSTRAINT oauth_authorizations_expires_at_future CHECK ((expires_at > created_at)),
    CONSTRAINT oauth_authorizations_nonce_length CHECK ((char_length(nonce) <= 255)),
    CONSTRAINT oauth_authorizations_redirect_uri_length CHECK ((char_length(redirect_uri) <= 2048)),
    CONSTRAINT oauth_authorizations_resource_length CHECK ((char_length(resource) <= 2048)),
    CONSTRAINT oauth_authorizations_scope_length CHECK ((char_length(scope) <= 4096)),
    CONSTRAINT oauth_authorizations_state_length CHECK ((char_length(state) <= 4096))
);


ALTER TABLE auth.oauth_authorizations OWNER TO supabase_auth_admin;

--
-- Name: oauth_client_states; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.oauth_client_states (
    id uuid NOT NULL,
    provider_type text NOT NULL,
    code_verifier text,
    created_at timestamp with time zone NOT NULL
);


ALTER TABLE auth.oauth_client_states OWNER TO supabase_auth_admin;

--
-- Name: TABLE oauth_client_states; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.oauth_client_states IS 'Stores OAuth states for third-party provider authentication flows where Supabase acts as the OAuth client.';


--
-- Name: oauth_clients; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.oauth_clients (
    id uuid NOT NULL,
    client_secret_hash text,
    registration_type auth.oauth_registration_type NOT NULL,
    redirect_uris text NOT NULL,
    grant_types text NOT NULL,
    client_name text,
    client_uri text,
    logo_uri text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    client_type auth.oauth_client_type DEFAULT 'confidential'::auth.oauth_client_type NOT NULL,
    token_endpoint_auth_method text NOT NULL,
    CONSTRAINT oauth_clients_client_name_length CHECK ((char_length(client_name) <= 1024)),
    CONSTRAINT oauth_clients_client_uri_length CHECK ((char_length(client_uri) <= 2048)),
    CONSTRAINT oauth_clients_logo_uri_length CHECK ((char_length(logo_uri) <= 2048)),
    CONSTRAINT oauth_clients_token_endpoint_auth_method_check CHECK ((token_endpoint_auth_method = ANY (ARRAY['client_secret_basic'::text, 'client_secret_post'::text, 'none'::text])))
);


ALTER TABLE auth.oauth_clients OWNER TO supabase_auth_admin;

--
-- Name: oauth_consents; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.oauth_consents (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    client_id uuid NOT NULL,
    scopes text NOT NULL,
    granted_at timestamp with time zone DEFAULT now() NOT NULL,
    revoked_at timestamp with time zone,
    CONSTRAINT oauth_consents_revoked_after_granted CHECK (((revoked_at IS NULL) OR (revoked_at >= granted_at))),
    CONSTRAINT oauth_consents_scopes_length CHECK ((char_length(scopes) <= 2048)),
    CONSTRAINT oauth_consents_scopes_not_empty CHECK ((char_length(TRIM(BOTH FROM scopes)) > 0))
);


ALTER TABLE auth.oauth_consents OWNER TO supabase_auth_admin;

--
-- Name: one_time_tokens; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.one_time_tokens (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    token_type auth.one_time_token_type NOT NULL,
    token_hash text NOT NULL,
    relates_to text NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT one_time_tokens_token_hash_check CHECK ((char_length(token_hash) > 0))
);


ALTER TABLE auth.one_time_tokens OWNER TO supabase_auth_admin;

--
-- Name: refresh_tokens; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.refresh_tokens (
    instance_id uuid,
    id bigint NOT NULL,
    token character varying(255),
    user_id character varying(255),
    revoked boolean,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    parent character varying(255),
    session_id uuid
);


ALTER TABLE auth.refresh_tokens OWNER TO supabase_auth_admin;

--
-- Name: TABLE refresh_tokens; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.refresh_tokens IS 'Auth: Store of tokens used to refresh JWT tokens once they expire.';


--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE; Schema: auth; Owner: supabase_auth_admin
--

CREATE SEQUENCE auth.refresh_tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE auth.refresh_tokens_id_seq OWNER TO supabase_auth_admin;

--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: auth; Owner: supabase_auth_admin
--

ALTER SEQUENCE auth.refresh_tokens_id_seq OWNED BY auth.refresh_tokens.id;


--
-- Name: saml_providers; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.saml_providers (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    entity_id text NOT NULL,
    metadata_xml text NOT NULL,
    metadata_url text,
    attribute_mapping jsonb,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    name_id_format text,
    CONSTRAINT "entity_id not empty" CHECK ((char_length(entity_id) > 0)),
    CONSTRAINT "metadata_url not empty" CHECK (((metadata_url = NULL::text) OR (char_length(metadata_url) > 0))),
    CONSTRAINT "metadata_xml not empty" CHECK ((char_length(metadata_xml) > 0))
);


ALTER TABLE auth.saml_providers OWNER TO supabase_auth_admin;

--
-- Name: TABLE saml_providers; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.saml_providers IS 'Auth: Manages SAML Identity Provider connections.';


--
-- Name: saml_relay_states; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.saml_relay_states (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    request_id text NOT NULL,
    for_email text,
    redirect_to text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    flow_state_id uuid,
    CONSTRAINT "request_id not empty" CHECK ((char_length(request_id) > 0))
);


ALTER TABLE auth.saml_relay_states OWNER TO supabase_auth_admin;

--
-- Name: TABLE saml_relay_states; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.saml_relay_states IS 'Auth: Contains SAML Relay State information for each Service Provider initiated login.';


--
-- Name: schema_migrations; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.schema_migrations (
    version character varying(255) NOT NULL
);


ALTER TABLE auth.schema_migrations OWNER TO supabase_auth_admin;

--
-- Name: TABLE schema_migrations; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.schema_migrations IS 'Auth: Manages updates to the auth system.';


--
-- Name: sessions; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.sessions (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    factor_id uuid,
    aal auth.aal_level,
    not_after timestamp with time zone,
    refreshed_at timestamp without time zone,
    user_agent text,
    ip inet,
    tag text,
    oauth_client_id uuid,
    refresh_token_hmac_key text,
    refresh_token_counter bigint,
    scopes text,
    CONSTRAINT sessions_scopes_length CHECK ((char_length(scopes) <= 4096))
);


ALTER TABLE auth.sessions OWNER TO supabase_auth_admin;

--
-- Name: TABLE sessions; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.sessions IS 'Auth: Stores session data associated to a user.';


--
-- Name: COLUMN sessions.not_after; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.sessions.not_after IS 'Auth: Not after is a nullable column that contains a timestamp after which the session should be regarded as expired.';


--
-- Name: COLUMN sessions.refresh_token_hmac_key; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.sessions.refresh_token_hmac_key IS 'Holds a HMAC-SHA256 key used to sign refresh tokens for this session.';


--
-- Name: COLUMN sessions.refresh_token_counter; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.sessions.refresh_token_counter IS 'Holds the ID (counter) of the last issued refresh token.';


--
-- Name: sso_domains; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.sso_domains (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    domain text NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    CONSTRAINT "domain not empty" CHECK ((char_length(domain) > 0))
);


ALTER TABLE auth.sso_domains OWNER TO supabase_auth_admin;

--
-- Name: TABLE sso_domains; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.sso_domains IS 'Auth: Manages SSO email address domain mapping to an SSO Identity Provider.';


--
-- Name: sso_providers; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.sso_providers (
    id uuid NOT NULL,
    resource_id text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    disabled boolean,
    CONSTRAINT "resource_id not empty" CHECK (((resource_id = NULL::text) OR (char_length(resource_id) > 0)))
);


ALTER TABLE auth.sso_providers OWNER TO supabase_auth_admin;

--
-- Name: TABLE sso_providers; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.sso_providers IS 'Auth: Manages SSO identity provider information; see saml_providers for SAML.';


--
-- Name: COLUMN sso_providers.resource_id; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.sso_providers.resource_id IS 'Auth: Uniquely identifies a SSO provider according to a user-chosen resource ID (case insensitive), useful in infrastructure as code.';


--
-- Name: users; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.users (
    instance_id uuid,
    id uuid NOT NULL,
    aud character varying(255),
    role character varying(255),
    email character varying(255),
    encrypted_password character varying(255),
    email_confirmed_at timestamp with time zone,
    invited_at timestamp with time zone,
    confirmation_token character varying(255),
    confirmation_sent_at timestamp with time zone,
    recovery_token character varying(255),
    recovery_sent_at timestamp with time zone,
    email_change_token_new character varying(255),
    email_change character varying(255),
    email_change_sent_at timestamp with time zone,
    last_sign_in_at timestamp with time zone,
    raw_app_meta_data jsonb,
    raw_user_meta_data jsonb,
    is_super_admin boolean,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    phone text DEFAULT NULL::character varying,
    phone_confirmed_at timestamp with time zone,
    phone_change text DEFAULT ''::character varying,
    phone_change_token character varying(255) DEFAULT ''::character varying,
    phone_change_sent_at timestamp with time zone,
    confirmed_at timestamp with time zone GENERATED ALWAYS AS (LEAST(email_confirmed_at, phone_confirmed_at)) STORED,
    email_change_token_current character varying(255) DEFAULT ''::character varying,
    email_change_confirm_status smallint DEFAULT 0,
    banned_until timestamp with time zone,
    reauthentication_token character varying(255) DEFAULT ''::character varying,
    reauthentication_sent_at timestamp with time zone,
    is_sso_user boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone,
    is_anonymous boolean DEFAULT false NOT NULL,
    CONSTRAINT users_email_change_confirm_status_check CHECK (((email_change_confirm_status >= 0) AND (email_change_confirm_status <= 2)))
);


ALTER TABLE auth.users OWNER TO supabase_auth_admin;

--
-- Name: TABLE users; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.users IS 'Auth: Stores user login data within a secure schema.';


--
-- Name: COLUMN users.is_sso_user; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.users.is_sso_user IS 'Auth: Set this column to true when the account comes from SSO. These accounts can have duplicate emails.';


--
-- Name: webauthn_challenges; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.webauthn_challenges (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid,
    challenge_type text NOT NULL,
    session_data jsonb NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    expires_at timestamp with time zone NOT NULL,
    CONSTRAINT webauthn_challenges_challenge_type_check CHECK ((challenge_type = ANY (ARRAY['signup'::text, 'registration'::text, 'authentication'::text])))
);


ALTER TABLE auth.webauthn_challenges OWNER TO supabase_auth_admin;

--
-- Name: webauthn_credentials; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.webauthn_credentials (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    credential_id bytea NOT NULL,
    public_key bytea NOT NULL,
    attestation_type text DEFAULT ''::text NOT NULL,
    aaguid uuid,
    sign_count bigint DEFAULT 0 NOT NULL,
    transports jsonb DEFAULT '[]'::jsonb NOT NULL,
    backup_eligible boolean DEFAULT false NOT NULL,
    backed_up boolean DEFAULT false NOT NULL,
    friendly_name text DEFAULT ''::text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    last_used_at timestamp with time zone
);


ALTER TABLE auth.webauthn_credentials OWNER TO supabase_auth_admin;

--
-- Name: activities; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.activities (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    learning_outcome_id uuid,
    title character varying(255) NOT NULL,
    description text,
    docente_id uuid,
    start_date timestamp without time zone,
    close_date timestamp without time zone,
    type character varying(50) DEFAULT 'task'::character varying,
    max_score numeric(5,2) DEFAULT 100,
    status text DEFAULT 'active'::text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.activities OWNER TO postgres;

--
-- Name: alertas_bajo_desempenio; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.alertas_bajo_desempenio (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    estudiante_id uuid NOT NULL,
    competencia_id character varying(36) NOT NULL,
    docente_id uuid NOT NULL,
    tipo_alerta text,
    porcentaje_logro numeric,
    nivel_riesgo text,
    leida boolean DEFAULT false,
    fecha_creacion timestamp without time zone DEFAULT now(),
    fecha_resolucion timestamp without time zone,
    CONSTRAINT alertas_bajo_desempenio_nivel_riesgo_check CHECK ((nivel_riesgo = ANY (ARRAY['bajo'::text, 'medio'::text, 'alto'::text, 'critico'::text]))),
    CONSTRAINT alertas_bajo_desempenio_tipo_alerta_check CHECK ((tipo_alerta = ANY (ARRAY['bajo_promedio'::text, 'sin_evidencias'::text, 'baja_asistencia'::text, 'multiples_reprobadas'::text])))
);


ALTER TABLE public.alertas_bajo_desempenio OWNER TO postgres;

--
-- Name: asistencias; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.asistencias (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    docente_id uuid NOT NULL,
    estudiante_id uuid NOT NULL,
    curso_id uuid NOT NULL,
    fecha date NOT NULL,
    estado text,
    observacion text,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now(),
    CONSTRAINT asistencias_estado_check CHECK ((estado = ANY (ARRAY['presente'::text, 'ausente'::text, 'tardanza'::text])))
);


ALTER TABLE public.asistencias OWNER TO postgres;

--
-- Name: audits; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.audits (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    action character varying(255) NOT NULL,
    table_name character varying(100) NOT NULL,
    record_id uuid,
    changes_json jsonb,
    action_date timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    tabla_afectada character varying(100),
    student_id uuid,
    criteria_id uuid,
    calificacion_anterior numeric(5,2),
    calificacion_nueva numeric(5,2),
    observation text
);


ALTER TABLE public.audits OWNER TO postgres;

--
-- Name: competencies; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.competencies (
    id character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    description text,
    descriptor text,
    subject character varying(255),
    teacher_id uuid,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.competencies OWNER TO postgres;

--
-- Name: configuration; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.configuration (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    key text NOT NULL,
    value text NOT NULL,
    type text DEFAULT 'text'::text,
    description text,
    updated_by uuid,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.configuration OWNER TO postgres;

--
-- Name: criteria; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.criteria (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    learning_outcome_id uuid NOT NULL,
    name character varying(255) NOT NULL,
    description text,
    weighting numeric(5,2) DEFAULT 100,
    requires_observation boolean DEFAULT false,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.criteria OWNER TO postgres;

--
-- Name: cursos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cursos (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    nombre character varying(255) NOT NULL,
    codigo character varying(50),
    descripcion text,
    docente_id uuid,
    estado character varying(50) DEFAULT 'activo'::character varying,
    fecha_creacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.cursos OWNER TO postgres;

--
-- Name: docente_curso; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.docente_curso (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    docente_id uuid,
    curso_id uuid,
    fecha_asignacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.docente_curso OWNER TO postgres;

--
-- Name: estudiante_curso; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.estudiante_curso (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    estudiante_id uuid,
    curso_id uuid,
    fecha_matricula timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.estudiante_curso OWNER TO postgres;

--
-- Name: evaluation_metadata; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.evaluation_metadata (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    evaluacion_id uuid,
    docente_id uuid NOT NULL,
    tiempo_inicio timestamp without time zone,
    tiempo_fin timestamp without time zone,
    duracion_segundos integer,
    fecha_creacion timestamp without time zone DEFAULT now()
);


ALTER TABLE public.evaluation_metadata OWNER TO postgres;

--
-- Name: evaluations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.evaluations (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    criteria_id uuid NOT NULL,
    student_id uuid NOT NULL,
    activity_id uuid NOT NULL,
    grade numeric(5,2),
    observation text,
    teacher_id uuid NOT NULL,
    grading_date timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.evaluations OWNER TO postgres;

--
-- Name: evidence; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.evidence (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    activity_id uuid NOT NULL,
    student_id uuid NOT NULL,
    file_url text,
    delivery_date timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    comment text,
    status character varying(50) DEFAULT 'pending'::character varying,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    actividad_id uuid
);


ALTER TABLE public.evidence OWNER TO postgres;

--
-- Name: final_grades; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.final_grades (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    learning_outcome_id uuid NOT NULL,
    student_id uuid NOT NULL,
    average_grade numeric(5,2),
    status character varying(50) DEFAULT 'in_progress'::character varying,
    grading_date timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.final_grades OWNER TO postgres;

--
-- Name: learning_outcomes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.learning_outcomes (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    competency_id character varying(255),
    title character varying(255) NOT NULL,
    description text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.learning_outcomes OWNER TO postgres;

--
-- Name: notificaciones; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.notificaciones (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    estudiante_id uuid NOT NULL,
    titulo text NOT NULL,
    mensaje text,
    tipo text,
    leida boolean DEFAULT false,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now(),
    CONSTRAINT notificaciones_tipo_check CHECK ((tipo = ANY (ARRAY['nueva_clase'::text, 'retroalimentacion'::text, 'evaluacion'::text])))
);


ALTER TABLE public.notificaciones OWNER TO postgres;

--
-- Name: plantillas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.plantillas (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    nombre text NOT NULL,
    descripcion text,
    contenido jsonb NOT NULL,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.plantillas OWNER TO postgres;

--
-- Name: progreso_snapshots; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.progreso_snapshots (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    estudiante_id uuid NOT NULL,
    competencia_id character varying(36) NOT NULL,
    porcentaje_logro numeric,
    nivel_logro text,
    total_evaluaciones integer,
    promedio_calificacion numeric,
    fecha_snapshot timestamp without time zone DEFAULT now()
);


ALTER TABLE public.progreso_snapshots OWNER TO postgres;

--
-- Name: re_evaluaciones; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.re_evaluaciones (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    estudiante_id uuid NOT NULL,
    competencia_id character varying(36) NOT NULL,
    intento_numero integer DEFAULT 1,
    calificacion_anterior numeric,
    calificacion_nueva numeric,
    estado text,
    fecha_creacion timestamp without time zone DEFAULT now(),
    fecha_completacion timestamp without time zone,
    observacion text,
    CONSTRAINT re_evaluaciones_estado_check CHECK ((estado = ANY (ARRAY['pendiente'::text, 'completada'::text])))
);


ALTER TABLE public.re_evaluaciones OWNER TO postgres;

--
-- Name: reports; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.reports (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    teacher_id uuid NOT NULL,
    title character varying(255) NOT NULL,
    type character varying(50),
    generation_date timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    data_json jsonb,
    pdf_url text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    tipo character varying(50),
    datos_json jsonb,
    fecha_generacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.reports OWNER TO postgres;

--
-- Name: roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.roles (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name text NOT NULL,
    description text,
    permissions jsonb,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.roles OWNER TO postgres;

--
-- Name: rubricas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.rubricas (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    nombre character varying(255) NOT NULL,
    descripcion text,
    docente_id uuid,
    competencia_id character varying(255),
    niveles jsonb,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.rubricas OWNER TO postgres;

--
-- Name: sections; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sections (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name character varying(10) NOT NULL,
    grade character varying(5) NOT NULL,
    letter character varying(1) NOT NULL,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.sections OWNER TO postgres;

--
-- Name: student_section; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.student_section (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    student_id uuid NOT NULL,
    section_id uuid NOT NULL,
    enrollment_date timestamp without time zone DEFAULT now()
);


ALTER TABLE public.student_section OWNER TO postgres;

--
-- Name: student_tracking; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.student_tracking (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    student_id uuid NOT NULL,
    competency_id character varying(255),
    progress_percentage numeric(5,2) DEFAULT 0,
    last_updated timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.student_tracking OWNER TO postgres;

--
-- Name: system_configuration; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.system_configuration (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    key character varying(100) NOT NULL,
    value text,
    type character varying(50),
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.system_configuration OWNER TO postgres;

--
-- Name: teacher_section; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.teacher_section (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    teacher_id uuid NOT NULL,
    section_id uuid NOT NULL,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.teacher_section OWNER TO postgres;

--
-- Name: templates; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.templates (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    name text NOT NULL,
    description text,
    criteria_id uuid,
    learning_outcome_id uuid,
    competency_id character varying(255),
    template_json jsonb,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.templates OWNER TO postgres;

--
-- Name: user_roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_roles (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    role_id uuid NOT NULL,
    assignment_date timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.user_roles OWNER TO postgres;

--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    email character varying(120) NOT NULL,
    name character varying(255) NOT NULL,
    password_hash character varying(255),
    role character varying(50) DEFAULT 'student'::character varying,
    active boolean DEFAULT true,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: messages; Type: TABLE; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE TABLE realtime.messages (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
)
PARTITION BY RANGE (inserted_at);


ALTER TABLE realtime.messages OWNER TO supabase_realtime_admin;

--
-- Name: schema_migrations; Type: TABLE; Schema: realtime; Owner: supabase_admin
--

CREATE TABLE realtime.schema_migrations (
    version bigint NOT NULL,
    inserted_at timestamp(0) without time zone
);


ALTER TABLE realtime.schema_migrations OWNER TO supabase_admin;

--
-- Name: subscription; Type: TABLE; Schema: realtime; Owner: supabase_admin
--

CREATE TABLE realtime.subscription (
    id bigint NOT NULL,
    subscription_id uuid NOT NULL,
    entity regclass NOT NULL,
    filters realtime.user_defined_filter[] DEFAULT '{}'::realtime.user_defined_filter[] NOT NULL,
    claims jsonb NOT NULL,
    claims_role regrole GENERATED ALWAYS AS (realtime.to_regrole((claims ->> 'role'::text))) STORED NOT NULL,
    created_at timestamp without time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    action_filter text DEFAULT '*'::text,
    CONSTRAINT subscription_action_filter_check CHECK ((action_filter = ANY (ARRAY['*'::text, 'INSERT'::text, 'UPDATE'::text, 'DELETE'::text])))
);


ALTER TABLE realtime.subscription OWNER TO supabase_admin;

--
-- Name: subscription_id_seq; Type: SEQUENCE; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE realtime.subscription ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME realtime.subscription_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: buckets; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.buckets (
    id text NOT NULL,
    name text NOT NULL,
    owner uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    public boolean DEFAULT false,
    avif_autodetection boolean DEFAULT false,
    file_size_limit bigint,
    allowed_mime_types text[],
    owner_id text,
    type storage.buckettype DEFAULT 'STANDARD'::storage.buckettype NOT NULL
);


ALTER TABLE storage.buckets OWNER TO supabase_storage_admin;

--
-- Name: COLUMN buckets.owner; Type: COMMENT; Schema: storage; Owner: supabase_storage_admin
--

COMMENT ON COLUMN storage.buckets.owner IS 'Field is deprecated, use owner_id instead';


--
-- Name: buckets_analytics; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.buckets_analytics (
    name text NOT NULL,
    type storage.buckettype DEFAULT 'ANALYTICS'::storage.buckettype NOT NULL,
    format text DEFAULT 'ICEBERG'::text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE storage.buckets_analytics OWNER TO supabase_storage_admin;

--
-- Name: buckets_vectors; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.buckets_vectors (
    id text NOT NULL,
    type storage.buckettype DEFAULT 'VECTOR'::storage.buckettype NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE storage.buckets_vectors OWNER TO supabase_storage_admin;

--
-- Name: migrations; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.migrations (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    hash character varying(40) NOT NULL,
    executed_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE storage.migrations OWNER TO supabase_storage_admin;

--
-- Name: objects; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.objects (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    bucket_id text,
    name text,
    owner uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    last_accessed_at timestamp with time zone DEFAULT now(),
    metadata jsonb,
    path_tokens text[] GENERATED ALWAYS AS (string_to_array(name, '/'::text)) STORED,
    version text,
    owner_id text,
    user_metadata jsonb
);


ALTER TABLE storage.objects OWNER TO supabase_storage_admin;

--
-- Name: COLUMN objects.owner; Type: COMMENT; Schema: storage; Owner: supabase_storage_admin
--

COMMENT ON COLUMN storage.objects.owner IS 'Field is deprecated, use owner_id instead';


--
-- Name: s3_multipart_uploads; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.s3_multipart_uploads (
    id text NOT NULL,
    in_progress_size bigint DEFAULT 0 NOT NULL,
    upload_signature text NOT NULL,
    bucket_id text NOT NULL,
    key text NOT NULL COLLATE pg_catalog."C",
    version text NOT NULL,
    owner_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    user_metadata jsonb,
    metadata jsonb
);


ALTER TABLE storage.s3_multipart_uploads OWNER TO supabase_storage_admin;

--
-- Name: s3_multipart_uploads_parts; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.s3_multipart_uploads_parts (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    upload_id text NOT NULL,
    size bigint DEFAULT 0 NOT NULL,
    part_number integer NOT NULL,
    bucket_id text NOT NULL,
    key text NOT NULL COLLATE pg_catalog."C",
    etag text NOT NULL,
    owner_id text,
    version text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE storage.s3_multipart_uploads_parts OWNER TO supabase_storage_admin;

--
-- Name: vector_indexes; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.vector_indexes (
    id text DEFAULT gen_random_uuid() NOT NULL,
    name text NOT NULL COLLATE pg_catalog."C",
    bucket_id text NOT NULL,
    data_type text NOT NULL,
    dimension integer NOT NULL,
    distance_metric text NOT NULL,
    metadata_configuration jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE storage.vector_indexes OWNER TO supabase_storage_admin;

--
-- Name: refresh_tokens id; Type: DEFAULT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens ALTER COLUMN id SET DEFAULT nextval('auth.refresh_tokens_id_seq'::regclass);


--
-- Data for Name: audit_log_entries; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.audit_log_entries (instance_id, id, payload, created_at, ip_address) FROM stdin;
\.


--
-- Data for Name: custom_oauth_providers; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.custom_oauth_providers (id, provider_type, identifier, name, client_id, client_secret, acceptable_client_ids, scopes, pkce_enabled, attribute_mapping, authorization_params, enabled, email_optional, issuer, discovery_url, skip_nonce_check, cached_discovery, discovery_cached_at, authorization_url, token_url, userinfo_url, jwks_uri, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: flow_state; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.flow_state (id, user_id, auth_code, code_challenge_method, code_challenge, provider_type, provider_access_token, provider_refresh_token, created_at, updated_at, authentication_method, auth_code_issued_at, invite_token, referrer, oauth_client_state_id, linking_target_id, email_optional) FROM stdin;
\.


--
-- Data for Name: identities; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.identities (provider_id, user_id, identity_data, provider, last_sign_in_at, created_at, updated_at, id) FROM stdin;
ad86439a-31de-4eed-a303-5d2fed9fec39	ad86439a-31de-4eed-a303-5d2fed9fec39	{"rol": "docente", "sub": "ad86439a-31de-4eed-a303-5d2fed9fec39", "email": "testsupabase@gmail.com", "nombre": " Test Supabase User", "email_verified": false, "phone_verified": false}	email	2026-03-05 16:52:29.865648+00	2026-03-05 16:52:29.865693+00	2026-03-05 16:52:29.865693+00	be937662-f80c-4c00-b7ed-87273875b839
e91e88ce-b231-40e5-a093-68283662b146	e91e88ce-b231-40e5-a093-68283662b146	{"rol": "docente", "sub": "e91e88ce-b231-40e5-a093-68283662b146", "email": "newtest@example.com", "nombre": "New Test User", "email_verified": false, "phone_verified": false}	email	2026-03-05 17:00:50.547927+00	2026-03-05 17:00:50.547975+00	2026-03-05 17:00:50.547975+00	3a864900-3e45-4c0a-86cb-126f40ffb14c
c5bbbc6d-abd6-477b-8998-400c04face6c	c5bbbc6d-abd6-477b-8998-400c04face6c	{"rol": "estudiante", "sub": "c5bbbc6d-abd6-477b-8998-400c04face6c", "email": "pamelareding@gmail.com", "nombre": "Ashley Pamela Reding ", "email_verified": false, "phone_verified": false}	email	2026-03-05 17:24:06.989453+00	2026-03-05 17:24:06.989502+00	2026-03-05 17:24:06.989502+00	3d990159-21a8-4b3d-a2df-67a2c9c77988
8a58df87-1912-4c39-a0c8-dc195db490f3	8a58df87-1912-4c39-a0c8-dc195db490f3	{"rol": "docente", "sub": "8a58df87-1912-4c39-a0c8-dc195db490f3", "email": "carlos2@gmail.com", "nombre": "Carlos Miguel Lima Camacho 2", "email_verified": false, "phone_verified": false}	email	2026-03-10 02:40:10.702249+00	2026-03-10 02:40:10.702298+00	2026-03-10 02:40:10.702298+00	1f5c6def-cf4f-443c-858b-22ee7f6aa214
bec157c7-cd63-4535-a8b7-7983ea223b7a	bec157c7-cd63-4535-a8b7-7983ea223b7a	{"sub": "bec157c7-cd63-4535-a8b7-7983ea223b7a", "email": "ramirezmichael@gmail.com", "nombre": "Michael Ramírez Feliz", "email_verified": false, "phone_verified": false}	email	2026-03-16 13:27:09.102572+00	2026-03-16 13:27:09.102625+00	2026-03-16 13:27:09.102625+00	093f9682-a87d-4f80-83e3-d49c090827ad
22e32e2a-0a39-4d7d-baca-de0a29aaaac3	22e32e2a-0a39-4d7d-baca-de0a29aaaac3	{"sub": "22e32e2a-0a39-4d7d-baca-de0a29aaaac3", "email": "carloscamacho9700@gmail.com", "email_verified": false, "phone_verified": false}	email	2026-03-17 16:20:10.152577+00	2026-03-17 16:20:10.152637+00	2026-03-17 16:20:10.152637+00	d6d475f0-6041-458e-8357-05632850cc81
9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	{"sub": "9ba53ac3-902f-48c4-a9b5-8e5a032c5b74", "email": "joserijo@gmail.com", "email_verified": false, "phone_verified": false}	email	2026-03-17 16:23:42.521504+00	2026-03-17 16:23:42.521562+00	2026-03-17 16:23:42.521562+00	247b1ede-0968-4d75-977e-c54cdfa34da9
41d0dce6-bd67-4a08-9d1f-696359e90e51	41d0dce6-bd67-4a08-9d1f-696359e90e51	{"sub": "41d0dce6-bd67-4a08-9d1f-696359e90e51", "name": "Gabriel Elias Alcala Aquino", "email": "gabriel.alcala@edu.com", "email_verified": false, "phone_verified": false}	email	2026-04-26 00:51:21.510692+00	2026-04-26 00:51:21.510755+00	2026-04-26 00:51:21.510755+00	073a9615-c73b-47a7-935f-1efc2f588cc9
c5e17e59-c4b4-47a7-b699-c8d9754f6f65	c5e17e59-c4b4-47a7-b699-c8d9754f6f65	{"sub": "c5e17e59-c4b4-47a7-b699-c8d9754f6f65", "name": "Winniviel Bello", "email": "winniviel.bello@edu.com", "email_verified": false, "phone_verified": false}	email	2026-04-26 00:51:21.873559+00	2026-04-26 00:51:21.873606+00	2026-04-26 00:51:21.873606+00	5a63c133-8000-400f-afc2-72cd49e8878f
2567a845-ec31-4484-bb26-77a357087983	2567a845-ec31-4484-bb26-77a357087983	{"sub": "2567a845-ec31-4484-bb26-77a357087983", "name": "Deuli de la Cruz Ramirez", "email": "deuli.cruz@edu.com", "email_verified": false, "phone_verified": false}	email	2026-04-26 00:51:22.105273+00	2026-04-26 00:51:22.105318+00	2026-04-26 00:51:22.105318+00	e53b50eb-fd29-4753-a87c-42bb1f01a627
e553ff72-4848-4488-840b-29f8b19a9846	e553ff72-4848-4488-840b-29f8b19a9846	{"sub": "e553ff72-4848-4488-840b-29f8b19a9846", "name": "Katherine Marie Cuesta Marte", "email": "katherine.cuesta@edu.com", "email_verified": false, "phone_verified": false}	email	2026-04-26 00:51:22.338537+00	2026-04-26 00:51:22.338581+00	2026-04-26 00:51:22.338581+00	efbaa7ae-c6b5-4e3b-85ff-3b5a48f2766f
6ee06e13-8b9d-4b7d-bb8c-f5e1392a2345	6ee06e13-8b9d-4b7d-bb8c-f5e1392a2345	{"sub": "6ee06e13-8b9d-4b7d-bb8c-f5e1392a2345", "name": "Elyin Emmanuel Diaz Adamez", "email": "elyin.diaz@edu.com", "email_verified": false, "phone_verified": false}	email	2026-04-26 00:51:22.569513+00	2026-04-26 00:51:22.569556+00	2026-04-26 00:51:22.569556+00	9718f160-4ba7-4e57-b4de-94b93c6f9493
15330155-3ad3-4e5d-a70d-e02557a5ba8d	15330155-3ad3-4e5d-a70d-e02557a5ba8d	{"sub": "15330155-3ad3-4e5d-a70d-e02557a5ba8d", "name": "Juan Armando Felix Norberto", "email": "juan.felix@edu.com", "email_verified": false, "phone_verified": false}	email	2026-04-26 00:51:22.79379+00	2026-04-26 00:51:22.79384+00	2026-04-26 00:51:22.79384+00	48ebaff5-56c2-4819-894b-2afb66e85c74
82deb24f-e7f8-46c9-9117-ee272f1671fa	82deb24f-e7f8-46c9-9117-ee272f1671fa	{"sub": "82deb24f-e7f8-46c9-9117-ee272f1671fa", "name": "Justin Ezequiel", "email": "justin.ezequiel@edu.com", "email_verified": false, "phone_verified": false}	email	2026-04-26 00:51:23.02587+00	2026-04-26 00:51:23.025914+00	2026-04-26 00:51:23.025914+00	84517f6b-6eb2-4349-9105-addc7372a709
ed797688-4ace-4eaf-80cd-8697ebaba1dc	ed797688-4ace-4eaf-80cd-8697ebaba1dc	{"sub": "ed797688-4ace-4eaf-80cd-8697ebaba1dc", "name": "Maikel Yael", "email": "maikel.yael@edu.com", "email_verified": false, "phone_verified": false}	email	2026-04-26 00:51:23.26996+00	2026-04-26 00:51:23.270003+00	2026-04-26 00:51:23.270003+00	a2ee7a41-09c1-46f8-8695-22903e622eae
65988fb9-ee24-402e-9f72-215888b19aa7	65988fb9-ee24-402e-9f72-215888b19aa7	{"sub": "65988fb9-ee24-402e-9f72-215888b19aa7", "name": "Carlos Miguel Lima Camacho", "email": "carlos.lima@edu.com", "email_verified": false, "phone_verified": false}	email	2026-04-26 00:51:23.490929+00	2026-04-26 00:51:23.490973+00	2026-04-26 00:51:23.490973+00	0e58f607-9e4a-419b-88f3-8ceac740df60
61050d2a-a59a-4306-a126-5ec1ceed6549	61050d2a-a59a-4306-a126-5ec1ceed6549	{"sub": "61050d2a-a59a-4306-a126-5ec1ceed6549", "name": "Yeuri Lorenzo Diaz", "email": "yeuri.lorenzo@edu.com", "email_verified": false, "phone_verified": false}	email	2026-04-26 00:51:23.713433+00	2026-04-26 00:51:23.713475+00	2026-04-26 00:51:23.713475+00	8259cf72-a557-445f-bca6-40688dbb560f
d4a5067d-f305-4344-80ec-ecec9777e6bc	d4a5067d-f305-4344-80ec-ecec9777e6bc	{"sub": "d4a5067d-f305-4344-80ec-ecec9777e6bc", "name": "Nashly Adriana Magallanes Feliz", "email": "nashly.magallanes@edu.com", "email_verified": false, "phone_verified": false}	email	2026-04-26 00:51:23.942408+00	2026-04-26 00:51:23.942449+00	2026-04-26 00:51:23.942449+00	40b08e44-bb90-419a-9d94-959cd9ac4f70
e7c839f3-cee4-4c59-b054-1e35731ef6b4	e7c839f3-cee4-4c59-b054-1e35731ef6b4	{"sub": "e7c839f3-cee4-4c59-b054-1e35731ef6b4", "name": "Angelo Alexander Mancebo", "email": "angelo.mancebo@edu.com", "email_verified": false, "phone_verified": false}	email	2026-04-26 00:51:24.159745+00	2026-04-26 00:51:24.159788+00	2026-04-26 00:51:24.159788+00	c3475f2a-8e09-4cdc-b90e-a49d977082a2
c3e075ab-d4ef-4047-9e59-9a42c99e0ec6	c3e075ab-d4ef-4047-9e59-9a42c99e0ec6	{"sub": "c3e075ab-d4ef-4047-9e59-9a42c99e0ec6", "name": "Enrique Ogando", "email": "enrique.ogando@edu.com", "email_verified": false, "phone_verified": false}	email	2026-04-26 00:51:24.373913+00	2026-04-26 00:51:24.373956+00	2026-04-26 00:51:24.373956+00	02998439-2542-467d-bc58-c232e2d29ff5
078c7814-4883-4bdb-9130-353518f12d4d	078c7814-4883-4bdb-9130-353518f12d4d	{"sub": "078c7814-4883-4bdb-9130-353518f12d4d", "name": "Jose Emmanuel Pichardo", "email": "jose.pichardo@edu.com", "email_verified": false, "phone_verified": false}	email	2026-04-26 00:51:24.588871+00	2026-04-26 00:51:24.588913+00	2026-04-26 00:51:24.588913+00	decacf75-b7b0-4e6e-8b94-e8bb7ad43e97
0890ea95-f0dd-48c1-94d7-d96da6d9e876	0890ea95-f0dd-48c1-94d7-d96da6d9e876	{"sub": "0890ea95-f0dd-48c1-94d7-d96da6d9e876", "name": "Ernesto Luis Pichardo", "email": "ernesto.pichardo@edu.com", "email_verified": false, "phone_verified": false}	email	2026-04-26 00:51:24.801651+00	2026-04-26 00:51:24.801692+00	2026-04-26 00:51:24.801692+00	078fa282-2f04-4bf5-89fb-70898a4085dd
ef7e8249-6c63-48e6-b3d2-dfc34f44ade7	ef7e8249-6c63-48e6-b3d2-dfc34f44ade7	{"sub": "ef7e8249-6c63-48e6-b3d2-dfc34f44ade7", "name": "Dustin Alexander Polanco Muños", "email": "dustin.polanco@edu.com", "email_verified": false, "phone_verified": false}	email	2026-04-26 00:51:25.022971+00	2026-04-26 00:51:25.023017+00	2026-04-26 00:51:25.023017+00	3ad4643e-ca53-4f64-a607-3c3c8156399b
6cc3ddc0-6296-48e1-9da4-3e35562534bd	6cc3ddc0-6296-48e1-9da4-3e35562534bd	{"sub": "6cc3ddc0-6296-48e1-9da4-3e35562534bd", "name": "Michael Ramirez Feliz", "email": "michael.ramirez@edu.com", "email_verified": false, "phone_verified": false}	email	2026-04-26 00:51:25.238793+00	2026-04-26 00:51:25.238838+00	2026-04-26 00:51:25.238838+00	723aaaa0-dde7-469a-94b6-5934bd95a6ca
0bcc0ef3-9a18-497d-9a2e-59ea53abfd82	0bcc0ef3-9a18-497d-9a2e-59ea53abfd82	{"sub": "0bcc0ef3-9a18-497d-9a2e-59ea53abfd82", "name": "Eliezer de Jesus", "email": "eliezer.jesus@edu.com", "email_verified": false, "phone_verified": false}	email	2026-04-26 00:51:25.464974+00	2026-04-26 00:51:25.465017+00	2026-04-26 00:51:25.465017+00	cd26025b-dd01-4137-8eb3-c8244812551f
9c90759f-19b4-4d84-91e8-6bae7d6205d5	9c90759f-19b4-4d84-91e8-6bae7d6205d5	{"sub": "9c90759f-19b4-4d84-91e8-6bae7d6205d5", "name": "Jeremy Manuel", "email": "jeremy.manuel@edu.com", "email_verified": false, "phone_verified": false}	email	2026-04-26 00:51:25.679+00	2026-04-26 00:51:25.679042+00	2026-04-26 00:51:25.679042+00	05b63ce4-59f9-4dc6-a5ac-4187c4bb622a
8b11710a-a694-4a66-af3c-c022b28b25e7	8b11710a-a694-4a66-af3c-c022b28b25e7	{"sub": "8b11710a-a694-4a66-af3c-c022b28b25e7", "name": "Ashly Pamela Reding Hernandez", "email": "ashly.reding@edu.com", "email_verified": false, "phone_verified": false}	email	2026-04-26 00:51:25.920861+00	2026-04-26 00:51:25.920906+00	2026-04-26 00:51:25.920906+00	b6a962ff-02f6-441d-ab27-e0268c83dce6
f9c231e0-8859-4d97-bf6d-3fdd11fe7234	f9c231e0-8859-4d97-bf6d-3fdd11fe7234	{"sub": "f9c231e0-8859-4d97-bf6d-3fdd11fe7234", "name": "Gianni Subervi Alcantara", "email": "gianni.subervi@edu.com", "email_verified": false, "phone_verified": false}	email	2026-04-26 00:51:26.142246+00	2026-04-26 00:51:26.142289+00	2026-04-26 00:51:26.142289+00	df9af330-4a3e-49cc-9898-46227bf99307
\.


--
-- Data for Name: instances; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.instances (id, uuid, raw_base_config, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: mfa_amr_claims; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.mfa_amr_claims (session_id, created_at, updated_at, authentication_method, id) FROM stdin;
571dcb60-528a-4f23-badf-8f004837534f	2026-03-05 17:00:50.576167+00	2026-03-05 17:00:50.576167+00	password	e64f941a-02e1-441f-ab2c-fac3dced57af
c5cc292e-4b6c-4f0d-a61d-004a09f1c2a7	2026-03-05 17:00:54.409476+00	2026-03-05 17:00:54.409476+00	password	8266326b-c63a-450c-8e90-667a6e79aace
76bf8189-c1a6-41de-9ac6-6e01f6811b78	2026-03-05 17:24:07.016781+00	2026-03-05 17:24:07.016781+00	password	370eeaab-dfff-4954-b453-60159e05757f
bf407aca-5a8d-478d-9876-de7ce07135d9	2026-03-05 17:24:21.618051+00	2026-03-05 17:24:21.618051+00	password	f47ce37a-a294-434f-a7ac-631f000317f2
f1df7cd7-9261-428f-8124-17a0d2562e0e	2026-03-05 17:39:37.11928+00	2026-03-05 17:39:37.11928+00	password	d7a1e61c-3839-453e-9c80-611fb0ad0288
750d91d3-743d-402b-8d9c-b68141cda3ca	2026-03-05 19:01:01.469157+00	2026-03-05 19:01:01.469157+00	password	1d96d69f-6bd9-44cf-900a-ff046f8ce699
2bc71d11-624a-45cc-9e1b-37f8ee18658e	2026-03-09 03:58:27.47658+00	2026-03-09 03:58:27.47658+00	password	c523fdeb-4500-41cc-a848-5c4d6d75229c
9afd34da-6508-4fd6-a942-16ffdb91d826	2026-03-09 20:39:03.219241+00	2026-03-09 20:39:03.219241+00	password	c210c20f-4d24-4154-b275-336bc52edf20
93a17e56-d79f-4e7f-8acb-23590d2a8ce6	2026-03-09 21:28:38.924608+00	2026-03-09 21:28:38.924608+00	password	2a35d19d-64a0-4de4-a872-34a85ebc1cec
5229ea93-9479-44c5-b7b5-c0a48139caff	2026-03-10 01:37:13.979037+00	2026-03-10 01:37:13.979037+00	password	b6d930b2-8c11-4f98-a0f3-4a31b955b54f
286cae0e-45a2-4740-a057-33324b159b68	2026-03-10 01:53:10.318562+00	2026-03-10 01:53:10.318562+00	password	40d1fe9c-5fbe-43e4-a385-5804c5af4d96
1e96260b-aac0-46b6-8890-3776d669a202	2026-03-10 02:40:10.751245+00	2026-03-10 02:40:10.751245+00	password	bd8167b2-811c-4405-8647-6740c1b3b2e5
f3fa007e-95cc-49b6-a3de-628d50a89ff1	2026-03-10 02:40:14.100251+00	2026-03-10 02:40:14.100251+00	password	b026eb80-6487-49d0-92bd-14b09e1389ba
7bfafe7f-8d5b-4a33-8179-768aa6399b78	2026-03-11 22:17:59.624732+00	2026-03-11 22:17:59.624732+00	password	3657ce65-e422-4d31-8cc7-d75c47952e2f
1a20eab6-93b4-4815-90d5-a570d6cca0ef	2026-03-14 19:50:21.274634+00	2026-03-14 19:50:21.274634+00	password	ca768737-8907-4014-912b-2642e84e7497
f6b6db9d-2216-40f8-8d1e-62e613c6729f	2026-03-16 13:17:07.403735+00	2026-03-16 13:17:07.403735+00	password	47684cfc-cc81-4034-b987-96df0702fde1
2f78a2c6-5a77-4cfe-a8b2-fda01ff52c47	2026-03-16 13:27:09.137335+00	2026-03-16 13:27:09.137335+00	password	74ed2cf4-174e-4cc7-86ab-cd883f952d2f
c80c321e-99d1-4379-95cd-caf43a8768ba	2026-03-16 13:27:41.943548+00	2026-03-16 13:27:41.943548+00	password	6af04c4e-3eee-481b-a690-342ef7041ac3
3b9f1ff2-76bc-4fe0-80cf-0c0da22b9801	2026-03-17 16:40:10.619245+00	2026-03-17 16:40:10.619245+00	password	e17e33cd-e565-4529-91b7-de9186677dfd
d6bb7d2b-835e-474e-b800-88e286b05f7c	2026-03-17 16:41:41.337368+00	2026-03-17 16:41:41.337368+00	password	bbfbef92-fe70-4fc7-b064-3634f94731c6
16984bfb-aa24-4093-9555-fafe2da55297	2026-03-17 16:48:11.345016+00	2026-03-17 16:48:11.345016+00	password	ffaeb34d-151a-4cfa-aa42-492a03fdc56f
2ba510b0-3031-457d-a555-3e56b90d7c66	2026-03-17 18:02:47.453947+00	2026-03-17 18:02:47.453947+00	password	d2161272-1ca9-4bd9-ba53-4eda3f3e3184
2ae8056f-65f3-4b0b-a6ea-c913a8e7037d	2026-03-17 18:06:45.43055+00	2026-03-17 18:06:45.43055+00	password	dfac5597-6de5-4673-909d-2d10c9757419
c692bd6a-466a-4490-9f0a-c2723769fa0e	2026-03-17 18:16:31.832576+00	2026-03-17 18:16:31.832576+00	password	28f9023a-5119-42f0-a8a6-fc4dca8b135f
519c3515-27fd-430c-9371-fa9214778db0	2026-03-17 18:17:17.914637+00	2026-03-17 18:17:17.914637+00	password	02a029b1-936a-453a-abb4-1c4be1d445b4
de72a969-4d9f-43fa-ba7d-7687a0fc2e3c	2026-03-22 16:35:46.053243+00	2026-03-22 16:35:46.053243+00	password	b77053b8-5dec-49ef-af8b-d4143274b156
0faa4f75-7fe7-4a9e-8a09-da2f5a7930f5	2026-03-22 22:13:51.758388+00	2026-03-22 22:13:51.758388+00	password	8550f537-6636-4e82-9ce9-f3516f0e1c71
740cb28c-d09f-4ccb-9196-e60ecfb109aa	2026-03-22 22:40:48.256811+00	2026-03-22 22:40:48.256811+00	password	d028bbef-a461-4243-93c0-acdc522f802c
b2ef2fad-5b2b-4974-a8e8-98aa6eeb1520	2026-03-23 22:31:16.940448+00	2026-03-23 22:31:16.940448+00	password	e437f0c1-ba7f-4bcd-8cd4-08364f24112c
fcc839fa-b068-4de0-b190-ef9f175d651d	2026-03-24 07:40:03.930786+00	2026-03-24 07:40:03.930786+00	password	3eb4317b-d915-49e5-bdaf-b9b43e1c5fbf
63355f27-15d5-4f52-998c-f9c37f7e7620	2026-03-24 08:07:24.743716+00	2026-03-24 08:07:24.743716+00	password	be04f14f-fa27-41b3-bbed-7721068192b7
e11d3475-23fe-494f-a16f-3e83b7bc217f	2026-03-24 16:44:36.599105+00	2026-03-24 16:44:36.599105+00	password	767cc24f-e01d-4d2f-baf8-704f975aba53
a17e5bd9-2598-4727-aed0-37f571ca363b	2026-03-24 18:13:32.275036+00	2026-03-24 18:13:32.275036+00	password	d881de26-e6f3-4c79-b3fa-fa1927aa59b6
946069d7-86bc-45af-8a0e-a72a966ea72b	2026-03-24 23:58:09.724938+00	2026-03-24 23:58:09.724938+00	password	1538241b-1dd8-430f-8db5-ce98fc2f1362
c2725836-5e74-40e4-9450-48e01eac3c69	2026-03-25 03:36:31.589723+00	2026-03-25 03:36:31.589723+00	password	2aba4d12-7cbb-44cf-b3b9-db88846208ca
2bbb3e90-0dea-4788-a69d-cc35094ed961	2026-03-25 03:54:49.072561+00	2026-03-25 03:54:49.072561+00	password	5bacfd64-a2e1-46d8-a298-3642a53216cd
15a38ac7-26f4-48f9-af6f-c049383c0b2f	2026-03-25 10:52:41.864906+00	2026-03-25 10:52:41.864906+00	password	691bed09-29e5-4d54-991e-71b8c2fe03e9
4c0b91f5-c652-48ed-b768-e66d9eb86930	2026-03-25 11:58:40.410259+00	2026-03-25 11:58:40.410259+00	password	9147c627-1cc9-40d1-a042-997fa3b3ceac
fd5221e9-f61a-4a1a-b341-7d415ae1ec5d	2026-03-25 12:04:53.336807+00	2026-03-25 12:04:53.336807+00	password	7db9764a-97af-476b-bcc4-86e0032e26a7
ada80241-a850-44a1-9925-280dcf4356a9	2026-03-25 12:05:08.243375+00	2026-03-25 12:05:08.243375+00	password	c0fb641c-8bb4-48b7-9074-ae74eb0173c6
b2aa9c43-597a-4d48-81f7-63e7e49ffdbb	2026-03-25 12:08:48.894495+00	2026-03-25 12:08:48.894495+00	password	91fbaa25-afbe-4eab-88da-76d25e5bad50
ee747375-3cf2-4552-97fe-405642cd319a	2026-04-10 14:56:26.695871+00	2026-04-10 14:56:26.695871+00	password	bd1e8dd2-0d0e-4d1a-9181-cfa7e3242b44
8986bfa7-fda7-4051-b2cb-228a38352701	2026-04-10 15:08:48.422662+00	2026-04-10 15:08:48.422662+00	password	028e5932-ddb8-4e98-b7d3-433ec3fd2756
57014f88-0ac9-4078-ac73-7ae74e230f1a	2026-04-19 15:01:13.341408+00	2026-04-19 15:01:13.341408+00	password	71ce4a3c-273e-465f-aed5-97ffe835c78d
b4fa5e8b-b965-4492-ae9f-00ee696d95a1	2026-04-19 22:13:31.332042+00	2026-04-19 22:13:31.332042+00	password	21fb682e-a948-424d-863d-b2838ccaccb9
545f2fe1-223b-4c00-b269-acd0e00e1cfa	2026-04-20 21:24:56.233897+00	2026-04-20 21:24:56.233897+00	password	887044a3-84a9-4ba6-82ac-255c3a53b5fc
2916c154-0cfe-4288-a01a-a936986917cf	2026-04-24 21:28:03.452583+00	2026-04-24 21:28:03.452583+00	password	bd7061e6-0175-4aa1-880b-d381e18075b2
ab055f59-fcd1-49d3-9136-08b0fccf923d	2026-04-24 21:29:39.937664+00	2026-04-24 21:29:39.937664+00	password	8e03e2b1-3986-4fe5-ac75-d75d2940ca39
11edd43b-9f0f-4ba0-b57c-ae29bff93935	2026-04-25 04:11:54.683402+00	2026-04-25 04:11:54.683402+00	password	7a76b71f-2882-4389-9318-3c9bd732f5df
4b61f367-aecc-4681-b168-aeb22acf7838	2026-04-25 04:37:56.345824+00	2026-04-25 04:37:56.345824+00	password	527a33e0-135f-4f34-a0cd-5937d4904ac7
12a555a4-fbec-48c4-8bee-057d31e553ac	2026-04-25 17:53:56.013899+00	2026-04-25 17:53:56.013899+00	password	484772e7-59c8-4a9f-a6ae-f9d4c9b34616
285ddf3d-7c78-4e36-b696-ebca987685df	2026-04-25 17:54:09.285234+00	2026-04-25 17:54:09.285234+00	password	3e55e9c8-7e46-40d7-a658-6eb9172eb00f
b2d7593e-792d-46c1-9aed-cacf27af14f4	2026-04-25 18:00:28.921811+00	2026-04-25 18:00:28.921811+00	password	31afa024-ffc0-44db-b05d-30cf6c679681
a2449b75-517e-4768-9ba5-8af9abe5b2b1	2026-04-25 18:10:06.04912+00	2026-04-25 18:10:06.04912+00	password	56b93d91-e203-4342-8c3a-412de48b5d62
90496beb-4ba2-4202-b711-12f848d85661	2026-04-25 20:44:45.799202+00	2026-04-25 20:44:45.799202+00	password	1926a205-7181-443a-a722-9fd7d296be28
c4c9989a-2f94-4352-b8e4-4df6d608e583	2026-04-25 23:18:50.363663+00	2026-04-25 23:18:50.363663+00	password	2c441d4e-3a43-4a6f-81b4-13d2b4de79c1
076833a6-cf08-4298-b962-5cff262be40e	2026-04-26 00:51:21.592696+00	2026-04-26 00:51:21.592696+00	password	09f61948-fec7-47e3-b3f1-4aeab0d3ce8a
2a79d1d9-c6ac-4d62-902b-ab3766d31b2d	2026-04-26 00:51:21.885429+00	2026-04-26 00:51:21.885429+00	password	cf341758-f139-42ed-bcdf-23aa1f44d763
c5616d63-812e-4824-adc4-2d71bcc74442	2026-04-26 00:51:22.112267+00	2026-04-26 00:51:22.112267+00	password	80bb7db2-1c1d-4750-8f43-a693b491961c
9dd6d27e-de78-4fb2-9105-a3e3cda290c0	2026-04-26 00:51:22.348307+00	2026-04-26 00:51:22.348307+00	password	e9ba1a71-8627-4f6e-90ee-abe3201c906e
f77b7da9-1e45-4a3a-b356-aac7bb0627db	2026-04-26 00:51:22.579173+00	2026-04-26 00:51:22.579173+00	password	d6ce8714-b1d0-40d5-ab0c-e408d7824f61
64162651-49a7-4aeb-b0aa-cf7183e809b5	2026-04-26 00:51:22.801902+00	2026-04-26 00:51:22.801902+00	password	900279c0-028b-4a4b-9291-27ae37ccf695
8d57dc1b-5759-4e8e-9fb0-bdabcc6c44e1	2026-04-26 00:51:23.032921+00	2026-04-26 00:51:23.032921+00	password	62f1c890-7b66-406e-a401-4e484d7b8d2a
f510790c-1af5-4828-8ff2-5cddf34e6260	2026-04-26 00:51:23.276013+00	2026-04-26 00:51:23.276013+00	password	3069053f-43bc-48bb-90ad-276bdda35b06
379b1e6a-af85-42b5-80be-dc5b621abf16	2026-04-26 00:51:23.498567+00	2026-04-26 00:51:23.498567+00	password	6799a344-2dfe-4285-a296-554ad6a8168d
17bed8b6-95cf-4233-ab30-dd902e24a494	2026-04-26 00:51:23.722813+00	2026-04-26 00:51:23.722813+00	password	93ba2b86-cfff-47eb-8de8-06690716f796
78474596-0edc-4f47-84e8-175f68f449e6	2026-04-26 00:51:23.948269+00	2026-04-26 00:51:23.948269+00	password	b9b44747-c457-4d2f-a5c8-3d4cfffa27d2
8ae17439-c6cd-4522-ad71-db265bccd4c1	2026-04-26 00:51:24.165494+00	2026-04-26 00:51:24.165494+00	password	b797f6ee-a9ba-469e-975b-ab048b4d0ee7
9fe98e2d-959d-4c48-8b5c-0f4ca4eb1dd4	2026-04-26 00:51:24.38165+00	2026-04-26 00:51:24.38165+00	password	c3dba8fd-3202-40f1-8f73-99256cc03d4c
81b624e0-50d1-4da0-ba0b-01664e9bb070	2026-04-26 00:51:24.594656+00	2026-04-26 00:51:24.594656+00	password	b6788165-1700-4c9b-9da8-6fc5a0f88a97
f04f483c-0aa6-4b66-8309-aa5d07a6b855	2026-04-26 00:51:24.807795+00	2026-04-26 00:51:24.807795+00	password	4a9e8c04-0d67-4af5-9239-cb586f0df71f
8b79e7ce-6bc1-4780-9f8f-ba2ad34f0fa0	2026-04-26 00:51:25.029164+00	2026-04-26 00:51:25.029164+00	password	a8fd10e1-792d-4af7-ac50-45036241692c
a0ddc0b1-c33d-43a5-a5fa-b8ba0026b2fc	2026-04-26 00:51:25.244898+00	2026-04-26 00:51:25.244898+00	password	4ffed4e2-02c1-47bf-ba80-ddb48129e847
a2f27ef4-8e6d-4f6c-9fbd-009d42edddab	2026-04-26 00:51:25.473291+00	2026-04-26 00:51:25.473291+00	password	1077ca54-195b-4934-81b5-5ee15aacdff3
3dedcc00-410a-4bfd-bcbe-7b55c9a2432b	2026-04-26 00:51:25.685669+00	2026-04-26 00:51:25.685669+00	password	acec6a0b-5cef-4e5f-8f18-0b1dc9cfaea3
a4f8b1f9-582e-4f1d-8b89-a714c276b06a	2026-04-26 00:51:25.927007+00	2026-04-26 00:51:25.927007+00	password	bfe699f8-18f9-4784-92bc-7cc133df5e51
cd455df6-a927-481c-b9fc-924bcd51cae6	2026-04-26 00:51:26.148525+00	2026-04-26 00:51:26.148525+00	password	b1831ea5-cda2-4bfa-a30d-5efa8e3e7b49
94fd5792-9b3f-48db-a957-60e068e608dc	2026-04-26 00:54:05.365845+00	2026-04-26 00:54:05.365845+00	password	1de74e54-ae81-4969-815d-fed73c99a43f
7060c646-dfaa-4270-bcd1-848f77453a74	2026-04-26 01:06:03.123174+00	2026-04-26 01:06:03.123174+00	password	86f8d28e-affd-4502-8549-eb60b8ff6f7a
5b41b515-b5bc-432f-9a3a-4a325fa4635e	2026-04-26 02:59:56.922534+00	2026-04-26 02:59:56.922534+00	password	5e0fef4a-35be-4dee-89cf-d4b5bc31482b
af86bfb8-687f-4c11-ac2a-6b8c962687ea	2026-04-26 03:00:54.56302+00	2026-04-26 03:00:54.56302+00	password	ed8018ef-f3ba-434d-a42c-90b9105d9f19
45c827ff-4251-40c0-90f7-193c6e5dfa9d	2026-04-26 20:22:34.606202+00	2026-04-26 20:22:34.606202+00	password	19622b9d-0132-448e-a8ad-344c89d77794
90f803c0-6c35-459f-a8fa-d05b2531253a	2026-04-27 03:02:21.459463+00	2026-04-27 03:02:21.459463+00	password	d2ac02ee-9fac-4062-b24c-164b4cd8b61e
47e24fcb-519a-4d92-a8a8-c5af2826d430	2026-04-27 03:02:37.420162+00	2026-04-27 03:02:37.420162+00	password	c7ad5376-077e-4515-8bf3-2deeb4b0955b
75162aab-92d0-4468-b533-d75a9e77369c	2026-04-27 03:10:04.749063+00	2026-04-27 03:10:04.749063+00	password	053714ec-e22a-4c11-9d42-560b92e42cd2
7293cb63-1497-43fa-8ec1-9363e73618a2	2026-04-27 03:14:21.797827+00	2026-04-27 03:14:21.797827+00	password	f046dbeb-0093-40ac-88ea-b91f32aa3a1d
e904b5f8-8563-4483-9215-c1e79ca5da79	2026-04-27 03:16:18.676286+00	2026-04-27 03:16:18.676286+00	password	6e793fd5-2b6c-406f-9267-942883c55e8f
4b322928-f226-486b-b46a-b5b753145b49	2026-04-27 04:55:30.100941+00	2026-04-27 04:55:30.100941+00	password	fec4b1dc-64af-4852-b0ea-da2c2eacde63
2cd035cf-b405-4ed3-a068-75e0ec58a672	2026-04-27 05:04:37.008925+00	2026-04-27 05:04:37.008925+00	password	82c47ecc-21e0-4e67-b8a4-87363ac5232e
88ab5341-e8d4-4afc-8407-ce808fb9cb86	2026-04-27 10:57:20.849581+00	2026-04-27 10:57:20.849581+00	password	4061fb90-4f2a-4a30-be81-16cfeb18a9c1
8856bdfe-0092-4cda-9a6c-16d5bc91d028	2026-04-27 12:33:16.9006+00	2026-04-27 12:33:16.9006+00	password	5ae077b9-82f7-444e-a926-7036b75d96bd
c13174e5-f33d-40b1-8a61-b5caba57a3c7	2026-04-27 15:07:42.910953+00	2026-04-27 15:07:42.910953+00	password	76cd1896-4441-4adc-b322-6093b4f18c64
70ee3b94-989c-46d3-b126-54244d96881b	2026-04-27 22:28:21.042944+00	2026-04-27 22:28:21.042944+00	password	ef0b51be-2d98-406b-8e56-c65a2198c568
af6cfc1f-d011-4e2a-bf8a-daf21628a075	2026-04-27 22:53:00.767219+00	2026-04-27 22:53:00.767219+00	password	9604571c-0d93-4e06-8d9e-22f6f5f3b5b8
0e4c4e3f-abf5-4b76-9d73-ed89d26c59b3	2026-04-27 22:53:52.244915+00	2026-04-27 22:53:52.244915+00	password	5bd65613-646d-4e92-8caf-1e310327ecee
4031835c-6bff-4cab-b889-38bb5d252267	2026-04-27 23:10:49.997185+00	2026-04-27 23:10:49.997185+00	password	1ced7b6a-d659-41cb-896b-d38d04aa368c
c2221522-7a4e-4dca-b359-896bf661d6ee	2026-04-27 23:30:10.570177+00	2026-04-27 23:30:10.570177+00	password	0fb53864-0ccf-4d95-a473-7ba9c4970e63
4358ae17-2475-480e-99c0-3a44756c7c5c	2026-04-28 13:02:06.410211+00	2026-04-28 13:02:06.410211+00	password	b65b6ce0-9d59-4c8b-82c5-dce776d3321f
8b834650-65aa-4442-bbff-0db5a838a2f9	2026-04-28 16:41:09.80152+00	2026-04-28 16:41:09.80152+00	password	accd1014-aa38-4b74-89cc-0c3179e950fd
ec0bc166-e32c-46a7-8bfe-5c53c446e621	2026-04-28 18:12:08.637562+00	2026-04-28 18:12:08.637562+00	password	ccd1f60b-896a-416b-914e-9728b63cfc7a
2edef557-c409-489f-bcac-d6d0b6db2e9c	2026-04-28 22:30:22.382424+00	2026-04-28 22:30:22.382424+00	password	f72620df-5c9f-4487-b5fa-9b62d168256f
c290607f-c046-44b4-bb9d-42fbe0809086	2026-04-28 22:59:32.587468+00	2026-04-28 22:59:32.587468+00	password	ccb9a0de-0c13-40e2-a6ef-ac58a3d898f1
a8a7f1e1-78fc-434f-8c7a-15e108a66e32	2026-04-28 23:46:00.816787+00	2026-04-28 23:46:00.816787+00	password	8dcfe044-adaa-4e56-b167-3ed0578c1c73
738b2087-6d5b-434a-b9be-de03a21c35a7	2026-04-29 00:28:45.920344+00	2026-04-29 00:28:45.920344+00	password	ea5ab0f6-2e29-4d55-851c-315b9897e0ea
f8427551-9399-4299-a6b6-72bd4c28ece5	2026-04-29 01:35:26.264544+00	2026-04-29 01:35:26.264544+00	password	61593318-1068-48a7-9c44-128ab9412785
e50dfa84-80e4-48b4-b09c-9b2bbe611a2d	2026-04-29 01:40:09.829774+00	2026-04-29 01:40:09.829774+00	password	3446f271-d689-4b45-a128-2c288257a07b
aa9652ac-3af8-4ccf-a1aa-ededdf5e72b1	2026-04-29 06:42:06.987733+00	2026-04-29 06:42:06.987733+00	password	7d2bed1a-f7b8-4a17-bc73-2796088bfd1c
d11137a3-855f-491a-a235-28c1fe8b9375	2026-04-29 07:02:30.664531+00	2026-04-29 07:02:30.664531+00	password	b7aecf5f-bdf5-4f64-afde-5b0d74c9ad6d
81c0b9ec-b445-40ce-8a91-610fe66513f1	2026-04-29 07:25:47.5536+00	2026-04-29 07:25:47.5536+00	password	ee97a85e-c087-49cc-9117-64204fbef1df
14f039cb-1b49-451a-b7e9-f4831010b9dc	2026-04-29 12:10:10.239022+00	2026-04-29 12:10:10.239022+00	password	4ff96a9a-5ee7-49ac-8351-6afa61c91410
b34669e3-3ba1-47ce-8b44-d601ff2317d6	2026-04-29 12:37:27.158588+00	2026-04-29 12:37:27.158588+00	password	62d47ff7-6046-47a7-88a9-64c1af2d2d44
64e2680c-b11c-43ca-8e5c-3b7c8416ca7f	2026-04-29 13:06:27.797852+00	2026-04-29 13:06:27.797852+00	password	8552d649-35e5-4868-9e87-dfa12f724699
0115616a-3262-4c64-b297-71ed06403631	2026-04-29 13:08:03.211092+00	2026-04-29 13:08:03.211092+00	password	6bab4cd8-c279-4d34-9db9-4d4ba5134729
68fd6e03-affb-4662-82f8-6da37bf55784	2026-04-29 13:13:15.621646+00	2026-04-29 13:13:15.621646+00	password	73f87b0f-a958-4c20-b225-152d7aeac980
1ae7b343-aec1-4079-b0d6-10c497aca253	2026-04-29 13:58:28.887415+00	2026-04-29 13:58:28.887415+00	password	bbd9b7e3-284f-470f-886e-e26c814a466c
e69f3913-b99b-4ef3-9fec-28cb6cefe3af	2026-04-29 14:34:51.024956+00	2026-04-29 14:34:51.024956+00	password	f69d3871-3e93-41f8-8979-3fc97c09bda9
4f6b3b6e-d8ea-48f0-8325-5d1aa7fb5694	2026-04-29 16:50:55.377583+00	2026-04-29 16:50:55.377583+00	password	30463777-26a2-4975-a8a5-dbf559fb6a4b
d67944e9-4963-4846-8b91-0c463c5cbdd3	2026-04-29 21:04:35.92188+00	2026-04-29 21:04:35.92188+00	password	e0ca85f8-f487-44f0-9b54-09372fdf2988
408f6423-f361-47d5-8e73-69a0bf2b9fcb	2026-04-29 21:24:43.290197+00	2026-04-29 21:24:43.290197+00	password	ef7b3130-607f-4974-b558-5e7ff499d2ed
8e2bc0c2-46c6-4240-9665-2bbdcaeb48b5	2026-04-29 21:42:22.671452+00	2026-04-29 21:42:22.671452+00	password	105f2abf-b1f2-4467-baeb-cde5cd98c21e
3b22bda1-769d-41c7-8641-44fc8f12055c	2026-04-29 21:56:26.852186+00	2026-04-29 21:56:26.852186+00	password	ee13c517-1959-4c00-b5e2-b0ecdca1734e
fa358f02-38b2-47f0-add2-e3182260dcf7	2026-04-29 23:35:23.422038+00	2026-04-29 23:35:23.422038+00	password	d151e777-bf1b-407a-b025-fca7ba9fae76
bc0e345a-7a1b-4859-91ad-8aab090eee54	2026-04-30 00:21:34.993835+00	2026-04-30 00:21:34.993835+00	password	bc8766b8-a00f-498c-80b1-405f25e33990
88b47e5b-0054-416f-a36f-17ae7a1dbf69	2026-04-30 00:38:10.498174+00	2026-04-30 00:38:10.498174+00	password	67b71cfc-ccf4-43bf-9b73-0f03f3d9b5e1
52bc52fe-6bae-4265-9def-928fd9899a41	2026-04-30 00:47:28.811915+00	2026-04-30 00:47:28.811915+00	password	cc39c697-ceca-486c-9420-573674bac851
b4285a2e-9091-41e6-8255-c44fdd56a112	2026-04-30 02:14:43.257897+00	2026-04-30 02:14:43.257897+00	password	b6959c11-fe4d-48cf-9760-ff97b9d94008
588debec-e23c-49b2-bc89-19d743d7ff8e	2026-04-30 02:28:11.997547+00	2026-04-30 02:28:11.997547+00	password	a66fdb9c-ff3b-4606-845a-c38f3a498d74
ad9011a0-e6b0-4877-9f53-b49259a89001	2026-04-30 02:54:36.036926+00	2026-04-30 02:54:36.036926+00	password	d14bf2d9-9336-4c09-aced-b2492befe298
3f5163e3-7e99-4315-8e09-c63f5c052407	2026-04-30 03:11:21.780298+00	2026-04-30 03:11:21.780298+00	password	c9617e37-5ff6-4940-9037-6683c99f2683
2c352fcc-ccc1-4f87-8263-6a33b4c2a733	2026-04-30 03:24:30.718278+00	2026-04-30 03:24:30.718278+00	password	57cea0a5-59a5-43e9-852b-c50d73fa7d21
eb152a9a-e57a-49b5-a572-2a6d23d07377	2026-04-30 03:24:43.872182+00	2026-04-30 03:24:43.872182+00	password	848dcba2-9bb3-40b0-b82d-f81b8232873b
4ecb2b4c-1238-4b9f-b4fe-fc1f6b41dc6a	2026-04-30 03:55:09.902716+00	2026-04-30 03:55:09.902716+00	password	136e4696-fc38-4712-869f-467a156ecc9e
35b0c666-e0b8-42fb-a616-9429adabab74	2026-04-30 04:12:35.71432+00	2026-04-30 04:12:35.71432+00	password	36c12d00-94d3-495e-b841-0639a099b16f
f25646ef-ed6f-4d96-8bea-f2fde0811c81	2026-04-30 04:49:58.288929+00	2026-04-30 04:49:58.288929+00	password	fa9398db-af49-4c58-ae4a-66f120c19c39
b3b6e136-e67a-4683-8d01-575a62a77f2f	2026-04-30 07:09:03.336908+00	2026-04-30 07:09:03.336908+00	password	b2a28612-33ad-4296-9e56-f11dc3d62883
ad70a6fe-7ee8-4f9d-96c8-6e75c482f74a	2026-04-30 10:10:50.444931+00	2026-04-30 10:10:50.444931+00	password	b70b9316-fd27-40d6-8e0a-0473ddb3ab13
c815d6b4-43a5-4ec9-8f8a-b1b05dda800c	2026-04-30 10:26:00.808374+00	2026-04-30 10:26:00.808374+00	password	2b2289b3-e571-4537-8892-ec42801c6067
53826f91-dd79-40eb-8a82-0179af37fa71	2026-04-30 10:34:10.835706+00	2026-04-30 10:34:10.835706+00	password	1e49184b-93cc-4d95-ad3b-ce1bfc9dc903
bde75454-b798-4374-bf5d-d2b435e72869	2026-04-30 11:46:00.791753+00	2026-04-30 11:46:00.791753+00	password	12c4cb9e-f738-4d44-9dfe-7df9c05781f8
dadcade2-6724-4314-ad55-16e5a608b3ae	2026-04-30 12:17:59.444334+00	2026-04-30 12:17:59.444334+00	password	078ad89e-ef9f-469a-b542-cc94e213f438
8a7b7a24-2b94-42fe-82b4-c3c3f2f916db	2026-04-30 12:52:49.363451+00	2026-04-30 12:52:49.363451+00	password	f9a0d3b9-ac79-4333-8647-f0b81aa4868e
d35912df-33f6-45ea-bb48-a0bdb2cb4c77	2026-04-30 15:10:16.141015+00	2026-04-30 15:10:16.141015+00	password	108de6f2-3acd-4da1-b2f4-4c1be635b932
adc9a9ff-dcf2-4899-bb73-bdca4d77fb7e	2026-04-30 16:28:44.998479+00	2026-04-30 16:28:44.998479+00	password	8880b5e4-89ed-4201-aac7-3caecc3fab4b
4cc033e8-b38f-4380-917d-7a7f70e66e89	2026-04-30 18:20:42.070825+00	2026-04-30 18:20:42.070825+00	password	8ff7da06-dd6a-43b1-8e8e-fa29a194b650
5c9ecafd-724d-4696-bc33-60e1a2e633ef	2026-04-30 23:13:51.128651+00	2026-04-30 23:13:51.128651+00	password	6dd4c142-12c1-43d0-866b-cd203971ad10
0ebe0dd1-8f70-4133-9e0d-574fda495380	2026-05-01 01:51:33.231556+00	2026-05-01 01:51:33.231556+00	password	7e4eaeb6-f845-4d9d-9839-1ba626998ba8
c9c8dbd5-0372-491a-b18f-42220cb45171	2026-05-01 02:04:48.022065+00	2026-05-01 02:04:48.022065+00	password	69e8b513-6e41-4bc0-af04-73d227fb988c
3bbb2871-98ce-4582-b8df-d3712db17346	2026-05-01 02:51:31.343186+00	2026-05-01 02:51:31.343186+00	password	7b20f16a-d10c-41a6-8c01-dba7fc42bd99
eea67a72-3d27-4bc9-b37f-b966ae12fe2a	2026-05-01 04:27:20.423872+00	2026-05-01 04:27:20.423872+00	password	88658480-c3b1-4479-ae2b-7d7b0bc8814c
df21b184-602b-44ce-b165-b049c0e87609	2026-05-01 04:29:03.595186+00	2026-05-01 04:29:03.595186+00	password	a197af26-3d21-4cb1-9c6e-550f4e92d880
77e49c65-278e-49fa-b63b-a62843c1cbb5	2026-05-01 04:38:16.171207+00	2026-05-01 04:38:16.171207+00	password	9d722c2c-e4e2-4cb0-b618-cabd90055994
9e043f3c-9626-4c94-975a-d0aee23a9d25	2026-05-01 04:57:49.438911+00	2026-05-01 04:57:49.438911+00	password	8f56ff6b-bbbd-4a8e-a417-1663df2845f1
69a0d995-3aa9-4223-a30d-b97366cad171	2026-05-01 05:48:00.45031+00	2026-05-01 05:48:00.45031+00	password	6db6bcce-a76f-4613-9f4d-08bf5e97f997
314f8fc8-75b5-4de3-ba2e-a576647f79fa	2026-05-01 12:14:13.498014+00	2026-05-01 12:14:13.498014+00	password	2681bad9-cdef-43b3-90d6-879d307d5636
b588f42a-ae17-4798-8103-06417b2ae105	2026-05-01 14:53:20.476665+00	2026-05-01 14:53:20.476665+00	password	0add0cc5-b8ed-44c1-94d5-5e020da682d1
7b249466-60be-4a7f-b6ac-2553a7f97f85	2026-05-01 15:25:54.06644+00	2026-05-01 15:25:54.06644+00	password	82e140a0-086e-41cc-b96a-8d786c39cd1b
dd977ca1-3c28-462b-974a-ed28337ef744	2026-05-01 15:29:42.945002+00	2026-05-01 15:29:42.945002+00	password	626f0ef8-11cd-49ff-a75a-fc21f4d281b0
dd6b79bd-356a-4b11-b1f6-321a973c5a24	2026-05-01 15:49:28.707041+00	2026-05-01 15:49:28.707041+00	password	e894c527-d698-4153-9336-197b6d67d0f8
33a3f91d-5f63-48b6-a51f-289a99b0540a	2026-05-01 15:53:46.155987+00	2026-05-01 15:53:46.155987+00	password	d961b310-b849-47f1-9b70-de10c3cd0ddf
b4e6c621-ece0-42b9-98db-c280181f7b18	2026-05-01 16:02:24.176851+00	2026-05-01 16:02:24.176851+00	password	3101813a-f343-41c6-9c00-65bddf419279
8761da2c-ba43-4ca0-ab92-59ffeef82bad	2026-05-01 16:55:59.018364+00	2026-05-01 16:55:59.018364+00	password	e076f601-22ce-4847-9a80-ad8da767940a
10362a88-46d7-4759-9616-a1f3c479b398	2026-05-02 17:16:03.944043+00	2026-05-02 17:16:03.944043+00	password	349ef097-1d9c-4fcb-ac42-0e2448cf978d
264b36e1-7d92-4dfd-9aaf-2631b9d8c287	2026-05-02 19:56:46.524007+00	2026-05-02 19:56:46.524007+00	password	5ad6cdd2-84fb-4e73-ac10-6abce101f0d1
a43d66be-0f73-4beb-8327-9e082e29b58f	2026-05-04 20:35:00.08448+00	2026-05-04 20:35:00.08448+00	password	47b04b17-e173-4cf7-8af7-d8baa3bb2b42
7923a88f-ab56-472a-9b1d-cdeba48946c8	2026-05-04 20:45:01.984685+00	2026-05-04 20:45:01.984685+00	password	8da1725b-32a8-4543-a136-66ad50fbd3f5
2eda2a32-e191-4bed-b167-827f258dfad2	2026-05-04 20:49:01.468831+00	2026-05-04 20:49:01.468831+00	password	a20f846b-f5a1-406e-9b76-9f53cb8ff369
39999e8d-ac78-40ef-afb7-0ba57296ccbc	2026-05-04 21:27:59.738344+00	2026-05-04 21:27:59.738344+00	password	4d9e27ff-0ddf-49b8-bd09-46c4ae130c02
4ff47f8c-85a6-4904-aef7-d23d57801847	2026-05-04 21:30:08.5031+00	2026-05-04 21:30:08.5031+00	password	44630c3d-b940-4b5e-a5d4-5ad546d115e4
e3d7097a-fb9d-4ba8-adcd-dc07d0406d7b	2026-05-04 21:53:19.178727+00	2026-05-04 21:53:19.178727+00	password	abade1d2-6d1d-4d4d-bcc8-b0122d94e6a0
7a2fb2a9-492a-4244-b5a6-f2d627099717	2026-05-04 23:48:34.094652+00	2026-05-04 23:48:34.094652+00	password	37e34d6b-e759-40f7-bbad-8d30471c5b14
823b64ff-2a04-498a-b14c-506a53b234c3	2026-05-05 00:01:54.805966+00	2026-05-05 00:01:54.805966+00	password	5be4f926-4ab9-425e-a487-62a8e86c572b
602390ce-472e-43e1-9506-efca15aec8d1	2026-05-05 00:36:29.963123+00	2026-05-05 00:36:29.963123+00	password	d90c86c2-cfe7-4cf2-92bf-c6a59c90842d
83304e5d-12fe-457e-8899-0e3c8798602a	2026-05-05 00:37:32.750467+00	2026-05-05 00:37:32.750467+00	password	69c4aae3-557f-4986-97df-d9e5aea8fdc6
263c72d8-4e5f-44cc-882a-e4a717aec054	2026-05-05 00:38:37.824032+00	2026-05-05 00:38:37.824032+00	password	d0dc2822-4846-4201-a5ff-0d3c24253c18
2c43642a-3915-4314-b9ce-429c87bc821a	2026-05-05 00:39:03.669577+00	2026-05-05 00:39:03.669577+00	password	50f1b40b-8e42-495a-adc4-c04a6ff5dc1a
569311da-76cf-4671-837a-c965bdf2f265	2026-05-05 00:40:13.782415+00	2026-05-05 00:40:13.782415+00	password	020ec688-6f5a-4139-a761-9e82df158638
906435ac-18e1-4255-93c0-415641487f0d	2026-05-05 10:11:58.255853+00	2026-05-05 10:11:58.255853+00	password	2e5cb32b-a638-443a-bbd5-211565dcdb37
bcb49636-4bd3-4192-abdb-a334e54a0658	2026-05-05 10:19:33.452247+00	2026-05-05 10:19:33.452247+00	password	6e56d9d8-965e-4b07-88b8-7161de36ebfe
e831f3e7-1683-48c0-b7c6-bc06fd66b75a	2026-05-05 10:37:27.566936+00	2026-05-05 10:37:27.566936+00	password	50cda394-36cd-4dcb-85a0-a6d78ee03aa2
858b306e-3bec-4b19-91b3-6161226bdad9	2026-05-05 10:42:47.103121+00	2026-05-05 10:42:47.103121+00	password	294025d9-f2c3-4544-9f0c-f591de4a8fc3
5d6efd21-990e-43dc-b3a5-27c9ca2788f0	2026-05-05 10:48:38.449945+00	2026-05-05 10:48:38.449945+00	password	993aa718-5444-40d2-bdcf-8d08939b8d23
ac106d55-b28b-4b2a-bbab-3b61c54ab32e	2026-05-05 11:53:15.915199+00	2026-05-05 11:53:15.915199+00	password	9665622d-449f-468e-9539-cc278447dc70
05c7791e-ddc2-4221-8ff7-f74b3e62d4a3	2026-05-05 12:03:44.966853+00	2026-05-05 12:03:44.966853+00	password	8f656f3c-31eb-4dcd-81eb-f02fecbcd387
2a3ac71e-6be6-49d9-86bc-42222614f11b	2026-05-05 13:28:42.080001+00	2026-05-05 13:28:42.080001+00	password	2130043f-35ea-4b2d-8d94-8d1ad7e1226b
b994ade4-3f8a-498c-b20d-c38ab01a53e2	2026-05-05 13:40:46.226737+00	2026-05-05 13:40:46.226737+00	password	30d19904-6059-4464-b9e5-1ae98a868341
390495b9-2289-486e-92f9-f6c40f6be253	2026-05-05 13:56:25.180762+00	2026-05-05 13:56:25.180762+00	password	b007930f-8d2e-4136-a03e-dc6d95f3f486
1362ecc5-0511-4636-9cb9-8b5142b1d880	2026-05-05 18:27:42.959598+00	2026-05-05 18:27:42.959598+00	password	820d927f-29e7-471e-8d8a-a9cc59cc36f7
3300d270-ba7b-40dd-8149-6904cd070305	2026-05-05 18:34:09.554142+00	2026-05-05 18:34:09.554142+00	password	1c1508d5-049c-42ea-847b-081150acb04a
6c33e142-21ac-4f0c-a3c9-f1e5b6ba7049	2026-05-07 03:58:03.519332+00	2026-05-07 03:58:03.519332+00	password	865c2c9c-4d69-4da3-9652-84fd0c96ea6c
895c2eb2-91d3-4704-933c-966697cf422e	2026-05-07 04:20:09.260986+00	2026-05-07 04:20:09.260986+00	password	c951f365-14f7-45bc-9288-ff7f05381d35
3c330d96-a237-412e-9d34-d68f171b53fc	2026-05-07 04:22:15.869672+00	2026-05-07 04:22:15.869672+00	password	61a2bcbb-4952-4329-842b-46bc694a21f4
336e8ae8-3399-4dd5-98e3-18fba894d75d	2026-05-07 04:27:06.378113+00	2026-05-07 04:27:06.378113+00	password	dc9e74d8-25b5-45a3-a785-6c637c4fcaf0
35ebcaf3-0eaf-4160-ae09-da12ecf336f6	2026-05-07 05:00:41.280744+00	2026-05-07 05:00:41.280744+00	password	df904ac5-a146-4401-aa3d-4bf03c964cb1
4d0da295-f81a-43c9-bb7e-50cf39c1618e	2026-05-07 05:00:59.210914+00	2026-05-07 05:00:59.210914+00	password	7ec95d83-c3e1-40fe-8ed8-1544aaffa3c5
31e874cc-acfe-4043-a580-e59cf1044f93	2026-05-08 11:47:56.763796+00	2026-05-08 11:47:56.763796+00	password	f653830c-38be-4d50-952c-bb5f0fcd5047
270d0805-9dc5-4f39-a2b0-17db677fc536	2026-05-08 11:48:06.004825+00	2026-05-08 11:48:06.004825+00	password	c1db245d-bf63-4f03-9ada-bacff3612dd0
f0b1d822-8fc2-4319-ab0d-1cafdcd81d52	2026-05-08 12:19:13.313198+00	2026-05-08 12:19:13.313198+00	password	c04668f7-3e86-4b61-b781-cf1b4a950223
\.


--
-- Data for Name: mfa_challenges; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.mfa_challenges (id, factor_id, created_at, verified_at, ip_address, otp_code, web_authn_session_data) FROM stdin;
\.


--
-- Data for Name: mfa_factors; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.mfa_factors (id, user_id, friendly_name, factor_type, status, created_at, updated_at, secret, phone, last_challenged_at, web_authn_credential, web_authn_aaguid, last_webauthn_challenge_data) FROM stdin;
\.


--
-- Data for Name: oauth_authorizations; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.oauth_authorizations (id, authorization_id, client_id, user_id, redirect_uri, scope, state, resource, code_challenge, code_challenge_method, response_type, status, authorization_code, created_at, expires_at, approved_at, nonce) FROM stdin;
\.


--
-- Data for Name: oauth_client_states; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.oauth_client_states (id, provider_type, code_verifier, created_at) FROM stdin;
\.


--
-- Data for Name: oauth_clients; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.oauth_clients (id, client_secret_hash, registration_type, redirect_uris, grant_types, client_name, client_uri, logo_uri, created_at, updated_at, deleted_at, client_type, token_endpoint_auth_method) FROM stdin;
\.


--
-- Data for Name: oauth_consents; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.oauth_consents (id, user_id, client_id, scopes, granted_at, revoked_at) FROM stdin;
\.


--
-- Data for Name: one_time_tokens; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.one_time_tokens (id, user_id, token_type, token_hash, relates_to, created_at, updated_at) FROM stdin;
29d40407-ae2a-4a76-adb1-1216d4eb57e6	ad86439a-31de-4eed-a303-5d2fed9fec39	confirmation_token	bb3ef61dbaef2e5015e5552a80fd1bae2724517e7ed4ebeef160cb1b	testsupabase@gmail.com	2026-03-05 16:52:30.856038	2026-03-05 16:52:30.856038
\.


--
-- Data for Name: refresh_tokens; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.refresh_tokens (instance_id, id, token, user_id, revoked, created_at, updated_at, parent, session_id) FROM stdin;
00000000-0000-0000-0000-000000000000	1	lmhlvndvyisa	e91e88ce-b231-40e5-a093-68283662b146	f	2026-03-05 17:00:50.566446+00	2026-03-05 17:00:50.566446+00	\N	571dcb60-528a-4f23-badf-8f004837534f
00000000-0000-0000-0000-000000000000	2	3orw3bywesdu	e91e88ce-b231-40e5-a093-68283662b146	f	2026-03-05 17:00:54.408088+00	2026-03-05 17:00:54.408088+00	\N	c5cc292e-4b6c-4f0d-a61d-004a09f1c2a7
00000000-0000-0000-0000-000000000000	3	utgmqrlu7jf2	c5bbbc6d-abd6-477b-8998-400c04face6c	f	2026-03-05 17:24:07.009273+00	2026-03-05 17:24:07.009273+00	\N	76bf8189-c1a6-41de-9ac6-6e01f6811b78
00000000-0000-0000-0000-000000000000	4	kcgdvieawf52	c5bbbc6d-abd6-477b-8998-400c04face6c	f	2026-03-05 17:24:21.61396+00	2026-03-05 17:24:21.61396+00	\N	bf407aca-5a8d-478d-9876-de7ce07135d9
00000000-0000-0000-0000-000000000000	5	4cvc2bzkby5j	e91e88ce-b231-40e5-a093-68283662b146	f	2026-03-05 17:39:37.100846+00	2026-03-05 17:39:37.100846+00	\N	f1df7cd7-9261-428f-8124-17a0d2562e0e
00000000-0000-0000-0000-000000000000	6	ne6v4bwhpn23	e91e88ce-b231-40e5-a093-68283662b146	f	2026-03-05 19:01:01.451251+00	2026-03-05 19:01:01.451251+00	\N	750d91d3-743d-402b-8d9c-b68141cda3ca
00000000-0000-0000-0000-000000000000	7	vcdafbmavpoo	c5bbbc6d-abd6-477b-8998-400c04face6c	f	2026-03-09 03:58:27.450505+00	2026-03-09 03:58:27.450505+00	\N	2bc71d11-624a-45cc-9e1b-37f8ee18658e
00000000-0000-0000-0000-000000000000	8	kid7qpzvzh2p	e91e88ce-b231-40e5-a093-68283662b146	f	2026-03-09 20:39:03.175929+00	2026-03-09 20:39:03.175929+00	\N	9afd34da-6508-4fd6-a942-16ffdb91d826
00000000-0000-0000-0000-000000000000	9	q2hmmpjrkn6s	e91e88ce-b231-40e5-a093-68283662b146	f	2026-03-09 21:28:38.912443+00	2026-03-09 21:28:38.912443+00	\N	93a17e56-d79f-4e7f-8acb-23590d2a8ce6
00000000-0000-0000-0000-000000000000	10	jkgceenwoao2	e91e88ce-b231-40e5-a093-68283662b146	f	2026-03-10 01:37:13.958928+00	2026-03-10 01:37:13.958928+00	\N	5229ea93-9479-44c5-b7b5-c0a48139caff
00000000-0000-0000-0000-000000000000	11	wsx34ocnhijq	e91e88ce-b231-40e5-a093-68283662b146	f	2026-03-10 01:53:10.306135+00	2026-03-10 01:53:10.306135+00	\N	286cae0e-45a2-4740-a057-33324b159b68
00000000-0000-0000-0000-000000000000	12	dbndrrc26ixy	8a58df87-1912-4c39-a0c8-dc195db490f3	f	2026-03-10 02:40:10.737052+00	2026-03-10 02:40:10.737052+00	\N	1e96260b-aac0-46b6-8890-3776d669a202
00000000-0000-0000-0000-000000000000	13	rsjzm7xl7bi4	8a58df87-1912-4c39-a0c8-dc195db490f3	f	2026-03-10 02:40:14.098958+00	2026-03-10 02:40:14.098958+00	\N	f3fa007e-95cc-49b6-a3de-628d50a89ff1
00000000-0000-0000-0000-000000000000	14	kwbaqbf4yfmg	8a58df87-1912-4c39-a0c8-dc195db490f3	f	2026-03-11 22:17:59.579773+00	2026-03-11 22:17:59.579773+00	\N	7bfafe7f-8d5b-4a33-8179-768aa6399b78
00000000-0000-0000-0000-000000000000	15	ho22vzo7zj2l	8a58df87-1912-4c39-a0c8-dc195db490f3	f	2026-03-14 19:50:21.241618+00	2026-03-14 19:50:21.241618+00	\N	1a20eab6-93b4-4815-90d5-a570d6cca0ef
00000000-0000-0000-0000-000000000000	16	ajk3v6v2stiv	8a58df87-1912-4c39-a0c8-dc195db490f3	f	2026-03-16 13:17:07.37613+00	2026-03-16 13:17:07.37613+00	\N	f6b6db9d-2216-40f8-8d1e-62e613c6729f
00000000-0000-0000-0000-000000000000	17	hb45nmxhp3j4	bec157c7-cd63-4535-a8b7-7983ea223b7a	f	2026-03-16 13:27:09.127354+00	2026-03-16 13:27:09.127354+00	\N	2f78a2c6-5a77-4cfe-a8b2-fda01ff52c47
00000000-0000-0000-0000-000000000000	18	otqgxpjpszwu	bec157c7-cd63-4535-a8b7-7983ea223b7a	f	2026-03-16 13:27:41.940828+00	2026-03-16 13:27:41.940828+00	\N	c80c321e-99d1-4379-95cd-caf43a8768ba
00000000-0000-0000-0000-000000000000	19	ty2scqhcaklj	22e32e2a-0a39-4d7d-baca-de0a29aaaac3	f	2026-03-17 16:40:10.599592+00	2026-03-17 16:40:10.599592+00	\N	3b9f1ff2-76bc-4fe0-80cf-0c0da22b9801
00000000-0000-0000-0000-000000000000	20	rcbqwa624kpy	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	f	2026-03-17 16:41:41.288494+00	2026-03-17 16:41:41.288494+00	\N	d6bb7d2b-835e-474e-b800-88e286b05f7c
00000000-0000-0000-0000-000000000000	21	j4iglosj7vti	22e32e2a-0a39-4d7d-baca-de0a29aaaac3	f	2026-03-17 16:48:11.34172+00	2026-03-17 16:48:11.34172+00	\N	16984bfb-aa24-4093-9555-fafe2da55297
00000000-0000-0000-0000-000000000000	22	p54xc3ocx4u7	22e32e2a-0a39-4d7d-baca-de0a29aaaac3	f	2026-03-17 18:02:47.421906+00	2026-03-17 18:02:47.421906+00	\N	2ba510b0-3031-457d-a555-3e56b90d7c66
00000000-0000-0000-0000-000000000000	23	kbnu4kgaenkx	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	f	2026-03-17 18:06:45.416704+00	2026-03-17 18:06:45.416704+00	\N	2ae8056f-65f3-4b0b-a6ea-c913a8e7037d
00000000-0000-0000-0000-000000000000	26	qtmvrgnb65ky	22e32e2a-0a39-4d7d-baca-de0a29aaaac3	f	2026-03-17 18:16:31.831351+00	2026-03-17 18:16:31.831351+00	\N	c692bd6a-466a-4490-9f0a-c2723769fa0e
00000000-0000-0000-0000-000000000000	27	lknniys3rsih	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	f	2026-03-17 18:17:17.91345+00	2026-03-17 18:17:17.91345+00	\N	519c3515-27fd-430c-9371-fa9214778db0
00000000-0000-0000-0000-000000000000	35	5drnb2hm5736	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	f	2026-03-22 16:35:46.015105+00	2026-03-22 16:35:46.015105+00	\N	de72a969-4d9f-43fa-ba7d-7687a0fc2e3c
00000000-0000-0000-0000-000000000000	36	o2yy2xlbahw2	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	f	2026-03-22 22:13:51.722728+00	2026-03-22 22:13:51.722728+00	\N	0faa4f75-7fe7-4a9e-8a09-da2f5a7930f5
00000000-0000-0000-0000-000000000000	38	56z42dblk4sm	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	f	2026-03-22 22:40:48.23218+00	2026-03-22 22:40:48.23218+00	\N	740cb28c-d09f-4ccb-9196-e60ecfb109aa
00000000-0000-0000-0000-000000000000	39	pspablqbr24k	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	f	2026-03-23 22:31:16.898468+00	2026-03-23 22:31:16.898468+00	\N	b2ef2fad-5b2b-4974-a8e8-98aa6eeb1520
00000000-0000-0000-0000-000000000000	40	ynnynl2gncsc	22e32e2a-0a39-4d7d-baca-de0a29aaaac3	f	2026-03-24 07:40:03.894687+00	2026-03-24 07:40:03.894687+00	\N	fcc839fa-b068-4de0-b190-ef9f175d651d
00000000-0000-0000-0000-000000000000	41	htznthngo7c7	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	f	2026-03-24 08:07:24.709766+00	2026-03-24 08:07:24.709766+00	\N	63355f27-15d5-4f52-998c-f9c37f7e7620
00000000-0000-0000-0000-000000000000	43	c7f5ecccymd3	22e32e2a-0a39-4d7d-baca-de0a29aaaac3	f	2026-03-24 16:44:36.596709+00	2026-03-24 16:44:36.596709+00	\N	e11d3475-23fe-494f-a16f-3e83b7bc217f
00000000-0000-0000-0000-000000000000	44	i2fxeuwmb3v3	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	t	2026-03-24 18:13:32.23778+00	2026-03-24 22:38:05.055455+00	\N	a17e5bd9-2598-4727-aed0-37f571ca363b
00000000-0000-0000-0000-000000000000	45	nuhhzpm73swv	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	t	2026-03-24 22:38:05.084891+00	2026-03-24 22:38:05.273914+00	i2fxeuwmb3v3	a17e5bd9-2598-4727-aed0-37f571ca363b
00000000-0000-0000-0000-000000000000	46	kjjduasrcr6a	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	f	2026-03-24 22:38:05.274307+00	2026-03-24 22:38:05.274307+00	nuhhzpm73swv	a17e5bd9-2598-4727-aed0-37f571ca363b
00000000-0000-0000-0000-000000000000	47	avi4cgavv6p6	22e32e2a-0a39-4d7d-baca-de0a29aaaac3	f	2026-03-24 23:58:09.706518+00	2026-03-24 23:58:09.706518+00	\N	946069d7-86bc-45af-8a0e-a72a966ea72b
00000000-0000-0000-0000-000000000000	48	x2hut4iolxjs	22e32e2a-0a39-4d7d-baca-de0a29aaaac3	f	2026-03-25 03:36:31.551867+00	2026-03-25 03:36:31.551867+00	\N	c2725836-5e74-40e4-9450-48e01eac3c69
00000000-0000-0000-0000-000000000000	49	ymgzlkphagu6	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	f	2026-03-25 03:54:49.045611+00	2026-03-25 03:54:49.045611+00	\N	2bbb3e90-0dea-4788-a69d-cc35094ed961
00000000-0000-0000-0000-000000000000	50	txd5zh73cc3v	22e32e2a-0a39-4d7d-baca-de0a29aaaac3	f	2026-03-25 10:52:41.823419+00	2026-03-25 10:52:41.823419+00	\N	15a38ac7-26f4-48f9-af6f-c049383c0b2f
00000000-0000-0000-0000-000000000000	51	3mbevshugbk3	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	f	2026-03-25 11:58:40.374676+00	2026-03-25 11:58:40.374676+00	\N	4c0b91f5-c652-48ed-b768-e66d9eb86930
00000000-0000-0000-0000-000000000000	52	fcupwjajjikm	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	f	2026-03-25 12:04:53.315393+00	2026-03-25 12:04:53.315393+00	\N	fd5221e9-f61a-4a1a-b341-7d415ae1ec5d
00000000-0000-0000-0000-000000000000	53	vfnbtjhwsy3v	22e32e2a-0a39-4d7d-baca-de0a29aaaac3	f	2026-03-25 12:05:08.233883+00	2026-03-25 12:05:08.233883+00	\N	ada80241-a850-44a1-9925-280dcf4356a9
00000000-0000-0000-0000-000000000000	54	t3p7amccmzdt	22e32e2a-0a39-4d7d-baca-de0a29aaaac3	f	2026-03-25 12:08:48.890734+00	2026-03-25 12:08:48.890734+00	\N	b2aa9c43-597a-4d48-81f7-63e7e49ffdbb
00000000-0000-0000-0000-000000000000	55	d3kmmd5dpx2n	22e32e2a-0a39-4d7d-baca-de0a29aaaac3	f	2026-04-10 14:56:26.657029+00	2026-04-10 14:56:26.657029+00	\N	ee747375-3cf2-4552-97fe-405642cd319a
00000000-0000-0000-0000-000000000000	57	nhkaj46sekfk	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	f	2026-04-10 15:08:48.420719+00	2026-04-10 15:08:48.420719+00	\N	8986bfa7-fda7-4051-b2cb-228a38352701
00000000-0000-0000-0000-000000000000	62	3wyfe43o7nis	22e32e2a-0a39-4d7d-baca-de0a29aaaac3	t	2026-04-19 15:01:13.33452+00	2026-04-19 17:06:09.445945+00	\N	57014f88-0ac9-4078-ac73-7ae74e230f1a
00000000-0000-0000-0000-000000000000	63	zh3nrzevm2qz	22e32e2a-0a39-4d7d-baca-de0a29aaaac3	t	2026-04-19 17:06:09.466996+00	2026-04-19 17:06:09.672306+00	3wyfe43o7nis	57014f88-0ac9-4078-ac73-7ae74e230f1a
00000000-0000-0000-0000-000000000000	64	bwh5743vaw6t	22e32e2a-0a39-4d7d-baca-de0a29aaaac3	f	2026-04-19 17:06:09.673402+00	2026-04-19 17:06:09.673402+00	zh3nrzevm2qz	57014f88-0ac9-4078-ac73-7ae74e230f1a
00000000-0000-0000-0000-000000000000	65	j65ryuctdxtm	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	f	2026-04-19 22:13:31.29142+00	2026-04-19 22:13:31.29142+00	\N	b4fa5e8b-b965-4492-ae9f-00ee696d95a1
00000000-0000-0000-0000-000000000000	66	yuqzrqenisow	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	f	2026-04-20 21:24:56.197728+00	2026-04-20 21:24:56.197728+00	\N	545f2fe1-223b-4c00-b269-acd0e00e1cfa
00000000-0000-0000-0000-000000000000	67	ylzaatzn4zyv	22e32e2a-0a39-4d7d-baca-de0a29aaaac3	f	2026-04-24 21:28:03.409808+00	2026-04-24 21:28:03.409808+00	\N	2916c154-0cfe-4288-a01a-a936986917cf
00000000-0000-0000-0000-000000000000	68	54d5ntdr2vrk	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	f	2026-04-24 21:29:39.933083+00	2026-04-24 21:29:39.933083+00	\N	ab055f59-fcd1-49d3-9136-08b0fccf923d
00000000-0000-0000-0000-000000000000	69	m6mvz6seuquw	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	f	2026-04-25 04:11:54.661082+00	2026-04-25 04:11:54.661082+00	\N	11edd43b-9f0f-4ba0-b57c-ae29bff93935
00000000-0000-0000-0000-000000000000	71	gxb3ayhurqf6	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	t	2026-04-25 04:37:56.343077+00	2026-04-25 17:10:45.93444+00	\N	4b61f367-aecc-4681-b168-aeb22acf7838
00000000-0000-0000-0000-000000000000	72	52eubnhsx6wi	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	t	2026-04-25 17:10:45.962488+00	2026-04-25 17:10:46.202919+00	gxb3ayhurqf6	4b61f367-aecc-4681-b168-aeb22acf7838
00000000-0000-0000-0000-000000000000	73	2bsbyedympv2	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	f	2026-04-25 17:10:46.203922+00	2026-04-25 17:10:46.203922+00	52eubnhsx6wi	4b61f367-aecc-4681-b168-aeb22acf7838
00000000-0000-0000-0000-000000000000	74	vm5eoocj4bwf	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	f	2026-04-25 17:53:55.993405+00	2026-04-25 17:53:55.993405+00	\N	12a555a4-fbec-48c4-8bee-057d31e553ac
00000000-0000-0000-0000-000000000000	75	zaawlfjdsskn	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	f	2026-04-25 17:54:09.283935+00	2026-04-25 17:54:09.283935+00	\N	285ddf3d-7c78-4e36-b696-ebca987685df
00000000-0000-0000-0000-000000000000	76	u2rd5ps4u7eq	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	f	2026-04-25 18:00:28.900088+00	2026-04-25 18:00:28.900088+00	\N	b2d7593e-792d-46c1-9aed-cacf27af14f4
00000000-0000-0000-0000-000000000000	77	sittbyd7lfdu	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	f	2026-04-25 18:10:06.027359+00	2026-04-25 18:10:06.027359+00	\N	a2449b75-517e-4768-9ba5-8af9abe5b2b1
00000000-0000-0000-0000-000000000000	78	rxm57lslrms3	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	t	2026-04-25 20:44:45.763921+00	2026-04-25 21:44:36.11636+00	\N	90496beb-4ba2-4202-b711-12f848d85661
00000000-0000-0000-0000-000000000000	79	byln5374p2qz	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	t	2026-04-25 21:44:36.139678+00	2026-04-25 21:44:36.328267+00	rxm57lslrms3	90496beb-4ba2-4202-b711-12f848d85661
00000000-0000-0000-0000-000000000000	80	s4ml4ofzxlpz	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	f	2026-04-25 21:44:36.328644+00	2026-04-25 21:44:36.328644+00	byln5374p2qz	90496beb-4ba2-4202-b711-12f848d85661
00000000-0000-0000-0000-000000000000	81	ohzkyy5o6hmy	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	f	2026-04-25 23:18:50.317395+00	2026-04-25 23:18:50.317395+00	\N	c4c9989a-2f94-4352-b8e4-4df6d608e583
00000000-0000-0000-0000-000000000000	82	xhz5ndvuhbyh	41d0dce6-bd67-4a08-9d1f-696359e90e51	f	2026-04-26 00:51:21.576333+00	2026-04-26 00:51:21.576333+00	\N	076833a6-cf08-4298-b962-5cff262be40e
00000000-0000-0000-0000-000000000000	83	joko2tpawkv2	c5e17e59-c4b4-47a7-b699-c8d9754f6f65	f	2026-04-26 00:51:21.884174+00	2026-04-26 00:51:21.884174+00	\N	2a79d1d9-c6ac-4d62-902b-ab3766d31b2d
00000000-0000-0000-0000-000000000000	84	lnsualgvrjze	2567a845-ec31-4484-bb26-77a357087983	f	2026-04-26 00:51:22.111027+00	2026-04-26 00:51:22.111027+00	\N	c5616d63-812e-4824-adc4-2d71bcc74442
00000000-0000-0000-0000-000000000000	85	sg2pqxxop2ji	e553ff72-4848-4488-840b-29f8b19a9846	f	2026-04-26 00:51:22.346979+00	2026-04-26 00:51:22.346979+00	\N	9dd6d27e-de78-4fb2-9105-a3e3cda290c0
00000000-0000-0000-0000-000000000000	86	p52lpyok6wgv	6ee06e13-8b9d-4b7d-bb8c-f5e1392a2345	f	2026-04-26 00:51:22.577866+00	2026-04-26 00:51:22.577866+00	\N	f77b7da9-1e45-4a3a-b356-aac7bb0627db
00000000-0000-0000-0000-000000000000	87	eyuxxlteeurl	15330155-3ad3-4e5d-a70d-e02557a5ba8d	f	2026-04-26 00:51:22.800606+00	2026-04-26 00:51:22.800606+00	\N	64162651-49a7-4aeb-b0aa-cf7183e809b5
00000000-0000-0000-0000-000000000000	88	pdw6dxt4f3ak	82deb24f-e7f8-46c9-9117-ee272f1671fa	f	2026-04-26 00:51:23.03138+00	2026-04-26 00:51:23.03138+00	\N	8d57dc1b-5759-4e8e-9fb0-bdabcc6c44e1
00000000-0000-0000-0000-000000000000	89	l36jcov6hnjn	ed797688-4ace-4eaf-80cd-8697ebaba1dc	f	2026-04-26 00:51:23.27479+00	2026-04-26 00:51:23.27479+00	\N	f510790c-1af5-4828-8ff2-5cddf34e6260
00000000-0000-0000-0000-000000000000	90	kr746og6qy5b	65988fb9-ee24-402e-9f72-215888b19aa7	f	2026-04-26 00:51:23.49683+00	2026-04-26 00:51:23.49683+00	\N	379b1e6a-af85-42b5-80be-dc5b621abf16
00000000-0000-0000-0000-000000000000	91	ui257bijpecd	61050d2a-a59a-4306-a126-5ec1ceed6549	f	2026-04-26 00:51:23.721567+00	2026-04-26 00:51:23.721567+00	\N	17bed8b6-95cf-4233-ab30-dd902e24a494
00000000-0000-0000-0000-000000000000	92	vna2i2jpylaw	d4a5067d-f305-4344-80ec-ecec9777e6bc	f	2026-04-26 00:51:23.947223+00	2026-04-26 00:51:23.947223+00	\N	78474596-0edc-4f47-84e8-175f68f449e6
00000000-0000-0000-0000-000000000000	93	cixxlhcnehjh	e7c839f3-cee4-4c59-b054-1e35731ef6b4	f	2026-04-26 00:51:24.164361+00	2026-04-26 00:51:24.164361+00	\N	8ae17439-c6cd-4522-ad71-db265bccd4c1
00000000-0000-0000-0000-000000000000	94	xnhfd2js243f	c3e075ab-d4ef-4047-9e59-9a42c99e0ec6	f	2026-04-26 00:51:24.380524+00	2026-04-26 00:51:24.380524+00	\N	9fe98e2d-959d-4c48-8b5c-0f4ca4eb1dd4
00000000-0000-0000-0000-000000000000	95	ykw6ac2aqihd	078c7814-4883-4bdb-9130-353518f12d4d	f	2026-04-26 00:51:24.593532+00	2026-04-26 00:51:24.593532+00	\N	81b624e0-50d1-4da0-ba0b-01664e9bb070
00000000-0000-0000-0000-000000000000	96	qxzxjefxxv2e	0890ea95-f0dd-48c1-94d7-d96da6d9e876	f	2026-04-26 00:51:24.806169+00	2026-04-26 00:51:24.806169+00	\N	f04f483c-0aa6-4b66-8309-aa5d07a6b855
00000000-0000-0000-0000-000000000000	97	jvgum3pof4tx	ef7e8249-6c63-48e6-b3d2-dfc34f44ade7	f	2026-04-26 00:51:25.028015+00	2026-04-26 00:51:25.028015+00	\N	8b79e7ce-6bc1-4780-9f8f-ba2ad34f0fa0
00000000-0000-0000-0000-000000000000	98	glot2vtvcsha	6cc3ddc0-6296-48e1-9da4-3e35562534bd	f	2026-04-26 00:51:25.243698+00	2026-04-26 00:51:25.243698+00	\N	a0ddc0b1-c33d-43a5-a5fa-b8ba0026b2fc
00000000-0000-0000-0000-000000000000	99	qqni3tlbjkmv	0bcc0ef3-9a18-497d-9a2e-59ea53abfd82	f	2026-04-26 00:51:25.47145+00	2026-04-26 00:51:25.47145+00	\N	a2f27ef4-8e6d-4f6c-9fbd-009d42edddab
00000000-0000-0000-0000-000000000000	100	i5jho4d3eocp	9c90759f-19b4-4d84-91e8-6bae7d6205d5	f	2026-04-26 00:51:25.684586+00	2026-04-26 00:51:25.684586+00	\N	3dedcc00-410a-4bfd-bcbe-7b55c9a2432b
00000000-0000-0000-0000-000000000000	101	cqn43rlfkwwp	8b11710a-a694-4a66-af3c-c022b28b25e7	f	2026-04-26 00:51:25.925847+00	2026-04-26 00:51:25.925847+00	\N	a4f8b1f9-582e-4f1d-8b89-a714c276b06a
00000000-0000-0000-0000-000000000000	102	eubbhpudams3	f9c231e0-8859-4d97-bf6d-3fdd11fe7234	f	2026-04-26 00:51:26.147391+00	2026-04-26 00:51:26.147391+00	\N	cd455df6-a927-481c-b9fc-924bcd51cae6
00000000-0000-0000-0000-000000000000	103	r5mosecdnda2	41d0dce6-bd67-4a08-9d1f-696359e90e51	f	2026-04-26 00:54:05.352066+00	2026-04-26 00:54:05.352066+00	\N	94fd5792-9b3f-48db-a957-60e068e608dc
00000000-0000-0000-0000-000000000000	104	cgj2jcq6yc5n	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	f	2026-04-26 01:06:03.107449+00	2026-04-26 01:06:03.107449+00	\N	7060c646-dfaa-4270-bcd1-848f77453a74
00000000-0000-0000-0000-000000000000	105	ph7elxcz7jly	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	f	2026-04-26 02:59:56.909587+00	2026-04-26 02:59:56.909587+00	\N	5b41b515-b5bc-432f-9a3a-4a325fa4635e
00000000-0000-0000-0000-000000000000	107	3kbgd4h3arcm	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	f	2026-04-26 03:00:54.538266+00	2026-04-26 03:00:54.538266+00	\N	af86bfb8-687f-4c11-ac2a-6b8c962687ea
00000000-0000-0000-0000-000000000000	108	5fr7jvgl2ao3	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	f	2026-04-26 20:22:34.582517+00	2026-04-26 20:22:34.582517+00	\N	45c827ff-4251-40c0-90f7-193c6e5dfa9d
00000000-0000-0000-0000-000000000000	109	rvxbaucphtta	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	f	2026-04-27 03:02:21.427035+00	2026-04-27 03:02:21.427035+00	\N	90f803c0-6c35-459f-a8fa-d05b2531253a
00000000-0000-0000-0000-000000000000	110	3hmztm2uvxpg	22e32e2a-0a39-4d7d-baca-de0a29aaaac3	f	2026-04-27 03:02:37.416958+00	2026-04-27 03:02:37.416958+00	\N	47e24fcb-519a-4d92-a8a8-c5af2826d430
00000000-0000-0000-0000-000000000000	111	gqlfe5p5hosq	22e32e2a-0a39-4d7d-baca-de0a29aaaac3	f	2026-04-27 03:10:04.735366+00	2026-04-27 03:10:04.735366+00	\N	75162aab-92d0-4468-b533-d75a9e77369c
00000000-0000-0000-0000-000000000000	112	suolvmopqbpp	41d0dce6-bd67-4a08-9d1f-696359e90e51	f	2026-04-27 03:14:21.788332+00	2026-04-27 03:14:21.788332+00	\N	7293cb63-1497-43fa-8ec1-9363e73618a2
00000000-0000-0000-0000-000000000000	113	ral4zrcbblag	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	f	2026-04-27 03:16:18.674273+00	2026-04-27 03:16:18.674273+00	\N	e904b5f8-8563-4483-9215-c1e79ca5da79
00000000-0000-0000-0000-000000000000	114	rvhbjd7wv5wi	22e32e2a-0a39-4d7d-baca-de0a29aaaac3	f	2026-04-27 04:55:30.07936+00	2026-04-27 04:55:30.07936+00	\N	4b322928-f226-486b-b46a-b5b753145b49
00000000-0000-0000-0000-000000000000	115	lpmnpzc6wk6z	22e32e2a-0a39-4d7d-baca-de0a29aaaac3	f	2026-04-27 05:04:36.964751+00	2026-04-27 05:04:36.964751+00	\N	2cd035cf-b405-4ed3-a068-75e0ec58a672
00000000-0000-0000-0000-000000000000	116	5nowz3emgsgg	22e32e2a-0a39-4d7d-baca-de0a29aaaac3	f	2026-04-27 10:57:20.81217+00	2026-04-27 10:57:20.81217+00	\N	88ab5341-e8d4-4afc-8407-ce808fb9cb86
00000000-0000-0000-0000-000000000000	117	v746qa7ea5kg	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	f	2026-04-27 12:33:16.873181+00	2026-04-27 12:33:16.873181+00	\N	8856bdfe-0092-4cda-9a6c-16d5bc91d028
00000000-0000-0000-0000-000000000000	118	5gr5armwqkq7	22e32e2a-0a39-4d7d-baca-de0a29aaaac3	f	2026-04-27 15:07:42.879871+00	2026-04-27 15:07:42.879871+00	\N	c13174e5-f33d-40b1-8a61-b5caba57a3c7
00000000-0000-0000-0000-000000000000	119	avxvhtbmuqhe	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	f	2026-04-27 22:28:21.000944+00	2026-04-27 22:28:21.000944+00	\N	70ee3b94-989c-46d3-b126-54244d96881b
00000000-0000-0000-0000-000000000000	120	o65hpoe4wsyc	22e32e2a-0a39-4d7d-baca-de0a29aaaac3	f	2026-04-27 22:53:00.737388+00	2026-04-27 22:53:00.737388+00	\N	af6cfc1f-d011-4e2a-bf8a-daf21628a075
00000000-0000-0000-0000-000000000000	121	iz7wcua2dqjw	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	f	2026-04-27 22:53:52.239837+00	2026-04-27 22:53:52.239837+00	\N	0e4c4e3f-abf5-4b76-9d73-ed89d26c59b3
00000000-0000-0000-0000-000000000000	122	nmtutvrfxghp	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	f	2026-04-27 23:10:49.986039+00	2026-04-27 23:10:49.986039+00	\N	4031835c-6bff-4cab-b889-38bb5d252267
00000000-0000-0000-0000-000000000000	123	4hsjyffimsau	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	t	2026-04-27 23:30:10.536971+00	2026-04-28 00:30:00.71791+00	\N	c2221522-7a4e-4dca-b359-896bf661d6ee
00000000-0000-0000-0000-000000000000	124	bos33q5ytr66	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	t	2026-04-28 00:30:00.743864+00	2026-04-28 00:30:00.958215+00	4hsjyffimsau	c2221522-7a4e-4dca-b359-896bf661d6ee
00000000-0000-0000-0000-000000000000	125	wmyulml4amyh	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	t	2026-04-28 00:30:00.958569+00	2026-04-28 01:29:51.350991+00	bos33q5ytr66	c2221522-7a4e-4dca-b359-896bf661d6ee
00000000-0000-0000-0000-000000000000	126	4mk3f6q42ppq	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	t	2026-04-28 01:29:51.364795+00	2026-04-28 01:29:51.576356+00	wmyulml4amyh	c2221522-7a4e-4dca-b359-896bf661d6ee
00000000-0000-0000-0000-000000000000	127	qigfnro7zhep	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	f	2026-04-28 01:29:51.576684+00	2026-04-28 01:29:51.576684+00	4mk3f6q42ppq	c2221522-7a4e-4dca-b359-896bf661d6ee
00000000-0000-0000-0000-000000000000	128	rbjbzgocm44q	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	t	2026-04-28 13:02:06.377229+00	2026-04-28 16:19:39.340113+00	\N	4358ae17-2475-480e-99c0-3a44756c7c5c
00000000-0000-0000-0000-000000000000	129	v4dogtaudm2e	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	t	2026-04-28 16:19:39.369321+00	2026-04-28 16:19:39.791093+00	rbjbzgocm44q	4358ae17-2475-480e-99c0-3a44756c7c5c
00000000-0000-0000-0000-000000000000	130	234ytgcdo22c	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	f	2026-04-28 16:19:39.791474+00	2026-04-28 16:19:39.791474+00	v4dogtaudm2e	4358ae17-2475-480e-99c0-3a44756c7c5c
00000000-0000-0000-0000-000000000000	131	3aio2ycqvdi5	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	f	2026-04-28 16:41:09.780883+00	2026-04-28 16:41:09.780883+00	\N	8b834650-65aa-4442-bbff-0db5a838a2f9
00000000-0000-0000-0000-000000000000	132	e2xg7u5pnqii	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	f	2026-04-28 18:12:08.619611+00	2026-04-28 18:12:08.619611+00	\N	ec0bc166-e32c-46a7-8bfe-5c53c446e621
00000000-0000-0000-0000-000000000000	133	j35ytioxerz2	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	f	2026-04-28 22:30:22.336194+00	2026-04-28 22:30:22.336194+00	\N	2edef557-c409-489f-bcac-d6d0b6db2e9c
00000000-0000-0000-0000-000000000000	134	3rlld2rkpcoh	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	f	2026-04-28 22:59:32.576397+00	2026-04-28 22:59:32.576397+00	\N	c290607f-c046-44b4-bb9d-42fbe0809086
00000000-0000-0000-0000-000000000000	135	2lpcno2a4yly	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	f	2026-04-28 23:46:00.781816+00	2026-04-28 23:46:00.781816+00	\N	a8a7f1e1-78fc-434f-8c7a-15e108a66e32
00000000-0000-0000-0000-000000000000	136	i7nvxse5sbq6	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	f	2026-04-29 00:28:45.906249+00	2026-04-29 00:28:45.906249+00	\N	738b2087-6d5b-434a-b9be-de03a21c35a7
00000000-0000-0000-0000-000000000000	137	4qqwfknoxsfk	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	f	2026-04-29 01:35:26.242923+00	2026-04-29 01:35:26.242923+00	\N	f8427551-9399-4299-a6b6-72bd4c28ece5
00000000-0000-0000-0000-000000000000	138	urpu6rsjzlpw	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	t	2026-04-29 01:40:09.825111+00	2026-04-29 06:23:10.096402+00	\N	e50dfa84-80e4-48b4-b09c-9b2bbe611a2d
00000000-0000-0000-0000-000000000000	139	ii63tx4zfdes	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	t	2026-04-29 06:23:10.122758+00	2026-04-29 06:23:10.323842+00	urpu6rsjzlpw	e50dfa84-80e4-48b4-b09c-9b2bbe611a2d
00000000-0000-0000-0000-000000000000	140	4hwya4fq56w5	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	f	2026-04-29 06:23:10.324237+00	2026-04-29 06:23:10.324237+00	ii63tx4zfdes	e50dfa84-80e4-48b4-b09c-9b2bbe611a2d
00000000-0000-0000-0000-000000000000	141	5dgitlzbzafa	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	f	2026-04-29 06:42:06.979915+00	2026-04-29 06:42:06.979915+00	\N	aa9652ac-3af8-4ccf-a1aa-ededdf5e72b1
00000000-0000-0000-0000-000000000000	142	dg7psgaidfr3	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	f	2026-04-29 07:02:30.635309+00	2026-04-29 07:02:30.635309+00	\N	d11137a3-855f-491a-a235-28c1fe8b9375
00000000-0000-0000-0000-000000000000	143	5hq7n4jr4dko	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	f	2026-04-29 07:25:47.524495+00	2026-04-29 07:25:47.524495+00	\N	81c0b9ec-b445-40ce-8a91-610fe66513f1
00000000-0000-0000-0000-000000000000	144	6lvxphcpxwpy	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	f	2026-04-29 12:10:10.210328+00	2026-04-29 12:10:10.210328+00	\N	14f039cb-1b49-451a-b7e9-f4831010b9dc
00000000-0000-0000-0000-000000000000	145	borvkajhaolc	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	f	2026-04-29 12:37:27.135597+00	2026-04-29 12:37:27.135597+00	\N	b34669e3-3ba1-47ce-8b44-d601ff2317d6
00000000-0000-0000-0000-000000000000	146	y2adno6gc2tc	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	f	2026-04-29 13:06:27.751325+00	2026-04-29 13:06:27.751325+00	\N	64e2680c-b11c-43ca-8e5c-3b7c8416ca7f
00000000-0000-0000-0000-000000000000	147	3mwj6b3mrxzo	c5e17e59-c4b4-47a7-b699-c8d9754f6f65	f	2026-04-29 13:08:03.201859+00	2026-04-29 13:08:03.201859+00	\N	0115616a-3262-4c64-b297-71ed06403631
00000000-0000-0000-0000-000000000000	148	aru7oyxgsl7v	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	f	2026-04-29 13:13:15.609613+00	2026-04-29 13:13:15.609613+00	\N	68fd6e03-affb-4662-82f8-6da37bf55784
00000000-0000-0000-0000-000000000000	149	ebipchxxexue	c5e17e59-c4b4-47a7-b699-c8d9754f6f65	f	2026-04-29 13:58:28.873206+00	2026-04-29 13:58:28.873206+00	\N	1ae7b343-aec1-4079-b0d6-10c497aca253
00000000-0000-0000-0000-000000000000	150	7gfwcwgrefdg	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	t	2026-04-29 14:34:51.010176+00	2026-04-29 16:50:35.135795+00	\N	e69f3913-b99b-4ef3-9fec-28cb6cefe3af
00000000-0000-0000-0000-000000000000	151	czud47dfxopy	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	t	2026-04-29 16:50:35.160818+00	2026-04-29 16:50:35.367431+00	7gfwcwgrefdg	e69f3913-b99b-4ef3-9fec-28cb6cefe3af
00000000-0000-0000-0000-000000000000	152	j3bueyxfullc	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	f	2026-04-29 16:50:35.368575+00	2026-04-29 16:50:35.368575+00	czud47dfxopy	e69f3913-b99b-4ef3-9fec-28cb6cefe3af
00000000-0000-0000-0000-000000000000	153	76b2yxd45qbz	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	f	2026-04-29 16:50:55.374834+00	2026-04-29 16:50:55.374834+00	\N	4f6b3b6e-d8ea-48f0-8325-5d1aa7fb5694
00000000-0000-0000-0000-000000000000	154	derz2qprabt5	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	f	2026-04-29 21:04:35.884332+00	2026-04-29 21:04:35.884332+00	\N	d67944e9-4963-4846-8b91-0c463c5cbdd3
00000000-0000-0000-0000-000000000000	155	odiixxoqh7o4	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	f	2026-04-29 21:24:43.259331+00	2026-04-29 21:24:43.259331+00	\N	408f6423-f361-47d5-8e73-69a0bf2b9fcb
00000000-0000-0000-0000-000000000000	156	gvlye4s4wg5k	c5e17e59-c4b4-47a7-b699-c8d9754f6f65	f	2026-04-29 21:42:22.624891+00	2026-04-29 21:42:22.624891+00	\N	8e2bc0c2-46c6-4240-9665-2bbdcaeb48b5
00000000-0000-0000-0000-000000000000	157	gg2wgb53cipv	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	f	2026-04-29 21:56:26.835026+00	2026-04-29 21:56:26.835026+00	\N	3b22bda1-769d-41c7-8641-44fc8f12055c
00000000-0000-0000-0000-000000000000	158	cdpvmb5ygvjz	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	f	2026-04-29 23:35:23.407753+00	2026-04-29 23:35:23.407753+00	\N	fa358f02-38b2-47f0-add2-e3182260dcf7
00000000-0000-0000-0000-000000000000	159	mv2dya3bxrv2	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	f	2026-04-30 00:21:34.94644+00	2026-04-30 00:21:34.94644+00	\N	bc0e345a-7a1b-4859-91ad-8aab090eee54
00000000-0000-0000-0000-000000000000	160	bgmzabrmhuvj	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	f	2026-04-30 00:38:10.464444+00	2026-04-30 00:38:10.464444+00	\N	88b47e5b-0054-416f-a36f-17ae7a1dbf69
00000000-0000-0000-0000-000000000000	161	g6rvx3o7kpe2	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	f	2026-04-30 00:47:28.760381+00	2026-04-30 00:47:28.760381+00	\N	52bc52fe-6bae-4265-9def-928fd9899a41
00000000-0000-0000-0000-000000000000	162	5gku625625kg	22e32e2a-0a39-4d7d-baca-de0a29aaaac3	f	2026-04-30 02:14:43.221651+00	2026-04-30 02:14:43.221651+00	\N	b4285a2e-9091-41e6-8255-c44fdd56a112
00000000-0000-0000-0000-000000000000	163	7wzhzqpaiuij	22e32e2a-0a39-4d7d-baca-de0a29aaaac3	f	2026-04-30 02:28:11.978977+00	2026-04-30 02:28:11.978977+00	\N	588debec-e23c-49b2-bc89-19d743d7ff8e
00000000-0000-0000-0000-000000000000	164	3uvtm3svdf6q	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	f	2026-04-30 02:54:36.014516+00	2026-04-30 02:54:36.014516+00	\N	ad9011a0-e6b0-4877-9f53-b49259a89001
00000000-0000-0000-0000-000000000000	165	2gsg5bu4qslq	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	f	2026-04-30 03:11:21.768664+00	2026-04-30 03:11:21.768664+00	\N	3f5163e3-7e99-4315-8e09-c63f5c052407
00000000-0000-0000-0000-000000000000	166	7idbrgm5w6tn	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	f	2026-04-30 03:24:30.680876+00	2026-04-30 03:24:30.680876+00	\N	2c352fcc-ccc1-4f87-8263-6a33b4c2a733
00000000-0000-0000-0000-000000000000	167	uuo7pn6slj4t	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	f	2026-04-30 03:24:43.870829+00	2026-04-30 03:24:43.870829+00	\N	eb152a9a-e57a-49b5-a572-2a6d23d07377
00000000-0000-0000-0000-000000000000	168	h7lppzl5r6db	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	f	2026-04-30 03:55:09.875642+00	2026-04-30 03:55:09.875642+00	\N	4ecb2b4c-1238-4b9f-b4fe-fc1f6b41dc6a
00000000-0000-0000-0000-000000000000	169	tcahwhwxclvh	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	f	2026-04-30 04:12:35.706339+00	2026-04-30 04:12:35.706339+00	\N	35b0c666-e0b8-42fb-a616-9429adabab74
00000000-0000-0000-0000-000000000000	170	2op6zpkg6bof	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	f	2026-04-30 04:49:58.253705+00	2026-04-30 04:49:58.253705+00	\N	f25646ef-ed6f-4d96-8bea-f2fde0811c81
00000000-0000-0000-0000-000000000000	171	c6qvmn6n73yg	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	f	2026-04-30 07:09:03.326841+00	2026-04-30 07:09:03.326841+00	\N	b3b6e136-e67a-4683-8d01-575a62a77f2f
00000000-0000-0000-0000-000000000000	172	5j33peus6tuf	22e32e2a-0a39-4d7d-baca-de0a29aaaac3	f	2026-04-30 10:10:50.426501+00	2026-04-30 10:10:50.426501+00	\N	ad70a6fe-7ee8-4f9d-96c8-6e75c482f74a
00000000-0000-0000-0000-000000000000	173	3gxkhq2kerg5	c5e17e59-c4b4-47a7-b699-c8d9754f6f65	f	2026-04-30 10:26:00.784885+00	2026-04-30 10:26:00.784885+00	\N	c815d6b4-43a5-4ec9-8f8a-b1b05dda800c
00000000-0000-0000-0000-000000000000	174	v4tmhxwtzyk7	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	f	2026-04-30 10:34:10.829002+00	2026-04-30 10:34:10.829002+00	\N	53826f91-dd79-40eb-8a82-0179af37fa71
00000000-0000-0000-0000-000000000000	175	l3vxm233yqtk	22e32e2a-0a39-4d7d-baca-de0a29aaaac3	f	2026-04-30 11:46:00.767014+00	2026-04-30 11:46:00.767014+00	\N	bde75454-b798-4374-bf5d-d2b435e72869
00000000-0000-0000-0000-000000000000	176	xlm5t4j2wcru	22e32e2a-0a39-4d7d-baca-de0a29aaaac3	f	2026-04-30 12:17:59.433336+00	2026-04-30 12:17:59.433336+00	\N	dadcade2-6724-4314-ad55-16e5a608b3ae
00000000-0000-0000-0000-000000000000	177	lyi4m57hfo42	c5e17e59-c4b4-47a7-b699-c8d9754f6f65	f	2026-04-30 12:52:49.337071+00	2026-04-30 12:52:49.337071+00	\N	8a7b7a24-2b94-42fe-82b4-c3c3f2f916db
00000000-0000-0000-0000-000000000000	178	7xndl5nckrjl	c5e17e59-c4b4-47a7-b699-c8d9754f6f65	f	2026-04-30 15:10:16.100675+00	2026-04-30 15:10:16.100675+00	\N	d35912df-33f6-45ea-bb48-a0bdb2cb4c77
00000000-0000-0000-0000-000000000000	179	jvrxf2f7dlv3	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	f	2026-04-30 16:28:44.978548+00	2026-04-30 16:28:44.978548+00	\N	adc9a9ff-dcf2-4899-bb73-bdca4d77fb7e
00000000-0000-0000-0000-000000000000	180	xcluyjedjt7i	22e32e2a-0a39-4d7d-baca-de0a29aaaac3	f	2026-04-30 18:20:42.059971+00	2026-04-30 18:20:42.059971+00	\N	4cc033e8-b38f-4380-917d-7a7f70e66e89
00000000-0000-0000-0000-000000000000	181	oq3f7ltkh2fr	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	t	2026-04-30 23:13:51.085181+00	2026-05-01 00:13:41.701365+00	\N	5c9ecafd-724d-4696-bc33-60e1a2e633ef
00000000-0000-0000-0000-000000000000	182	s3jbi5gfrych	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	t	2026-05-01 00:13:41.729473+00	2026-05-01 00:13:41.938448+00	oq3f7ltkh2fr	5c9ecafd-724d-4696-bc33-60e1a2e633ef
00000000-0000-0000-0000-000000000000	183	xvgkdzjt47h7	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	f	2026-05-01 00:13:41.938838+00	2026-05-01 00:13:41.938838+00	s3jbi5gfrych	5c9ecafd-724d-4696-bc33-60e1a2e633ef
00000000-0000-0000-0000-000000000000	184	fswfikvmir6x	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	f	2026-05-01 01:51:33.205978+00	2026-05-01 01:51:33.205978+00	\N	0ebe0dd1-8f70-4133-9e0d-574fda495380
00000000-0000-0000-0000-000000000000	185	avnf6jbbwjyt	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	f	2026-05-01 02:04:47.99852+00	2026-05-01 02:04:47.99852+00	\N	c9c8dbd5-0372-491a-b18f-42220cb45171
00000000-0000-0000-0000-000000000000	186	ujxcmbreukhd	c5e17e59-c4b4-47a7-b699-c8d9754f6f65	f	2026-05-01 02:51:31.331424+00	2026-05-01 02:51:31.331424+00	\N	3bbb2871-98ce-4582-b8df-d3712db17346
00000000-0000-0000-0000-000000000000	187	5boswwe5agey	c5e17e59-c4b4-47a7-b699-c8d9754f6f65	f	2026-05-01 04:27:20.408252+00	2026-05-01 04:27:20.408252+00	\N	eea67a72-3d27-4bc9-b37f-b966ae12fe2a
00000000-0000-0000-0000-000000000000	188	z6kkdly3ux6b	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	f	2026-05-01 04:29:03.58817+00	2026-05-01 04:29:03.58817+00	\N	df21b184-602b-44ce-b165-b049c0e87609
00000000-0000-0000-0000-000000000000	189	nfq7bglc7sj2	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	f	2026-05-01 04:38:16.155518+00	2026-05-01 04:38:16.155518+00	\N	77e49c65-278e-49fa-b63b-a62843c1cbb5
00000000-0000-0000-0000-000000000000	190	yhwd7rs6vtlg	22e32e2a-0a39-4d7d-baca-de0a29aaaac3	f	2026-05-01 04:57:49.421707+00	2026-05-01 04:57:49.421707+00	\N	9e043f3c-9626-4c94-975a-d0aee23a9d25
00000000-0000-0000-0000-000000000000	191	ws32swtlbgpc	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	f	2026-05-01 05:48:00.415357+00	2026-05-01 05:48:00.415357+00	\N	69a0d995-3aa9-4223-a30d-b97366cad171
00000000-0000-0000-0000-000000000000	192	d6akdql44vqe	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	f	2026-05-01 12:14:13.460473+00	2026-05-01 12:14:13.460473+00	\N	314f8fc8-75b5-4de3-ba2e-a576647f79fa
00000000-0000-0000-0000-000000000000	193	clrq3ku4a4en	22e32e2a-0a39-4d7d-baca-de0a29aaaac3	f	2026-05-01 14:53:20.446261+00	2026-05-01 14:53:20.446261+00	\N	b588f42a-ae17-4798-8103-06417b2ae105
00000000-0000-0000-0000-000000000000	194	d4dq7zylbe32	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	f	2026-05-01 15:25:54.025654+00	2026-05-01 15:25:54.025654+00	\N	7b249466-60be-4a7f-b6ac-2553a7f97f85
00000000-0000-0000-0000-000000000000	195	3stve5cwccbr	c5e17e59-c4b4-47a7-b699-c8d9754f6f65	f	2026-05-01 15:29:42.939307+00	2026-05-01 15:29:42.939307+00	\N	dd977ca1-3c28-462b-974a-ed28337ef744
00000000-0000-0000-0000-000000000000	196	3ftxeq6rg4yv	c5e17e59-c4b4-47a7-b699-c8d9754f6f65	f	2026-05-01 15:49:28.68634+00	2026-05-01 15:49:28.68634+00	\N	dd6b79bd-356a-4b11-b1f6-321a973c5a24
00000000-0000-0000-0000-000000000000	197	hjn3jbiqpfhp	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	f	2026-05-01 15:53:46.139225+00	2026-05-01 15:53:46.139225+00	\N	33a3f91d-5f63-48b6-a51f-289a99b0540a
00000000-0000-0000-0000-000000000000	198	cc557p4qmia3	22e32e2a-0a39-4d7d-baca-de0a29aaaac3	f	2026-05-01 16:02:24.153718+00	2026-05-01 16:02:24.153718+00	\N	b4e6c621-ece0-42b9-98db-c280181f7b18
00000000-0000-0000-0000-000000000000	199	hq2hpdgshrrc	22e32e2a-0a39-4d7d-baca-de0a29aaaac3	f	2026-05-01 16:55:58.992849+00	2026-05-01 16:55:58.992849+00	\N	8761da2c-ba43-4ca0-ab92-59ffeef82bad
00000000-0000-0000-0000-000000000000	200	napbxdp6k5mo	22e32e2a-0a39-4d7d-baca-de0a29aaaac3	t	2026-05-02 17:16:03.911371+00	2026-05-02 18:15:54.358763+00	\N	10362a88-46d7-4759-9616-a1f3c479b398
00000000-0000-0000-0000-000000000000	201	ah4r4llmex3t	22e32e2a-0a39-4d7d-baca-de0a29aaaac3	t	2026-05-02 18:15:54.379635+00	2026-05-02 18:15:54.605916+00	napbxdp6k5mo	10362a88-46d7-4759-9616-a1f3c479b398
00000000-0000-0000-0000-000000000000	202	n47x2nd7kvov	22e32e2a-0a39-4d7d-baca-de0a29aaaac3	t	2026-05-02 18:15:54.606914+00	2026-05-02 19:15:45.733318+00	ah4r4llmex3t	10362a88-46d7-4759-9616-a1f3c479b398
00000000-0000-0000-0000-000000000000	203	tslc26ehwpku	22e32e2a-0a39-4d7d-baca-de0a29aaaac3	t	2026-05-02 19:15:45.74872+00	2026-05-02 19:15:45.945237+00	n47x2nd7kvov	10362a88-46d7-4759-9616-a1f3c479b398
00000000-0000-0000-0000-000000000000	204	al6igk2xugrv	22e32e2a-0a39-4d7d-baca-de0a29aaaac3	f	2026-05-02 19:15:45.945623+00	2026-05-02 19:15:45.945623+00	tslc26ehwpku	10362a88-46d7-4759-9616-a1f3c479b398
00000000-0000-0000-0000-000000000000	205	dplz73edcmka	22e32e2a-0a39-4d7d-baca-de0a29aaaac3	f	2026-05-02 19:56:46.510045+00	2026-05-02 19:56:46.510045+00	\N	264b36e1-7d92-4dfd-9aaf-2631b9d8c287
00000000-0000-0000-0000-000000000000	206	in7rg3rnnmkm	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	f	2026-05-04 20:35:00.051262+00	2026-05-04 20:35:00.051262+00	\N	a43d66be-0f73-4beb-8327-9e082e29b58f
00000000-0000-0000-0000-000000000000	207	aqw3anpne26c	c5e17e59-c4b4-47a7-b699-c8d9754f6f65	f	2026-05-04 20:45:01.954044+00	2026-05-04 20:45:01.954044+00	\N	7923a88f-ab56-472a-9b1d-cdeba48946c8
00000000-0000-0000-0000-000000000000	208	qxczmgjudqpn	22e32e2a-0a39-4d7d-baca-de0a29aaaac3	f	2026-05-04 20:49:01.464226+00	2026-05-04 20:49:01.464226+00	\N	2eda2a32-e191-4bed-b167-827f258dfad2
00000000-0000-0000-0000-000000000000	209	rzdsmzhpkmuz	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	f	2026-05-04 21:27:59.688835+00	2026-05-04 21:27:59.688835+00	\N	39999e8d-ac78-40ef-afb7-0ba57296ccbc
00000000-0000-0000-0000-000000000000	210	an574xgd7am3	c5e17e59-c4b4-47a7-b699-c8d9754f6f65	f	2026-05-04 21:30:08.496412+00	2026-05-04 21:30:08.496412+00	\N	4ff47f8c-85a6-4904-aef7-d23d57801847
00000000-0000-0000-0000-000000000000	211	dggd757ssacr	c5e17e59-c4b4-47a7-b699-c8d9754f6f65	f	2026-05-04 21:53:19.160336+00	2026-05-04 21:53:19.160336+00	\N	e3d7097a-fb9d-4ba8-adcd-dc07d0406d7b
00000000-0000-0000-0000-000000000000	212	hi737fultgcm	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	f	2026-05-04 23:48:34.075897+00	2026-05-04 23:48:34.075897+00	\N	7a2fb2a9-492a-4244-b5a6-f2d627099717
00000000-0000-0000-0000-000000000000	213	kqesvo5kws25	22e32e2a-0a39-4d7d-baca-de0a29aaaac3	f	2026-05-05 00:01:54.789701+00	2026-05-05 00:01:54.789701+00	\N	823b64ff-2a04-498a-b14c-506a53b234c3
00000000-0000-0000-0000-000000000000	214	gzyj2cq2brmx	22e32e2a-0a39-4d7d-baca-de0a29aaaac3	f	2026-05-05 00:36:29.924812+00	2026-05-05 00:36:29.924812+00	\N	602390ce-472e-43e1-9506-efca15aec8d1
00000000-0000-0000-0000-000000000000	215	du5xmhqjwuyk	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	f	2026-05-05 00:37:32.748513+00	2026-05-05 00:37:32.748513+00	\N	83304e5d-12fe-457e-8899-0e3c8798602a
00000000-0000-0000-0000-000000000000	216	kmxp6porubwp	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	f	2026-05-05 00:38:37.821565+00	2026-05-05 00:38:37.821565+00	\N	263c72d8-4e5f-44cc-882a-e4a717aec054
00000000-0000-0000-0000-000000000000	217	mwg5uwvogxmo	65988fb9-ee24-402e-9f72-215888b19aa7	f	2026-05-05 00:39:03.666496+00	2026-05-05 00:39:03.666496+00	\N	2c43642a-3915-4314-b9ce-429c87bc821a
00000000-0000-0000-0000-000000000000	218	fdijafxwhtkr	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	f	2026-05-05 00:40:13.777198+00	2026-05-05 00:40:13.777198+00	\N	569311da-76cf-4671-837a-c965bdf2f265
00000000-0000-0000-0000-000000000000	219	pxg7232zf5u3	22e32e2a-0a39-4d7d-baca-de0a29aaaac3	f	2026-05-05 10:11:58.231912+00	2026-05-05 10:11:58.231912+00	\N	906435ac-18e1-4255-93c0-415641487f0d
00000000-0000-0000-0000-000000000000	220	whwqn7x7xqjq	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	f	2026-05-05 10:19:33.431233+00	2026-05-05 10:19:33.431233+00	\N	bcb49636-4bd3-4192-abdb-a334e54a0658
00000000-0000-0000-0000-000000000000	221	6hdgf3ymxqwm	65988fb9-ee24-402e-9f72-215888b19aa7	f	2026-05-05 10:37:27.543024+00	2026-05-05 10:37:27.543024+00	\N	e831f3e7-1683-48c0-b7c6-bc06fd66b75a
00000000-0000-0000-0000-000000000000	222	hojpabzrkmdm	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	f	2026-05-05 10:42:47.099805+00	2026-05-05 10:42:47.099805+00	\N	858b306e-3bec-4b19-91b3-6161226bdad9
00000000-0000-0000-0000-000000000000	223	pm3h3ul77zbd	65988fb9-ee24-402e-9f72-215888b19aa7	f	2026-05-05 10:48:38.440411+00	2026-05-05 10:48:38.440411+00	\N	5d6efd21-990e-43dc-b3a5-27c9ca2788f0
00000000-0000-0000-0000-000000000000	224	covsjhw7pbvo	65988fb9-ee24-402e-9f72-215888b19aa7	f	2026-05-05 11:53:15.882672+00	2026-05-05 11:53:15.882672+00	\N	ac106d55-b28b-4b2a-bbab-3b61c54ab32e
00000000-0000-0000-0000-000000000000	225	xtm6ynoi5auv	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	t	2026-05-05 12:03:44.961801+00	2026-05-05 13:18:49.40909+00	\N	05c7791e-ddc2-4221-8ff7-f74b3e62d4a3
00000000-0000-0000-0000-000000000000	226	bzs6t4oszqqn	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	t	2026-05-05 13:18:49.430561+00	2026-05-05 13:18:49.608852+00	xtm6ynoi5auv	05c7791e-ddc2-4221-8ff7-f74b3e62d4a3
00000000-0000-0000-0000-000000000000	227	yojjhjw6wvbm	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	f	2026-05-05 13:18:49.609222+00	2026-05-05 13:18:49.609222+00	bzs6t4oszqqn	05c7791e-ddc2-4221-8ff7-f74b3e62d4a3
00000000-0000-0000-0000-000000000000	228	275okvvvhvip	22e32e2a-0a39-4d7d-baca-de0a29aaaac3	f	2026-05-05 13:28:42.0619+00	2026-05-05 13:28:42.0619+00	\N	2a3ac71e-6be6-49d9-86bc-42222614f11b
00000000-0000-0000-0000-000000000000	229	7bazjdlvs2vu	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	f	2026-05-05 13:40:46.21787+00	2026-05-05 13:40:46.21787+00	\N	b994ade4-3f8a-498c-b20d-c38ab01a53e2
00000000-0000-0000-0000-000000000000	230	c7nyk3adatpg	65988fb9-ee24-402e-9f72-215888b19aa7	f	2026-05-05 13:56:25.159225+00	2026-05-05 13:56:25.159225+00	\N	390495b9-2289-486e-92f9-f6c40f6be253
00000000-0000-0000-0000-000000000000	231	3bcnin7zonrv	22e32e2a-0a39-4d7d-baca-de0a29aaaac3	f	2026-05-05 18:27:42.93661+00	2026-05-05 18:27:42.93661+00	\N	1362ecc5-0511-4636-9cb9-8b5142b1d880
00000000-0000-0000-0000-000000000000	232	2kfb7xcebs4o	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	t	2026-05-05 18:34:09.535528+00	2026-05-05 22:00:01.15079+00	\N	3300d270-ba7b-40dd-8149-6904cd070305
00000000-0000-0000-0000-000000000000	233	il5d6ob7oxsa	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	t	2026-05-05 22:00:01.179079+00	2026-05-05 22:00:01.37766+00	2kfb7xcebs4o	3300d270-ba7b-40dd-8149-6904cd070305
00000000-0000-0000-0000-000000000000	234	auy6cxiquiic	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	t	2026-05-05 22:00:01.37803+00	2026-05-06 03:32:13.695057+00	il5d6ob7oxsa	3300d270-ba7b-40dd-8149-6904cd070305
00000000-0000-0000-0000-000000000000	235	pm6w6wlsxhia	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	t	2026-05-06 03:32:13.721557+00	2026-05-06 03:32:13.909939+00	auy6cxiquiic	3300d270-ba7b-40dd-8149-6904cd070305
00000000-0000-0000-0000-000000000000	236	igu3xpo666hz	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	t	2026-05-06 03:32:13.910316+00	2026-05-06 04:47:30.814243+00	pm6w6wlsxhia	3300d270-ba7b-40dd-8149-6904cd070305
00000000-0000-0000-0000-000000000000	237	5n7t42tdgo3s	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	t	2026-05-06 04:47:30.829212+00	2026-05-06 04:47:31.0269+00	igu3xpo666hz	3300d270-ba7b-40dd-8149-6904cd070305
00000000-0000-0000-0000-000000000000	238	bwusfh2cshwo	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	t	2026-05-06 04:47:31.028628+00	2026-05-06 20:30:18.106439+00	5n7t42tdgo3s	3300d270-ba7b-40dd-8149-6904cd070305
00000000-0000-0000-0000-000000000000	239	7yru7ygqwy4a	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	t	2026-05-06 20:30:18.129858+00	2026-05-06 20:30:18.579705+00	bwusfh2cshwo	3300d270-ba7b-40dd-8149-6904cd070305
00000000-0000-0000-0000-000000000000	240	x4npgxwj25vz	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	t	2026-05-06 20:30:18.580118+00	2026-05-06 21:30:10.474395+00	7yru7ygqwy4a	3300d270-ba7b-40dd-8149-6904cd070305
00000000-0000-0000-0000-000000000000	241	sfhqrf7jjynw	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	t	2026-05-06 21:30:10.498352+00	2026-05-06 21:30:10.668228+00	x4npgxwj25vz	3300d270-ba7b-40dd-8149-6904cd070305
00000000-0000-0000-0000-000000000000	242	4ppian6t6jfx	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	t	2026-05-06 21:30:10.668607+00	2026-05-06 22:30:03.750689+00	sfhqrf7jjynw	3300d270-ba7b-40dd-8149-6904cd070305
00000000-0000-0000-0000-000000000000	243	xay4bvsp5fvs	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	t	2026-05-06 22:30:03.76791+00	2026-05-06 22:30:03.942242+00	4ppian6t6jfx	3300d270-ba7b-40dd-8149-6904cd070305
00000000-0000-0000-0000-000000000000	244	okyxgflae7l4	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	f	2026-05-06 22:30:03.942708+00	2026-05-06 22:30:03.942708+00	xay4bvsp5fvs	3300d270-ba7b-40dd-8149-6904cd070305
00000000-0000-0000-0000-000000000000	245	ikjliiwy2enb	22e32e2a-0a39-4d7d-baca-de0a29aaaac3	f	2026-05-07 03:58:03.480542+00	2026-05-07 03:58:03.480542+00	\N	6c33e142-21ac-4f0c-a3c9-f1e5b6ba7049
00000000-0000-0000-0000-000000000000	246	3raanmrctgpt	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	f	2026-05-07 04:20:09.233192+00	2026-05-07 04:20:09.233192+00	\N	895c2eb2-91d3-4704-933c-966697cf422e
00000000-0000-0000-0000-000000000000	247	qvs7bbmui2at	22e32e2a-0a39-4d7d-baca-de0a29aaaac3	f	2026-05-07 04:22:15.846786+00	2026-05-07 04:22:15.846786+00	\N	3c330d96-a237-412e-9d34-d68f171b53fc
00000000-0000-0000-0000-000000000000	248	kxawxrnuvojj	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	f	2026-05-07 04:27:06.375332+00	2026-05-07 04:27:06.375332+00	\N	336e8ae8-3399-4dd5-98e3-18fba894d75d
00000000-0000-0000-0000-000000000000	249	umce5uvbiqcb	22e32e2a-0a39-4d7d-baca-de0a29aaaac3	f	2026-05-07 05:00:41.262067+00	2026-05-07 05:00:41.262067+00	\N	35ebcaf3-0eaf-4160-ae09-da12ecf336f6
00000000-0000-0000-0000-000000000000	250	fier3fkn5iyc	65988fb9-ee24-402e-9f72-215888b19aa7	f	2026-05-07 05:00:59.20963+00	2026-05-07 05:00:59.20963+00	\N	4d0da295-f81a-43c9-bb7e-50cf39c1618e
00000000-0000-0000-0000-000000000000	251	e33np22w2b7i	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	f	2026-05-08 11:47:56.718236+00	2026-05-08 11:47:56.718236+00	\N	31e874cc-acfe-4043-a580-e59cf1044f93
00000000-0000-0000-0000-000000000000	252	dzftqqwnysw5	22e32e2a-0a39-4d7d-baca-de0a29aaaac3	f	2026-05-08 11:48:06.001904+00	2026-05-08 11:48:06.001904+00	\N	270d0805-9dc5-4f39-a2b0-17db677fc536
00000000-0000-0000-0000-000000000000	253	l32w77tqhzhj	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	f	2026-05-08 12:19:13.28112+00	2026-05-08 12:19:13.28112+00	\N	f0b1d822-8fc2-4319-ab0d-1cafdcd81d52
\.


--
-- Data for Name: saml_providers; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.saml_providers (id, sso_provider_id, entity_id, metadata_xml, metadata_url, attribute_mapping, created_at, updated_at, name_id_format) FROM stdin;
\.


--
-- Data for Name: saml_relay_states; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.saml_relay_states (id, sso_provider_id, request_id, for_email, redirect_to, created_at, updated_at, flow_state_id) FROM stdin;
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.schema_migrations (version) FROM stdin;
20171026211738
20171026211808
20171026211834
20180103212743
20180108183307
20180119214651
20180125194653
00
20210710035447
20210722035447
20210730183235
20210909172000
20210927181326
20211122151130
20211124214934
20211202183645
20220114185221
20220114185340
20220224000811
20220323170000
20220429102000
20220531120530
20220614074223
20220811173540
20221003041349
20221003041400
20221011041400
20221020193600
20221021073300
20221021082433
20221027105023
20221114143122
20221114143410
20221125140132
20221208132122
20221215195500
20221215195800
20221215195900
20230116124310
20230116124412
20230131181311
20230322519590
20230402418590
20230411005111
20230508135423
20230523124323
20230818113222
20230914180801
20231027141322
20231114161723
20231117164230
20240115144230
20240214120130
20240306115329
20240314092811
20240427152123
20240612123726
20240729123726
20240802193726
20240806073726
20241009103726
20250717082212
20250731150234
20250804100000
20250901200500
20250903112500
20250904133000
20250925093508
20251007112900
20251104100000
20251111201300
20251201000000
20260115000000
20260121000000
20260219120000
20260302000000
\.


--
-- Data for Name: sessions; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.sessions (id, user_id, created_at, updated_at, factor_id, aal, not_after, refreshed_at, user_agent, ip, tag, oauth_client_id, refresh_token_hmac_key, refresh_token_counter, scopes) FROM stdin;
571dcb60-528a-4f23-badf-8f004837534f	e91e88ce-b231-40e5-a093-68283662b146	2026-03-05 17:00:50.558346+00	2026-03-05 17:00:50.558346+00	\N	aal1	\N	\N	python-httpx/0.28.1	149.2.82.62	\N	\N	\N	\N	\N
c5cc292e-4b6c-4f0d-a61d-004a09f1c2a7	e91e88ce-b231-40e5-a093-68283662b146	2026-03-05 17:00:54.406976+00	2026-03-05 17:00:54.406976+00	\N	aal1	\N	\N	python-httpx/0.28.1	149.2.82.62	\N	\N	\N	\N	\N
76bf8189-c1a6-41de-9ac6-6e01f6811b78	c5bbbc6d-abd6-477b-8998-400c04face6c	2026-03-05 17:24:07.002415+00	2026-03-05 17:24:07.002415+00	\N	aal1	\N	\N	python-httpx/0.28.1	149.2.82.62	\N	\N	\N	\N	\N
bf407aca-5a8d-478d-9876-de7ce07135d9	c5bbbc6d-abd6-477b-8998-400c04face6c	2026-03-05 17:24:21.61089+00	2026-03-05 17:24:21.61089+00	\N	aal1	\N	\N	python-httpx/0.28.1	149.2.82.62	\N	\N	\N	\N	\N
f1df7cd7-9261-428f-8124-17a0d2562e0e	e91e88ce-b231-40e5-a093-68283662b146	2026-03-05 17:39:37.080068+00	2026-03-05 17:39:37.080068+00	\N	aal1	\N	\N	python-httpx/0.28.1	149.2.82.62	\N	\N	\N	\N	\N
750d91d3-743d-402b-8d9c-b68141cda3ca	e91e88ce-b231-40e5-a093-68283662b146	2026-03-05 19:01:01.429828+00	2026-03-05 19:01:01.429828+00	\N	aal1	\N	\N	python-httpx/0.28.1	149.2.82.62	\N	\N	\N	\N	\N
2bc71d11-624a-45cc-9e1b-37f8ee18658e	c5bbbc6d-abd6-477b-8998-400c04face6c	2026-03-09 03:58:27.430869+00	2026-03-09 03:58:27.430869+00	\N	aal1	\N	\N	python-httpx/0.28.1	38.159.109.114	\N	\N	\N	\N	\N
9afd34da-6508-4fd6-a942-16ffdb91d826	e91e88ce-b231-40e5-a093-68283662b146	2026-03-09 20:39:03.125115+00	2026-03-09 20:39:03.125115+00	\N	aal1	\N	\N	python-httpx/0.28.1	38.159.109.114	\N	\N	\N	\N	\N
93a17e56-d79f-4e7f-8acb-23590d2a8ce6	e91e88ce-b231-40e5-a093-68283662b146	2026-03-09 21:28:38.881162+00	2026-03-09 21:28:38.881162+00	\N	aal1	\N	\N	python-httpx/0.28.1	38.159.109.114	\N	\N	\N	\N	\N
5229ea93-9479-44c5-b7b5-c0a48139caff	e91e88ce-b231-40e5-a093-68283662b146	2026-03-10 01:37:13.91518+00	2026-03-10 01:37:13.91518+00	\N	aal1	\N	\N	python-httpx/0.28.1	38.159.109.114	\N	\N	\N	\N	\N
286cae0e-45a2-4740-a057-33324b159b68	e91e88ce-b231-40e5-a093-68283662b146	2026-03-10 01:53:10.2806+00	2026-03-10 01:53:10.2806+00	\N	aal1	\N	\N	python-httpx/0.28.1	38.159.109.114	\N	\N	\N	\N	\N
1e96260b-aac0-46b6-8890-3776d669a202	8a58df87-1912-4c39-a0c8-dc195db490f3	2026-03-10 02:40:10.728316+00	2026-03-10 02:40:10.728316+00	\N	aal1	\N	\N	python-httpx/0.28.1	38.159.109.114	\N	\N	\N	\N	\N
f3fa007e-95cc-49b6-a3de-628d50a89ff1	8a58df87-1912-4c39-a0c8-dc195db490f3	2026-03-10 02:40:14.097907+00	2026-03-10 02:40:14.097907+00	\N	aal1	\N	\N	python-httpx/0.28.1	38.159.109.114	\N	\N	\N	\N	\N
7bfafe7f-8d5b-4a33-8179-768aa6399b78	8a58df87-1912-4c39-a0c8-dc195db490f3	2026-03-11 22:17:59.525904+00	2026-03-11 22:17:59.525904+00	\N	aal1	\N	\N	python-httpx/0.28.1	38.159.109.114	\N	\N	\N	\N	\N
1a20eab6-93b4-4815-90d5-a570d6cca0ef	8a58df87-1912-4c39-a0c8-dc195db490f3	2026-03-14 19:50:21.197083+00	2026-03-14 19:50:21.197083+00	\N	aal1	\N	\N	python-httpx/0.28.1	38.159.109.114	\N	\N	\N	\N	\N
f6b6db9d-2216-40f8-8d1e-62e613c6729f	8a58df87-1912-4c39-a0c8-dc195db490f3	2026-03-16 13:17:07.330834+00	2026-03-16 13:17:07.330834+00	\N	aal1	\N	\N	python-httpx/0.28.1	149.2.82.61	\N	\N	\N	\N	\N
2f78a2c6-5a77-4cfe-a8b2-fda01ff52c47	bec157c7-cd63-4535-a8b7-7983ea223b7a	2026-03-16 13:27:09.119776+00	2026-03-16 13:27:09.119776+00	\N	aal1	\N	\N	python-httpx/0.28.1	149.2.82.61	\N	\N	\N	\N	\N
c80c321e-99d1-4379-95cd-caf43a8768ba	bec157c7-cd63-4535-a8b7-7983ea223b7a	2026-03-16 13:27:41.939426+00	2026-03-16 13:27:41.939426+00	\N	aal1	\N	\N	python-httpx/0.28.1	149.2.82.61	\N	\N	\N	\N	\N
3b9f1ff2-76bc-4fe0-80cf-0c0da22b9801	22e32e2a-0a39-4d7d-baca-de0a29aaaac3	2026-03-17 16:40:10.571685+00	2026-03-17 16:40:10.571685+00	\N	aal1	\N	\N	python-httpx/0.28.1	149.2.82.61	\N	\N	\N	\N	\N
d6bb7d2b-835e-474e-b800-88e286b05f7c	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	2026-03-17 16:41:41.223257+00	2026-03-17 16:41:41.223257+00	\N	aal1	\N	\N	python-httpx/0.28.1	149.2.82.61	\N	\N	\N	\N	\N
16984bfb-aa24-4093-9555-fafe2da55297	22e32e2a-0a39-4d7d-baca-de0a29aaaac3	2026-03-17 16:48:11.330555+00	2026-03-17 16:48:11.330555+00	\N	aal1	\N	\N	python-httpx/0.28.1	149.2.82.61	\N	\N	\N	\N	\N
2ba510b0-3031-457d-a555-3e56b90d7c66	22e32e2a-0a39-4d7d-baca-de0a29aaaac3	2026-03-17 18:02:47.379159+00	2026-03-17 18:02:47.379159+00	\N	aal1	\N	\N	python-httpx/0.28.1	149.2.82.61	\N	\N	\N	\N	\N
2ae8056f-65f3-4b0b-a6ea-c913a8e7037d	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	2026-03-17 18:06:45.397481+00	2026-03-17 18:06:45.397481+00	\N	aal1	\N	\N	python-httpx/0.28.1	149.2.82.61	\N	\N	\N	\N	\N
c692bd6a-466a-4490-9f0a-c2723769fa0e	22e32e2a-0a39-4d7d-baca-de0a29aaaac3	2026-03-17 18:16:31.829494+00	2026-03-17 18:16:31.829494+00	\N	aal1	\N	\N	python-httpx/0.28.1	149.2.82.61	\N	\N	\N	\N	\N
519c3515-27fd-430c-9371-fa9214778db0	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	2026-03-17 18:17:17.910925+00	2026-03-17 18:17:17.910925+00	\N	aal1	\N	\N	python-httpx/0.28.1	149.2.82.61	\N	\N	\N	\N	\N
285ddf3d-7c78-4e36-b696-ebca987685df	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	2026-04-25 17:54:09.282678+00	2026-04-25 17:54:09.282678+00	\N	aal1	\N	\N	python-httpx/0.28.1	38.159.109.114	\N	\N	\N	\N	\N
57014f88-0ac9-4078-ac73-7ae74e230f1a	22e32e2a-0a39-4d7d-baca-de0a29aaaac3	2026-04-19 15:01:13.315838+00	2026-04-19 17:06:09.675609+00	\N	aal1	\N	2026-04-19 17:06:09.675516	python-httpx/0.28.1	45.176.95.45	\N	\N	\N	\N	\N
b4fa5e8b-b965-4492-ae9f-00ee696d95a1	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	2026-04-19 22:13:31.256903+00	2026-04-19 22:13:31.256903+00	\N	aal1	\N	\N	python-httpx/0.28.1	45.176.95.42	\N	\N	\N	\N	\N
545f2fe1-223b-4c00-b269-acd0e00e1cfa	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	2026-04-20 21:24:56.149131+00	2026-04-20 21:24:56.149131+00	\N	aal1	\N	\N	python-httpx/0.28.1	38.159.109.114	\N	\N	\N	\N	\N
2916c154-0cfe-4288-a01a-a936986917cf	22e32e2a-0a39-4d7d-baca-de0a29aaaac3	2026-04-24 21:28:03.368249+00	2026-04-24 21:28:03.368249+00	\N	aal1	\N	\N	python-httpx/0.28.1	38.159.109.114	\N	\N	\N	\N	\N
de72a969-4d9f-43fa-ba7d-7687a0fc2e3c	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	2026-03-22 16:35:45.972001+00	2026-03-22 16:35:45.972001+00	\N	aal1	\N	\N	python-httpx/0.28.1	38.159.109.114	\N	\N	\N	\N	\N
0faa4f75-7fe7-4a9e-8a09-da2f5a7930f5	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	2026-03-22 22:13:51.675006+00	2026-03-22 22:13:51.675006+00	\N	aal1	\N	\N	python-httpx/0.28.1	38.159.109.114	\N	\N	\N	\N	\N
740cb28c-d09f-4ccb-9196-e60ecfb109aa	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	2026-03-22 22:40:48.197458+00	2026-03-22 22:40:48.197458+00	\N	aal1	\N	\N	python-httpx/0.28.1	38.159.109.114	\N	\N	\N	\N	\N
b2ef2fad-5b2b-4974-a8e8-98aa6eeb1520	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	2026-03-23 22:31:16.860918+00	2026-03-23 22:31:16.860918+00	\N	aal1	\N	\N	python-httpx/0.28.1	38.159.109.114	\N	\N	\N	\N	\N
fcc839fa-b068-4de0-b190-ef9f175d651d	22e32e2a-0a39-4d7d-baca-de0a29aaaac3	2026-03-24 07:40:03.860841+00	2026-03-24 07:40:03.860841+00	\N	aal1	\N	\N	python-httpx/0.28.1	38.159.109.114	\N	\N	\N	\N	\N
63355f27-15d5-4f52-998c-f9c37f7e7620	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	2026-03-24 08:07:24.664451+00	2026-03-24 08:07:24.664451+00	\N	aal1	\N	\N	python-httpx/0.28.1	38.159.109.114	\N	\N	\N	\N	\N
e11d3475-23fe-494f-a16f-3e83b7bc217f	22e32e2a-0a39-4d7d-baca-de0a29aaaac3	2026-03-24 16:44:36.594223+00	2026-03-24 16:44:36.594223+00	\N	aal1	\N	\N	python-httpx/0.28.1	149.2.82.61	\N	\N	\N	\N	\N
ab055f59-fcd1-49d3-9136-08b0fccf923d	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	2026-04-24 21:29:39.928963+00	2026-04-24 21:29:39.928963+00	\N	aal1	\N	\N	python-httpx/0.28.1	38.159.109.114	\N	\N	\N	\N	\N
a17e5bd9-2598-4727-aed0-37f571ca363b	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	2026-03-24 18:13:32.198801+00	2026-03-24 22:38:05.278508+00	\N	aal1	\N	2026-03-24 22:38:05.278411	python-httpx/0.28.1	38.159.109.114	\N	\N	\N	\N	\N
946069d7-86bc-45af-8a0e-a72a966ea72b	22e32e2a-0a39-4d7d-baca-de0a29aaaac3	2026-03-24 23:58:09.686779+00	2026-03-24 23:58:09.686779+00	\N	aal1	\N	\N	python-httpx/0.28.1	38.159.109.114	\N	\N	\N	\N	\N
c2725836-5e74-40e4-9450-48e01eac3c69	22e32e2a-0a39-4d7d-baca-de0a29aaaac3	2026-03-25 03:36:31.507316+00	2026-03-25 03:36:31.507316+00	\N	aal1	\N	\N	python-httpx/0.28.1	38.159.109.114	\N	\N	\N	\N	\N
2bbb3e90-0dea-4788-a69d-cc35094ed961	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	2026-03-25 03:54:49.015543+00	2026-03-25 03:54:49.015543+00	\N	aal1	\N	\N	python-httpx/0.28.1	38.159.109.114	\N	\N	\N	\N	\N
15a38ac7-26f4-48f9-af6f-c049383c0b2f	22e32e2a-0a39-4d7d-baca-de0a29aaaac3	2026-03-25 10:52:41.781781+00	2026-03-25 10:52:41.781781+00	\N	aal1	\N	\N	python-httpx/0.28.1	38.159.109.114	\N	\N	\N	\N	\N
4c0b91f5-c652-48ed-b768-e66d9eb86930	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	2026-03-25 11:58:40.333877+00	2026-03-25 11:58:40.333877+00	\N	aal1	\N	\N	python-httpx/0.28.1	149.2.82.61	\N	\N	\N	\N	\N
fd5221e9-f61a-4a1a-b341-7d415ae1ec5d	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	2026-03-25 12:04:53.295994+00	2026-03-25 12:04:53.295994+00	\N	aal1	\N	\N	python-httpx/0.28.1	149.2.82.61	\N	\N	\N	\N	\N
ada80241-a850-44a1-9925-280dcf4356a9	22e32e2a-0a39-4d7d-baca-de0a29aaaac3	2026-03-25 12:05:08.229132+00	2026-03-25 12:05:08.229132+00	\N	aal1	\N	\N	python-httpx/0.28.1	149.2.82.61	\N	\N	\N	\N	\N
b2aa9c43-597a-4d48-81f7-63e7e49ffdbb	22e32e2a-0a39-4d7d-baca-de0a29aaaac3	2026-03-25 12:08:48.883532+00	2026-03-25 12:08:48.883532+00	\N	aal1	\N	\N	python-httpx/0.28.1	149.2.82.61	\N	\N	\N	\N	\N
ee747375-3cf2-4552-97fe-405642cd319a	22e32e2a-0a39-4d7d-baca-de0a29aaaac3	2026-04-10 14:56:26.607721+00	2026-04-10 14:56:26.607721+00	\N	aal1	\N	\N	python-httpx/0.28.1	149.2.82.61	\N	\N	\N	\N	\N
8986bfa7-fda7-4051-b2cb-228a38352701	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	2026-04-10 15:08:48.414628+00	2026-04-10 15:08:48.414628+00	\N	aal1	\N	\N	python-httpx/0.28.1	149.2.82.61	\N	\N	\N	\N	\N
11edd43b-9f0f-4ba0-b57c-ae29bff93935	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	2026-04-25 04:11:54.627471+00	2026-04-25 04:11:54.627471+00	\N	aal1	\N	\N	python-httpx/0.28.1	38.159.109.114	\N	\N	\N	\N	\N
b2d7593e-792d-46c1-9aed-cacf27af14f4	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	2026-04-25 18:00:28.878898+00	2026-04-25 18:00:28.878898+00	\N	aal1	\N	\N	python-httpx/0.28.1	38.159.109.114	\N	\N	\N	\N	\N
4b61f367-aecc-4681-b168-aeb22acf7838	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	2026-04-25 04:37:56.340802+00	2026-04-25 17:10:46.207887+00	\N	aal1	\N	2026-04-25 17:10:46.207797	python-httpx/0.28.1	38.159.109.114	\N	\N	\N	\N	\N
12a555a4-fbec-48c4-8bee-057d31e553ac	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	2026-04-25 17:53:55.967609+00	2026-04-25 17:53:55.967609+00	\N	aal1	\N	\N	python-httpx/0.28.1	38.159.109.114	\N	\N	\N	\N	\N
a2449b75-517e-4768-9ba5-8af9abe5b2b1	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	2026-04-25 18:10:06.006851+00	2026-04-25 18:10:06.006851+00	\N	aal1	\N	\N	python-httpx/0.28.1	38.159.109.114	\N	\N	\N	\N	\N
076833a6-cf08-4298-b962-5cff262be40e	41d0dce6-bd67-4a08-9d1f-696359e90e51	2026-04-26 00:51:21.552645+00	2026-04-26 00:51:21.552645+00	\N	aal1	\N	\N	python-httpx/0.28.1	38.159.109.114	\N	\N	\N	\N	\N
90496beb-4ba2-4202-b711-12f848d85661	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	2026-04-25 20:44:45.719361+00	2026-04-25 21:44:36.33094+00	\N	aal1	\N	2026-04-25 21:44:36.330848	python-httpx/0.28.1	45.176.95.45	\N	\N	\N	\N	\N
c4c9989a-2f94-4352-b8e4-4df6d608e583	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	2026-04-25 23:18:50.274081+00	2026-04-25 23:18:50.274081+00	\N	aal1	\N	\N	python-httpx/0.28.1	45.176.95.42	\N	\N	\N	\N	\N
2a79d1d9-c6ac-4d62-902b-ab3766d31b2d	c5e17e59-c4b4-47a7-b699-c8d9754f6f65	2026-04-26 00:51:21.883314+00	2026-04-26 00:51:21.883314+00	\N	aal1	\N	\N	python-httpx/0.28.1	38.159.109.114	\N	\N	\N	\N	\N
c5616d63-812e-4824-adc4-2d71bcc74442	2567a845-ec31-4484-bb26-77a357087983	2026-04-26 00:51:22.110287+00	2026-04-26 00:51:22.110287+00	\N	aal1	\N	\N	python-httpx/0.28.1	38.159.109.114	\N	\N	\N	\N	\N
9dd6d27e-de78-4fb2-9105-a3e3cda290c0	e553ff72-4848-4488-840b-29f8b19a9846	2026-04-26 00:51:22.345957+00	2026-04-26 00:51:22.345957+00	\N	aal1	\N	\N	python-httpx/0.28.1	38.159.109.114	\N	\N	\N	\N	\N
f77b7da9-1e45-4a3a-b356-aac7bb0627db	6ee06e13-8b9d-4b7d-bb8c-f5e1392a2345	2026-04-26 00:51:22.575495+00	2026-04-26 00:51:22.575495+00	\N	aal1	\N	\N	python-httpx/0.28.1	38.159.109.114	\N	\N	\N	\N	\N
64162651-49a7-4aeb-b0aa-cf7183e809b5	15330155-3ad3-4e5d-a70d-e02557a5ba8d	2026-04-26 00:51:22.799797+00	2026-04-26 00:51:22.799797+00	\N	aal1	\N	\N	python-httpx/0.28.1	38.159.109.114	\N	\N	\N	\N	\N
8d57dc1b-5759-4e8e-9fb0-bdabcc6c44e1	82deb24f-e7f8-46c9-9117-ee272f1671fa	2026-04-26 00:51:23.030622+00	2026-04-26 00:51:23.030622+00	\N	aal1	\N	\N	python-httpx/0.28.1	38.159.109.114	\N	\N	\N	\N	\N
f510790c-1af5-4828-8ff2-5cddf34e6260	ed797688-4ace-4eaf-80cd-8697ebaba1dc	2026-04-26 00:51:23.27392+00	2026-04-26 00:51:23.27392+00	\N	aal1	\N	\N	python-httpx/0.28.1	38.159.109.114	\N	\N	\N	\N	\N
379b1e6a-af85-42b5-80be-dc5b621abf16	65988fb9-ee24-402e-9f72-215888b19aa7	2026-04-26 00:51:23.496029+00	2026-04-26 00:51:23.496029+00	\N	aal1	\N	\N	python-httpx/0.28.1	38.159.109.114	\N	\N	\N	\N	\N
17bed8b6-95cf-4233-ab30-dd902e24a494	61050d2a-a59a-4306-a126-5ec1ceed6549	2026-04-26 00:51:23.719851+00	2026-04-26 00:51:23.719851+00	\N	aal1	\N	\N	python-httpx/0.28.1	38.159.109.114	\N	\N	\N	\N	\N
78474596-0edc-4f47-84e8-175f68f449e6	d4a5067d-f305-4344-80ec-ecec9777e6bc	2026-04-26 00:51:23.946535+00	2026-04-26 00:51:23.946535+00	\N	aal1	\N	\N	python-httpx/0.28.1	38.159.109.114	\N	\N	\N	\N	\N
8ae17439-c6cd-4522-ad71-db265bccd4c1	e7c839f3-cee4-4c59-b054-1e35731ef6b4	2026-04-26 00:51:24.163623+00	2026-04-26 00:51:24.163623+00	\N	aal1	\N	\N	python-httpx/0.28.1	38.159.109.114	\N	\N	\N	\N	\N
9fe98e2d-959d-4c48-8b5c-0f4ca4eb1dd4	c3e075ab-d4ef-4047-9e59-9a42c99e0ec6	2026-04-26 00:51:24.379741+00	2026-04-26 00:51:24.379741+00	\N	aal1	\N	\N	python-httpx/0.28.1	38.159.109.114	\N	\N	\N	\N	\N
81b624e0-50d1-4da0-ba0b-01664e9bb070	078c7814-4883-4bdb-9130-353518f12d4d	2026-04-26 00:51:24.592805+00	2026-04-26 00:51:24.592805+00	\N	aal1	\N	\N	python-httpx/0.28.1	38.159.109.114	\N	\N	\N	\N	\N
f04f483c-0aa6-4b66-8309-aa5d07a6b855	0890ea95-f0dd-48c1-94d7-d96da6d9e876	2026-04-26 00:51:24.805485+00	2026-04-26 00:51:24.805485+00	\N	aal1	\N	\N	python-httpx/0.28.1	38.159.109.114	\N	\N	\N	\N	\N
8b79e7ce-6bc1-4780-9f8f-ba2ad34f0fa0	ef7e8249-6c63-48e6-b3d2-dfc34f44ade7	2026-04-26 00:51:25.027296+00	2026-04-26 00:51:25.027296+00	\N	aal1	\N	\N	python-httpx/0.28.1	38.159.109.114	\N	\N	\N	\N	\N
a0ddc0b1-c33d-43a5-a5fa-b8ba0026b2fc	6cc3ddc0-6296-48e1-9da4-3e35562534bd	2026-04-26 00:51:25.242897+00	2026-04-26 00:51:25.242897+00	\N	aal1	\N	\N	python-httpx/0.28.1	38.159.109.114	\N	\N	\N	\N	\N
a2f27ef4-8e6d-4f6c-9fbd-009d42edddab	0bcc0ef3-9a18-497d-9a2e-59ea53abfd82	2026-04-26 00:51:25.470486+00	2026-04-26 00:51:25.470486+00	\N	aal1	\N	\N	python-httpx/0.28.1	38.159.109.114	\N	\N	\N	\N	\N
3dedcc00-410a-4bfd-bcbe-7b55c9a2432b	9c90759f-19b4-4d84-91e8-6bae7d6205d5	2026-04-26 00:51:25.683872+00	2026-04-26 00:51:25.683872+00	\N	aal1	\N	\N	python-httpx/0.28.1	38.159.109.114	\N	\N	\N	\N	\N
a4f8b1f9-582e-4f1d-8b89-a714c276b06a	8b11710a-a694-4a66-af3c-c022b28b25e7	2026-04-26 00:51:25.925114+00	2026-04-26 00:51:25.925114+00	\N	aal1	\N	\N	python-httpx/0.28.1	38.159.109.114	\N	\N	\N	\N	\N
cd455df6-a927-481c-b9fc-924bcd51cae6	f9c231e0-8859-4d97-bf6d-3fdd11fe7234	2026-04-26 00:51:26.146538+00	2026-04-26 00:51:26.146538+00	\N	aal1	\N	\N	python-httpx/0.28.1	38.159.109.114	\N	\N	\N	\N	\N
94fd5792-9b3f-48db-a957-60e068e608dc	41d0dce6-bd67-4a08-9d1f-696359e90e51	2026-04-26 00:54:05.32225+00	2026-04-26 00:54:05.32225+00	\N	aal1	\N	\N	python-httpx/0.28.1	38.159.109.114	\N	\N	\N	\N	\N
7060c646-dfaa-4270-bcd1-848f77453a74	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	2026-04-26 01:06:03.078003+00	2026-04-26 01:06:03.078003+00	\N	aal1	\N	\N	python-httpx/0.28.1	38.159.109.114	\N	\N	\N	\N	\N
5b41b515-b5bc-432f-9a3a-4a325fa4635e	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	2026-04-26 02:59:56.893454+00	2026-04-26 02:59:56.893454+00	\N	aal1	\N	\N	python-httpx/0.28.1	38.159.109.114	\N	\N	\N	\N	\N
af86bfb8-687f-4c11-ac2a-6b8c962687ea	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	2026-04-26 03:00:54.517348+00	2026-04-26 03:00:54.517348+00	\N	aal1	\N	\N	python-httpx/0.28.1	38.159.109.114	\N	\N	\N	\N	\N
45c827ff-4251-40c0-90f7-193c6e5dfa9d	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	2026-04-26 20:22:34.557205+00	2026-04-26 20:22:34.557205+00	\N	aal1	\N	\N	python-httpx/0.28.1	45.176.95.45	\N	\N	\N	\N	\N
90f803c0-6c35-459f-a8fa-d05b2531253a	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	2026-04-27 03:02:21.383267+00	2026-04-27 03:02:21.383267+00	\N	aal1	\N	\N	python-httpx/0.28.1	38.159.109.114	\N	\N	\N	\N	\N
47e24fcb-519a-4d92-a8a8-c5af2826d430	22e32e2a-0a39-4d7d-baca-de0a29aaaac3	2026-04-27 03:02:37.414758+00	2026-04-27 03:02:37.414758+00	\N	aal1	\N	\N	python-httpx/0.28.1	38.159.109.114	\N	\N	\N	\N	\N
75162aab-92d0-4468-b533-d75a9e77369c	22e32e2a-0a39-4d7d-baca-de0a29aaaac3	2026-04-27 03:10:04.707975+00	2026-04-27 03:10:04.707975+00	\N	aal1	\N	\N	python-httpx/0.28.1	38.159.109.114	\N	\N	\N	\N	\N
7293cb63-1497-43fa-8ec1-9363e73618a2	41d0dce6-bd67-4a08-9d1f-696359e90e51	2026-04-27 03:14:21.766206+00	2026-04-27 03:14:21.766206+00	\N	aal1	\N	\N	python-httpx/0.28.1	38.159.109.114	\N	\N	\N	\N	\N
e904b5f8-8563-4483-9215-c1e79ca5da79	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	2026-04-27 03:16:18.671941+00	2026-04-27 03:16:18.671941+00	\N	aal1	\N	\N	python-httpx/0.28.1	38.159.109.114	\N	\N	\N	\N	\N
4b322928-f226-486b-b46a-b5b753145b49	22e32e2a-0a39-4d7d-baca-de0a29aaaac3	2026-04-27 04:55:30.04278+00	2026-04-27 04:55:30.04278+00	\N	aal1	\N	\N	python-httpx/0.28.1	38.159.109.114	\N	\N	\N	\N	\N
2cd035cf-b405-4ed3-a068-75e0ec58a672	22e32e2a-0a39-4d7d-baca-de0a29aaaac3	2026-04-27 05:04:36.927305+00	2026-04-27 05:04:36.927305+00	\N	aal1	\N	\N	python-httpx/0.28.1	38.159.109.114	\N	\N	\N	\N	\N
88ab5341-e8d4-4afc-8407-ce808fb9cb86	22e32e2a-0a39-4d7d-baca-de0a29aaaac3	2026-04-27 10:57:20.764384+00	2026-04-27 10:57:20.764384+00	\N	aal1	\N	\N	python-httpx/0.28.1	38.159.109.114	\N	\N	\N	\N	\N
8856bdfe-0092-4cda-9a6c-16d5bc91d028	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	2026-04-27 12:33:16.838123+00	2026-04-27 12:33:16.838123+00	\N	aal1	\N	\N	python-httpx/0.28.1	190.80.245.207	\N	\N	\N	\N	\N
c13174e5-f33d-40b1-8a61-b5caba57a3c7	22e32e2a-0a39-4d7d-baca-de0a29aaaac3	2026-04-27 15:07:42.844059+00	2026-04-27 15:07:42.844059+00	\N	aal1	\N	\N	python-httpx/0.28.1	190.80.244.15	\N	\N	\N	\N	\N
70ee3b94-989c-46d3-b126-54244d96881b	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	2026-04-27 22:28:20.955921+00	2026-04-27 22:28:20.955921+00	\N	aal1	\N	\N	python-httpx/0.28.1	38.159.109.114	\N	\N	\N	\N	\N
af6cfc1f-d011-4e2a-bf8a-daf21628a075	22e32e2a-0a39-4d7d-baca-de0a29aaaac3	2026-04-27 22:53:00.680478+00	2026-04-27 22:53:00.680478+00	\N	aal1	\N	\N	python-httpx/0.28.1	38.159.109.114	\N	\N	\N	\N	\N
0e4c4e3f-abf5-4b76-9d73-ed89d26c59b3	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	2026-04-27 22:53:52.237307+00	2026-04-27 22:53:52.237307+00	\N	aal1	\N	\N	python-httpx/0.28.1	38.159.109.114	\N	\N	\N	\N	\N
4031835c-6bff-4cab-b889-38bb5d252267	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	2026-04-27 23:10:49.970652+00	2026-04-27 23:10:49.970652+00	\N	aal1	\N	\N	python-httpx/0.28.1	38.159.109.114	\N	\N	\N	\N	\N
1ae7b343-aec1-4079-b0d6-10c497aca253	c5e17e59-c4b4-47a7-b699-c8d9754f6f65	2026-04-29 13:58:28.843747+00	2026-04-29 13:58:28.843747+00	\N	aal1	\N	\N	python-httpx/0.28.1	38.159.109.114	\N	\N	\N	\N	\N
3b22bda1-769d-41c7-8641-44fc8f12055c	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	2026-04-29 21:56:26.803595+00	2026-04-29 21:56:26.803595+00	\N	aal1	\N	\N	python-httpx/0.28.1	38.159.109.114	\N	\N	\N	\N	\N
c2221522-7a4e-4dca-b359-896bf661d6ee	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	2026-04-27 23:30:10.506467+00	2026-04-28 01:29:51.579184+00	\N	aal1	\N	2026-04-28 01:29:51.579059	python-httpx/0.28.1	38.159.109.114	\N	\N	\N	\N	\N
e69f3913-b99b-4ef3-9fec-28cb6cefe3af	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	2026-04-29 14:34:50.993306+00	2026-04-29 16:50:35.3759+00	\N	aal1	\N	2026-04-29 16:50:35.375771	python-httpx/0.28.1	149.2.82.62	\N	\N	\N	\N	\N
4358ae17-2475-480e-99c0-3a44756c7c5c	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	2026-04-28 13:02:06.325814+00	2026-04-28 16:19:39.79373+00	\N	aal1	\N	2026-04-28 16:19:39.793629	python-httpx/0.28.1	149.2.82.62	\N	\N	\N	\N	\N
8b834650-65aa-4442-bbff-0db5a838a2f9	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	2026-04-28 16:41:09.741042+00	2026-04-28 16:41:09.741042+00	\N	aal1	\N	\N	python-httpx/0.28.1	149.2.82.62	\N	\N	\N	\N	\N
ec0bc166-e32c-46a7-8bfe-5c53c446e621	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	2026-04-28 18:12:08.588238+00	2026-04-28 18:12:08.588238+00	\N	aal1	\N	\N	python-httpx/0.28.1	149.2.82.62	\N	\N	\N	\N	\N
2edef557-c409-489f-bcac-d6d0b6db2e9c	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	2026-04-28 22:30:22.288013+00	2026-04-28 22:30:22.288013+00	\N	aal1	\N	\N	python-httpx/0.28.1	38.159.109.114	\N	\N	\N	\N	\N
c290607f-c046-44b4-bb9d-42fbe0809086	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	2026-04-28 22:59:32.549256+00	2026-04-28 22:59:32.549256+00	\N	aal1	\N	\N	python-httpx/0.28.1	38.159.109.114	\N	\N	\N	\N	\N
a8a7f1e1-78fc-434f-8c7a-15e108a66e32	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	2026-04-28 23:46:00.734306+00	2026-04-28 23:46:00.734306+00	\N	aal1	\N	\N	python-httpx/0.28.1	38.159.109.114	\N	\N	\N	\N	\N
738b2087-6d5b-434a-b9be-de03a21c35a7	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	2026-04-29 00:28:45.876915+00	2026-04-29 00:28:45.876915+00	\N	aal1	\N	\N	python-httpx/0.28.1	38.159.109.114	\N	\N	\N	\N	\N
f8427551-9399-4299-a6b6-72bd4c28ece5	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	2026-04-29 01:35:26.208573+00	2026-04-29 01:35:26.208573+00	\N	aal1	\N	\N	python-httpx/0.28.1	38.159.109.114	\N	\N	\N	\N	\N
4f6b3b6e-d8ea-48f0-8325-5d1aa7fb5694	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	2026-04-29 16:50:55.371763+00	2026-04-29 16:50:55.371763+00	\N	aal1	\N	\N	python-httpx/0.28.1	149.2.82.62	\N	\N	\N	\N	\N
e50dfa84-80e4-48b4-b09c-9b2bbe611a2d	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	2026-04-29 01:40:09.809428+00	2026-04-29 06:23:10.327952+00	\N	aal1	\N	2026-04-29 06:23:10.327853	python-httpx/0.28.1	38.159.109.114	\N	\N	\N	\N	\N
aa9652ac-3af8-4ccf-a1aa-ededdf5e72b1	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	2026-04-29 06:42:06.963759+00	2026-04-29 06:42:06.963759+00	\N	aal1	\N	\N	python-httpx/0.28.1	38.159.109.114	\N	\N	\N	\N	\N
d11137a3-855f-491a-a235-28c1fe8b9375	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	2026-04-29 07:02:30.598878+00	2026-04-29 07:02:30.598878+00	\N	aal1	\N	\N	python-httpx/0.28.1	38.159.109.114	\N	\N	\N	\N	\N
81c0b9ec-b445-40ce-8a91-610fe66513f1	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	2026-04-29 07:25:47.485504+00	2026-04-29 07:25:47.485504+00	\N	aal1	\N	\N	python-httpx/0.28.1	38.159.109.114	\N	\N	\N	\N	\N
14f039cb-1b49-451a-b7e9-f4831010b9dc	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	2026-04-29 12:10:10.158676+00	2026-04-29 12:10:10.158676+00	\N	aal1	\N	\N	python-httpx/0.28.1	38.159.109.114	\N	\N	\N	\N	\N
b34669e3-3ba1-47ce-8b44-d601ff2317d6	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	2026-04-29 12:37:27.107062+00	2026-04-29 12:37:27.107062+00	\N	aal1	\N	\N	python-httpx/0.28.1	38.159.109.114	\N	\N	\N	\N	\N
64e2680c-b11c-43ca-8e5c-3b7c8416ca7f	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	2026-04-29 13:06:27.710105+00	2026-04-29 13:06:27.710105+00	\N	aal1	\N	\N	python-httpx/0.28.1	38.159.109.114	\N	\N	\N	\N	\N
0115616a-3262-4c64-b297-71ed06403631	c5e17e59-c4b4-47a7-b699-c8d9754f6f65	2026-04-29 13:08:03.184984+00	2026-04-29 13:08:03.184984+00	\N	aal1	\N	\N	python-httpx/0.28.1	38.159.109.114	\N	\N	\N	\N	\N
68fd6e03-affb-4662-82f8-6da37bf55784	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	2026-04-29 13:13:15.590795+00	2026-04-29 13:13:15.590795+00	\N	aal1	\N	\N	python-httpx/0.28.1	38.159.109.114	\N	\N	\N	\N	\N
d67944e9-4963-4846-8b91-0c463c5cbdd3	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	2026-04-29 21:04:35.836397+00	2026-04-29 21:04:35.836397+00	\N	aal1	\N	\N	python-httpx/0.28.1	38.159.109.114	\N	\N	\N	\N	\N
408f6423-f361-47d5-8e73-69a0bf2b9fcb	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	2026-04-29 21:24:43.214405+00	2026-04-29 21:24:43.214405+00	\N	aal1	\N	\N	python-httpx/0.28.1	38.159.109.114	\N	\N	\N	\N	\N
8e2bc0c2-46c6-4240-9665-2bbdcaeb48b5	c5e17e59-c4b4-47a7-b699-c8d9754f6f65	2026-04-29 21:42:22.532472+00	2026-04-29 21:42:22.532472+00	\N	aal1	\N	\N	python-httpx/0.28.1	38.159.109.114	\N	\N	\N	\N	\N
fa358f02-38b2-47f0-add2-e3182260dcf7	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	2026-04-29 23:35:23.384625+00	2026-04-29 23:35:23.384625+00	\N	aal1	\N	\N	python-httpx/0.28.1	38.159.109.114	\N	\N	\N	\N	\N
bc0e345a-7a1b-4859-91ad-8aab090eee54	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	2026-04-30 00:21:34.896192+00	2026-04-30 00:21:34.896192+00	\N	aal1	\N	\N	python-httpx/0.28.1	38.159.109.114	\N	\N	\N	\N	\N
88b47e5b-0054-416f-a36f-17ae7a1dbf69	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	2026-04-30 00:38:10.42706+00	2026-04-30 00:38:10.42706+00	\N	aal1	\N	\N	python-httpx/0.28.1	38.159.109.114	\N	\N	\N	\N	\N
52bc52fe-6bae-4265-9def-928fd9899a41	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	2026-04-30 00:47:28.683724+00	2026-04-30 00:47:28.683724+00	\N	aal1	\N	\N	python-httpx/0.28.1	38.159.109.114	\N	\N	\N	\N	\N
b4285a2e-9091-41e6-8255-c44fdd56a112	22e32e2a-0a39-4d7d-baca-de0a29aaaac3	2026-04-30 02:14:43.170455+00	2026-04-30 02:14:43.170455+00	\N	aal1	\N	\N	python-httpx/0.28.1	38.159.109.114	\N	\N	\N	\N	\N
588debec-e23c-49b2-bc89-19d743d7ff8e	22e32e2a-0a39-4d7d-baca-de0a29aaaac3	2026-04-30 02:28:11.954532+00	2026-04-30 02:28:11.954532+00	\N	aal1	\N	\N	python-httpx/0.28.1	38.159.109.114	\N	\N	\N	\N	\N
ad9011a0-e6b0-4877-9f53-b49259a89001	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	2026-04-30 02:54:35.988186+00	2026-04-30 02:54:35.988186+00	\N	aal1	\N	\N	python-httpx/0.28.1	38.159.109.114	\N	\N	\N	\N	\N
3f5163e3-7e99-4315-8e09-c63f5c052407	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	2026-04-30 03:11:21.745374+00	2026-04-30 03:11:21.745374+00	\N	aal1	\N	\N	python-httpx/0.28.1	38.159.109.114	\N	\N	\N	\N	\N
2c352fcc-ccc1-4f87-8263-6a33b4c2a733	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	2026-04-30 03:24:30.630703+00	2026-04-30 03:24:30.630703+00	\N	aal1	\N	\N	python-httpx/0.28.1	38.159.109.114	\N	\N	\N	\N	\N
eb152a9a-e57a-49b5-a572-2a6d23d07377	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	2026-04-30 03:24:43.869821+00	2026-04-30 03:24:43.869821+00	\N	aal1	\N	\N	python-httpx/0.28.1	38.159.109.114	\N	\N	\N	\N	\N
4ecb2b4c-1238-4b9f-b4fe-fc1f6b41dc6a	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	2026-04-30 03:55:09.829455+00	2026-04-30 03:55:09.829455+00	\N	aal1	\N	\N	python-httpx/0.28.1	38.159.109.114	\N	\N	\N	\N	\N
35b0c666-e0b8-42fb-a616-9429adabab74	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	2026-04-30 04:12:35.682799+00	2026-04-30 04:12:35.682799+00	\N	aal1	\N	\N	python-httpx/0.28.1	38.159.109.114	\N	\N	\N	\N	\N
f25646ef-ed6f-4d96-8bea-f2fde0811c81	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	2026-04-30 04:49:58.21331+00	2026-04-30 04:49:58.21331+00	\N	aal1	\N	\N	python-httpx/0.28.1	38.159.109.114	\N	\N	\N	\N	\N
b3b6e136-e67a-4683-8d01-575a62a77f2f	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	2026-04-30 07:09:03.308217+00	2026-04-30 07:09:03.308217+00	\N	aal1	\N	\N	python-httpx/0.28.1	38.159.109.114	\N	\N	\N	\N	\N
ad70a6fe-7ee8-4f9d-96c8-6e75c482f74a	22e32e2a-0a39-4d7d-baca-de0a29aaaac3	2026-04-30 10:10:50.370462+00	2026-04-30 10:10:50.370462+00	\N	aal1	\N	\N	python-httpx/0.28.1	38.159.109.114	\N	\N	\N	\N	\N
c815d6b4-43a5-4ec9-8f8a-b1b05dda800c	c5e17e59-c4b4-47a7-b699-c8d9754f6f65	2026-04-30 10:26:00.748765+00	2026-04-30 10:26:00.748765+00	\N	aal1	\N	\N	python-httpx/0.28.1	38.159.109.114	\N	\N	\N	\N	\N
53826f91-dd79-40eb-8a82-0179af37fa71	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	2026-04-30 10:34:10.816865+00	2026-04-30 10:34:10.816865+00	\N	aal1	\N	\N	python-httpx/0.28.1	38.159.109.114	\N	\N	\N	\N	\N
bde75454-b798-4374-bf5d-d2b435e72869	22e32e2a-0a39-4d7d-baca-de0a29aaaac3	2026-04-30 11:46:00.727265+00	2026-04-30 11:46:00.727265+00	\N	aal1	\N	\N	python-httpx/0.28.1	149.2.82.62	\N	\N	\N	\N	\N
dadcade2-6724-4314-ad55-16e5a608b3ae	22e32e2a-0a39-4d7d-baca-de0a29aaaac3	2026-04-30 12:17:59.415875+00	2026-04-30 12:17:59.415875+00	\N	aal1	\N	\N	python-httpx/0.28.1	149.2.82.62	\N	\N	\N	\N	\N
8a7b7a24-2b94-42fe-82b4-c3c3f2f916db	c5e17e59-c4b4-47a7-b699-c8d9754f6f65	2026-04-30 12:52:49.314172+00	2026-04-30 12:52:49.314172+00	\N	aal1	\N	\N	python-httpx/0.28.1	149.2.82.62	\N	\N	\N	\N	\N
d35912df-33f6-45ea-bb48-a0bdb2cb4c77	c5e17e59-c4b4-47a7-b699-c8d9754f6f65	2026-04-30 15:10:16.052525+00	2026-04-30 15:10:16.052525+00	\N	aal1	\N	\N	python-httpx/0.28.1	149.2.82.62	\N	\N	\N	\N	\N
adc9a9ff-dcf2-4899-bb73-bdca4d77fb7e	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	2026-04-30 16:28:44.926427+00	2026-04-30 16:28:44.926427+00	\N	aal1	\N	\N	python-httpx/0.28.1	149.2.82.62	\N	\N	\N	\N	\N
4cc033e8-b38f-4380-917d-7a7f70e66e89	22e32e2a-0a39-4d7d-baca-de0a29aaaac3	2026-04-30 18:20:42.034881+00	2026-04-30 18:20:42.034881+00	\N	aal1	\N	\N	python-httpx/0.28.1	190.167.253.246	\N	\N	\N	\N	\N
b994ade4-3f8a-498c-b20d-c38ab01a53e2	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	2026-05-05 13:40:46.20394+00	2026-05-05 13:40:46.20394+00	\N	aal1	\N	\N	python-httpx/0.28.1	149.2.82.62	\N	\N	\N	\N	\N
5c9ecafd-724d-4696-bc33-60e1a2e633ef	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	2026-04-30 23:13:51.037027+00	2026-05-01 00:13:41.94182+00	\N	aal1	\N	2026-05-01 00:13:41.941719	python-httpx/0.28.1	38.159.109.114	\N	\N	\N	\N	\N
0ebe0dd1-8f70-4133-9e0d-574fda495380	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	2026-05-01 01:51:33.163626+00	2026-05-01 01:51:33.163626+00	\N	aal1	\N	\N	python-httpx/0.28.1	38.159.109.114	\N	\N	\N	\N	\N
c9c8dbd5-0372-491a-b18f-42220cb45171	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	2026-05-01 02:04:47.965109+00	2026-05-01 02:04:47.965109+00	\N	aal1	\N	\N	python-httpx/0.28.1	38.159.109.114	\N	\N	\N	\N	\N
3bbb2871-98ce-4582-b8df-d3712db17346	c5e17e59-c4b4-47a7-b699-c8d9754f6f65	2026-05-01 02:51:31.309246+00	2026-05-01 02:51:31.309246+00	\N	aal1	\N	\N	python-httpx/0.28.1	38.159.109.114	\N	\N	\N	\N	\N
eea67a72-3d27-4bc9-b37f-b966ae12fe2a	c5e17e59-c4b4-47a7-b699-c8d9754f6f65	2026-05-01 04:27:20.375569+00	2026-05-01 04:27:20.375569+00	\N	aal1	\N	\N	python-httpx/0.28.1	38.159.109.114	\N	\N	\N	\N	\N
df21b184-602b-44ce-b165-b049c0e87609	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	2026-05-01 04:29:03.578745+00	2026-05-01 04:29:03.578745+00	\N	aal1	\N	\N	python-httpx/0.28.1	38.159.109.114	\N	\N	\N	\N	\N
77e49c65-278e-49fa-b63b-a62843c1cbb5	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	2026-05-01 04:38:16.128629+00	2026-05-01 04:38:16.128629+00	\N	aal1	\N	\N	python-httpx/0.28.1	38.159.109.114	\N	\N	\N	\N	\N
9e043f3c-9626-4c94-975a-d0aee23a9d25	22e32e2a-0a39-4d7d-baca-de0a29aaaac3	2026-05-01 04:57:49.387977+00	2026-05-01 04:57:49.387977+00	\N	aal1	\N	\N	python-httpx/0.28.1	38.159.109.114	\N	\N	\N	\N	\N
69a0d995-3aa9-4223-a30d-b97366cad171	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	2026-05-01 05:48:00.369345+00	2026-05-01 05:48:00.369345+00	\N	aal1	\N	\N	python-httpx/0.28.1	38.159.109.114	\N	\N	\N	\N	\N
314f8fc8-75b5-4de3-ba2e-a576647f79fa	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	2026-05-01 12:14:13.394297+00	2026-05-01 12:14:13.394297+00	\N	aal1	\N	\N	python-httpx/0.28.1	190.167.253.164	\N	\N	\N	\N	\N
b588f42a-ae17-4798-8103-06417b2ae105	22e32e2a-0a39-4d7d-baca-de0a29aaaac3	2026-05-01 14:53:20.39784+00	2026-05-01 14:53:20.39784+00	\N	aal1	\N	\N	python-httpx/0.28.1	149.2.82.62	\N	\N	\N	\N	\N
7b249466-60be-4a7f-b6ac-2553a7f97f85	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	2026-05-01 15:25:53.980738+00	2026-05-01 15:25:53.980738+00	\N	aal1	\N	\N	python-httpx/0.28.1	149.2.82.62	\N	\N	\N	\N	\N
dd977ca1-3c28-462b-974a-ed28337ef744	c5e17e59-c4b4-47a7-b699-c8d9754f6f65	2026-05-01 15:29:42.937673+00	2026-05-01 15:29:42.937673+00	\N	aal1	\N	\N	python-httpx/0.28.1	149.2.82.61	\N	\N	\N	\N	\N
dd6b79bd-356a-4b11-b1f6-321a973c5a24	c5e17e59-c4b4-47a7-b699-c8d9754f6f65	2026-05-01 15:49:28.6668+00	2026-05-01 15:49:28.6668+00	\N	aal1	\N	\N	python-httpx/0.28.1	149.2.82.61	\N	\N	\N	\N	\N
33a3f91d-5f63-48b6-a51f-289a99b0540a	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	2026-05-01 15:53:46.11914+00	2026-05-01 15:53:46.11914+00	\N	aal1	\N	\N	python-httpx/0.28.1	149.2.82.61	\N	\N	\N	\N	\N
b4e6c621-ece0-42b9-98db-c280181f7b18	22e32e2a-0a39-4d7d-baca-de0a29aaaac3	2026-05-01 16:02:24.125726+00	2026-05-01 16:02:24.125726+00	\N	aal1	\N	\N	python-httpx/0.28.1	149.2.82.62	\N	\N	\N	\N	\N
8761da2c-ba43-4ca0-ab92-59ffeef82bad	22e32e2a-0a39-4d7d-baca-de0a29aaaac3	2026-05-01 16:55:58.965125+00	2026-05-01 16:55:58.965125+00	\N	aal1	\N	\N	python-httpx/0.28.1	149.2.82.61	\N	\N	\N	\N	\N
390495b9-2289-486e-92f9-f6c40f6be253	65988fb9-ee24-402e-9f72-215888b19aa7	2026-05-05 13:56:25.130372+00	2026-05-05 13:56:25.130372+00	\N	aal1	\N	\N	python-httpx/0.28.1	149.2.82.62	\N	\N	\N	\N	\N
1362ecc5-0511-4636-9cb9-8b5142b1d880	22e32e2a-0a39-4d7d-baca-de0a29aaaac3	2026-05-05 18:27:42.899768+00	2026-05-05 18:27:42.899768+00	\N	aal1	\N	\N	python-httpx/0.28.1	190.80.246.157	\N	\N	\N	\N	\N
10362a88-46d7-4759-9616-a1f3c479b398	22e32e2a-0a39-4d7d-baca-de0a29aaaac3	2026-05-02 17:16:03.853827+00	2026-05-02 19:15:45.953865+00	\N	aal1	\N	2026-05-02 19:15:45.953773	python-httpx/0.28.1	38.159.109.114	\N	\N	\N	\N	\N
264b36e1-7d92-4dfd-9aaf-2631b9d8c287	22e32e2a-0a39-4d7d-baca-de0a29aaaac3	2026-05-02 19:56:46.484004+00	2026-05-02 19:56:46.484004+00	\N	aal1	\N	\N	python-httpx/0.28.1	38.159.109.114	\N	\N	\N	\N	\N
a43d66be-0f73-4beb-8327-9e082e29b58f	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	2026-05-04 20:35:00.016557+00	2026-05-04 20:35:00.016557+00	\N	aal1	\N	\N	python-httpx/0.28.1	38.159.109.114	\N	\N	\N	\N	\N
7923a88f-ab56-472a-9b1d-cdeba48946c8	c5e17e59-c4b4-47a7-b699-c8d9754f6f65	2026-05-04 20:45:01.917064+00	2026-05-04 20:45:01.917064+00	\N	aal1	\N	\N	python-httpx/0.28.1	38.159.109.114	\N	\N	\N	\N	\N
2eda2a32-e191-4bed-b167-827f258dfad2	22e32e2a-0a39-4d7d-baca-de0a29aaaac3	2026-05-04 20:49:01.452084+00	2026-05-04 20:49:01.452084+00	\N	aal1	\N	\N	python-httpx/0.28.1	38.159.109.114	\N	\N	\N	\N	\N
39999e8d-ac78-40ef-afb7-0ba57296ccbc	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	2026-05-04 21:27:59.642245+00	2026-05-04 21:27:59.642245+00	\N	aal1	\N	\N	python-httpx/0.28.1	38.159.109.114	\N	\N	\N	\N	\N
4ff47f8c-85a6-4904-aef7-d23d57801847	c5e17e59-c4b4-47a7-b699-c8d9754f6f65	2026-05-04 21:30:08.48853+00	2026-05-04 21:30:08.48853+00	\N	aal1	\N	\N	python-httpx/0.28.1	38.159.109.114	\N	\N	\N	\N	\N
e3d7097a-fb9d-4ba8-adcd-dc07d0406d7b	c5e17e59-c4b4-47a7-b699-c8d9754f6f65	2026-05-04 21:53:19.116757+00	2026-05-04 21:53:19.116757+00	\N	aal1	\N	\N	python-httpx/0.28.1	38.159.109.114	\N	\N	\N	\N	\N
7a2fb2a9-492a-4244-b5a6-f2d627099717	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	2026-05-04 23:48:34.054224+00	2026-05-04 23:48:34.054224+00	\N	aal1	\N	\N	python-httpx/0.28.1	38.159.109.114	\N	\N	\N	\N	\N
823b64ff-2a04-498a-b14c-506a53b234c3	22e32e2a-0a39-4d7d-baca-de0a29aaaac3	2026-05-05 00:01:54.766565+00	2026-05-05 00:01:54.766565+00	\N	aal1	\N	\N	python-httpx/0.28.1	38.159.109.114	\N	\N	\N	\N	\N
602390ce-472e-43e1-9506-efca15aec8d1	22e32e2a-0a39-4d7d-baca-de0a29aaaac3	2026-05-05 00:36:29.886497+00	2026-05-05 00:36:29.886497+00	\N	aal1	\N	\N	python-httpx/0.28.1	38.159.109.114	\N	\N	\N	\N	\N
83304e5d-12fe-457e-8899-0e3c8798602a	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	2026-05-05 00:37:32.746479+00	2026-05-05 00:37:32.746479+00	\N	aal1	\N	\N	python-httpx/0.28.1	38.159.109.114	\N	\N	\N	\N	\N
263c72d8-4e5f-44cc-882a-e4a717aec054	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	2026-05-05 00:38:37.810975+00	2026-05-05 00:38:37.810975+00	\N	aal1	\N	\N	python-httpx/0.28.1	38.159.109.114	\N	\N	\N	\N	\N
2c43642a-3915-4314-b9ce-429c87bc821a	65988fb9-ee24-402e-9f72-215888b19aa7	2026-05-05 00:39:03.664428+00	2026-05-05 00:39:03.664428+00	\N	aal1	\N	\N	python-httpx/0.28.1	38.159.109.114	\N	\N	\N	\N	\N
569311da-76cf-4671-837a-c965bdf2f265	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	2026-05-05 00:40:13.771651+00	2026-05-05 00:40:13.771651+00	\N	aal1	\N	\N	python-httpx/0.28.1	38.159.109.114	\N	\N	\N	\N	\N
906435ac-18e1-4255-93c0-415641487f0d	22e32e2a-0a39-4d7d-baca-de0a29aaaac3	2026-05-05 10:11:58.191608+00	2026-05-05 10:11:58.191608+00	\N	aal1	\N	\N	python-httpx/0.28.1	38.159.109.114	\N	\N	\N	\N	\N
bcb49636-4bd3-4192-abdb-a334e54a0658	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	2026-05-05 10:19:33.406172+00	2026-05-05 10:19:33.406172+00	\N	aal1	\N	\N	python-httpx/0.28.1	38.159.109.114	\N	\N	\N	\N	\N
e831f3e7-1683-48c0-b7c6-bc06fd66b75a	65988fb9-ee24-402e-9f72-215888b19aa7	2026-05-05 10:37:27.521627+00	2026-05-05 10:37:27.521627+00	\N	aal1	\N	\N	python-httpx/0.28.1	38.159.109.114	\N	\N	\N	\N	\N
858b306e-3bec-4b19-91b3-6161226bdad9	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	2026-05-05 10:42:47.097495+00	2026-05-05 10:42:47.097495+00	\N	aal1	\N	\N	python-httpx/0.28.1	38.159.109.114	\N	\N	\N	\N	\N
5d6efd21-990e-43dc-b3a5-27c9ca2788f0	65988fb9-ee24-402e-9f72-215888b19aa7	2026-05-05 10:48:38.420361+00	2026-05-05 10:48:38.420361+00	\N	aal1	\N	\N	python-httpx/0.28.1	38.159.109.114	\N	\N	\N	\N	\N
ac106d55-b28b-4b2a-bbab-3b61c54ab32e	65988fb9-ee24-402e-9f72-215888b19aa7	2026-05-05 11:53:15.843494+00	2026-05-05 11:53:15.843494+00	\N	aal1	\N	\N	python-httpx/0.28.1	149.2.82.62	\N	\N	\N	\N	\N
895c2eb2-91d3-4704-933c-966697cf422e	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	2026-05-07 04:20:09.201796+00	2026-05-07 04:20:09.201796+00	\N	aal1	\N	\N	python-httpx/0.28.1	38.159.109.114	\N	\N	\N	\N	\N
05c7791e-ddc2-4221-8ff7-f74b3e62d4a3	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	2026-05-05 12:03:44.943696+00	2026-05-05 13:18:49.61136+00	\N	aal1	\N	2026-05-05 13:18:49.61127	python-httpx/0.28.1	149.2.82.62	\N	\N	\N	\N	\N
2a3ac71e-6be6-49d9-86bc-42222614f11b	22e32e2a-0a39-4d7d-baca-de0a29aaaac3	2026-05-05 13:28:42.029503+00	2026-05-05 13:28:42.029503+00	\N	aal1	\N	\N	python-httpx/0.28.1	149.2.82.62	\N	\N	\N	\N	\N
3c330d96-a237-412e-9d34-d68f171b53fc	22e32e2a-0a39-4d7d-baca-de0a29aaaac3	2026-05-07 04:22:15.808412+00	2026-05-07 04:22:15.808412+00	\N	aal1	\N	\N	python-httpx/0.28.1	38.159.109.114	\N	\N	\N	\N	\N
336e8ae8-3399-4dd5-98e3-18fba894d75d	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	2026-05-07 04:27:06.368388+00	2026-05-07 04:27:06.368388+00	\N	aal1	\N	\N	python-httpx/0.28.1	38.159.109.114	\N	\N	\N	\N	\N
3300d270-ba7b-40dd-8149-6904cd070305	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	2026-05-05 18:34:09.503992+00	2026-05-06 22:30:03.94524+00	\N	aal1	\N	2026-05-06 22:30:03.945138	python-httpx/0.28.1	38.159.109.114	\N	\N	\N	\N	\N
6c33e142-21ac-4f0c-a3c9-f1e5b6ba7049	22e32e2a-0a39-4d7d-baca-de0a29aaaac3	2026-05-07 03:58:03.428421+00	2026-05-07 03:58:03.428421+00	\N	aal1	\N	\N	python-httpx/0.28.1	38.159.109.114	\N	\N	\N	\N	\N
35ebcaf3-0eaf-4160-ae09-da12ecf336f6	22e32e2a-0a39-4d7d-baca-de0a29aaaac3	2026-05-07 05:00:41.23642+00	2026-05-07 05:00:41.23642+00	\N	aal1	\N	\N	python-httpx/0.28.1	38.159.109.114	\N	\N	\N	\N	\N
4d0da295-f81a-43c9-bb7e-50cf39c1618e	65988fb9-ee24-402e-9f72-215888b19aa7	2026-05-07 05:00:59.208372+00	2026-05-07 05:00:59.208372+00	\N	aal1	\N	\N	python-httpx/0.28.1	38.159.109.114	\N	\N	\N	\N	\N
31e874cc-acfe-4043-a580-e59cf1044f93	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	2026-05-08 11:47:56.661069+00	2026-05-08 11:47:56.661069+00	\N	aal1	\N	\N	python-httpx/0.28.1	149.2.82.61	\N	\N	\N	\N	\N
270d0805-9dc5-4f39-a2b0-17db677fc536	22e32e2a-0a39-4d7d-baca-de0a29aaaac3	2026-05-08 11:48:06.000873+00	2026-05-08 11:48:06.000873+00	\N	aal1	\N	\N	python-httpx/0.28.1	149.2.82.61	\N	\N	\N	\N	\N
f0b1d822-8fc2-4319-ab0d-1cafdcd81d52	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	2026-05-08 12:19:13.245096+00	2026-05-08 12:19:13.245096+00	\N	aal1	\N	\N	python-httpx/0.28.1	149.2.82.61	\N	\N	\N	\N	\N
\.


--
-- Data for Name: sso_domains; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.sso_domains (id, sso_provider_id, domain, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: sso_providers; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.sso_providers (id, resource_id, created_at, updated_at, disabled) FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.users (instance_id, id, aud, role, email, encrypted_password, email_confirmed_at, invited_at, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) FROM stdin;
00000000-0000-0000-0000-000000000000	e91e88ce-b231-40e5-a093-68283662b146	authenticated	authenticated	newtest@example.com	$2a$10$4h/NcDCE/g9VYrdhxU7ltuOnBoxsoHuGJVaJ0acl4izqyFrqKtRFK	2026-03-05 17:00:50.551635+00	\N		\N		\N			\N	2026-03-10 01:53:10.279745+00	{"provider": "email", "providers": ["email"]}	{"rol": "docente", "sub": "e91e88ce-b231-40e5-a093-68283662b146", "email": "newtest@example.com", "nombre": "New Test User", "email_verified": true, "phone_verified": false}	\N	2026-03-05 17:00:50.535934+00	2026-03-10 01:53:10.314346+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	41d0dce6-bd67-4a08-9d1f-696359e90e51	authenticated	authenticated	gabriel.alcala@edu.com	$2a$10$UJq40oUb0dUF8u58ksGO0u6XbxjPrcLi92CnV934thXxrbegyXdKK	2026-04-26 00:51:21.529535+00	\N		\N		\N			\N	2026-04-27 03:14:21.766081+00	{"provider": "email", "providers": ["email"]}	{"sub": "41d0dce6-bd67-4a08-9d1f-696359e90e51", "name": "Gabriel Elias Alcala Aquino", "email": "gabriel.alcala@edu.com", "email_verified": true, "phone_verified": false}	\N	2026-04-26 00:51:21.452069+00	2026-04-27 03:14:21.794127+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	ad86439a-31de-4eed-a303-5d2fed9fec39	authenticated	authenticated	testsupabase@gmail.com	$2a$10$2s2tETyCuQkIsmUWWJcJkOiBPfg3/g0qEYMEefDlbkJa9TF.DDY7u	\N	\N	bb3ef61dbaef2e5015e5552a80fd1bae2724517e7ed4ebeef160cb1b	2026-03-05 16:52:29.867845+00		\N			\N	\N	{"provider": "email", "providers": ["email"]}	{"rol": "docente", "sub": "ad86439a-31de-4eed-a303-5d2fed9fec39", "email": "testsupabase@gmail.com", "nombre": " Test Supabase User", "email_verified": false, "phone_verified": false}	\N	2026-03-05 16:52:29.863089+00	2026-03-05 16:52:30.850332+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	e553ff72-4848-4488-840b-29f8b19a9846	authenticated	authenticated	katherine.cuesta@edu.com	$2a$10$NNJ9Iwx78cQPZtGqY0VK2.KXsB.CKQKdT7lC7rNYf2/TVzXf9jYFO	2026-04-26 00:51:22.343352+00	\N		\N		\N			\N	2026-04-26 00:51:22.345846+00	{"provider": "email", "providers": ["email"]}	{"sub": "e553ff72-4848-4488-840b-29f8b19a9846", "name": "Katherine Marie Cuesta Marte", "email": "katherine.cuesta@edu.com", "email_verified": true, "phone_verified": false}	\N	2026-04-26 00:51:22.330653+00	2026-04-26 00:51:22.347963+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	bec157c7-cd63-4535-a8b7-7983ea223b7a	authenticated	authenticated	ramirezmichael@gmail.com	$2a$10$CkUPcec8XkMG6gUmYWdfDeXwEr/Id/AvQToDTtZa27TV00LtUTQ4y	2026-03-16 13:27:09.111272+00	\N		\N		\N			\N	2026-03-16 13:27:41.939331+00	{"provider": "email", "providers": ["email"]}	{"sub": "bec157c7-cd63-4535-a8b7-7983ea223b7a", "email": "ramirezmichael@gmail.com", "nombre": "Michael Ramírez Feliz", "email_verified": true, "phone_verified": false}	\N	2026-03-16 13:27:09.074722+00	2026-03-16 13:27:41.943153+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	c5bbbc6d-abd6-477b-8998-400c04face6c	authenticated	authenticated	pamelareding@gmail.com	$2a$10$i5jTiE9ASkqnAgLkP8ql8.tw56x2dJ3yAaAAsQz1OEsFpDnWNWyje	2026-03-05 17:24:06.994698+00	\N		\N		\N			\N	2026-03-09 03:58:27.429814+00	{"provider": "email", "providers": ["email"]}	{"rol": "estudiante", "sub": "c5bbbc6d-abd6-477b-8998-400c04face6c", "email": "pamelareding@gmail.com", "nombre": "Ashley Pamela Reding ", "email_verified": true, "phone_verified": false}	\N	2026-03-05 17:24:06.961621+00	2026-03-09 03:58:27.473948+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	8a58df87-1912-4c39-a0c8-dc195db490f3	authenticated	authenticated	carlos2@gmail.com	$2a$10$LmbO2nrxiUY0oXifaemda.1cRRxSlR3esZcpm8wWVWYRL6dLCfN.q	2026-03-10 02:40:10.719016+00	\N		\N		\N			\N	2026-03-16 13:17:07.330322+00	{"provider": "email", "providers": ["email"]}	{"rol": "docente", "sub": "8a58df87-1912-4c39-a0c8-dc195db490f3", "email": "carlos2@gmail.com", "nombre": "Carlos Miguel Lima Camacho 2", "email_verified": true, "phone_verified": false}	\N	2026-03-10 02:40:10.679559+00	2026-03-16 13:17:07.397407+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	6ee06e13-8b9d-4b7d-bb8c-f5e1392a2345	authenticated	authenticated	elyin.diaz@edu.com	$2a$10$65lyf3oOpHbPh6qp8YKjKepgLw/2DR8Ble0Rs8Ljs5QHKkoBD6St6	2026-04-26 00:51:22.572732+00	\N		\N		\N			\N	2026-04-26 00:51:22.575407+00	{"provider": "email", "providers": ["email"]}	{"sub": "6ee06e13-8b9d-4b7d-bb8c-f5e1392a2345", "name": "Elyin Emmanuel Diaz Adamez", "email": "elyin.diaz@edu.com", "email_verified": true, "phone_verified": false}	\N	2026-04-26 00:51:22.565707+00	2026-04-26 00:51:22.578839+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	22e32e2a-0a39-4d7d-baca-de0a29aaaac3	authenticated	authenticated	carloscamacho9700@gmail.com	$2a$10$/pxroGMCPPPYLpmKEBmVHe3EbVtYLOuqF1X5ZGBI8aDE6zySAv.ki	2026-03-17 16:20:10.158944+00	\N		\N		\N			\N	2026-05-08 11:48:06.000782+00	{"provider": "email", "providers": ["email"]}	{"email_verified": true}	\N	2026-03-17 16:20:10.128576+00	2026-05-08 11:48:06.004493+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	2567a845-ec31-4484-bb26-77a357087983	authenticated	authenticated	deuli.cruz@edu.com	$2a$10$yBZHxU49OSXEoW164HSgc.YobQ0CO5fy09j1lIQzvotFldUe4BKnW	2026-04-26 00:51:22.108025+00	\N		\N		\N			\N	2026-04-26 00:51:22.110209+00	{"provider": "email", "providers": ["email"]}	{"sub": "2567a845-ec31-4484-bb26-77a357087983", "name": "Deuli de la Cruz Ramirez", "email": "deuli.cruz@edu.com", "email_verified": true, "phone_verified": false}	\N	2026-04-26 00:51:22.101743+00	2026-04-26 00:51:22.11197+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	c5e17e59-c4b4-47a7-b699-c8d9754f6f65	authenticated	authenticated	winniviel.bello@edu.com	$2a$10$qLn/zUMaHT2fCPSFKIfzwer.bSXl/pSK9kCIX/qyqK7qPEuTrXaz2	2026-04-26 00:51:21.879921+00	\N		\N		\N			\N	2026-05-04 21:53:19.114799+00	{"provider": "email", "providers": ["email"]}	{"sub": "c5e17e59-c4b4-47a7-b699-c8d9754f6f65", "name": "Winniviel Bello", "email": "winniviel.bello@edu.com", "email_verified": true, "phone_verified": false}	\N	2026-04-26 00:51:21.868878+00	2026-05-04 21:53:19.176505+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	authenticated	authenticated	joserijo@gmail.com	$2a$10$HAqzDhkRKC9DttxXuYxr7.oVGSPcVyta4C7f6AeEVEvSAAoNEIQpK	2026-03-17 16:23:42.530289+00	\N		\N		\N			\N	2026-05-08 12:19:13.24399+00	{"provider": "email", "providers": ["email"]}	{"email_verified": true}	\N	2026-03-17 16:23:42.506612+00	2026-05-08 12:19:13.308978+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	15330155-3ad3-4e5d-a70d-e02557a5ba8d	authenticated	authenticated	juan.felix@edu.com	$2a$10$kCXGXsWkp5G8toj.OjbwmeGmrn1yR.2lvBDJmxPbBMYz97Ui7WRV2	2026-04-26 00:51:22.797225+00	\N		\N		\N			\N	2026-04-26 00:51:22.799707+00	{"provider": "email", "providers": ["email"]}	{"sub": "15330155-3ad3-4e5d-a70d-e02557a5ba8d", "name": "Juan Armando Felix Norberto", "email": "juan.felix@edu.com", "email_verified": true, "phone_verified": false}	\N	2026-04-26 00:51:22.791313+00	2026-04-26 00:51:22.801593+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	e7c839f3-cee4-4c59-b054-1e35731ef6b4	authenticated	authenticated	angelo.mancebo@edu.com	$2a$10$K0ZjMjqWukhgP8SJrKx6wuIWwxRX/c0wCPA5EJ2EigXpAUYLI6tgq	2026-04-26 00:51:24.161502+00	\N		\N		\N			\N	2026-04-26 00:51:24.163546+00	{"provider": "email", "providers": ["email"]}	{"sub": "e7c839f3-cee4-4c59-b054-1e35731ef6b4", "name": "Angelo Alexander Mancebo", "email": "angelo.mancebo@edu.com", "email_verified": true, "phone_verified": false}	\N	2026-04-26 00:51:24.157682+00	2026-04-26 00:51:24.165226+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	82deb24f-e7f8-46c9-9117-ee272f1671fa	authenticated	authenticated	justin.ezequiel@edu.com	$2a$10$00R6XzAsJgMxukZFk08Aw.618tspC33vVVyUlXTaOD3YIo9q4YJBa	2026-04-26 00:51:23.028234+00	\N		\N		\N			\N	2026-04-26 00:51:23.030527+00	{"provider": "email", "providers": ["email"]}	{"sub": "82deb24f-e7f8-46c9-9117-ee272f1671fa", "name": "Justin Ezequiel", "email": "justin.ezequiel@edu.com", "email_verified": true, "phone_verified": false}	\N	2026-04-26 00:51:23.022286+00	2026-04-26 00:51:23.032696+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	6cc3ddc0-6296-48e1-9da4-3e35562534bd	authenticated	authenticated	michael.ramirez@edu.com	$2a$10$xsr2WTsrQYatuwlK3B3fKOb7ZLGlMUDNe8ojVli3vKW0mDGEnB7k.	2026-04-26 00:51:25.240708+00	\N		\N		\N			\N	2026-04-26 00:51:25.242815+00	{"provider": "email", "providers": ["email"]}	{"sub": "6cc3ddc0-6296-48e1-9da4-3e35562534bd", "name": "Michael Ramirez Feliz", "email": "michael.ramirez@edu.com", "email_verified": true, "phone_verified": false}	\N	2026-04-26 00:51:25.236544+00	2026-04-26 00:51:25.24462+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	078c7814-4883-4bdb-9130-353518f12d4d	authenticated	authenticated	jose.pichardo@edu.com	$2a$10$fHvPmaa7fy9/klUodjGLseWu/mnsE/LcETYLASmMALd9GQSmkOB96	2026-04-26 00:51:24.590697+00	\N		\N		\N			\N	2026-04-26 00:51:24.592717+00	{"provider": "email", "providers": ["email"]}	{"sub": "078c7814-4883-4bdb-9130-353518f12d4d", "name": "Jose Emmanuel Pichardo", "email": "jose.pichardo@edu.com", "email_verified": true, "phone_verified": false}	\N	2026-04-26 00:51:24.586803+00	2026-04-26 00:51:24.594351+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	d4a5067d-f305-4344-80ec-ecec9777e6bc	authenticated	authenticated	nashly.magallanes@edu.com	$2a$10$us7jWYIGmh7PvpSorTTuIuWL9zoZ52Yr0mje1ZtGaNb9/9FLI9IFO	2026-04-26 00:51:23.94434+00	\N		\N		\N			\N	2026-04-26 00:51:23.946457+00	{"provider": "email", "providers": ["email"]}	{"sub": "d4a5067d-f305-4344-80ec-ecec9777e6bc", "name": "Nashly Adriana Magallanes Feliz", "email": "nashly.magallanes@edu.com", "email_verified": true, "phone_verified": false}	\N	2026-04-26 00:51:23.940289+00	2026-04-26 00:51:23.948+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	c3e075ab-d4ef-4047-9e59-9a42c99e0ec6	authenticated	authenticated	enrique.ogando@edu.com	$2a$10$VyakOjM1eQtearaIiknNju8fpvv9/zEJ3HnEzaZtvorJzv679.Sfi	2026-04-26 00:51:24.375733+00	\N		\N		\N			\N	2026-04-26 00:51:24.379647+00	{"provider": "email", "providers": ["email"]}	{"sub": "c3e075ab-d4ef-4047-9e59-9a42c99e0ec6", "name": "Enrique Ogando", "email": "enrique.ogando@edu.com", "email_verified": true, "phone_verified": false}	\N	2026-04-26 00:51:24.371123+00	2026-04-26 00:51:24.381387+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	ed797688-4ace-4eaf-80cd-8697ebaba1dc	authenticated	authenticated	maikel.yael@edu.com	$2a$10$YdgTb4ONdifCOZ6UYoL6eOrhlt26YMyqVAzU6PyJ5Ip8KTk1y75l6	2026-04-26 00:51:23.271874+00	\N		\N		\N			\N	2026-04-26 00:51:23.273843+00	{"provider": "email", "providers": ["email"]}	{"sub": "ed797688-4ace-4eaf-80cd-8697ebaba1dc", "name": "Maikel Yael", "email": "maikel.yael@edu.com", "email_verified": true, "phone_verified": false}	\N	2026-04-26 00:51:23.267829+00	2026-04-26 00:51:23.275739+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	61050d2a-a59a-4306-a126-5ec1ceed6549	authenticated	authenticated	yeuri.lorenzo@edu.com	$2a$10$c7V5qUwRksfG7l5nTNS9xuDwvFgKyzsU2MNnk7YePdGXo72BOqg46	2026-04-26 00:51:23.715331+00	\N		\N		\N			\N	2026-04-26 00:51:23.719756+00	{"provider": "email", "providers": ["email"]}	{"sub": "61050d2a-a59a-4306-a126-5ec1ceed6549", "name": "Yeuri Lorenzo Diaz", "email": "yeuri.lorenzo@edu.com", "email_verified": true, "phone_verified": false}	\N	2026-04-26 00:51:23.709113+00	2026-04-26 00:51:23.722492+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	65988fb9-ee24-402e-9f72-215888b19aa7	authenticated	authenticated	carlos.lima@edu.com	$2a$10$Zk1QpuA.NHGqL3Wu3YaqnO78zvO2vVmvV26fRuQwgbKv3T3M11OIS	2026-04-26 00:51:23.493296+00	\N		\N		\N			\N	2026-05-07 05:00:59.208278+00	{"provider": "email", "providers": ["email"]}	{"sub": "65988fb9-ee24-402e-9f72-215888b19aa7", "name": "Carlos Miguel Lima Camacho", "email": "carlos.lima@edu.com", "email_verified": true, "phone_verified": false}	\N	2026-04-26 00:51:23.487792+00	2026-05-07 05:00:59.210604+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	0890ea95-f0dd-48c1-94d7-d96da6d9e876	authenticated	authenticated	ernesto.pichardo@edu.com	$2a$10$050bDhmxecJJPElR0ScjiOahBPJYPIQc.i/M10f/eiJjVkYwEZGT6	2026-04-26 00:51:24.80343+00	\N		\N		\N			\N	2026-04-26 00:51:24.805394+00	{"provider": "email", "providers": ["email"]}	{"sub": "0890ea95-f0dd-48c1-94d7-d96da6d9e876", "name": "Ernesto Luis Pichardo", "email": "ernesto.pichardo@edu.com", "email_verified": true, "phone_verified": false}	\N	2026-04-26 00:51:24.799631+00	2026-04-26 00:51:24.807546+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	ef7e8249-6c63-48e6-b3d2-dfc34f44ade7	authenticated	authenticated	dustin.polanco@edu.com	$2a$10$RUWLDml/0JNFF/PyQ7MGNueSsd3HeoS6UZjXREUOFZwAOlJ2EwjxC	2026-04-26 00:51:25.025213+00	\N		\N		\N			\N	2026-04-26 00:51:25.027208+00	{"provider": "email", "providers": ["email"]}	{"sub": "ef7e8249-6c63-48e6-b3d2-dfc34f44ade7", "name": "Dustin Alexander Polanco Muños", "email": "dustin.polanco@edu.com", "email_verified": true, "phone_verified": false}	\N	2026-04-26 00:51:25.020701+00	2026-04-26 00:51:25.028887+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	0bcc0ef3-9a18-497d-9a2e-59ea53abfd82	authenticated	authenticated	eliezer.jesus@edu.com	$2a$10$uV6jVRvZeM862HiY7jWQNuOVQXXW/kHftv4KSwQf/gdV3PMii9MhW	2026-04-26 00:51:25.466971+00	\N		\N		\N			\N	2026-04-26 00:51:25.470394+00	{"provider": "email", "providers": ["email"]}	{"sub": "0bcc0ef3-9a18-497d-9a2e-59ea53abfd82", "name": "Eliezer de Jesus", "email": "eliezer.jesus@edu.com", "email_verified": true, "phone_verified": false}	\N	2026-04-26 00:51:25.461954+00	2026-04-26 00:51:25.473027+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	f9c231e0-8859-4d97-bf6d-3fdd11fe7234	authenticated	authenticated	gianni.subervi@edu.com	$2a$10$6MgLMJpTE1BqTc602air2Om4IPZ963EvGEHl2uuJ/Vd1IzvgIptZy	2026-04-26 00:51:26.144394+00	\N		\N		\N			\N	2026-04-26 00:51:26.146452+00	{"provider": "email", "providers": ["email"]}	{"sub": "f9c231e0-8859-4d97-bf6d-3fdd11fe7234", "name": "Gianni Subervi Alcantara", "email": "gianni.subervi@edu.com", "email_verified": true, "phone_verified": false}	\N	2026-04-26 00:51:26.139231+00	2026-04-26 00:51:26.148205+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	9c90759f-19b4-4d84-91e8-6bae7d6205d5	authenticated	authenticated	jeremy.manuel@edu.com	$2a$10$eBIfASKFa9CMe690eFChKuxQkbAXdww2JTm/6zxapgNBfUTQr8uWG	2026-04-26 00:51:25.680856+00	\N		\N		\N			\N	2026-04-26 00:51:25.683772+00	{"provider": "email", "providers": ["email"]}	{"sub": "9c90759f-19b4-4d84-91e8-6bae7d6205d5", "name": "Jeremy Manuel", "email": "jeremy.manuel@edu.com", "email_verified": true, "phone_verified": false}	\N	2026-04-26 00:51:25.676848+00	2026-04-26 00:51:25.685417+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	8b11710a-a694-4a66-af3c-c022b28b25e7	authenticated	authenticated	ashly.reding@edu.com	$2a$10$RXwxjnWmiY7eC43rjikZkOgsr7dFudgzcAWACi/89NzgcYQL2f93a	2026-04-26 00:51:25.922907+00	\N		\N		\N			\N	2026-04-26 00:51:25.925023+00	{"provider": "email", "providers": ["email"]}	{"sub": "8b11710a-a694-4a66-af3c-c022b28b25e7", "name": "Ashly Pamela Reding Hernandez", "email": "ashly.reding@edu.com", "email_verified": true, "phone_verified": false}	\N	2026-04-26 00:51:25.918652+00	2026-04-26 00:51:25.926761+00	\N	\N			\N		0	\N		\N	f	\N	f
\.


--
-- Data for Name: webauthn_challenges; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.webauthn_challenges (id, user_id, challenge_type, session_data, created_at, expires_at) FROM stdin;
\.


--
-- Data for Name: webauthn_credentials; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.webauthn_credentials (id, user_id, credential_id, public_key, attestation_type, aaguid, sign_count, transports, backup_eligible, backed_up, friendly_name, created_at, updated_at, last_used_at) FROM stdin;
\.


--
-- Data for Name: activities; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.activities (id, learning_outcome_id, title, description, docente_id, start_date, close_date, type, max_score, status, created_at, updated_at) FROM stdin;
15597c90-8d1a-4618-ab03-0a707332423c	\N	Análisis de Caso	Analiza el caso presentado en clase	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	2026-04-29 00:00:00	2026-05-10 00:00:00	assignment	100.00	active	2026-04-29 13:01:21.287955	2026-04-29 13:01:21.287955
b3f599c7-824b-48ae-bc99-f75a970991d1	\N	Presentación Grupal	Presenta tu proyecto al grupo	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	2026-04-29 00:00:00	2026-05-15 00:00:00	project	100.00	active	2026-04-29 13:01:21.287955	2026-04-29 13:01:21.287955
cc1c4e5e-58ab-4884-a415-7abbc22951a9	\N	Quiz Online	Contesta el quiz sobre el tema	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	2026-04-29 00:00:00	2026-05-05 00:00:00	quiz	50.00	active	2026-04-29 13:01:21.287955	2026-04-29 13:01:21.287955
f2e8192d-af8c-44ca-b0ca-49171c7bfa30	\N	Test Actividad	asdfhjgiug	\N	2026-04-30 00:00:00	2026-04-29 00:00:00	tarea	100.00	active	2026-04-30 00:51:32.795878	2026-04-30 00:51:32.795878
4a1125d1-42a8-40d1-9297-ec1704b4af59	\N	Proyecto Final	Entrega	\N	2026-05-01 00:00:00	2026-05-01 00:00:00	tarea	100.00	active	2026-05-01 12:22:58.166671	2026-05-01 12:22:58.166671
7acb4a70-9d69-47e7-83aa-4b721f440101	7acb4a70-9d69-47e7-83aa-4b721f420101	Practica de algoritmos con ciclos	Resolver ejercicios aplicando ciclos y condicionales. Incluye pseudocodigo y prueba de escritorio.	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	2026-05-01 00:00:00	2026-05-08 00:00:00	assignment	100.00	active	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999
7acb4a70-9d69-47e7-83aa-4b721f440103	7acb4a70-9d69-47e7-83aa-4b721f420103	Diagrama entidad relacion	Modelar una base de datos para gestion academica.	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	2026-05-10 00:00:00	2026-05-17 00:00:00	task	100.00	active	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999
661d56a6-b36b-4308-af40-ccebc9056269	156c1508-353e-47c7-87fc-1c54d2a01a98	Actividad: informe de comunicación	Actividad demo para evaluar Actividad: informe de comunicación.	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	\N	\N	tarea	100.00	active	2026-05-05 10:57:08.441669	2026-05-05 10:57:08.441669
697d82f2-cd7a-4705-a72e-bb52d771565b	7cc10cd1-a5e9-4dfd-962d-7a2dd5b7fc51	Actividad: caso práctico	Actividad demo para evaluar Actividad: caso práctico.	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	\N	\N	tarea	100.00	active	2026-05-05 11:00:48.129984	2026-05-05 11:00:48.129984
587d122a-087d-4b18-aa19-f4527ea1cc89	55a7b7d9-4b11-42e2-93a2-4a3758c287d3	Actividad: proyecto en equipo	Actividad demo para evaluar Actividad: proyecto en equipo.	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	\N	\N	tarea	100.00	active	2026-05-05 11:00:53.442501	2026-05-05 11:00:53.442501
42c2c0ff-62bf-4e85-94e5-bac9b5bb0db3	7cc10cd1-a5e9-4dfd-962d-7a2dd5b7fc51	Proyecto	Entrega de proyecto	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	2026-05-07 00:00:00	2026-05-22 00:00:00	tarea	100.00	active	2026-05-07 04:37:25.601048	2026-05-07 04:37:25.601048
\.


--
-- Data for Name: alertas_bajo_desempenio; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.alertas_bajo_desempenio (id, estudiante_id, competencia_id, docente_id, tipo_alerta, porcentaje_logro, nivel_riesgo, leida, fecha_creacion, fecha_resolucion) FROM stdin;
\.


--
-- Data for Name: asistencias; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.asistencias (id, docente_id, estudiante_id, curso_id, fecha, estado, observacion, created_at, updated_at) FROM stdin;
9e2b0ef4-3e0b-400b-b47f-9c329d44f394	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	5255b0d0-ac71-40a0-84e6-8e5af4cd03dd	7ab7dd0e-b224-4b3a-81ca-34d47dd61f45	2026-05-01	presente		2026-05-01 06:38:48.220834	2026-05-01 15:49:18.915999
446d1123-a951-4bcf-afdd-94ee8c39e50c	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	b4310a5f-014b-40be-b5e5-ff8f0f186ac3	7ab7dd0e-b224-4b3a-81ca-34d47dd61f45	2026-05-01	presente		2026-05-01 06:38:48.522484	2026-05-01 15:49:18.915999
6de3b6a3-1539-4b1f-8586-c7e04d64ab23	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	44be7b74-1260-46dd-8dfb-d00bebb8bfe7	7ab7dd0e-b224-4b3a-81ca-34d47dd61f45	2026-05-01	presente		2026-05-01 06:38:48.80797	2026-05-01 15:49:18.915999
08a715ac-655e-4c98-b93a-6225a677bcee	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	b0c039cb-87d6-48f8-8da1-b3fb51a841d9	7ab7dd0e-b224-4b3a-81ca-34d47dd61f45	2026-05-01	presente		2026-05-01 06:38:49.143618	2026-05-01 15:49:18.915999
23765260-3e7a-46d0-a97c-93218604d781	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	880f1b10-6a6d-4144-bbb5-17281b801f59	7ab7dd0e-b224-4b3a-81ca-34d47dd61f45	2026-05-01	tardanza	Llegada tarde demo.	2026-05-01 06:38:49.421402	2026-05-01 15:49:18.915999
86035a2c-2a7f-4325-ade5-8cd8f1ff92bd	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	7332bffc-f65e-4b47-a800-5f5871dd1ff1	7ab7dd0e-b224-4b3a-81ca-34d47dd61f45	2026-05-01	presente		2026-05-01 06:38:49.692988	2026-05-01 15:49:18.915999
2b647690-d79e-46f2-9099-0cb42aacd60b	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	d28c16f6-36f6-41c4-9f1b-9dc98d435a62	7ab7dd0e-b224-4b3a-81ca-34d47dd61f45	2026-05-01	ausente	Ausencia demo.	2026-05-01 06:38:49.961336	2026-05-01 15:49:18.915999
d845686a-53f1-475d-a23f-710e0e165e0f	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	9a3edf62-5da6-4102-88d9-b9702f2c451e	7ab7dd0e-b224-4b3a-81ca-34d47dd61f45	2026-05-01	presente		2026-05-01 06:38:50.210755	2026-05-01 15:49:18.915999
739d71f6-c13a-4aa6-8e08-90978c57e820	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	3b65f5af-5a4d-4d74-bd1f-2a3025412f06	7ab7dd0e-b224-4b3a-81ca-34d47dd61f45	2026-05-01	presente		2026-05-01 06:38:50.455172	2026-05-01 15:49:18.915999
fbb84b7e-c802-4354-a5a8-3a3f9d7137f4	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	cb45271c-dd6c-4cf9-a063-21a5b540bc32	7ab7dd0e-b224-4b3a-81ca-34d47dd61f45	2026-05-01	tardanza	Llegada tarde demo.	2026-05-01 06:38:50.703229	2026-05-01 15:49:18.915999
3814a557-9f62-45fd-ae7f-1dd588570520	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	2088677b-a9ed-41c2-b7cf-6b1c0f67340a	7ab7dd0e-b224-4b3a-81ca-34d47dd61f45	2026-05-01	presente		2026-05-01 06:38:50.948517	2026-05-01 15:49:18.915999
6bdfd43f-d0f2-4277-8963-c933a9116d67	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	e8bac2f2-ae10-4de3-beea-824bd74aad7f	7ab7dd0e-b224-4b3a-81ca-34d47dd61f45	2026-05-01	presente		2026-05-01 06:38:51.196562	2026-05-01 15:49:18.915999
df6232ac-e9e4-4a3b-a156-ed056e4213b0	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	76542e5b-958f-4a97-9a56-b2eb23fe5d50	7ab7dd0e-b224-4b3a-81ca-34d47dd61f45	2026-05-01	presente		2026-05-01 06:38:51.442846	2026-05-01 15:49:18.915999
0eb6e38d-41bd-4896-b132-d8f970f95b9e	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	cd1c0e10-48e1-4123-9c0b-6dfa69751676	7ab7dd0e-b224-4b3a-81ca-34d47dd61f45	2026-05-01	ausente	Ausencia demo.	2026-05-01 06:38:51.685353	2026-05-01 15:49:18.915999
fa3f740f-ba4b-49ec-98ee-4474521481fd	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	b338bdf1-8943-4b46-83b1-8fc5315c456e	7ab7dd0e-b224-4b3a-81ca-34d47dd61f45	2026-05-01	tardanza	Llegada tarde demo.	2026-05-01 06:38:51.932498	2026-05-01 15:49:18.915999
012a4ffb-a6d7-48cc-97b4-8bd80b198eef	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	6ae5e88e-52df-4b57-836e-a88795849517	7ab7dd0e-b224-4b3a-81ca-34d47dd61f45	2026-05-01	presente		2026-05-01 06:38:52.18279	2026-05-01 15:49:18.915999
86e2bbb1-d46f-40d9-925b-730ede9bb572	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	62515288-7ece-48cc-af13-bf8359872434	7ab7dd0e-b224-4b3a-81ca-34d47dd61f45	2026-05-01	presente		2026-05-01 06:38:52.428608	2026-05-01 15:49:18.915999
eb2b7b3f-280d-4b60-87ba-fd5a57f022ae	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	e67826a2-3c40-4e3a-b6b6-046968b1ecdd	7ab7dd0e-b224-4b3a-81ca-34d47dd61f45	2026-05-01	presente		2026-05-01 06:38:52.671202	2026-05-01 15:49:18.915999
b97cfcf1-8559-4038-be66-50d464e1ead4	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	6941db3c-5b29-4671-bfb9-320c75ff89c4	7ab7dd0e-b224-4b3a-81ca-34d47dd61f45	2026-05-01	presente		2026-05-01 06:38:52.916303	2026-05-01 15:49:18.915999
2da44a0d-3b23-4fd6-8f0f-2299af370387	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	07349913-b823-49e2-b3db-0b91dee5be95	7ab7dd0e-b224-4b3a-81ca-34d47dd61f45	2026-05-01	tardanza	Llegada tarde demo.	2026-05-01 06:38:53.158378	2026-05-01 15:49:18.915999
c7e41e30-fbcb-410b-92f2-9c5939800b8d	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	1f3ead0e-eaf7-4da9-a638-443c1be2aebf	7ab7dd0e-b224-4b3a-81ca-34d47dd61f45	2026-05-01	ausente	Ausencia demo.	2026-05-01 06:38:53.404532	2026-05-01 15:49:18.915999
c6ea1aa8-810e-41ed-94ee-6eab93dba16a	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	5255b0d0-ac71-40a0-84e6-8e5af4cd03dd	7ab7dd0e-b224-4b3a-81ca-34d47dd61f45	2026-05-04	presente		2026-05-04 20:37:52.372318	2026-05-04 20:37:52.372318
b725feab-8ede-4ef9-8db9-b341488ca6d6	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	b4310a5f-014b-40be-b5e5-ff8f0f186ac3	7ab7dd0e-b224-4b3a-81ca-34d47dd61f45	2026-05-04	presente		2026-05-04 20:37:52.633186	2026-05-04 20:37:52.633186
f88dcdde-40e5-4a92-aad3-b26667c5dd6d	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	44be7b74-1260-46dd-8dfb-d00bebb8bfe7	7ab7dd0e-b224-4b3a-81ca-34d47dd61f45	2026-05-04	presente		2026-05-04 20:37:52.878441	2026-05-04 20:37:52.878441
e3132027-4c5f-43a3-a137-fd712a805888	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	b0c039cb-87d6-48f8-8da1-b3fb51a841d9	7ab7dd0e-b224-4b3a-81ca-34d47dd61f45	2026-05-04	presente		2026-05-04 20:37:53.126887	2026-05-04 20:37:53.126887
06be575a-afbe-4240-9c53-101cb3360911	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	880f1b10-6a6d-4144-bbb5-17281b801f59	7ab7dd0e-b224-4b3a-81ca-34d47dd61f45	2026-05-04	presente		2026-05-04 20:37:53.375059	2026-05-04 20:37:53.375059
448c1c4c-9ba6-45e1-a6db-bf795a57df40	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	7332bffc-f65e-4b47-a800-5f5871dd1ff1	7ab7dd0e-b224-4b3a-81ca-34d47dd61f45	2026-05-04	presente		2026-05-04 20:37:53.617592	2026-05-04 20:37:53.617592
de1c4704-6d55-4d83-a023-dfad461655b2	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	d28c16f6-36f6-41c4-9f1b-9dc98d435a62	7ab7dd0e-b224-4b3a-81ca-34d47dd61f45	2026-05-04	presente		2026-05-04 20:37:53.860792	2026-05-04 20:37:53.860792
554114f2-f394-47a1-94c7-d48b69fbd4fe	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	9a3edf62-5da6-4102-88d9-b9702f2c451e	7ab7dd0e-b224-4b3a-81ca-34d47dd61f45	2026-05-04	presente		2026-05-04 20:37:54.102581	2026-05-04 20:37:54.102581
42042147-8f9d-4764-a135-6dab64530bfb	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	3b65f5af-5a4d-4d74-bd1f-2a3025412f06	7ab7dd0e-b224-4b3a-81ca-34d47dd61f45	2026-05-04	presente		2026-05-04 20:37:54.350698	2026-05-04 20:37:54.350698
93f8e622-a2cb-42e8-b073-e8e62f494b31	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	cb45271c-dd6c-4cf9-a063-21a5b540bc32	7ab7dd0e-b224-4b3a-81ca-34d47dd61f45	2026-05-04	presente		2026-05-04 20:37:54.595396	2026-05-04 20:37:54.595396
541a07e7-9968-4c3d-96f0-07da97799cdb	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	2088677b-a9ed-41c2-b7cf-6b1c0f67340a	7ab7dd0e-b224-4b3a-81ca-34d47dd61f45	2026-05-04	presente		2026-05-04 20:37:54.836371	2026-05-04 20:37:54.836371
9068da83-3d6e-476e-92db-d0549991f481	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	e8bac2f2-ae10-4de3-beea-824bd74aad7f	7ab7dd0e-b224-4b3a-81ca-34d47dd61f45	2026-05-04	presente		2026-05-04 20:37:55.07803	2026-05-04 20:37:55.07803
f8698d34-557a-4f08-a8f4-430644ecf580	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	76542e5b-958f-4a97-9a56-b2eb23fe5d50	7ab7dd0e-b224-4b3a-81ca-34d47dd61f45	2026-05-04	presente		2026-05-04 20:37:55.323898	2026-05-04 20:37:55.323898
68c7b1b5-1c87-47f3-a2cf-a217d472ac74	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	cd1c0e10-48e1-4123-9c0b-6dfa69751676	7ab7dd0e-b224-4b3a-81ca-34d47dd61f45	2026-05-04	presente		2026-05-04 20:37:55.568396	2026-05-04 20:37:55.568396
e69bc230-5137-44ab-83b3-7604e0a711e2	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	b338bdf1-8943-4b46-83b1-8fc5315c456e	7ab7dd0e-b224-4b3a-81ca-34d47dd61f45	2026-05-04	presente		2026-05-04 20:37:55.817901	2026-05-04 20:37:55.817901
6ce41c29-2088-41f2-a43c-fd58a42a0790	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	6ae5e88e-52df-4b57-836e-a88795849517	7ab7dd0e-b224-4b3a-81ca-34d47dd61f45	2026-05-04	presente		2026-05-04 20:37:56.064444	2026-05-04 20:37:56.064444
2991ea70-afba-4c05-b660-cf023543f2f3	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	62515288-7ece-48cc-af13-bf8359872434	7ab7dd0e-b224-4b3a-81ca-34d47dd61f45	2026-05-04	presente		2026-05-04 20:37:56.569201	2026-05-04 20:37:56.569201
77ea0998-4cd2-4ad8-bc13-1f117c79dc34	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	e67826a2-3c40-4e3a-b6b6-046968b1ecdd	7ab7dd0e-b224-4b3a-81ca-34d47dd61f45	2026-05-04	presente		2026-05-04 20:37:56.818893	2026-05-04 20:37:56.818893
19a5a63d-09aa-4b21-8a96-37e0d698b22a	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	6941db3c-5b29-4671-bfb9-320c75ff89c4	7ab7dd0e-b224-4b3a-81ca-34d47dd61f45	2026-05-04	presente		2026-05-04 20:37:57.062081	2026-05-04 20:37:57.062081
742f0424-757e-4026-94f5-fbab8f29a2c6	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	07349913-b823-49e2-b3db-0b91dee5be95	7ab7dd0e-b224-4b3a-81ca-34d47dd61f45	2026-05-04	presente		2026-05-04 20:37:57.306273	2026-05-04 20:37:57.306273
6a8f2ced-d8f4-4b8f-a388-2a86752d3961	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	1f3ead0e-eaf7-4da9-a638-443c1be2aebf	7ab7dd0e-b224-4b3a-81ca-34d47dd61f45	2026-05-04	ausente	Llego tarde sin justificacion	2026-05-04 20:37:57.553696	2026-05-04 20:37:57.553696
\.


--
-- Data for Name: audits; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.audits (id, user_id, action, table_name, record_id, changes_json, action_date, created_at, tabla_afectada, student_id, criteria_id, calificacion_anterior, calificacion_nueva, observation) FROM stdin;
459f2c14-456e-47f9-a852-ad5c2a5f7f23	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	Calificacion registrada	evaluations	6c9c31f2-efb8-4f2a-bae2-72056e5bdf7a	{"grade": 94.00, "student_id": "5255b0d0-ac71-40a0-84e6-8e5af4cd03dd", "criteria_id": "7acb4a70-9d69-47e7-83aa-4b721f430101"}	2026-05-08 00:00:00	2026-05-01 15:49:18.915999	evaluations	5255b0d0-ac71-40a0-84e6-8e5af4cd03dd	7acb4a70-9d69-47e7-83aa-4b721f430101	\N	94.00	Evaluacion demo: analisis inicial del problema.
e00b3d52-27a8-4444-b339-63791b30d72d	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	Calificacion registrada	evaluations	82f7d773-1660-4594-a50b-a9917e609484	{"grade": 86.00, "student_id": "5255b0d0-ac71-40a0-84e6-8e5af4cd03dd", "criteria_id": "7acb4a70-9d69-47e7-83aa-4b721f430102"}	2026-05-08 00:00:00	2026-05-01 15:49:18.915999	evaluations	5255b0d0-ac71-40a0-84e6-8e5af4cd03dd	7acb4a70-9d69-47e7-83aa-4b721f430102	\N	86.00	Evaluacion demo: uso de estructuras de control.
a48ba0ec-893b-4634-b0c1-677c912dfdcc	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	Calificacion registrada	evaluations	3a1c2c8e-165d-466d-9971-2649c8a8af11	{"grade": 97.00, "student_id": "5255b0d0-ac71-40a0-84e6-8e5af4cd03dd", "criteria_id": "7acb4a70-9d69-47e7-83aa-4b721f430103"}	2026-05-16 00:00:00	2026-05-01 15:49:18.915999	evaluations	5255b0d0-ac71-40a0-84e6-8e5af4cd03dd	7acb4a70-9d69-47e7-83aa-4b721f430103	\N	97.00	Evaluacion demo: funcionamiento del codigo.
b2499286-349e-44ef-b2cc-9b7e0fe2a48a	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	Calificacion registrada	evaluations	661554f9-691a-4941-a939-c21343795a05	{"grade": 89.00, "student_id": "5255b0d0-ac71-40a0-84e6-8e5af4cd03dd", "criteria_id": "7acb4a70-9d69-47e7-83aa-4b721f430104"}	2026-05-16 00:00:00	2026-05-01 15:49:18.915999	evaluations	5255b0d0-ac71-40a0-84e6-8e5af4cd03dd	7acb4a70-9d69-47e7-83aa-4b721f430104	\N	89.00	Evaluacion demo: claridad y organizacion.
7b7b8eef-7e9b-4278-bc51-cb39ef9e5080	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	Calificacion registrada	evaluations	7827df1b-aa23-485d-86ad-299554cb6ed1	{"grade": 82.00, "student_id": "5255b0d0-ac71-40a0-84e6-8e5af4cd03dd", "criteria_id": "7acb4a70-9d69-47e7-83aa-4b721f430105"}	2026-05-17 00:00:00	2026-05-01 15:49:18.915999	evaluations	5255b0d0-ac71-40a0-84e6-8e5af4cd03dd	7acb4a70-9d69-47e7-83aa-4b721f430105	\N	82.00	Evaluacion demo: modelo entidad relacion.
7f47107a-b0fa-4252-8194-199296be8b1f	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	Calificacion registrada	evaluations	06be0c2f-4f30-4854-bc28-510e884d5684	{"grade": 86.00, "student_id": "b4310a5f-014b-40be-b5e5-ff8f0f186ac3", "criteria_id": "7acb4a70-9d69-47e7-83aa-4b721f430101"}	2026-05-08 00:00:00	2026-05-01 15:49:18.915999	evaluations	b4310a5f-014b-40be-b5e5-ff8f0f186ac3	7acb4a70-9d69-47e7-83aa-4b721f430101	\N	86.00	Evaluacion demo: analisis inicial del problema.
97fd35cd-59c8-433e-8f20-2a0efdcadc87	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	Calificacion registrada	evaluations	30591f64-7039-48b8-8047-01b88a9c14c2	{"grade": 78.00, "student_id": "b4310a5f-014b-40be-b5e5-ff8f0f186ac3", "criteria_id": "7acb4a70-9d69-47e7-83aa-4b721f430102"}	2026-05-08 00:00:00	2026-05-01 15:49:18.915999	evaluations	b4310a5f-014b-40be-b5e5-ff8f0f186ac3	7acb4a70-9d69-47e7-83aa-4b721f430102	\N	78.00	Evaluacion demo: uso de estructuras de control.
bdab4ab6-96ad-4330-b997-2ae1e4623076	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	Calificacion registrada	evaluations	2307dd32-e87f-4667-a480-0bbccb6e14d8	{"grade": 89.00, "student_id": "b4310a5f-014b-40be-b5e5-ff8f0f186ac3", "criteria_id": "7acb4a70-9d69-47e7-83aa-4b721f430103"}	2026-05-16 00:00:00	2026-05-01 15:49:18.915999	evaluations	b4310a5f-014b-40be-b5e5-ff8f0f186ac3	7acb4a70-9d69-47e7-83aa-4b721f430103	\N	89.00	Evaluacion demo: funcionamiento del codigo.
24de50d8-c166-431a-89e1-afce7cfce1e2	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	Calificacion registrada	evaluations	53e4d393-b48e-4f79-b04f-3004e9911f40	{"grade": 81.00, "student_id": "b4310a5f-014b-40be-b5e5-ff8f0f186ac3", "criteria_id": "7acb4a70-9d69-47e7-83aa-4b721f430104"}	2026-05-16 00:00:00	2026-05-01 15:49:18.915999	evaluations	b4310a5f-014b-40be-b5e5-ff8f0f186ac3	7acb4a70-9d69-47e7-83aa-4b721f430104	\N	81.00	Evaluacion demo: claridad y organizacion.
e755199d-d538-474d-a76e-3ba2d6adc424	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	Calificacion registrada	evaluations	ca172ada-ede1-46fa-a3a1-0dd19c995d70	{"grade": 74.00, "student_id": "b4310a5f-014b-40be-b5e5-ff8f0f186ac3", "criteria_id": "7acb4a70-9d69-47e7-83aa-4b721f430105"}	2026-05-17 00:00:00	2026-05-01 15:49:18.915999	evaluations	b4310a5f-014b-40be-b5e5-ff8f0f186ac3	7acb4a70-9d69-47e7-83aa-4b721f430105	\N	74.00	Evaluacion demo: modelo entidad relacion.
319179ef-980c-430c-bed9-803118a73ced	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	Calificacion registrada	evaluations	1462ac52-b573-4ab9-8bea-1a9dcd10926c	{"grade": 78.00, "student_id": "44be7b74-1260-46dd-8dfb-d00bebb8bfe7", "criteria_id": "7acb4a70-9d69-47e7-83aa-4b721f430101"}	2026-05-08 00:00:00	2026-05-01 15:49:18.915999	evaluations	44be7b74-1260-46dd-8dfb-d00bebb8bfe7	7acb4a70-9d69-47e7-83aa-4b721f430101	\N	78.00	Evaluacion demo: analisis inicial del problema.
8f3ffdfd-0c0b-4068-be7a-43a37e3e8315	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	Calificacion registrada	evaluations	79d4a2f2-d396-4fc3-95a6-0f37192849df	{"grade": 70.00, "student_id": "44be7b74-1260-46dd-8dfb-d00bebb8bfe7", "criteria_id": "7acb4a70-9d69-47e7-83aa-4b721f430102"}	2026-05-08 00:00:00	2026-05-01 15:49:18.915999	evaluations	44be7b74-1260-46dd-8dfb-d00bebb8bfe7	7acb4a70-9d69-47e7-83aa-4b721f430102	\N	70.00	Evaluacion demo: uso de estructuras de control.
42433293-405c-4b67-a5aa-ceba05bddb5a	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	Calificacion registrada	evaluations	7b66cac2-87c8-4d63-9a82-7503761f8302	{"grade": 81.00, "student_id": "44be7b74-1260-46dd-8dfb-d00bebb8bfe7", "criteria_id": "7acb4a70-9d69-47e7-83aa-4b721f430103"}	2026-05-16 00:00:00	2026-05-01 15:49:18.915999	evaluations	44be7b74-1260-46dd-8dfb-d00bebb8bfe7	7acb4a70-9d69-47e7-83aa-4b721f430103	\N	81.00	Evaluacion demo: funcionamiento del codigo.
149dadd9-3aeb-4163-95d0-06641b97ffc9	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	Calificacion registrada	evaluations	62adfa59-253d-4c7c-8304-59bfc88c7334	{"grade": 73.00, "student_id": "44be7b74-1260-46dd-8dfb-d00bebb8bfe7", "criteria_id": "7acb4a70-9d69-47e7-83aa-4b721f430104"}	2026-05-16 00:00:00	2026-05-01 15:49:18.915999	evaluations	44be7b74-1260-46dd-8dfb-d00bebb8bfe7	7acb4a70-9d69-47e7-83aa-4b721f430104	\N	73.00	Evaluacion demo: claridad y organizacion.
d39a4536-2669-4cad-a637-8ece1bd0250b	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	Calificacion registrada	evaluations	1c0cb489-eb3c-48a4-ad3d-e903204870d5	{"grade": 66.00, "student_id": "44be7b74-1260-46dd-8dfb-d00bebb8bfe7", "criteria_id": "7acb4a70-9d69-47e7-83aa-4b721f430105"}	2026-05-17 00:00:00	2026-05-01 15:49:18.915999	evaluations	44be7b74-1260-46dd-8dfb-d00bebb8bfe7	7acb4a70-9d69-47e7-83aa-4b721f430105	\N	66.00	Evaluacion demo: modelo entidad relacion.
6e1397fc-6154-44ee-aaa0-aa57403127a3	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	Calificacion registrada	evaluations	6f3903b1-0eed-4bab-84d8-29e9ce038216	{"grade": 66.00, "student_id": "b0c039cb-87d6-48f8-8da1-b3fb51a841d9", "criteria_id": "7acb4a70-9d69-47e7-83aa-4b721f430101"}	2026-05-08 00:00:00	2026-05-01 15:49:18.915999	evaluations	b0c039cb-87d6-48f8-8da1-b3fb51a841d9	7acb4a70-9d69-47e7-83aa-4b721f430101	\N	66.00	Evaluacion demo: analisis inicial del problema.
45a51d9d-709f-4a52-9856-dcc95b69e1a0	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	Calificacion registrada	evaluations	42f520c0-71c8-4ff7-b52f-7f22e83db5a5	{"grade": 58.00, "student_id": "b0c039cb-87d6-48f8-8da1-b3fb51a841d9", "criteria_id": "7acb4a70-9d69-47e7-83aa-4b721f430102"}	2026-05-08 00:00:00	2026-05-01 15:49:18.915999	evaluations	b0c039cb-87d6-48f8-8da1-b3fb51a841d9	7acb4a70-9d69-47e7-83aa-4b721f430102	\N	58.00	Evaluacion demo: uso de estructuras de control.
665fd276-e8e3-47d8-8c4e-bcab2d9bc646	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	Calificacion registrada	evaluations	db905fc1-d712-44a6-9c10-44ce2f3b9622	{"grade": 69.00, "student_id": "b0c039cb-87d6-48f8-8da1-b3fb51a841d9", "criteria_id": "7acb4a70-9d69-47e7-83aa-4b721f430103"}	2026-05-16 00:00:00	2026-05-01 15:49:18.915999	evaluations	b0c039cb-87d6-48f8-8da1-b3fb51a841d9	7acb4a70-9d69-47e7-83aa-4b721f430103	\N	69.00	Evaluacion demo: funcionamiento del codigo.
eebd33b0-5a5e-4180-9d74-cb09e8110d82	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	Calificacion registrada	evaluations	d1140776-c8ca-4b3d-b03d-df1a40bd08cd	{"grade": 61.00, "student_id": "b0c039cb-87d6-48f8-8da1-b3fb51a841d9", "criteria_id": "7acb4a70-9d69-47e7-83aa-4b721f430104"}	2026-05-16 00:00:00	2026-05-01 15:49:18.915999	evaluations	b0c039cb-87d6-48f8-8da1-b3fb51a841d9	7acb4a70-9d69-47e7-83aa-4b721f430104	\N	61.00	Evaluacion demo: claridad y organizacion.
d1874ba9-1b1f-417b-aa0a-bff76e38d83f	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	Calificacion registrada	evaluations	cf24de39-c5c1-4b23-8db6-e4bfe713a25c	{"grade": 54.00, "student_id": "b0c039cb-87d6-48f8-8da1-b3fb51a841d9", "criteria_id": "7acb4a70-9d69-47e7-83aa-4b721f430105"}	2026-05-17 00:00:00	2026-05-01 15:49:18.915999	evaluations	b0c039cb-87d6-48f8-8da1-b3fb51a841d9	7acb4a70-9d69-47e7-83aa-4b721f430105	\N	54.00	Evaluacion demo: modelo entidad relacion.
d1480847-a6c4-4920-b019-6435e27ff6bb	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	Calificacion registrada	evaluations	128b3bf0-7369-4164-a859-10df2a9cf08f	{"grade": 52.00, "student_id": "880f1b10-6a6d-4144-bbb5-17281b801f59", "criteria_id": "7acb4a70-9d69-47e7-83aa-4b721f430101"}	2026-05-08 00:00:00	2026-05-01 15:49:18.915999	evaluations	880f1b10-6a6d-4144-bbb5-17281b801f59	7acb4a70-9d69-47e7-83aa-4b721f430101	\N	52.00	Evaluacion demo: analisis inicial del problema.
d10c2304-0c68-4b42-bd74-c736a78c0f86	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	Calificacion registrada	evaluations	de780271-7b92-4f1b-b5fb-9da168320b46	{"grade": 44.00, "student_id": "880f1b10-6a6d-4144-bbb5-17281b801f59", "criteria_id": "7acb4a70-9d69-47e7-83aa-4b721f430102"}	2026-05-08 00:00:00	2026-05-01 15:49:18.915999	evaluations	880f1b10-6a6d-4144-bbb5-17281b801f59	7acb4a70-9d69-47e7-83aa-4b721f430102	\N	44.00	Evaluacion demo: uso de estructuras de control.
fa13a318-2161-4017-8d52-0779f3ea50ca	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	Calificacion registrada	evaluations	9cb0240b-482a-42f0-99ab-cc41e4a71b19	{"grade": 55.00, "student_id": "880f1b10-6a6d-4144-bbb5-17281b801f59", "criteria_id": "7acb4a70-9d69-47e7-83aa-4b721f430103"}	2026-05-16 00:00:00	2026-05-01 15:49:18.915999	evaluations	880f1b10-6a6d-4144-bbb5-17281b801f59	7acb4a70-9d69-47e7-83aa-4b721f430103	\N	55.00	Evaluacion demo: funcionamiento del codigo.
82968ed7-b1b1-4ff5-94d2-10672365874e	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	Calificacion registrada	evaluations	81b262fa-b3e8-4f65-acfc-ff9cf2f270c8	{"grade": 47.00, "student_id": "880f1b10-6a6d-4144-bbb5-17281b801f59", "criteria_id": "7acb4a70-9d69-47e7-83aa-4b721f430104"}	2026-05-16 00:00:00	2026-05-01 15:49:18.915999	evaluations	880f1b10-6a6d-4144-bbb5-17281b801f59	7acb4a70-9d69-47e7-83aa-4b721f430104	\N	47.00	Evaluacion demo: claridad y organizacion.
19b9700f-5bc3-4414-ae4a-fbf017ce95bd	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	Calificacion registrada	evaluations	79e24bb1-3ad5-4f3b-9bf9-5833d9997b35	{"grade": 40.00, "student_id": "880f1b10-6a6d-4144-bbb5-17281b801f59", "criteria_id": "7acb4a70-9d69-47e7-83aa-4b721f430105"}	2026-05-17 00:00:00	2026-05-01 15:49:18.915999	evaluations	880f1b10-6a6d-4144-bbb5-17281b801f59	7acb4a70-9d69-47e7-83aa-4b721f430105	\N	40.00	Evaluacion demo: modelo entidad relacion.
0da48505-d7da-48fe-bb25-c01fb2191f97	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	Calificacion registrada	evaluations	9c30ae2e-7830-40dd-abc6-fec034f5e73e	{"grade": 74.00, "student_id": "880f1b10-6a6d-4144-bbb5-17281b801f59", "criteria_id": "7acb4a70-9d69-47e7-83aa-4b721f430102"}	2026-05-22 00:00:00	2026-05-01 15:49:18.915999	evaluations	880f1b10-6a6d-4144-bbb5-17281b801f59	7acb4a70-9d69-47e7-83aa-4b721f430102	\N	74.00	Re-evaluacion: mejora luego de retroalimentacion.
047f190e-77c6-47b3-b190-17d1d56d6863	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	Calificacion registrada	evaluations	946f5b2e-a0c6-4660-bc5b-3967b5f4a4a5	{"grade": 78.00, "student_id": "7332bffc-f65e-4b47-a800-5f5871dd1ff1", "criteria_id": "7acb4a70-9d69-47e7-83aa-4b721f430101"}	2026-05-08 00:00:00	2026-05-01 15:49:18.915999	evaluations	7332bffc-f65e-4b47-a800-5f5871dd1ff1	7acb4a70-9d69-47e7-83aa-4b721f430101	\N	78.00	Evaluacion demo: analisis inicial del problema.
1f9b52fa-ab0c-4766-83e9-c3a867ba938c	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	Calificacion registrada	evaluations	138e818b-1062-4141-bbd1-38fbf1e0a786	{"grade": 70.00, "student_id": "7332bffc-f65e-4b47-a800-5f5871dd1ff1", "criteria_id": "7acb4a70-9d69-47e7-83aa-4b721f430102"}	2026-05-08 00:00:00	2026-05-01 15:49:18.915999	evaluations	7332bffc-f65e-4b47-a800-5f5871dd1ff1	7acb4a70-9d69-47e7-83aa-4b721f430102	\N	70.00	Evaluacion demo: uso de estructuras de control.
13160712-0a45-4a88-9a6a-439c8c1628ed	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	Calificacion registrada	evaluations	af5c0b20-8eb2-4591-b838-a01d54a5d466	{"grade": 81.00, "student_id": "7332bffc-f65e-4b47-a800-5f5871dd1ff1", "criteria_id": "7acb4a70-9d69-47e7-83aa-4b721f430103"}	2026-05-16 00:00:00	2026-05-01 15:49:18.915999	evaluations	7332bffc-f65e-4b47-a800-5f5871dd1ff1	7acb4a70-9d69-47e7-83aa-4b721f430103	\N	81.00	Evaluacion demo: funcionamiento del codigo.
6200427e-2c02-45fa-b6bb-69ad86da17bc	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	Calificacion registrada	evaluations	2acdec79-6feb-4b11-a485-9fe8316ca0d4	{"grade": 73.00, "student_id": "7332bffc-f65e-4b47-a800-5f5871dd1ff1", "criteria_id": "7acb4a70-9d69-47e7-83aa-4b721f430104"}	2026-05-16 00:00:00	2026-05-01 15:49:18.915999	evaluations	7332bffc-f65e-4b47-a800-5f5871dd1ff1	7acb4a70-9d69-47e7-83aa-4b721f430104	\N	73.00	Evaluacion demo: claridad y organizacion.
67e6262f-4248-4f27-a816-b437d633740e	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	Calificacion registrada	evaluations	90cb41c5-5813-46ed-9c44-cedc68dde1e9	{"grade": 66.00, "student_id": "7332bffc-f65e-4b47-a800-5f5871dd1ff1", "criteria_id": "7acb4a70-9d69-47e7-83aa-4b721f430105"}	2026-05-17 00:00:00	2026-05-01 15:49:18.915999	evaluations	7332bffc-f65e-4b47-a800-5f5871dd1ff1	7acb4a70-9d69-47e7-83aa-4b721f430105	\N	66.00	Evaluacion demo: modelo entidad relacion.
f25fa976-7e1b-497a-81c2-967d0b4a8ef1	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	Calificacion registrada	evaluations	25532697-c5aa-4f55-ae6a-d6da606d60db	{"grade": 94.00, "student_id": "d28c16f6-36f6-41c4-9f1b-9dc98d435a62", "criteria_id": "7acb4a70-9d69-47e7-83aa-4b721f430101"}	2026-05-08 00:00:00	2026-05-01 15:49:18.915999	evaluations	d28c16f6-36f6-41c4-9f1b-9dc98d435a62	7acb4a70-9d69-47e7-83aa-4b721f430101	\N	94.00	Evaluacion demo: analisis inicial del problema.
780d97ee-58fb-44a9-b04a-01a44451ad7d	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	Calificacion registrada	evaluations	fea5092a-1e46-4d3d-b499-a2fc597e5858	{"grade": 86.00, "student_id": "d28c16f6-36f6-41c4-9f1b-9dc98d435a62", "criteria_id": "7acb4a70-9d69-47e7-83aa-4b721f430102"}	2026-05-08 00:00:00	2026-05-01 15:49:18.915999	evaluations	d28c16f6-36f6-41c4-9f1b-9dc98d435a62	7acb4a70-9d69-47e7-83aa-4b721f430102	\N	86.00	Evaluacion demo: uso de estructuras de control.
0399b457-e51a-4c00-bc87-c51bcaced42e	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	Calificacion registrada	evaluations	9f832761-74a0-48e5-bfcd-6d63c9355bb2	{"grade": 97.00, "student_id": "d28c16f6-36f6-41c4-9f1b-9dc98d435a62", "criteria_id": "7acb4a70-9d69-47e7-83aa-4b721f430103"}	2026-05-16 00:00:00	2026-05-01 15:49:18.915999	evaluations	d28c16f6-36f6-41c4-9f1b-9dc98d435a62	7acb4a70-9d69-47e7-83aa-4b721f430103	\N	97.00	Evaluacion demo: funcionamiento del codigo.
e1ba58aa-fb66-4272-bfa1-0b4e8dc1e2bf	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	Calificacion registrada	evaluations	edee4b37-cca7-4937-815a-32ffdfba01cb	{"grade": 89.00, "student_id": "d28c16f6-36f6-41c4-9f1b-9dc98d435a62", "criteria_id": "7acb4a70-9d69-47e7-83aa-4b721f430104"}	2026-05-16 00:00:00	2026-05-01 15:49:18.915999	evaluations	d28c16f6-36f6-41c4-9f1b-9dc98d435a62	7acb4a70-9d69-47e7-83aa-4b721f430104	\N	89.00	Evaluacion demo: claridad y organizacion.
398b508c-6ecd-45d0-b182-8780285e981f	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	Calificacion registrada	evaluations	43579f6d-2499-4ee9-ba90-02e432962db6	{"grade": 82.00, "student_id": "d28c16f6-36f6-41c4-9f1b-9dc98d435a62", "criteria_id": "7acb4a70-9d69-47e7-83aa-4b721f430105"}	2026-05-17 00:00:00	2026-05-01 15:49:18.915999	evaluations	d28c16f6-36f6-41c4-9f1b-9dc98d435a62	7acb4a70-9d69-47e7-83aa-4b721f430105	\N	82.00	Evaluacion demo: modelo entidad relacion.
671f5b0f-fc18-4a38-b4f3-38f9788d266b	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	Calificacion registrada	evaluations	49d0d637-6080-43bf-867d-43393e2a21e5	{"grade": 66.00, "student_id": "9a3edf62-5da6-4102-88d9-b9702f2c451e", "criteria_id": "7acb4a70-9d69-47e7-83aa-4b721f430101"}	2026-05-08 00:00:00	2026-05-01 15:49:18.915999	evaluations	9a3edf62-5da6-4102-88d9-b9702f2c451e	7acb4a70-9d69-47e7-83aa-4b721f430101	\N	66.00	Evaluacion demo: analisis inicial del problema.
6d11edb3-28bf-4377-ac2a-4f352992136a	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	Calificacion registrada	evaluations	f62b8e99-92b1-431b-8d3e-e5e13739961a	{"grade": 58.00, "student_id": "9a3edf62-5da6-4102-88d9-b9702f2c451e", "criteria_id": "7acb4a70-9d69-47e7-83aa-4b721f430102"}	2026-05-08 00:00:00	2026-05-01 15:49:18.915999	evaluations	9a3edf62-5da6-4102-88d9-b9702f2c451e	7acb4a70-9d69-47e7-83aa-4b721f430102	\N	58.00	Evaluacion demo: uso de estructuras de control.
9afd9567-2a56-4650-b2d9-9d523f391681	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	Calificacion registrada	evaluations	45c93345-bca1-46a7-9ade-712f599a04b8	{"grade": 69.00, "student_id": "9a3edf62-5da6-4102-88d9-b9702f2c451e", "criteria_id": "7acb4a70-9d69-47e7-83aa-4b721f430103"}	2026-05-16 00:00:00	2026-05-01 15:49:18.915999	evaluations	9a3edf62-5da6-4102-88d9-b9702f2c451e	7acb4a70-9d69-47e7-83aa-4b721f430103	\N	69.00	Evaluacion demo: funcionamiento del codigo.
1c0a3732-8474-4f2f-9f5a-b111fc52c115	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	Calificacion registrada	evaluations	36224c51-badd-4415-b499-584918048f76	{"grade": 61.00, "student_id": "9a3edf62-5da6-4102-88d9-b9702f2c451e", "criteria_id": "7acb4a70-9d69-47e7-83aa-4b721f430104"}	2026-05-16 00:00:00	2026-05-01 15:49:18.915999	evaluations	9a3edf62-5da6-4102-88d9-b9702f2c451e	7acb4a70-9d69-47e7-83aa-4b721f430104	\N	61.00	Evaluacion demo: claridad y organizacion.
d2eb769a-6b5e-4da4-be83-814b5320a9ed	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	Calificacion registrada	evaluations	2344add0-a081-4e18-a52f-ba802a46ce76	{"grade": 54.00, "student_id": "9a3edf62-5da6-4102-88d9-b9702f2c451e", "criteria_id": "7acb4a70-9d69-47e7-83aa-4b721f430105"}	2026-05-17 00:00:00	2026-05-01 15:49:18.915999	evaluations	9a3edf62-5da6-4102-88d9-b9702f2c451e	7acb4a70-9d69-47e7-83aa-4b721f430105	\N	54.00	Evaluacion demo: modelo entidad relacion.
89b57152-0c85-47a3-8c61-7fa2772f5b72	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	Calificacion registrada	evaluations	df9cf181-eff4-4297-819c-0fa0f9ef9817	{"grade": 78.00, "student_id": "3b65f5af-5a4d-4d74-bd1f-2a3025412f06", "criteria_id": "7acb4a70-9d69-47e7-83aa-4b721f430101"}	2026-05-08 00:00:00	2026-05-01 15:49:18.915999	evaluations	3b65f5af-5a4d-4d74-bd1f-2a3025412f06	7acb4a70-9d69-47e7-83aa-4b721f430101	\N	78.00	Evaluacion demo: analisis inicial del problema.
75995d78-2a47-4517-85e8-97ca40be1005	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	Calificacion registrada	evaluations	1fa8bf89-be5c-4893-b3c0-272b1addf84d	{"grade": 70.00, "student_id": "3b65f5af-5a4d-4d74-bd1f-2a3025412f06", "criteria_id": "7acb4a70-9d69-47e7-83aa-4b721f430102"}	2026-05-08 00:00:00	2026-05-01 15:49:18.915999	evaluations	3b65f5af-5a4d-4d74-bd1f-2a3025412f06	7acb4a70-9d69-47e7-83aa-4b721f430102	\N	70.00	Evaluacion demo: uso de estructuras de control.
ba216594-af2d-4c32-ad21-fc8407e0dea5	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	Calificacion registrada	evaluations	c073957c-4619-444b-841f-fb5a383ba2cf	{"grade": 81.00, "student_id": "3b65f5af-5a4d-4d74-bd1f-2a3025412f06", "criteria_id": "7acb4a70-9d69-47e7-83aa-4b721f430103"}	2026-05-16 00:00:00	2026-05-01 15:49:18.915999	evaluations	3b65f5af-5a4d-4d74-bd1f-2a3025412f06	7acb4a70-9d69-47e7-83aa-4b721f430103	\N	81.00	Evaluacion demo: funcionamiento del codigo.
4cb86082-b169-44f7-b96f-07d0cefd6cf4	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	Calificacion registrada	evaluations	2e1a213d-3e77-414b-99ae-f3f1e84033fa	{"grade": 73.00, "student_id": "3b65f5af-5a4d-4d74-bd1f-2a3025412f06", "criteria_id": "7acb4a70-9d69-47e7-83aa-4b721f430104"}	2026-05-16 00:00:00	2026-05-01 15:49:18.915999	evaluations	3b65f5af-5a4d-4d74-bd1f-2a3025412f06	7acb4a70-9d69-47e7-83aa-4b721f430104	\N	73.00	Evaluacion demo: claridad y organizacion.
204915d2-45a8-4e02-a6d4-8973035e7def	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	Calificacion registrada	evaluations	6d21b53e-0466-4742-b14d-8fff6385fac6	{"grade": 66.00, "student_id": "3b65f5af-5a4d-4d74-bd1f-2a3025412f06", "criteria_id": "7acb4a70-9d69-47e7-83aa-4b721f430105"}	2026-05-17 00:00:00	2026-05-01 15:49:18.915999	evaluations	3b65f5af-5a4d-4d74-bd1f-2a3025412f06	7acb4a70-9d69-47e7-83aa-4b721f430105	\N	66.00	Evaluacion demo: modelo entidad relacion.
ca71ffbd-f804-43ac-9b86-2a34792b6116	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	Calificacion registrada	evaluations	896212b3-5a30-440c-ac53-ab5a55791179	{"grade": 52.00, "student_id": "cb45271c-dd6c-4cf9-a063-21a5b540bc32", "criteria_id": "7acb4a70-9d69-47e7-83aa-4b721f430101"}	2026-05-08 00:00:00	2026-05-01 15:49:18.915999	evaluations	cb45271c-dd6c-4cf9-a063-21a5b540bc32	7acb4a70-9d69-47e7-83aa-4b721f430101	\N	52.00	Evaluacion demo: analisis inicial del problema.
5e8884b8-361d-453f-9b03-f5c321386d61	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	Calificacion registrada	evaluations	bbce75ef-0c98-4d25-881d-3ab3981a7edd	{"grade": 44.00, "student_id": "cb45271c-dd6c-4cf9-a063-21a5b540bc32", "criteria_id": "7acb4a70-9d69-47e7-83aa-4b721f430102"}	2026-05-08 00:00:00	2026-05-01 15:49:18.915999	evaluations	cb45271c-dd6c-4cf9-a063-21a5b540bc32	7acb4a70-9d69-47e7-83aa-4b721f430102	\N	44.00	Evaluacion demo: uso de estructuras de control.
bce954d1-e975-4f1e-a8d4-805500a96edf	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	Calificacion registrada	evaluations	161c22b0-06f9-49e9-8d5f-f48aabefef67	{"grade": 55.00, "student_id": "cb45271c-dd6c-4cf9-a063-21a5b540bc32", "criteria_id": "7acb4a70-9d69-47e7-83aa-4b721f430103"}	2026-05-16 00:00:00	2026-05-01 15:49:18.915999	evaluations	cb45271c-dd6c-4cf9-a063-21a5b540bc32	7acb4a70-9d69-47e7-83aa-4b721f430103	\N	55.00	Evaluacion demo: funcionamiento del codigo.
7c5f681a-21b0-4947-a47c-c8fa63ec3eda	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	Calificacion registrada	evaluations	99a4030d-4f60-410b-8e71-7a0ca2875e41	{"grade": 47.00, "student_id": "cb45271c-dd6c-4cf9-a063-21a5b540bc32", "criteria_id": "7acb4a70-9d69-47e7-83aa-4b721f430104"}	2026-05-16 00:00:00	2026-05-01 15:49:18.915999	evaluations	cb45271c-dd6c-4cf9-a063-21a5b540bc32	7acb4a70-9d69-47e7-83aa-4b721f430104	\N	47.00	Evaluacion demo: claridad y organizacion.
cc4c7bea-6ab8-4cb9-a6d4-45493f8705ef	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	Calificacion registrada	evaluations	5b5a119a-fc7e-4fee-af82-0eeab9434d56	{"grade": 40.00, "student_id": "cb45271c-dd6c-4cf9-a063-21a5b540bc32", "criteria_id": "7acb4a70-9d69-47e7-83aa-4b721f430105"}	2026-05-17 00:00:00	2026-05-01 15:49:18.915999	evaluations	cb45271c-dd6c-4cf9-a063-21a5b540bc32	7acb4a70-9d69-47e7-83aa-4b721f430105	\N	40.00	Evaluacion demo: modelo entidad relacion.
b07826b0-27cd-4334-904e-8900c2f1c164	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	Calificacion registrada	evaluations	a683b169-456c-4544-bcf5-24ba9be7c334	{"grade": 74.00, "student_id": "cb45271c-dd6c-4cf9-a063-21a5b540bc32", "criteria_id": "7acb4a70-9d69-47e7-83aa-4b721f430102"}	2026-05-22 00:00:00	2026-05-01 15:49:18.915999	evaluations	cb45271c-dd6c-4cf9-a063-21a5b540bc32	7acb4a70-9d69-47e7-83aa-4b721f430102	\N	74.00	Re-evaluacion: mejora luego de retroalimentacion.
427ca5cf-f465-481f-885f-97faeb2ea90f	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	Calificacion registrada	evaluations	aec37624-8b0a-425d-ad9a-d3e1e6a4efed	{"grade": 94.00, "student_id": "2088677b-a9ed-41c2-b7cf-6b1c0f67340a", "criteria_id": "7acb4a70-9d69-47e7-83aa-4b721f430101"}	2026-05-08 00:00:00	2026-05-01 15:49:18.915999	evaluations	2088677b-a9ed-41c2-b7cf-6b1c0f67340a	7acb4a70-9d69-47e7-83aa-4b721f430101	\N	94.00	Evaluacion demo: analisis inicial del problema.
a609183c-a4d7-4acc-b691-7656f5d7a044	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	Calificacion registrada	evaluations	c9c0f558-c93c-47a4-b636-2d5a51ef36fb	{"grade": 86.00, "student_id": "2088677b-a9ed-41c2-b7cf-6b1c0f67340a", "criteria_id": "7acb4a70-9d69-47e7-83aa-4b721f430102"}	2026-05-08 00:00:00	2026-05-01 15:49:18.915999	evaluations	2088677b-a9ed-41c2-b7cf-6b1c0f67340a	7acb4a70-9d69-47e7-83aa-4b721f430102	\N	86.00	Evaluacion demo: uso de estructuras de control.
48ca40d3-b004-4104-8081-adada6f5a209	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	Calificacion registrada	evaluations	1168640e-7882-4475-8036-5f17bd202311	{"grade": 97.00, "student_id": "2088677b-a9ed-41c2-b7cf-6b1c0f67340a", "criteria_id": "7acb4a70-9d69-47e7-83aa-4b721f430103"}	2026-05-16 00:00:00	2026-05-01 15:49:18.915999	evaluations	2088677b-a9ed-41c2-b7cf-6b1c0f67340a	7acb4a70-9d69-47e7-83aa-4b721f430103	\N	97.00	Evaluacion demo: funcionamiento del codigo.
deec7723-a4a4-4d7c-89c0-ae71910c7da0	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	Calificacion registrada	evaluations	6521d1de-52ba-48c3-834d-e72c16d173f9	{"grade": 89.00, "student_id": "2088677b-a9ed-41c2-b7cf-6b1c0f67340a", "criteria_id": "7acb4a70-9d69-47e7-83aa-4b721f430104"}	2026-05-16 00:00:00	2026-05-01 15:49:18.915999	evaluations	2088677b-a9ed-41c2-b7cf-6b1c0f67340a	7acb4a70-9d69-47e7-83aa-4b721f430104	\N	89.00	Evaluacion demo: claridad y organizacion.
58d3b0e5-7995-4815-8abe-5cbeb4329779	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	Calificacion registrada	evaluations	e0d86889-afdb-43c2-84e0-7d79ab6ab189	{"grade": 82.00, "student_id": "2088677b-a9ed-41c2-b7cf-6b1c0f67340a", "criteria_id": "7acb4a70-9d69-47e7-83aa-4b721f430105"}	2026-05-17 00:00:00	2026-05-01 15:49:18.915999	evaluations	2088677b-a9ed-41c2-b7cf-6b1c0f67340a	7acb4a70-9d69-47e7-83aa-4b721f430105	\N	82.00	Evaluacion demo: modelo entidad relacion.
2a02ba88-8d28-49dc-862f-3d6737e7aedc	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	Calificacion registrada	evaluations	df1396ac-5835-44d0-a64f-5415213667d7	{"grade": 66.00, "student_id": "e8bac2f2-ae10-4de3-beea-824bd74aad7f", "criteria_id": "7acb4a70-9d69-47e7-83aa-4b721f430101"}	2026-05-08 00:00:00	2026-05-01 15:49:18.915999	evaluations	e8bac2f2-ae10-4de3-beea-824bd74aad7f	7acb4a70-9d69-47e7-83aa-4b721f430101	\N	66.00	Evaluacion demo: analisis inicial del problema.
42fb1168-26f7-472c-8321-8c130b0e8e0a	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	Calificacion registrada	evaluations	48a3be9f-38be-4b8d-8ee1-46c52735c4f3	{"grade": 58.00, "student_id": "e8bac2f2-ae10-4de3-beea-824bd74aad7f", "criteria_id": "7acb4a70-9d69-47e7-83aa-4b721f430102"}	2026-05-08 00:00:00	2026-05-01 15:49:18.915999	evaluations	e8bac2f2-ae10-4de3-beea-824bd74aad7f	7acb4a70-9d69-47e7-83aa-4b721f430102	\N	58.00	Evaluacion demo: uso de estructuras de control.
e0bd2440-c489-477c-ab26-9edfa865cac5	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	Calificacion registrada	evaluations	5f696631-ad38-4eaa-845a-02496ef7a6de	{"grade": 69.00, "student_id": "e8bac2f2-ae10-4de3-beea-824bd74aad7f", "criteria_id": "7acb4a70-9d69-47e7-83aa-4b721f430103"}	2026-05-16 00:00:00	2026-05-01 15:49:18.915999	evaluations	e8bac2f2-ae10-4de3-beea-824bd74aad7f	7acb4a70-9d69-47e7-83aa-4b721f430103	\N	69.00	Evaluacion demo: funcionamiento del codigo.
08392a2f-7c28-447e-b581-2bed5449ab5d	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	Calificacion registrada	evaluations	e9717b66-117e-4e37-901b-92cca089683f	{"grade": 61.00, "student_id": "e8bac2f2-ae10-4de3-beea-824bd74aad7f", "criteria_id": "7acb4a70-9d69-47e7-83aa-4b721f430104"}	2026-05-16 00:00:00	2026-05-01 15:49:18.915999	evaluations	e8bac2f2-ae10-4de3-beea-824bd74aad7f	7acb4a70-9d69-47e7-83aa-4b721f430104	\N	61.00	Evaluacion demo: claridad y organizacion.
85fe6202-7249-41b1-8676-9cab423ae793	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	Calificacion registrada	evaluations	8022c7d7-bd63-4ace-9904-e5437c7cecfa	{"grade": 54.00, "student_id": "e8bac2f2-ae10-4de3-beea-824bd74aad7f", "criteria_id": "7acb4a70-9d69-47e7-83aa-4b721f430105"}	2026-05-17 00:00:00	2026-05-01 15:49:18.915999	evaluations	e8bac2f2-ae10-4de3-beea-824bd74aad7f	7acb4a70-9d69-47e7-83aa-4b721f430105	\N	54.00	Evaluacion demo: modelo entidad relacion.
c5f9f1a7-eea8-4d38-8184-2326057efbd2	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	Calificacion registrada	evaluations	e169f275-1bfe-468c-aef5-f0444aa87b69	{"grade": 94.00, "student_id": "76542e5b-958f-4a97-9a56-b2eb23fe5d50", "criteria_id": "7acb4a70-9d69-47e7-83aa-4b721f430101"}	2026-05-08 00:00:00	2026-05-01 15:49:18.915999	evaluations	76542e5b-958f-4a97-9a56-b2eb23fe5d50	7acb4a70-9d69-47e7-83aa-4b721f430101	\N	94.00	Evaluacion demo: analisis inicial del problema.
3d4b04f4-133e-4495-9a06-cee7ab39f851	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	Calificacion registrada	evaluations	ecc620b9-ad65-4bd4-8053-f3720db5c641	{"grade": 86.00, "student_id": "76542e5b-958f-4a97-9a56-b2eb23fe5d50", "criteria_id": "7acb4a70-9d69-47e7-83aa-4b721f430102"}	2026-05-08 00:00:00	2026-05-01 15:49:18.915999	evaluations	76542e5b-958f-4a97-9a56-b2eb23fe5d50	7acb4a70-9d69-47e7-83aa-4b721f430102	\N	86.00	Evaluacion demo: uso de estructuras de control.
79b8a2ca-c804-416b-8241-df22c0432144	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	Calificacion registrada	evaluations	f940b51c-4d73-45ab-bbda-07f69e608087	{"grade": 97.00, "student_id": "76542e5b-958f-4a97-9a56-b2eb23fe5d50", "criteria_id": "7acb4a70-9d69-47e7-83aa-4b721f430103"}	2026-05-16 00:00:00	2026-05-01 15:49:18.915999	evaluations	76542e5b-958f-4a97-9a56-b2eb23fe5d50	7acb4a70-9d69-47e7-83aa-4b721f430103	\N	97.00	Evaluacion demo: funcionamiento del codigo.
e37ea2c4-5033-47d4-98a4-708df3c98041	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	Calificacion registrada	evaluations	147ff44a-d3a4-4449-828e-4467d2b0786c	{"grade": 89.00, "student_id": "76542e5b-958f-4a97-9a56-b2eb23fe5d50", "criteria_id": "7acb4a70-9d69-47e7-83aa-4b721f430104"}	2026-05-16 00:00:00	2026-05-01 15:49:18.915999	evaluations	76542e5b-958f-4a97-9a56-b2eb23fe5d50	7acb4a70-9d69-47e7-83aa-4b721f430104	\N	89.00	Evaluacion demo: claridad y organizacion.
a8d49a1d-f8db-424b-8cf1-b67b86783aaa	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	Calificacion registrada	evaluations	a1ece101-9ea2-4aa8-9218-df67e3f530a8	{"grade": 82.00, "student_id": "76542e5b-958f-4a97-9a56-b2eb23fe5d50", "criteria_id": "7acb4a70-9d69-47e7-83aa-4b721f430105"}	2026-05-17 00:00:00	2026-05-01 15:49:18.915999	evaluations	76542e5b-958f-4a97-9a56-b2eb23fe5d50	7acb4a70-9d69-47e7-83aa-4b721f430105	\N	82.00	Evaluacion demo: modelo entidad relacion.
811447f2-6b38-454d-aee0-3bf26939f65d	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	Calificacion registrada	evaluations	954421b0-0c7d-455d-8b19-f4f7bb1aee0b	{"grade": 86.00, "student_id": "cd1c0e10-48e1-4123-9c0b-6dfa69751676", "criteria_id": "7acb4a70-9d69-47e7-83aa-4b721f430101"}	2026-05-08 00:00:00	2026-05-01 15:49:18.915999	evaluations	cd1c0e10-48e1-4123-9c0b-6dfa69751676	7acb4a70-9d69-47e7-83aa-4b721f430101	\N	86.00	Evaluacion demo: analisis inicial del problema.
e7915af1-1906-49e0-a1ad-85cbad9778ac	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	Calificacion registrada	evaluations	a021f56c-7f1a-4c10-8568-90186dfad05b	{"grade": 78.00, "student_id": "cd1c0e10-48e1-4123-9c0b-6dfa69751676", "criteria_id": "7acb4a70-9d69-47e7-83aa-4b721f430102"}	2026-05-08 00:00:00	2026-05-01 15:49:18.915999	evaluations	cd1c0e10-48e1-4123-9c0b-6dfa69751676	7acb4a70-9d69-47e7-83aa-4b721f430102	\N	78.00	Evaluacion demo: uso de estructuras de control.
40bafdec-23b9-413b-860e-20a5a35e3936	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	Calificacion registrada	evaluations	599c64a2-938a-4bc5-ab4d-ddbdad546dee	{"grade": 89.00, "student_id": "cd1c0e10-48e1-4123-9c0b-6dfa69751676", "criteria_id": "7acb4a70-9d69-47e7-83aa-4b721f430103"}	2026-05-16 00:00:00	2026-05-01 15:49:18.915999	evaluations	cd1c0e10-48e1-4123-9c0b-6dfa69751676	7acb4a70-9d69-47e7-83aa-4b721f430103	\N	89.00	Evaluacion demo: funcionamiento del codigo.
9174555b-fbea-4d4f-b11d-672d2d896d0a	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	Calificacion registrada	evaluations	83f27773-1197-47cd-ba2e-7b0161d2b104	{"grade": 81.00, "student_id": "cd1c0e10-48e1-4123-9c0b-6dfa69751676", "criteria_id": "7acb4a70-9d69-47e7-83aa-4b721f430104"}	2026-05-16 00:00:00	2026-05-01 15:49:18.915999	evaluations	cd1c0e10-48e1-4123-9c0b-6dfa69751676	7acb4a70-9d69-47e7-83aa-4b721f430104	\N	81.00	Evaluacion demo: claridad y organizacion.
2a065192-218b-4d28-aa03-ab7708d56d55	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	Calificacion registrada	evaluations	e789917c-5932-462f-ba93-db5d730d79af	{"grade": 74.00, "student_id": "cd1c0e10-48e1-4123-9c0b-6dfa69751676", "criteria_id": "7acb4a70-9d69-47e7-83aa-4b721f430105"}	2026-05-17 00:00:00	2026-05-01 15:49:18.915999	evaluations	cd1c0e10-48e1-4123-9c0b-6dfa69751676	7acb4a70-9d69-47e7-83aa-4b721f430105	\N	74.00	Evaluacion demo: modelo entidad relacion.
47d083b5-183e-433e-9f06-3fa1758f5a28	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	Calificacion registrada	evaluations	381f585f-a0f6-452b-8bff-841ccee24f05	{"grade": 52.00, "student_id": "b338bdf1-8943-4b46-83b1-8fc5315c456e", "criteria_id": "7acb4a70-9d69-47e7-83aa-4b721f430101"}	2026-05-08 00:00:00	2026-05-01 15:49:18.915999	evaluations	b338bdf1-8943-4b46-83b1-8fc5315c456e	7acb4a70-9d69-47e7-83aa-4b721f430101	\N	52.00	Evaluacion demo: analisis inicial del problema.
c3c59885-2451-41e2-9fb9-8d7f620ecfe1	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	Calificacion registrada	evaluations	495f33b4-933a-41ba-9ed4-61df1cda7c99	{"grade": 44.00, "student_id": "b338bdf1-8943-4b46-83b1-8fc5315c456e", "criteria_id": "7acb4a70-9d69-47e7-83aa-4b721f430102"}	2026-05-08 00:00:00	2026-05-01 15:49:18.915999	evaluations	b338bdf1-8943-4b46-83b1-8fc5315c456e	7acb4a70-9d69-47e7-83aa-4b721f430102	\N	44.00	Evaluacion demo: uso de estructuras de control.
2a6ee491-3682-46ae-9422-bdf0aae1d1b4	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	Calificacion registrada	evaluations	c27dfac3-e9f3-43b5-94b9-399d03d35cc2	{"grade": 55.00, "student_id": "b338bdf1-8943-4b46-83b1-8fc5315c456e", "criteria_id": "7acb4a70-9d69-47e7-83aa-4b721f430103"}	2026-05-16 00:00:00	2026-05-01 15:49:18.915999	evaluations	b338bdf1-8943-4b46-83b1-8fc5315c456e	7acb4a70-9d69-47e7-83aa-4b721f430103	\N	55.00	Evaluacion demo: funcionamiento del codigo.
3895dceb-04c0-402b-b160-828b813d66a1	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	Calificacion registrada	evaluations	7bfeebdb-0ee7-49e7-9bd8-b7d2e2e6b247	{"grade": 47.00, "student_id": "b338bdf1-8943-4b46-83b1-8fc5315c456e", "criteria_id": "7acb4a70-9d69-47e7-83aa-4b721f430104"}	2026-05-16 00:00:00	2026-05-01 15:49:18.915999	evaluations	b338bdf1-8943-4b46-83b1-8fc5315c456e	7acb4a70-9d69-47e7-83aa-4b721f430104	\N	47.00	Evaluacion demo: claridad y organizacion.
e93fab32-d3db-4f6e-865c-9cb0259b9a22	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	Calificacion registrada	evaluations	4ccc16f6-54d7-4c4f-94a7-224a78e18a30	{"grade": 40.00, "student_id": "b338bdf1-8943-4b46-83b1-8fc5315c456e", "criteria_id": "7acb4a70-9d69-47e7-83aa-4b721f430105"}	2026-05-17 00:00:00	2026-05-01 15:49:18.915999	evaluations	b338bdf1-8943-4b46-83b1-8fc5315c456e	7acb4a70-9d69-47e7-83aa-4b721f430105	\N	40.00	Evaluacion demo: modelo entidad relacion.
c48317ae-ce1a-448a-82e2-6bdfbe89f57c	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	Calificacion registrada	evaluations	bc9980f1-ba19-49c7-a7af-febc70f022c3	{"grade": 74.00, "student_id": "b338bdf1-8943-4b46-83b1-8fc5315c456e", "criteria_id": "7acb4a70-9d69-47e7-83aa-4b721f430102"}	2026-05-22 00:00:00	2026-05-01 15:49:18.915999	evaluations	b338bdf1-8943-4b46-83b1-8fc5315c456e	7acb4a70-9d69-47e7-83aa-4b721f430102	\N	74.00	Re-evaluacion: mejora luego de retroalimentacion.
d70f4056-2d3d-4188-9d9b-62e3df4b925f	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	Calificacion registrada	evaluations	60bb6840-8400-4d7a-8c06-e7b25a56e33f	{"grade": 66.00, "student_id": "6ae5e88e-52df-4b57-836e-a88795849517", "criteria_id": "7acb4a70-9d69-47e7-83aa-4b721f430101"}	2026-05-08 00:00:00	2026-05-01 15:49:18.915999	evaluations	6ae5e88e-52df-4b57-836e-a88795849517	7acb4a70-9d69-47e7-83aa-4b721f430101	\N	66.00	Evaluacion demo: analisis inicial del problema.
f843d884-cb4a-4879-964e-8ca775815110	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	Calificacion registrada	evaluations	bb9bb66e-d64f-4708-8689-401c284be81e	{"grade": 58.00, "student_id": "6ae5e88e-52df-4b57-836e-a88795849517", "criteria_id": "7acb4a70-9d69-47e7-83aa-4b721f430102"}	2026-05-08 00:00:00	2026-05-01 15:49:18.915999	evaluations	6ae5e88e-52df-4b57-836e-a88795849517	7acb4a70-9d69-47e7-83aa-4b721f430102	\N	58.00	Evaluacion demo: uso de estructuras de control.
\.


--
-- Data for Name: competencies; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.competencies (id, name, description, descriptor, subject, teacher_id, created_at) FROM stdin;
1	Liderazgo	Capacidad de dirigir equipos	Liderazgo efectivo en equipos de trabajo	Blanda	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	2026-04-28 13:43:32.960438
2	Comunicación	Expresar ideas claramente	Comunicación oral y escrita efectiva	Blanda	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	2026-04-28 13:43:32.960438
3	Resolución de Problemas	Analizar y resolver conflictos	Pensamiento crítico y resolución efectiva	Técnica	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	2026-04-28 13:43:32.960438
4	Trabajo en Equipo	Colaborar efectivamente	Cooperación y sinergia grupal	Blanda	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	2026-04-28 13:43:32.960438
5	Pensamiento Crítico	Analizar información	Evaluación objetiva de datos y situaciones	Técnica	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	2026-04-28 13:43:32.960438
7acb4a70-9d69-47e7-83aa-4b721f410101	Desarrollo de algoritmos	Resuelve problemas usando pensamiento logico y estructuras de programacion.	Analiza problemas, disena algoritmos y valida soluciones.	Programacion I	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	2026-05-01 15:49:18.915999
7acb4a70-9d69-47e7-83aa-4b721f410102	Modelado de bases de datos	Disena modelos de datos coherentes para necesidades de informacion.	Identifica entidades, relaciones y reglas de integridad.	Base de Datos	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	2026-05-01 15:49:18.915999
00a19c78-af41-42a4-96f1-0eff97e4bd27	Comunicación efectiva	Expresa ideas de forma clara, precisa y adecuada al contexto.	Organiza información, argumenta con claridad y adapta su comunicación a diferentes audiencias.	Competencia transversal	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	2026-05-05 10:57:07.611936
b6b6fc14-1fbb-42b2-bb76-2c9730486dd6	Resolución de problemas	Analiza situaciones y propone soluciones pertinentes.	Identifica causas, evalúa alternativas y aplica procedimientos para resolver problemas.	Competencia transversal	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	2026-05-05 11:00:47.336353
2241e15e-6187-4e59-8d07-2e18a574871d	Trabajo colaborativo	Participa de manera responsable en equipos de trabajo.	Colabora, asume roles y contribuye al logro de objetivos comunes.	Competencia transversal	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	2026-05-05 11:00:52.682198
\.


--
-- Data for Name: configuration; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.configuration (id, key, value, type, description, updated_by, updated_at, created_at) FROM stdin;
9bf34a11-f3e5-4baf-8ee7-6570968562fc	institution_name	Instituto Politécnico	text	Nombre de la institución	\N	2026-04-27 02:35:32.58094	2026-04-27 02:35:32.58094
b761b4c8-d40c-49f7-9126-d4bf247a9905	period_trimestre_1	{'name': 'gfbdbfdbhdd ', 'type': 'trimestre', 'start_date': '2026-04-30', 'end_date': '2026-07-30', 'order': 1, 'active': True, 'created_at': '2026-04-30T06:21:11.860742'}	period	Período académico: gfbdbfdbhdd 	\N	2026-04-30 10:21:11.580011	2026-04-30 10:21:11.580011
cb5938f8-2684-4e76-b92f-14811d0c861d	period_Segundo bimestre	{"name": "Segundo bimestre", "type": "bimestre", "start_date": "2026-04-30", "end_date": "2026-06-30", "order": 1, "active": true, "created_at": "2026-04-30T14:22:25.034949"}	text	\N	\N	2026-04-30 18:22:24.686376	2026-04-30 18:22:24.686376
b6d1771c-e01c-4701-a681-0c54582adb0b	academic_year	2026	text	Ano academico	\N	2026-04-27 02:35:32.58094	2026-04-27 02:35:32.58094
9ece6a3b-31d1-4bf7-ba98-53f8fe0c1754	period_Primer Semestre 2026	{"name":"Primer Semestre 2026","type":"semestre","start_date":"2026-01-12","end_date":"2026-06-19","order":1,"active":true}	json	Periodo demo	\N	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999
495a7564-8bfb-4dc4-95f2-9236eaf82e4a	minimum_passing_score	70	number	Calificación mínima	\N	2026-04-27 02:35:32.58094	2026-04-27 02:35:32.58094
10599afd-9f64-4e12-aa1a-43cf9eafafc9	period_type	trimestre	text	Tipo de periodo	\N	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999
071f849e-b894-490e-8932-2f6d5d933250	umbral_reevaluacion	60.0	text	Umbral mínimo de calificación para re-evaluación (0-100)	\N	2026-05-08 11:49:47.258803	2026-05-08 11:49:47.258803
9a0d67b1-a822-42ac-8767-ba1678fb76a2	escala_calificacion	0-100	text	Escala activa	\N	2026-04-30 02:52:14.16026	2026-04-30 02:52:14.16026
\.


--
-- Data for Name: criteria; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.criteria (id, learning_outcome_id, name, description, weighting, requires_observation, created_at, updated_at) FROM stdin;
7acb4a70-9d69-47e7-83aa-4b721f430101	7acb4a70-9d69-47e7-83aa-4b721f420101	Analisis del problema	Identifica entradas, procesos y salidas.	35.00	t	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999
7acb4a70-9d69-47e7-83aa-4b721f430102	7acb4a70-9d69-47e7-83aa-4b721f420101	Uso de estructuras de control	Aplica decisiones y ciclos adecuadamente.	65.00	t	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999
7acb4a70-9d69-47e7-83aa-4b721f430103	7acb4a70-9d69-47e7-83aa-4b721f420102	Funcionamiento del codigo	La solucion ejecuta y cumple el objetivo.	60.00	t	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999
7acb4a70-9d69-47e7-83aa-4b721f430104	7acb4a70-9d69-47e7-83aa-4b721f420102	Claridad y organizacion	El codigo es legible y esta bien organizado.	40.00	t	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999
7acb4a70-9d69-47e7-83aa-4b721f430105	7acb4a70-9d69-47e7-83aa-4b721f420103	Identificacion de entidades y relaciones	Define entidades, atributos y cardinalidades.	100.00	t	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999
8b332f3c-5ea5-4352-b187-c4229c95f95e	156c1508-353e-47c7-87fc-1c54d2a01a98	Claridad y argumentación	\N	100.00	f	2026-05-05 10:57:08.158343	2026-05-05 10:57:08.158343
4ff15b00-c16d-47d4-a058-4931638ff055	7cc10cd1-a5e9-4dfd-962d-7a2dd5b7fc51	Análisis y solución	\N	100.00	f	2026-05-05 11:00:47.889227	2026-05-05 11:00:47.889227
c6bc815c-218d-4195-85d0-3caaa2cabadd	55a7b7d9-4b11-42e2-93a2-4a3758c287d3	Participación y responsabilidad	\N	100.00	f	2026-05-05 11:00:53.180322	2026-05-05 11:00:53.180322
77c1ee6a-52bb-4fbd-8018-599b21c59fbf	156c1508-353e-47c7-87fc-1c54d2a01a98	Nose	Tampoco se	50.00	f	2026-05-07 04:35:41.22245	2026-05-07 04:35:41.22245
\.


--
-- Data for Name: cursos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cursos (id, nombre, codigo, descripcion, docente_id, estado, fecha_creacion) FROM stdin;
7ab7dd0e-b224-4b3a-81ca-34d47dd61f45	Programación I	PROG-101	\N	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	activo	2026-04-27 02:35:32.58094
02733032-caf9-49d6-8c56-e7a703ca0466	Base de Datos	BD-201	\N	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	activo	2026-04-27 02:35:32.58094
957e7af6-f3b9-47fb-8ff5-e9926b40edcb	Web Avanzado	WEB-301	\N	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	inactivo	2026-04-27 02:35:32.58094
\.


--
-- Data for Name: docente_curso; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.docente_curso (id, docente_id, curso_id, fecha_asignacion) FROM stdin;
bac13143-6187-4c71-99df-087f2eddb47d	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	7ab7dd0e-b224-4b3a-81ca-34d47dd61f45	2026-05-01 15:49:18.915999
b57b9fe6-c759-4531-9858-e4af195a3211	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	02733032-caf9-49d6-8c56-e7a703ca0466	2026-05-01 15:49:18.915999
23c67fd6-34e8-43bc-a5bd-bea596f3485b	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	957e7af6-f3b9-47fb-8ff5-e9926b40edcb	2026-05-01 15:49:18.915999
\.


--
-- Data for Name: estudiante_curso; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.estudiante_curso (id, estudiante_id, curso_id, fecha_matricula) FROM stdin;
c7230764-a48f-4762-ae1c-ed14ed813dc6	cb45271c-dd6c-4cf9-a063-21a5b540bc32	7ab7dd0e-b224-4b3a-81ca-34d47dd61f45	2026-05-01 15:49:18.915999
a091ec3d-8dc6-4e13-94f3-22522297589b	cb45271c-dd6c-4cf9-a063-21a5b540bc32	02733032-caf9-49d6-8c56-e7a703ca0466	2026-05-01 15:49:18.915999
c6141847-e4fb-42ff-968d-9013493b4802	cb45271c-dd6c-4cf9-a063-21a5b540bc32	957e7af6-f3b9-47fb-8ff5-e9926b40edcb	2026-05-01 15:49:18.915999
a603c80a-380f-4bd2-8144-f0328b85c458	07349913-b823-49e2-b3db-0b91dee5be95	7ab7dd0e-b224-4b3a-81ca-34d47dd61f45	2026-05-01 15:49:18.915999
7b8245c8-e5bd-4bb3-b3c5-983f97ad6a79	07349913-b823-49e2-b3db-0b91dee5be95	02733032-caf9-49d6-8c56-e7a703ca0466	2026-05-01 15:49:18.915999
03352bcf-900b-48e6-a50e-231c46c08483	07349913-b823-49e2-b3db-0b91dee5be95	957e7af6-f3b9-47fb-8ff5-e9926b40edcb	2026-05-01 15:49:18.915999
46007bd8-a275-47da-89ca-2678b085a219	b0c039cb-87d6-48f8-8da1-b3fb51a841d9	7ab7dd0e-b224-4b3a-81ca-34d47dd61f45	2026-05-01 15:49:18.915999
2a54e62f-6bc8-46bd-be10-4fab1aa5aa7c	b0c039cb-87d6-48f8-8da1-b3fb51a841d9	02733032-caf9-49d6-8c56-e7a703ca0466	2026-05-01 15:49:18.915999
ded21f03-4075-4383-8799-d9952d46d298	b0c039cb-87d6-48f8-8da1-b3fb51a841d9	957e7af6-f3b9-47fb-8ff5-e9926b40edcb	2026-05-01 15:49:18.915999
a0cefb14-119d-4d94-a7e4-75d205970460	6ae5e88e-52df-4b57-836e-a88795849517	7ab7dd0e-b224-4b3a-81ca-34d47dd61f45	2026-05-01 15:49:18.915999
e09d8a69-557a-4c25-a715-52376ea131ff	6ae5e88e-52df-4b57-836e-a88795849517	02733032-caf9-49d6-8c56-e7a703ca0466	2026-05-01 15:49:18.915999
b19e88ee-f180-449f-b4b0-a41e9d6e2fb8	6ae5e88e-52df-4b57-836e-a88795849517	957e7af6-f3b9-47fb-8ff5-e9926b40edcb	2026-05-01 15:49:18.915999
454c37b2-754a-41a2-a4e4-386b5782c82a	d28c16f6-36f6-41c4-9f1b-9dc98d435a62	7ab7dd0e-b224-4b3a-81ca-34d47dd61f45	2026-05-01 15:49:18.915999
ab6a5b84-42b8-4732-be10-1724100d740e	d28c16f6-36f6-41c4-9f1b-9dc98d435a62	02733032-caf9-49d6-8c56-e7a703ca0466	2026-05-01 15:49:18.915999
d07edb2b-b484-46d0-bd56-768f77d51445	d28c16f6-36f6-41c4-9f1b-9dc98d435a62	957e7af6-f3b9-47fb-8ff5-e9926b40edcb	2026-05-01 15:49:18.915999
4ec243c0-762b-4fb9-8eba-cb0979f3b231	cd1c0e10-48e1-4123-9c0b-6dfa69751676	7ab7dd0e-b224-4b3a-81ca-34d47dd61f45	2026-05-01 15:49:18.915999
1b281169-8582-4a71-abc2-ece50612e112	cd1c0e10-48e1-4123-9c0b-6dfa69751676	02733032-caf9-49d6-8c56-e7a703ca0466	2026-05-01 15:49:18.915999
1a21f92f-01c4-44e2-ae0e-5b284f22e118	cd1c0e10-48e1-4123-9c0b-6dfa69751676	957e7af6-f3b9-47fb-8ff5-e9926b40edcb	2026-05-01 15:49:18.915999
0ce91792-be9f-456a-b909-8b8bdf7c48f1	b338bdf1-8943-4b46-83b1-8fc5315c456e	7ab7dd0e-b224-4b3a-81ca-34d47dd61f45	2026-05-01 15:49:18.915999
17ca37f9-b3d9-4c69-b6d3-683d445038b5	b338bdf1-8943-4b46-83b1-8fc5315c456e	02733032-caf9-49d6-8c56-e7a703ca0466	2026-05-01 15:49:18.915999
cc2e1b5f-bc46-4185-b8c5-723f42cc0412	b338bdf1-8943-4b46-83b1-8fc5315c456e	957e7af6-f3b9-47fb-8ff5-e9926b40edcb	2026-05-01 15:49:18.915999
15c84078-40d2-486d-bbdd-2a2fa76b5770	62515288-7ece-48cc-af13-bf8359872434	7ab7dd0e-b224-4b3a-81ca-34d47dd61f45	2026-05-01 15:49:18.915999
7d5f7079-e417-44f6-ad00-4f73a3bd64ca	62515288-7ece-48cc-af13-bf8359872434	02733032-caf9-49d6-8c56-e7a703ca0466	2026-05-01 15:49:18.915999
fb886acb-f0bf-4806-96a6-e06f8c9f90be	62515288-7ece-48cc-af13-bf8359872434	957e7af6-f3b9-47fb-8ff5-e9926b40edcb	2026-05-01 15:49:18.915999
cc56c7c5-c6db-42ee-a806-beb0f0386f05	44be7b74-1260-46dd-8dfb-d00bebb8bfe7	7ab7dd0e-b224-4b3a-81ca-34d47dd61f45	2026-05-01 15:49:18.915999
44140efb-e7e5-4807-9841-e1e6f1a86309	44be7b74-1260-46dd-8dfb-d00bebb8bfe7	02733032-caf9-49d6-8c56-e7a703ca0466	2026-05-01 15:49:18.915999
54f90396-03c6-440d-9574-aa9b12dd01ce	44be7b74-1260-46dd-8dfb-d00bebb8bfe7	957e7af6-f3b9-47fb-8ff5-e9926b40edcb	2026-05-01 15:49:18.915999
cbcb6e23-cdcd-42af-b6bd-292f0f38f087	1f3ead0e-eaf7-4da9-a638-443c1be2aebf	7ab7dd0e-b224-4b3a-81ca-34d47dd61f45	2026-05-01 15:49:18.915999
c4b6344a-fcfe-465e-ad99-0ea13655dbd6	1f3ead0e-eaf7-4da9-a638-443c1be2aebf	02733032-caf9-49d6-8c56-e7a703ca0466	2026-05-01 15:49:18.915999
bd9903ae-e7d7-42ed-ac39-5fa3d3c5280a	1f3ead0e-eaf7-4da9-a638-443c1be2aebf	957e7af6-f3b9-47fb-8ff5-e9926b40edcb	2026-05-01 15:49:18.915999
c23e7b8e-b039-4f3e-be43-e28eb25b9b58	6941db3c-5b29-4671-bfb9-320c75ff89c4	7ab7dd0e-b224-4b3a-81ca-34d47dd61f45	2026-05-01 15:49:18.915999
b15dfee5-bb7f-4f93-80e3-6a283922ffce	6941db3c-5b29-4671-bfb9-320c75ff89c4	02733032-caf9-49d6-8c56-e7a703ca0466	2026-05-01 15:49:18.915999
8a7e89cd-4208-4ee2-b5dd-ff556e27c1a3	6941db3c-5b29-4671-bfb9-320c75ff89c4	957e7af6-f3b9-47fb-8ff5-e9926b40edcb	2026-05-01 15:49:18.915999
733723b0-a39f-4e2c-8376-d8ce2493897a	5255b0d0-ac71-40a0-84e6-8e5af4cd03dd	7ab7dd0e-b224-4b3a-81ca-34d47dd61f45	2026-05-01 15:49:18.915999
ea129361-1267-424d-8490-18d5179fc0d7	5255b0d0-ac71-40a0-84e6-8e5af4cd03dd	02733032-caf9-49d6-8c56-e7a703ca0466	2026-05-01 15:49:18.915999
68bfe4d0-9087-40ec-9fa2-018878f247f5	5255b0d0-ac71-40a0-84e6-8e5af4cd03dd	957e7af6-f3b9-47fb-8ff5-e9926b40edcb	2026-05-01 15:49:18.915999
83faf7ad-0ccf-4086-a344-d1192c771c68	9a3edf62-5da6-4102-88d9-b9702f2c451e	7ab7dd0e-b224-4b3a-81ca-34d47dd61f45	2026-05-01 15:49:18.915999
b6722d9e-a4c4-4f00-91c9-45e40277f6e2	9a3edf62-5da6-4102-88d9-b9702f2c451e	02733032-caf9-49d6-8c56-e7a703ca0466	2026-05-01 15:49:18.915999
e4e19ce0-317d-482f-8108-fb45df4a6f49	9a3edf62-5da6-4102-88d9-b9702f2c451e	957e7af6-f3b9-47fb-8ff5-e9926b40edcb	2026-05-01 15:49:18.915999
38d4f22f-a098-40bf-bfe9-adc120158180	76542e5b-958f-4a97-9a56-b2eb23fe5d50	7ab7dd0e-b224-4b3a-81ca-34d47dd61f45	2026-05-01 15:49:18.915999
07ef59e8-42b2-4c28-9daf-7c058580c9ae	76542e5b-958f-4a97-9a56-b2eb23fe5d50	02733032-caf9-49d6-8c56-e7a703ca0466	2026-05-01 15:49:18.915999
1af2ae37-9d95-490b-b33a-1b17a6948c53	76542e5b-958f-4a97-9a56-b2eb23fe5d50	957e7af6-f3b9-47fb-8ff5-e9926b40edcb	2026-05-01 15:49:18.915999
4bc2831c-7eea-4c97-8997-22485b4644c5	3b65f5af-5a4d-4d74-bd1f-2a3025412f06	7ab7dd0e-b224-4b3a-81ca-34d47dd61f45	2026-05-01 15:49:18.915999
c0f6c1a3-b138-46d8-b666-ddf67c927728	3b65f5af-5a4d-4d74-bd1f-2a3025412f06	02733032-caf9-49d6-8c56-e7a703ca0466	2026-05-01 15:49:18.915999
09a4748e-1438-40fc-a92c-3c43ed1e39f9	3b65f5af-5a4d-4d74-bd1f-2a3025412f06	957e7af6-f3b9-47fb-8ff5-e9926b40edcb	2026-05-01 15:49:18.915999
8c58fe35-cf90-4926-a02a-982fea39aaa1	880f1b10-6a6d-4144-bbb5-17281b801f59	7ab7dd0e-b224-4b3a-81ca-34d47dd61f45	2026-05-01 15:49:18.915999
c45a22f3-7069-439a-949a-2c2fc0e0dd50	880f1b10-6a6d-4144-bbb5-17281b801f59	02733032-caf9-49d6-8c56-e7a703ca0466	2026-05-01 15:49:18.915999
8bb426f8-7f64-4c0b-9c69-07ffb5f2ec55	880f1b10-6a6d-4144-bbb5-17281b801f59	957e7af6-f3b9-47fb-8ff5-e9926b40edcb	2026-05-01 15:49:18.915999
3e8a4035-cfab-47f1-b43e-9f83aa10d25e	e67826a2-3c40-4e3a-b6b6-046968b1ecdd	7ab7dd0e-b224-4b3a-81ca-34d47dd61f45	2026-05-01 15:49:18.915999
f327a332-5d37-4f58-b558-8c40f40010a2	e67826a2-3c40-4e3a-b6b6-046968b1ecdd	02733032-caf9-49d6-8c56-e7a703ca0466	2026-05-01 15:49:18.915999
37515dfc-938b-4210-9348-ad8cde06d77d	e67826a2-3c40-4e3a-b6b6-046968b1ecdd	957e7af6-f3b9-47fb-8ff5-e9926b40edcb	2026-05-01 15:49:18.915999
6fd88ca2-c102-41d8-b205-95abb6e946ff	7332bffc-f65e-4b47-a800-5f5871dd1ff1	7ab7dd0e-b224-4b3a-81ca-34d47dd61f45	2026-05-01 15:49:18.915999
67761e0f-6f7e-45d9-af0e-ec956e69c469	7332bffc-f65e-4b47-a800-5f5871dd1ff1	02733032-caf9-49d6-8c56-e7a703ca0466	2026-05-01 15:49:18.915999
88431ae0-e4a7-4848-94be-431fde5f3781	7332bffc-f65e-4b47-a800-5f5871dd1ff1	957e7af6-f3b9-47fb-8ff5-e9926b40edcb	2026-05-01 15:49:18.915999
5d9c30c8-2190-4c05-bfef-a53a0b999ad2	e8bac2f2-ae10-4de3-beea-824bd74aad7f	7ab7dd0e-b224-4b3a-81ca-34d47dd61f45	2026-05-01 15:49:18.915999
50b8998e-05c9-479a-925c-131da4609ae0	e8bac2f2-ae10-4de3-beea-824bd74aad7f	02733032-caf9-49d6-8c56-e7a703ca0466	2026-05-01 15:49:18.915999
77226ea8-7e27-4cca-be9a-c1ba1492d526	e8bac2f2-ae10-4de3-beea-824bd74aad7f	957e7af6-f3b9-47fb-8ff5-e9926b40edcb	2026-05-01 15:49:18.915999
7520572c-ccae-4558-9ecc-c4f3ced53a6b	b4310a5f-014b-40be-b5e5-ff8f0f186ac3	7ab7dd0e-b224-4b3a-81ca-34d47dd61f45	2026-05-01 15:49:18.915999
9b4f09ff-f995-4d81-8254-aa250974fb23	b4310a5f-014b-40be-b5e5-ff8f0f186ac3	02733032-caf9-49d6-8c56-e7a703ca0466	2026-05-01 15:49:18.915999
ee19c659-f501-4f79-8f3e-a7e028d31302	b4310a5f-014b-40be-b5e5-ff8f0f186ac3	957e7af6-f3b9-47fb-8ff5-e9926b40edcb	2026-05-01 15:49:18.915999
4b1e4daf-af60-4fc9-93ad-b127448fe425	2088677b-a9ed-41c2-b7cf-6b1c0f67340a	7ab7dd0e-b224-4b3a-81ca-34d47dd61f45	2026-05-01 15:49:18.915999
24bfcde3-c9a5-4467-a810-14a74ace0e48	2088677b-a9ed-41c2-b7cf-6b1c0f67340a	02733032-caf9-49d6-8c56-e7a703ca0466	2026-05-01 15:49:18.915999
0fc83f16-669e-46b9-ad6b-2b2b36c133ea	2088677b-a9ed-41c2-b7cf-6b1c0f67340a	957e7af6-f3b9-47fb-8ff5-e9926b40edcb	2026-05-01 15:49:18.915999
\.


--
-- Data for Name: evaluation_metadata; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.evaluation_metadata (id, evaluacion_id, docente_id, tiempo_inicio, tiempo_fin, duracion_segundos, fecha_creacion) FROM stdin;
\.


--
-- Data for Name: evaluations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.evaluations (id, criteria_id, student_id, activity_id, grade, observation, teacher_id, grading_date, created_at, updated_at) FROM stdin;
158bb40b-a34f-4aa2-90be-29835d3ad6bf	8b332f3c-5ea5-4352-b187-c4229c95f95e	cb45271c-dd6c-4cf9-a063-21a5b540bc32	661d56a6-b36b-4308-af40-ccebc9056269	96.00	Demo: calificación precargada para presentación.	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	2026-05-05 07:00:40.686118	2026-05-05 11:00:41.413777	2026-05-05 11:00:41.413777
195cf7e3-2460-44fa-b731-73952b3b8148	8b332f3c-5ea5-4352-b187-c4229c95f95e	07349913-b823-49e2-b3db-0b91dee5be95	661d56a6-b36b-4308-af40-ccebc9056269	88.00	Demo: calificación precargada para presentación.	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	2026-05-05 07:00:41.226181	2026-05-05 11:00:41.951786	2026-05-05 11:00:41.951786
80956dd1-433f-4ce3-be43-00383dec61a5	8b332f3c-5ea5-4352-b187-c4229c95f95e	b0c039cb-87d6-48f8-8da1-b3fb51a841d9	661d56a6-b36b-4308-af40-ccebc9056269	78.00	Demo: calificación precargada para presentación.	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	2026-05-05 07:00:41.736569	2026-05-05 11:00:42.457119	2026-05-05 11:00:42.457119
e23d50b8-1916-40e6-b905-d03005b2beea	8b332f3c-5ea5-4352-b187-c4229c95f95e	6ae5e88e-52df-4b57-836e-a88795849517	661d56a6-b36b-4308-af40-ccebc9056269	67.00	Demo: calificación precargada para presentación.	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	2026-05-05 07:00:42.249173	2026-05-05 11:00:42.969116	2026-05-05 11:00:42.969116
a786ef3e-9b12-48e4-bca1-eac3b7ec1411	8b332f3c-5ea5-4352-b187-c4229c95f95e	d28c16f6-36f6-41c4-9f1b-9dc98d435a62	661d56a6-b36b-4308-af40-ccebc9056269	54.00	Demo: calificación precargada para presentación.	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	2026-05-05 07:00:42.814059	2026-05-05 11:00:43.539565	2026-05-05 11:00:43.539565
f61df21a-1631-44af-ab6a-60ab8b3c857e	8b332f3c-5ea5-4352-b187-c4229c95f95e	cd1c0e10-48e1-4123-9c0b-6dfa69751676	661d56a6-b36b-4308-af40-ccebc9056269	92.00	Demo: calificación precargada para presentación.	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	2026-05-05 07:00:43.333596	2026-05-05 11:00:44.055668	2026-05-05 11:00:44.055668
767b1169-6e85-4113-85ad-115058ee4314	8b332f3c-5ea5-4352-b187-c4229c95f95e	b338bdf1-8943-4b46-83b1-8fc5315c456e	661d56a6-b36b-4308-af40-ccebc9056269	73.00	Demo: calificación precargada para presentación.	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	2026-05-05 07:00:43.857478	2026-05-05 11:00:44.580408	2026-05-05 11:00:44.580408
69c9b033-ae34-4ec7-8067-3ef1d3dd57bf	8b332f3c-5ea5-4352-b187-c4229c95f95e	62515288-7ece-48cc-af13-bf8359872434	661d56a6-b36b-4308-af40-ccebc9056269	61.00	Demo: calificación precargada para presentación.	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	2026-05-05 07:00:44.364828	2026-05-05 11:00:45.086311	2026-05-05 11:00:45.086311
906217f4-36c8-48ea-b969-29848173a235	8b332f3c-5ea5-4352-b187-c4229c95f95e	44be7b74-1260-46dd-8dfb-d00bebb8bfe7	661d56a6-b36b-4308-af40-ccebc9056269	96.00	Demo: calificación precargada para presentación.	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	2026-05-05 07:00:44.877094	2026-05-05 11:00:45.600326	2026-05-05 11:00:45.600326
867eba0d-7a8f-4b80-b1cc-e606595f1339	8b332f3c-5ea5-4352-b187-c4229c95f95e	1f3ead0e-eaf7-4da9-a638-443c1be2aebf	661d56a6-b36b-4308-af40-ccebc9056269	88.00	Demo: calificación precargada para presentación.	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	2026-05-05 07:00:45.394735	2026-05-05 11:00:46.116762	2026-05-05 11:00:46.116762
ba03f69c-9f8b-40fc-80cf-a71560361196	8b332f3c-5ea5-4352-b187-c4229c95f95e	6941db3c-5b29-4671-bfb9-320c75ff89c4	661d56a6-b36b-4308-af40-ccebc9056269	78.00	Demo: calificación precargada para presentación.	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	2026-05-05 07:00:46.20889	2026-05-05 11:00:46.935357	2026-05-05 11:00:46.935357
682a8d23-10e8-4efb-9580-a1ed19fa3f65	4ff15b00-c16d-47d4-a058-4931638ff055	cb45271c-dd6c-4cf9-a063-21a5b540bc32	697d82f2-cd7a-4705-a72e-bb52d771565b	88.00	Demo: calificación precargada para presentación.	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	2026-05-05 07:00:47.796884	2026-05-05 11:00:48.524507	2026-05-05 11:00:48.524507
48c43053-f4ab-4bef-8132-d233b1eea2d6	4ff15b00-c16d-47d4-a058-4931638ff055	07349913-b823-49e2-b3db-0b91dee5be95	697d82f2-cd7a-4705-a72e-bb52d771565b	78.00	Demo: calificación precargada para presentación.	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	2026-05-05 07:00:48.192306	2026-05-05 11:00:48.914824	2026-05-05 11:00:48.914824
4247c264-c54a-4d18-81f4-0f1e8ac48bc1	4ff15b00-c16d-47d4-a058-4931638ff055	b0c039cb-87d6-48f8-8da1-b3fb51a841d9	697d82f2-cd7a-4705-a72e-bb52d771565b	67.00	Demo: calificación precargada para presentación.	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	2026-05-05 07:00:48.603211	2026-05-05 11:00:49.343911	2026-05-05 11:00:49.343911
fb921c7e-d24c-4e90-94b4-e3b2512df9a9	4ff15b00-c16d-47d4-a058-4931638ff055	6ae5e88e-52df-4b57-836e-a88795849517	697d82f2-cd7a-4705-a72e-bb52d771565b	54.00	Demo: calificación precargada para presentación.	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	2026-05-05 07:00:49.039213	2026-05-05 11:00:49.763973	2026-05-05 11:00:49.763973
05a68f8f-5edd-466f-9302-98158f5da1b9	4ff15b00-c16d-47d4-a058-4931638ff055	d28c16f6-36f6-41c4-9f1b-9dc98d435a62	697d82f2-cd7a-4705-a72e-bb52d771565b	92.00	Demo: calificación precargada para presentación.	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	2026-05-05 07:00:49.412824	2026-05-05 11:00:50.143511	2026-05-05 11:00:50.143511
3cabedd3-67b6-40e8-90cd-36e337d865bb	4ff15b00-c16d-47d4-a058-4931638ff055	cd1c0e10-48e1-4123-9c0b-6dfa69751676	697d82f2-cd7a-4705-a72e-bb52d771565b	73.00	Demo: calificación precargada para presentación.	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	2026-05-05 07:00:49.805715	2026-05-05 11:00:50.526491	2026-05-05 11:00:50.526491
75389b6f-c735-42e9-9c67-ba282d066cf4	4ff15b00-c16d-47d4-a058-4931638ff055	b338bdf1-8943-4b46-83b1-8fc5315c456e	697d82f2-cd7a-4705-a72e-bb52d771565b	61.00	Demo: calificación precargada para presentación.	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	2026-05-05 07:00:50.170247	2026-05-05 11:00:50.903335	2026-05-05 11:00:50.903335
7ab21962-6684-4fec-9f67-9eb1b895f5a9	4ff15b00-c16d-47d4-a058-4931638ff055	62515288-7ece-48cc-af13-bf8359872434	697d82f2-cd7a-4705-a72e-bb52d771565b	96.00	Demo: calificación precargada para presentación.	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	2026-05-05 07:00:50.568286	2026-05-05 11:00:51.28549	2026-05-05 11:00:51.28549
a682d1dc-5063-4083-a438-be06ab40d855	4ff15b00-c16d-47d4-a058-4931638ff055	44be7b74-1260-46dd-8dfb-d00bebb8bfe7	697d82f2-cd7a-4705-a72e-bb52d771565b	88.00	Demo: calificación precargada para presentación.	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	2026-05-05 07:00:50.953477	2026-05-05 11:00:51.677686	2026-05-05 11:00:51.677686
d7c84bec-5367-4151-92fe-4f6554b7c68d	4ff15b00-c16d-47d4-a058-4931638ff055	1f3ead0e-eaf7-4da9-a638-443c1be2aebf	697d82f2-cd7a-4705-a72e-bb52d771565b	78.00	Demo: calificación precargada para presentación.	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	2026-05-05 07:00:51.333713	2026-05-05 11:00:52.054891	2026-05-05 11:00:52.054891
c705d3a8-86ad-47a9-9437-98e63ad6d82c	4ff15b00-c16d-47d4-a058-4931638ff055	6941db3c-5b29-4671-bfb9-320c75ff89c4	697d82f2-cd7a-4705-a72e-bb52d771565b	67.00	Demo: calificación precargada para presentación.	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	2026-05-05 07:00:51.697071	2026-05-05 11:00:52.437077	2026-05-05 11:00:52.437077
16bae962-6d9d-4ca4-b75b-c646fcdcc0ac	c6bc815c-218d-4195-85d0-3caaa2cabadd	cb45271c-dd6c-4cf9-a063-21a5b540bc32	587d122a-087d-4b18-aa19-f4527ea1cc89	78.00	Demo: calificación precargada para presentación.	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	2026-05-05 07:00:53.102577	2026-05-05 11:00:53.820981	2026-05-05 11:00:53.820981
b3220427-a265-4ad6-842e-9d4bfae3e518	c6bc815c-218d-4195-85d0-3caaa2cabadd	07349913-b823-49e2-b3db-0b91dee5be95	587d122a-087d-4b18-aa19-f4527ea1cc89	67.00	Demo: calificación precargada para presentación.	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	2026-05-05 07:00:53.483936	2026-05-05 11:00:54.207606	2026-05-05 11:00:54.207606
3b25aeae-df39-4b14-b890-f45aadf5336a	c6bc815c-218d-4195-85d0-3caaa2cabadd	b0c039cb-87d6-48f8-8da1-b3fb51a841d9	587d122a-087d-4b18-aa19-f4527ea1cc89	54.00	Demo: calificación precargada para presentación.	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	2026-05-05 07:00:53.871415	2026-05-05 11:00:54.592167	2026-05-05 11:00:54.592167
3ea96d72-1a19-4805-aeb5-f2b3246410ee	c6bc815c-218d-4195-85d0-3caaa2cabadd	6ae5e88e-52df-4b57-836e-a88795849517	587d122a-087d-4b18-aa19-f4527ea1cc89	92.00	Demo: calificación precargada para presentación.	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	2026-05-05 07:00:54.234271	2026-05-05 11:00:54.967989	2026-05-05 11:00:54.967989
b27424c3-bd40-422d-b66d-729d19c476a3	c6bc815c-218d-4195-85d0-3caaa2cabadd	d28c16f6-36f6-41c4-9f1b-9dc98d435a62	587d122a-087d-4b18-aa19-f4527ea1cc89	73.00	Demo: calificación precargada para presentación.	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	2026-05-05 07:00:54.864222	2026-05-05 11:00:55.580382	2026-05-05 11:00:55.580382
dc4155b3-0d23-4e46-ae11-69988e7fabc7	c6bc815c-218d-4195-85d0-3caaa2cabadd	cd1c0e10-48e1-4123-9c0b-6dfa69751676	587d122a-087d-4b18-aa19-f4527ea1cc89	61.00	Demo: calificación precargada para presentación.	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	2026-05-05 07:00:55.23776	2026-05-05 11:00:55.982617	2026-05-05 11:00:55.982617
65d5e3cb-154e-4464-8c8d-7ad855587637	c6bc815c-218d-4195-85d0-3caaa2cabadd	b338bdf1-8943-4b46-83b1-8fc5315c456e	587d122a-087d-4b18-aa19-f4527ea1cc89	96.00	Demo: calificación precargada para presentación.	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	2026-05-05 07:00:55.627979	2026-05-05 11:00:56.362313	2026-05-05 11:00:56.362313
6e29e0bb-3ccd-421b-bd73-35ca104141ec	c6bc815c-218d-4195-85d0-3caaa2cabadd	62515288-7ece-48cc-af13-bf8359872434	587d122a-087d-4b18-aa19-f4527ea1cc89	88.00	Demo: calificación precargada para presentación.	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	2026-05-05 07:00:56.008797	2026-05-05 11:00:56.741806	2026-05-05 11:00:56.741806
8b921029-60b8-4827-9010-2be1fb3504f5	c6bc815c-218d-4195-85d0-3caaa2cabadd	1f3ead0e-eaf7-4da9-a638-443c1be2aebf	587d122a-087d-4b18-aa19-f4527ea1cc89	67.00	Demo: calificación precargada para presentación.	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	2026-05-05 07:00:57.010334	2026-05-05 11:00:57.732757	2026-05-05 11:00:57.732757
8a3e51eb-1435-4202-8313-0027ca61aff1	c6bc815c-218d-4195-85d0-3caaa2cabadd	44be7b74-1260-46dd-8dfb-d00bebb8bfe7	587d122a-087d-4b18-aa19-f4527ea1cc89	100.00		9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	2026-05-07 04:38:34.625	2026-05-05 11:00:57.098171	2026-05-05 11:00:57.098171
1f110747-0a07-4f65-b0be-4af00b6bf32e	c6bc815c-218d-4195-85d0-3caaa2cabadd	6941db3c-5b29-4671-bfb9-320c75ff89c4	587d122a-087d-4b18-aa19-f4527ea1cc89	50.00		9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	2026-05-07 04:38:58.168	2026-05-05 11:00:58.118197	2026-05-05 11:00:58.118197
\.


--
-- Data for Name: evidence; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.evidence (id, activity_id, student_id, file_url, delivery_date, comment, status, created_at, updated_at, actividad_id) FROM stdin;
b6d609b1-c24c-4689-912e-613844a68875	b3f599c7-824b-48ae-bc99-f75a970991d1	07349913-b823-49e2-b3db-0b91dee5be95	ECommerceEmporium.pdf	2026-04-30 15:23:57.819661	\N	pendiente	2026-04-30 15:23:57.819661	2026-04-30 15:23:57.819661	\N
c8880d64-c6c4-4a8f-9794-033059ff8c39	7acb4a70-9d69-47e7-83aa-4b721f440101	cb45271c-dd6c-4cf9-a063-21a5b540bc32	practica_algoritmos_gabriel.alcala.pdf	2026-05-01 15:49:18.915999	Entrega demo cargada para pruebas.	revisado	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999	\N
a9e54b7b-db0e-432d-9904-b6a1468312b3	7acb4a70-9d69-47e7-83aa-4b721f440101	07349913-b823-49e2-b3db-0b91dee5be95	practica_algoritmos_winniviel.bello.pdf	2026-05-01 15:49:18.915999	Entrega demo cargada para pruebas.	revisado	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999	\N
593ef252-4b57-47b4-ae58-d1153450eb32	7acb4a70-9d69-47e7-83aa-4b721f440101	b0c039cb-87d6-48f8-8da1-b3fb51a841d9	practica_algoritmos_deuli.cruz.pdf	2026-05-01 15:49:18.915999	Entrega demo cargada para pruebas.	revisado	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999	\N
a49be385-04c0-49a7-baf0-f222b6de83a0	7acb4a70-9d69-47e7-83aa-4b721f440101	6ae5e88e-52df-4b57-836e-a88795849517	practica_algoritmos_katherine.cuesta.pdf	2026-05-01 15:49:18.915999	Entrega demo cargada para pruebas.	revisado	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999	\N
fac3fa8a-8c8e-4653-94ab-ecf8e46f7748	7acb4a70-9d69-47e7-83aa-4b721f440101	d28c16f6-36f6-41c4-9f1b-9dc98d435a62	practica_algoritmos_elyin.diaz.pdf	2026-05-01 15:49:18.915999	Entrega demo cargada para pruebas.	revisado	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999	\N
ae57ae47-6231-4c86-bf82-f733a0fc2fbe	7acb4a70-9d69-47e7-83aa-4b721f440101	cd1c0e10-48e1-4123-9c0b-6dfa69751676	practica_algoritmos_juan.felix.pdf	2026-05-01 15:49:18.915999	Entrega demo cargada para pruebas.	revisado	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999	\N
206c2d28-f856-41e6-8275-a9e35825bb52	7acb4a70-9d69-47e7-83aa-4b721f440101	b338bdf1-8943-4b46-83b1-8fc5315c456e	practica_algoritmos_justin.ezequiel.pdf	2026-05-01 15:49:18.915999	Entrega demo cargada para pruebas.	revisado	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999	\N
321ca142-8241-4b2b-89e2-5f2f4ad2fd89	7acb4a70-9d69-47e7-83aa-4b721f440101	62515288-7ece-48cc-af13-bf8359872434	practica_algoritmos_maikel.yael.pdf	2026-05-01 15:49:18.915999	Entrega demo cargada para pruebas.	revisado	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999	\N
61e602a6-4063-416e-beb5-50ed8aa758c8	7acb4a70-9d69-47e7-83aa-4b721f440101	44be7b74-1260-46dd-8dfb-d00bebb8bfe7	practica_algoritmos_carlos.lima.pdf	2026-05-01 15:49:18.915999	Entrega demo cargada para pruebas.	revisado	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999	\N
ccc1103d-0893-4c62-8de9-4df6369c5847	7acb4a70-9d69-47e7-83aa-4b721f440101	1f3ead0e-eaf7-4da9-a638-443c1be2aebf	practica_algoritmos_yeuri.lorenzo.pdf	2026-05-01 15:49:18.915999	Entrega demo cargada para pruebas.	revisado	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999	\N
61491a82-5e58-4444-b705-230c3afbd7d5	7acb4a70-9d69-47e7-83aa-4b721f440101	6941db3c-5b29-4671-bfb9-320c75ff89c4	practica_algoritmos_nashly.magallanes.pdf	2026-05-01 15:49:18.915999	Entrega demo cargada para pruebas.	revisado	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999	\N
e23df9e7-6884-4a73-ad8d-8dc4c7bc0e9a	7acb4a70-9d69-47e7-83aa-4b721f440101	5255b0d0-ac71-40a0-84e6-8e5af4cd03dd	practica_algoritmos_angelo.mancebo.pdf	2026-05-01 15:49:18.915999	Entrega demo cargada para pruebas.	revisado	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999	\N
c4234604-13a7-458a-854c-8ad55f7647d9	7acb4a70-9d69-47e7-83aa-4b721f440101	9a3edf62-5da6-4102-88d9-b9702f2c451e	practica_algoritmos_enrique.ogando.pdf	2026-05-01 15:49:18.915999	Entrega demo cargada para pruebas.	revisado	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999	\N
e02b857f-a477-4f33-a7dd-46312cc26b9f	7acb4a70-9d69-47e7-83aa-4b721f440101	76542e5b-958f-4a97-9a56-b2eb23fe5d50	practica_algoritmos_jose.pichardo.pdf	2026-05-01 15:49:18.915999	Entrega demo cargada para pruebas.	revisado	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999	\N
1b12ae6b-1ea4-4807-9dbe-0764fed71dd3	7acb4a70-9d69-47e7-83aa-4b721f440101	3b65f5af-5a4d-4d74-bd1f-2a3025412f06	practica_algoritmos_ernesto.pichardo.pdf	2026-05-01 15:49:18.915999	Entrega demo cargada para pruebas.	revisado	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999	\N
deb147c5-8086-4947-b161-ca320e53788f	7acb4a70-9d69-47e7-83aa-4b721f440101	880f1b10-6a6d-4144-bbb5-17281b801f59	practica_algoritmos_dustin.polanco.pdf	2026-05-01 15:49:18.915999	Entrega demo cargada para pruebas.	revisado	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999	\N
7f5d32ba-54d4-4b00-a90f-3e09b404adff	7acb4a70-9d69-47e7-83aa-4b721f440101	e67826a2-3c40-4e3a-b6b6-046968b1ecdd	practica_algoritmos_michael.ramirez.pdf	2026-05-01 15:49:18.915999	Entrega demo cargada para pruebas.	revisado	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999	\N
c2aafd49-dbb8-485d-9182-0ed68dde37f7	7acb4a70-9d69-47e7-83aa-4b721f440101	7332bffc-f65e-4b47-a800-5f5871dd1ff1	practica_algoritmos_eliezer.jesus.pdf	2026-05-01 15:49:18.915999	Entrega demo cargada para pruebas.	revisado	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999	\N
d359303f-5184-42e4-9697-fd54451bc172	7acb4a70-9d69-47e7-83aa-4b721f440101	e8bac2f2-ae10-4de3-beea-824bd74aad7f	practica_algoritmos_jeremy.manuel.pdf	2026-05-01 15:49:18.915999	Entrega demo cargada para pruebas.	revisado	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999	\N
7aee5031-0e9a-4dcf-aaaf-47e88c079ff3	7acb4a70-9d69-47e7-83aa-4b721f440101	b4310a5f-014b-40be-b5e5-ff8f0f186ac3	practica_algoritmos_ashly.reding.pdf	2026-05-01 15:49:18.915999	Entrega demo cargada para pruebas.	revisado	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999	\N
2f7c8de9-df0f-4cb5-8f20-943fb41eda06	7acb4a70-9d69-47e7-83aa-4b721f440101	2088677b-a9ed-41c2-b7cf-6b1c0f67340a	practica_algoritmos_gianni.subervi.pdf	2026-05-01 15:49:18.915999	Entrega demo cargada para pruebas.	revisado	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999	\N
dbfc6928-c1d9-4c2f-95af-2bde587774b5	cc1c4e5e-58ab-4884-a415-7abbc22951a9	44be7b74-1260-46dd-8dfb-d00bebb8bfe7	Captura de pantalla 2026-05-04 180108.png	2026-05-05 00:40:04.269307	\N	pendiente	2026-05-05 00:40:04.269307	2026-05-05 00:40:04.269307	\N
15fec690-8aa2-4af3-afb2-5e657f1ab2cf	15597c90-8d1a-4618-ab03-0a707332423c	44be7b74-1260-46dd-8dfb-d00bebb8bfe7	Captura de pantalla 2026-02-01 135719.png	2026-05-05 10:38:07.158095	\N	pendiente	2026-05-05 10:38:07.158095	2026-05-05 10:38:07.158095	\N
8da211e2-4d46-4ca6-8cf2-b5eab6640bfb	661d56a6-b36b-4308-af40-ccebc9056269	cb45271c-dd6c-4cf9-a063-21a5b540bc32	demo_evidencia_gabriel_elias_alcala_aquino.pdf	2026-05-05 11:00:41.140719	\N	pendiente	2026-05-05 11:00:41.140719	2026-05-05 11:00:41.140719	\N
72dceb0a-3d09-479d-9f84-9d1f47bb96e0	661d56a6-b36b-4308-af40-ccebc9056269	07349913-b823-49e2-b3db-0b91dee5be95	demo_evidencia_winniviel_bello.pdf	2026-05-05 11:00:41.809735	\N	pendiente	2026-05-05 11:00:41.809735	2026-05-05 11:00:41.809735	\N
c0dccd5b-aab6-401d-8dfc-1d2b3497d118	661d56a6-b36b-4308-af40-ccebc9056269	b0c039cb-87d6-48f8-8da1-b3fb51a841d9	demo_evidencia_deuli_de_la_cruz_ramirez.pdf	2026-05-05 11:00:42.32912	\N	pendiente	2026-05-05 11:00:42.32912	2026-05-05 11:00:42.32912	\N
879b0fd8-08ed-4f68-8032-5e8f26d85478	661d56a6-b36b-4308-af40-ccebc9056269	6ae5e88e-52df-4b57-836e-a88795849517	demo_evidencia_katherine_marie_cuesta_marte.pdf	2026-05-05 11:00:42.834525	\N	pendiente	2026-05-05 11:00:42.834525	2026-05-05 11:00:42.834525	\N
afd632c8-7ad3-4755-94df-0539809cd472	661d56a6-b36b-4308-af40-ccebc9056269	d28c16f6-36f6-41c4-9f1b-9dc98d435a62	demo_evidencia_elyin_emmanuel_diaz_adamez.pdf	2026-05-05 11:00:43.394622	\N	pendiente	2026-05-05 11:00:43.394622	2026-05-05 11:00:43.394622	\N
b3b79d94-8a27-4bc0-bcc2-b075eba4d0af	661d56a6-b36b-4308-af40-ccebc9056269	cd1c0e10-48e1-4123-9c0b-6dfa69751676	demo_evidencia_juan_armando_felix_norberto.pdf	2026-05-05 11:00:43.932731	\N	pendiente	2026-05-05 11:00:43.932731	2026-05-05 11:00:43.932731	\N
5dac087a-bf34-4dd3-b016-00b8efb8ffd7	661d56a6-b36b-4308-af40-ccebc9056269	b338bdf1-8943-4b46-83b1-8fc5315c456e	demo_evidencia_justin_ezequiel.pdf	2026-05-05 11:00:44.454347	\N	pendiente	2026-05-05 11:00:44.454347	2026-05-05 11:00:44.454347	\N
68f9d5e9-f31d-462a-b595-2587465b0fba	661d56a6-b36b-4308-af40-ccebc9056269	62515288-7ece-48cc-af13-bf8359872434	demo_evidencia_maikel_yael.pdf	2026-05-05 11:00:44.961929	\N	pendiente	2026-05-05 11:00:44.961929	2026-05-05 11:00:44.961929	\N
da94d716-8343-4fe5-9e83-106f89ff2ea2	661d56a6-b36b-4308-af40-ccebc9056269	44be7b74-1260-46dd-8dfb-d00bebb8bfe7	demo_evidencia_carlos_miguel_lima_camacho.pdf	2026-05-05 11:00:45.475917	\N	pendiente	2026-05-05 11:00:45.475917	2026-05-05 11:00:45.475917	\N
b99faf01-8888-43fd-aa4f-2c74fc040473	661d56a6-b36b-4308-af40-ccebc9056269	1f3ead0e-eaf7-4da9-a638-443c1be2aebf	demo_evidencia_yeuri_lorenzo_diaz.pdf	2026-05-05 11:00:45.994439	\N	pendiente	2026-05-05 11:00:45.994439	2026-05-05 11:00:45.994439	\N
b1394f2d-28b4-4466-8937-be74e218560d	661d56a6-b36b-4308-af40-ccebc9056269	6941db3c-5b29-4671-bfb9-320c75ff89c4	demo_evidencia_nashly_adriana_magallanes_feliz.pdf	2026-05-05 11:00:46.805922	\N	pendiente	2026-05-05 11:00:46.805922	2026-05-05 11:00:46.805922	\N
de3f7d3b-9807-4b0c-a783-681312829f4d	697d82f2-cd7a-4705-a72e-bb52d771565b	cb45271c-dd6c-4cf9-a063-21a5b540bc32	demo_evidencia_gabriel_elias_alcala_aquino.pdf	2026-05-05 11:00:48.398484	\N	pendiente	2026-05-05 11:00:48.398484	2026-05-05 11:00:48.398484	\N
7a0132d6-d267-40b6-b5fb-a1277d467d13	697d82f2-cd7a-4705-a72e-bb52d771565b	07349913-b823-49e2-b3db-0b91dee5be95	demo_evidencia_winniviel_bello.pdf	2026-05-05 11:00:48.790053	\N	pendiente	2026-05-05 11:00:48.790053	2026-05-05 11:00:48.790053	\N
0a8c2d75-41d8-45ab-8a75-b328b339b9da	697d82f2-cd7a-4705-a72e-bb52d771565b	b0c039cb-87d6-48f8-8da1-b3fb51a841d9	demo_evidencia_deuli_de_la_cruz_ramirez.pdf	2026-05-05 11:00:49.171196	\N	pendiente	2026-05-05 11:00:49.171196	2026-05-05 11:00:49.171196	\N
fb335af0-febd-4d40-b252-8fdb2ce7cb70	697d82f2-cd7a-4705-a72e-bb52d771565b	6ae5e88e-52df-4b57-836e-a88795849517	demo_evidencia_katherine_marie_cuesta_marte.pdf	2026-05-05 11:00:49.622552	\N	pendiente	2026-05-05 11:00:49.622552	2026-05-05 11:00:49.622552	\N
b4a449da-2848-4531-bca5-3e620d076feb	697d82f2-cd7a-4705-a72e-bb52d771565b	d28c16f6-36f6-41c4-9f1b-9dc98d435a62	demo_evidencia_elyin_emmanuel_diaz_adamez.pdf	2026-05-05 11:00:50.016972	\N	pendiente	2026-05-05 11:00:50.016972	2026-05-05 11:00:50.016972	\N
59bc96ba-e1c7-4f2c-a82a-1a9f91216e0b	697d82f2-cd7a-4705-a72e-bb52d771565b	cd1c0e10-48e1-4123-9c0b-6dfa69751676	demo_evidencia_juan_armando_felix_norberto.pdf	2026-05-05 11:00:50.404604	\N	pendiente	2026-05-05 11:00:50.404604	2026-05-05 11:00:50.404604	\N
a64ec7c5-490d-4c2f-815c-519e556e28fd	697d82f2-cd7a-4705-a72e-bb52d771565b	b338bdf1-8943-4b46-83b1-8fc5315c456e	demo_evidencia_justin_ezequiel.pdf	2026-05-05 11:00:50.765452	\N	pendiente	2026-05-05 11:00:50.765452	2026-05-05 11:00:50.765452	\N
9cfe2d0c-c8ad-48b2-bdb7-df8b88b32587	697d82f2-cd7a-4705-a72e-bb52d771565b	62515288-7ece-48cc-af13-bf8359872434	demo_evidencia_maikel_yael.pdf	2026-05-05 11:00:51.167702	\N	pendiente	2026-05-05 11:00:51.167702	2026-05-05 11:00:51.167702	\N
35018099-d468-4622-b913-1f4a3ac8f91d	697d82f2-cd7a-4705-a72e-bb52d771565b	44be7b74-1260-46dd-8dfb-d00bebb8bfe7	demo_evidencia_carlos_miguel_lima_camacho.pdf	2026-05-05 11:00:51.542297	\N	pendiente	2026-05-05 11:00:51.542297	2026-05-05 11:00:51.542297	\N
638681ea-3eed-4b2f-a75e-f262c2320377	697d82f2-cd7a-4705-a72e-bb52d771565b	1f3ead0e-eaf7-4da9-a638-443c1be2aebf	demo_evidencia_yeuri_lorenzo_diaz.pdf	2026-05-05 11:00:51.933243	\N	pendiente	2026-05-05 11:00:51.933243	2026-05-05 11:00:51.933243	\N
1e0eaf09-de87-45bc-9aec-eff90a8d73e9	697d82f2-cd7a-4705-a72e-bb52d771565b	6941db3c-5b29-4671-bfb9-320c75ff89c4	demo_evidencia_nashly_adriana_magallanes_feliz.pdf	2026-05-05 11:00:52.300194	\N	pendiente	2026-05-05 11:00:52.300194	2026-05-05 11:00:52.300194	\N
4da323e6-aa0c-4119-ae8d-6cdbf4e43914	587d122a-087d-4b18-aa19-f4527ea1cc89	07349913-b823-49e2-b3db-0b91dee5be95	demo_evidencia_winniviel_bello.pdf	2026-05-05 11:00:54.081817	\N	pendiente	2026-05-05 11:00:54.081817	2026-05-05 11:00:54.081817	\N
499cd6b7-6c9f-4eb7-94e8-228637bbfa32	587d122a-087d-4b18-aa19-f4527ea1cc89	6ae5e88e-52df-4b57-836e-a88795849517	demo_evidencia_katherine_marie_cuesta_marte.pdf	2026-05-05 11:00:54.827791	\N	pendiente	2026-05-05 11:00:54.827791	2026-05-05 11:00:54.827791	\N
8e479bfb-8da7-4dfc-b701-0d68f7c8139c	587d122a-087d-4b18-aa19-f4527ea1cc89	cd1c0e10-48e1-4123-9c0b-6dfa69751676	demo_evidencia_juan_armando_felix_norberto.pdf	2026-05-05 11:00:55.838508	\N	pendiente	2026-05-05 11:00:55.838508	2026-05-05 11:00:55.838508	\N
836a8068-42e7-4833-b516-3da518dcf3f2	587d122a-087d-4b18-aa19-f4527ea1cc89	62515288-7ece-48cc-af13-bf8359872434	demo_evidencia_maikel_yael.pdf	2026-05-05 11:00:56.608561	\N	pendiente	2026-05-05 11:00:56.608561	2026-05-05 11:00:56.608561	\N
fda58bd9-8672-4d4e-8df0-3a85dbb221ea	587d122a-087d-4b18-aa19-f4527ea1cc89	1f3ead0e-eaf7-4da9-a638-443c1be2aebf	demo_evidencia_yeuri_lorenzo_diaz.pdf	2026-05-05 11:00:57.610585	\N	pendiente	2026-05-05 11:00:57.610585	2026-05-05 11:00:57.610585	\N
12b85a30-45c0-4749-b838-23e6a7c1e90f	587d122a-087d-4b18-aa19-f4527ea1cc89	cb45271c-dd6c-4cf9-a063-21a5b540bc32	demo_evidencia_gabriel_elias_alcala_aquino.pdf	2026-05-05 11:00:53.702841	\N	pendiente	2026-05-05 11:00:53.702841	2026-05-05 11:00:53.702841	\N
887d68c7-022e-4e94-9a36-9c14355c78dc	587d122a-087d-4b18-aa19-f4527ea1cc89	b0c039cb-87d6-48f8-8da1-b3fb51a841d9	demo_evidencia_deuli_de_la_cruz_ramirez.pdf	2026-05-05 11:00:54.468888	\N	pendiente	2026-05-05 11:00:54.468888	2026-05-05 11:00:54.468888	\N
fe24c3c0-3ac8-4381-a452-2a1827fbd418	587d122a-087d-4b18-aa19-f4527ea1cc89	d28c16f6-36f6-41c4-9f1b-9dc98d435a62	demo_evidencia_elyin_emmanuel_diaz_adamez.pdf	2026-05-05 11:00:55.464239	\N	pendiente	2026-05-05 11:00:55.464239	2026-05-05 11:00:55.464239	\N
2d652cdd-3f2b-4d1a-8d33-dd46d3ff947f	587d122a-087d-4b18-aa19-f4527ea1cc89	b338bdf1-8943-4b46-83b1-8fc5315c456e	demo_evidencia_justin_ezequiel.pdf	2026-05-05 11:00:56.238902	\N	pendiente	2026-05-05 11:00:56.238902	2026-05-05 11:00:56.238902	\N
c2a049b2-6b63-4abd-a666-901d6e7c530c	587d122a-087d-4b18-aa19-f4527ea1cc89	44be7b74-1260-46dd-8dfb-d00bebb8bfe7	demo_evidencia_carlos_miguel_lima_camacho.pdf	2026-05-05 11:00:56.98251	\N	pendiente	2026-05-05 11:00:56.98251	2026-05-05 11:00:56.98251	\N
b83247a4-fb26-4c4f-961c-98a5d35b6367	587d122a-087d-4b18-aa19-f4527ea1cc89	6941db3c-5b29-4671-bfb9-320c75ff89c4	demo_evidencia_nashly_adriana_magallanes_feliz.pdf	2026-05-05 11:00:57.984513	\N	pendiente	2026-05-05 11:00:57.984513	2026-05-05 11:00:57.984513	\N
cacc486c-756a-4cf9-9abc-f92c6a39fbd9	b3f599c7-824b-48ae-bc99-f75a970991d1	44be7b74-1260-46dd-8dfb-d00bebb8bfe7	Captura de pantalla 2026-02-02 123833.png	2026-05-05 11:53:59.583953	\N	pendiente	2026-05-05 11:53:59.583953	2026-05-05 11:53:59.583953	\N
0f04bdeb-565d-4205-af2d-a42854dd6930	42c2c0ff-62bf-4e85-94e5-bac9b5bb0db3	44be7b74-1260-46dd-8dfb-d00bebb8bfe7	Captura de pantalla 2026-05-06 165816.png	2026-05-07 05:02:50.243417	\N	pendiente	2026-05-07 05:02:50.243417	2026-05-07 05:02:50.243417	\N
\.


--
-- Data for Name: final_grades; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.final_grades (id, learning_outcome_id, student_id, average_grade, status, grading_date, created_at, updated_at) FROM stdin;
672d946d-d723-45e6-9c91-4187a979b4bf	7acb4a70-9d69-47e7-83aa-4b721f420102	07349913-b823-49e2-b3db-0b91dee5be95	51.00	calculada	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999
82824bf4-c175-480c-9366-70f9dc17e606	7acb4a70-9d69-47e7-83aa-4b721f420103	b338bdf1-8943-4b46-83b1-8fc5315c456e	40.00	calculada	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999
9a48af3f-79c6-4b7f-a5c7-39a417bd817d	7acb4a70-9d69-47e7-83aa-4b721f420102	3b65f5af-5a4d-4d74-bd1f-2a3025412f06	77.00	calculada	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999
f0569e3f-063a-486a-9a0a-0e16cc3600db	7acb4a70-9d69-47e7-83aa-4b721f420102	9a3edf62-5da6-4102-88d9-b9702f2c451e	65.00	calculada	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999
8a579970-8617-4929-9ed9-a5640de4ffcc	7acb4a70-9d69-47e7-83aa-4b721f420102	6941db3c-5b29-4671-bfb9-320c75ff89c4	93.00	calculada	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999
3fa35bc3-e807-4a65-8a9c-1f4024dde686	7acb4a70-9d69-47e7-83aa-4b721f420101	b4310a5f-014b-40be-b5e5-ff8f0f186ac3	82.00	calculada	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999
0ef5e1e6-13d2-4373-9a08-c0215585baeb	7acb4a70-9d69-47e7-83aa-4b721f420103	7332bffc-f65e-4b47-a800-5f5871dd1ff1	66.00	calculada	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999
aa5c553d-a187-4575-9ac8-f8f4c1760b05	7acb4a70-9d69-47e7-83aa-4b721f420103	62515288-7ece-48cc-af13-bf8359872434	82.00	calculada	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999
9c20d4f7-0227-4e36-ac45-597df1d837a5	7acb4a70-9d69-47e7-83aa-4b721f420103	3b65f5af-5a4d-4d74-bd1f-2a3025412f06	66.00	calculada	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999
6e798ced-af8f-4ae7-ae58-2669e85bcae2	7acb4a70-9d69-47e7-83aa-4b721f420101	880f1b10-6a6d-4144-bbb5-17281b801f59	56.67	calculada	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999
86adbab5-a265-48c5-a594-c1eeb19659f6	7acb4a70-9d69-47e7-83aa-4b721f420103	1f3ead0e-eaf7-4da9-a638-443c1be2aebf	66.00	calculada	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999
01278d9a-ce23-4874-bbe8-f609f563bc29	7acb4a70-9d69-47e7-83aa-4b721f420102	2088677b-a9ed-41c2-b7cf-6b1c0f67340a	93.00	calculada	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999
71d73a38-d899-46f5-9aa4-ace9af906b4a	7acb4a70-9d69-47e7-83aa-4b721f420102	cd1c0e10-48e1-4123-9c0b-6dfa69751676	85.00	calculada	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999
b355ef67-d4a0-47b1-a599-98c92af3f465	7acb4a70-9d69-47e7-83aa-4b721f420103	6941db3c-5b29-4671-bfb9-320c75ff89c4	82.00	calculada	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999
cde442dd-9bd1-45c3-b6b5-61380ce10e74	7acb4a70-9d69-47e7-83aa-4b721f420103	44be7b74-1260-46dd-8dfb-d00bebb8bfe7	66.00	calculada	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999
40da7f7f-3583-4a23-9a85-2914204e5121	7acb4a70-9d69-47e7-83aa-4b721f420101	07349913-b823-49e2-b3db-0b91dee5be95	56.67	calculada	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999
001d725a-fb52-4605-8e78-1d952ccf56c8	7acb4a70-9d69-47e7-83aa-4b721f420103	cb45271c-dd6c-4cf9-a063-21a5b540bc32	40.00	calculada	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999
8b0f37b0-a250-41fb-9d47-8cccdede5e06	7acb4a70-9d69-47e7-83aa-4b721f420101	3b65f5af-5a4d-4d74-bd1f-2a3025412f06	74.00	calculada	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999
040e4713-00ab-489a-8ee2-631c9b89a84b	7acb4a70-9d69-47e7-83aa-4b721f420102	880f1b10-6a6d-4144-bbb5-17281b801f59	51.00	calculada	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999
90bedd4c-1a0c-476e-a604-debcec08f889	7acb4a70-9d69-47e7-83aa-4b721f420101	5255b0d0-ac71-40a0-84e6-8e5af4cd03dd	90.00	calculada	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999
be7b9504-fa71-4260-95c1-52089b6bea71	7acb4a70-9d69-47e7-83aa-4b721f420103	2088677b-a9ed-41c2-b7cf-6b1c0f67340a	82.00	calculada	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999
12bc3303-d731-4bf4-b652-184b47ada52e	7acb4a70-9d69-47e7-83aa-4b721f420101	b0c039cb-87d6-48f8-8da1-b3fb51a841d9	62.00	calculada	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999
65a6c0e4-87ed-45d5-9215-983858bd76b7	7acb4a70-9d69-47e7-83aa-4b721f420103	880f1b10-6a6d-4144-bbb5-17281b801f59	40.00	calculada	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999
aed44e28-a003-435a-9e35-8d6068c49320	7acb4a70-9d69-47e7-83aa-4b721f420101	6941db3c-5b29-4671-bfb9-320c75ff89c4	90.00	calculada	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999
3ef0e2cc-2634-4eac-ae19-839c11bcbeee	7acb4a70-9d69-47e7-83aa-4b721f420101	b338bdf1-8943-4b46-83b1-8fc5315c456e	56.67	calculada	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999
e31ccd57-7725-4a69-9502-36a3f67780a4	7acb4a70-9d69-47e7-83aa-4b721f420101	6ae5e88e-52df-4b57-836e-a88795849517	62.00	calculada	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999
7e720af6-ab75-4fd1-b673-647382203969	7acb4a70-9d69-47e7-83aa-4b721f420101	cd1c0e10-48e1-4123-9c0b-6dfa69751676	82.00	calculada	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999
c01b9494-af84-485a-875e-72c06592043e	7acb4a70-9d69-47e7-83aa-4b721f420101	62515288-7ece-48cc-af13-bf8359872434	90.00	calculada	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999
2265f2e4-abb1-4be3-b3c1-2ee5b32ce8c6	7acb4a70-9d69-47e7-83aa-4b721f420101	76542e5b-958f-4a97-9a56-b2eb23fe5d50	90.00	calculada	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999
d4298565-6cd7-4376-8e09-bec91fe64571	7acb4a70-9d69-47e7-83aa-4b721f420102	b0c039cb-87d6-48f8-8da1-b3fb51a841d9	65.00	calculada	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999
e4f5d571-052b-4216-9c78-f811be0f11c5	7acb4a70-9d69-47e7-83aa-4b721f420102	e67826a2-3c40-4e3a-b6b6-046968b1ecdd	77.00	calculada	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999
08f48289-3c05-43e9-9cb1-a5f1db0039f4	7acb4a70-9d69-47e7-83aa-4b721f420102	e8bac2f2-ae10-4de3-beea-824bd74aad7f	65.00	calculada	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999
24a7de22-5e59-42ab-87a7-a807b8cf2781	7acb4a70-9d69-47e7-83aa-4b721f420103	d28c16f6-36f6-41c4-9f1b-9dc98d435a62	82.00	calculada	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999
eaf2ade0-fc7e-4ade-8386-f07b2d1f7b89	7acb4a70-9d69-47e7-83aa-4b721f420103	76542e5b-958f-4a97-9a56-b2eb23fe5d50	82.00	calculada	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999
471ca983-0c9d-4269-b876-0bfb6ce3faf5	7acb4a70-9d69-47e7-83aa-4b721f420101	9a3edf62-5da6-4102-88d9-b9702f2c451e	62.00	calculada	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999
85dbbaed-582a-4b02-afba-f387bb67dd17	7acb4a70-9d69-47e7-83aa-4b721f420102	76542e5b-958f-4a97-9a56-b2eb23fe5d50	93.00	calculada	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999
d60634f1-250d-442c-b011-778770a9d473	7acb4a70-9d69-47e7-83aa-4b721f420101	d28c16f6-36f6-41c4-9f1b-9dc98d435a62	90.00	calculada	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999
55f3c699-9d62-45f4-9aae-7a150363ba2f	7acb4a70-9d69-47e7-83aa-4b721f420103	b0c039cb-87d6-48f8-8da1-b3fb51a841d9	54.00	calculada	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999
761ab88a-96a7-405f-9d4a-ca3135c69316	7acb4a70-9d69-47e7-83aa-4b721f420103	e8bac2f2-ae10-4de3-beea-824bd74aad7f	54.00	calculada	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999
491f4752-83b5-47ae-a552-bf112cc01d26	7acb4a70-9d69-47e7-83aa-4b721f420102	62515288-7ece-48cc-af13-bf8359872434	93.00	calculada	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999
9db72239-f918-46cc-977b-15849c980ae2	7acb4a70-9d69-47e7-83aa-4b721f420103	6ae5e88e-52df-4b57-836e-a88795849517	54.00	calculada	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999
b2e99af6-04b5-4597-910d-9d2d73623787	7acb4a70-9d69-47e7-83aa-4b721f420101	7332bffc-f65e-4b47-a800-5f5871dd1ff1	74.00	calculada	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999
53b71c34-fb52-428c-be36-60aa096251f5	7acb4a70-9d69-47e7-83aa-4b721f420103	b4310a5f-014b-40be-b5e5-ff8f0f186ac3	74.00	calculada	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999
f6a2cd34-eb8b-490b-9862-ec08e9634738	7acb4a70-9d69-47e7-83aa-4b721f420102	d28c16f6-36f6-41c4-9f1b-9dc98d435a62	93.00	calculada	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999
713001fa-cf54-45fd-8319-8e01d37c4eaa	7acb4a70-9d69-47e7-83aa-4b721f420103	9a3edf62-5da6-4102-88d9-b9702f2c451e	54.00	calculada	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999
6918f231-529d-45b2-81e3-c4f731b4efe8	7acb4a70-9d69-47e7-83aa-4b721f420103	e67826a2-3c40-4e3a-b6b6-046968b1ecdd	66.00	calculada	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999
ef108eb4-bdd6-4e0e-bac7-59c3178f563f	7acb4a70-9d69-47e7-83aa-4b721f420102	b338bdf1-8943-4b46-83b1-8fc5315c456e	51.00	calculada	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999
f36df351-db35-4836-91f8-169eea137dbe	7acb4a70-9d69-47e7-83aa-4b721f420102	6ae5e88e-52df-4b57-836e-a88795849517	65.00	calculada	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999
3947f586-12e0-42d9-87b3-2c90e1206bdb	7acb4a70-9d69-47e7-83aa-4b721f420103	cd1c0e10-48e1-4123-9c0b-6dfa69751676	74.00	calculada	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999
eb0bcf1d-ed4f-457d-9e94-d3578f98d0f1	7acb4a70-9d69-47e7-83aa-4b721f420102	5255b0d0-ac71-40a0-84e6-8e5af4cd03dd	93.00	calculada	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999
200f9674-4180-44db-ab66-4e1b42da777d	7acb4a70-9d69-47e7-83aa-4b721f420101	e8bac2f2-ae10-4de3-beea-824bd74aad7f	62.00	calculada	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999
4af9a7e5-8781-414a-82ac-36f094bb32d0	7acb4a70-9d69-47e7-83aa-4b721f420101	e67826a2-3c40-4e3a-b6b6-046968b1ecdd	74.00	calculada	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999
fb601f0c-5b56-4f94-ad34-48023db7a514	7acb4a70-9d69-47e7-83aa-4b721f420102	7332bffc-f65e-4b47-a800-5f5871dd1ff1	77.00	calculada	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999
808eb7e8-049c-4a80-a8f3-6eb090f113ac	7acb4a70-9d69-47e7-83aa-4b721f420102	b4310a5f-014b-40be-b5e5-ff8f0f186ac3	85.00	calculada	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999
71e0e503-8c3c-4139-974c-ad961c1c5873	7acb4a70-9d69-47e7-83aa-4b721f420101	2088677b-a9ed-41c2-b7cf-6b1c0f67340a	90.00	calculada	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999
dd3f3243-04b2-49e6-af7e-48a7da91fcf6	7acb4a70-9d69-47e7-83aa-4b721f420103	5255b0d0-ac71-40a0-84e6-8e5af4cd03dd	82.00	calculada	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999
72000cd8-b433-4ee8-8f53-aa22972ee8e8	7acb4a70-9d69-47e7-83aa-4b721f420103	07349913-b823-49e2-b3db-0b91dee5be95	40.00	calculada	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999
c14842bd-9993-41f8-be65-4d3a29316c12	7acb4a70-9d69-47e7-83aa-4b721f420101	1f3ead0e-eaf7-4da9-a638-443c1be2aebf	80.00	calculada	2026-05-04 20:36:48.472187	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999
c131571e-df3a-4279-8495-a06d7de5cc41	7acb4a70-9d69-47e7-83aa-4b721f420102	1f3ead0e-eaf7-4da9-a638-443c1be2aebf	88.60	calculada	2026-05-04 20:36:56.40153	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999
72bccc91-1130-48db-9fe2-c53a6f58840b	55a7b7d9-4b11-42e2-93a2-4a3758c287d3	44be7b74-1260-46dd-8dfb-d00bebb8bfe7	100.00	calculada	2026-05-07 04:38:37.361129	2026-05-07 04:38:37.361129	2026-05-07 04:38:37.361129
4ab85390-a8c3-4bd2-b760-9b375483881b	7acb4a70-9d69-47e7-83aa-4b721f420101	cb45271c-dd6c-4cf9-a063-21a5b540bc32	100.00	calculada	2026-05-04 23:52:09.053048	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999
135f341f-a5bc-4ed2-aa96-4607eaf1d98f	7acb4a70-9d69-47e7-83aa-4b721f420102	cb45271c-dd6c-4cf9-a063-21a5b540bc32	100.00	calculada	2026-05-04 23:52:24.419364	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999
06404c0d-caf9-4922-a08b-fa79b3e14c4c	7acb4a70-9d69-47e7-83aa-4b721f420101	44be7b74-1260-46dd-8dfb-d00bebb8bfe7	100.00	calculada	2026-05-04 23:59:13.917769	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999
874faa03-fef6-49b8-8dd3-c039cb8a4eed	7acb4a70-9d69-47e7-83aa-4b721f420102	44be7b74-1260-46dd-8dfb-d00bebb8bfe7	100.00	calculada	2026-05-04 23:59:27.307467	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999
f327c26a-869f-423c-aa87-5defe312a61e	55a7b7d9-4b11-42e2-93a2-4a3758c287d3	6941db3c-5b29-4671-bfb9-320c75ff89c4	50.00	calculada	2026-05-07 04:39:00.612325	2026-05-07 04:39:00.612325	2026-05-07 04:39:00.612325
f52a78cd-c1a0-4e59-888e-8b65e01f9a86	156c1508-353e-47c7-87fc-1c54d2a01a98	07349913-b823-49e2-b3db-0b91dee5be95	75.33	calculada	2026-05-07 04:43:38.468054	2026-05-07 04:43:38.468054	2026-05-07 04:43:38.468054
\.


--
-- Data for Name: learning_outcomes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.learning_outcomes (id, competency_id, title, description, created_at, updated_at) FROM stdin;
7acb4a70-9d69-47e7-83aa-4b721f420101	7acb4a70-9d69-47e7-83aa-4b721f410101	Construye algoritmos con estructuras de control	Usa secuencias, decisiones y ciclos para resolver problemas.	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999
7acb4a70-9d69-47e7-83aa-4b721f420102	7acb4a70-9d69-47e7-83aa-4b721f410101	Implementa soluciones funcionales	Convierte algoritmos en codigo claro y probado.	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999
7acb4a70-9d69-47e7-83aa-4b721f420103	7acb4a70-9d69-47e7-83aa-4b721f410102	Elabora modelos entidad relacion	Representa entidades, atributos y relaciones con claridad.	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999
156c1508-353e-47c7-87fc-1c54d2a01a98	00a19c78-af41-42a4-96f1-0eff97e4bd27	Entrega oral y escrita	Resultado asociado a Entrega oral y escrita	2026-05-05 10:57:07.911602	2026-05-05 10:57:07.911602
7cc10cd1-a5e9-4dfd-962d-7a2dd5b7fc51	b6b6fc14-1fbb-42b2-bb76-2c9730486dd6	Solución de caso práctico	Resultado asociado a Solución de caso práctico	2026-05-05 11:00:47.612445	2026-05-05 11:00:47.612445
55a7b7d9-4b11-42e2-93a2-4a3758c287d3	2241e15e-6187-4e59-8d07-2e18a574871d	Proyecto colaborativo	Resultado asociado a Proyecto colaborativo	2026-05-05 11:00:52.934876	2026-05-05 11:00:52.934876
\.


--
-- Data for Name: notificaciones; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.notificaciones (id, estudiante_id, titulo, mensaje, tipo, leida, created_at, updated_at) FROM stdin;
08c6b8b2-06e1-4114-af84-0e995cebe8be	cb45271c-dd6c-4cf9-a063-21a5b540bc32	Nueva actividad disponible	Tienes una actividad asignada para la presentación.	nueva_clase	f	2026-05-05 11:03:38.08071	2026-05-05 11:03:38.08071
fac71733-c204-4085-b92b-20a3beeb62cc	07349913-b823-49e2-b3db-0b91dee5be95	Nueva actividad disponible	Tienes una actividad asignada para la presentación.	nueva_clase	f	2026-05-05 11:03:38.08071	2026-05-05 11:03:38.08071
bc2b3a3c-3d40-4a02-b7cd-8e6e95c8fec6	b0c039cb-87d6-48f8-8da1-b3fb51a841d9	Nueva actividad disponible	Tienes una actividad asignada para la presentación.	nueva_clase	f	2026-05-05 11:03:38.08071	2026-05-05 11:03:38.08071
5d1df8d7-248c-440b-a78b-896ec3a7e264	6ae5e88e-52df-4b57-836e-a88795849517	Nueva actividad disponible	Tienes una actividad asignada para la presentación.	nueva_clase	f	2026-05-05 11:03:38.08071	2026-05-05 11:03:38.08071
2e318e16-4573-4183-a56b-3a251bad5456	d28c16f6-36f6-41c4-9f1b-9dc98d435a62	Nueva actividad disponible	Tienes una actividad asignada para la presentación.	nueva_clase	f	2026-05-05 11:03:38.08071	2026-05-05 11:03:38.08071
e6fc3d7f-07e6-4264-b142-98a03a797402	b4310a5f-014b-40be-b5e5-ff8f0f186ac3	Nueva clase: Proyecto	Entrega de proyecto	nueva_clase	f	2026-05-07 04:37:26.116629	2026-05-07 04:37:26.116629
597b1453-551e-4018-a477-4c69a1fb75b7	d28c16f6-36f6-41c4-9f1b-9dc98d435a62	Nueva clase: Proyecto	Entrega de proyecto	nueva_clase	f	2026-05-07 04:37:26.257718	2026-05-07 04:37:26.257718
777bdd5d-0e94-445e-a1e0-1affda459da6	1f3ead0e-eaf7-4da9-a638-443c1be2aebf	Nueva clase: Proyecto	Entrega de proyecto	nueva_clase	f	2026-05-07 04:37:26.390186	2026-05-07 04:37:26.390186
2346cc55-a0df-401e-97bd-12cb1dee0ef0	3b65f5af-5a4d-4d74-bd1f-2a3025412f06	Nueva clase: Proyecto	Entrega de proyecto	nueva_clase	f	2026-05-07 04:37:26.525096	2026-05-07 04:37:26.525096
94334af1-a321-4e6e-aee2-7671c65d1ce1	e67826a2-3c40-4e3a-b6b6-046968b1ecdd	Nueva clase: Proyecto	Entrega de proyecto	nueva_clase	f	2026-05-07 04:37:26.653664	2026-05-07 04:37:26.653664
b7543886-f4f8-413b-807c-cd1d15cb111f	e8bac2f2-ae10-4de3-beea-824bd74aad7f	Nueva clase: Proyecto	Entrega de proyecto	nueva_clase	f	2026-05-07 04:37:26.788009	2026-05-07 04:37:26.788009
1e549f66-003b-4170-96e8-ba29591fba24	6ae5e88e-52df-4b57-836e-a88795849517	Nueva clase: Proyecto	Entrega de proyecto	nueva_clase	f	2026-05-07 04:37:26.918793	2026-05-07 04:37:26.918793
2622e44c-d256-49e0-87d7-3c05f796b1ee	9a3edf62-5da6-4102-88d9-b9702f2c451e	Nueva clase: Proyecto	Entrega de proyecto	nueva_clase	f	2026-05-07 04:37:27.051772	2026-05-07 04:37:27.051772
e2289413-0e30-4bdd-ba45-9d012a07fcd4	07349913-b823-49e2-b3db-0b91dee5be95	Nueva clase: Proyecto	Entrega de proyecto	nueva_clase	f	2026-05-07 04:37:27.178398	2026-05-07 04:37:27.178398
82bde305-b58a-4c35-b848-643e82fabd73	b0c039cb-87d6-48f8-8da1-b3fb51a841d9	Nueva clase: Proyecto	Entrega de proyecto	nueva_clase	f	2026-05-07 04:37:27.477229	2026-05-07 04:37:27.477229
a8ccbbe0-87b8-4195-9251-afd1d8e7ec5b	62515288-7ece-48cc-af13-bf8359872434	Nueva clase: Proyecto	Entrega de proyecto	nueva_clase	f	2026-05-07 04:37:27.60713	2026-05-07 04:37:27.60713
1e02577b-a7fd-4bac-9c90-7089a89d99ae	6941db3c-5b29-4671-bfb9-320c75ff89c4	Nueva clase: Proyecto	Entrega de proyecto	nueva_clase	f	2026-05-07 04:37:27.739517	2026-05-07 04:37:27.739517
35a1ef86-3785-44f6-bffd-4cd766c81e27	2088677b-a9ed-41c2-b7cf-6b1c0f67340a	Nueva clase: Proyecto	Entrega de proyecto	nueva_clase	f	2026-05-07 04:37:27.888201	2026-05-07 04:37:27.888201
35bdd6b8-acc3-48d1-8ec8-63b5565b22b5	7332bffc-f65e-4b47-a800-5f5871dd1ff1	Nueva clase: Proyecto	Entrega de proyecto	nueva_clase	f	2026-05-07 04:37:28.062461	2026-05-07 04:37:28.062461
7aeecfd4-e583-4478-b3c5-7a2980b6d8b8	76542e5b-958f-4a97-9a56-b2eb23fe5d50	Nueva clase: Proyecto	Entrega de proyecto	nueva_clase	f	2026-05-07 04:37:28.329521	2026-05-07 04:37:28.329521
7e8dc400-c0d1-4d4f-8f52-7f0a84348eeb	880f1b10-6a6d-4144-bbb5-17281b801f59	Nueva clase: Proyecto	Entrega de proyecto	nueva_clase	f	2026-05-07 04:37:28.468857	2026-05-07 04:37:28.468857
78da5f53-9726-4613-9f75-2bf6ece6df7c	cd1c0e10-48e1-4123-9c0b-6dfa69751676	Nueva clase: Proyecto	Entrega de proyecto	nueva_clase	f	2026-05-07 04:37:28.600726	2026-05-07 04:37:28.600726
785f130a-eb2e-4dd2-b395-51f65860054f	5255b0d0-ac71-40a0-84e6-8e5af4cd03dd	Nueva clase: Proyecto	Entrega de proyecto	nueva_clase	f	2026-05-07 04:37:28.732989	2026-05-07 04:37:28.732989
6f4b2c7b-c2f1-4ab5-a7d3-c1ba339b3678	cb45271c-dd6c-4cf9-a063-21a5b540bc32	Nueva clase: Proyecto	Entrega de proyecto	nueva_clase	f	2026-05-07 04:37:28.867259	2026-05-07 04:37:28.867259
6aa1941d-f128-4783-b67f-a38c50462b37	b338bdf1-8943-4b46-83b1-8fc5315c456e	Nueva clase: Proyecto	Entrega de proyecto	nueva_clase	f	2026-05-07 04:37:29.088708	2026-05-07 04:37:29.088708
3b4dc4fa-83f7-4eff-8d39-e684fe1b2f4a	44be7b74-1260-46dd-8dfb-d00bebb8bfe7	Nueva clase: Proyecto	Entrega de proyecto	nueva_clase	t	2026-05-07 04:37:28.195222	2026-05-07 04:37:28.195222
\.


--
-- Data for Name: plantillas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.plantillas (id, nombre, descripcion, contenido, created_at, updated_at) FROM stdin;
2ebc5eb8-c27b-40ed-8fd2-566c66b87a49	Plantilla demo por competencia	Plantilla base para rubricas de cuatro niveles.	{"escala": "0-100", "niveles": [{"nivel": 1, "rango_max": 40, "rango_min": 0, "descripcion": "Incipiente"}, {"nivel": 2, "rango_max": 60, "rango_min": 40, "descripcion": "Basico"}, {"nivel": 3, "rango_max": 85, "rango_min": 60, "descripcion": "Satisfactorio"}, {"nivel": 4, "rango_max": 100, "rango_min": 85, "descripcion": "Avanzado"}]}	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999
\.


--
-- Data for Name: progreso_snapshots; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.progreso_snapshots (id, estudiante_id, competencia_id, porcentaje_logro, nivel_logro, total_evaluaciones, promedio_calificacion, fecha_snapshot) FROM stdin;
\.


--
-- Data for Name: re_evaluaciones; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.re_evaluaciones (id, estudiante_id, competencia_id, intento_numero, calificacion_anterior, calificacion_nueva, estado, fecha_creacion, fecha_completacion, observacion) FROM stdin;
\.


--
-- Data for Name: reports; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.reports (id, teacher_id, title, type, generation_date, data_json, pdf_url, created_at, updated_at, tipo, datos_json, fecha_generacion) FROM stdin;
5f272e36-5afc-4218-afd4-d2768fe6a137	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	Reporte demo - Programacion I	grupo	2026-05-01 15:49:18.915999	{"promedio": 78.4, "total_estudiantes": 21}	\N	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999	grupo	{"promedio": 78.4, "total_estudiantes": 21}	2026-05-01 15:49:18.915999
1609953c-efa6-4eda-a93d-23272217f3ea	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	Reporte demo - Competencias	competencias	2026-05-01 15:49:18.915999	{"competencias": 2, "evaluaciones": 105}	\N	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999	competencias	{"competencias": 2, "evaluaciones": 105}	2026-05-01 15:49:18.915999
\.


--
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.roles (id, name, description, permissions, created_at) FROM stdin;
65d7437c-7b40-4417-98c8-0b338e698fb4	admin	Administrador	{"view_all": true}	2026-04-27 02:35:32.58094
fae05a64-cb43-4650-97e5-85e52cbe8023	teacher	Docente	{"manage_competencies": true}	2026-04-27 02:35:32.58094
c9349289-8854-4129-bfba-67fdfdd25516	student	Estudiante	{"submit_evidence": true}	2026-04-27 02:35:32.58094
\.


--
-- Data for Name: rubricas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.rubricas (id, nombre, descripcion, docente_id, competencia_id, niveles, created_at) FROM stdin;
36a58c37-299e-44a4-b3c1-ae5d495ed915	Rúbrica de Liderazgo	Evalúa liderazgo	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	\N	[{"nivel": 1, "rango_max": 39, "rango_min": 0, "descripcion": "Insuficiente"}, {"nivel": 2, "rango_max": 69, "rango_min": 40, "descripcion": "Básico"}, {"nivel": 3, "rango_max": 84, "rango_min": 70, "descripcion": "Intermedio"}, {"nivel": 4, "rango_max": 100, "rango_min": 85, "descripcion": "Avanzado"}]	2026-04-27 02:35:32.58094
17586378-1fac-4b6b-813c-af74a36ed5a9	Rúbrica de Comunicación	Evalúa comunicación	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	\N	[{"nivel": 1, "rango_max": 39, "rango_min": 0, "descripcion": "Insuficiente"}, {"nivel": 2, "rango_max": 69, "rango_min": 40, "descripcion": "Básico"}, {"nivel": 3, "rango_max": 84, "rango_min": 70, "descripcion": "Intermedio"}, {"nivel": 4, "rango_max": 100, "rango_min": 85, "descripcion": "Avanzado"}]	2026-04-27 02:35:32.58094
83df5ba9-f016-42a2-9d48-4635ce74db58	Rubrica de Participacion	nose	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74		[{"nivel": 1, "rango_max": 39, "rango_min": 0, "descripcion": "Insuficiente"}, {"nivel": 2, "rango_max": 69, "rango_min": 40, "descripcion": "Básico"}, {"nivel": 3, "rango_max": 84, "rango_min": 70, "descripcion": "Intermedio"}, {"nivel": 4, "rango_max": 100, "rango_min": 85, "descripcion": "Avanzado"}]	2026-05-01 12:23:50.139955
52089d35-87c9-48cf-b633-cb30e83c3f4c	Rubrica demo - Desarrollo de algoritmos	Evalua analisis, control de flujo y calidad de solucion.	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	7acb4a70-9d69-47e7-83aa-4b721f410101	[{"nivel": "Incipiente", "rango_max": 40, "rango_min": 0}, {"nivel": "Basico", "rango_max": 70, "rango_min": 41}, {"nivel": "Satisfactorio", "rango_max": 90, "rango_min": 71}, {"nivel": "Avanzado", "rango_max": 100, "rango_min": 91}]	2026-05-01 15:49:18.915999
d30c8dcc-be54-4ee2-aa0b-f89fc995bcc1	Rubrica demo - Modelado de bases de datos	Evalua entidades, relaciones y normalizacion inicial.	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	7acb4a70-9d69-47e7-83aa-4b721f410102	[{"nivel": "Incipiente", "rango_max": 40, "rango_min": 0}, {"nivel": "Basico", "rango_max": 70, "rango_min": 41}, {"nivel": "Satisfactorio", "rango_max": 90, "rango_min": 71}, {"nivel": "Avanzado", "rango_max": 100, "rango_min": 91}]	2026-05-01 15:49:18.915999
32de01a9-4510-41cb-a6b7-6095d62072ef	Rubrica de Participacion	nose	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74		[{"nivel": 1, "rango_max": 39, "rango_min": 0, "descripcion": "Insuficiente"}, {"nivel": 2, "rango_max": 69, "rango_min": 40, "descripcion": "Básico"}, {"nivel": 3, "rango_max": 84, "rango_min": 70, "descripcion": "Intermedio"}, {"nivel": 4, "rango_max": 100, "rango_min": 85, "descripcion": "Avanzado"}]	2026-05-05 10:29:35.497168
ec5698bb-697f-4c92-a9ff-fc0e8b48e1aa	Liderazgo	Demostrar buen trabajo en equipo con ayuda de su lider	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74		[{"nivel": 1, "rango_max": 39, "rango_min": 0, "descripcion": "Insuficiente"}, {"nivel": 2, "rango_max": 69, "rango_min": 40, "descripcion": "Básico"}, {"nivel": 3, "rango_max": 84, "rango_min": 70, "descripcion": "Intermedio"}, {"nivel": 4, "rango_max": 100, "rango_min": 85, "descripcion": "Avanzado"}]	2026-05-07 04:45:45.248346
d6cf0b64-8ba6-4bd3-ae60-2be77a8737dc	Liderazgo	Demostrar buen trabajo en equipo con ayuda de su lider	9ba53ac3-902f-48c4-a9b5-8e5a032c5b74		[{"nivel": 1, "rango_max": 39, "rango_min": 0, "descripcion": "Insuficiente"}, {"nivel": 2, "rango_max": 69, "rango_min": 40, "descripcion": "Básico"}, {"nivel": 3, "rango_max": 84, "rango_min": 70, "descripcion": "Intermedio"}, {"nivel": 4, "rango_max": 100, "rango_min": 85, "descripcion": "Avanzado"}]	2026-05-07 04:46:05.625255
\.


--
-- Data for Name: sections; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sections (id, name, grade, letter, created_at) FROM stdin;
daba6124-ff80-4236-a939-06e933462e21	4toA	4to	A	2026-04-29 06:36:28.372318
8bbb7381-1a60-4a44-8692-34eace2858cb	4toB	4to	B	2026-04-29 06:36:28.372318
2ea8b6cc-7255-4c55-8b9d-008770da288a	4toF	4to	F	2026-04-29 06:36:28.372318
f6ab6526-f65a-436a-a419-aaddfd669f95	5toA	5to	A	2026-04-29 06:36:28.372318
d7a8c2f7-bc04-4457-a1e3-e5a4093e055f	5toD	5to	D	2026-04-29 06:36:28.372318
6cd51dc6-2ff7-477d-8282-a38766b01959	6toF	6to	F	2026-04-29 06:36:28.372318
\.


--
-- Data for Name: student_section; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.student_section (id, student_id, section_id, enrollment_date) FROM stdin;
\.


--
-- Data for Name: student_tracking; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.student_tracking (id, student_id, competency_id, progress_percentage, last_updated, created_at) FROM stdin;
e185fb4c-9a1a-4656-8d92-788c567f49eb	6941db3c-5b29-4671-bfb9-320c75ff89c4	7acb4a70-9d69-47e7-83aa-4b721f410102	82.00	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999
695d0a6a-85d5-4d16-b728-506a6b54cde2	cb45271c-dd6c-4cf9-a063-21a5b540bc32	7acb4a70-9d69-47e7-83aa-4b721f410101	54.40	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999
90a51826-5066-4686-8f92-80ce7dcd2739	b338bdf1-8943-4b46-83b1-8fc5315c456e	7acb4a70-9d69-47e7-83aa-4b721f410102	40.00	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999
8629c7f0-879d-4226-97fa-75a55b872280	d28c16f6-36f6-41c4-9f1b-9dc98d435a62	7acb4a70-9d69-47e7-83aa-4b721f410101	91.50	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999
078fdafa-78e1-41f5-96cd-ba7bfa58c017	cd1c0e10-48e1-4123-9c0b-6dfa69751676	7acb4a70-9d69-47e7-83aa-4b721f410101	83.50	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999
9d161c97-701f-41de-a2f8-76881c77b786	6941db3c-5b29-4671-bfb9-320c75ff89c4	7acb4a70-9d69-47e7-83aa-4b721f410101	91.50	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999
41ec8410-66af-47f6-964c-db362422e727	76542e5b-958f-4a97-9a56-b2eb23fe5d50	7acb4a70-9d69-47e7-83aa-4b721f410102	82.00	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999
0c9fc66b-c00a-4cba-80d6-4430c99ff450	6ae5e88e-52df-4b57-836e-a88795849517	7acb4a70-9d69-47e7-83aa-4b721f410102	54.00	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999
7d94c02f-4f47-4760-8dff-606e5c4ef9f8	e67826a2-3c40-4e3a-b6b6-046968b1ecdd	7acb4a70-9d69-47e7-83aa-4b721f410102	66.00	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999
fdfe5436-6353-4b4f-9a2c-3a39e25beb0d	76542e5b-958f-4a97-9a56-b2eb23fe5d50	7acb4a70-9d69-47e7-83aa-4b721f410101	91.50	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999
aadd1dee-cf40-4cd8-9afd-da0db57ca89d	b338bdf1-8943-4b46-83b1-8fc5315c456e	7acb4a70-9d69-47e7-83aa-4b721f410101	54.40	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999
e42f0554-ac98-452e-be87-5a61aebf75c5	44be7b74-1260-46dd-8dfb-d00bebb8bfe7	7acb4a70-9d69-47e7-83aa-4b721f410102	66.00	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999
24e3fc6b-75a4-42c0-891e-46bf770c01e9	b4310a5f-014b-40be-b5e5-ff8f0f186ac3	7acb4a70-9d69-47e7-83aa-4b721f410101	83.50	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999
58ccd5b9-4290-4f61-b7cf-91d8c5a8c586	1f3ead0e-eaf7-4da9-a638-443c1be2aebf	7acb4a70-9d69-47e7-83aa-4b721f410102	66.00	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999
75a12d4c-b87b-4085-8420-9c89f08707bf	44be7b74-1260-46dd-8dfb-d00bebb8bfe7	7acb4a70-9d69-47e7-83aa-4b721f410101	75.50	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999
66a82f66-df38-48f2-b8ed-a1a6756a4408	b0c039cb-87d6-48f8-8da1-b3fb51a841d9	7acb4a70-9d69-47e7-83aa-4b721f410102	54.00	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999
c300019e-1cf8-4abe-963a-2abb2e561561	3b65f5af-5a4d-4d74-bd1f-2a3025412f06	7acb4a70-9d69-47e7-83aa-4b721f410102	66.00	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999
fa5d287c-1371-4f55-9143-098ccc8795bd	1f3ead0e-eaf7-4da9-a638-443c1be2aebf	7acb4a70-9d69-47e7-83aa-4b721f410101	75.50	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999
9cae680b-9794-4218-a0ff-f476bd92cdff	9a3edf62-5da6-4102-88d9-b9702f2c451e	7acb4a70-9d69-47e7-83aa-4b721f410101	63.50	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999
d63d6338-e2f6-477f-861d-a3ecb8677a14	62515288-7ece-48cc-af13-bf8359872434	7acb4a70-9d69-47e7-83aa-4b721f410101	91.50	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999
9fac5122-31bc-40d4-b995-03ec7578db26	6ae5e88e-52df-4b57-836e-a88795849517	7acb4a70-9d69-47e7-83aa-4b721f410101	63.50	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999
e5b33b85-b3ce-4e3d-ac46-3588e52ac7bd	cb45271c-dd6c-4cf9-a063-21a5b540bc32	7acb4a70-9d69-47e7-83aa-4b721f410102	40.00	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999
56f147ab-ce76-4df9-9049-e14e62f3a145	5255b0d0-ac71-40a0-84e6-8e5af4cd03dd	7acb4a70-9d69-47e7-83aa-4b721f410102	82.00	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999
a27ad40f-ab34-4504-90d0-2b44176d0881	d28c16f6-36f6-41c4-9f1b-9dc98d435a62	7acb4a70-9d69-47e7-83aa-4b721f410102	82.00	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999
4c1dc91a-9f02-46c4-902e-1cae30193e59	2088677b-a9ed-41c2-b7cf-6b1c0f67340a	7acb4a70-9d69-47e7-83aa-4b721f410101	91.50	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999
761a145c-fdf2-4edb-9b9d-018a85019ac2	62515288-7ece-48cc-af13-bf8359872434	7acb4a70-9d69-47e7-83aa-4b721f410102	82.00	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999
c168579e-5197-41e1-8955-2a65bbe831e2	e8bac2f2-ae10-4de3-beea-824bd74aad7f	7acb4a70-9d69-47e7-83aa-4b721f410102	54.00	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999
2549f7d8-bcfa-4246-9290-019c70393ebb	880f1b10-6a6d-4144-bbb5-17281b801f59	7acb4a70-9d69-47e7-83aa-4b721f410101	54.40	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999
bdd145f0-c96f-4b77-b506-89887e2e4352	880f1b10-6a6d-4144-bbb5-17281b801f59	7acb4a70-9d69-47e7-83aa-4b721f410102	40.00	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999
42694cd4-2ee2-437d-9599-3ce7bb91e246	07349913-b823-49e2-b3db-0b91dee5be95	7acb4a70-9d69-47e7-83aa-4b721f410101	54.40	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999
2d0155ac-0bfb-4d9e-8939-e6736b308b23	5255b0d0-ac71-40a0-84e6-8e5af4cd03dd	7acb4a70-9d69-47e7-83aa-4b721f410101	91.50	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999
d1f5feab-0422-4872-b051-4ea09d2cd0b0	7332bffc-f65e-4b47-a800-5f5871dd1ff1	7acb4a70-9d69-47e7-83aa-4b721f410101	75.50	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999
8bb6694c-70de-424f-b4fc-20882ff3499b	b0c039cb-87d6-48f8-8da1-b3fb51a841d9	7acb4a70-9d69-47e7-83aa-4b721f410101	63.50	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999
38cdc5bc-5c4e-4085-a062-7dee62e12012	3b65f5af-5a4d-4d74-bd1f-2a3025412f06	7acb4a70-9d69-47e7-83aa-4b721f410101	75.50	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999
135c2f80-d83c-4428-a39d-1a2ceb7718c7	e8bac2f2-ae10-4de3-beea-824bd74aad7f	7acb4a70-9d69-47e7-83aa-4b721f410101	63.50	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999
8f0ab59b-7f66-4ad3-aa46-4a09ce5407c2	7332bffc-f65e-4b47-a800-5f5871dd1ff1	7acb4a70-9d69-47e7-83aa-4b721f410102	66.00	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999
d8db5ed8-d6ea-4258-940f-09ecc1775b49	cd1c0e10-48e1-4123-9c0b-6dfa69751676	7acb4a70-9d69-47e7-83aa-4b721f410102	74.00	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999
dd2ee509-b3a8-4bcc-a910-899124f18da6	2088677b-a9ed-41c2-b7cf-6b1c0f67340a	7acb4a70-9d69-47e7-83aa-4b721f410102	82.00	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999
0a894be6-b717-4975-8661-00079be769cb	b4310a5f-014b-40be-b5e5-ff8f0f186ac3	7acb4a70-9d69-47e7-83aa-4b721f410102	74.00	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999
614149e5-5226-494a-b74f-462d99fcb1de	07349913-b823-49e2-b3db-0b91dee5be95	7acb4a70-9d69-47e7-83aa-4b721f410102	40.00	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999
9d1d2da4-0dba-4a3d-b735-76549c28bcf9	9a3edf62-5da6-4102-88d9-b9702f2c451e	7acb4a70-9d69-47e7-83aa-4b721f410102	54.00	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999
c09eba3f-ed72-401d-8755-715e9f51827d	e67826a2-3c40-4e3a-b6b6-046968b1ecdd	7acb4a70-9d69-47e7-83aa-4b721f410101	75.50	2026-05-01 15:49:18.915999	2026-05-01 15:49:18.915999
\.


--
-- Data for Name: system_configuration; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.system_configuration (id, key, value, type, updated_at, created_at) FROM stdin;
\.


--
-- Data for Name: teacher_section; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.teacher_section (id, teacher_id, section_id, created_at) FROM stdin;
\.


--
-- Data for Name: templates; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.templates (id, user_id, name, description, criteria_id, learning_outcome_id, competency_id, template_json, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: user_roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_roles (id, user_id, role_id, assignment_date) FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, email, name, password_hash, role, active, created_at, updated_at) FROM stdin;
22e32e2a-0a39-4d7d-baca-de0a29aaaac3	carloscamacho9700@gmail.com	Carlos Camacho	$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5ELPcqJQ5cJOi	admin	t	2026-04-27 02:35:32.58094	2026-04-27 02:35:32.58094
cb45271c-dd6c-4cf9-a063-21a5b540bc32	gabriel.alcala@edu.com	Gabriel Elias Alcala Aquino	$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5ELPcqJQ5cJOi	student	t	2026-04-27 02:35:32.58094	2026-04-27 02:35:32.58094
07349913-b823-49e2-b3db-0b91dee5be95	winniviel.bello@edu.com	Winniviel Bello	$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5ELPcqJQ5cJOi	student	t	2026-04-27 02:35:32.58094	2026-04-27 02:35:32.58094
b0c039cb-87d6-48f8-8da1-b3fb51a841d9	deuli.cruz@edu.com	Deuli de la Cruz Ramirez	$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5ELPcqJQ5cJOi	student	t	2026-04-27 02:35:32.58094	2026-04-27 02:35:32.58094
6ae5e88e-52df-4b57-836e-a88795849517	katherine.cuesta@edu.com	Katherine Marie Cuesta Marte	$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5ELPcqJQ5cJOi	student	t	2026-04-27 02:35:32.58094	2026-04-27 02:35:32.58094
d28c16f6-36f6-41c4-9f1b-9dc98d435a62	elyin.diaz@edu.com	Elyin Emmanuel Diaz Adamez	$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5ELPcqJQ5cJOi	student	t	2026-04-27 02:35:32.58094	2026-04-27 02:35:32.58094
cd1c0e10-48e1-4123-9c0b-6dfa69751676	juan.felix@edu.com	Juan Armando Felix Norberto	$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5ELPcqJQ5cJOi	student	t	2026-04-27 02:35:32.58094	2026-04-27 02:35:32.58094
b338bdf1-8943-4b46-83b1-8fc5315c456e	justin.ezequiel@edu.com	Justin Ezequiel	$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5ELPcqJQ5cJOi	student	t	2026-04-27 02:35:32.58094	2026-04-27 02:35:32.58094
62515288-7ece-48cc-af13-bf8359872434	maikel.yael@edu.com	Maikel Yael	$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5ELPcqJQ5cJOi	student	t	2026-04-27 02:35:32.58094	2026-04-27 02:35:32.58094
44be7b74-1260-46dd-8dfb-d00bebb8bfe7	carlos.lima@edu.com	Carlos Miguel Lima Camacho	$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5ELPcqJQ5cJOi	student	t	2026-04-27 02:35:32.58094	2026-04-27 02:35:32.58094
1f3ead0e-eaf7-4da9-a638-443c1be2aebf	yeuri.lorenzo@edu.com	Yeuri Lorenzo Diaz	$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5ELPcqJQ5cJOi	student	t	2026-04-27 02:35:32.58094	2026-04-27 02:35:32.58094
6941db3c-5b29-4671-bfb9-320c75ff89c4	nashly.magallanes@edu.com	Nashly Adriana Magallanes Feliz	$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5ELPcqJQ5cJOi	student	t	2026-04-27 02:35:32.58094	2026-04-27 02:35:32.58094
5255b0d0-ac71-40a0-84e6-8e5af4cd03dd	angelo.mancebo@edu.com	Angelo Alexander Mancebo	$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5ELPcqJQ5cJOi	student	t	2026-04-27 02:35:32.58094	2026-04-27 02:35:32.58094
9a3edf62-5da6-4102-88d9-b9702f2c451e	enrique.ogando@edu.com	Enrique Ogando	$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5ELPcqJQ5cJOi	student	t	2026-04-27 02:35:32.58094	2026-04-27 02:35:32.58094
76542e5b-958f-4a97-9a56-b2eb23fe5d50	jose.pichardo@edu.com	Jose Emmanuel Pichardo	$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5ELPcqJQ5cJOi	student	t	2026-04-27 02:35:32.58094	2026-04-27 02:35:32.58094
3b65f5af-5a4d-4d74-bd1f-2a3025412f06	ernesto.pichardo@edu.com	Ernesto Luis Pichardo	$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5ELPcqJQ5cJOi	student	t	2026-04-27 02:35:32.58094	2026-04-27 02:35:32.58094
880f1b10-6a6d-4144-bbb5-17281b801f59	dustin.polanco@edu.com	Dustin Alexander Polanco Muños	$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5ELPcqJQ5cJOi	student	t	2026-04-27 02:35:32.58094	2026-04-27 02:35:32.58094
e67826a2-3c40-4e3a-b6b6-046968b1ecdd	michael.ramirez@edu.com	Michael Ramirez Feliz	$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5ELPcqJQ5cJOi	student	t	2026-04-27 02:35:32.58094	2026-04-27 02:35:32.58094
7332bffc-f65e-4b47-a800-5f5871dd1ff1	eliezer.jesus@edu.com	Eliezer de Jesus	$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5ELPcqJQ5cJOi	student	t	2026-04-27 02:35:32.58094	2026-04-27 02:35:32.58094
e8bac2f2-ae10-4de3-beea-824bd74aad7f	jeremy.manuel@edu.com	Jeremy Manuel	$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5ELPcqJQ5cJOi	student	t	2026-04-27 02:35:32.58094	2026-04-27 02:35:32.58094
b4310a5f-014b-40be-b5e5-ff8f0f186ac3	ashly.reding@edu.com	Ashly Pamela Reding Hernandez	$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5ELPcqJQ5cJOi	student	t	2026-04-27 02:35:32.58094	2026-04-27 02:35:32.58094
2088677b-a9ed-41c2-b7cf-6b1c0f67340a	gianni.subervi@edu.com	Gianni Subervi Alcantara	$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5ELPcqJQ5cJOi	student	t	2026-04-27 02:35:32.58094	2026-04-27 02:35:32.58094
9ba53ac3-902f-48c4-a9b5-8e5a032c5b74	joserijo@gmail.com	José Rijo	$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5ELPcqJQ5cJOi	teacher	t	2026-04-27 02:35:32.58094	2026-04-27 02:35:32.58094
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: realtime; Owner: supabase_admin
--

COPY realtime.schema_migrations (version, inserted_at) FROM stdin;
20211116024918	2026-03-05 15:10:36
20211116045059	2026-03-05 15:10:36
20211116050929	2026-03-05 15:10:36
20211116051442	2026-03-05 15:10:37
20211116212300	2026-03-05 15:10:37
20211116213355	2026-03-05 15:10:38
20211116213934	2026-03-05 15:10:38
20211116214523	2026-03-05 15:10:38
20211122062447	2026-03-05 15:10:39
20211124070109	2026-03-05 15:10:39
20211202204204	2026-03-05 15:10:40
20211202204605	2026-03-05 15:10:40
20211210212804	2026-03-05 15:10:41
20211228014915	2026-03-05 15:10:42
20220107221237	2026-03-05 15:10:42
20220228202821	2026-03-05 15:10:42
20220312004840	2026-03-05 15:10:43
20220603231003	2026-03-05 15:10:43
20220603232444	2026-03-05 15:10:44
20220615214548	2026-03-05 15:10:44
20220712093339	2026-03-05 15:10:44
20220908172859	2026-03-05 15:10:45
20220916233421	2026-03-05 15:10:45
20230119133233	2026-03-05 15:10:46
20230128025114	2026-03-05 15:10:46
20230128025212	2026-03-05 15:10:46
20230227211149	2026-03-05 15:10:47
20230228184745	2026-03-05 15:10:47
20230308225145	2026-03-05 15:10:48
20230328144023	2026-03-05 15:10:48
20231018144023	2026-03-05 15:10:48
20231204144023	2026-03-05 15:10:49
20231204144024	2026-03-05 15:10:49
20231204144025	2026-03-05 15:10:50
20240108234812	2026-03-05 15:10:50
20240109165339	2026-03-05 15:10:51
20240227174441	2026-03-05 15:10:51
20240311171622	2026-03-05 15:10:52
20240321100241	2026-03-05 15:10:53
20240401105812	2026-03-05 15:10:54
20240418121054	2026-03-05 15:10:54
20240523004032	2026-03-05 15:10:55
20240618124746	2026-03-05 15:10:56
20240801235015	2026-03-05 15:10:56
20240805133720	2026-03-05 15:10:57
20240827160934	2026-03-05 15:10:57
20240919163303	2026-03-05 15:10:58
20240919163305	2026-03-05 15:10:58
20241019105805	2026-03-05 15:10:58
20241030150047	2026-03-05 15:11:00
20241108114728	2026-03-05 15:11:00
20241121104152	2026-03-05 15:11:01
20241130184212	2026-03-05 15:11:01
20241220035512	2026-03-05 15:11:01
20241220123912	2026-03-05 15:11:02
20241224161212	2026-03-05 15:11:02
20250107150512	2026-03-05 15:11:02
20250110162412	2026-03-05 15:11:03
20250123174212	2026-03-05 15:11:03
20250128220012	2026-03-05 15:11:04
20250506224012	2026-03-05 15:11:04
20250523164012	2026-03-05 15:11:04
20250714121412	2026-03-05 15:11:05
20250905041441	2026-03-05 15:11:05
20251103001201	2026-03-05 15:11:05
20251120212548	2026-03-05 15:11:06
20251120215549	2026-03-05 15:11:06
20260218120000	2026-03-05 15:11:07
20260326120000	2026-04-21 16:33:24
\.


--
-- Data for Name: subscription; Type: TABLE DATA; Schema: realtime; Owner: supabase_admin
--

COPY realtime.subscription (id, subscription_id, entity, filters, claims, created_at, action_filter) FROM stdin;
\.


--
-- Data for Name: buckets; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.buckets (id, name, owner, created_at, updated_at, public, avif_autodetection, file_size_limit, allowed_mime_types, owner_id, type) FROM stdin;
evidencias	evidencias	\N	2026-03-11 23:07:36.539495+00	2026-03-11 23:07:36.539495+00	t	f	\N	\N	\N	STANDARD
\.


--
-- Data for Name: buckets_analytics; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.buckets_analytics (name, type, format, created_at, updated_at, id, deleted_at) FROM stdin;
\.


--
-- Data for Name: buckets_vectors; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.buckets_vectors (id, type, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: migrations; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.migrations (id, name, hash, executed_at) FROM stdin;
0	create-migrations-table	e18db593bcde2aca2a408c4d1100f6abba2195df	2026-03-05 14:19:25.301502
1	initialmigration	6ab16121fbaa08bbd11b712d05f358f9b555d777	2026-03-05 14:19:25.332494
2	storage-schema	f6a1fa2c93cbcd16d4e487b362e45fca157a8dbd	2026-03-05 14:19:25.338499
3	pathtoken-column	2cb1b0004b817b29d5b0a971af16bafeede4b70d	2026-03-05 14:19:25.361936
4	add-migrations-rls	427c5b63fe1c5937495d9c635c263ee7a5905058	2026-03-05 14:19:25.373949
5	add-size-functions	79e081a1455b63666c1294a440f8ad4b1e6a7f84	2026-03-05 14:19:25.378009
6	change-column-name-in-get-size	ded78e2f1b5d7e616117897e6443a925965b30d2	2026-03-05 14:19:25.381871
7	add-rls-to-buckets	e7e7f86adbc51049f341dfe8d30256c1abca17aa	2026-03-05 14:19:25.385086
8	add-public-to-buckets	fd670db39ed65f9d08b01db09d6202503ca2bab3	2026-03-05 14:19:25.387647
9	fix-search-function	af597a1b590c70519b464a4ab3be54490712796b	2026-03-05 14:19:25.390523
10	search-files-search-function	b595f05e92f7e91211af1bbfe9c6a13bb3391e16	2026-03-05 14:19:25.393271
11	add-trigger-to-auto-update-updated_at-column	7425bdb14366d1739fa8a18c83100636d74dcaa2	2026-03-05 14:19:25.396368
12	add-automatic-avif-detection-flag	8e92e1266eb29518b6a4c5313ab8f29dd0d08df9	2026-03-05 14:19:25.399699
13	add-bucket-custom-limits	cce962054138135cd9a8c4bcd531598684b25e7d	2026-03-05 14:19:25.402373
14	use-bytes-for-max-size	941c41b346f9802b411f06f30e972ad4744dad27	2026-03-05 14:19:25.405095
15	add-can-insert-object-function	934146bc38ead475f4ef4b555c524ee5d66799e5	2026-03-05 14:19:25.427932
16	add-version	76debf38d3fd07dcfc747ca49096457d95b1221b	2026-03-05 14:19:25.431017
17	drop-owner-foreign-key	f1cbb288f1b7a4c1eb8c38504b80ae2a0153d101	2026-03-05 14:19:25.433647
18	add_owner_id_column_deprecate_owner	e7a511b379110b08e2f214be852c35414749fe66	2026-03-05 14:19:25.436262
19	alter-default-value-objects-id	02e5e22a78626187e00d173dc45f58fa66a4f043	2026-03-05 14:19:25.44099
20	list-objects-with-delimiter	cd694ae708e51ba82bf012bba00caf4f3b6393b7	2026-03-05 14:19:25.44393
21	s3-multipart-uploads	8c804d4a566c40cd1e4cc5b3725a664a9303657f	2026-03-05 14:19:25.448361
22	s3-multipart-uploads-big-ints	9737dc258d2397953c9953d9b86920b8be0cdb73	2026-03-05 14:19:25.459296
23	optimize-search-function	9d7e604cddc4b56a5422dc68c9313f4a1b6f132c	2026-03-05 14:19:25.469169
24	operation-function	8312e37c2bf9e76bbe841aa5fda889206d2bf8aa	2026-03-05 14:19:25.472343
25	custom-metadata	d974c6057c3db1c1f847afa0e291e6165693b990	2026-03-05 14:19:25.476014
26	objects-prefixes	215cabcb7f78121892a5a2037a09fedf9a1ae322	2026-03-05 14:19:25.478832
27	search-v2	859ba38092ac96eb3964d83bf53ccc0b141663a6	2026-03-05 14:19:25.480919
28	object-bucket-name-sorting	c73a2b5b5d4041e39705814fd3a1b95502d38ce4	2026-03-05 14:19:25.483096
29	create-prefixes	ad2c1207f76703d11a9f9007f821620017a66c21	2026-03-05 14:19:25.485284
30	update-object-levels	2be814ff05c8252fdfdc7cfb4b7f5c7e17f0bed6	2026-03-05 14:19:25.487456
31	objects-level-index	b40367c14c3440ec75f19bbce2d71e914ddd3da0	2026-03-05 14:19:25.489483
32	backward-compatible-index-on-objects	e0c37182b0f7aee3efd823298fb3c76f1042c0f7	2026-03-05 14:19:25.491685
33	backward-compatible-index-on-prefixes	b480e99ed951e0900f033ec4eb34b5bdcb4e3d49	2026-03-05 14:19:25.493847
34	optimize-search-function-v1	ca80a3dc7bfef894df17108785ce29a7fc8ee456	2026-03-05 14:19:25.496045
35	add-insert-trigger-prefixes	458fe0ffd07ec53f5e3ce9df51bfdf4861929ccc	2026-03-05 14:19:25.498316
36	optimise-existing-functions	6ae5fca6af5c55abe95369cd4f93985d1814ca8f	2026-03-05 14:19:25.500552
37	add-bucket-name-length-trigger	3944135b4e3e8b22d6d4cbb568fe3b0b51df15c1	2026-03-05 14:19:25.503023
38	iceberg-catalog-flag-on-buckets	02716b81ceec9705aed84aa1501657095b32e5c5	2026-03-05 14:19:25.50625
39	add-search-v2-sort-support	6706c5f2928846abee18461279799ad12b279b78	2026-03-05 14:19:25.513334
40	fix-prefix-race-conditions-optimized	7ad69982ae2d372b21f48fc4829ae9752c518f6b	2026-03-05 14:19:25.515559
41	add-object-level-update-trigger	07fcf1a22165849b7a029deed059ffcde08d1ae0	2026-03-05 14:19:25.517827
42	rollback-prefix-triggers	771479077764adc09e2ea2043eb627503c034cd4	2026-03-05 14:19:25.520015
43	fix-object-level	84b35d6caca9d937478ad8a797491f38b8c2979f	2026-03-05 14:19:25.522343
44	vector-bucket-type	99c20c0ffd52bb1ff1f32fb992f3b351e3ef8fb3	2026-03-05 14:19:25.52466
45	vector-buckets	049e27196d77a7cb76497a85afae669d8b230953	2026-03-05 14:19:25.527644
46	buckets-objects-grants	fedeb96d60fefd8e02ab3ded9fbde05632f84aed	2026-03-05 14:19:25.538007
47	iceberg-table-metadata	649df56855c24d8b36dd4cc1aeb8251aa9ad42c2	2026-03-05 14:19:25.541034
48	iceberg-catalog-ids	e0e8b460c609b9999ccd0df9ad14294613eed939	2026-03-05 14:19:25.543368
49	buckets-objects-grants-postgres	072b1195d0d5a2f888af6b2302a1938dd94b8b3d	2026-03-05 14:19:25.556452
50	search-v2-optimised	6323ac4f850aa14e7387eb32102869578b5bd478	2026-03-05 14:19:25.559674
51	index-backward-compatible-search	2ee395d433f76e38bcd3856debaf6e0e5b674011	2026-03-05 14:19:25.574238
52	drop-not-used-indexes-and-functions	5cc44c8696749ac11dd0dc37f2a3802075f3a171	2026-03-05 14:19:25.575773
53	drop-index-lower-name	d0cb18777d9e2a98ebe0bc5cc7a42e57ebe41854	2026-03-05 14:19:25.587732
54	drop-index-object-level	6289e048b1472da17c31a7eba1ded625a6457e67	2026-03-05 14:19:25.589404
55	prevent-direct-deletes	262a4798d5e0f2e7c8970232e03ce8be695d5819	2026-03-05 14:19:25.590889
57	s3-multipart-uploads-metadata	f127886e00d1b374fadbc7c6b31e09336aad5287	2026-04-08 23:00:18.785913
58	operation-ergonomics	00ca5d483b3fe0d522133d9002ccc5df98365120	2026-04-08 23:00:18.817619
56	fix-optimized-search-function	b823ed1e418101032fa01374edc9a436e54e3ed4	2026-03-05 14:19:25.594192
59	drop-unused-functions	38456f13e39691c2bbb4b5151d0d1cdbabd4a8c4	2026-05-06 21:16:43.195107
60	optimize-existing-functions-again	db35e1c91a9201e59f4fef8d972c2f277d68b157	2026-05-06 21:16:43.207109
\.


--
-- Data for Name: objects; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.objects (id, bucket_id, name, owner, created_at, updated_at, last_accessed_at, metadata, version, owner_id, user_metadata) FROM stdin;
2c5360e9-c2f9-423e-9eec-8f1955af92c1	evidencias	evidencias/2026/03/11/d6ee4a1b-4b75-46be-93f1-0c435df802ed.pdf	\N	2026-03-11 23:12:48.469683+00	2026-03-11 23:12:48.469683+00	2026-03-11 23:12:48.469683+00	{"eTag": "\\"68f9e6c2bf062a2a358e4ba668498cf8-2\\"", "size": 6332222, "mimetype": "application/pdf", "cacheControl": "no-cache", "lastModified": "2026-03-11T23:12:48.000Z", "contentLength": 6332222, "httpStatusCode": 200}	1aeab990-590e-452d-9d97-d502346f04a0	\N	{}
2be31438-06e2-420a-ac50-0ce925747c3a	evidencias	evidencias/2026/03/22/460fa253-fc44-4e4f-891b-b1eb8d75001a.pdf	\N	2026-03-22 16:11:06.577421+00	2026-03-22 16:11:06.577421+00	2026-03-22 16:11:06.577421+00	{"eTag": "\\"7cbd1e596b616e6846fd66e926d87923\\"", "size": 183903, "mimetype": "application/pdf", "cacheControl": "no-cache", "lastModified": "2026-03-22T16:11:07.000Z", "contentLength": 183903, "httpStatusCode": 200}	5a657d3a-d314-42ec-8d7f-8e0a3d145d04	\N	{}
\.


--
-- Data for Name: s3_multipart_uploads; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.s3_multipart_uploads (id, in_progress_size, upload_signature, bucket_id, key, version, owner_id, created_at, user_metadata, metadata) FROM stdin;
\.


--
-- Data for Name: s3_multipart_uploads_parts; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.s3_multipart_uploads_parts (id, upload_id, size, part_number, bucket_id, key, etag, owner_id, version, created_at) FROM stdin;
\.


--
-- Data for Name: vector_indexes; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.vector_indexes (id, name, bucket_id, data_type, dimension, distance_metric, metadata_configuration, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: secrets; Type: TABLE DATA; Schema: vault; Owner: supabase_admin
--

COPY vault.secrets (id, name, description, secret, key_id, nonce, created_at, updated_at) FROM stdin;
\.


--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE SET; Schema: auth; Owner: supabase_auth_admin
--

SELECT pg_catalog.setval('auth.refresh_tokens_id_seq', 253, true);


--
-- Name: subscription_id_seq; Type: SEQUENCE SET; Schema: realtime; Owner: supabase_admin
--

SELECT pg_catalog.setval('realtime.subscription_id_seq', 1, false);


--
-- Name: mfa_amr_claims amr_id_pk; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT amr_id_pk PRIMARY KEY (id);


--
-- Name: audit_log_entries audit_log_entries_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.audit_log_entries
    ADD CONSTRAINT audit_log_entries_pkey PRIMARY KEY (id);


--
-- Name: custom_oauth_providers custom_oauth_providers_identifier_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.custom_oauth_providers
    ADD CONSTRAINT custom_oauth_providers_identifier_key UNIQUE (identifier);


--
-- Name: custom_oauth_providers custom_oauth_providers_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.custom_oauth_providers
    ADD CONSTRAINT custom_oauth_providers_pkey PRIMARY KEY (id);


--
-- Name: flow_state flow_state_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.flow_state
    ADD CONSTRAINT flow_state_pkey PRIMARY KEY (id);


--
-- Name: identities identities_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_pkey PRIMARY KEY (id);


--
-- Name: identities identities_provider_id_provider_unique; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_provider_id_provider_unique UNIQUE (provider_id, provider);


--
-- Name: instances instances_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.instances
    ADD CONSTRAINT instances_pkey PRIMARY KEY (id);


--
-- Name: mfa_amr_claims mfa_amr_claims_session_id_authentication_method_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT mfa_amr_claims_session_id_authentication_method_pkey UNIQUE (session_id, authentication_method);


--
-- Name: mfa_challenges mfa_challenges_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_challenges
    ADD CONSTRAINT mfa_challenges_pkey PRIMARY KEY (id);


--
-- Name: mfa_factors mfa_factors_last_challenged_at_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_last_challenged_at_key UNIQUE (last_challenged_at);


--
-- Name: mfa_factors mfa_factors_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_pkey PRIMARY KEY (id);


--
-- Name: oauth_authorizations oauth_authorizations_authorization_code_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_authorization_code_key UNIQUE (authorization_code);


--
-- Name: oauth_authorizations oauth_authorizations_authorization_id_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_authorization_id_key UNIQUE (authorization_id);


--
-- Name: oauth_authorizations oauth_authorizations_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_pkey PRIMARY KEY (id);


--
-- Name: oauth_client_states oauth_client_states_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_client_states
    ADD CONSTRAINT oauth_client_states_pkey PRIMARY KEY (id);


--
-- Name: oauth_clients oauth_clients_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_clients
    ADD CONSTRAINT oauth_clients_pkey PRIMARY KEY (id);


--
-- Name: oauth_consents oauth_consents_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_consents
    ADD CONSTRAINT oauth_consents_pkey PRIMARY KEY (id);


--
-- Name: oauth_consents oauth_consents_user_client_unique; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_consents
    ADD CONSTRAINT oauth_consents_user_client_unique UNIQUE (user_id, client_id);


--
-- Name: one_time_tokens one_time_tokens_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.one_time_tokens
    ADD CONSTRAINT one_time_tokens_pkey PRIMARY KEY (id);


--
-- Name: refresh_tokens refresh_tokens_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_pkey PRIMARY KEY (id);


--
-- Name: refresh_tokens refresh_tokens_token_unique; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_token_unique UNIQUE (token);


--
-- Name: saml_providers saml_providers_entity_id_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_entity_id_key UNIQUE (entity_id);


--
-- Name: saml_providers saml_providers_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_pkey PRIMARY KEY (id);


--
-- Name: saml_relay_states saml_relay_states_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: sessions sessions_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- Name: sso_domains sso_domains_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sso_domains
    ADD CONSTRAINT sso_domains_pkey PRIMARY KEY (id);


--
-- Name: sso_providers sso_providers_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sso_providers
    ADD CONSTRAINT sso_providers_pkey PRIMARY KEY (id);


--
-- Name: users users_phone_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.users
    ADD CONSTRAINT users_phone_key UNIQUE (phone);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: webauthn_challenges webauthn_challenges_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.webauthn_challenges
    ADD CONSTRAINT webauthn_challenges_pkey PRIMARY KEY (id);


--
-- Name: webauthn_credentials webauthn_credentials_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.webauthn_credentials
    ADD CONSTRAINT webauthn_credentials_pkey PRIMARY KEY (id);


--
-- Name: activities activities_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.activities
    ADD CONSTRAINT activities_pkey PRIMARY KEY (id);


--
-- Name: alertas_bajo_desempenio alertas_bajo_desempenio_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alertas_bajo_desempenio
    ADD CONSTRAINT alertas_bajo_desempenio_pkey PRIMARY KEY (id);


--
-- Name: asistencias asistencias_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asistencias
    ADD CONSTRAINT asistencias_pkey PRIMARY KEY (id);


--
-- Name: audits audits_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.audits
    ADD CONSTRAINT audits_pkey PRIMARY KEY (id);


--
-- Name: competencies competencias_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.competencies
    ADD CONSTRAINT competencias_pkey PRIMARY KEY (id);


--
-- Name: configuration configuration_key_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.configuration
    ADD CONSTRAINT configuration_key_key UNIQUE (key);


--
-- Name: configuration configuration_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.configuration
    ADD CONSTRAINT configuration_pkey PRIMARY KEY (id);


--
-- Name: criteria criteria_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.criteria
    ADD CONSTRAINT criteria_pkey PRIMARY KEY (id);


--
-- Name: cursos cursos_codigo_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cursos
    ADD CONSTRAINT cursos_codigo_key UNIQUE (codigo);


--
-- Name: cursos cursos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cursos
    ADD CONSTRAINT cursos_pkey PRIMARY KEY (id);


--
-- Name: docente_curso docente_curso_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.docente_curso
    ADD CONSTRAINT docente_curso_pkey PRIMARY KEY (id);


--
-- Name: estudiante_curso estudiante_curso_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.estudiante_curso
    ADD CONSTRAINT estudiante_curso_pkey PRIMARY KEY (id);


--
-- Name: evaluation_metadata evaluation_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.evaluation_metadata
    ADD CONSTRAINT evaluation_metadata_pkey PRIMARY KEY (id);


--
-- Name: evaluations evaluations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.evaluations
    ADD CONSTRAINT evaluations_pkey PRIMARY KEY (id);


--
-- Name: evidence evidence_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.evidence
    ADD CONSTRAINT evidence_pkey PRIMARY KEY (id);


--
-- Name: final_grades final_grades_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.final_grades
    ADD CONSTRAINT final_grades_pkey PRIMARY KEY (id);


--
-- Name: learning_outcomes learning_outcomes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.learning_outcomes
    ADD CONSTRAINT learning_outcomes_pkey PRIMARY KEY (id);


--
-- Name: notificaciones notificaciones_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notificaciones
    ADD CONSTRAINT notificaciones_pkey PRIMARY KEY (id);


--
-- Name: plantillas plantillas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.plantillas
    ADD CONSTRAINT plantillas_pkey PRIMARY KEY (id);


--
-- Name: progreso_snapshots progreso_snapshots_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.progreso_snapshots
    ADD CONSTRAINT progreso_snapshots_pkey PRIMARY KEY (id);


--
-- Name: re_evaluaciones re_evaluaciones_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.re_evaluaciones
    ADD CONSTRAINT re_evaluaciones_pkey PRIMARY KEY (id);


--
-- Name: reports reports_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reports
    ADD CONSTRAINT reports_pkey PRIMARY KEY (id);


--
-- Name: roles roles_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_name_key UNIQUE (name);


--
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- Name: rubricas rubricas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rubricas
    ADD CONSTRAINT rubricas_pkey PRIMARY KEY (id);


--
-- Name: sections sections_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sections
    ADD CONSTRAINT sections_pkey PRIMARY KEY (id);


--
-- Name: student_section student_section_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_section
    ADD CONSTRAINT student_section_pkey PRIMARY KEY (id);


--
-- Name: student_section student_section_student_id_section_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_section
    ADD CONSTRAINT student_section_student_id_section_id_key UNIQUE (student_id, section_id);


--
-- Name: student_tracking student_tracking_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_tracking
    ADD CONSTRAINT student_tracking_pkey PRIMARY KEY (id);


--
-- Name: system_configuration system_configuration_key_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.system_configuration
    ADD CONSTRAINT system_configuration_key_key UNIQUE (key);


--
-- Name: system_configuration system_configuration_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.system_configuration
    ADD CONSTRAINT system_configuration_pkey PRIMARY KEY (id);


--
-- Name: teacher_section teacher_section_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teacher_section
    ADD CONSTRAINT teacher_section_pkey PRIMARY KEY (id);


--
-- Name: teacher_section teacher_section_teacher_id_section_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teacher_section
    ADD CONSTRAINT teacher_section_teacher_id_section_id_key UNIQUE (teacher_id, section_id);


--
-- Name: templates templates_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.templates
    ADD CONSTRAINT templates_pkey PRIMARY KEY (id);


--
-- Name: user_roles user_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_roles
    ADD CONSTRAINT user_roles_pkey PRIMARY KEY (id);


--
-- Name: user_roles user_roles_user_id_role_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_roles
    ADD CONSTRAINT user_roles_user_id_role_id_key UNIQUE (user_id, role_id);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: messages messages_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER TABLE ONLY realtime.messages
    ADD CONSTRAINT messages_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: subscription pk_subscription; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.subscription
    ADD CONSTRAINT pk_subscription PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: buckets_analytics buckets_analytics_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.buckets_analytics
    ADD CONSTRAINT buckets_analytics_pkey PRIMARY KEY (id);


--
-- Name: buckets buckets_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.buckets
    ADD CONSTRAINT buckets_pkey PRIMARY KEY (id);


--
-- Name: buckets_vectors buckets_vectors_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.buckets_vectors
    ADD CONSTRAINT buckets_vectors_pkey PRIMARY KEY (id);


--
-- Name: migrations migrations_name_key; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.migrations
    ADD CONSTRAINT migrations_name_key UNIQUE (name);


--
-- Name: migrations migrations_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (id);


--
-- Name: objects objects_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.objects
    ADD CONSTRAINT objects_pkey PRIMARY KEY (id);


--
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_pkey PRIMARY KEY (id);


--
-- Name: s3_multipart_uploads s3_multipart_uploads_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads
    ADD CONSTRAINT s3_multipart_uploads_pkey PRIMARY KEY (id);


--
-- Name: vector_indexes vector_indexes_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.vector_indexes
    ADD CONSTRAINT vector_indexes_pkey PRIMARY KEY (id);


--
-- Name: audit_logs_instance_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX audit_logs_instance_id_idx ON auth.audit_log_entries USING btree (instance_id);


--
-- Name: confirmation_token_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX confirmation_token_idx ON auth.users USING btree (confirmation_token) WHERE ((confirmation_token)::text !~ '^[0-9 ]*$'::text);


--
-- Name: custom_oauth_providers_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX custom_oauth_providers_created_at_idx ON auth.custom_oauth_providers USING btree (created_at);


--
-- Name: custom_oauth_providers_enabled_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX custom_oauth_providers_enabled_idx ON auth.custom_oauth_providers USING btree (enabled);


--
-- Name: custom_oauth_providers_identifier_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX custom_oauth_providers_identifier_idx ON auth.custom_oauth_providers USING btree (identifier);


--
-- Name: custom_oauth_providers_provider_type_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX custom_oauth_providers_provider_type_idx ON auth.custom_oauth_providers USING btree (provider_type);


--
-- Name: email_change_token_current_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX email_change_token_current_idx ON auth.users USING btree (email_change_token_current) WHERE ((email_change_token_current)::text !~ '^[0-9 ]*$'::text);


--
-- Name: email_change_token_new_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX email_change_token_new_idx ON auth.users USING btree (email_change_token_new) WHERE ((email_change_token_new)::text !~ '^[0-9 ]*$'::text);


--
-- Name: factor_id_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX factor_id_created_at_idx ON auth.mfa_factors USING btree (user_id, created_at);


--
-- Name: flow_state_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX flow_state_created_at_idx ON auth.flow_state USING btree (created_at DESC);


--
-- Name: identities_email_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX identities_email_idx ON auth.identities USING btree (email text_pattern_ops);


--
-- Name: INDEX identities_email_idx; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON INDEX auth.identities_email_idx IS 'Auth: Ensures indexed queries on the email column';


--
-- Name: identities_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX identities_user_id_idx ON auth.identities USING btree (user_id);


--
-- Name: idx_auth_code; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX idx_auth_code ON auth.flow_state USING btree (auth_code);


--
-- Name: idx_oauth_client_states_created_at; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX idx_oauth_client_states_created_at ON auth.oauth_client_states USING btree (created_at);


--
-- Name: idx_user_id_auth_method; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX idx_user_id_auth_method ON auth.flow_state USING btree (user_id, authentication_method);


--
-- Name: mfa_challenge_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX mfa_challenge_created_at_idx ON auth.mfa_challenges USING btree (created_at DESC);


--
-- Name: mfa_factors_user_friendly_name_unique; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX mfa_factors_user_friendly_name_unique ON auth.mfa_factors USING btree (friendly_name, user_id) WHERE (TRIM(BOTH FROM friendly_name) <> ''::text);


--
-- Name: mfa_factors_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX mfa_factors_user_id_idx ON auth.mfa_factors USING btree (user_id);


--
-- Name: oauth_auth_pending_exp_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX oauth_auth_pending_exp_idx ON auth.oauth_authorizations USING btree (expires_at) WHERE (status = 'pending'::auth.oauth_authorization_status);


--
-- Name: oauth_clients_deleted_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX oauth_clients_deleted_at_idx ON auth.oauth_clients USING btree (deleted_at);


--
-- Name: oauth_consents_active_client_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX oauth_consents_active_client_idx ON auth.oauth_consents USING btree (client_id) WHERE (revoked_at IS NULL);


--
-- Name: oauth_consents_active_user_client_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX oauth_consents_active_user_client_idx ON auth.oauth_consents USING btree (user_id, client_id) WHERE (revoked_at IS NULL);


--
-- Name: oauth_consents_user_order_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX oauth_consents_user_order_idx ON auth.oauth_consents USING btree (user_id, granted_at DESC);


--
-- Name: one_time_tokens_relates_to_hash_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX one_time_tokens_relates_to_hash_idx ON auth.one_time_tokens USING hash (relates_to);


--
-- Name: one_time_tokens_token_hash_hash_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX one_time_tokens_token_hash_hash_idx ON auth.one_time_tokens USING hash (token_hash);


--
-- Name: one_time_tokens_user_id_token_type_key; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX one_time_tokens_user_id_token_type_key ON auth.one_time_tokens USING btree (user_id, token_type);


--
-- Name: reauthentication_token_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX reauthentication_token_idx ON auth.users USING btree (reauthentication_token) WHERE ((reauthentication_token)::text !~ '^[0-9 ]*$'::text);


--
-- Name: recovery_token_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX recovery_token_idx ON auth.users USING btree (recovery_token) WHERE ((recovery_token)::text !~ '^[0-9 ]*$'::text);


--
-- Name: refresh_tokens_instance_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_instance_id_idx ON auth.refresh_tokens USING btree (instance_id);


--
-- Name: refresh_tokens_instance_id_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_instance_id_user_id_idx ON auth.refresh_tokens USING btree (instance_id, user_id);


--
-- Name: refresh_tokens_parent_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_parent_idx ON auth.refresh_tokens USING btree (parent);


--
-- Name: refresh_tokens_session_id_revoked_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_session_id_revoked_idx ON auth.refresh_tokens USING btree (session_id, revoked);


--
-- Name: refresh_tokens_updated_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_updated_at_idx ON auth.refresh_tokens USING btree (updated_at DESC);


--
-- Name: saml_providers_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX saml_providers_sso_provider_id_idx ON auth.saml_providers USING btree (sso_provider_id);


--
-- Name: saml_relay_states_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX saml_relay_states_created_at_idx ON auth.saml_relay_states USING btree (created_at DESC);


--
-- Name: saml_relay_states_for_email_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX saml_relay_states_for_email_idx ON auth.saml_relay_states USING btree (for_email);


--
-- Name: saml_relay_states_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX saml_relay_states_sso_provider_id_idx ON auth.saml_relay_states USING btree (sso_provider_id);


--
-- Name: sessions_not_after_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sessions_not_after_idx ON auth.sessions USING btree (not_after DESC);


--
-- Name: sessions_oauth_client_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sessions_oauth_client_id_idx ON auth.sessions USING btree (oauth_client_id);


--
-- Name: sessions_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sessions_user_id_idx ON auth.sessions USING btree (user_id);


--
-- Name: sso_domains_domain_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX sso_domains_domain_idx ON auth.sso_domains USING btree (lower(domain));


--
-- Name: sso_domains_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sso_domains_sso_provider_id_idx ON auth.sso_domains USING btree (sso_provider_id);


--
-- Name: sso_providers_resource_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX sso_providers_resource_id_idx ON auth.sso_providers USING btree (lower(resource_id));


--
-- Name: sso_providers_resource_id_pattern_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sso_providers_resource_id_pattern_idx ON auth.sso_providers USING btree (resource_id text_pattern_ops);


--
-- Name: unique_phone_factor_per_user; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX unique_phone_factor_per_user ON auth.mfa_factors USING btree (user_id, phone);


--
-- Name: user_id_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX user_id_created_at_idx ON auth.sessions USING btree (user_id, created_at);


--
-- Name: users_email_partial_key; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX users_email_partial_key ON auth.users USING btree (email) WHERE (is_sso_user = false);


--
-- Name: INDEX users_email_partial_key; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON INDEX auth.users_email_partial_key IS 'Auth: A partial unique index that applies only when is_sso_user is false';


--
-- Name: users_instance_id_email_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX users_instance_id_email_idx ON auth.users USING btree (instance_id, lower((email)::text));


--
-- Name: users_instance_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX users_instance_id_idx ON auth.users USING btree (instance_id);


--
-- Name: users_is_anonymous_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX users_is_anonymous_idx ON auth.users USING btree (is_anonymous);


--
-- Name: webauthn_challenges_expires_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX webauthn_challenges_expires_at_idx ON auth.webauthn_challenges USING btree (expires_at);


--
-- Name: webauthn_challenges_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX webauthn_challenges_user_id_idx ON auth.webauthn_challenges USING btree (user_id);


--
-- Name: webauthn_credentials_credential_id_key; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX webauthn_credentials_credential_id_key ON auth.webauthn_credentials USING btree (credential_id);


--
-- Name: webauthn_credentials_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX webauthn_credentials_user_id_idx ON auth.webauthn_credentials USING btree (user_id);


--
-- Name: idx_alertas_docente; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_alertas_docente ON public.alertas_bajo_desempenio USING btree (docente_id);


--
-- Name: idx_alertas_estudiante; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_alertas_estudiante ON public.alertas_bajo_desempenio USING btree (estudiante_id);


--
-- Name: idx_alertas_leida; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_alertas_leida ON public.alertas_bajo_desempenio USING btree (leida);


--
-- Name: idx_alertas_nivel_riesgo; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_alertas_nivel_riesgo ON public.alertas_bajo_desempenio USING btree (nivel_riesgo);


--
-- Name: idx_asistencias_curso_fecha; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_asistencias_curso_fecha ON public.asistencias USING btree (curso_id, fecha);


--
-- Name: idx_asistencias_estudiante; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_asistencias_estudiante ON public.asistencias USING btree (estudiante_id);


--
-- Name: idx_criteria_learning_outcome; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_criteria_learning_outcome ON public.criteria USING btree (learning_outcome_id);


--
-- Name: idx_eval_meta_docente; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_eval_meta_docente ON public.evaluation_metadata USING btree (docente_id);


--
-- Name: idx_evidence_actividad; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_evidence_actividad ON public.evidence USING btree (actividad_id);


--
-- Name: idx_notificaciones_created_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_notificaciones_created_at ON public.notificaciones USING btree (created_at DESC);


--
-- Name: idx_notificaciones_estudiante; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_notificaciones_estudiante ON public.notificaciones USING btree (estudiante_id);


--
-- Name: idx_notificaciones_leida; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_notificaciones_leida ON public.notificaciones USING btree (leida);


--
-- Name: idx_plantillas_nombre; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_plantillas_nombre ON public.plantillas USING btree (nombre);


--
-- Name: idx_re_eval_competencia; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_re_eval_competencia ON public.re_evaluaciones USING btree (competencia_id);


--
-- Name: idx_re_eval_estado; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_re_eval_estado ON public.re_evaluaciones USING btree (estado);


--
-- Name: idx_re_eval_estudiante; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_re_eval_estudiante ON public.re_evaluaciones USING btree (estudiante_id);


--
-- Name: idx_snapshots_competencia; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_snapshots_competencia ON public.progreso_snapshots USING btree (competencia_id);


--
-- Name: idx_snapshots_estudiante; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_snapshots_estudiante ON public.progreso_snapshots USING btree (estudiante_id);


--
-- Name: idx_snapshots_fecha; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_snapshots_fecha ON public.progreso_snapshots USING btree (fecha_snapshot DESC);


--
-- Name: uq_asistencia_demo; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX uq_asistencia_demo ON public.asistencias USING btree (docente_id, estudiante_id, curso_id, fecha);


--
-- Name: uq_estudiante_curso_demo; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX uq_estudiante_curso_demo ON public.estudiante_curso USING btree (estudiante_id, curso_id);


--
-- Name: ix_realtime_subscription_entity; Type: INDEX; Schema: realtime; Owner: supabase_admin
--

CREATE INDEX ix_realtime_subscription_entity ON realtime.subscription USING btree (entity);


--
-- Name: messages_inserted_at_topic_index; Type: INDEX; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE INDEX messages_inserted_at_topic_index ON ONLY realtime.messages USING btree (inserted_at DESC, topic) WHERE ((extension = 'broadcast'::text) AND (private IS TRUE));


--
-- Name: subscription_subscription_id_entity_filters_action_filter_key; Type: INDEX; Schema: realtime; Owner: supabase_admin
--

CREATE UNIQUE INDEX subscription_subscription_id_entity_filters_action_filter_key ON realtime.subscription USING btree (subscription_id, entity, filters, action_filter);


--
-- Name: bname; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX bname ON storage.buckets USING btree (name);


--
-- Name: bucketid_objname; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX bucketid_objname ON storage.objects USING btree (bucket_id, name);


--
-- Name: buckets_analytics_unique_name_idx; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX buckets_analytics_unique_name_idx ON storage.buckets_analytics USING btree (name) WHERE (deleted_at IS NULL);


--
-- Name: idx_multipart_uploads_list; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE INDEX idx_multipart_uploads_list ON storage.s3_multipart_uploads USING btree (bucket_id, key, created_at);


--
-- Name: idx_objects_bucket_id_name; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE INDEX idx_objects_bucket_id_name ON storage.objects USING btree (bucket_id, name COLLATE "C");


--
-- Name: idx_objects_bucket_id_name_lower; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE INDEX idx_objects_bucket_id_name_lower ON storage.objects USING btree (bucket_id, lower(name) COLLATE "C");


--
-- Name: name_prefix_search; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE INDEX name_prefix_search ON storage.objects USING btree (name text_pattern_ops);


--
-- Name: vector_indexes_name_bucket_id_idx; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX vector_indexes_name_bucket_id_idx ON storage.vector_indexes USING btree (name, bucket_id);


--
-- Name: subscription tr_check_filters; Type: TRIGGER; Schema: realtime; Owner: supabase_admin
--

CREATE TRIGGER tr_check_filters BEFORE INSERT OR UPDATE ON realtime.subscription FOR EACH ROW EXECUTE FUNCTION realtime.subscription_check_filters();


--
-- Name: buckets enforce_bucket_name_length_trigger; Type: TRIGGER; Schema: storage; Owner: supabase_storage_admin
--

CREATE TRIGGER enforce_bucket_name_length_trigger BEFORE INSERT OR UPDATE OF name ON storage.buckets FOR EACH ROW EXECUTE FUNCTION storage.enforce_bucket_name_length();


--
-- Name: buckets protect_buckets_delete; Type: TRIGGER; Schema: storage; Owner: supabase_storage_admin
--

CREATE TRIGGER protect_buckets_delete BEFORE DELETE ON storage.buckets FOR EACH STATEMENT EXECUTE FUNCTION storage.protect_delete();


--
-- Name: objects protect_objects_delete; Type: TRIGGER; Schema: storage; Owner: supabase_storage_admin
--

CREATE TRIGGER protect_objects_delete BEFORE DELETE ON storage.objects FOR EACH STATEMENT EXECUTE FUNCTION storage.protect_delete();


--
-- Name: objects update_objects_updated_at; Type: TRIGGER; Schema: storage; Owner: supabase_storage_admin
--

CREATE TRIGGER update_objects_updated_at BEFORE UPDATE ON storage.objects FOR EACH ROW EXECUTE FUNCTION storage.update_updated_at_column();


--
-- Name: identities identities_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: mfa_amr_claims mfa_amr_claims_session_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT mfa_amr_claims_session_id_fkey FOREIGN KEY (session_id) REFERENCES auth.sessions(id) ON DELETE CASCADE;


--
-- Name: mfa_challenges mfa_challenges_auth_factor_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_challenges
    ADD CONSTRAINT mfa_challenges_auth_factor_id_fkey FOREIGN KEY (factor_id) REFERENCES auth.mfa_factors(id) ON DELETE CASCADE;


--
-- Name: mfa_factors mfa_factors_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: oauth_authorizations oauth_authorizations_client_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_client_id_fkey FOREIGN KEY (client_id) REFERENCES auth.oauth_clients(id) ON DELETE CASCADE;


--
-- Name: oauth_authorizations oauth_authorizations_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: oauth_consents oauth_consents_client_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_consents
    ADD CONSTRAINT oauth_consents_client_id_fkey FOREIGN KEY (client_id) REFERENCES auth.oauth_clients(id) ON DELETE CASCADE;


--
-- Name: oauth_consents oauth_consents_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_consents
    ADD CONSTRAINT oauth_consents_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: one_time_tokens one_time_tokens_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.one_time_tokens
    ADD CONSTRAINT one_time_tokens_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: refresh_tokens refresh_tokens_session_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_session_id_fkey FOREIGN KEY (session_id) REFERENCES auth.sessions(id) ON DELETE CASCADE;


--
-- Name: saml_providers saml_providers_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- Name: saml_relay_states saml_relay_states_flow_state_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_flow_state_id_fkey FOREIGN KEY (flow_state_id) REFERENCES auth.flow_state(id) ON DELETE CASCADE;


--
-- Name: saml_relay_states saml_relay_states_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- Name: sessions sessions_oauth_client_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_oauth_client_id_fkey FOREIGN KEY (oauth_client_id) REFERENCES auth.oauth_clients(id) ON DELETE CASCADE;


--
-- Name: sessions sessions_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: sso_domains sso_domains_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sso_domains
    ADD CONSTRAINT sso_domains_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- Name: webauthn_challenges webauthn_challenges_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.webauthn_challenges
    ADD CONSTRAINT webauthn_challenges_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: webauthn_credentials webauthn_credentials_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.webauthn_credentials
    ADD CONSTRAINT webauthn_credentials_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: activities activities_docente_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.activities
    ADD CONSTRAINT activities_docente_id_fkey FOREIGN KEY (docente_id) REFERENCES public.users(id);


--
-- Name: activities activities_learning_outcome_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.activities
    ADD CONSTRAINT activities_learning_outcome_id_fkey FOREIGN KEY (learning_outcome_id) REFERENCES public.learning_outcomes(id) ON DELETE CASCADE;


--
-- Name: alertas_bajo_desempenio alertas_bajo_desempenio_competencia_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alertas_bajo_desempenio
    ADD CONSTRAINT alertas_bajo_desempenio_competencia_id_fkey FOREIGN KEY (competencia_id) REFERENCES public.competencies(id) ON DELETE CASCADE;


--
-- Name: alertas_bajo_desempenio alertas_bajo_desempenio_docente_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alertas_bajo_desempenio
    ADD CONSTRAINT alertas_bajo_desempenio_docente_id_fkey FOREIGN KEY (docente_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: alertas_bajo_desempenio alertas_bajo_desempenio_estudiante_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alertas_bajo_desempenio
    ADD CONSTRAINT alertas_bajo_desempenio_estudiante_id_fkey FOREIGN KEY (estudiante_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: asistencias asistencias_curso_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asistencias
    ADD CONSTRAINT asistencias_curso_id_fkey FOREIGN KEY (curso_id) REFERENCES public.cursos(id);


--
-- Name: asistencias asistencias_docente_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asistencias
    ADD CONSTRAINT asistencias_docente_id_fkey FOREIGN KEY (docente_id) REFERENCES public.users(id);


--
-- Name: asistencias asistencias_estudiante_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asistencias
    ADD CONSTRAINT asistencias_estudiante_id_fkey FOREIGN KEY (estudiante_id) REFERENCES public.users(id);


--
-- Name: audits audits_criteria_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.audits
    ADD CONSTRAINT audits_criteria_id_fkey FOREIGN KEY (criteria_id) REFERENCES public.criteria(id);


--
-- Name: audits audits_student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.audits
    ADD CONSTRAINT audits_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.users(id);


--
-- Name: audits audits_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.audits
    ADD CONSTRAINT audits_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: competencies competencias_docente_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.competencies
    ADD CONSTRAINT competencias_docente_id_fkey FOREIGN KEY (teacher_id) REFERENCES public.users(id);


--
-- Name: criteria criteria_learning_outcome_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.criteria
    ADD CONSTRAINT criteria_learning_outcome_id_fkey FOREIGN KEY (learning_outcome_id) REFERENCES public.learning_outcomes(id) ON DELETE CASCADE;


--
-- Name: cursos cursos_docente_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cursos
    ADD CONSTRAINT cursos_docente_id_fkey FOREIGN KEY (docente_id) REFERENCES public.users(id);


--
-- Name: docente_curso docente_curso_curso_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.docente_curso
    ADD CONSTRAINT docente_curso_curso_id_fkey FOREIGN KEY (curso_id) REFERENCES public.cursos(id);


--
-- Name: docente_curso docente_curso_docente_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.docente_curso
    ADD CONSTRAINT docente_curso_docente_id_fkey FOREIGN KEY (docente_id) REFERENCES public.users(id);


--
-- Name: estudiante_curso estudiante_curso_curso_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.estudiante_curso
    ADD CONSTRAINT estudiante_curso_curso_id_fkey FOREIGN KEY (curso_id) REFERENCES public.cursos(id);


--
-- Name: estudiante_curso estudiante_curso_estudiante_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.estudiante_curso
    ADD CONSTRAINT estudiante_curso_estudiante_id_fkey FOREIGN KEY (estudiante_id) REFERENCES public.users(id);


--
-- Name: evaluation_metadata evaluation_metadata_docente_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.evaluation_metadata
    ADD CONSTRAINT evaluation_metadata_docente_id_fkey FOREIGN KEY (docente_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: evaluation_metadata evaluation_metadata_evaluacion_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.evaluation_metadata
    ADD CONSTRAINT evaluation_metadata_evaluacion_id_fkey FOREIGN KEY (evaluacion_id) REFERENCES public.evaluations(id) ON DELETE CASCADE;


--
-- Name: evaluations evaluations_activity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.evaluations
    ADD CONSTRAINT evaluations_activity_id_fkey FOREIGN KEY (activity_id) REFERENCES public.activities(id) ON DELETE CASCADE;


--
-- Name: evaluations evaluations_criteria_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.evaluations
    ADD CONSTRAINT evaluations_criteria_id_fkey FOREIGN KEY (criteria_id) REFERENCES public.criteria(id) ON DELETE CASCADE;


--
-- Name: evaluations evaluations_student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.evaluations
    ADD CONSTRAINT evaluations_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: evaluations evaluations_teacher_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.evaluations
    ADD CONSTRAINT evaluations_teacher_id_fkey FOREIGN KEY (teacher_id) REFERENCES public.users(id);


--
-- Name: evidence evidence_actividad_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.evidence
    ADD CONSTRAINT evidence_actividad_id_fkey FOREIGN KEY (actividad_id) REFERENCES public.activities(id) ON DELETE CASCADE;


--
-- Name: evidence evidence_activity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.evidence
    ADD CONSTRAINT evidence_activity_id_fkey FOREIGN KEY (activity_id) REFERENCES public.activities(id) ON DELETE CASCADE;


--
-- Name: evidence evidence_student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.evidence
    ADD CONSTRAINT evidence_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: final_grades final_grades_learning_outcome_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.final_grades
    ADD CONSTRAINT final_grades_learning_outcome_id_fkey FOREIGN KEY (learning_outcome_id) REFERENCES public.learning_outcomes(id) ON DELETE CASCADE;


--
-- Name: final_grades final_grades_student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.final_grades
    ADD CONSTRAINT final_grades_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: learning_outcomes learning_outcomes_competency_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.learning_outcomes
    ADD CONSTRAINT learning_outcomes_competency_id_fkey FOREIGN KEY (competency_id) REFERENCES public.competencies(id) ON DELETE CASCADE;


--
-- Name: notificaciones notificaciones_estudiante_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notificaciones
    ADD CONSTRAINT notificaciones_estudiante_id_fkey FOREIGN KEY (estudiante_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: progreso_snapshots progreso_snapshots_competencia_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.progreso_snapshots
    ADD CONSTRAINT progreso_snapshots_competencia_id_fkey FOREIGN KEY (competencia_id) REFERENCES public.competencies(id) ON DELETE CASCADE;


--
-- Name: progreso_snapshots progreso_snapshots_estudiante_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.progreso_snapshots
    ADD CONSTRAINT progreso_snapshots_estudiante_id_fkey FOREIGN KEY (estudiante_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: re_evaluaciones re_evaluaciones_competencia_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.re_evaluaciones
    ADD CONSTRAINT re_evaluaciones_competencia_id_fkey FOREIGN KEY (competencia_id) REFERENCES public.competencies(id) ON DELETE CASCADE;


--
-- Name: re_evaluaciones re_evaluaciones_estudiante_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.re_evaluaciones
    ADD CONSTRAINT re_evaluaciones_estudiante_id_fkey FOREIGN KEY (estudiante_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: reports reports_teacher_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reports
    ADD CONSTRAINT reports_teacher_id_fkey FOREIGN KEY (teacher_id) REFERENCES public.users(id);


--
-- Name: rubricas rubricas_docente_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rubricas
    ADD CONSTRAINT rubricas_docente_id_fkey FOREIGN KEY (docente_id) REFERENCES public.users(id);


--
-- Name: student_section student_section_section_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_section
    ADD CONSTRAINT student_section_section_id_fkey FOREIGN KEY (section_id) REFERENCES public.sections(id);


--
-- Name: student_section student_section_student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_section
    ADD CONSTRAINT student_section_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.users(id);


--
-- Name: student_tracking student_tracking_competency_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_tracking
    ADD CONSTRAINT student_tracking_competency_id_fkey FOREIGN KEY (competency_id) REFERENCES public.competencies(id);


--
-- Name: student_tracking student_tracking_student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_tracking
    ADD CONSTRAINT student_tracking_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: teacher_section teacher_section_section_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teacher_section
    ADD CONSTRAINT teacher_section_section_id_fkey FOREIGN KEY (section_id) REFERENCES public.sections(id);


--
-- Name: teacher_section teacher_section_teacher_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teacher_section
    ADD CONSTRAINT teacher_section_teacher_id_fkey FOREIGN KEY (teacher_id) REFERENCES public.users(id);


--
-- Name: user_roles user_roles_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_roles
    ADD CONSTRAINT user_roles_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.roles(id) ON DELETE CASCADE;


--
-- Name: user_roles user_roles_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_roles
    ADD CONSTRAINT user_roles_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: objects objects_bucketId_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.objects
    ADD CONSTRAINT "objects_bucketId_fkey" FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- Name: s3_multipart_uploads s3_multipart_uploads_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads
    ADD CONSTRAINT s3_multipart_uploads_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_upload_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_upload_id_fkey FOREIGN KEY (upload_id) REFERENCES storage.s3_multipart_uploads(id) ON DELETE CASCADE;


--
-- Name: vector_indexes vector_indexes_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.vector_indexes
    ADD CONSTRAINT vector_indexes_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets_vectors(id);


--
-- Name: audit_log_entries; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.audit_log_entries ENABLE ROW LEVEL SECURITY;

--
-- Name: flow_state; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.flow_state ENABLE ROW LEVEL SECURITY;

--
-- Name: identities; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.identities ENABLE ROW LEVEL SECURITY;

--
-- Name: instances; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.instances ENABLE ROW LEVEL SECURITY;

--
-- Name: mfa_amr_claims; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.mfa_amr_claims ENABLE ROW LEVEL SECURITY;

--
-- Name: mfa_challenges; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.mfa_challenges ENABLE ROW LEVEL SECURITY;

--
-- Name: mfa_factors; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.mfa_factors ENABLE ROW LEVEL SECURITY;

--
-- Name: one_time_tokens; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.one_time_tokens ENABLE ROW LEVEL SECURITY;

--
-- Name: refresh_tokens; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.refresh_tokens ENABLE ROW LEVEL SECURITY;

--
-- Name: saml_providers; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.saml_providers ENABLE ROW LEVEL SECURITY;

--
-- Name: saml_relay_states; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.saml_relay_states ENABLE ROW LEVEL SECURITY;

--
-- Name: schema_migrations; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.schema_migrations ENABLE ROW LEVEL SECURITY;

--
-- Name: sessions; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.sessions ENABLE ROW LEVEL SECURITY;

--
-- Name: sso_domains; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.sso_domains ENABLE ROW LEVEL SECURITY;

--
-- Name: sso_providers; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.sso_providers ENABLE ROW LEVEL SECURITY;

--
-- Name: users; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.users ENABLE ROW LEVEL SECURITY;

--
-- Name: messages; Type: ROW SECURITY; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER TABLE realtime.messages ENABLE ROW LEVEL SECURITY;

--
-- Name: buckets Enable insert for authenticated users only; Type: POLICY; Schema: storage; Owner: supabase_storage_admin
--

CREATE POLICY "Enable insert for authenticated users only" ON storage.buckets FOR INSERT TO authenticated WITH CHECK (true);


--
-- Name: buckets; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.buckets ENABLE ROW LEVEL SECURITY;

--
-- Name: buckets_analytics; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.buckets_analytics ENABLE ROW LEVEL SECURITY;

--
-- Name: buckets_vectors; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.buckets_vectors ENABLE ROW LEVEL SECURITY;

--
-- Name: migrations; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.migrations ENABLE ROW LEVEL SECURITY;

--
-- Name: objects; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.objects ENABLE ROW LEVEL SECURITY;

--
-- Name: s3_multipart_uploads; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.s3_multipart_uploads ENABLE ROW LEVEL SECURITY;

--
-- Name: s3_multipart_uploads_parts; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.s3_multipart_uploads_parts ENABLE ROW LEVEL SECURITY;

--
-- Name: vector_indexes; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.vector_indexes ENABLE ROW LEVEL SECURITY;

--
-- Name: supabase_realtime; Type: PUBLICATION; Schema: -; Owner: postgres
--

CREATE PUBLICATION supabase_realtime WITH (publish = 'insert, update, delete, truncate');


ALTER PUBLICATION supabase_realtime OWNER TO postgres;

--
-- Name: SCHEMA auth; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA auth TO anon;
GRANT USAGE ON SCHEMA auth TO authenticated;
GRANT USAGE ON SCHEMA auth TO service_role;
GRANT ALL ON SCHEMA auth TO supabase_auth_admin;
GRANT ALL ON SCHEMA auth TO dashboard_user;
GRANT USAGE ON SCHEMA auth TO postgres;


--
-- Name: SCHEMA extensions; Type: ACL; Schema: -; Owner: postgres
--

GRANT USAGE ON SCHEMA extensions TO anon;
GRANT USAGE ON SCHEMA extensions TO authenticated;
GRANT USAGE ON SCHEMA extensions TO service_role;
GRANT ALL ON SCHEMA extensions TO dashboard_user;


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: pg_database_owner
--

GRANT USAGE ON SCHEMA public TO postgres;
GRANT USAGE ON SCHEMA public TO anon;
GRANT USAGE ON SCHEMA public TO authenticated;
GRANT USAGE ON SCHEMA public TO service_role;


--
-- Name: SCHEMA realtime; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA realtime TO postgres;
GRANT USAGE ON SCHEMA realtime TO anon;
GRANT USAGE ON SCHEMA realtime TO authenticated;
GRANT USAGE ON SCHEMA realtime TO service_role;
GRANT ALL ON SCHEMA realtime TO supabase_realtime_admin;


--
-- Name: SCHEMA storage; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA storage TO postgres WITH GRANT OPTION;
GRANT USAGE ON SCHEMA storage TO anon;
GRANT USAGE ON SCHEMA storage TO authenticated;
GRANT USAGE ON SCHEMA storage TO service_role;
GRANT ALL ON SCHEMA storage TO supabase_storage_admin WITH GRANT OPTION;
GRANT ALL ON SCHEMA storage TO dashboard_user;


--
-- Name: SCHEMA vault; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA vault TO postgres WITH GRANT OPTION;
GRANT USAGE ON SCHEMA vault TO service_role;


--
-- Name: FUNCTION email(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.email() TO dashboard_user;


--
-- Name: FUNCTION jwt(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.jwt() TO postgres;
GRANT ALL ON FUNCTION auth.jwt() TO dashboard_user;


--
-- Name: FUNCTION role(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.role() TO dashboard_user;


--
-- Name: FUNCTION uid(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.uid() TO dashboard_user;


--
-- Name: FUNCTION armor(bytea); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.armor(bytea) FROM postgres;
GRANT ALL ON FUNCTION extensions.armor(bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.armor(bytea) TO dashboard_user;


--
-- Name: FUNCTION armor(bytea, text[], text[]); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.armor(bytea, text[], text[]) FROM postgres;
GRANT ALL ON FUNCTION extensions.armor(bytea, text[], text[]) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.armor(bytea, text[], text[]) TO dashboard_user;


--
-- Name: FUNCTION crypt(text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.crypt(text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.crypt(text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.crypt(text, text) TO dashboard_user;


--
-- Name: FUNCTION dearmor(text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.dearmor(text) FROM postgres;
GRANT ALL ON FUNCTION extensions.dearmor(text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.dearmor(text) TO dashboard_user;


--
-- Name: FUNCTION decrypt(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.decrypt(bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.decrypt(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.decrypt(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION decrypt_iv(bytea, bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.decrypt_iv(bytea, bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.decrypt_iv(bytea, bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.decrypt_iv(bytea, bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION digest(bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.digest(bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.digest(bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.digest(bytea, text) TO dashboard_user;


--
-- Name: FUNCTION digest(text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.digest(text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.digest(text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.digest(text, text) TO dashboard_user;


--
-- Name: FUNCTION encrypt(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.encrypt(bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.encrypt(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.encrypt(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION encrypt_iv(bytea, bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.encrypt_iv(bytea, bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.encrypt_iv(bytea, bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.encrypt_iv(bytea, bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION gen_random_bytes(integer); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.gen_random_bytes(integer) FROM postgres;
GRANT ALL ON FUNCTION extensions.gen_random_bytes(integer) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.gen_random_bytes(integer) TO dashboard_user;


--
-- Name: FUNCTION gen_random_uuid(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.gen_random_uuid() FROM postgres;
GRANT ALL ON FUNCTION extensions.gen_random_uuid() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.gen_random_uuid() TO dashboard_user;


--
-- Name: FUNCTION gen_salt(text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.gen_salt(text) FROM postgres;
GRANT ALL ON FUNCTION extensions.gen_salt(text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.gen_salt(text) TO dashboard_user;


--
-- Name: FUNCTION gen_salt(text, integer); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.gen_salt(text, integer) FROM postgres;
GRANT ALL ON FUNCTION extensions.gen_salt(text, integer) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.gen_salt(text, integer) TO dashboard_user;


--
-- Name: FUNCTION grant_pg_cron_access(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

REVOKE ALL ON FUNCTION extensions.grant_pg_cron_access() FROM supabase_admin;
GRANT ALL ON FUNCTION extensions.grant_pg_cron_access() TO supabase_admin WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.grant_pg_cron_access() TO dashboard_user;


--
-- Name: FUNCTION grant_pg_graphql_access(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.grant_pg_graphql_access() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION grant_pg_net_access(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

REVOKE ALL ON FUNCTION extensions.grant_pg_net_access() FROM supabase_admin;
GRANT ALL ON FUNCTION extensions.grant_pg_net_access() TO supabase_admin WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.grant_pg_net_access() TO dashboard_user;


--
-- Name: FUNCTION hmac(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.hmac(bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.hmac(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.hmac(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION hmac(text, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.hmac(text, text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.hmac(text, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.hmac(text, text, text) TO dashboard_user;


--
-- Name: FUNCTION pg_stat_statements(showtext boolean, OUT userid oid, OUT dbid oid, OUT toplevel boolean, OUT queryid bigint, OUT query text, OUT plans bigint, OUT total_plan_time double precision, OUT min_plan_time double precision, OUT max_plan_time double precision, OUT mean_plan_time double precision, OUT stddev_plan_time double precision, OUT calls bigint, OUT total_exec_time double precision, OUT min_exec_time double precision, OUT max_exec_time double precision, OUT mean_exec_time double precision, OUT stddev_exec_time double precision, OUT rows bigint, OUT shared_blks_hit bigint, OUT shared_blks_read bigint, OUT shared_blks_dirtied bigint, OUT shared_blks_written bigint, OUT local_blks_hit bigint, OUT local_blks_read bigint, OUT local_blks_dirtied bigint, OUT local_blks_written bigint, OUT temp_blks_read bigint, OUT temp_blks_written bigint, OUT shared_blk_read_time double precision, OUT shared_blk_write_time double precision, OUT local_blk_read_time double precision, OUT local_blk_write_time double precision, OUT temp_blk_read_time double precision, OUT temp_blk_write_time double precision, OUT wal_records bigint, OUT wal_fpi bigint, OUT wal_bytes numeric, OUT jit_functions bigint, OUT jit_generation_time double precision, OUT jit_inlining_count bigint, OUT jit_inlining_time double precision, OUT jit_optimization_count bigint, OUT jit_optimization_time double precision, OUT jit_emission_count bigint, OUT jit_emission_time double precision, OUT jit_deform_count bigint, OUT jit_deform_time double precision, OUT stats_since timestamp with time zone, OUT minmax_stats_since timestamp with time zone); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pg_stat_statements(showtext boolean, OUT userid oid, OUT dbid oid, OUT toplevel boolean, OUT queryid bigint, OUT query text, OUT plans bigint, OUT total_plan_time double precision, OUT min_plan_time double precision, OUT max_plan_time double precision, OUT mean_plan_time double precision, OUT stddev_plan_time double precision, OUT calls bigint, OUT total_exec_time double precision, OUT min_exec_time double precision, OUT max_exec_time double precision, OUT mean_exec_time double precision, OUT stddev_exec_time double precision, OUT rows bigint, OUT shared_blks_hit bigint, OUT shared_blks_read bigint, OUT shared_blks_dirtied bigint, OUT shared_blks_written bigint, OUT local_blks_hit bigint, OUT local_blks_read bigint, OUT local_blks_dirtied bigint, OUT local_blks_written bigint, OUT temp_blks_read bigint, OUT temp_blks_written bigint, OUT shared_blk_read_time double precision, OUT shared_blk_write_time double precision, OUT local_blk_read_time double precision, OUT local_blk_write_time double precision, OUT temp_blk_read_time double precision, OUT temp_blk_write_time double precision, OUT wal_records bigint, OUT wal_fpi bigint, OUT wal_bytes numeric, OUT jit_functions bigint, OUT jit_generation_time double precision, OUT jit_inlining_count bigint, OUT jit_inlining_time double precision, OUT jit_optimization_count bigint, OUT jit_optimization_time double precision, OUT jit_emission_count bigint, OUT jit_emission_time double precision, OUT jit_deform_count bigint, OUT jit_deform_time double precision, OUT stats_since timestamp with time zone, OUT minmax_stats_since timestamp with time zone) FROM postgres;
GRANT ALL ON FUNCTION extensions.pg_stat_statements(showtext boolean, OUT userid oid, OUT dbid oid, OUT toplevel boolean, OUT queryid bigint, OUT query text, OUT plans bigint, OUT total_plan_time double precision, OUT min_plan_time double precision, OUT max_plan_time double precision, OUT mean_plan_time double precision, OUT stddev_plan_time double precision, OUT calls bigint, OUT total_exec_time double precision, OUT min_exec_time double precision, OUT max_exec_time double precision, OUT mean_exec_time double precision, OUT stddev_exec_time double precision, OUT rows bigint, OUT shared_blks_hit bigint, OUT shared_blks_read bigint, OUT shared_blks_dirtied bigint, OUT shared_blks_written bigint, OUT local_blks_hit bigint, OUT local_blks_read bigint, OUT local_blks_dirtied bigint, OUT local_blks_written bigint, OUT temp_blks_read bigint, OUT temp_blks_written bigint, OUT shared_blk_read_time double precision, OUT shared_blk_write_time double precision, OUT local_blk_read_time double precision, OUT local_blk_write_time double precision, OUT temp_blk_read_time double precision, OUT temp_blk_write_time double precision, OUT wal_records bigint, OUT wal_fpi bigint, OUT wal_bytes numeric, OUT jit_functions bigint, OUT jit_generation_time double precision, OUT jit_inlining_count bigint, OUT jit_inlining_time double precision, OUT jit_optimization_count bigint, OUT jit_optimization_time double precision, OUT jit_emission_count bigint, OUT jit_emission_time double precision, OUT jit_deform_count bigint, OUT jit_deform_time double precision, OUT stats_since timestamp with time zone, OUT minmax_stats_since timestamp with time zone) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pg_stat_statements(showtext boolean, OUT userid oid, OUT dbid oid, OUT toplevel boolean, OUT queryid bigint, OUT query text, OUT plans bigint, OUT total_plan_time double precision, OUT min_plan_time double precision, OUT max_plan_time double precision, OUT mean_plan_time double precision, OUT stddev_plan_time double precision, OUT calls bigint, OUT total_exec_time double precision, OUT min_exec_time double precision, OUT max_exec_time double precision, OUT mean_exec_time double precision, OUT stddev_exec_time double precision, OUT rows bigint, OUT shared_blks_hit bigint, OUT shared_blks_read bigint, OUT shared_blks_dirtied bigint, OUT shared_blks_written bigint, OUT local_blks_hit bigint, OUT local_blks_read bigint, OUT local_blks_dirtied bigint, OUT local_blks_written bigint, OUT temp_blks_read bigint, OUT temp_blks_written bigint, OUT shared_blk_read_time double precision, OUT shared_blk_write_time double precision, OUT local_blk_read_time double precision, OUT local_blk_write_time double precision, OUT temp_blk_read_time double precision, OUT temp_blk_write_time double precision, OUT wal_records bigint, OUT wal_fpi bigint, OUT wal_bytes numeric, OUT jit_functions bigint, OUT jit_generation_time double precision, OUT jit_inlining_count bigint, OUT jit_inlining_time double precision, OUT jit_optimization_count bigint, OUT jit_optimization_time double precision, OUT jit_emission_count bigint, OUT jit_emission_time double precision, OUT jit_deform_count bigint, OUT jit_deform_time double precision, OUT stats_since timestamp with time zone, OUT minmax_stats_since timestamp with time zone) TO dashboard_user;


--
-- Name: FUNCTION pg_stat_statements_info(OUT dealloc bigint, OUT stats_reset timestamp with time zone); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pg_stat_statements_info(OUT dealloc bigint, OUT stats_reset timestamp with time zone) FROM postgres;
GRANT ALL ON FUNCTION extensions.pg_stat_statements_info(OUT dealloc bigint, OUT stats_reset timestamp with time zone) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pg_stat_statements_info(OUT dealloc bigint, OUT stats_reset timestamp with time zone) TO dashboard_user;


--
-- Name: FUNCTION pg_stat_statements_reset(userid oid, dbid oid, queryid bigint, minmax_only boolean); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pg_stat_statements_reset(userid oid, dbid oid, queryid bigint, minmax_only boolean) FROM postgres;
GRANT ALL ON FUNCTION extensions.pg_stat_statements_reset(userid oid, dbid oid, queryid bigint, minmax_only boolean) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pg_stat_statements_reset(userid oid, dbid oid, queryid bigint, minmax_only boolean) TO dashboard_user;


--
-- Name: FUNCTION pgp_armor_headers(text, OUT key text, OUT value text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_armor_headers(text, OUT key text, OUT value text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_armor_headers(text, OUT key text, OUT value text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_armor_headers(text, OUT key text, OUT value text) TO dashboard_user;


--
-- Name: FUNCTION pgp_key_id(bytea); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_key_id(bytea) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_key_id(bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_key_id(bytea) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt(bytea, bytea); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt(bytea, bytea, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt_bytea(bytea, bytea); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt_bytea(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt_bytea(bytea, bytea, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_encrypt(text, bytea); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_encrypt(text, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_encrypt_bytea(bytea, bytea); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_encrypt_bytea(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_decrypt(bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_decrypt(bytea, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_decrypt_bytea(bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_decrypt_bytea(bytea, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_encrypt(text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_encrypt(text, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_encrypt_bytea(bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_encrypt_bytea(bytea, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text, text) TO dashboard_user;


--
-- Name: FUNCTION pgrst_ddl_watch(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgrst_ddl_watch() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgrst_drop_watch(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgrst_drop_watch() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION set_graphql_placeholder(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.set_graphql_placeholder() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION uuid_generate_v1(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_generate_v1() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_generate_v1() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_generate_v1() TO dashboard_user;


--
-- Name: FUNCTION uuid_generate_v1mc(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_generate_v1mc() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_generate_v1mc() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_generate_v1mc() TO dashboard_user;


--
-- Name: FUNCTION uuid_generate_v3(namespace uuid, name text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_generate_v3(namespace uuid, name text) FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_generate_v3(namespace uuid, name text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_generate_v3(namespace uuid, name text) TO dashboard_user;


--
-- Name: FUNCTION uuid_generate_v4(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_generate_v4() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_generate_v4() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_generate_v4() TO dashboard_user;


--
-- Name: FUNCTION uuid_generate_v5(namespace uuid, name text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_generate_v5(namespace uuid, name text) FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_generate_v5(namespace uuid, name text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_generate_v5(namespace uuid, name text) TO dashboard_user;


--
-- Name: FUNCTION uuid_nil(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_nil() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_nil() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_nil() TO dashboard_user;


--
-- Name: FUNCTION uuid_ns_dns(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_ns_dns() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_ns_dns() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_ns_dns() TO dashboard_user;


--
-- Name: FUNCTION uuid_ns_oid(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_ns_oid() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_ns_oid() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_ns_oid() TO dashboard_user;


--
-- Name: FUNCTION uuid_ns_url(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_ns_url() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_ns_url() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_ns_url() TO dashboard_user;


--
-- Name: FUNCTION uuid_ns_x500(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_ns_x500() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_ns_x500() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_ns_x500() TO dashboard_user;


--
-- Name: FUNCTION graphql("operationName" text, query text, variables jsonb, extensions jsonb); Type: ACL; Schema: graphql_public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO postgres;
GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO anon;
GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO authenticated;
GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO service_role;


--
-- Name: FUNCTION pg_reload_conf(); Type: ACL; Schema: pg_catalog; Owner: supabase_admin
--

GRANT ALL ON FUNCTION pg_catalog.pg_reload_conf() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION get_auth(p_usename text); Type: ACL; Schema: pgbouncer; Owner: supabase_admin
--

REVOKE ALL ON FUNCTION pgbouncer.get_auth(p_usename text) FROM PUBLIC;
GRANT ALL ON FUNCTION pgbouncer.get_auth(p_usename text) TO pgbouncer;


--
-- Name: FUNCTION apply_rls(wal jsonb, max_record_bytes integer); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO postgres;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO anon;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO authenticated;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO service_role;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO supabase_realtime_admin;


--
-- Name: FUNCTION broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text) TO postgres;
GRANT ALL ON FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text) TO dashboard_user;


--
-- Name: FUNCTION build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO postgres;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO anon;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO authenticated;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO service_role;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO supabase_realtime_admin;


--
-- Name: FUNCTION "cast"(val text, type_ regtype); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO postgres;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO dashboard_user;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO anon;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO authenticated;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO service_role;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO supabase_realtime_admin;


--
-- Name: FUNCTION check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO postgres;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO anon;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO authenticated;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO service_role;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO supabase_realtime_admin;


--
-- Name: FUNCTION is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO postgres;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO anon;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO authenticated;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO service_role;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO supabase_realtime_admin;


--
-- Name: FUNCTION list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO postgres;
GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO dashboard_user;


--
-- Name: FUNCTION quote_wal2json(entity regclass); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO postgres;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO anon;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO authenticated;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO service_role;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO supabase_realtime_admin;


--
-- Name: FUNCTION send(payload jsonb, event text, topic text, private boolean); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean) TO postgres;
GRANT ALL ON FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean) TO dashboard_user;


--
-- Name: FUNCTION subscription_check_filters(); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO postgres;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO dashboard_user;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO anon;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO authenticated;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO service_role;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO supabase_realtime_admin;


--
-- Name: FUNCTION to_regrole(role_name text); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO postgres;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO anon;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO authenticated;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO service_role;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO supabase_realtime_admin;


--
-- Name: FUNCTION topic(); Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON FUNCTION realtime.topic() TO postgres;
GRANT ALL ON FUNCTION realtime.topic() TO dashboard_user;


--
-- Name: FUNCTION _crypto_aead_det_decrypt(message bytea, additional bytea, key_id bigint, context bytea, nonce bytea); Type: ACL; Schema: vault; Owner: supabase_admin
--

GRANT ALL ON FUNCTION vault._crypto_aead_det_decrypt(message bytea, additional bytea, key_id bigint, context bytea, nonce bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION vault._crypto_aead_det_decrypt(message bytea, additional bytea, key_id bigint, context bytea, nonce bytea) TO service_role;


--
-- Name: FUNCTION create_secret(new_secret text, new_name text, new_description text, new_key_id uuid); Type: ACL; Schema: vault; Owner: supabase_admin
--

GRANT ALL ON FUNCTION vault.create_secret(new_secret text, new_name text, new_description text, new_key_id uuid) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION vault.create_secret(new_secret text, new_name text, new_description text, new_key_id uuid) TO service_role;


--
-- Name: FUNCTION update_secret(secret_id uuid, new_secret text, new_name text, new_description text, new_key_id uuid); Type: ACL; Schema: vault; Owner: supabase_admin
--

GRANT ALL ON FUNCTION vault.update_secret(secret_id uuid, new_secret text, new_name text, new_description text, new_key_id uuid) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION vault.update_secret(secret_id uuid, new_secret text, new_name text, new_description text, new_key_id uuid) TO service_role;


--
-- Name: TABLE audit_log_entries; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.audit_log_entries TO dashboard_user;
GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.audit_log_entries TO postgres;
GRANT SELECT ON TABLE auth.audit_log_entries TO postgres WITH GRANT OPTION;


--
-- Name: TABLE custom_oauth_providers; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.custom_oauth_providers TO postgres;
GRANT ALL ON TABLE auth.custom_oauth_providers TO dashboard_user;


--
-- Name: TABLE flow_state; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.flow_state TO postgres;
GRANT SELECT ON TABLE auth.flow_state TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.flow_state TO dashboard_user;


--
-- Name: TABLE identities; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.identities TO postgres;
GRANT SELECT ON TABLE auth.identities TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.identities TO dashboard_user;


--
-- Name: TABLE instances; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.instances TO dashboard_user;
GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.instances TO postgres;
GRANT SELECT ON TABLE auth.instances TO postgres WITH GRANT OPTION;


--
-- Name: TABLE mfa_amr_claims; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.mfa_amr_claims TO postgres;
GRANT SELECT ON TABLE auth.mfa_amr_claims TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.mfa_amr_claims TO dashboard_user;


--
-- Name: TABLE mfa_challenges; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.mfa_challenges TO postgres;
GRANT SELECT ON TABLE auth.mfa_challenges TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.mfa_challenges TO dashboard_user;


--
-- Name: TABLE mfa_factors; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.mfa_factors TO postgres;
GRANT SELECT ON TABLE auth.mfa_factors TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.mfa_factors TO dashboard_user;


--
-- Name: TABLE oauth_authorizations; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.oauth_authorizations TO postgres;
GRANT ALL ON TABLE auth.oauth_authorizations TO dashboard_user;


--
-- Name: TABLE oauth_client_states; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.oauth_client_states TO postgres;
GRANT ALL ON TABLE auth.oauth_client_states TO dashboard_user;


--
-- Name: TABLE oauth_clients; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.oauth_clients TO postgres;
GRANT ALL ON TABLE auth.oauth_clients TO dashboard_user;


--
-- Name: TABLE oauth_consents; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.oauth_consents TO postgres;
GRANT ALL ON TABLE auth.oauth_consents TO dashboard_user;


--
-- Name: TABLE one_time_tokens; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.one_time_tokens TO postgres;
GRANT SELECT ON TABLE auth.one_time_tokens TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.one_time_tokens TO dashboard_user;


--
-- Name: TABLE refresh_tokens; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.refresh_tokens TO dashboard_user;
GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.refresh_tokens TO postgres;
GRANT SELECT ON TABLE auth.refresh_tokens TO postgres WITH GRANT OPTION;


--
-- Name: SEQUENCE refresh_tokens_id_seq; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON SEQUENCE auth.refresh_tokens_id_seq TO dashboard_user;
GRANT ALL ON SEQUENCE auth.refresh_tokens_id_seq TO postgres;


--
-- Name: TABLE saml_providers; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.saml_providers TO postgres;
GRANT SELECT ON TABLE auth.saml_providers TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.saml_providers TO dashboard_user;


--
-- Name: TABLE saml_relay_states; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.saml_relay_states TO postgres;
GRANT SELECT ON TABLE auth.saml_relay_states TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.saml_relay_states TO dashboard_user;


--
-- Name: TABLE schema_migrations; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT SELECT ON TABLE auth.schema_migrations TO postgres WITH GRANT OPTION;


--
-- Name: TABLE sessions; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.sessions TO postgres;
GRANT SELECT ON TABLE auth.sessions TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.sessions TO dashboard_user;


--
-- Name: TABLE sso_domains; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.sso_domains TO postgres;
GRANT SELECT ON TABLE auth.sso_domains TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.sso_domains TO dashboard_user;


--
-- Name: TABLE sso_providers; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.sso_providers TO postgres;
GRANT SELECT ON TABLE auth.sso_providers TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.sso_providers TO dashboard_user;


--
-- Name: TABLE users; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.users TO dashboard_user;
GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.users TO postgres;
GRANT SELECT ON TABLE auth.users TO postgres WITH GRANT OPTION;


--
-- Name: TABLE webauthn_challenges; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.webauthn_challenges TO postgres;
GRANT ALL ON TABLE auth.webauthn_challenges TO dashboard_user;


--
-- Name: TABLE webauthn_credentials; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.webauthn_credentials TO postgres;
GRANT ALL ON TABLE auth.webauthn_credentials TO dashboard_user;


--
-- Name: TABLE pg_stat_statements; Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON TABLE extensions.pg_stat_statements FROM postgres;
GRANT ALL ON TABLE extensions.pg_stat_statements TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE extensions.pg_stat_statements TO dashboard_user;


--
-- Name: TABLE pg_stat_statements_info; Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON TABLE extensions.pg_stat_statements_info FROM postgres;
GRANT ALL ON TABLE extensions.pg_stat_statements_info TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE extensions.pg_stat_statements_info TO dashboard_user;


--
-- Name: TABLE activities; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.activities TO anon;
GRANT ALL ON TABLE public.activities TO authenticated;
GRANT ALL ON TABLE public.activities TO service_role;


--
-- Name: TABLE alertas_bajo_desempenio; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.alertas_bajo_desempenio TO anon;
GRANT ALL ON TABLE public.alertas_bajo_desempenio TO authenticated;
GRANT ALL ON TABLE public.alertas_bajo_desempenio TO service_role;


--
-- Name: TABLE asistencias; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.asistencias TO anon;
GRANT ALL ON TABLE public.asistencias TO authenticated;
GRANT ALL ON TABLE public.asistencias TO service_role;


--
-- Name: TABLE audits; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.audits TO anon;
GRANT ALL ON TABLE public.audits TO authenticated;
GRANT ALL ON TABLE public.audits TO service_role;


--
-- Name: TABLE competencies; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.competencies TO anon;
GRANT ALL ON TABLE public.competencies TO authenticated;
GRANT ALL ON TABLE public.competencies TO service_role;


--
-- Name: TABLE configuration; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.configuration TO anon;
GRANT ALL ON TABLE public.configuration TO authenticated;
GRANT ALL ON TABLE public.configuration TO service_role;


--
-- Name: TABLE criteria; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.criteria TO anon;
GRANT ALL ON TABLE public.criteria TO authenticated;
GRANT ALL ON TABLE public.criteria TO service_role;


--
-- Name: TABLE cursos; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.cursos TO anon;
GRANT ALL ON TABLE public.cursos TO authenticated;
GRANT ALL ON TABLE public.cursos TO service_role;


--
-- Name: TABLE docente_curso; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.docente_curso TO anon;
GRANT ALL ON TABLE public.docente_curso TO authenticated;
GRANT ALL ON TABLE public.docente_curso TO service_role;


--
-- Name: TABLE estudiante_curso; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.estudiante_curso TO anon;
GRANT ALL ON TABLE public.estudiante_curso TO authenticated;
GRANT ALL ON TABLE public.estudiante_curso TO service_role;


--
-- Name: TABLE evaluation_metadata; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.evaluation_metadata TO anon;
GRANT ALL ON TABLE public.evaluation_metadata TO authenticated;
GRANT ALL ON TABLE public.evaluation_metadata TO service_role;


--
-- Name: TABLE evaluations; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.evaluations TO anon;
GRANT ALL ON TABLE public.evaluations TO authenticated;
GRANT ALL ON TABLE public.evaluations TO service_role;


--
-- Name: TABLE evidence; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.evidence TO anon;
GRANT ALL ON TABLE public.evidence TO authenticated;
GRANT ALL ON TABLE public.evidence TO service_role;


--
-- Name: TABLE final_grades; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.final_grades TO anon;
GRANT ALL ON TABLE public.final_grades TO authenticated;
GRANT ALL ON TABLE public.final_grades TO service_role;


--
-- Name: TABLE learning_outcomes; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.learning_outcomes TO anon;
GRANT ALL ON TABLE public.learning_outcomes TO authenticated;
GRANT ALL ON TABLE public.learning_outcomes TO service_role;


--
-- Name: TABLE notificaciones; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.notificaciones TO anon;
GRANT ALL ON TABLE public.notificaciones TO authenticated;
GRANT ALL ON TABLE public.notificaciones TO service_role;


--
-- Name: TABLE plantillas; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.plantillas TO anon;
GRANT ALL ON TABLE public.plantillas TO authenticated;
GRANT ALL ON TABLE public.plantillas TO service_role;


--
-- Name: TABLE progreso_snapshots; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.progreso_snapshots TO anon;
GRANT ALL ON TABLE public.progreso_snapshots TO authenticated;
GRANT ALL ON TABLE public.progreso_snapshots TO service_role;


--
-- Name: TABLE re_evaluaciones; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.re_evaluaciones TO anon;
GRANT ALL ON TABLE public.re_evaluaciones TO authenticated;
GRANT ALL ON TABLE public.re_evaluaciones TO service_role;


--
-- Name: TABLE reports; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.reports TO anon;
GRANT ALL ON TABLE public.reports TO authenticated;
GRANT ALL ON TABLE public.reports TO service_role;


--
-- Name: TABLE roles; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.roles TO anon;
GRANT ALL ON TABLE public.roles TO authenticated;
GRANT ALL ON TABLE public.roles TO service_role;


--
-- Name: TABLE rubricas; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.rubricas TO anon;
GRANT ALL ON TABLE public.rubricas TO authenticated;
GRANT ALL ON TABLE public.rubricas TO service_role;


--
-- Name: TABLE sections; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.sections TO anon;
GRANT ALL ON TABLE public.sections TO authenticated;
GRANT ALL ON TABLE public.sections TO service_role;


--
-- Name: TABLE student_section; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.student_section TO anon;
GRANT ALL ON TABLE public.student_section TO authenticated;
GRANT ALL ON TABLE public.student_section TO service_role;


--
-- Name: TABLE student_tracking; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.student_tracking TO anon;
GRANT ALL ON TABLE public.student_tracking TO authenticated;
GRANT ALL ON TABLE public.student_tracking TO service_role;


--
-- Name: TABLE system_configuration; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.system_configuration TO anon;
GRANT ALL ON TABLE public.system_configuration TO authenticated;
GRANT ALL ON TABLE public.system_configuration TO service_role;


--
-- Name: TABLE teacher_section; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.teacher_section TO anon;
GRANT ALL ON TABLE public.teacher_section TO authenticated;
GRANT ALL ON TABLE public.teacher_section TO service_role;


--
-- Name: TABLE templates; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.templates TO anon;
GRANT ALL ON TABLE public.templates TO authenticated;
GRANT ALL ON TABLE public.templates TO service_role;


--
-- Name: TABLE user_roles; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.user_roles TO anon;
GRANT ALL ON TABLE public.user_roles TO authenticated;
GRANT ALL ON TABLE public.user_roles TO service_role;


--
-- Name: TABLE users; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.users TO anon;
GRANT ALL ON TABLE public.users TO authenticated;
GRANT ALL ON TABLE public.users TO service_role;


--
-- Name: TABLE messages; Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON TABLE realtime.messages TO postgres;
GRANT ALL ON TABLE realtime.messages TO dashboard_user;
GRANT SELECT,INSERT,UPDATE ON TABLE realtime.messages TO anon;
GRANT SELECT,INSERT,UPDATE ON TABLE realtime.messages TO authenticated;
GRANT SELECT,INSERT,UPDATE ON TABLE realtime.messages TO service_role;


--
-- Name: TABLE schema_migrations; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON TABLE realtime.schema_migrations TO postgres;
GRANT ALL ON TABLE realtime.schema_migrations TO dashboard_user;
GRANT SELECT ON TABLE realtime.schema_migrations TO anon;
GRANT SELECT ON TABLE realtime.schema_migrations TO authenticated;
GRANT SELECT ON TABLE realtime.schema_migrations TO service_role;
GRANT ALL ON TABLE realtime.schema_migrations TO supabase_realtime_admin;


--
-- Name: TABLE subscription; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON TABLE realtime.subscription TO postgres;
GRANT ALL ON TABLE realtime.subscription TO dashboard_user;
GRANT SELECT ON TABLE realtime.subscription TO anon;
GRANT SELECT ON TABLE realtime.subscription TO authenticated;
GRANT SELECT ON TABLE realtime.subscription TO service_role;
GRANT ALL ON TABLE realtime.subscription TO supabase_realtime_admin;


--
-- Name: SEQUENCE subscription_id_seq; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON SEQUENCE realtime.subscription_id_seq TO postgres;
GRANT ALL ON SEQUENCE realtime.subscription_id_seq TO dashboard_user;
GRANT USAGE ON SEQUENCE realtime.subscription_id_seq TO anon;
GRANT USAGE ON SEQUENCE realtime.subscription_id_seq TO authenticated;
GRANT USAGE ON SEQUENCE realtime.subscription_id_seq TO service_role;
GRANT ALL ON SEQUENCE realtime.subscription_id_seq TO supabase_realtime_admin;


--
-- Name: TABLE buckets; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

REVOKE ALL ON TABLE storage.buckets FROM supabase_storage_admin;
GRANT ALL ON TABLE storage.buckets TO supabase_storage_admin WITH GRANT OPTION;
GRANT ALL ON TABLE storage.buckets TO service_role;
GRANT ALL ON TABLE storage.buckets TO authenticated;
GRANT ALL ON TABLE storage.buckets TO anon;
GRANT ALL ON TABLE storage.buckets TO postgres WITH GRANT OPTION;


--
-- Name: TABLE buckets_analytics; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.buckets_analytics TO service_role;
GRANT ALL ON TABLE storage.buckets_analytics TO authenticated;
GRANT ALL ON TABLE storage.buckets_analytics TO anon;


--
-- Name: TABLE buckets_vectors; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT SELECT ON TABLE storage.buckets_vectors TO service_role;
GRANT SELECT ON TABLE storage.buckets_vectors TO authenticated;
GRANT SELECT ON TABLE storage.buckets_vectors TO anon;


--
-- Name: TABLE objects; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

REVOKE ALL ON TABLE storage.objects FROM supabase_storage_admin;
GRANT ALL ON TABLE storage.objects TO supabase_storage_admin WITH GRANT OPTION;
GRANT ALL ON TABLE storage.objects TO service_role;
GRANT ALL ON TABLE storage.objects TO authenticated;
GRANT ALL ON TABLE storage.objects TO anon;
GRANT ALL ON TABLE storage.objects TO postgres WITH GRANT OPTION;


--
-- Name: TABLE s3_multipart_uploads; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.s3_multipart_uploads TO service_role;
GRANT SELECT ON TABLE storage.s3_multipart_uploads TO authenticated;
GRANT SELECT ON TABLE storage.s3_multipart_uploads TO anon;


--
-- Name: TABLE s3_multipart_uploads_parts; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.s3_multipart_uploads_parts TO service_role;
GRANT SELECT ON TABLE storage.s3_multipart_uploads_parts TO authenticated;
GRANT SELECT ON TABLE storage.s3_multipart_uploads_parts TO anon;


--
-- Name: TABLE vector_indexes; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT SELECT ON TABLE storage.vector_indexes TO service_role;
GRANT SELECT ON TABLE storage.vector_indexes TO authenticated;
GRANT SELECT ON TABLE storage.vector_indexes TO anon;


--
-- Name: TABLE secrets; Type: ACL; Schema: vault; Owner: supabase_admin
--

GRANT SELECT,REFERENCES,DELETE,TRUNCATE ON TABLE vault.secrets TO postgres WITH GRANT OPTION;
GRANT SELECT,DELETE ON TABLE vault.secrets TO service_role;


--
-- Name: TABLE decrypted_secrets; Type: ACL; Schema: vault; Owner: supabase_admin
--

GRANT SELECT,REFERENCES,DELETE,TRUNCATE ON TABLE vault.decrypted_secrets TO postgres WITH GRANT OPTION;
GRANT SELECT,DELETE ON TABLE vault.decrypted_secrets TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: auth; Owner: supabase_auth_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON SEQUENCES TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: auth; Owner: supabase_auth_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON FUNCTIONS TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: auth; Owner: supabase_auth_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON TABLES TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: extensions; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA extensions GRANT ALL ON SEQUENCES TO postgres WITH GRANT OPTION;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: extensions; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA extensions GRANT ALL ON FUNCTIONS TO postgres WITH GRANT OPTION;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: extensions; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA extensions GRANT ALL ON TABLES TO postgres WITH GRANT OPTION;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: graphql; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: graphql; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: graphql; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: graphql_public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: graphql_public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: graphql_public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: realtime; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON SEQUENCES TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: realtime; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON FUNCTIONS TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: realtime; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON TABLES TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: storage; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: storage; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: storage; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES TO service_role;


--
-- Name: issue_graphql_placeholder; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER issue_graphql_placeholder ON sql_drop
         WHEN TAG IN ('DROP EXTENSION')
   EXECUTE FUNCTION extensions.set_graphql_placeholder();


ALTER EVENT TRIGGER issue_graphql_placeholder OWNER TO supabase_admin;

--
-- Name: issue_pg_cron_access; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER issue_pg_cron_access ON ddl_command_end
         WHEN TAG IN ('CREATE EXTENSION')
   EXECUTE FUNCTION extensions.grant_pg_cron_access();


ALTER EVENT TRIGGER issue_pg_cron_access OWNER TO supabase_admin;

--
-- Name: issue_pg_graphql_access; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER issue_pg_graphql_access ON ddl_command_end
         WHEN TAG IN ('CREATE FUNCTION')
   EXECUTE FUNCTION extensions.grant_pg_graphql_access();


ALTER EVENT TRIGGER issue_pg_graphql_access OWNER TO supabase_admin;

--
-- Name: issue_pg_net_access; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER issue_pg_net_access ON ddl_command_end
         WHEN TAG IN ('CREATE EXTENSION')
   EXECUTE FUNCTION extensions.grant_pg_net_access();


ALTER EVENT TRIGGER issue_pg_net_access OWNER TO supabase_admin;

--
-- Name: pgrst_ddl_watch; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER pgrst_ddl_watch ON ddl_command_end
   EXECUTE FUNCTION extensions.pgrst_ddl_watch();


ALTER EVENT TRIGGER pgrst_ddl_watch OWNER TO supabase_admin;

--
-- Name: pgrst_drop_watch; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER pgrst_drop_watch ON sql_drop
   EXECUTE FUNCTION extensions.pgrst_drop_watch();


ALTER EVENT TRIGGER pgrst_drop_watch OWNER TO supabase_admin;

--
-- PostgreSQL database dump complete
--

\unrestrict i0bFTnZNCYkMxHmeYMeD0ADAZugiTUWelCJCcaL1BrBubquJfZ9dknrvoBAR9kA

