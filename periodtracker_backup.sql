--
-- PostgreSQL database dump
--

-- Dumped from database version 10.23
-- Dumped by pg_dump version 10.23

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

--
-- Name: periodtracker; Type: SCHEMA; Schema: -; Owner: periodtracker
--

CREATE SCHEMA periodtracker;


ALTER SCHEMA periodtracker OWNER TO periodtracker;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: about_id_seq; Type: SEQUENCE; Schema: periodtracker; Owner: periodtracker
--

CREATE SEQUENCE periodtracker.about_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 2147483646
    CACHE 1;


ALTER TABLE periodtracker.about_id_seq OWNER TO periodtracker;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: about; Type: TABLE; Schema: periodtracker; Owner: periodtracker
--

CREATE TABLE periodtracker.about (
    id integer DEFAULT nextval('periodtracker.about_id_seq'::regclass) NOT NULL,
    json_dump character varying NOT NULL,
    "timestamp" timestamp without time zone NOT NULL,
    lang character varying NOT NULL
);


ALTER TABLE periodtracker.about OWNER TO periodtracker;

--
-- Name: about_banner_id_seq; Type: SEQUENCE; Schema: periodtracker; Owner: periodtracker
--

CREATE SEQUENCE periodtracker.about_banner_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 2147483646
    CACHE 1;


ALTER TABLE periodtracker.about_banner_id_seq OWNER TO periodtracker;

--
-- Name: about_banner; Type: TABLE; Schema: periodtracker; Owner: periodtracker
--

CREATE TABLE periodtracker.about_banner (
    id integer DEFAULT nextval('periodtracker.about_banner_id_seq'::regclass) NOT NULL,
    image character varying NOT NULL,
    "timestamp" timestamp without time zone NOT NULL,
    lang character varying NOT NULL
);


ALTER TABLE periodtracker.about_banner OWNER TO periodtracker;

--
-- Name: analytics_id_seq; Type: SEQUENCE; Schema: periodtracker; Owner: periodtracker
--

CREATE SEQUENCE periodtracker.analytics_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE periodtracker.analytics_id_seq OWNER TO periodtracker;

--
-- Name: analytics; Type: TABLE; Schema: periodtracker; Owner: periodtracker
--

