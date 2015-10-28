--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: pg_stat_statements; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_stat_statements WITH SCHEMA public;


--
-- Name: EXTENSION pg_stat_statements; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pg_stat_statements IS 'track execution statistics of all SQL statements executed';


--
-- Name: postgis; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS postgis WITH SCHEMA public;


--
-- Name: EXTENSION postgis; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION postgis IS 'PostGIS geometry, geography, and raster spatial types and functions';


--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: events; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE events (
    id integer NOT NULL,
    title text,
    description text,
    geom geometry,
    updated_at timestamp without time zone,
    created_at timestamp without time zone,
    publisher_id integer,
    feature_id text,
    properties json DEFAULT '{}'::json
);


--
-- Name: events_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE events_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE events_id_seq OWNED BY events.id;


--
-- Name: http_requests; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE http_requests (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    scheme character varying(255),
    userinfo text,
    host text,
    port integer,
    path text,
    query text,
    fragment text,
    method character varying(255),
    response_status integer,
    duration integer,
    started_at timestamp without time zone
);


--
-- Name: publishers; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE publishers (
    id integer NOT NULL,
    title text,
    endpoint text,
    updated_at timestamp without time zone,
    created_at timestamp without time zone,
    active boolean,
    city text,
    icon text,
    visible boolean DEFAULT true,
    state text,
    description text,
    tags text[] DEFAULT '{}'::text[] NOT NULL,
    event_display_endpoint text,
    events_are_polygons boolean
);


--
-- Name: publishers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE publishers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: publishers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE publishers_id_seq OWNED BY publishers.id;


--
-- Name: schema_info; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_info (
    version integer DEFAULT 0 NOT NULL
);


--
-- Name: subscriptions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE subscriptions (
    geom geometry,
    updated_at timestamp without time zone,
    created_at timestamp without time zone,
    publisher_id integer,
    channel text NOT NULL,
    phone_number text,
    email_address text,
    webhook_url text,
    unsubscribed_at timestamp without time zone,
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    last_notified timestamp without time zone
);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY events ALTER COLUMN id SET DEFAULT nextval('events_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY publishers ALTER COLUMN id SET DEFAULT nextval('publishers_id_seq'::regclass);


--
-- Name: events_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY events
    ADD CONSTRAINT events_pkey PRIMARY KEY (id);


--
-- Name: http_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY http_requests
    ADD CONSTRAINT http_requests_pkey PRIMARY KEY (id);


--
-- Name: publishers_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY publishers
    ADD CONSTRAINT publishers_pkey PRIMARY KEY (id);


--
-- Name: subscriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY subscriptions
    ADD CONSTRAINT subscriptions_pkey PRIMARY KEY (id);


--
-- Name: events_geom_gist; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX events_geom_gist ON events USING gist (geom);


--
-- Name: events_publisher_id_feature_id_index; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX events_publisher_id_feature_id_index ON events USING btree (publisher_id, feature_id);


--
-- Name: publishers_endpoint_index; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX publishers_endpoint_index ON publishers USING btree (endpoint);


--
-- Name: subscriptions_geom_gist; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX subscriptions_geom_gist ON subscriptions USING gist (geom);


--
-- Name: events_publisher_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY events
    ADD CONSTRAINT events_publisher_id_fkey FOREIGN KEY (publisher_id) REFERENCES publishers(id);


--
-- Name: subscriptions_publisher_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY subscriptions
    ADD CONSTRAINT subscriptions_publisher_id_fkey FOREIGN KEY (publisher_id) REFERENCES publishers(id);


--
-- PostgreSQL database dump complete
--

