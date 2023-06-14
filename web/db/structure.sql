--
-- PostgreSQL database dump
--

-- Dumped from database version 15.3
-- Dumped by pg_dump version 15.3

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: device_tokens; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.device_tokens (
    id integer NOT NULL,
    token text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: device_tokens_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.device_tokens ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.device_tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: distributed_options; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.distributed_options (
    device_token_id integer NOT NULL,
    experiment_id integer NOT NULL,
    value character varying(100) NOT NULL
);


--
-- Name: experiments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.experiments (
    id integer NOT NULL,
    title text NOT NULL,
    key character varying(50) NOT NULL,
    options json NOT NULL,
    probability_line json NOT NULL,
    distribution_type integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: experiments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.experiments ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.experiments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    filename text NOT NULL
);


--
-- Name: device_tokens device_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.device_tokens
    ADD CONSTRAINT device_tokens_pkey PRIMARY KEY (id);


--
-- Name: device_tokens device_tokens_token_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.device_tokens
    ADD CONSTRAINT device_tokens_token_key UNIQUE (token);


--
-- Name: experiments experiments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.experiments
    ADD CONSTRAINT experiments_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (filename);


--
-- Name: experiments_created_at_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX experiments_created_at_index ON public.experiments USING btree (created_at);


--
-- Name: experiments_distribution_type_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX experiments_distribution_type_index ON public.experiments USING btree (distribution_type);


--
-- Name: distributed_options distributed_options_device_token_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.distributed_options
    ADD CONSTRAINT distributed_options_device_token_id_fkey FOREIGN KEY (device_token_id) REFERENCES public.device_tokens(id) ON DELETE CASCADE;


--
-- Name: distributed_options distributed_options_experiment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.distributed_options
    ADD CONSTRAINT distributed_options_experiment_id_fkey FOREIGN KEY (experiment_id) REFERENCES public.experiments(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;
INSERT INTO "schema_migrations" ("filename") VALUES ('20230530154118_create_experiments.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20230530154609_create_device_tokens.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20230530184245_create_distributed_options.rb');