CREATE TABLE periodtracker.analytics (
    id integer DEFAULT nextval('periodtracker.analytics_id_seq'::regclass) NOT NULL,
    type character varying NOT NULL,
    payload json NOT NULL,
    metadata json NOT NULL,
    date_created timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE periodtracker.analytics OWNER TO periodtracker;

--
-- Name: app_event_id_seq; Type: SEQUENCE; Schema: periodtracker; Owner: periodtracker
--

CREATE SEQUENCE periodtracker.app_event_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE periodtracker.app_event_id_seq OWNER TO periodtracker;

--
-- Name: app_event; Type: TABLE; Schema: periodtracker; Owner: periodtracker
--

CREATE TABLE periodtracker.app_event (
    id integer DEFAULT nextval('periodtracker.app_event_id_seq'::regclass) NOT NULL,
    local_id uuid NOT NULL,
    type character varying NOT NULL,
    payload json NOT NULL,
    metadata json NOT NULL,
    user_id character varying,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE periodtracker.app_event OWNER TO periodtracker;

--
-- Name: answered_quizzes; Type: VIEW; Schema: periodtracker; Owner: periodtracker
--

CREATE VIEW periodtracker.answered_quizzes AS
 SELECT (app_event.payload ->> 'id'::text) AS id,
    (app_event.payload ->> 'question'::text) AS question,
    (app_event.payload ->> 'isCorrect'::text) AS iscorrect,
    (app_event.payload ->> 'answerID'::text) AS answerid,
    (app_event.payload ->> 'answer'::text) AS answer,
    (app_event.payload ->> 'utcDateTime'::text) AS date
   FROM periodtracker.app_event
  WHERE ((app_event.type)::text = 'ANSWER_QUIZ'::text);


ALTER TABLE periodtracker.answered_quizzes OWNER TO periodtracker;

--
-- Name: answered_surveys; Type: VIEW; Schema: periodtracker; Owner: periodtracker
--

CREATE VIEW periodtracker.answered_surveys AS
 SELECT (app_event.payload ->> 'id'::text) AS id,
    (app_event.payload ->> 'questions'::text) AS question,
    (app_event.payload ->> 'answerID'::text) AS answerid,
    (app_event.payload ->> 'answer'::text) AS answer,
    (app_event.payload ->> 'utcDateTime'::text) AS date,
    (app_event.payload ->> 'isCompleted'::text) AS iscompleted,
    (app_event.payload ->> 'isSurveyAnswered'::text) AS issurveyanswered,
    (app_event.payload ->> 'user_id'::text) AS user_id,
    (app_event.payload ->> 'questions'::text) AS questions
   FROM periodtracker.app_event
  WHERE ((app_event.type)::text = 'ANSWER_SURVEY'::text);


ALTER TABLE periodtracker.answered_surveys OWNER TO periodtracker;

--
-- Name: article_sorting_key; Type: SEQUENCE; Schema: periodtracker; Owner: periodtracker
--

CREATE SEQUENCE periodtracker.article_sorting_key
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 9223372036854775806
    CACHE 1;


ALTER TABLE periodtracker.article_sorting_key OWNER TO periodtracker;

--
-- Name: article; Type: TABLE; Schema: periodtracker; Owner: periodtracker
--

CREATE TABLE periodtracker.article (
    id uuid NOT NULL,
    category character varying NOT NULL,
    subcategory character varying NOT NULL,
    article_heading character varying NOT NULL,
    article_text character varying NOT NULL,
    date_created timestamp without time zone DEFAULT now() NOT NULL,
    live boolean NOT NULL,
    lang character varying NOT NULL,
    "sortingKey" integer DEFAULT nextval('periodtracker.article_sorting_key'::regclass) NOT NULL,
    "voiceOverKey" text,
    "isAgeRestricted" boolean,
    "ageRestrictionLevel" integer,
    "contentFilter" integer
);


ALTER TABLE periodtracker.article OWNER TO periodtracker;

--
-- Name: avatar_messages; Type: TABLE; Schema: periodtracker; Owner: periodtracker
--

CREATE TABLE periodtracker.avatar_messages (
    id uuid NOT NULL,
    content character varying NOT NULL,
    live boolean NOT NULL,
    lang character varying NOT NULL
);


ALTER TABLE periodtracker.avatar_messages OWNER TO periodtracker;

--
-- Name: category_sorting_key; Type: SEQUENCE; Schema: periodtracker; Owner: periodtracker
--

CREATE SEQUENCE periodtracker.category_sorting_key
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 9223372036854775806
    CACHE 1;


ALTER TABLE periodtracker.category_sorting_key OWNER TO periodtracker;

--
-- Name: category; Type: TABLE; Schema: periodtracker; Owner: periodtracker
--

CREATE TABLE periodtracker.category (
    id uuid NOT NULL,
    title character varying NOT NULL,
    primary_emoji character varying NOT NULL,
    primary_emoji_name character varying NOT NULL,
    lang character varying NOT NULL,
    "sortingKey" integer DEFAULT nextval('periodtracker.category_sorting_key'::regclass) NOT NULL
);


ALTER TABLE periodtracker.category OWNER TO periodtracker;

--
-- Name: did_you_know; Type: TABLE; Schema: periodtracker; Owner: periodtracker
--

CREATE TABLE periodtracker.did_you_know (
    id uuid NOT NULL,
    title character varying NOT NULL,
    content character varying NOT NULL,
    "isAgeRestricted" boolean DEFAULT false,
    live boolean NOT NULL,
    lang character varying NOT NULL,
    "ageRestrictionLevel" integer,
    "contentFilter" integer
);


ALTER TABLE periodtracker.did_you_know OWNER TO periodtracker;

--
-- Name: help_center_id_seq; Type: SEQUENCE; Schema: periodtracker; Owner: periodtracker
--

CREATE SEQUENCE periodtracker.help_center_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 9223372036854775806
    CACHE 1;


ALTER TABLE periodtracker.help_center_id_seq OWNER TO periodtracker;

--
-- Name: help_center_sorting_key; Type: SEQUENCE; Schema: periodtracker; Owner: periodtracker
--

CREATE SEQUENCE periodtracker.help_center_sorting_key
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 9223372036854775806
    CACHE 1;


ALTER TABLE periodtracker.help_center_sorting_key OWNER TO periodtracker;

--
-- Name: help_center; Type: TABLE; Schema: periodtracker; Owner: periodtracker
--

CREATE TABLE periodtracker.help_center (
    id integer DEFAULT nextval('periodtracker.help_center_id_seq'::regclass) NOT NULL,
    title character varying NOT NULL,
    caption character varying NOT NULL,
    "contactOne" character varying NOT NULL,
    "contactTwo" character varying NOT NULL,
    address character varying NOT NULL,
    website character varying NOT NULL,
    lang character varying NOT NULL,
    region text,
    "subRegion" text,
    "isAvailableNationwide" boolean DEFAULT true,
    "primaryAttributeId" integer,
    "otherAttributes" text,
    "isActive" boolean DEFAULT false,
    "sortingKey" integer DEFAULT nextval('periodtracker.help_center_sorting_key'::regclass) NOT NULL
);


ALTER TABLE periodtracker.help_center OWNER TO periodtracker;

--
-- Name: help_center_attribute_id_seq; Type: SEQUENCE; Schema: periodtracker; Owner: periodtracker
--

CREATE SEQUENCE periodtracker.help_center_attribute_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 9223372036854775806
    CACHE 1;


ALTER TABLE periodtracker.help_center_attribute_id_seq OWNER TO periodtracker;

--
-- Name: help_center_attribute; Type: TABLE; Schema: periodtracker; Owner: periodtracker
--

CREATE TABLE periodtracker.help_center_attribute (
    id integer DEFAULT nextval('periodtracker.help_center_attribute_id_seq'::regclass) NOT NULL,
    name character varying NOT NULL,
    emoji character varying NOT NULL,
    "isActive" boolean DEFAULT true,
    lang character varying NOT NULL
);


ALTER TABLE periodtracker.help_center_attribute OWNER TO periodtracker;

--
-- Name: notification_id_seq; Type: SEQUENCE; Schema: periodtracker; Owner: periodtracker
--

CREATE SEQUENCE periodtracker.notification_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE periodtracker.notification_id_seq OWNER TO periodtracker;

--
-- Name: notification; Type: TABLE; Schema: periodtracker; Owner: periodtracker
--

CREATE TABLE periodtracker.notification (
    id integer DEFAULT nextval('periodtracker.notification_id_seq'::regclass) NOT NULL,
    title character varying NOT NULL,
    content character varying NOT NULL,
    date_sent character varying NOT NULL,
    status character varying NOT NULL,
    lang character varying NOT NULL
);


ALTER TABLE periodtracker.notification OWNER TO periodtracker;

--
-- Name: oky_user; Type: TABLE; Schema: periodtracker; Owner: periodtracker
--

CREATE TABLE periodtracker.oky_user (
    id uuid NOT NULL,
    date_of_birth timestamp without time zone NOT NULL,
    gender character varying NOT NULL,
    location character varying NOT NULL,
    country character varying DEFAULT '00'::character varying,
    province character varying DEFAULT '0'::character varying,
    store json,
    "nameHash" character varying NOT NULL,
    "passwordHash" character varying NOT NULL,
    "memorableQuestion" character varying NOT NULL,
    "memorableAnswer" character varying NOT NULL,
    date_signed_up timestamp without time zone,
    date_account_saved timestamp without time zone DEFAULT now(),
    metadata json DEFAULT '{}'::json
);


ALTER TABLE periodtracker.oky_user OWNER TO periodtracker;

--
-- Name: permanent_notification_id_seq; Type: SEQUENCE; Schema: periodtracker; Owner: periodtracker
--

CREATE SEQUENCE periodtracker.permanent_notification_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 2147483647
    CACHE 1;


ALTER TABLE periodtracker.permanent_notification_id_seq OWNER TO periodtracker;

--
-- Name: permanent_notification; Type: TABLE; Schema: periodtracker; Owner: periodtracker
--

CREATE TABLE periodtracker.permanent_notification (
    id integer DEFAULT nextval('periodtracker.permanent_notification_id_seq'::regclass) NOT NULL,
    message character varying NOT NULL,
    "isPermanent" boolean NOT NULL,
    live boolean NOT NULL,
    lang character varying NOT NULL,
    versions character varying NOT NULL
);


ALTER TABLE periodtracker.permanent_notification OWNER TO periodtracker;

--
-- Name: privacy_policy_id_seq; Type: SEQUENCE; Schema: periodtracker; Owner: periodtracker
--

CREATE SEQUENCE periodtracker.privacy_policy_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 2147483646
    CACHE 1;


ALTER TABLE periodtracker.privacy_policy_id_seq OWNER TO periodtracker;

--
-- Name: privacy_policy; Type: TABLE; Schema: periodtracker; Owner: periodtracker
--

CREATE TABLE periodtracker.privacy_policy (
    id integer DEFAULT nextval('periodtracker.privacy_policy_id_seq'::regclass) NOT NULL,
    json_dump character varying NOT NULL,
    "timestamp" timestamp without time zone NOT NULL,
    lang character varying NOT NULL
);


ALTER TABLE periodtracker.privacy_policy OWNER TO periodtracker;

--
-- Name: question; Type: TABLE; Schema: periodtracker; Owner: periodtracker
--

CREATE TABLE periodtracker.question (
    id uuid NOT NULL,
    question character varying NOT NULL,
    option1 character varying NOT NULL,
    option2 character varying NOT NULL,
    option3 character varying NOT NULL,
    option4 character varying NOT NULL,
    option5 character varying NOT NULL,
    response character varying NOT NULL,
    is_multiple boolean DEFAULT true,
    next_question json NOT NULL,
    sort_number character varying NOT NULL,
    "surveyId" uuid NOT NULL
);


ALTER TABLE periodtracker.question OWNER TO periodtracker;

--
-- Name: quiz; Type: TABLE; Schema: periodtracker; Owner: periodtracker
--

CREATE TABLE periodtracker.quiz (
    id uuid NOT NULL,
    topic character varying NOT NULL,
    question character varying NOT NULL,
    option1 character varying NOT NULL,
    option2 character varying NOT NULL,
    option3 character varying NOT NULL,
    right_answer character varying NOT NULL,
    wrong_answer_response character varying NOT NULL,
    right_answer_response character varying NOT NULL,
    "isAgeRestricted" boolean DEFAULT false,
    live boolean NOT NULL,
    date_created timestamp without time zone DEFAULT now() NOT NULL,
    lang character varying NOT NULL,
    "ageRestrictionLevel" integer,
    "contentFilter" integer
);


ALTER TABLE periodtracker.quiz OWNER TO periodtracker;

--
-- Name: subcategory_sorting_key; Type: SEQUENCE; Schema: periodtracker; Owner: periodtracker
--

CREATE SEQUENCE periodtracker.subcategory_sorting_key
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 9223372036854775806
    CACHE 1;


ALTER TABLE periodtracker.subcategory_sorting_key OWNER TO periodtracker;

--
-- Name: subcategory; Type: TABLE; Schema: periodtracker; Owner: periodtracker
--

CREATE TABLE periodtracker.subcategory (
    id uuid NOT NULL,
    title character varying NOT NULL,
    parent_category character varying NOT NULL,
    lang character varying NOT NULL,
    "sortingKey" integer DEFAULT nextval('periodtracker.subcategory_sorting_key'::regclass) NOT NULL
);


ALTER TABLE periodtracker.subcategory OWNER TO periodtracker;

--
-- Name: suggestion; Type: TABLE; Schema: periodtracker; Owner: periodtracker
--

CREATE TABLE periodtracker.suggestion (
    id uuid NOT NULL,
    name character varying NOT NULL,
    "dateRec" character varying NOT NULL,
    organization character varying NOT NULL,
    platform character varying NOT NULL,
    reason character varying NOT NULL,
    email character varying NOT NULL,
    status character varying NOT NULL,
    content character varying NOT NULL,
    lang character varying NOT NULL
);


ALTER TABLE periodtracker.suggestion OWNER TO periodtracker;

--
-- Name: survey; Type: TABLE; Schema: periodtracker; Owner: periodtracker
--

CREATE TABLE periodtracker.survey (
    id uuid NOT NULL,
    question character varying NOT NULL,
    option1 character varying NOT NULL,
    option2 character varying NOT NULL,
    option3 character varying NOT NULL,
    option4 character varying NOT NULL,
    option5 character varying NOT NULL,
    response character varying NOT NULL,
    live boolean NOT NULL,
    date_created timestamp without time zone DEFAULT now() NOT NULL,
    lang character varying NOT NULL,
    "isAgeRestricted" boolean DEFAULT false,
    is_multiple boolean DEFAULT true,
    "ageRestrictionLevel" integer,
    "contentFilter" integer
);


ALTER TABLE periodtracker.survey OWNER TO periodtracker;

--
-- Name: terms_and_conditions_id_seq; Type: SEQUENCE; Schema: periodtracker; Owner: periodtracker
--

CREATE SEQUENCE periodtracker.terms_and_conditions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 2147483646
    CACHE 1;


ALTER TABLE periodtracker.terms_and_conditions_id_seq OWNER TO periodtracker;

--
-- Name: terms_and_conditions; Type: TABLE; Schema: periodtracker; Owner: periodtracker
--

CREATE TABLE periodtracker.terms_and_conditions (
    id integer DEFAULT nextval('periodtracker.terms_and_conditions_id_seq'::regclass) NOT NULL,
    json_dump character varying NOT NULL,
    "timestamp" timestamp without time zone NOT NULL,
    lang character varying NOT NULL
);


ALTER TABLE periodtracker.terms_and_conditions OWNER TO periodtracker;

--
-- Name: user_id_seq; Type: SEQUENCE; Schema: periodtracker; Owner: periodtracker
--

CREATE SEQUENCE periodtracker.user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE periodtracker.user_id_seq OWNER TO periodtracker;

--
-- Name: user; Type: TABLE; Schema: periodtracker; Owner: periodtracker
--

CREATE TABLE periodtracker."user" (
    id integer DEFAULT nextval('periodtracker.user_id_seq'::regclass) NOT NULL,
    username character varying NOT NULL,
    password character varying NOT NULL,
    lang character varying NOT NULL,
    date_created character varying DEFAULT 'now()'::character varying NOT NULL,
    type character varying NOT NULL
);


ALTER TABLE periodtracker."user" OWNER TO periodtracker;

--
-- Name: video_sorting_key; Type: SEQUENCE; Schema: periodtracker; Owner: periodtracker
--

CREATE SEQUENCE periodtracker.video_sorting_key
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 9223372036854775806
    CACHE 1;


ALTER TABLE periodtracker.video_sorting_key OWNER TO periodtracker;

--
-- Name: video; Type: TABLE; Schema: periodtracker; Owner: periodtracker
--

CREATE TABLE periodtracker.video (
    id uuid NOT NULL,
    title character varying NOT NULL,
    "youtubeId" character varying,
    "assetName" character varying,
    live boolean NOT NULL,
    date_created timestamp without time zone DEFAULT now() NOT NULL,
    lang character varying NOT NULL,
    "sortingKey" integer DEFAULT nextval('periodtracker.video_sorting_key'::regclass) NOT NULL
);


ALTER TABLE periodtracker.video OWNER TO periodtracker;

--
-- Data for Name: about; Type: TABLE DATA; Schema: periodtracker; Owner: periodtracker
--

COPY periodtracker.about (id, json_dump, "timestamp", lang) FROM stdin;
1	[{"type":"CONTENT","content":"Oky is a mobile phone app that helps girls to take control of their periods and their lives. Feel more confident by tracking your period, and getting the facts that all girls should know."},{"type":"HEADING","content":"What is Oky?"},{"type":"CONTENT","content":"Oky is a period tracking app designed for girls and by girls: it’s fun and positive because we want to reverse the shyness and bad feelings that periods can sometimes cause!\\n"},{"type":"HEADING","content":"Why did UNICEF create Oky?"},{"type":"CONTENT","content":"UNICEF created Oky as part of its mission to promote girl’s education and health, by changing one of the world’s biggest taboos: menstruation."},{"type":"CONTENT","content":"UNICEF created Oky as part of its mission to promote girl’s education and health, by changing one of the world’s biggest taboos: menstruation."},{"type":"CONTENT","content":"It can be difficult to find trustworthy, quality information online that is relevant. There is so much misinformation out there. All this can make periods stressful, when they don’t need to be. Oky is designed to help girls manage their periods with confidence, because girls should be able to make informed decisions about their bodies and their lives."},{"type":"HEADING","content":"How did UNICEF create Oky?"}]	2025-07-29 14:59:43.827	en
2	[{"type":"CONTENT","content":"Oky is a mobile phone app that helps girls to take control of their periods and their lives. Feel more confident by tracking your period, and getting the facts that all girls should know."},{"type":"HEADING","content":"What is Oky?"},{"type":"CONTENT","content":"Oky is a period tracking app designed for girls and by girls: it’s fun and positive because we want to reverse the shyness and bad feelings that periods can sometimes cause!\\n"},{"type":"HEADING","content":"Why did UNICEF create Oky?"},{"type":"CONTENT","content":"UNICEF created Oky as part of its mission to promote girl’s education and health, by changing one of the world’s biggest taboos: menstruation."},{"type":"CONTENT","content":"UNICEF created Oky as part of its mission to promote girl’s education and health, by changing one of the world’s biggest taboos: menstruation."},{"type":"CONTENT","content":"It can be difficult to find trustworthy, quality information online that is relevant. There is so much misinformation out there. All this can make periods stressful, when they don’t need to be. Oky is designed to help girls manage their periods with confidence, because girls should be able to make informed decisions about their bodies and their lives."},{"type":"HEADING","content":"How did UNICEF create Oky?"}]	2025-07-29 15:00:00.713	en
3	[{"type":"CONTENT","content":"Oky is a mobile phone app that helps girls to take control of their periods and their lives. Feel more confident by tracking your period, and getting the facts that all girls should know."},{"type":"HEADING","content":"What is Oky?"},{"type":"CONTENT","content":"Oky is a period tracking app designed for girls and by girls: it’s fun and positive because we want to reverse the shyness and bad feelings that periods can sometimes cause!\\n"},{"type":"HEADING","content":"Why did UNICEF create Oky?"},{"type":"CONTENT","content":"UNICEF created Oky as part of its mission to promote girl’s education and health, by changing one of the world’s biggest taboos: menstruation."},{"type":"CONTENT","content":"UNICEF created Oky as part of its mission to promote girl’s education and health, by changing one of the world’s biggest taboos: menstruation."},{"type":"CONTENT","content":"It can be difficult to find trustworthy, quality information online that is relevant. There is so much misinformation out there. All this can make periods stressful, when they don’t need to be. Oky is designed to help girls manage their periods with confidence, because girls should be able to make informed decisions about their bodies and their lives."},{"type":"HEADING","content":"How did UNICEF create Oky?"},{"type":"CONTENT","content":"We spent months talking to more than 400 girls in Mongolia and Indonesia about their periods, their fears, their hopes and their lives, and worked together to co-create Oky! Of course, we also worked with our education and medical experts to ensure that Oky reflect UNICEF’s ethics and its high health standards and guidelines. "},{"type":"HEADING","content":"How does Oky work?"},{"type":"CONTENT","content":"Oky allows you to add information about your period, body, activities and mood, and based on this, provides predictions about you next period and ovulation cycle. There is a calendar, which acts as a diary and helps with reminders. Oky gives tips and motivation through games & quizzes too!"},{"type":"HEADING","content":"How is Oky different?"},{"type":"CONTENT","content":"Oky is different from other period tracking apps because it is aimed particularly at girls. Oky is not a business, it is a service for girls that aims to be inclusive and non-judgemental, and maintains the highest privacy and data protection standards."},{"type":"CONTENT","content":"Oky is developed in an open way so others can learn from the process of creating a digital public health resource. This way, it can be useful to more people and contribute to changing the way our digital information is used for profit rather than for public good."}]	2025-07-29 15:45:42.366	en
\.


--
-- Data for Name: about_banner; Type: TABLE DATA; Schema: periodtracker; Owner: periodtracker
--

COPY periodtracker.about_banner (id, image, "timestamp", lang) FROM stdin;
1	data:image/jpeg;base64,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	2025-07-29 14:53:31.041	en
\.


--
-- Data for Name: analytics; Type: TABLE DATA; Schema: periodtracker; Owner: periodtracker
--

COPY periodtracker.analytics (id, type, payload, metadata, date_created) FROM stdin;
\.


--
-- Data for Name: app_event; Type: TABLE DATA; Schema: periodtracker; Owner: periodtracker
--

COPY periodtracker.app_event (id, local_id, type, payload, metadata, user_id, created_at) FROM stdin;
1	39d3dfa0-7c91-4100-9f52-4602fa25529a	SET_THEME	{"theme":"village"}	{"date":"2025-07-25T08:32:06.441Z","user":"8907de2d-efbd-4bff-9256-97a31da9194c","deviceId":"539e5d0f-3c2d-417d-8c8b-ccca60ca4103"}	8907de2d-efbd-4bff-9256-97a31da9194c	2025-07-25 08:33:01.821604
2	50c77c70-dcc9-44ce-952b-ef8b8817eae0	SET_THEME	{"theme":"desert"}	{"date":"2025-07-25T10:20:06.185Z","user":"d52bd883-ab62-4afb-8e33-8887410efa75","deviceId":"86152b5d-8fd2-4651-a95b-7d85403cc2d1"}	d52bd883-ab62-4afb-8e33-8887410efa75	2025-07-25 10:20:12.523636
\.


--
-- Data for Name: article; Type: TABLE DATA; Schema: periodtracker; Owner: periodtracker
--

COPY periodtracker.article (id, category, subcategory, article_heading, article_text, date_created, live, lang, "sortingKey", "voiceOverKey", "isAgeRestricted", "ageRestrictionLevel", "contentFilter") FROM stdin;
\.


--
-- Data for Name: avatar_messages; Type: TABLE DATA; Schema: periodtracker; Owner: periodtracker
--

COPY periodtracker.avatar_messages (id, content, live, lang) FROM stdin;
ef40ae2f-79c6-4028-92af-d9e985ce9dc2	All of your period information stays private and secure with Oky.	f	en
14d2ef61-9720-41d1-9aed-130a70d937c5	Knowing yourself is loving yourself. 💜	f	en
1cc42fe8-166a-478b-9c94-f0a108798154	Well done for checking in!🌈	f	en
d1fdec09-c0c0-45ba-9ebe-f9e4d431012a	How are you?😄	f	en
390dec68-2bf3-4c33-908e-985af54eb43f	Done your Daily Diary? 📆	f	en
4df69f65-4818-4812-81c1-d5e52f4c8582	Win stars ✨ when you track!	f	en
384979d5-900d-4953-8226-a9e86f590942	Tap to make me smile!😊	f	en
33849607-292d-4279-b842-bf76058540c5	Happy to see you!🌞	f	en
af6f4b99-2acc-459b-8d1e-ec21bba0b974	You have a right to know about your body!💥	f	en
615bcda1-d268-4fe7-a099-9cac8429ee82	Always remember to take care of you!💪	f	en
7a213fb0-edb7-42b3-b2ef-89206b040fbf	Your period doesn't have to be a mystery! 😊	f	en
c15af3e4-9766-4740-b7e3-69ff2e61429f	Thanks for being my friend.😊	f	en
3b404288-d945-4741-99fc-4b5135e77fba	With Oky, your privacy always comes first.	f	en
c727912b-b31d-4d15-86b0-aa64800c2e62	Tomorrow is a chance for a fresh start. 👊	f	en
5fe63273-3dd2-4394-90d1-52618550b361	Oky's data protection systems keep your data private!	f	en
ed1ca8cd-a7b9-4a17-9cb6-37a933e79d08	Know YOUR period to feel great! 💫	f	en
beedd695-73f7-4627-b314-d70dfd8f7a7b	Your body, your future, your life.🌈	f	en
5c3bdc2d-59e9-40b7-8631-da44162f36d2	Girls support each other! 🙏	f	en
99a5a0cd-889e-431a-b2d2-bb01a011a70d	Look after your body and your mind.🌻	f	en
37f89126-a8c1-49a3-9cb5-9d4ccf01b402	Sisters are there for each other. 👑	f	en
8735586f-4cd8-44f8-b380-90770403e169	You are great!🌟	f	en
f50734c1-69e3-4dc6-b795-757dcbc96832	Living = Learning. What did you learn today?🤓	f	en
ecb2c314-5734-4174-a176-1fb7e5605e04	Healthy and feeling great — that's the goal! 🎯	f	en
6c2a1488-690f-4cb7-ae43-7d2d3fced809	The more you know, the wiser your decisions in life.👩‍🎓	f	en
c0ce8d2d-e643-4106-9b9d-6e5b23b98f3d	To be beautiful means to be yourself. 😌\n	f	en
1588ebf1-0ccb-4d00-a8b3-df913b7732ad	Friends look out for each other!🙌\n	f	en
936c0e0d-0bbc-4729-8537-de35e534ac3e	Oky does not collect any personally identifiable information!\n	f	en
c5499a40-4528-410a-8ace-fd7e4c2d0e13	The more knowledge you have, the wiser your decisions. 🎓\n	f	en
1fd5a85e-e664-409e-b058-e8de243f4539	What did you learn about yourself today? 💕	f	en
95506697-3809-4900-a17f-c231e0df8049	Learn to listen to your body.👂	f	en
76a1161d-ddab-4151-859f-781a6752772a	Your Oky account is private and secure.	f	en
4bf157aa-1ca3-49f9-9677-d9d0c4c85408	Oky values your privacy. None of your info will ever be shared.	f	en
a5a81b1f-9634-483b-a100-0cb815b1ae2d	Show me love! ❤️	f	en
453cddcf-56fe-4fbc-940a-16692048dbd8	The secret to life? Knowing yourself!✨	f	en
ef9aaad3-72f3-420d-8566-8978b2748365	Time to do your Daily Diary! ⏰	f	en
4e8db9eb-80b4-4bad-88ff-3edb54e2efd9	Everything you share with Oky is completely safe and secure!	f	en
08945202-2800-435c-a3c1-39b8119653f5	Make Oky's predictions more accurate by filling in your Daily Diary! 📅	f	en
3a285af7-6c03-484c-b4d2-a98b40d9d152	Does it feel good to get to know yourself? 💖	f	en
e26a3d57-7ae5-4ee0-8881-fca50d83e36c	Track your mood! 📲	f	en
bcca36a5-d193-4647-8959-bc0d255bda87	What are you thankful for today?🙏	f	en
d0279244-dfb5-497e-a4e7-ad7a69d41fc1	How are you feeling? Track it! 📝	f	en
ffa30a9c-4da4-43c2-bb3e-c9eea5a0491a	You spread love to others when you love yourself first. 😍	f	en
594eee0d-78d0-481d-9667-aec4caa6f34a	You're great, don't forget it!👍	f	en
0f486999-1101-40f8-ac8a-2080d0653a3c	You are unique, and that's a good thing.🌸	f	en
d39fa3ab-6b1b-471e-8730-e6f76ef3aa87	All your Oky information is completely secure.	f	en
1d8a2eb5-7466-4ea1-a6e3-38daf1cca9b0	Oky is not a family planning method! Always use protection✋	f	en
58541111-2af6-451d-90a9-1e99df4b2374	Oky's data and privacy processes are strict. Your info will never be shared.	f	en
2ed17b33-9e6e-40d1-9619-b5b1dcace866	Your Oky info will never be shared.	f	en
e782644a-ea2a-4cfd-94db-c2ecb4397ea3	Well done for learning about your body. 😌	f	en
cdc051ec-be15-4b79-b65e-7b1ac09003cc	If you're feeling down, try getting active! 💪	f	en
f1764797-bc9e-4bd9-935f-f2d051d54320	Lifting others up will lift you up too!🙌	f	en
0a7e7e46-5573-46e9-9f69-d41aca46c284	Everything you share with Oky is safe and secure.	f	en
7f027794-69ec-493e-ae54-fc48e7078904	Tracking your periods can give you more control over your life! 😊	f	en
a1128b0f-6f56-4c74-9e6a-4be993a495a4	Oky values your privacy. Everything you share with Oky is completely safe and secure.	f	en
0ab340b2-104d-4b5b-a4cd-83d51ea5ab42	Oky takes your privacy very seriously.	f	en
8e7ebee0-3902-47d0-a84c-b516f07b0e75	Believe in yourself and you will be unstoppable! ⭐	f	en
2f967788-42d9-4ce0-bec1-ea7f2630fc87	You generate love when you love yourself.😍	f	en
d218de08-8d3e-438c-a2a3-bcd7bdd89817	Knowing your body makes you feel good! 🙌	f	en
f6e88e79-cdc0-468d-bce5-f9d50611ec3f	We support each other — that's what girls do! 👭	f	en
d00b8019-7883-40b8-9f06-cabe1ad45fc7	Hello you!😍	f	en
12c0623b-2b20-4149-a200-c860ffed31b2	Share what you learned with a friend! 👯	f	en
8f104515-4132-4294-9580-e902215ecda3	Confidence is loving yourself!💃	f	en
dc083ad2-f854-4f9e-b91d-c69acc6c7569	Embrace who you are! 👸	f	en
b5d04780-6b38-4622-9bab-fefa2a36b0f9	Knowing yourself gives you positive energy! ☀️	f	en
b0dd1184-8b0c-4968-aa9a-08841c9b762f	Are your periods irregular? ⏰ That's totally normal — and why Oky predictions aren't always correct!	f	en
900b18ba-30ce-4776-8e13-673c89c60240	Sharing knowledge with you makes me happy!🙂	f	en
16030f17-dd44-452e-9ca1-7c30dad1a252	Getting to know yourself is a journey. ⬆️	f	en
08b95388-c4ca-4eba-8927-639e86236342	Hi friend! 👋	f	en
\.


--
-- Data for Name: category; Type: TABLE DATA; Schema: periodtracker; Owner: periodtracker
--

COPY periodtracker.category (id, title, primary_emoji, primary_emoji_name, lang, "sortingKey") FROM stdin;
02bca300-9373-442d-a83e-750cc15fc4c5	Periods and life	🎌	life	en	3
c969a7ed-eef0-44f5-b2ef-6030750127b2	Menstruation and menstrual cycle	🚩	periods	en	4
75906d2a-2ddd-4cbd-98e1-680a74e2ba6e	Managing menstruation	🏁	care	en	5
fb535db0-9923-44d1-ae66-9d51d82ea4e8	Puberty	🔲	growing	en	6
0dcbc24b-d285-494a-90bd-dfac51e59271	Boys, men and relationships	🔘	boys	en	7
879ff9ec-f959-43a9-8c87-03e99e3508f7	Health, nutrition and exercise	🔻	health	en	8
2d155a96-49c4-45a6-aafa-6aaa751f626e	Myths and feelings	🔷	feelings	en	10
e066f374-ef39-4d50-9331-2d2cd7cffca7	COVID-19	😄	covid-19	en	11
afc705f3-c602-43cd-be03-b82831bd4900	Personal identity	😁	Gender	en	13
43a40940-1d38-4c6b-930e-aec7e7b01011	Violence and staying safe	😅	speak up	en	14
dd43195b-732c-4407-aed3-e340a5902814	My rights	😉	legal	en	15
17c1809a-01bc-46fe-a26c-9970e8700df7	Mental health	😇	okay	en	16
d2dafb9e-ee3a-421b-8363-8c267b67ed08	Your Rights in Nepal	😚	Hand rise	en	17
48165873-6517-4c03-a53d-4c99f01366ba	Helpline Services	😏	Helpline	en	18
fff4b357-c0b8-42b0-b414-d0b137f55722	Content Sources	😝	sources	en	19
0e28b0c3-186c-4d67-89b7-c95dfc8d3588	Family planning	👯	family	en	9
ce454a41-a733-4c38-972e-c8d0e99837e4	Using Oky	📱	mobile	en	12
\.


--
-- Data for Name: did_you_know; Type: TABLE DATA; Schema: periodtracker; Owner: periodtracker
--

COPY periodtracker.did_you_know (id, title, content, "isAgeRestricted", live, lang, "ageRestrictionLevel", "contentFilter") FROM stdin;
0c8be937-ed82-488a-b3bc-2980b2435220	Boys, men and relationships	Boys don't have periods because they don't have a uterus or produce eggs. They produce sperm instead!🚶	f	f	en	\N	\N
57051c87-2ada-46df-bec1-b5285d3c8d3a	Boys, men and relationships	There is no 'right' age for a romantic relationship, only you can decide when you are ready! 💕	f	f	en	\N	\N
edf298a2-7ab4-42bc-8ab8-0f0d7d9ee25a	Boys, men and relationships	A good friend is there for the good times and the bad times. ❤️	f	f	en	\N	\N
eacac77f-4ed0-4fb7-a751-986bd8244550	Boys, men and relationships	If a friend is upset, you don't always have to give them advice. Sometimes they just want someone to listen!👂🏼	f	f	en	\N	\N
2636cb7e-c0af-47a6-9d37-3f8b85e0d66e	Boys, men and relationships	You're allowed to speak up for yourself when you're being treated unfairly! 💪	f	f	en	\N	\N
de9af3fc-9ae7-4dfe-b627-a7d7e0331fe8	Boys, men and relationships	Healthy relationships should bring out the best in both of you. 💕	f	f	en	\N	\N
8f6a450e-6fbf-4f0f-b815-52dbf1ff659a	Boys, men and relationships	It’s not your fault or your job to fix things if your parents fight! 💛	f	f	en	\N	\N
ea59e4b6-a64d-478f-8d7c-5f965708dac4	Boys, men and relationships	Boys should care about periods because it affects the girls and women they love. 👫	f	f	en	\N	\N
45f1612b-a3e4-41f2-825b-8516a2ab32bd	Boys, men and relationships	Boys can help girls when they have their periods by asking questions and listening to their experiences.👂	f	f	en	\N	\N
05b482a2-ab8a-4de8-ac3d-fa739e95f100	Boys, men and relationships	You don't need to be with someone just because THEY like you. You need to like them too! 💙	f	f	en	\N	\N
7c21dd24-22f3-4b64-b5a6-4b471c8f9abe	Family planning	It's OK to say NO to sex — even if you've said yes before. Your partner should ask for consent every time. 💯	f	f	en	\N	\N
6d2787af-7ea8-4206-b283-4579d7d545e2	Family planning	Babies are made when a man's sperm fertilizes a woman's egg and it implants into the uterus lining. 👶	f	f	en	\N	\N
030f1d97-ebac-4554-9e30-c938ed470508	Family planning	There are 6 fertile days per cycle: 5 days before ovulation (when the egg is released), and 1 day after ovulation. 📆	f	f	en	\N	\N
94f5462d-6c99-453d-a75e-2ae95a5c2bea	Family planning	It's possible to get pregnant on your period because sperm can live for up 5 days inside your body! 📆	f	f	en	\N	\N
6ec755d6-0a68-4a28-9a55-91c43a777648	Family planning	Contraception is all the methods you can use to avoid getting pregnant. ❌	f	f	en	\N	\N
6d075b0d-2afe-4036-8fff-5ff793d10337	Family planning	The contraceptive injection is 99% effective at preventing pregnancy. 💉	f	f	en	\N	\N
e380d6a2-1f40-4688-93c1-3e4f4ebdbe1a	Family planning	Lack of education, confidence and access to contraception cause most teen pregnancies. Know your options! 👫👩🏽‍⚕️	f	f	en	\N	\N
9c683f0d-eaa8-4978-9189-74fc68555830	Family planning	Almost every country has a legal age of consent for having sex. 🚫	f	f	en	\N	\N
5861c69a-ba08-4cae-b9a0-80cafb32d039	Family planning	The copper IUD can be used for long-term AND emergency contraception, and can be 99% effective.✨	f	f	en	\N	\N
36696f50-437f-4a7a-978b-4e34e6aee079	Family planning	There are about 6 days during your menstrual cycle when you are most likely to get pregnant — these are called fertile days. 📆	f	f	en	\N	\N
88f7234f-bf57-4a12-bd06-f648198c9327	Family planning	There are no 'safe days' from STIs or HIV. Always use a condom for protection! 👈	f	f	en	\N	\N
24f8b0b2-34d2-45dd-ad71-a9574091c7a9	Family planning	There's nothing wrong with having sex on your period, as long as you both want to. Don't forget to use protection! 👊	f	f	en	\N	\N
6ca8a411-6afd-4f07-90a4-3ee1ad99e321	Family Planning	Abstinence means not having penetrative sex. This can be for contraception or for personal reasons. 🚫	f	f	en	\N	\N
c60d8be3-a57a-4694-a96d-f18b3d50b896	Health, nutrition and exercise	The blue light from your phone can delay the release of the sleep hormone melatonin. Stay off your phone before bed! 📱	f	f	en	\N	\N
82685e6b-db66-4fd4-bd12-534266640b62	Health, nutrition and exercise	Don't avoid exercise when you have your period, it can actually help with your cramps! 💪	f	f	en	\N	\N
0fcec757-5ca5-434e-b1a6-b5aad5bb4a4e	Health, nutrition and exercise	Teenagers make the sleep hormone melatonin later at night, which is why you might struggle to fall asleep! 💤	f	f	en	\N	\N
04214a7b-2b43-49fa-af6f-020f76f46d27	Health, nutrition and exercise	Teenagers should sleep 8–10 hours per night! 🌙	f	f	en	\N	\N
b694be0e-5677-408d-80f3-f4254f62594e	Health, nutrition and exercise	Your mental health is just as important as your physical health! 🙏	f	f	en	\N	\N
b4fe59df-a9fb-4406-aacc-d6e8dcc7a4c7	Health, nutrition and exercise	Teenagers should get about 1 hour of physical activity most days. 🏃	f	f	en	\N	\N
67a5e86d-8a6f-4527-9779-60154435c768	Health, nutrition and exercise	There are 3 body types: ectomorph, endomorph, and mesomorph. Your type affects how easy it is to change your body shape. 😲	f	f	en	\N	\N
1a237f22-eb13-4803-961c-4731153503e8	Health, nutrition and exercise	It's normal to gain weight during your period! Your hormones increase the amount of water in your body — it usually goes away in a few days. 💦	f	f	en	\N	\N
e88d04c8-d049-4055-858d-d89f9c32a905	Health, nutrition and exercise	Cold food won't cause more cramps during your period. But warm foods can be comforting! 🍚	f	f	en	\N	\N
a4094236-e638-49c1-91fb-9efac9f60e62	Health, nutrition and exercise	Eat foods full of iron like red meat, lentils or leafy green vegetables when you have your period.🍃	f	f	en	\N	\N
3feb3ffe-26ae-4755-818b-a14131c341a6	Health, nutrition and exercise	You can get your 1 hour of daily exercise by playing outside, dancing or taking a walk — anything! 💃	f	f	en	\N	\N
5eb15e97-a0c8-4a39-8631-59eae3727198	Health, nutrition and exercise	Just after your period, your body responds better to the sleep hormone melatonin. 💤	f	f	en	\N	\N
20055367-2e07-4017-9dc9-034fd2ca5c3a	Managing menstruation	You should change your pad every 2–6 hours or whenever you think it is full. ⌛	f	f	en	\N	\N
7260684b-5e34-4f1b-b575-daaba7bb29ef	Managing menstruation	Sore breasts happen when estrogen enlarges your breast ducts and progesterone causes swollen glands! 😨	f	f	en	\N	\N
3ab802f7-99a6-4dcc-b248-848a4b4270e1	Managing menstruation	Period leaks and stains happen to almost every girl — it's totally normal! 🎀	f	f	en	\N	\N
9407ff83-8ae8-4ebc-92b4-503c23d46115	Managing menstruation	You can make an emergency homemade pad by folding tissue and placing it in the crotch of your underwear! 👍	f	f	en	\N	\N
eddb65c0-ee40-4361-b0c3-c4f154a64122	Managing menstruation	There's no way to force your first period to start — your body will know when it's ready! 🥰	f	f	en	\N	\N
488fb641-c4fd-4372-8fd5-714459f7c104	Managing menstruation	Prostaglandins can cause your bowels to contract, leading to more poo during your period. 💩	f	f	en	\N	\N
a779c6e1-4238-42ea-ad1c-b687f692fe7e	Managing menstruation	You feel bloated on your period as changing hormones cause you to retain more water and salt. 😓	f	f	en	\N	\N
37c5e174-afa7-47c2-add4-cb68861f3cb2	Managing menstruation	You should change your tampon every 4–8 hours, or sooner if it feels full or starts leaking. ⏰	f	f	en	\N	\N
ee2fbe93-4080-4a79-8958-7dc0233273ad	Managing menstruation	Periods usually last for 2–7 days, but every girl is different! 👑	f	f	en	\N	\N
a443234e-ba34-43c3-a9a1-27c704fd1b54	Managing menstruation	Some absorbent underwear has clasps on each side and can be easier if you have a disability. 💟	f	f	en	\N	\N
eb98e172-c70f-44d1-bea3-59f46ac699bc	Managing menstruation	If you use a wheelchair, pads with wings may move less when you shift or transfer. 😌	f	f	en	\N	\N
3c9c524b-74dc-4ec6-9527-3222a80aea58	Periods and life	If you have spots, keep your skin clean, moisturized and protected from the sun. ☀️	f	f	en	\N	\N
bbe27953-86b8-4773-b91f-3627284525a8	Managing menstruation	Don't judge yourself for feeling something ‘negative’ like jealousy or anger. Respect and feel your emotions so you can move forward. 🙏	f	f	en	\N	\N
79dafef8-4064-447b-9531-1dd99e3f5be6	Managing menstruation	If you use a catheter, clean your perinial area every time you change your period products. 🌸	f	f	en	\N	\N
7a7626cd-c24d-4b99-83b6-a4215dae97be	Managing menstruation	You don't need to wash inside your vagina during your period (or ever!) as this can increase the risk of infection. 🛀	f	f	en	\N	\N
c0075acf-24dc-484f-8361-f0a70e37fcd3	Managing menstruation	Using a tampon does NOT mean you are no longer a virgin.👍 Losing your virginity only happens if you have sex.	f	f	en	\N	\N
7d5d6f3f-7a09-49ea-a5df-fa1d24d7a398	Managing menstruation	Your uterus contracts to push out the old lining of the womb during your period — that's what cramps are! 😖	f	f	en	\N	\N
64d389ed-2ca7-4d49-9df2-1d88658f6c82	Managing Menstruation	Some menstrual cups have special features like pull-tabs that make them easier to remove. 😌	f	f	en	\N	\N
83e14fe1-4a66-4b52-8665-644e5056b5a5	Managing Menstruation	If your vagina feels dry, try a tampon with an applicator or adding lubricant to the tip. 💦	f	f	en	\N	\N
a69f2534-4d84-4e36-a400-c14caaadf183	Managing Menstruation	Try different period products and give yourself time to find what feels right for you. 💙	f	f	en	\N	\N
ca54956e-50d0-4dc1-8fca-e51b833fe133	Menstruation and menstrual cycle	The womb creates a fresh lining every month in preparation for a possible baby. Your period is the old lining coming out! ⤵️	f	f	en	\N	\N
906b7089-5bd1-489b-b395-39ca8de8b113	Menstruation and menstrual cycle	Vaginas don't smell like flowers or perfume. However you smell is normal! 👑	f	f	en	\N	\N
5eb60621-2235-4a40-a5fa-991752c6e836	Menstruation and menstrual cycle	In regular cycles, ovulation happens 10–15 days before your next period. 📆	f	f	en	\N	\N
2c12351e-c8e6-4957-94ac-779d4f3750ee	Menstruation and menstrual cycle	In your teens, early, late or missed periods are totally normal as your cycle is still developing. 😊	f	f	en	\N	\N
02e0a251-e750-488b-9f3a-bebcf4d98f96	Menstruation and menstrual cycle	The menstrual cycle can be between 21–35 days — everyone is different! 👑	f	f	en	\N	\N
6e1a4133-2dd7-450c-b68e-074d56c3eca6	Menstruation and menstrual cycle	A new routine, changes in your diet, or feeling stressed can all make you miss a period! 😮	f	f	en	\N	\N
7f7158df-6a9c-4c17-8195-e59cff6cb6a4	Menstruation and menstrual cycle	Stress affects hormones like estrogen, which can delay your period. Try to relax if you're late. 🙏	f	f	en	\N	\N
0b8839b0-35a0-4dd5-a1db-3726664580ed	Menstruation and menstrual cycle	Tissue from your uterus can block your cervix opening, making your period flow stop for a few hours or days. 🔴	f	f	en	\N	\N
b1975975-4361-4be1-908e-90f650bdc796	Menstruation and menstrual cycle	Your vagina has its own natural cleaning system. There's no need for wipes, sprays or deodorants. Just use water! 🛀	f	f	en	\N	\N
0104e9e4-4f65-41a4-b76b-67f546f4f934	Menstruation and menstrual cycle	Only half of 'period blood' is blood! 😮 The rest is tissue that lines your womb and vagina.	f	f	en	\N	\N
ceae379f-35dd-4583-aa26-8e6eb86dff3b	Menstruation and menstrual cycle	Spotting is a tiny bit of bleeding between your periods. It might look little pink spots in your underwear. 🔴	f	f	en	\N	\N
beea63b6-8b2c-4e05-8c02-540a1f9b7446	Menstruation and menstrual cycle	Eggs only live for 12–24 hours after ovulation! ⏰	f	f	en	\N	\N
ad521a26-1bd7-4b6e-91e5-9851fd3b6f7c	Mental health	Self-care means being kind to yourself and others, even when it's tough. 👏	f	f	en	\N	\N
ef66d47f-0467-43a8-9a5e-6b5ece2aa1e6	Mental health	Write a list of what makes you special and look at it when you doubt yourself! 😊	f	f	en	\N	\N
3e866318-cffd-4364-a207-160b5b66cea3	Mental health	As a teen, it's totally normal to feel anxious or nervous sometimes. 💙	f	f	en	\N	\N
c88a4dee-872a-434e-aa77-28b84e813af5	Mental health	Singing your favorite song out loud can help you stay calm when you're anxious or stressed. 😊	f	f	en	\N	\N
00f0c024-83bb-4814-bb71-e6ea05f6377d	Mental health	Self-care is about making time to look after yourself — mentally and physically! 😍	f	f	en	\N	\N
16b6ba95-a74e-4ef5-a0a3-90bbaafbaf84	Mental Health	If you feel sad, hopeless, and have no motivation for over 2 weeks, it might be depression. Talk to someone to get support.👏	f	f	en	\N	\N
132596ed-4f40-417a-ae7e-57e391c30535	Mental Health	Feelings aren't facts. Just because you think something about yourself, doesn't mean others see you that way! 😊	f	f	en	\N	\N
9b0818bf-1838-433b-b975-cfb1ce7d677e	My human rights	As a girl, it's your right to live free from discrimination, be educated, and choose who to marry! 👏	f	f	en	\N	\N
39a85739-e3ca-40bd-997d-54838de63c03	My human rights	Getting married under 18 is child marriage, and it's not OK! It puts your physical and mental health at risk. 😣	f	f	en	\N	\N
68de4f63-14e0-4ce3-91a3-f68dc890d97d	My rights	As a girl, it's your RIGHT to choose when you want children or if you even want them at all! 👶	f	f	en	\N	\N
bed7fcaa-7393-4c9d-986f-07d08a1c7945	My rights	Most child marriages happen to girls, and it's not okay. 😣	f	f	en	\N	\N
9b310b46-7c00-4e9d-8daa-b634fcdf78e6	My rights	Everyone has human rights! 👏	f	f	en	\N	\N
f53237e4-5b5e-479e-9393-60273e1f94ef	My rights	If you're under 18, one of your human rights is the RIGHT to play! 😆	f	f	en	\N	\N
957c2e02-af64-4556-bf69-2b6658fe7a0e	My rights	We all have human rights based on dignity, equality and freedom! 👏	f	f	en	\N	\N
4fa620ca-4bc8-43c8-bdc6-41a817b98ff9	My rights	As a girl, it's your RIGHT to choose who and when you want to marry, or if you want to get married at all. 🙌	f	f	en	\N	\N
8a8acf5e-2513-4431-a550-a22dd394196b	Myths and feelings	Some people think that girls with disabilities don't get their period – but they do! ☺️	f	f	en	\N	\N
00194f76-5025-49a4-8c16-6e62bd625991	Myths and feelings	Having a period doesn't mean you are ready to get married. You should be emotionally mature before marriage! 👏	f	f	en	\N	\N
219cb3c1-d962-4a8e-a54c-0f37d3361373	Myths and feelings	There is no scientific reason why girls should live, eat or sleep separately during their periods. 😐	f	f	en	\N	\N
6a69a3cf-b9d0-480a-a7fe-2d61be9ad8e5	Myths and feelings	In many cultures, a girl's first period is a cause for celebration as she enters womanhood. 🎉	f	f	en	\N	\N
29bb8e2a-57a9-490d-86da-a8512629a0f5	Myths and feelings	Mood swings are sudden, extreme changes in your mood that happen a lot during puberty! 😒	f	f	en	\N	\N
b3a952f1-32f3-4557-91ab-a65a9e8dab00	Myths and feelings	If you feel moody, talking about it with someone you love can help a lot. 💛	f	f	en	\N	\N
0e8be29c-7a55-4b62-bd3d-eea91a94791e	Myths and feelings	You can swim on your period (just wear a tampon or menstrual cup, not a pad)! 🏊	f	f	en	\N	\N
a170543b-b851-49b9-952e-458d756a811b	Myths and feelings	Some animals have a strong sense of smell, and might be able to tell you smell different on your period! 🐱	f	f	en	\N	\N
d0a9b5a6-12c7-4265-9b67-7a6122f44194	Myths and feelings	If your period's late, eating or drinking certain herbs or fruits WON'T make it start! 🍉	f	f	en	\N	\N
adcec7d2-0201-47fe-a4cc-45cfa8d46a58	Myths and feelings	After your period, estrogen peaks so you might feel more motivated, outgoing and confident! 🎉	f	f	en	\N	\N
a461ab41-1531-4fad-8a72-ebea2a34018d	Myths and feelings	After ovulation, progesterone peaks so you might feel calm and less anxious. 🙏	f	f	en	\N	\N
4c18279b-ec12-464b-b343-c866155a87bd	Periods and life	Almost everyone has stretch marks, and they will grow and change just as you do! 😍	f	f	en	\N	\N
4ec68014-31d8-403f-aa00-78a8b91842f6	Periods and life	Spots happen when the tiny holes in your skin (called pores) become blocked by dead skin and skin oil. 😨	f	f	en	\N	\N
6e37b485-6087-4c57-a96c-4c4fcee741c3	Periods and life	Feeling down? Get active! Running, jumping, or dancing can put a smile back on your face. 😊	f	f	en	\N	\N
22514418-f690-4b16-90e2-d4efef7b65f2	Periods and life	Pack a 'period kit' for your school bag with pads and spare underwear! 👜	f	f	en	\N	\N
88e2887f-fa54-4f8e-bd68-dce0387e7740	Periods and life	As a care giver, communicate clearly with girls of all abilities about their period. ☀️	f	f	en	\N	\N
3fb9630a-020a-42f9-b12e-6ac9e14dc789	Periods and life	Tracking your period can help you plan activities and plan to ask for help if you need it. 💗	f	f	en	\N	\N
5026e874-e7e5-4d69-951a-e61f731e2711	Periods and life	If you have a catheter, try different period products to find what feels comfortable for you! ☺️	f	f	en	\N	\N
c9b04601-4818-4204-aeaf-56817d785042	Periods and life	The best beauty advice is to eat delicious, healthy food, drink plenty of water, stay active, and get lots of sleep! 😴	f	f	en	\N	\N
cc4cabdd-ee7f-4fc8-abba-6531e0610210	Periods and life	Even though periods are normal and healthy, it's OK to dislike them. 😡	f	f	en	\N	\N
57e567e4-430e-4593-a5a2-947ea28ba245	Periods and life	After ovulation, you might see clogged pores and acne thanks to rising progesterone. 😣	f	f	en	\N	\N
f5e982af-cef0-43db-a561-197fbd7fd746	Periods and life	Your skin may glow after your period as higher estrogen keeps it plump!💄	f	f	en	\N	\N
76977e53-3965-4b7b-8e30-53b4cde4e01f	Periods and life	Stretch marks are normal as you go through growth spurts during puberty! 👯	f	f	en	\N	\N
c5e575e0-b366-4c1d-84cf-f9d672b82b64	Personal identity	It's normal to go through phases of being attracted to the same sex. Being a teenager is a time of discovery — roll with it! 😄	f	f	en	\N	\N
49746009-ac3e-4bb1-b35f-39336d070537	Personal identity	If you're gay or transgender, you can still have a happy life, partner, and kids. Surround yourself with people who love you and anything is possible. 💖	f	f	en	\N	\N
5ee08336-fb9e-4cc8-b838-7a3838c7e1d1	Personal identity	Being non-binary means you don't feel male or female, but something else. 💗	f	f	en	\N	\N
517b1083-35d9-405d-9ce9-ef80416ccd34	Personal identity	Being heterosexual or straight means you're attracted to people of the opposite gender! ❤️	f	f	en	\N	\N
3238f402-1a44-49b8-abef-290a479f4002	Personal identity	Being transgender means you feel you were born in the wrong body. 💜	f	f	en	\N	\N
ec29b6ef-682f-4814-b02d-4327fa3fafae	Personal identity	Being demisexual means you're only attracted to someone once you get to know them better. 😍	f	f	en	\N	\N
2143e3b5-e9b0-455e-be9f-c86942b703de	Personal identity	Being asexual means you do not feel sexual or romantic attraction to others. 💖	f	f	en	\N	\N
1e08975a-3356-48c4-9d8e-36cb25d11f01	Personal identity	'Gay' can be used for anyone who likes people of the same gender. 'Lesbian' describes a woman who likes other women. 😊	f	f	en	\N	\N
fd3eb94c-b97a-454d-b305-6b38a9e82392	Puberty	Weight gain, becoming suddenly taller, mood swings and oily skin are all signs of puberty arriving. Annoying, but normal! 👿	f	f	en	\N	\N
4a9a26b9-6f47-4ff0-8daf-3d03a2abe6a1	Puberty	Girls' voices get a little lower when they hit puberty! 🔊	f	f	en	\N	\N
b150605b-5605-4475-83b3-3143ec343c61	Puberty	Boys start puberty a little later than girls, usually between 10–14 years old! 👦	f	f	en	\N	\N
f4f9cf2c-7b24-4923-b7a3-03c4df33958d	Puberty	Puberty starts between the ages of 9–13 for most girls, but it can be earlier or later! 👧	f	f	en	\N	\N
a24ae9d0-4a26-4bcb-ba32-5657cd2f94a2	Puberty	The hymen is a thin piece of skin that covers part of the opening to the vagina. It thins over time and tears! 👍	f	f	en	\N	\N
46cdc0c6-bc0a-4eed-a78c-d8e058f259b1	Puberty	Girls have 3 openings between their legs: the urethra (for pee), the vagina (for periods, sex, and giving birth), and the anus (for poo). 👈	f	f	en	\N	\N
cd549371-247b-4d80-ad33-3050ccf65f34	Puberty	During puberty, boys get taller, their voices get deeper and pubic hair grows. 😮	f	f	en	\N	\N
ea3b51af-2ab5-493c-aa34-434f767d1c42	Puberty	The vulva is the name for all the parts between your legs on the outside. 😄	f	f	en	\N	\N
d7f923e9-2a8f-438e-b7f1-4268702a6a0f	Puberty	Puberty is when you change from a child into a young woman. 👧	f	f	en	\N	\N
8f4d0a77-1840-4c6e-ae35-d39f206e4323	Puberty	The first sign of puberty is usually growing breasts, then hair on the genitals and armpits, and later, your periods! 😯	f	f	en	\N	\N
3bde671c-14e9-48f5-bb9e-09e7063ea370	Violence and staying safe	It is illegal to share nude images of under 18s (even if it's you in the picture)! 😮	f	f	en	\N	\N
73429b91-0c9d-4f0f-855f-30b60dc794b1	Violence and staying safe	Unwanted hugging or sexual 'jokes' are both considered sexual harassment, and it's not okay! 😡	f	f	en	\N	\N
078209d9-f569-4154-af03-cc6a7d83b654	Violence and staying safe	If someone hurts you physically on purpose, it's NEVER your fault and you DON'T deserve it. ❤️	f	f	en	\N	\N
950af938-af30-4a36-b05d-0979093efbb0	Violence and staying safe	If a guy touched you and it didn't feel right, trust your instinct and do something about it. You have the right to say NO and to be listened to!❗	f	f	en	\N	\N
0eaf5037-f1f2-42ef-bfef-2f78ec69d794	Violence and staying safe	If a guy's comments make you feel uncomfortable and he doesn't stop when you ask him to, it's called sexual harassment. It's not 'just' flirting! 😡	f	f	en	\N	\N
feef36ed-ac8f-4692-875d-3a6b0a7b571f	Violence and staying safe	Physical abuse can come from anyone, including your family and people you love. But it's never okay! 😓	f	f	en	\N	\N
b86bed31-21db-496e-81d1-c3ef5318dfde	Violence and staying safe	Physical abuse is when someone intentionally causes you physical pain, and it's never okay. 🚫	f	f	en	\N	\N
3b79fd8d-dee0-4c4f-8c88-e280feb714ca	Violence and staying safe	If you get sexually harassed, it's NOT your fault and you DIDN'T ask for it. 💛	f	f	en	\N	\N
01c3d920-f3c2-4684-b21f-58710c452b57	महिनावारी व्यवस्थापन	एस्ट्रोजेनले तपाईंको स्तनको नलीलाई ठूलो बनाउँदा र प्रोजेस्टेरोनले ग्रन्थीहरू सुन्निदा स्तन दुख्छ! 😨	f	f	en	\N	\N
2adbaa15-2911-4bb4-94b0-dded6c40101a	महिनावारी व्यवस्थापन	तपाईंले आफ्नो प्याड प्रत्येक २–६ घण्टामा फेर्नु गर्नुपर्छ वा जब प्याड भरिएकोे हुन्छ तब यो फेर्नु फेर्नु गर्नुपछ। ⌛	f	f	en	\N	\N
979f648f-0565-4bb6-9fbe-56da566cf8d3	महिनावारी व्यवस्थापन	महिनावारी सामान्यतया २–७ दिन सम्म रहन्छ, तर यो ब्यक्ती अनुसार अलि अलि फरक पनि हुन्छ । 👑	f	f	en	\N	\N
75057bd7-a2a8-4e29-8da0-c0f611feba54	महिनावारी व्यवस्थापन	तपाइँको पहिलो महिनावारी आफैं जबरजस्ती सुरु गर्ने कुनै उपाय हुदैंन । महिनावारीको लागि समय भयो भन्ने कुरा तपाइँको शरीरले आफै थाहा पाउनेछ ! 🥰	f	f	en	\N	\N
0f342267-11d8-4eaf-a625-3a346163e79e	महिनावारी व्यवस्थापन	टिस्यु फोल्ड गरेर त्यसलाई आफ्नो अन्डरवियरको मुनिको भागमा राखेर तपाईंले आपतकालीन घरेलु प्याड बनाउन सक्नुहुन्छ! 👍	f	f	en	\N	\N
4e22ce71-5799-4f95-9c50-3876abee743b	महिनावारी व्यवस्थापन	बेला बेलामा रगत चुहिने र दाग लाग्ने लगभग हरेक किशोरीमा हुन्छ । यो सामान्य कुरा हो! 🎀	f	f	en	\N	\N
5af6321a-1ba0-4e42-979e-4135c56ad4fb	महिनावारी व्यवस्थापन	तपाईंले आफ्नो ट्याम्पोन प्रत्येक ४–८ घण्टामा परिवर्तन गर्नुपर्छ वा भरियो भने त्यो भन्दा चाँडै पनि फेर्नु पर्छ । ⏰	f	f	en	\N	\N
a9cf2b2d-55a1-4d66-9fdf-c6edd6963155	महिनावारी व्यवस्थापन	महिनावारीको समयमा तपाइँ आफ्नो शरीर फुलेको वा सुन्निएको महसुस गर्नुहुन्छ किनभने एस समयमा परिबर्तित हर्मोनको कारणले तपाईको शरीरलाई धेरै पानी र नुन चाहिएको हुन्छ । 😓	f	f	en	\N	\N
7d6c77dd-003c-4e2b-8237-3f88a80b06ee	महिनावारी व्यवस्थापन	प्रोस्टाग्ल्यान्डिनले तपाईंको आन्द्रालाई संकुचित गराउन सक्छ, जसले गर्दा तपाईंको महिनावारीको समयमा थप दिशा लाग्दछ । 💩	f	f	en	\N	\N
224886b5-046e-44c4-bde1-c9e15dfc8640	स्वास्थ्य, पोषण र व्यायाम	किशोरकिशोरीहरूले हरेक दिनमा लगभग एक घण्टा शारीरिक कृयाकलाप गर्नुपर्छ । 🏃	f	f	en	\N	\N
dbad7c11-ad95-47dc-a320-7b53f634310c	स्वास्थ्य, पोषण र व्यायाम	तपाईको मानसिक स्वास्थ्य पनि शारीरिक स्वास्थ्य जत्तिकै महत्वपूर्ण छ! 🙏	f	f	en	\N	\N
61d67206-b1ea-4f06-bcba-8fc52a68c0bc	स्वास्थ्य, पोषण र व्यायाम	किशोरकिशोरीहरू हरेक रात ८–१० घण्टा सुत्नु पर्छ! 🌙	f	f	en	\N	\N
3cb35d30-8b0c-4249-800b-3e1e56de3f7d	स्वास्थ्य, पोषण र व्यायाम	किशोरकिशोरीहरूको शरीरले निद्रा सम्बन्धी हर्मोन (मेलाटोनिन) राति ढिलो गरि उत्पादन गर्छ। जसका कारण तपाइलाई निन्द्रा पनि ढिलो लग्छ वा निदाउन गाह्रो हुन सक्छ! 💤	f	f	en	\N	\N
35744e2e-ea5e-45c4-9e3f-2fdc6b988043	स्वास्थ्य, पोषण र व्यायाम	तपाईंले दैनिक एक घण्टाको व्यायाम घर बाहिर खेलेर, नाचेर वा हिँडेर पुरा गन सक्नुहुन्छ ! यी मध्ये जुनसुकै गरेपनि हुन्छ ! 💃	f	f	en	\N	\N
98ab8b4c-7253-41fc-85e4-f7a62b8a5b2f	स्वास्थ्य, पोषण र व्यायाम	तपाईको फोनबाट निस्कने नीला रंगकोे बत्तीले निद्रा सम्बन्धी हर्मोन (मेलाटोनिन) निस्कनलाई बाधा पुर्याउन सक्छ । त्यसैले सुत्नुअघि आफ्नो फोन बन्द गर्नुहोस् । 📱	f	f	en	\N	\N
d11b033b-f218-4d5e-a219-adbd6796781d	स्वास्थ्य, पोषण र व्यायाम	महिनावारी चक्र सुरु भएपछी तपाईंको शरीरले निद्रा सम्बन्धी हर्मोन (मेलाटोनिन) निस्कनलाई सहज बनाउँछ । 💤	f	f	en	\N	\N
\.


--
-- Data for Name: help_center; Type: TABLE DATA; Schema: periodtracker; Owner: periodtracker
--

COPY periodtracker.help_center (id, title, caption, "contactOne", "contactTwo", address, website, lang, region, "subRegion", "isAvailableNationwide", "primaryAttributeId", "otherAttributes", "isActive", "sortingKey") FROM stdin;
\.


--
-- Data for Name: help_center_attribute; Type: TABLE DATA; Schema: periodtracker; Owner: periodtracker
--

COPY periodtracker.help_center_attribute (id, name, emoji, "isActive", lang) FROM stdin;
\.


--
-- Data for Name: notification; Type: TABLE DATA; Schema: periodtracker; Owner: periodtracker
--

COPY periodtracker.notification (id, title, content, date_sent, status, lang) FROM stdin;
\.


--
-- Data for Name: oky_user; Type: TABLE DATA; Schema: periodtracker; Owner: periodtracker
--

COPY periodtracker.oky_user (id, date_of_birth, gender, location, country, province, store, "nameHash", "passwordHash", "memorableQuestion", "memorableAnswer", date_signed_up, date_account_saved, metadata) FROM stdin;
6a2043f7-2ec8-4615-913f-f42417e60767	2000-01-01 00:00:00	Female	Urban	US	CA	\N	edb2e37f90825097c1d6083d994efc741d2209e392f91b6abbd43772a3a027f8	$2b$10$nyuQaC8aDBOAtT62XM4cRejIzti6JJVs7QJWmBShq5mfnjefQxV1m	favourite_teacher	$2b$10$tzpw5IPH88zyuk7Ic7hjWOsEHKsg9BFv7bST65TJyPlglwr6Vd2Iy	2024-01-01 00:00:00	2025-07-25 09:56:39.53703	{}
8907de2d-efbd-4bff-9256-97a31da9194c	2018-01-01 18:15:00	Male	Urban	NP	3110	{"storeVersion":-1,"appState":{"app":{"appVersionName":"2.32.18","appVersionCode":"2.32.18","firebaseToken":null,"locale":"en","hasOpened":true,"isTutorialOneActive":true,"isTutorialTwoActive":true,"isLoginPasswordActive":true,"isFuturePredictionActive":true,"theme":"village","avatar":"panda","verifiedDates":[],"predicted_cycles":[],"predicted_periods":[],"deviceId":"539e5d0f-3c2d-417d-8c8b-ccca60ca4103","isHapticActive":true,"isSoundActive":true,"lastPressedCardDate":null,"lastPressedEmojiDate":null},"prediction":{"isActive":false,"currentCycle":{"startDate":"2025-07-11T00:00:00.000Z","periodLength":5,"cycleLength":26},"smartPrediction":{"circularPeriodLength":[],"circularCycleLength":[],"smaPeriodLength":5,"smaCycleLength":26},"futurePredictionStatus":true,"history":[],"actualCurrentStartDate":null},"helpCenters":{"savedHelpCenterIds":[]}}}	76e11af94d353c6edf577441a23d0f5ebe7b3beb5fc36afd05987c3c14b46830	$2b$10$2ud579Los4xZI.i/Hx/sVOrDsR4H..cR.wDj1WsYcmK2/9BC2.uWu	favourite_actor	$2b$10$iOOY9W7ZQVo04DF3SrAZS.Mtf4gF.USWcSOZDaB5QdQB/OX4im6Ge	2025-07-25 08:31:56.515	2025-07-25 08:31:57.283	{"periodDates":[{"date":"25/07/2025","mlGenerated":true,"userVerified":null},{"date":"26/07/2025","mlGenerated":true,"userVerified":null},{"date":"27/07/2025","mlGenerated":true,"userVerified":null},{"date":"28/07/2025","mlGenerated":true,"userVerified":null},{"date":"29/07/2025","mlGenerated":true,"userVerified":null},{"date":"22/08/2025","mlGenerated":true,"userVerified":null},{"date":"23/08/2025","mlGenerated":true,"userVerified":null},{"date":"24/08/2025","mlGenerated":true,"userVerified":null},{"date":"25/08/2025","mlGenerated":true,"userVerified":null},{"date":"26/08/2025","mlGenerated":true,"userVerified":null},{"date":"19/09/2025","mlGenerated":true,"userVerified":null},{"date":"20/09/2025","mlGenerated":true,"userVerified":null},{"date":"21/09/2025","mlGenerated":true,"userVerified":null},{"date":"22/09/2025","mlGenerated":true,"userVerified":null},{"date":"23/09/2025","mlGenerated":true,"userVerified":null},{"date":"17/10/2025","mlGenerated":true,"userVerified":null},{"date":"18/10/2025","mlGenerated":true,"userVerified":null},{"date":"19/10/2025","mlGenerated":true,"userVerified":null},{"date":"20/10/2025","mlGenerated":true,"userVerified":null},{"date":"21/10/2025","mlGenerated":true,"userVerified":null},{"date":"14/11/2025","mlGenerated":true,"userVerified":null},{"date":"15/11/2025","mlGenerated":true,"userVerified":null},{"date":"16/11/2025","mlGenerated":true,"userVerified":null},{"date":"17/11/2025","mlGenerated":true,"userVerified":null},{"date":"18/11/2025","mlGenerated":true,"userVerified":null},{"date":"12/12/2025","mlGenerated":true,"userVerified":null},{"date":"13/12/2025","mlGenerated":true,"userVerified":null},{"date":"14/12/2025","mlGenerated":true,"userVerified":null},{"date":"15/12/2025","mlGenerated":true,"userVerified":null},{"date":"16/12/2025","mlGenerated":true,"userVerified":null},{"date":"09/01/2026","mlGenerated":true,"userVerified":null},{"date":"10/01/2026","mlGenerated":true,"userVerified":null},{"date":"11/01/2026","mlGenerated":true,"userVerified":null},{"date":"12/01/2026","mlGenerated":true,"userVerified":null},{"date":"13/01/2026","mlGenerated":true,"userVerified":null},{"date":"06/02/2026","mlGenerated":true,"userVerified":null},{"date":"07/02/2026","mlGenerated":true,"userVerified":null},{"date":"08/02/2026","mlGenerated":true,"userVerified":null},{"date":"09/02/2026","mlGenerated":true,"userVerified":null},{"date":"10/02/2026","mlGenerated":true,"userVerified":null},{"date":"06/03/2026","mlGenerated":true,"userVerified":null},{"date":"07/03/2026","mlGenerated":true,"userVerified":null},{"date":"08/03/2026","mlGenerated":true,"userVerified":null},{"date":"09/03/2026","mlGenerated":true,"userVerified":null},{"date":"10/03/2026","mlGenerated":true,"userVerified":null},{"date":"03/04/2026","mlGenerated":true,"userVerified":null},{"date":"04/04/2026","mlGenerated":true,"userVerified":null},{"date":"05/04/2026","mlGenerated":true,"userVerified":null},{"date":"06/04/2026","mlGenerated":true,"userVerified":null},{"date":"07/04/2026","mlGenerated":true,"userVerified":null},{"date":"01/05/2026","mlGenerated":true,"userVerified":null},{"date":"02/05/2026","mlGenerated":true,"userVerified":null},{"date":"03/05/2026","mlGenerated":true,"userVerified":null},{"date":"04/05/2026","mlGenerated":true,"userVerified":null},{"date":"05/05/2026","mlGenerated":true,"userVerified":null},{"date":"29/05/2026","mlGenerated":true,"userVerified":null},{"date":"30/05/2026","mlGenerated":true,"userVerified":null},{"date":"31/05/2026","mlGenerated":true,"userVerified":null},{"date":"01/06/2026","mlGenerated":true,"userVerified":null},{"date":"02/06/2026","mlGenerated":true,"userVerified":null},{"date":"26/06/2026","mlGenerated":true,"userVerified":null},{"date":"27/06/2026","mlGenerated":true,"userVerified":null},{"date":"28/06/2026","mlGenerated":true,"userVerified":null},{"date":"29/06/2026","mlGenerated":true,"userVerified":null},{"date":"30/06/2026","mlGenerated":true,"userVerified":null}]}
072fff96-872f-4190-abc6-0d7a4ba453d0	2000-01-01 00:00:00	Female	Urban	US	CA	\N	d79aeec77b3b6e6ec5f45ae5e040173380262e1ea51b38747195c3cf09a02f16	$2b$10$/EnRSs/UvyhapqbO4Y0rTeAmey9ZjjdNaGQHKoG31Q6cruCA05R6m	favourite_teacher	$2b$10$m0oZEovonsGwFfymG3c71Oi2tdZz5x0yYevntBIi/iSDEP6dPLVSW	2024-01-01 00:00:00	2025-07-25 09:43:47.462264	{}
d52bd883-ab62-4afb-8e33-8887410efa75	2018-01-01 18:15:00	Female	Urban	NP	3111	{"storeVersion":-1,"appState":{"app":{"appVersionName":"2.32.18","appVersionCode":"2.32.18","firebaseToken":null,"locale":"en","hasOpened":true,"isTutorialOneActive":true,"isTutorialTwoActive":true,"isLoginPasswordActive":true,"isFuturePredictionActive":true,"theme":"desert","avatar":"panda","verifiedDates":[],"predicted_cycles":[],"predicted_periods":[],"deviceId":"86152b5d-8fd2-4651-a95b-7d85403cc2d1","isHapticActive":true,"isSoundActive":true,"lastPressedCardDate":null,"lastPressedEmojiDate":null},"prediction":{"isActive":false,"currentCycle":{"startDate":"2025-07-11T00:00:00.000Z","periodLength":5,"cycleLength":26},"smartPrediction":{"circularPeriodLength":[],"circularCycleLength":[],"smaPeriodLength":5,"smaCycleLength":26},"futurePredictionStatus":true,"history":[],"actualCurrentStartDate":null},"helpCenters":{"savedHelpCenterIds":[]}}}	3f9dfa41efa889646b63376f9add4d4e70d15ae1c9f7d8d0c23f4141699c18bf	$2b$10$Aef1SCs/flUxdWUogtPPGelETPyg8ZtBeQohSiAtSRTNKYvmCEYRS	favourite_teacher	$2b$10$eAA4iNfiVpsJ5SOgpaQmWeoZ9twNBWSYy5OCcjq3EBHWjydr54jum	2025-07-25 10:20:00.578	2025-07-25 10:20:00.961	{"periodDates":[{"date":"25/07/2025","mlGenerated":true,"userVerified":null},{"date":"26/07/2025","mlGenerated":true,"userVerified":null},{"date":"27/07/2025","mlGenerated":true,"userVerified":null},{"date":"28/07/2025","mlGenerated":true,"userVerified":null},{"date":"29/07/2025","mlGenerated":true,"userVerified":null},{"date":"22/08/2025","mlGenerated":true,"userVerified":null},{"date":"23/08/2025","mlGenerated":true,"userVerified":null},{"date":"24/08/2025","mlGenerated":true,"userVerified":null},{"date":"25/08/2025","mlGenerated":true,"userVerified":null},{"date":"26/08/2025","mlGenerated":true,"userVerified":null},{"date":"19/09/2025","mlGenerated":true,"userVerified":null},{"date":"20/09/2025","mlGenerated":true,"userVerified":null},{"date":"21/09/2025","mlGenerated":true,"userVerified":null},{"date":"22/09/2025","mlGenerated":true,"userVerified":null},{"date":"23/09/2025","mlGenerated":true,"userVerified":null},{"date":"17/10/2025","mlGenerated":true,"userVerified":null},{"date":"18/10/2025","mlGenerated":true,"userVerified":null},{"date":"19/10/2025","mlGenerated":true,"userVerified":null},{"date":"20/10/2025","mlGenerated":true,"userVerified":null},{"date":"21/10/2025","mlGenerated":true,"userVerified":null},{"date":"14/11/2025","mlGenerated":true,"userVerified":null},{"date":"15/11/2025","mlGenerated":true,"userVerified":null},{"date":"16/11/2025","mlGenerated":true,"userVerified":null},{"date":"17/11/2025","mlGenerated":true,"userVerified":null},{"date":"18/11/2025","mlGenerated":true,"userVerified":null},{"date":"12/12/2025","mlGenerated":true,"userVerified":null},{"date":"13/12/2025","mlGenerated":true,"userVerified":null},{"date":"14/12/2025","mlGenerated":true,"userVerified":null},{"date":"15/12/2025","mlGenerated":true,"userVerified":null},{"date":"16/12/2025","mlGenerated":true,"userVerified":null},{"date":"09/01/2026","mlGenerated":true,"userVerified":null},{"date":"10/01/2026","mlGenerated":true,"userVerified":null},{"date":"11/01/2026","mlGenerated":true,"userVerified":null},{"date":"12/01/2026","mlGenerated":true,"userVerified":null},{"date":"13/01/2026","mlGenerated":true,"userVerified":null},{"date":"06/02/2026","mlGenerated":true,"userVerified":null},{"date":"07/02/2026","mlGenerated":true,"userVerified":null},{"date":"08/02/2026","mlGenerated":true,"userVerified":null},{"date":"09/02/2026","mlGenerated":true,"userVerified":null},{"date":"10/02/2026","mlGenerated":true,"userVerified":null},{"date":"06/03/2026","mlGenerated":true,"userVerified":null},{"date":"07/03/2026","mlGenerated":true,"userVerified":null},{"date":"08/03/2026","mlGenerated":true,"userVerified":null},{"date":"09/03/2026","mlGenerated":true,"userVerified":null},{"date":"10/03/2026","mlGenerated":true,"userVerified":null},{"date":"03/04/2026","mlGenerated":true,"userVerified":null},{"date":"04/04/2026","mlGenerated":true,"userVerified":null},{"date":"05/04/2026","mlGenerated":true,"userVerified":null},{"date":"06/04/2026","mlGenerated":true,"userVerified":null},{"date":"07/04/2026","mlGenerated":true,"userVerified":null},{"date":"01/05/2026","mlGenerated":true,"userVerified":null},{"date":"02/05/2026","mlGenerated":true,"userVerified":null},{"date":"03/05/2026","mlGenerated":true,"userVerified":null},{"date":"04/05/2026","mlGenerated":true,"userVerified":null},{"date":"05/05/2026","mlGenerated":true,"userVerified":null},{"date":"29/05/2026","mlGenerated":true,"userVerified":null},{"date":"30/05/2026","mlGenerated":true,"userVerified":null},{"date":"31/05/2026","mlGenerated":true,"userVerified":null},{"date":"01/06/2026","mlGenerated":true,"userVerified":null},{"date":"02/06/2026","mlGenerated":true,"userVerified":null},{"date":"26/06/2026","mlGenerated":true,"userVerified":null},{"date":"27/06/2026","mlGenerated":true,"userVerified":null},{"date":"28/06/2026","mlGenerated":true,"userVerified":null},{"date":"29/06/2026","mlGenerated":true,"userVerified":null},{"date":"30/06/2026","mlGenerated":true,"userVerified":null}]}
\.


--
-- Data for Name: permanent_notification; Type: TABLE DATA; Schema: periodtracker; Owner: periodtracker
--

COPY periodtracker.permanent_notification (id, message, "isPermanent", live, lang, versions) FROM stdin;
\.


--
-- Data for Name: privacy_policy; Type: TABLE DATA; Schema: periodtracker; Owner: periodtracker
--

COPY periodtracker.privacy_policy (id, json_dump, "timestamp", lang) FROM stdin;
1	[{"type":"HEADING","content":"Privacy Policy\\n\\n"},{"type":"CONTENT","content":"This privacy policy applies to the Oky Period Tracker Nepal app (hereby referred to as \\"Application\\") for mobile devices that was created by Unicef (hereby referred to as \\"Service Provider\\") as a Free service. This service is intended for use \\"AS IS\\"."},{"type":"CONTENT","content":"The Application does not gather precise information about the location of your mobile device.\\n\\nThe Service Provider may use the information you provided to contact you from time to time to provide you with important information, required notices and marketing promotions.\\n\\nFor a better experience, while using the Application, the Service Provider may require you to provide us with certain personally identifiable information. The information that the Service Provider request will be retained by them and used as described in this privacy policy."}]	2025-07-29 14:33:26.673	en
2	[{"type":"HEADING","content":"Privacy Policy\\n\\n"},{"type":"CONTENT","content":"This privacy policy applies to the Oky Period Tracker Nepal app (hereby referred to as \\"Application\\") for mobile devices that was created by Unicef (hereby referred to as \\"Service Provider\\") as a Free service. This service is intended for use \\"AS IS\\"."},{"type":"CONTENT","content":"The Application does not gather precise information about the location of your mobile device.\\n\\nThe Service Provider may use the information you provided to contact you from time to time to provide you with important information, required notices and marketing promotions.\\n\\nFor a better experience, while using the Application, the Service Provider may require you to provide us with certain personally identifiable information. The information that the Service Provider request will be retained by them and used as described in this privacy policy."},{"type":"CONTENT","content":"Opt-Out Rights\\nYou can stop all collection of information by the Application easily by uninstalling it. You may use the standard uninstall processes as may be available as part of your mobile device or via the mobile application marketplace or network."},{"type":"CONTENT","content":"Data Retention Policy\\nThe Service Provider will retain User Provided data for as long as you use the Application and for a reasonable time thereafter. If you'd like them to delete User Provided Data that you have provided via the Application, please contact them at okynepal@gmail.com and they will respond in a reasonable time."}]	2025-07-29 14:34:15.44	en
3	[{"type":"HEADING","content":"Privacy Policy\\n\\n"},{"type":"CONTENT","content":"This privacy policy applies to the Oky Period Tracker Nepal app (hereby referred to as \\"Application\\") for mobile devices that was created by Unicef (hereby referred to as \\"Service Provider\\") as a Free service. This service is intended for use \\"AS IS\\"."},{"type":"CONTENT","content":"The Application does not gather precise information about the location of your mobile device.\\n\\nThe Service Provider may use the information you provided to contact you from time to time to provide you with important information, required notices and marketing promotions.\\n\\nFor a better experience, while using the Application, the Service Provider may require you to provide us with certain personally identifiable information. The information that the Service Provider request will be retained by them and used as described in this privacy policy."},{"type":"CONTENT","content":"Opt-Out Rights\\nYou can stop all collection of information by the Application easily by uninstalling it. You may use the standard uninstall processes as may be available as part of your mobile device or via the mobile application marketplace or network."},{"type":"CONTENT","content":"Data Retention Policy\\nThe Service Provider will retain User Provided data for as long as you use the Application and for a reasonable time thereafter. If you'd like them to delete User Provided Data that you have provided via the Application, please contact them at okynepal@gmail.com and they will respond in a reasonable time."},{"type":"CONTENT","content":"Your Consent\\nBy using the Application, you are consenting to the processing of your information as set forth in this Privacy Policy now and as amended by us.\\n\\n\\nContact Us\\nIf you have any questions regarding privacy while using the Application, or have questions about the practices, please contact the Service Provider via email at okynepal@gmail.com."}]	2025-07-29 14:34:42.572	en
4	[{"type":"HEADING","content":"Privacy Policy\\n\\n"},{"type":"CONTENT","content":"Taking care of your data is important to us. We aim for the highest standards of privacy and security and we are committed to being transparent about how we process and use your data. \\n\\nThis Privacy Policy explains how your data is collected, stored and used, and what steps we take to ensure your data stays safe.  \\n\\n\\nPlease read our Privacy Policy carefully before using Oky and refer back to it regularly to check for updates. Remember, by accessing and using the Oky app or Oky website, you agree to this Privacy Policy.\\nOky was developed and is owned by UNICEF. Please do not hesitate to contact us if you have any questions about the use of your data in Oky. To contact us, please email hello@okyapp.info.\\n\\nFor the purpose of this Privacy Policy, \\"personal data\\" means any information that enables us to identify an individual, directly or indirectly, by reference to an identifier such as name, identification number, location data, online identifier or one more factors specific to the individual."},{"type":"HEADING","content":"1. What information does Oky collect about you and how do we use it?"},{"type":"CONTENT","content":"When you enter information into the Oky app, Oky uses technology to turn that data into helpful information that can help you learn more about your menstrual cycle patterns to enable you to take control of your body and your health. \\n\\n Oky has been designed to minimize the use of your personal data. Described below are the sources and types of data we collect and process, as well as information on how we process such data. "},{"type":"HEADING","content":"Login information"},{"type":"CONTENT","content":"In order to use the period tracker functions on the app, you need to create a login. During login creation, we ask you for a display or user name, date of birth, gender and location (country and province only). We encourage you to select a display name that does not disclose your real name or other information that could identify you – especially if you are under the age of 18. We request this gender, age and location data from you to understand if we are reaching the right audiences; all of this data is aggregated and anonymised."},{"type":"HEADING","content":"Device data"},{"type":"CONTENT","content":"We collect information on the device you use to access Oky’s services, such as the model, operating system, language, location and the session’s duration. This data is anonymized and is collected to help us understand our users better and how they are engaging with Oky."},{"type":"HEADING","content":"Engagement data"},{"type":"CONTENT","content":"When you use the Oky app, we and our third-party service providers process engagement data about how you are interacting with the Oky app. This engagement is anonymized, meaning it does not identify you as an individual. We use an App centre together with some customer created tracking features to record these interactions.\\n\\nWe collect this information to understand your usage of our services, for example which functions of the Oky app you are using and to ensure all the features provided by the Oky app are  functioning properly. We also collect this information to communicate with you about the app and its services. "},{"type":"HEADING","content":"Health and menstruation data"},{"type":"CONTENT","content":"Your information about your health and menstruation that you enter in the calendar feature of the Oky app, such as dates of your past and current periods, is collected and used to predict your future period data. This information is stored on our servers so that you can can have access to that information whenever you log into your account from any device. However, to protect your privacy, we have set up a system where no-one can identify any one user from this stored data. \\n\\nThe information you enter in your day cards (body, mood, activity and flow, and your daily diary card) is stored locally on your device and only you have access to it."},{"type":"HEADING","content":"Surveys"},{"type":"CONTENT","content":"Oky may ask for your feedback about the Oky app through questions and surveys, e.g. on the performance of the app or on the usefulness of the information Oky provides and your experience of using the Oky app. Information given to you via such surveys and questions is processed by Oky to improve our services and your experience with Oky. Any survey responses are anonymous."},{"type":"HEADING","content":"Cookies"},{"type":"CONTENT","content":"Cookies, which are small text files which identify your computer, phone, and other devices to our server. \\n\\nThe Oky website uses Google Analytics, which can use cookies and similar technologies to collect and analyze information about your use of the website and report on activities and trends. You can learn more about Google's practices by going to www.google.com/policies/privacy/partners/.  The information collected through Google Analytics includes your IP address, network location, what browser you are using, device IDs and characteristics, operating system version, language preferences, referring URLs, and information about the usage of the Oky website.\\n\\nHowever, Google Analytics removes any and all personal information about Oky website users (such as IP addresses) before any analytics are shared with the Oky team, so all website analytics are anoymized and cannot be used to identify you or any individual. "},{"type":"CONTENT","content":"Aggregate data"},{"type":"CONTENT","content":"We may aggregate information collected through the Oky app for statistical analysis and other lawful purpose, including in research studies intended to improve our understanding of young people's use of technology and digital tools. The results of this research may be shared with third parties, such as our partners, supporters, educators and researchers through conferences, journals and other publications."},{"type":"CONTENT","content":"If we do this, all data will be aggregated and anonymous. "},{"type":"CONTENT","content":"Legal"},{"type":"CONTENT","content":"We may use your information to enforce our Terms of Use, to defend our legal rights, and to comply with our legal obligations and internal policies."},{"type":"CONTENT","content":"2. How do we keep your data secure?"},{"type":"CONTENT","content":"Health and sensitive data"},{"type":"CONTENT","content":"We use many reasonable measures - physical and electronic - to prevent unauthorised access and disclosure of your data. However, it is always a possibility that third parties may unlawfully intercept or access your data.\\n\\n\\n\\n\\n\\n\\n\\n\\nSo, although we work extremely hard to safeguard your data, we cannot guarantee that your data will always remain private.\\n\\n\\n\\n\\n\\nThe security of our servers is regularly checked by experts to ensure your data is protected from unauthorised access. \\n\\n\\nThe following data is stored on our servers: your username, month and year of birth, gender, location (country and province), your period-related data, the menstrual cycle start and end data, and the theme, language and avatar you selected on the Oky app.\\n\\n\\n\\n\\n\\nHowever, we have put a system in place so that no-one can identify any one user from this stored data. We store this data on our server so that you can access this data when you log into your account from different devices. \\n\\n\\n\\n\\n\\nYou can contact us with any questions you may have about data security via email: hello@okyapp.info."},{"type":"CONTENT","content":"Recommendations for protecting your data"},{"type":"CONTENT","content":"We believe the biggest threat to the security and privacy of your data is if someone—probably someone you know—gains access to your device. The data you enter into Oky is private and it should stay that way. We have outlined some ways to keep your devices secure below.\\n\\n\\ni. Activate a unique PIN or password code to create a login. Make it personal and not easy for others to guess. Do not use your date of birth or your name, for example. If you share your device with others, activating a unique PIN or password code will ensure you are the only person who can access your Oky-related data on the device.\\n\\n\\nii. Set up a feature that will allow you to erase all the data from your device if it’s lost or stolen. For Android, download and set up Find My Device (formerly Android Device Manager) from the Google Play Store and, if needed, use the connected web interface to lock or wipe your phone remotely."},{"type":"CONTENT","content":"3. Third parties websites"},{"type":"CONTENT","content":"The Oky app or website may contain links to other sites that are not covered by this Privacy Policy. This Privacy Policy applies only to the processing of your information by Oky. It does not address, and we are not responsible for, the privacy, information, or other practices of any third parties, including any third party operating any site or service to which the Oky website or app links. \\n\\n\\n\\n\\n\\n The inclusion of a link on the Oky website or app does not imply endorsement of the linked site or service by UNICEF. Please be aware that the terms of this Privacy Policy do not apply to these outside websites or content, or to any collection of data after you click on links to such outside websites."},{"type":"CONTENT","content":"4. How long does Oky keep your data?"},{"type":"CONTENT","content":"We will only use and store information for so long as it is required for the purposes it was collected for, and as specified in UNICEF's retention policy. We use your data as necessary to comply with our legal obligations, resolve disputes, and enforce our agreements and rights, or if it is not technically and reasonably feasible to remove it. \\n\\n\\n\\n\\n\\nWe also retain the right to store your data with parties outside of UNICEF's direct control, such as with the servers or databases of a third-party organisation. "},{"type":"CONTENT","content":"5. How can you control your data?"},{"type":"CONTENT","content":"If you have registered an account with us, you can access most information associated with your account by logging in and using the account setting page. \\n\\n\\n\\n\\n\\nIf you want to delete your account and/or your contributed data, you can delete it from the app. Once you delete your account, all the data will be erased from our servers. "},{"type":"CONTENT","content":"6. Notifications of changes to the Privacy Policy"},{"type":"CONTENT","content":"We review our security measures and our Privacy Policy, and we may modify our policies as we deem appropriate.  If we make changes to our privacy practices, we will post a notification to the Oky website and app alerting you that the Privacy Policy has been amended.\\n\\n\\n\\n\\n\\nSuch changes will be effective immediately upon posting them to the Oky app and website. For this reason, we encourage you to check our Privacy Policy frequently. The 'Last updated' date at the bottom of this page indicates when this Privacy Policy was last revised.\\n\\n\\n\\n\\n\\nYour continued use of the Oky app and website  following these changes means that you accept the revised Privacy Policy."},{"type":"CONTENT","content":"7. Contact us"},{"type":"CONTENT","content":"Feel free to contact us if you require further information about this Privacy Policy. \\n\\n\\n\\n\\n\\nTo contact us please email hello@okyapp.info.\\n\\n\\n\\n\\n\\nLast updated 1st December 2021."}]	2025-07-29 15:58:24.125	en
5	[{"type":"HEADING","content":"Privacy Policy\\n\\n"},{"type":"CONTENT","content":"Taking care of your data is important to us. We aim for the highest standards of privacy and security and we are committed to being transparent about how we process and use your data. \\n\\nThis Privacy Policy explains how your data is collected, stored and used, and what steps we take to ensure your data stays safe.  \\n\\n\\nPlease read our Privacy Policy carefully before using Oky and refer back to it regularly to check for updates. Remember, by accessing and using the Oky app or Oky website, you agree to this Privacy Policy.\\nOky was developed and is owned by UNICEF. Please do not hesitate to contact us if you have any questions about the use of your data in Oky. To contact us, please email hello@okyapp.info.\\n\\nFor the purpose of this Privacy Policy, \\"personal data\\" means any information that enables us to identify an individual, directly or indirectly, by reference to an identifier such as name, identification number, location data, online identifier or one more factors specific to the individual."},{"type":"HEADING","content":"1. What information does Oky collect about you and how do we use it?"},{"type":"CONTENT","content":"When you enter information into the Oky app, Oky uses technology to turn that data into helpful information that can help you learn more about your menstrual cycle patterns to enable you to take control of your body and your health. \\n\\n Oky has been designed to minimize the use of your personal data. Described below are the sources and types of data we collect and process, as well as information on how we process such data. "},{"type":"HEADING","content":"Login information"},{"type":"CONTENT","content":"In order to use the period tracker functions on the app, you need to create a login. During login creation, we ask you for a display or user name, date of birth, gender and location (country and province only). We encourage you to select a display name that does not disclose your real name or other information that could identify you – especially if you are under the age of 18. We request this gender, age and location data from you to understand if we are reaching the right audiences; all of this data is aggregated and anonymised."},{"type":"HEADING","content":"Device data"},{"type":"CONTENT","content":"We collect information on the device you use to access Oky’s services, such as the model, operating system, language, location and the session’s duration. This data is anonymized and is collected to help us understand our users better and how they are engaging with Oky."},{"type":"HEADING","content":"Engagement data"},{"type":"CONTENT","content":"When you use the Oky app, we and our third-party service providers process engagement data about how you are interacting with the Oky app. This engagement is anonymized, meaning it does not identify you as an individual. We use an App centre together with some customer created tracking features to record these interactions.\\n\\nWe collect this information to understand your usage of our services, for example which functions of the Oky app you are using and to ensure all the features provided by the Oky app are  functioning properly. We also collect this information to communicate with you about the app and its services. "},{"type":"HEADING","content":"Health and menstruation data"},{"type":"CONTENT","content":"Your information about your health and menstruation that you enter in the calendar feature of the Oky app, such as dates of your past and current periods, is collected and used to predict your future period data. This information is stored on our servers so that you can can have access to that information whenever you log into your account from any device. However, to protect your privacy, we have set up a system where no-one can identify any one user from this stored data. \\n\\nThe information you enter in your day cards (body, mood, activity and flow, and your daily diary card) is stored locally on your device and only you have access to it."},{"type":"HEADING","content":"Surveys"},{"type":"CONTENT","content":"Oky may ask for your feedback about the Oky app through questions and surveys, e.g. on the performance of the app or on the usefulness of the information Oky provides and your experience of using the Oky app. Information given to you via such surveys and questions is processed by Oky to improve our services and your experience with Oky. Any survey responses are anonymous."},{"type":"HEADING","content":"Cookies"},{"type":"CONTENT","content":"Cookies, which are small text files which identify your computer, phone, and other devices to our server. \\n\\nThe Oky website uses Google Analytics, which can use cookies and similar technologies to collect and analyze information about your use of the website and report on activities and trends. You can learn more about Google's practices by going to www.google.com/policies/privacy/partners/.  The information collected through Google Analytics includes your IP address, network location, what browser you are using, device IDs and characteristics, operating system version, language preferences, referring URLs, and information about the usage of the Oky website.\\n\\nHowever, Google Analytics removes any and all personal information about Oky website users (such as IP addresses) before any analytics are shared with the Oky team, so all website analytics are anoymized and cannot be used to identify you or any individual. "},{"type":"HEADING","content":"Aggregate data"},{"type":"CONTENT","content":"We may aggregate information collected through the Oky app for statistical analysis and other lawful purpose, including in research studies intended to improve our understanding of young people's use of technology and digital tools. The results of this research may be shared with third parties, such as our partners, supporters, educators and researchers through conferences, journals and other publications."},{"type":"CONTENT","content":"If we do this, all data will be aggregated and anonymous. "},{"type":"HEADING","content":"Legal"},{"type":"CONTENT","content":"We may use your information to enforce our Terms of Use, to defend our legal rights, and to comply with our legal obligations and internal policies."},{"type":"HEADING","content":"2. How do we keep your data secure?"},{"type":"HEADING","content":"Health and sensitive data"},{"type":"CONTENT","content":"We use many reasonable measures - physical and electronic - to prevent unauthorised access and disclosure of your data. However, it is always a possibility that third parties may unlawfully intercept or access your data.\\nSo, although we work extremely hard to safeguard your data, we cannot guarantee that your data will always remain private.\\n\\n\\nThe security of our servers is regularly checked by experts to ensure your data is protected from unauthorised access. \\nThe following data is stored on our servers: your username, month and year of birth, gender, location (country and province), your period-related data, the menstrual cycle start and end data, and the theme, language and avatar you selected on the Oky app.\\nHowever, we have put a system in place so that no-one can identify any one user from this stored data. We store this data on our server so that you can access this data when you log into your account from different devices. \\n\\nYou can contact us with any questions you may have about data security via email: hello@okyapp.info."},{"type":"HEADING","content":"Recommendations for protecting your data"},{"type":"CONTENT","content":"We believe the biggest threat to the security and privacy of your data is if someone—probably someone you know—gains access to your device. The data you enter into Oky is private and it should stay that way. We have outlined some ways to keep your devices secure below.\\ni. Activate a unique PIN or password code to create a login. Make it personal and not easy for others to guess. Do not use your date of birth or your name, for example. If you share your device with others, activating a unique PIN or password code will ensure you are the only person who can access your Oky-related data on the device.\\nii. Set up a feature that will allow you to erase all the data from your device if it’s lost or stolen. For Android, download and set up Find My Device (formerly Android Device Manager) from the Google Play Store and, if needed, use the connected web interface to lock or wipe your phone remotely."},{"type":"HEADING","content":"3. Third parties websites"},{"type":"CONTENT","content":"The Oky app or website may contain links to other sites that are not covered by this Privacy Policy. This Privacy Policy applies only to the processing of your information by Oky. It does not address, and we are not responsible for, the privacy, information, or other practices of any third parties, including any third party operating any site or service to which the Oky website or app links. \\n The inclusion of a link on the Oky website or app does not imply endorsement of the linked site or service by UNICEF. Please be aware that the terms of this Privacy Policy do not apply to these outside websites or content, or to any collection of data after you click on links to such outside websites."},{"type":"HEADING","content":"4. How long does Oky keep your data?"},{"type":"CONTENT","content":"We will only use and store information for so long as it is required for the purposes it was collected for, and as specified in UNICEF's retention policy. We use your data as necessary to comply with our legal obligations, resolve disputes, and enforce our agreements and rights, or if it is not technically and reasonably feasible to remove it. \\nWe also retain the right to store your data with parties outside of UNICEF's direct control, such as with the servers or databases of a third-party organisation. "},{"type":"HEADING","content":"5. How can you control your data?"},{"type":"CONTENT","content":"If you have registered an account with us, you can access most information associated with your account by logging in and using the account setting page. \\nIf you want to delete your account and/or your contributed data, you can delete it from the app. Once you delete your account, all the data will be erased from our servers. "},{"type":"HEADING","content":"6. Notifications of changes to the Privacy Policy"},{"type":"CONTENT","content":"We review our security measures and our Privacy Policy, and we may modify our policies as we deem appropriate.  If we make changes to our privacy practices, we will post a notification to the Oky website and app alerting you that the Privacy Policy has been amended.\\nSuch changes will be effective immediately upon posting them to the Oky app and website. For this reason, we encourage you to check our Privacy Policy frequently. The 'Last updated' date at the bottom of this page indicates when this Privacy Policy was last revised.\\nYour continued use of the Oky app and website  following these changes means that you accept the revised Privacy Policy."},{"type":"HEADING","content":"7. Contact us"},{"type":"CONTENT","content":"Feel free to contact us if you require further information about this Privacy Policy. \\n\\nTo contact us please email hello@okyapp.info.\\nLast updated 1st December 2021."}]	2025-07-29 16:00:52.958	en
\.


--
-- Data for Name: question; Type: TABLE DATA; Schema: periodtracker; Owner: periodtracker
--

COPY periodtracker.question (id, question, option1, option2, option3, option4, option5, response, is_multiple, next_question, sort_number, "surveyId") FROM stdin;
bb43c90d-5146-4392-bff3-08c4688acb73	How long have you been using Oky?	More than 3 months	1-3 months	1-4 weeks	Less than 1 week	I don't want to say\t		t	{"option1":"2","option2":"2","option3":"2","option4":"2","option5":"2"}	0	4e6d7047-11ad-4522-a61a-42941ce8cb8b
82a4b985-cf6e-4a9c-be99-09a8115b91e1	In that time, have you learned any new information from Oky?	Yes	No	I don't want to say	NA	NA		t	{"option1":"","option2":"","option3":"","option4":"","option5":""}	1	4e6d7047-11ad-4522-a61a-42941ce8cb8b
\.


--
-- Data for Name: quiz; Type: TABLE DATA; Schema: periodtracker; Owner: periodtracker
--

COPY periodtracker.quiz (id, topic, question, option1, option2, option3, right_answer, wrong_answer_response, right_answer_response, "isAgeRestricted", live, date_created, lang, "ageRestrictionLevel", "contentFilter") FROM stdin;
a085f7e6-627c-4f01-a25a-0cd6456c5ee4	Boys, men and relationships	Sex and gender are the same thing.❓	True	False	NA	2	It was false! Sex is determined by our biology but gender is how we express ourselves.💃	That's right, sex is determined by our biology but gender is how we express ourselves.💃	f	f	2025-07-31 12:55:31.643989	en	\N	\N
5e21542c-0dce-45ea-821b-2decfa97c273	Boys, men and relationships	Why do boys tease girls during their periods? 😠	It's their right.	They are confused	They are mean.	2	Incorrect! Boys, like girls, aren't given enough information about periods which can make them feel confused. 😳	Right answer! Boys, like girls, aren't given enough information about periods which can make them feel confused. 😳	f	f	2025-07-31 12:55:53.503324	en	\N	\N
f0bf17d6-391d-4ea8-a3f2-3051d6f89573	Boys, men and relationships	A good friend should never make you feel...🌹	judged.	respected.	Happy.	1	Wrong answer! A good friend should make you feel happy and NEVER make you feel judged! 💖	Yesss! A good friend should make you feel happy and NEVER make you feel judged! 💖	f	f	2025-07-31 12:56:15.593098	en	\N	\N
aeaf3a0d-37f7-44de-a1eb-8ea2b90462a1	Boys, men and relationships	Crushes are always romantic. 😍	True	False	NA	2	Wrong answer! crushes just mean having intense feelings for a short time. This can happen between friends too! 😊	Correct — crushes just mean having intense feelings for a short time. This can happen between friends too! 😊	f	f	2025-07-31 12:56:37.643932	en	\N	\N
c0e3fc55-8388-439e-b014-255054e6495b	Boys, men and relationships	What is a sign someone might like you? 😘	They tease you.	They look at you.	They ignore you.	2	Woops, incorrect! The answer was 'they look at you.' But the only way to know for sure is to ask them! 😜	That's right! If someone looks at you a lot, they might like you. But you can only find out by asking them! 😜	f	f	2025-07-31 12:56:59.510039	en	\N	\N
edb82221-30a2-461a-83f1-c440780fa4b6	Boys, men and relationships	Boys can get periods.	True	False	NA	2	No, sorry! Boys cannot get periods because their bodies are different to girls'! 👫	Right! Boys cannot get periods because their bodies are different to girls'! 👫	f	f	2025-07-31 12:57:21.68374	en	\N	\N
0120337f-0257-47e7-9b3b-065bb49cc2bd	Boys, men and relationships	The best way to be a good friend is to always give your advice	True	False	NA	2	Wrong! People don't always want advice. It's more important to listen 👂🏼, ask what your friend needs, and show you care.	You're right! More important than giving advice is listening 👂🏼, asking what your friend needs, and showing you care.	f	f	2025-07-31 12:57:43.846992	en	\N	\N
a3ffda5b-b282-48ea-b236-6ae286174dbf	Family planning	You only need one person's consent to have sex. 😨	True	False	NA	2	It was false! ❌ Both you and your partner should ask for and give consent, even if you've said 'yes' before.	Yes! ✅ Both you and your partner should ask for and give consent, even if you've said 'yes' before.	f	f	2025-07-31 12:58:06.218219	en	\N	\N
9fc8c0bc-ed11-4417-952a-b22e582db671	Family planning	You can get pregnant even if you have never had a period. 😳	True	False	NA	1	It's actually true! 😲 Even if you've not started your period yet, your body might have released an egg which could be fertilized.	Yes, it's true! 😲 Even if you've not started your period yet, your body might have released an egg which could be fertilized.	f	f	2025-07-31 12:58:28.568664	en	\N	\N
cd4b5f85-5e2a-4445-9862-6f19ed6929a6	Family planning	A baby is created when a sperm joins an egg. 👶	True	False	NA	1	It's actually true! When a guy ejaculates during sex, he releases millions of sperm into the vagina, which swim towards the fallopian tubes to find an egg. 😮	That's right! When a guy ejaculates during sex, he releases millions of sperm into the vagina, which swim towards the fallopian tubes to find an egg. 😮	f	f	2025-07-31 12:58:51.011581	en	\N	\N
34bd4023-6df8-46a2-af4a-bce037d8e27b	Family planning	You and your partner should ask for consent ___ sexual activity❓	before	after	during	1	Sorry, the answer was BEFORE. You should always have the chance to say yes or no BEFORE sexual activity (but late is better than never!).👍🏽	You got it! You should always have the chance to say yes or no BEFORE sexual activity (but late is better than never!). 👍🏽	f	f	2025-07-31 12:59:13.320553	en	\N	\N
efbe0a44-a068-4b67-b6a3-acdff75f958c	Family Planning	Where are eggs fertilized by sperm? ⭐️	The vagina.	The womb.	The fallopian tubes.	3	Incorrect! An egg is fertilized by sperm in the fallopian tube. Then it travels down to the womb and grows into a baby there. 👶	Well done! An egg is fertilized by sperm in the fallopian tube. Then it travels down to the womb and grows into a baby. 👶	f	f	2025-07-31 12:59:36.035476	en	\N	\N
55462ee3-afb1-469f-ae7b-8d6d070f6778	Family Planning	Pregnancy starts as soon as sperm fertilizes an egg. 😅	True	False	NA	2	Wrong answer! A fertilized egg must implant itself into the wall of the womb for you to be pregnant. 😋	You're right! Pregnancy only starts after the fertilized egg travels to the womb and implants itself there. 😊	f	f	2025-07-31 12:59:58.810946	en	\N	\N
4def955f-fe3c-415a-bf89-a2200192b9c0	Family Planning	When is it OK to have sex during your period? 👩‍❤️‍👨	It's always OK.	Both partners are OK	if you say a prayer	2	Nope! There's nothing wrong with having sex during your period. 🔴 You can still get pregnant or an STI, so use contraception!	Exactly right — there's nothing wrong with having sex during your period. 🔴 You can still get pregnant or an STI, so use contraception!	f	f	2025-07-31 13:00:21.59087	en	\N	\N
fac9d738-9a97-47e1-8496-10441d2cc29e	Family Planning	Girls' fertile days are in the middle of their cycle. 📆	True	False	NA	2	It was false! Your fertile days depend on the length of your cycle — everyone is different. 💫	You're right, it was false! 💫 Your fertile days depend on the length of your cycle — everyone is different.	f	f	2025-07-31 13:00:44.643285	en	\N	\N
948f3912-b526-47e1-bf63-284c2fee95d3	Health, nutrition and exercise	It's normal to want to change things about your body. 👗	True	False	NA	1	Woops, incorrect! It's normal to want to change things — but that doesn't mean you should! Focus on loving the bits you like, not hating the bits you don't. 😍	Correct! It's totally normal — but that doesn't mean you should! Focus on loving the bits you like, not hating the bits you don't. 😍	f	f	2025-07-31 13:01:07.490939	en	\N	\N
bf86c68d-d249-4267-84b0-3641dc8443e3	Health, nutrition and exercise	What body type makes it hard to lose weight? 😒	Ectomorph	Endomorph	NA	2	Incorrect! Endomorphs have more muscles and fat while ectomorphs are slim with small muscles. 🏃	That's right! Endomorphs have more muscles and fat while ectomorphs are slim with small muscles. 🏃	f	f	2025-07-31 13:01:30.477155	en	\N	\N
ae915d20-4a5f-4189-a3ba-b4e2c0b584be	Boys, men and relationships	You should change yourself to make someone love you.💄	True	False	NA	2	Incorrect — never change to make someone fall in love with you. You should only be with someone who loves you the way you are. 💞	That's right — never change to make someone fall in love with you. You should only be with someone who loves you the way you are. 💞	f	f	2025-07-31 12:55:10.103179	en	\N	\N
609fffb2-df1f-40ee-8578-242a605d6ab1	Health, nutrition and exercise	Dizziness during your period is not normal.😵	True	False	NA	2	Not true! Dizziness, weakness and excessive tiredness could be a sign of an iron deficiency, and you should see a doctor. 😔	That's right! Dizziness, weakness and excessive tiredness could be a sign of an iron deficiency, and you should see a doctor. 😔	f	f	2025-07-31 13:01:53.683605	en	\N	\N
d9bce73f-545d-4276-8157-93c0bcac7506	Health, nutrition and exercise	Eating certain foods can change the smell of your period blood 🍛	True	False	NA	2	Incorrect! Nothing you eat will affect the smell of your period blood, so eat what you like! 😋	Correct! Nothing you eat will affect the smell of your period blood, so eat what you like! 😋	f	f	2025-07-31 13:02:16.608733	en	\N	\N
bf1a5183-1988-49e9-87ad-9763a88f7d01	Health, Nutrition and Exercise	Why does being active soothe period cramps? 💛	It doesn't.	Clears your mind	Increases blood flow	3	Wrong this time! Being active increases the flow of blood, including to painful areas, and this can help reduce cramps. 😀	You got it! Being active increases the flow of blood, including to painful areas, and this can help reduce cramps. 😀	f	f	2025-07-31 13:02:39.855774	en	\N	\N
2f08f0cd-829c-41a0-a397-163b3bfa7875	Managing menstruation	What is the right way to wash during your period? 💦	You should not wash	Outside of your body	Inside your vagina	2	Nope! Never wash inside your vagina as this can cause an infection — just wash the outside of your body. 🚿	You're right! Never wash inside your vagina as this can cause an infection — just wash the outside of your body. 🚿	f	f	2025-07-31 13:03:03.088193	en	\N	\N
e321f572-ce35-42d5-a7f9-b36b67719640	Managing menstruation	What causes menstrual cramps? 😖	Chemicals.	Bad food.	Nobody knows.	1	Oops, that's not right! Chemicals called prostaglandins cause cramps, which help push the womb lining out. ⬇️	That's right! Chemicals called prostaglandins cause cramps, which help push the womb lining out. ⬇️	f	f	2025-07-31 13:03:26.197397	en	\N	\N
7006a3ad-d245-4749-877b-ddc00bcac61f	Managing menstruation	You should only use a tampon if you are not a virgin. 😏	True	False	NA	2	Incorrect! Anyone can use a tampon — your hymen usually stretches to let the tampon pass through. 👍	Correct! Anyone can use a tampon — your hymen usually stretches to let the tampon pass through. 👍	f	f	2025-07-31 13:03:49.678921	en	\N	\N
91b56496-38de-4a24-9294-ec03a76d78e5	Menstruation and menstrual cycle	If your period doesn't come, you are definitely pregnant. 😨	True	False	NA	2	False! Stress, extreme tiredness or poor nutrition can also make you miss your period. 😫	That's right! Stress, extreme tiredness or poor nutrition can also make you miss your period. 😫	f	f	2025-07-31 13:04:13.165015	en	\N	\N
c562d6f5-3a0a-4088-90ce-ac277b210f0f	Menstruation and menstrual cycle	How many hours do eggs live after ovulation? ⏳	2–4	12–24	36–72	2	Incorrect! Eggs live for 12–24 hours after release. If they're not fertilized within that time, they dissolve (or break down). ⏰	You got it! 😊 Eggs live for 12–24 hours after release. If they're not fertilized within that time, they dissolve (or break down).	f	f	2025-07-31 13:04:36.676093	en	\N	\N
d3ca83f8-bed6-4994-8d65-5abb5ffb5be0	Menstruation and menstrual cycle	How many parts does the menstrual cycle have? 🕓	2	3	5	1	Wrong answer — your cycle has 2 parts: before ovulation, and after ovulation. 😯	Correct! 👍 Your cycle has 2 parts: before ovulation and after ovulation.	f	f	2025-07-31 13:05:00.138173	en	\N	\N
4f06eab9-ab77-4af2-ba21-5b53d65cf869	Menstruation and menstrual cycle	A bit of blood between periods (called spotting) is normal. 🔴	True	False	NA	1	Woops, wrong answer.😋 It's nothing to worry about, unless you bleed a lot or experience dizziness or pain.	That's right! 👍 It's nothing to worry about, unless you bleed a lot or experience dizziness or pain.	f	f	2025-07-31 13:05:23.891029	en	\N	\N
c8d2620e-79e0-42b3-bfbd-553ecc000e30	Menstruation and menstrual cycle	How many days are there in a menstrual cycle? 🗓	Between 15–20.	28 exactly.	Between 21–35.	3	Sorry! It's usually between 21–35 days, but it's different for every girl. 👑	Correct! It's usually between 21–35 days, but it's different for every girl. 👑	f	f	2025-07-31 13:05:47.778748	en	\N	\N
21dc4867-4edb-4ddf-9816-d8ef3383f4b9	Menstruation and menstrual cycle	If period blood is brown or black, something's wrong. 😰	True	False	n/a	2	Oops, it's false! Period blood can be pink-ish, red, brown, or almost black! 👍	You're right, it's false! Period blood can be pink-ish, red, brown, or almost black! 👍	f	f	2025-07-31 13:06:11.883543	en	\N	\N
a6eea705-cd1e-4056-8401-1f1caff85a7e	Mental health	Anxiety means you often feel really...😖	Angry.	Worried.	NA	2	Not quite! It's normal to feel worried sometimes, but if you're worried a lot of the time, consider talking to someone about it. 😫	Rrrright! It's normal to feel worried sometimes, but if you're worried a lot of the time, consider talking to someone about it. 😫	f	f	2025-07-31 13:06:35.823913	en	\N	\N
7eabacea-3933-4aa7-896a-664df9bfb6a3	Mental health	If you feel sad now and again, you've got depression. 😭	True	False	NA	2	Wrong answer — depression is feeling sad and hopeless non-stop for at least 2 weeks, not just now and again. 😞	Right — depression is feeling sad and hopeless non-stop for at least 2 weeks, not just now and again. 😞	f	f	2025-07-31 13:06:59.828896	en	\N	\N
1c2b0afd-b54e-49c1-b36f-79332c0a6764	My rights	It's a child's right to play and have spare time. 👧	True	False	NA	1	It was true! Believe it or not, having time to play is one of the Rights of the Child. ⚽️	Wow, you got it right! Having time to play is one of the Rights of the Child. ⚽️	f	f	2025-07-31 13:07:23.900897	en	\N	\N
457427cc-05a4-4a56-a38d-d857b1541f94	My rights	In 1948, nations signed the Declaration of Human...📝	Rights.	Fights.	NA	1	No, it's Human Rights! Members who signed it all agreed to respect, protect, and fulfil the rights listed in it.🔏	Woo, correct! Members who signed it all agreed to respect, protect, and fulfil the rights in it. 🔏	f	f	2025-07-31 13:07:48.075645	en	\N	\N
fe092177-2268-4ee7-89ca-b1671a441be1	Myths and Feelings	If you are moody, writing how you feel can help. 📝	True	False	NA	1	Woops, incorrect! Writing can give you perspective and calm you down. You can also exercise, eat, and sleep well. 💙	That's right — writing can give you perspective and calm you down. You can also exercise, eat, and sleep well. 💙	f	f	2025-08-01 08:40:02.876086	en	\N	\N
130ae34d-2b57-4799-8600-e7e73e6952cf	Myths and feelings	What should girls avoid during their period? 😳	Exercise	Cooking	Nothing	3	Not quite right! Girls can do anything they feel like when they have their period! 💪	Bravo! Girls can do anything they feel like when they have their period! 💪	f	f	2025-08-01 08:39:43.113462	en	\N	\N
5eb56dd3-4502-4692-b116-4e82a3f41f4d	Myths and Feelings	Why do teenagers get moody? 😤	Hormones	Growing up	Both	3	Not quite! Teenagers are affected by changing hormones and are also learning to cope with life. 😣	You got it! Teenagers are affected by changing hormones and are also learning to cope with life. 😣	f	f	2025-08-01 08:40:22.860639	en	\N	\N
546d3910-ddde-4b09-b374-cde787cb9a45	Myths and Feelings	What could be a sign of depression?	Risky behaviour	Moody	NA	1	Sorry, that's not right. Being moody or sad sometimes is normal, but if you find yourself taking risks, or feel sad or moody most of the time, talk to someone	That's right — being moody or sad sometimes is normal, but if you find yourself taking risks, or you feel sad or moody most of the time, talk to someone! 😓	f	f	2025-08-01 08:40:42.782787	en	\N	\N
55d179cc-3e94-4e4a-b7cc-604e7058df10	Periods and Life	What are spots caused by? 😠	Oil and dead skin.	Heat.	Negative thoughts.	1	Wrong! The tiny holes in our skin (called pores) can be blocked by oil and dead skin, which causes inflammation. Washing daily with gentle soap can help. 💦	Right! The tiny holes in our skin (called pores) can be blocked by oil and dead skin, which causes inflammation. Washing daily with gentle soap can help. 💦	f	f	2025-08-01 08:41:02.545047	en	\N	\N
4f9807ed-f0f6-4f5d-ac4d-037523eeeb85	Periods & life	Hormones cause oily skin. 😓	True	False	NA	1	Wrong answer, it was true! During puberty, hormones can increase the oil in your skin which can cause pimples. 😵	Correct! During puberty, hormones can increase the oil in your skin which can cause pimples. 😵	f	f	2025-08-01 08:41:22.306833	en	\N	\N
fb194b48-69b1-464d-abcc-4cd748aa6358	Puberty	A girl's hymen can be torn even if she is a virgin. 🚺	True	False	NA	1	That's right — your hymen can be torn during exercise even if you've never had sex. Checking girls' hymens as a sign of virginity is not reliable!❌	Incorrect. Your hymen can be torn during exercise even if you've never had sex. Checking girls' hymens as a sign of virginity is not reliable!❌	f	f	2025-08-01 08:43:20.76054	en	\N	\N
9d4b5326-67a0-4839-b885-be3c1d1b2889	Violence and staying safe	If you're under 18, sharing naked photos of yourself is illegal🔞	True	False	NA	1	No, it's illegal! If you're a minor, sharing a naked picture is child pornography. You and the person receiving it could get in serious trouble. 🚨	Yep — if you're a minor, sharing a naked picture is child pornography. You and the person receiving it could get in serious trouble.🚨	f	f	2025-08-01 08:44:39.353952	en	\N	\N
d758612a-ae5e-406c-8b1b-01c22216e031	Violence and staying safe	If a guy touches you and you say no, that's called sexual	harassment	assault	NA	2	No - it's sexual assault.🚫 Sexual harassment usually involves words, gestures or looks that continue even after you've asked them to stop.	100% right 💯 no one has the right to touch your private parts unless you say that it's OK. If they do despite you saying NO, it's sexual abuse or assault.	f	f	2025-08-01 08:44:19.711205	en	\N	\N
02121d37-85b6-4696-bc80-b4f4258ac705	Puberty	Which one of these is a sign of puberty in boys? 🚶	Clumsiness.	Deep voice.	Nose growth.	2	Sorry, the correct answer was 'deep voice'. Boys also get hair on their genitals, chest, face and underarms, and grow taller during puberty. 😱	Correct! Boys also get hair on their genitals, chest, face and underarms, and grow taller during puberty. 😱	f	f	2025-08-01 08:43:00.976386	en	\N	\N
ebad12ff-0a2a-402d-8448-37ff386a2d79	Puberty	Puberty and adolescence are the same thing.	True	False	NA	2	The answer was false! Puberty is when a young person's body goes through physical changes. Adolescence is the whole journey to becoming an adult.	You're right, it was false! Puberty is when a young person's body goes through physical changes. Adolescence is the whole journey to becoming an adult.	f	f	2025-08-01 08:43:40.435317	en	\N	\N
c902a51f-c1d6-4adc-bafc-743c23386884	Puberty	Usually, boys reach puberty before girls. 👀	True	False	NA	2	Incorrect this time! Boys usually reach puberty 1–2 years after girls. 👦	That's right! Boys usually reach puberty 1–2 years after girls. 👦	f	f	2025-08-01 08:44:00.174912	en	\N	\N
fad772b4-c89e-4d95-91b3-e38e1eb255ed	Puberty	What age do boys start puberty? 👦🏽	45944	45910	13 - 16	2	Oops, that's incorrect! Puberty for boys usually starts between the ages of 10-14. That's a little later than for girls, where puberty can start from age 9!	That's right, puberty for boys usually starts between the ages of 10-14. That's a little later than for girls, where puberty can start from age 9!	f	f	2025-08-01 08:42:41.002417	en	\N	\N
abc9e24f-a297-4922-b92b-2c03ad204106	Personal identity	Other people can tell if you're gay. 😳	True	False	NA	2	Incorrect — it's impossible to tell if someone else is gay. Only you know if you're gay, and you can tell others when YOU feel ready. 💜	That's right — only you know if you're gay, and you can tell others when YOU feel ready. 💜	f	f	2025-08-01 08:42:01.577944	en	\N	\N
ce8dee6c-9251-4663-afde-901bedc58f30	Personal identity	Being bisexual makes you ___ likely to cheat. 😲	More.	Less.	As.	3	That's a myth! Just because you CAN be attracted to both guys and girls, doesn't mean you WILL be. 😬	Well done! Just because you CAN be attracted to both guys and girls, doesn't mean you WILL be. 😬	f	f	2025-08-01 08:42:21.255323	en	\N	\N
bd4e6a91-1fa4-4f89-821e-ea76529e8f7a	Periods & Life	If you have acne, you will have it for life. 😒	True	False	NA	2	You're right — acne often disappears with time. 😊 It can leave scars, so don't squeeze your pimples as this can make it worse!	Incorrect! Acne often disappears with time. 😊 It can leave scars, so don't squeeze your pimples as this can make it worse!	f	f	2025-08-01 08:41:42.020033	en	\N	\N
73cff6b2-cc0d-4bde-9c10-22a4439490b5	Myths and feelings	How can girls prepare for their first period? 😨	2 pairs of underwear	Talk to other girls	Don't think about it	2	Nope — your first period can be a shock, but it helps to talk to friends or family who've been there before. You're not alone! 💖	Right — your first period can be a shock, but it helps to talk to friends or family who've been there before. You're not alone! 💖	f	f	2025-08-01 08:39:23.417088	en	\N	\N
\.


--
-- Data for Name: subcategory; Type: TABLE DATA; Schema: periodtracker; Owner: periodtracker
--

COPY periodtracker.subcategory (id, title, parent_category, lang, "sortingKey") FROM stdin;
b624dbd2-08c5-4964-90d6-9013763d4ace	Skin	02bca300-9373-442d-a83e-750cc15fc4c5	en	1
6e2b0c3c-dc46-4302-aed8-fb4d47a261c7	Beauty and fashion	02bca300-9373-442d-a83e-750cc15fc4c5	en	2
9b4dc44d-2c21-41c8-aee3-d2b4a9859051	School preparation and management	02bca300-9373-442d-a83e-750cc15fc4c5	en	3
b6d44932-7b7e-42f0-883a-a7837fd2f350	Encouragement	02bca300-9373-442d-a83e-750cc15fc4c5	en	4
b72d0f33-d66a-4d04-a5ba-17bb2393793d	Menstruation and periods	c969a7ed-eef0-44f5-b2ef-6030750127b2	en	5
18b34e1b-0099-44a5-8350-206f99f6f790	Irregularity and missed periods	c969a7ed-eef0-44f5-b2ef-6030750127b2	en	6
231e5464-ba8f-4345-a998-76c4703ef0d1	Blood, flow and discharge	c969a7ed-eef0-44f5-b2ef-6030750127b2	en	7
7b08c075-443d-4f2a-9ecf-608eeca2ce9b	Managing Periods with a Disability	75906d2a-2ddd-4cbd-98e1-680a74e2ba6e	en	8
6c5ab8e0-846c-462f-a691-674a9cdb5351	Pain and PMS	75906d2a-2ddd-4cbd-98e1-680a74e2ba6e	en	9
37ba42f6-3ae8-4691-988a-19270a6bff71	Sanitary protection	75906d2a-2ddd-4cbd-98e1-680a74e2ba6e	en	10
6e52a12e-15e0-4064-ac71-f2b02c73461a	Hygiene	75906d2a-2ddd-4cbd-98e1-680a74e2ba6e	en	11
0bde49a2-29d5-47ff-afa3-9f1163f035e3	Puberty	fb535db0-9923-44d1-ae66-9d51d82ea4e8	en	12
8c490219-979d-48ed-826e-10342e8acafd	Relationships	0dcbc24b-d285-494a-90bd-dfac51e59271	en	13
0e3ba89c-d7e7-4c98-8d87-0471809f9cd0	Gender	0dcbc24b-d285-494a-90bd-dfac51e59271	en	14
b2ffe457-2c2a-4805-83ec-1f87589e104d	Boys and men	0dcbc24b-d285-494a-90bd-dfac51e59271	en	15
32d75062-13d0-44fc-967d-2fc394432941	Sleep	879ff9ec-f959-43a9-8c87-03e99e3508f7	en	16
21b7aa97-2f95-4ea5-b18f-d45a66deb8ed	Bodies and weight	879ff9ec-f959-43a9-8c87-03e99e3508f7	en	17
057b788e-0006-4ef9-86e9-8d3d73c720ae	Exercise	879ff9ec-f959-43a9-8c87-03e99e3508f7	en	18
c3b09e95-26e2-41a0-a0dd-06ade60ed16c	Nutrition and diet	879ff9ec-f959-43a9-8c87-03e99e3508f7	en	19
2fa638f2-8895-4d00-89c7-440222388ecb	Contraception	0e28b0c3-186c-4d67-89b7-c95dfc8d3588	en	20
a3f92b34-2a59-4f0f-b350-8196982d507b	Pregnancy	0e28b0c3-186c-4d67-89b7-c95dfc8d3588	en	21
fff010bc-4984-4ac0-8d51-ee0f87477c79	Fertility	0e28b0c3-186c-4d67-89b7-c95dfc8d3588	en	22
44a9ea5f-3bbf-40f8-be7c-51e91cc4b4a6	Sex	0e28b0c3-186c-4d67-89b7-c95dfc8d3588	en	23
818634d4-a9d3-43e7-ab12-a0ac304df6c7	Feelings	2d155a96-49c4-45a6-aafa-6aaa751f626e	en	25
f92cb7e1-a83f-42c5-8512-fc4e20fa860f	Myths	2d155a96-49c4-45a6-aafa-6aaa751f626e	en	26
3075567d-4339-437b-8958-90deeda3a31c	Shame	2d155a96-49c4-45a6-aafa-6aaa751f626e	en	27
f0e2ddb7-63ef-449e-8e69-73bf42c78067	Fear	2d155a96-49c4-45a6-aafa-6aaa751f626e	en	28
6084fe8a-779d-4a50-bb12-fb8939e206ac	Facts and myths	e066f374-ef39-4d50-9331-2d2cd7cffca7	en	29
2498c331-e4aa-4b63-a6fe-93078492658c	Overview and symptoms	e066f374-ef39-4d50-9331-2d2cd7cffca7	en	30
cee1e653-43d0-4c4c-aa68-c4540120ac76	Protecting yourself and others	e066f374-ef39-4d50-9331-2d2cd7cffca7	en	31
7038ad9a-3c33-4f0d-9c52-1634061f7766	Keeping your information safe	ce454a41-a733-4c38-972e-c8d0e99837e4	en	34
2970f50e-9952-466e-a270-2ed9e608e94f	Your questions about Oky	ce454a41-a733-4c38-972e-c8d0e99837e4	en	35
33b1dde0-4a7e-4d6b-8d06-f6df1b6c1729	Your Oky account	ce454a41-a733-4c38-972e-c8d0e99837e4	en	36
ae09565b-06cd-47e8-bac1-11f15181fd35	Gender identity	afc705f3-c602-43cd-be03-b82831bd4900	en	37
989a9df6-cb62-442b-afeb-9dea2e291e55	Sexual orientation	afc705f3-c602-43cd-be03-b82831bd4900	en	38
7294d855-a5a8-4cec-bb81-bd7d096e5790	Physical violence	43a40940-1d38-4c6b-930e-aec7e7b01011	en	39
4c423f29-cdcd-4cf3-9051-289d52e9a68f	Sexual harassment	43a40940-1d38-4c6b-930e-aec7e7b01011	en	40
c5003e77-255d-4b82-affa-8879683f4d7c	Sexual abuse	43a40940-1d38-4c6b-930e-aec7e7b01011	en	41
03a3a07a-c690-4c99-8d3e-4c8bad963674	Child marriage	dd43195b-732c-4407-aed3-e340a5902814	en	42
876f27c1-a6d8-4301-bccd-4bcbf06bb32a	My human rights	dd43195b-732c-4407-aed3-e340a5902814	en	43
496c34eb-568a-43f8-b1ad-17866b17bbcc	Mental health concerns	17c1809a-01bc-46fe-a26c-9970e8700df7	en	44
c9aff1d2-3c1f-4afb-8350-8801b342a996	Law & Policies	d2dafb9e-ee3a-421b-8363-8c267b67ed08	en	45
055593e4-bd7a-4a2a-848d-c32a25e83227	Ask help	48165873-6517-4c03-a53d-4c99f01366ba	en	46
e7fa11a0-5bb7-4d0f-92a3-3657347d29ce	Contact	48165873-6517-4c03-a53d-4c99f01366ba	en	47
e20339e5-caf2-49b3-b39c-0537221fdb6d	Source	fff4b357-c0b8-42b0-b414-d0b137f55722	en	48
\.


--
-- Data for Name: suggestion; Type: TABLE DATA; Schema: periodtracker; Owner: periodtracker
--

COPY periodtracker.suggestion (id, name, "dateRec", organization, platform, reason, email, status, content, lang) FROM stdin;
\.


--
-- Data for Name: survey; Type: TABLE DATA; Schema: periodtracker; Owner: periodtracker
--

COPY periodtracker.survey (id, question, option1, option2, option3, option4, option5, response, live, date_created, lang, "isAgeRestricted", is_multiple, "ageRestrictionLevel", "contentFilter") FROM stdin;
4e6d7047-11ad-4522-a61a-42941ce8cb8b								f	2025-07-29 16:15:25.960662	en	f	t	\N	\N
\.


--
-- Data for Name: terms_and_conditions; Type: TABLE DATA; Schema: periodtracker; Owner: periodtracker
--

COPY periodtracker.terms_and_conditions (id, json_dump, "timestamp", lang) FROM stdin;
1	[{"type":"HEADING","content":"Oky Terms and Conditions"},{"type":"HEADING","content":"User agreement"},{"type":"CONTENT","content":"These Terms of Use are an agreement between you and Oky that set the rules for your interactions with the Oky app and website.\\n\\nOky is a period tracker app for girls and created with girls. It provides information about menstruation in fun, creative and positive ways. Please read these Terms of Use carefully. By using the Oky app, you agree that you have read, understood, and accepted the terms and conditions contained below. If you do not agree to any of these terms and conditions, please do not use the Oky app.\\n\\nOky is targeted at young people from ages 10 and older. If you are under 16 years old, we encourage you to discuss your use and engagememnt on the Oky app with your parents or guardians and make sure that they consent to your use of the Oky app.\\n\\nThese Terms of Use are subject to change, so please make sure you check out the Oky Terms of Use on the app or on the website from time to time. The date of the most recent revisions will appear at the bottom of this page. If you continue to use the Oky app, this means that you accept any changes to or revisions of these Terms of Use.\\nYour privacy is very important to us – please also read our Privacy Policy, which will walk you through how the Oky app collects, stores, and uses the information that you provide to us. By using the Oky app, you are confirming to us that you are agreeing to our Privacy Policy."},{"type":"HEADING","content":"Account creation and security"},{"type":"CONTENT","content":"In order for you to use the period tracker functions on the Oky app, you will need to register on the Oky app and create an account. Creating an account is optional but doing so will allow you to track your periods and other health information on the day cards (such as body, mood, activity and flow, and your daily diary card). If you do not create an account, you will still have access to Oky’s information in the encyclopaedia.\\n\\nDuring account creation, we ask you to create a username or display name, indicate your month and year of birth, your gender and location (country and province only). We encourage you to create a username or display name that is not your real name or discloses your real name or other information that could identify you – especially if you are under the age of 18 years.\\nOnce you create your account, you will be required to select a secret question and provide an answer. Please keep this information safe since it is the only way to access your account if you forget your password.\\n\\nOnce you create your account you can edit your username or display name by choosing a different one, change your password or change your secret question and password.\\n\\nTo see how we handle your personal information, please see our Privacy Policy.\\nYou are responsible for keeping your password, secret question and answer secret and your account secure. You are responsible for all uses of your account, even if your account is used by someone else. You may not use another person’s Oky account without their permission.\\n\\nIf you have any reason to believe that your account is no longer secure – if your password has been stolen, for instance – you should change your password as soon as possible. If you forget your password, you will be prompted to input your secret answer in order to access your account.\\nIf you have forgotten your secret question and answer, you will have several opportunities to try, however, if you cannot remember, you will have to create a new account to continue using the Oky app. If you create a new account, kindly note that you will not be able to retrieve your previous information associated with your other account.\\n\\nOky does not have access to your account and cannot change, retrieve or reset passwords or secret questions for its users."},{"type":"HEADING","content":"Rules of usage"},{"type":"CONTENT","content":"Oky is an app that is open to and welcomes young people from around the world. Due to the diversity of our users, Oky aims to create an environment where any young person feels comfortable, no matter their nationality, gender, cultural background, religion, sexual orientation or political conviction.Oky’s core values are positivity, openness, respect, inclusiveness, dialogue, collaboration and constructiveness.You agree to comply with all applicable laws and regulations in your country when you use the Oky app.Content"},{"type":"HEADING","content":"Content"},{"type":"CONTENT","content":"Oky is a way to monitor and learn about your menstrual cycle, as well as provide information about your period and female health. The service is provided for free for personal and private use. Everything on the Oky app is for you and your peers but not for commercial use.Please do not use the Oky app for contraceptive or medical purposes. In case of any individual health issues, consult a medical professional.Oky is not intended to replace contraceptive measures and/or medical advice: it is only intended to provide information. By using the Oky app you agree to use it for the intended purpose only and particularly not for contraception and/or medical purposes.\\nExcept for any user-generated content, Oky owns and retains all rights in and to the Oky code, the design, functionality, and architecture of the Oky app, and any software, support materials or content provided through this site (collectively the “Oky IP”). Except for any rights explicitly granted under these Terms of Use, you are not granted any rights in and to any Oky IP. If you want to use Oky IP in a way that is not allowed by these Terms of Use, you must first contact the Oky team and get permission.\\n\\nUnless we say otherwise, all the materials provided by Oky on the app and website are licensed under the Creative Commons license: Attribution 4.0 International (CC BY 4.0). This license allows you and others to copy and redistribute the content on Oky app. This license requires you to attribute any material you use to the original author. When you use any of Oky materials, please use the following attribution: “Oky is developed by the United Nations Children’s Fund. See http://www.okyapp.info”. If you still have questions, please feel free to visit the Creative Commons FAQ page, where you will find more information.\\nPlease note that the Oky app and the Oky support materials may contain images, sounds and videos that are trademarked by third parties. Nothing in these Terms of Use or the Creative Commons license limits or reduces a third party’s intellectual property rights. You may not use these materials to label, promote, or endorse any product or service. You are solely responsible for any violation of a third party’s intellectual property rights caused by your misuse of these materials.\\n\\nOky, the Oky app and UNICEF names and emblems/logos are the exclusive property of UNICEF. They are protected under international and national laws. Unauthorized use is prohibited. They may not be copied or reproduced in any way without the prior written permission of UNICEF. Requests for permission should be sent to us at hello@okyapp.info."},{"type":"HEADING","content":"Changes to Terms and Conditions"},{"type":"CONTENT","content":"UNICEF amends these terms from time to time. Every time you wish to use Oky, please check these terms to ensure you understand the terms that apply at that time."},{"type":"HEADING","content":"External links and resources"},{"type":"CONTENT","content":"Oky may link to other websites and resources that are not under Oky and or UNICEF's control. The inclusion of such links does not imply an endorsement or approval by Oky and or UNICEF of any website, product or service. \\n\\n\\nWhen you click on links on the Oky app or website, some of them may lead you to other places on the internet, so please keep that in mind and click carefully! We have not checked out all of the other sites and we cannot guarantee that they are always accurate or reliable. We also do not support these sites, their opinions or anything that they are trying to sell. Also note that these other sites are subject to their own terms of use. Oky does not assume any responsibility for content on such other sites.\\n\\nUNICEF and or Oky does not assume any responsibility or liability in respect of such websites, including, for example, responsibility or liability for the accuracy or reliability of any information, data, opinions, advice or statements made on those web sites."},{"type":"HEADING","content":"Disclaimer"},{"type":"CONTENT","content":"What you read on the Oky app or website is not necessarily written by the Oky team and or UNICEF staff, so the views and opinions voiced on the Oky app and website are not necessarily the same as those of UNICEF and or Oky team.\\nAll content that Oky provides or is provided “as is”. This simply means that we cannot guarantee that everything you find on this site will be completely accurate or error-free. The Oky content is periodically added to, changed, improved, or updated without notice. Make sure you use content on the Oky app or website thoughtfully and responsibly.\\nThe Oky app and website may be updated and changed from time to time to provide updated information, links or provide new functionality and reflect changes to our users' needs.It is not guaranteed that the Oky app, or any content on it, will always be available or be uninterrupted. We may suspend or withdraw or restrict the availability of all or any part of the Oky app for operational or other reasons. We will try to give you reasonable notice of any suspension or withdrawal.You agree that you are solely responsible for any issues that you may encounter that result from your use of the Oky app. Under no circumstances can UNICEF and or Oky be held responsible for any damages or injuries you may have related to your use of the Oky app.\\nYou agree to indemnify, at your own expense, UNICEF, its officials, employees, consultants and agents, against any claims, including your costs and expenses, by any third party, resulting from your use of the Oky app and website.\\nThe mention of names of specific companies or products on the Oky app or website does not imply any intention to infringe proprietary rights, nor should it be interpreted as an endorsement or recommendation on the part of UNICEF and or Oky.The use of particular designations of countries or territories or maps on this site does not reflect a position by UNICEF and or Oky on the legal status of such countries or territories, of their authorities and institutions or of the delimitation of their boundaries."},{"type":"HEADING","content":"Contact us"},{"type":"CONTENT","content":"If you have any questions about Oky, please contact us at hello@okyapp.info .\\n\\nLast updated 1st December 2021"}]	2025-07-29 16:05:01.956	en
\.


--
-- Data for Name: user; Type: TABLE DATA; Schema: periodtracker; Owner: periodtracker
--

COPY periodtracker."user" (id, username, password, lang, date_created, type) FROM stdin;
-1	admin	$2b$10$cslKchhKRBsWG.dCsspbb.mkY9.opLl1t1Oxs3j2E01/Zm3llW/Rm	en	2025-07-24 07:24:01.650358+00	superAdmin
1	sadmin	$2b$10$At8WU8w9HOJH3.uTfmHsceWUmWJMgaqRc3J0nzM2/7uiJnP4GmXj2	en	2025-07-24T07:28:42.784Z	superAdmin
\.


--
-- Data for Name: video; Type: TABLE DATA; Schema: periodtracker; Owner: periodtracker
--

COPY periodtracker.video (id, title, "youtubeId", "assetName", live, date_created, lang, "sortingKey") FROM stdin;
\.


--
-- Name: about_banner_id_seq; Type: SEQUENCE SET; Schema: periodtracker; Owner: periodtracker
--

SELECT pg_catalog.setval('periodtracker.about_banner_id_seq', 1, true);


--
-- Name: about_id_seq; Type: SEQUENCE SET; Schema: periodtracker; Owner: periodtracker
--

SELECT pg_catalog.setval('periodtracker.about_id_seq', 3, true);


--
-- Name: analytics_id_seq; Type: SEQUENCE SET; Schema: periodtracker; Owner: periodtracker
--

SELECT pg_catalog.setval('periodtracker.analytics_id_seq', 1, false);


--
-- Name: app_event_id_seq; Type: SEQUENCE SET; Schema: periodtracker; Owner: periodtracker
--

SELECT pg_catalog.setval('periodtracker.app_event_id_seq', 2, true);


--
-- Name: article_sorting_key; Type: SEQUENCE SET; Schema: periodtracker; Owner: periodtracker
--

SELECT pg_catalog.setval('periodtracker.article_sorting_key', 1, false);


--
-- Name: category_sorting_key; Type: SEQUENCE SET; Schema: periodtracker; Owner: periodtracker
--

SELECT pg_catalog.setval('periodtracker.category_sorting_key', 19, true);


--
-- Name: help_center_attribute_id_seq; Type: SEQUENCE SET; Schema: periodtracker; Owner: periodtracker
--

SELECT pg_catalog.setval('periodtracker.help_center_attribute_id_seq', 1, false);


--
-- Name: help_center_id_seq; Type: SEQUENCE SET; Schema: periodtracker; Owner: periodtracker
--

SELECT pg_catalog.setval('periodtracker.help_center_id_seq', 1, false);


--
-- Name: help_center_sorting_key; Type: SEQUENCE SET; Schema: periodtracker; Owner: periodtracker
--

SELECT pg_catalog.setval('periodtracker.help_center_sorting_key', 1, false);


--
-- Name: notification_id_seq; Type: SEQUENCE SET; Schema: periodtracker; Owner: periodtracker
--

SELECT pg_catalog.setval('periodtracker.notification_id_seq', 1, false);


--
-- Name: permanent_notification_id_seq; Type: SEQUENCE SET; Schema: periodtracker; Owner: periodtracker
--

SELECT pg_catalog.setval('periodtracker.permanent_notification_id_seq', 1, false);


--
-- Name: privacy_policy_id_seq; Type: SEQUENCE SET; Schema: periodtracker; Owner: periodtracker
--

SELECT pg_catalog.setval('periodtracker.privacy_policy_id_seq', 5, true);


--
-- Name: subcategory_sorting_key; Type: SEQUENCE SET; Schema: periodtracker; Owner: periodtracker
--

SELECT pg_catalog.setval('periodtracker.subcategory_sorting_key', 48, true);


--
-- Name: terms_and_conditions_id_seq; Type: SEQUENCE SET; Schema: periodtracker; Owner: periodtracker
--

SELECT pg_catalog.setval('periodtracker.terms_and_conditions_id_seq', 1, true);


--
-- Name: user_id_seq; Type: SEQUENCE SET; Schema: periodtracker; Owner: periodtracker
--

SELECT pg_catalog.setval('periodtracker.user_id_seq', 1, true);


--
-- Name: video_sorting_key; Type: SEQUENCE SET; Schema: periodtracker; Owner: periodtracker
--

SELECT pg_catalog.setval('periodtracker.video_sorting_key', 1, false);


--
-- Name: app_event PK_2107093522d011af5866f5c7b8b; Type: CONSTRAINT; Schema: periodtracker; Owner: periodtracker
--

ALTER TABLE ONLY periodtracker.app_event
    ADD CONSTRAINT "PK_2107093522d011af5866f5c7b8b" PRIMARY KEY (id);


--
-- Name: did_you_know PK_32deb816574cba45fcf50f4b364; Type: CONSTRAINT; Schema: periodtracker; Owner: periodtracker
--

ALTER TABLE ONLY periodtracker.did_you_know
    ADD CONSTRAINT "PK_32deb816574cba45fcf50f4b364" PRIMARY KEY (id);


--
-- Name: subcategory PK_35c7f127f3a4e0e26e2f46746ff; Type: CONSTRAINT; Schema: periodtracker; Owner: periodtracker
--

ALTER TABLE ONLY periodtracker.subcategory
    ADD CONSTRAINT "PK_35c7f127f3a4e0e26e2f46746ff" PRIMARY KEY (id);


--
-- Name: survey PK_6b410aa92ebd6c5e429c8c7555f; Type: CONSTRAINT; Schema: periodtracker; Owner: periodtracker
--

ALTER TABLE ONLY periodtracker.survey
    ADD CONSTRAINT "PK_6b410aa92ebd6c5e429c8c7555f" PRIMARY KEY (id);


--
-- Name: user PK_6cb7c14d28b65103f54c5b538f1; Type: CONSTRAINT; Schema: periodtracker; Owner: periodtracker
--

ALTER TABLE ONLY periodtracker."user"
    ADD CONSTRAINT "PK_6cb7c14d28b65103f54c5b538f1" PRIMARY KEY (id);


--
-- Name: category PK_6ff10a6bb5bac58bf412a00dc8e; Type: CONSTRAINT; Schema: periodtracker; Owner: periodtracker
--

ALTER TABLE ONLY periodtracker.category
    ADD CONSTRAINT "PK_6ff10a6bb5bac58bf412a00dc8e" PRIMARY KEY (id);


--
-- Name: suggestion PK_753936e5595250a6f94ef15273a; Type: CONSTRAINT; Schema: periodtracker; Owner: periodtracker
--

ALTER TABLE ONLY periodtracker.suggestion
    ADD CONSTRAINT "PK_753936e5595250a6f94ef15273a" PRIMARY KEY (id);


--
-- Name: article PK_8a87b738cfed36d3df1ae29f6f8; Type: CONSTRAINT; Schema: periodtracker; Owner: periodtracker
--

ALTER TABLE ONLY periodtracker.article
    ADD CONSTRAINT "PK_8a87b738cfed36d3df1ae29f6f8" PRIMARY KEY (id);


--
-- Name: help_center PK_b75170bf3fa752ce352ee24695e; Type: CONSTRAINT; Schema: periodtracker; Owner: periodtracker
--

ALTER TABLE ONLY periodtracker.help_center
    ADD CONSTRAINT "PK_b75170bf3fa752ce352ee24695e" PRIMARY KEY (id);


--
-- Name: avatar_messages PK_caa28febed46e7e9cc603ba6336; Type: CONSTRAINT; Schema: periodtracker; Owner: periodtracker
--

ALTER TABLE ONLY periodtracker.avatar_messages
    ADD CONSTRAINT "PK_caa28febed46e7e9cc603ba6336" PRIMARY KEY (id);


--
-- Name: analytics PK_cc3f23b88a99dbd75748995bc44; Type: CONSTRAINT; Schema: periodtracker; Owner: periodtracker
--

ALTER TABLE ONLY periodtracker.analytics
    ADD CONSTRAINT "PK_cc3f23b88a99dbd75748995bc44" PRIMARY KEY (id);


--
-- Name: quiz PK_d431cff50cfee5d1bf2b4a78bd4; Type: CONSTRAINT; Schema: periodtracker; Owner: periodtracker
--

ALTER TABLE ONLY periodtracker.quiz
    ADD CONSTRAINT "PK_d431cff50cfee5d1bf2b4a78bd4" PRIMARY KEY (id);


--
-- Name: oky_user PK_d6e1a97b8ab1251cdfa1e96cfae; Type: CONSTRAINT; Schema: periodtracker; Owner: periodtracker
--

ALTER TABLE ONLY periodtracker.oky_user
    ADD CONSTRAINT "PK_d6e1a97b8ab1251cdfa1e96cfae" PRIMARY KEY (id);


--
-- Name: notification PK_f8813f8c52a4bfe5ac252994970; Type: CONSTRAINT; Schema: periodtracker; Owner: periodtracker
--

ALTER TABLE ONLY periodtracker.notification
    ADD CONSTRAINT "PK_f8813f8c52a4bfe5ac252994970" PRIMARY KEY (id);


--
-- Name: permanent_notification PK_fec922ab39cf369a3dc40fd75cc; Type: CONSTRAINT; Schema: periodtracker; Owner: periodtracker
--

ALTER TABLE ONLY periodtracker.permanent_notification
    ADD CONSTRAINT "PK_fec922ab39cf369a3dc40fd75cc" PRIMARY KEY (id);


--
-- Name: video PK_periodtracker_video_id; Type: CONSTRAINT; Schema: periodtracker; Owner: periodtracker
--

ALTER TABLE ONLY periodtracker.video
    ADD CONSTRAINT "PK_periodtracker_video_id" PRIMARY KEY (id);


--
-- Name: app_event UQ_b5ad7953934db4391d65a852736; Type: CONSTRAINT; Schema: periodtracker; Owner: periodtracker
--

ALTER TABLE ONLY periodtracker.app_event
    ADD CONSTRAINT "UQ_b5ad7953934db4391d65a852736" UNIQUE (local_id);


--
-- Name: about_banner about_banner_pkey; Type: CONSTRAINT; Schema: periodtracker; Owner: periodtracker
--

ALTER TABLE ONLY periodtracker.about_banner
    ADD CONSTRAINT about_banner_pkey PRIMARY KEY (id);


--
-- Name: about about_pkey; Type: CONSTRAINT; Schema: periodtracker; Owner: periodtracker
--

ALTER TABLE ONLY periodtracker.about
    ADD CONSTRAINT about_pkey PRIMARY KEY (id);


--
-- Name: help_center_attribute help_center_attribute_pkey; Type: CONSTRAINT; Schema: periodtracker; Owner: periodtracker
--

ALTER TABLE ONLY periodtracker.help_center_attribute
    ADD CONSTRAINT help_center_attribute_pkey PRIMARY KEY (id);


--
-- Name: privacy_policy privacy_policy_pkey; Type: CONSTRAINT; Schema: periodtracker; Owner: periodtracker
--

ALTER TABLE ONLY periodtracker.privacy_policy
    ADD CONSTRAINT privacy_policy_pkey PRIMARY KEY (id);


--
-- Name: terms_and_conditions terms_and_conditions_pkey; Type: CONSTRAINT; Schema: periodtracker; Owner: periodtracker
--

ALTER TABLE ONLY periodtracker.terms_and_conditions
    ADD CONSTRAINT terms_and_conditions_pkey PRIMARY KEY (id);


--
-- PostgreSQL database dump complete
--

