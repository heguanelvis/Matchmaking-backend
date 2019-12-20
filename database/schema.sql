DROP SCHEMA public CASCADE;
CREATE SCHEMA public;

/*

SELECT * FROM schedule;

SELECT s.student_id, s.student_first_name, s.student_last_name, 
e.*, sd.appointment_datetime FROM users u INNER JOIN
student_user su ON u.user_id = su.user_id INNER JOIN 
student s ON su.student_id = s.student_id INNER JOIN
schedule sd ON sd.student_id = s.student_id INNER JOIN employer e
ON sd.employer_id = e.employer_id WHERE username = 'ghe';

SELECT e.employer_id, e.employer_name, e.table_count, e.days_to_attend, 
s.*, sd.appointment_datetime FROM employer e INNER JOIN
schedule sd ON sd.employer_id = e.employer_id INNER JOIN student s 
ON sd.student_id = s.student_id WHERE e.employer_id = '2010';

SELECT employer_id FROM employer;
*/

CREATE TABLE users (
  user_id SERIAL PRIMARY KEY,
  username varchar(64) NOT NULL UNIQUE, 
  email varchar(128) NOT NULL UNIQUE,    
  password varchar(32) NOT NULL,      
  salt varchar(256) NOT NULL,          
  role varchar(32) NOT NULL 
);

CREATE TABLE student (
  student_id SERIAL PRIMARY KEY,
  student_first_name varchar(32) NOT NULL,
  student_last_name varchar(32) NOT NULL,
  student_email varchar(128) NOT NULL,
  student_linkedin_url text NOT NULL,
  student_img_url text NOT NULL
);

CREATE TABLE student_user (
  user_id INTEGER NOT NULL,
  student_id INTEGER NOT NULL,
  CONSTRAINT fk_student_user_user_id FOREIGN KEY (user_id) REFERENCES users (user_id),
  CONSTRAINT fk_student_user_student_id FOREIGN KEY (student_id) REFERENCES student (student_id),
  CONSTRAINT pk_student_user PRIMARY KEY (user_id, student_id)
);

CREATE TABLE employer (
  employer_id SERIAL PRIMARY KEY,
  employer_name varchar(128) NOT NULL,
  employer_email varchar(128) NOT NULL,
  table_count INTEGER NOT NULL,
  days_to_attend varchar(16) NOT NULL,
  employer_representatives text NOT NULL,
  employer_positions text NOT NULL,
  employer_img_url text NOT NULL,
  employer_description text NOT NULL,
  employer_note text NOT NULL
);

CREATE TABLE employer_user (
  user_id SERIAL,
  employer_id SERIAL,
  CONSTRAINT fk_employer_user_user_id FOREIGN KEY (user_id) REFERENCES users (user_id),
  CONSTRAINT fk_employer_user_employer_id FOREIGN KEY (employer_id) REFERENCES employer (employer_id),
  CONSTRAINT pk_employer_user PRIMARY KEY (user_id, employer_id)
);

CREATE TABLE ranking (
  student_id INTEGER NOT NULL,
  employer_id INTEGER NOT NULL,
  ranking INTEGER NOT NULL,
  CONSTRAINT fk_ranking_student_id FOREIGN KEY (student_id) REFERENCES student (student_id),
  CONSTRAINT fk_ranking_employer_id FOREIGN KEY (employer_id) REFERENCES employer (employer_id),
  CONSTRAINT pk_ranking PRIMARY KEY (student_id, employer_id)
);

CREATE TABlE schedule (
  student_id INTEGER NOT NULL,
  employer_id INTEGER NOT NULL,
  appointment_datetime INTEGER NOT NULL,
  CONSTRAINT pk_schedule PRIMARY KEY (student_id, employer_id, appointment_datetime),
  CONSTRAINT fk_student_user_student_id FOREIGN KEY (student_id) REFERENCES student (student_id),
  CONSTRAINT fk_employer_user_employer_id FOREIGN KEY (employer_id) REFERENCES employer (employer_id)
 );


/* --- Admin Data --- */
/* --- Nicole - password: nicolenicole --- */
INSERT INTO users(username, email, password, salt, role) 
VALUES ('nicole', 
'nicole@techelevator.com', 
'MrTyy+c0vf0Gmg0iG5dNoA==', 
'VavhUqL50mJMp6x9F+mtCXBjqLCVg4f7GyZ50oEvs3ha4ILEiLSlRF+rrVE44VoLXz1Qq0OlZhTJthfMGDEeFLcNWpz5zCAEla64EnitxAgTCLn4Iro9GgFUEgHEIxiKx/MrlC0y05SrMN9PA+oQx1sAG7lqQtFpA1JeN95b4w4=', 
'admin'
);


/* --- 1 --- Bluth Company - password: greatwall */

INSERT INTO users (user_id, username, email, password, salt, role) VALUES
(1001,
'BluthCo', 
'Bluth@BluthCo.com',
'FjZDm+sndmsdEDwNtfr6NA==',
'kidcasB0te7i0jK0fmRIGHSm0mYhdLTaiGkEAiEvLp7dAEHWnuT8n/5bd2V/mqjstQ198iImm1xCmEFu+BHyOz1Mf7vm4LILcrr17y7Ws40Xyx4FOCt8jD03G+jEafpuVJnPiDmaZQXJEpEfekGOvhKGOCtBnT5uatjKEuVWuDA=',
'employer'
);

INSERT INTO employer (employer_id, employer_name, employer_email, table_count, days_to_attend, employer_representatives, employer_positions, employer_img_url, employer_description, employer_note)
VALUES
(2001,
'BluthCo',
'BlutchCo@BluthCo.com',
2,
'day1',
'George$$$$$Bluth$$$$$georgemichael@bluth.com$$$$$Talent Acquistion Specialist$$$$$Lucille$$$$$Bluth$$$$$lucille@bluth.com$$$$$Talent Acquistion Specialist',
'Cloud Engineer$$$$$https://slalom.secure.force.com/careers/ts2__JobDetails?jobId=a0h1R00000BFiN6QAL&tSource=$$$$$Integration Architect$$$$$https://slalom.secure.force.com/careers/ts2__JobDetails?jobId=a0h1R00000BNnpdQAD&tSource=',
'https://i.pinimg.com/474x/e8/8f/f6/e88ff6298fac3f18f109e576978470a9.jpg',
'Bluth Co is a business and technology consulting firm headquartered in Seattle, Washington. The company, which is a division of Bluth, LLC, employs more than 7,000 people across 27 offices in North America and London. Bluth''s annual revenue exceeds one billion dollars.',
'Bluth''s office is in downtown Detroit.'
);

INSERT INTO employer_user (user_id, employer_id) VALUES
(1001, 2001);


/* --- 2 ---Binford Tools - password: greatwall */

INSERT INTO users (user_id, username, email, password, salt, role) VALUES
(1002,
'binford', 
'binford@binford.com',
'FjZDm+sndmsdEDwNtfr6NA==',
'kidcasB0te7i0jK0fmRIGHSm0mYhdLTaiGkEAiEvLp7dAEHWnuT8n/5bd2V/mqjstQ198iImm1xCmEFu+BHyOz1Mf7vm4LILcrr17y7Ws40Xyx4FOCt8jD03G+jEafpuVJnPiDmaZQXJEpEfekGOvhKGOCtBnT5uatjKEuVWuDA=',
'employer'
);

INSERT INTO employer (employer_id, employer_name, employer_email, table_count, days_to_attend, employer_representatives, employer_positions, employer_img_url, employer_description, employer_note)
VALUES
(2002,
'Binford',
'Binford@Binford.com',
2,
'day1',
'Tim$$$$$Taylor$$$$$tim@binfordtools.com$$$$$Talent Acquistion Specialist$$$$$Al$$$$$Borland$$$$$al.borland@binfordtools.com$$$$$Enterprise Transformation Specialist',
'Technical Analyst$$$$$https://careers-perficient.icims.com/jobs/8896/senior-digital-analyst/job?hub=7&mobile=false&width=1071&height=500&bga=true&needsRedirect=false&jan1offset=-300&jun1offset=-240',
'https://i.pinimg.com/474x/12/77/dd/1277dd711cb32cdf21b34f8e7a6b884a.jpg',
'Binford is the leading digital transformation consulting firm serving Global 2000 and enterprise customers throughout North America. With unparalleled information technology, management consulting and creative capabilities, Binford and its Binford Digital agency deliver vision, execution and value with outstanding digital experience, business optimization and industry solutions.',
'Binford''s office is in Livonia.'
);

INSERT INTO employer_user (user_id, employer_id) VALUES
(1002, 2002);


/* --- 3 ---Dunder Mifflin - password: greatwall */

INSERT INTO users (user_id, username, email, password, salt, role) VALUES
(1003,
'DunderMifflin', 
'Dunder@Mifflin.com',
'FjZDm+sndmsdEDwNtfr6NA==',
'kidcasB0te7i0jK0fmRIGHSm0mYhdLTaiGkEAiEvLp7dAEHWnuT8n/5bd2V/mqjstQ198iImm1xCmEFu+BHyOz1Mf7vm4LILcrr17y7Ws40Xyx4FOCt8jD03G+jEafpuVJnPiDmaZQXJEpEfekGOvhKGOCtBnT5uatjKEuVWuDA=',
'employer'
);

INSERT INTO employer (employer_id, employer_name, employer_email, table_count, days_to_attend, employer_representatives, employer_positions, employer_img_url, employer_description, employer_note)
VALUES
(2003,
'Dunder Mifflin',
'Dunder@Mifflin.com',
1,
'day1',
'Michael$$$$$Scott$$$$$michaelgaryscott@dundermifflin.com$$$$$Senior Paper Director$$$$$Dwight$$$$$Schrute$$$$$bearsbeetsbattlestargalactica@dundermifflin.com$$$$$Assitant to the Regional Manager',
'Assistant to the Assistant Regional Manager$$$$$https://www.dundermifflin.com/',
'https://i.pinimg.com/474x/91/91/f0/9191f0d73f12b1dc06e39c2c9258774c.jpg',
'Dunder Mifflin Paper Company, Inc. is a fictional paper sales company featured in the American television series The Office. It is analogous to Wernham Hogg in the British original of the series, and Papiers Jennings and Cogirep in the French Canadian and French adaptations respectively. Originally, the company was completely fictitious, but eventually, the brand was used to sell products at Staples and other office supply outlets.',
'Dunder Mifflin''s office is in Scranton, Pennsylvania.'
);

INSERT INTO employer_user (user_id, employer_id) VALUES
(1003, 2003);


/* --- 4 ---LexCorp - password: greatwall */

INSERT INTO users (user_id, username, email, password, salt, role) VALUES
(1004,
'lexcorp', 
'lexcorp@lexcorp.com',
'FjZDm+sndmsdEDwNtfr6NA==',
'kidcasB0te7i0jK0fmRIGHSm0mYhdLTaiGkEAiEvLp7dAEHWnuT8n/5bd2V/mqjstQ198iImm1xCmEFu+BHyOz1Mf7vm4LILcrr17y7Ws40Xyx4FOCt8jD03G+jEafpuVJnPiDmaZQXJEpEfekGOvhKGOCtBnT5uatjKEuVWuDA=',
'employer'
);

INSERT INTO employer (employer_id, employer_name, employer_email, table_count, days_to_attend, employer_representatives, employer_positions, employer_img_url, employer_description, employer_note)
VALUES
(2004,
'LexCorp',
'lexcorp@lexcorp.com',
1,
'day2',
'Lex$$$$$Luthor$$$$$lex@lexcorp.com$$$$$Talent Engagement & Culture Lead$$$$$Clark$$$$$Kent$$$$$clark@thedailyplanet.com$$$$$Talent Engagement Consultant',
'Software Artisan$$$$$https://www.lexcorp.com/',
'https://i.pinimg.com/474x/8e/bd/27/8ebd27d21e5b4a95f64391d05a40d2db.jpg',
'Growing customer expectations. Market-shaping AI. Self-optimizing systems. The post-digital age shows no signs of slowing down, and the need for new ideas powered by intelligent technologies has never been greater.',
'Lexcorp is located in downtown Metropolis.'
);

INSERT INTO employer_user (user_id, employer_id) VALUES
(1004, 2004);


/* --- 5 --- Wayne Enterprises - password: greatwall */

INSERT INTO users (user_id, username, email, password, salt, role) VALUES
(1005,
'wayne', 
'wayne@wayne.com',
'FjZDm+sndmsdEDwNtfr6NA==',
'kidcasB0te7i0jK0fmRIGHSm0mYhdLTaiGkEAiEvLp7dAEHWnuT8n/5bd2V/mqjstQ198iImm1xCmEFu+BHyOz1Mf7vm4LILcrr17y7Ws40Xyx4FOCt8jD03G+jEafpuVJnPiDmaZQXJEpEfekGOvhKGOCtBnT5uatjKEuVWuDA=',
'employer'
);

INSERT INTO employer (employer_id, employer_name, employer_email, table_count, days_to_attend, employer_representatives, employer_positions, employer_img_url, employer_description, employer_note)
VALUES
(2005,
'Wayne Enterprises',
'wayne@wayne.com',
2,
'day2',
'Bruce$$$$$Wayne$$$$$imnotreallybatman@wayne.com$$$$$Talent Engagement Lead$$$$$Alfred$$$$$Pennyworth$$$$$AlfredPennyworth@wayne.com$$$$$Talent Engagement Lead',
'AEM Author$$$$$https://wayneenterprises.com/',
'https://i.pinimg.com/564x/97/db/0d/97db0d849cc18a625fd17e36bbbe6135.jpg',
'Wayne Enterprises and the Wayne Foundation are largely run by Bruce Wayne''s business manager Lucius Fox. Fox makes most company decisions on Bruce Wayne''s behalf, since Wayne''s time is largely occupied as the vigilante Batman.

Wayne Enterprises have been presented in movies and TV as a business conglomerate, modeled after the standards of a multinational company.',
'Wayne Enterprises is located in downtown Gotham.'
);

INSERT INTO employer_user (user_id, employer_id) VALUES
(1005, 2005);


/* --- 6 --- Acme- password: greatwall */

INSERT INTO users (user_id, username, email, password, salt, role) VALUES
(1006,
'acme', 
'acme@acme.com',
'FjZDm+sndmsdEDwNtfr6NA==',
'kidcasB0te7i0jK0fmRIGHSm0mYhdLTaiGkEAiEvLp7dAEHWnuT8n/5bd2V/mqjstQ198iImm1xCmEFu+BHyOz1Mf7vm4LILcrr17y7Ws40Xyx4FOCt8jD03G+jEafpuVJnPiDmaZQXJEpEfekGOvhKGOCtBnT5uatjKEuVWuDA=',
'employer'
);

INSERT INTO employer (employer_id, employer_name, employer_email, table_count, days_to_attend, employer_representatives, employer_positions, employer_img_url, employer_description, employer_note)
VALUES
(2006,
'Acme',
'acme@acme.com',
1,
'day2',
'Wile E.$$$$$Coyote$$$$$stilltryingtocatchtheroadrunner@acme.com$$$$$Managing Director',
'Jr Developer$$$$$https://www.acme.online/',
'https://i.pinimg.com/564x/9f/f7/db/9ff7db5b263089c03cf7a0f8af26f122.jpg',
'We increase productivity by transforming how businesses train and engage their employees, automate business processes and provide resources to advance technology projects. Our processes, training and technology services have helped small businesses, fortune 100 corporations and many in between.',
'Acme Inc. is located in Troy, MI.');

INSERT INTO employer_user (user_id, employer_id) VALUES
(1006, 2006);


/* --- 7 --- Hooli - password: greatwall */

INSERT INTO users (user_id, username, email, password, salt, role) VALUES
(1007,
'hooli', 
'hooli@hooli.com',
'FjZDm+sndmsdEDwNtfr6NA==',
'kidcasB0te7i0jK0fmRIGHSm0mYhdLTaiGkEAiEvLp7dAEHWnuT8n/5bd2V/mqjstQ198iImm1xCmEFu+BHyOz1Mf7vm4LILcrr17y7Ws40Xyx4FOCt8jD03G+jEafpuVJnPiDmaZQXJEpEfekGOvhKGOCtBnT5uatjKEuVWuDA=',
'employer'
);

INSERT INTO employer (employer_id, employer_name, employer_email, table_count, days_to_attend, employer_representatives, employer_positions, employer_img_url, employer_description, employer_note)
VALUES
(2007,
'Hooli',
'hooli@.com',
1,
'day1',
'Gavin$$$$$Belson$$$$$gavin@hooli.com$$$$$University Relations Manager',
'Jr Developer$$$$$https://www.hooli.com/',
'https://vignette.wikia.nocookie.net/silicon-valley/images/f/f0/Hooli.png/revision/latest/scale-to-width-down/180?cb=20160811201728',
'Our top priority is destroying Pied Piper. That?s why we?re using our expertise to help solve a serious issue ? eradicating Erlich from the Earth!',
'Hooli is located in downtown Silicon Valley.'
);

INSERT INTO employer_user (user_id, employer_id) VALUES
(1007, 2007);


/* --- 8 --- Human Element - password: greatwall */

INSERT INTO users (user_id, username, email, password, salt, role) VALUES
(1008,
'piedpiper', 
'piedpiper@piedpiper.com',
'FjZDm+sndmsdEDwNtfr6NA==',
'kidcasB0te7i0jK0fmRIGHSm0mYhdLTaiGkEAiEvLp7dAEHWnuT8n/5bd2V/mqjstQ198iImm1xCmEFu+BHyOz1Mf7vm4LILcrr17y7Ws40Xyx4FOCt8jD03G+jEafpuVJnPiDmaZQXJEpEfekGOvhKGOCtBnT5uatjKEuVWuDA=',
'employer'
);

INSERT INTO employer (employer_id, employer_name, employer_email, table_count, days_to_attend, employer_representatives, employer_positions, employer_img_url, employer_description, employer_note)
VALUES
(2008,
'Pied Piper',
'piedpiper@piedpiper.com',
1,
'both',
'Richard$$$$$Hendricks$$$$$lilrichie@piedpiper.com$$$$$Human Resources Manager',
'Full Stack Developer$$$$$https://www.piedpiper.com/magento-development',
'https://ih0.redbubble.net/image.245216652.4688/ap,550x550,16x12,1,transparent,t.u1.png',
'At its core, Pied Piper was built on the belief that money matters ? and it is reflected in everything we do. Our company was started in 2004 by managing partners Richard Hendricks and Erlich Bachman because they wanted to be a part of a company that valued human connection with a strong foundation in what they know best: software development and consulting. Fast forward 15 years and the Pied Piper of today has grown to something bigger and more successful than we could have hoped. Twice making it on the Inc. 5000 list, a handful of Fast Track awards, and most importantly, never losing the standards set when it was just two guys in a basement. Today, the roots are still in technology and development, but we have evolved to support the growing and ever-changing eCommerce industry by offering new services in digital marketing, experience design, and customer research.',
'Pied Piper is located in Silicon Valley.'
);

INSERT INTO employer_user (user_id, employer_id) VALUES
(1008, 2008);


/* --- 9 --- Stark Industries - password: greatwall */

INSERT INTO users (user_id, username, email, password, salt, role) VALUES
(1009,
'starkindustries', 
'stark@stark.com',
'FjZDm+sndmsdEDwNtfr6NA==',
'kidcasB0te7i0jK0fmRIGHSm0mYhdLTaiGkEAiEvLp7dAEHWnuT8n/5bd2V/mqjstQ198iImm1xCmEFu+BHyOz1Mf7vm4LILcrr17y7Ws40Xyx4FOCt8jD03G+jEafpuVJnPiDmaZQXJEpEfekGOvhKGOCtBnT5uatjKEuVWuDA=',
'employer'
);

INSERT INTO employer (employer_id, employer_name, employer_email, table_count, days_to_attend, employer_representatives, employer_positions, employer_img_url, employer_description, employer_note)
VALUES
(2009,
'Stark Industries',
'stark@stark.com',
'1',
'day2',
'Tony$$$$$Stark$$$$$TonyTheGod@stark.com$$$$$CTO',
'Full Stack Developer$$$$$https://www.starkindustries.co/',
'https://www.picclickimg.com/d/l400/pict/264328089926_/Stark-Industries-Sticker-Vinyl-Decal-Iron-Man.jpg',
'Stark Industries (NYSE: SIA, NASDAQ: STRK, fictional), later also known as Stark International, Stark Innovations, Stark Enterprises and Stark Resilient, is a fictional company appearing in American comic books published by Marvel Comics. The company is depicted as being owned and run by businessman Tony Stark, who is also known as Iron Man. It first appeared in Tales of Suspense No. 40 (April 1963) and was founded by Tony''s father, Howard Stark. According to Forbes 25 largest fictional companies it had an estimated sales of $20.3 billion, ranking it at number 16. ',
'Stark Industries is located in New York City.'
);

INSERT INTO employer_user (user_id, employer_id) VALUES
(1009, 2009);


/* --- 10 --- Spacely Sprockets---password: greatwall */

INSERT INTO users (user_id, username, email, password, salt, role) VALUES
(1010,
'spacely sprockets', 
'spacely@sprockets.com',
'FjZDm+sndmsdEDwNtfr6NA==',
'kidcasB0te7i0jK0fmRIGHSm0mYhdLTaiGkEAiEvLp7dAEHWnuT8n/5bd2V/mqjstQ198iImm1xCmEFu+BHyOz1Mf7vm4LILcrr17y7Ws40Xyx4FOCt8jD03G+jEafpuVJnPiDmaZQXJEpEfekGOvhKGOCtBnT5uatjKEuVWuDA=',
'employer'
);

INSERT INTO employer (employer_id, employer_name, employer_email, table_count, days_to_attend, employer_representatives, employer_positions, employer_img_url, employer_description, employer_note)
VALUES
(2010,
'Spacely Sprockets',
'spacely@sprockets.com',
1,
'day1',
'Cosmo$$$$$Spacely$$$$$cosmo@spacely.com$$$$$Software Engineer',
'Full Stack Developer$$$$$https://www.spacelysprockets.io/',
'https://longstreet.typepad.com/.a/6a00d83542d51e69e2017d3fba8e53970c-pi',
'Spacely Space Sprockets is a company located in Orbit City that manufactures sprockets.  It is owned by Cosmo Spacely.',
'Spacely Sprockets is located in Orbit City.'
);

INSERT INTO employer_user (user_id, employer_id) VALUES
(1010, 2010);


/* --- 1 --- Matt - password: greatwall */

INSERT INTO users (user_id, username, email, password, salt, role) VALUES
(1011,
'mstuart', 
'mstuart85@gmail.com',
'FjZDm+sndmsdEDwNtfr6NA==',
'kidcasB0te7i0jK0fmRIGHSm0mYhdLTaiGkEAiEvLp7dAEHWnuT8n/5bd2V/mqjstQ198iImm1xCmEFu+BHyOz1Mf7vm4LILcrr17y7Ws40Xyx4FOCt8jD03G+jEafpuVJnPiDmaZQXJEpEfekGOvhKGOCtBnT5uatjKEuVWuDA=',
'student'
);

/* --- 2 --- Kirsten - password: greatwall */

INSERT INTO users (user_id, username, email, password, salt, role) VALUES
(1012,
'klund', 
'kirsten.d.lund@gmail.com',
'FjZDm+sndmsdEDwNtfr6NA==',
'kidcasB0te7i0jK0fmRIGHSm0mYhdLTaiGkEAiEvLp7dAEHWnuT8n/5bd2V/mqjstQ198iImm1xCmEFu+BHyOz1Mf7vm4LILcrr17y7Ws40Xyx4FOCt8jD03G+jEafpuVJnPiDmaZQXJEpEfekGOvhKGOCtBnT5uatjKEuVWuDA=',
'student'
);

/* --- 3 --- Guan - password: greatwall */

INSERT INTO users (user_id, username, email, password, salt, role) VALUES
(1013,
'ghe', 
'heguanelvis@gmail.com',
'FjZDm+sndmsdEDwNtfr6NA==',
'kidcasB0te7i0jK0fmRIGHSm0mYhdLTaiGkEAiEvLp7dAEHWnuT8n/5bd2V/mqjstQ198iImm1xCmEFu+BHyOz1Mf7vm4LILcrr17y7Ws40Xyx4FOCt8jD03G+jEafpuVJnPiDmaZQXJEpEfekGOvhKGOCtBnT5uatjKEuVWuDA=',
'student'
);

/* --- 4 --- Alicia - password: greatwall */

INSERT INTO users (user_id, username, email, password, salt, role) VALUES
(1014,
'afilippis', 
'aliciafillipis@gmail.com',
'FjZDm+sndmsdEDwNtfr6NA==',
'kidcasB0te7i0jK0fmRIGHSm0mYhdLTaiGkEAiEvLp7dAEHWnuT8n/5bd2V/mqjstQ198iImm1xCmEFu+BHyOz1Mf7vm4LILcrr17y7Ws40Xyx4FOCt8jD03G+jEafpuVJnPiDmaZQXJEpEfekGOvhKGOCtBnT5uatjKEuVWuDA=',
'student'
);

/* --- 5 --- Kelly - password: greatwall */

INSERT INTO users (user_id, username, email, password, salt, role) VALUES
(1015,
'kflood', 
'kellyflood@gmail.com',
'FjZDm+sndmsdEDwNtfr6NA==',
'kidcasB0te7i0jK0fmRIGHSm0mYhdLTaiGkEAiEvLp7dAEHWnuT8n/5bd2V/mqjstQ198iImm1xCmEFu+BHyOz1Mf7vm4LILcrr17y7Ws40Xyx4FOCt8jD03G+jEafpuVJnPiDmaZQXJEpEfekGOvhKGOCtBnT5uatjKEuVWuDA=',
'student'
);

/* --- 6 --- Chris N. - password: greatwall */

INSERT INTO users (user_id, username, email, password, salt, role) VALUES
(1016,
'cnichols', 
'chrisnichols@gmail.com',
'FjZDm+sndmsdEDwNtfr6NA==',
'kidcasB0te7i0jK0fmRIGHSm0mYhdLTaiGkEAiEvLp7dAEHWnuT8n/5bd2V/mqjstQ198iImm1xCmEFu+BHyOz1Mf7vm4LILcrr17y7Ws40Xyx4FOCt8jD03G+jEafpuVJnPiDmaZQXJEpEfekGOvhKGOCtBnT5uatjKEuVWuDA=',
'student'
);

/* ---7 --- Jackie - password: greatwall */

INSERT INTO users (user_id, username, email, password, salt, role) VALUES
(1017,
'jgordin', 
'jackiegordin@gmail.com.com',
'FjZDm+sndmsdEDwNtfr6NA==',
'kidcasB0te7i0jK0fmRIGHSm0mYhdLTaiGkEAiEvLp7dAEHWnuT8n/5bd2V/mqjstQ198iImm1xCmEFu+BHyOz1Mf7vm4LILcrr17y7Ws40Xyx4FOCt8jD03G+jEafpuVJnPiDmaZQXJEpEfekGOvhKGOCtBnT5uatjKEuVWuDA=',
'student'
);

/* --- 8 --- Nathan - password: greatwall */

INSERT INTO users (user_id, username, email, password, salt, role) VALUES
(1018,
'nnewcomb', 
'nathannewcomb@gmail.com',
'FjZDm+sndmsdEDwNtfr6NA==',
'kidcasB0te7i0jK0fmRIGHSm0mYhdLTaiGkEAiEvLp7dAEHWnuT8n/5bd2V/mqjstQ198iImm1xCmEFu+BHyOz1Mf7vm4LILcrr17y7Ws40Xyx4FOCt8jD03G+jEafpuVJnPiDmaZQXJEpEfekGOvhKGOCtBnT5uatjKEuVWuDA=',
'student'
);

/* --- 9 --- Chris D. - password: greatwall */

INSERT INTO users (user_id, username, email, password, salt, role) VALUES
(1019,
'cday', 
'chrisday@gmail.com',
'FjZDm+sndmsdEDwNtfr6NA==',
'kidcasB0te7i0jK0fmRIGHSm0mYhdLTaiGkEAiEvLp7dAEHWnuT8n/5bd2V/mqjstQ198iImm1xCmEFu+BHyOz1Mf7vm4LILcrr17y7Ws40Xyx4FOCt8jD03G+jEafpuVJnPiDmaZQXJEpEfekGOvhKGOCtBnT5uatjKEuVWuDA=',
'student'
);

/* --- 10 --- John-Paul - password: greatwall */

INSERT INTO users (user_id, username, email, password, salt, role) VALUES
(1020,
'johnpaulahme', 
'johnpaulahme@gmail.com',
'FjZDm+sndmsdEDwNtfr6NA==',
'kidcasB0te7i0jK0fmRIGHSm0mYhdLTaiGkEAiEvLp7dAEHWnuT8n/5bd2V/mqjstQ198iImm1xCmEFu+BHyOz1Mf7vm4LILcrr17y7Ws40Xyx4FOCt8jD03G+jEafpuVJnPiDmaZQXJEpEfekGOvhKGOCtBnT5uatjKEuVWuDA=',
'student'
);

/* --- 11 --- Austin - password: greatwall */

INSERT INTO users (user_id, username, email, password, salt, role) VALUES
(1021,
'agrant', 
'imdjaustin@gmail.com',
'FjZDm+sndmsdEDwNtfr6NA==',
'kidcasB0te7i0jK0fmRIGHSm0mYhdLTaiGkEAiEvLp7dAEHWnuT8n/5bd2V/mqjstQ198iImm1xCmEFu+BHyOz1Mf7vm4LILcrr17y7Ws40Xyx4FOCt8jD03G+jEafpuVJnPiDmaZQXJEpEfekGOvhKGOCtBnT5uatjKEuVWuDA=',
'student'
);

/* --- 12 --- Max - password: greatwall */

INSERT INTO users (user_id, username, email, password, salt, role) VALUES
(1022,
'mevans', 
'maxevans@gmail.com',
'FjZDm+sndmsdEDwNtfr6NA==',
'kidcasB0te7i0jK0fmRIGHSm0mYhdLTaiGkEAiEvLp7dAEHWnuT8n/5bd2V/mqjstQ198iImm1xCmEFu+BHyOz1Mf7vm4LILcrr17y7Ws40Xyx4FOCt8jD03G+jEafpuVJnPiDmaZQXJEpEfekGOvhKGOCtBnT5uatjKEuVWuDA=',
'student'
);

/* --- 13 --- Tom B. - password: greatwall */

INSERT INTO users (user_id, username, email, password, salt, role) VALUES
(1023,
'tbryson', 
'tommybryson@gmail.com',
'FjZDm+sndmsdEDwNtfr6NA==',
'kidcasB0te7i0jK0fmRIGHSm0mYhdLTaiGkEAiEvLp7dAEHWnuT8n/5bd2V/mqjstQ198iImm1xCmEFu+BHyOz1Mf7vm4LILcrr17y7Ws40Xyx4FOCt8jD03G+jEafpuVJnPiDmaZQXJEpEfekGOvhKGOCtBnT5uatjKEuVWuDA=',
'student'
);

/* --- 14 --- Shawn - password: greatwall */

INSERT INTO users (user_id, username, email, password, salt, role) VALUES
(1024,
'smiller', 
'shawnmiller16@gmail.com',
'FjZDm+sndmsdEDwNtfr6NA==',
'kidcasB0te7i0jK0fmRIGHSm0mYhdLTaiGkEAiEvLp7dAEHWnuT8n/5bd2V/mqjstQ198iImm1xCmEFu+BHyOz1Mf7vm4LILcrr17y7Ws40Xyx4FOCt8jD03G+jEafpuVJnPiDmaZQXJEpEfekGOvhKGOCtBnT5uatjKEuVWuDA=',
'student'
);

/* --- 15 --- Tom P. - password: greatwall */

INSERT INTO users (user_id, username, email, password, salt, role) VALUES
(1025,
'tphillips', 
'longhairtom@gmail.com',
'FjZDm+sndmsdEDwNtfr6NA==',
'kidcasB0te7i0jK0fmRIGHSm0mYhdLTaiGkEAiEvLp7dAEHWnuT8n/5bd2V/mqjstQ198iImm1xCmEFu+BHyOz1Mf7vm4LILcrr17y7Ws40Xyx4FOCt8jD03G+jEafpuVJnPiDmaZQXJEpEfekGOvhKGOCtBnT5uatjKEuVWuDA=',
'student'
);

/* --- 16 --- amyre - password: greatwall */

INSERT INTO users (user_id, username, email, password, salt, role) VALUES
(1026,
'avincent', 
'amyrevincent@gmail.com',
'FjZDm+sndmsdEDwNtfr6NA==',
'kidcasB0te7i0jK0fmRIGHSm0mYhdLTaiGkEAiEvLp7dAEHWnuT8n/5bd2V/mqjstQ198iImm1xCmEFu+BHyOz1Mf7vm4LILcrr17y7Ws40Xyx4FOCt8jD03G+jEafpuVJnPiDmaZQXJEpEfekGOvhKGOCtBnT5uatjKEuVWuDA=',
'student'
);

/* --- 17 --- Ryan- password: greatwall */

INSERT INTO users (user_id, username, email, password, salt, role) VALUES
(1027,
'rmangahas', 
'bigryanm@gmail.com',
'FjZDm+sndmsdEDwNtfr6NA==',
'kidcasB0te7i0jK0fmRIGHSm0mYhdLTaiGkEAiEvLp7dAEHWnuT8n/5bd2V/mqjstQ198iImm1xCmEFu+BHyOz1Mf7vm4LILcrr17y7Ws40Xyx4FOCt8jD03G+jEafpuVJnPiDmaZQXJEpEfekGOvhKGOCtBnT5uatjKEuVWuDA=',
'student'
);

/* --- 18 --- Audrey - password: greatwall */

INSERT INTO users (user_id, username, email, password, salt, role) VALUES
(1028,
'alambright', 
'audreyl@gmail.com',
'FjZDm+sndmsdEDwNtfr6NA==',
'kidcasB0te7i0jK0fmRIGHSm0mYhdLTaiGkEAiEvLp7dAEHWnuT8n/5bd2V/mqjstQ198iImm1xCmEFu+BHyOz1Mf7vm4LILcrr17y7Ws40Xyx4FOCt8jD03G+jEafpuVJnPiDmaZQXJEpEfekGOvhKGOCtBnT5uatjKEuVWuDA=',
'student'
);

/* --- 19 ---  - password: greatwall */

INSERT INTO users (user_id, username, email, password, salt, role) VALUES
(1029,
'zmendelson', 
'floridagatorssuck@gmail.com',
'FjZDm+sndmsdEDwNtfr6NA==',
'kidcasB0te7i0jK0fmRIGHSm0mYhdLTaiGkEAiEvLp7dAEHWnuT8n/5bd2V/mqjstQ198iImm1xCmEFu+BHyOz1Mf7vm4LILcrr17y7Ws40Xyx4FOCt8jD03G+jEafpuVJnPiDmaZQXJEpEfekGOvhKGOCtBnT5uatjKEuVWuDA=',
'student'
);

/* --- 20 --- Damar - password: greatwall */

INSERT INTO users (user_id, username, email, password, salt, role) VALUES
(1030,
'dadams', 
'bigdadams@gmail.com',
'FjZDm+sndmsdEDwNtfr6NA==',
'kidcasB0te7i0jK0fmRIGHSm0mYhdLTaiGkEAiEvLp7dAEHWnuT8n/5bd2V/mqjstQ198iImm1xCmEFu+BHyOz1Mf7vm4LILcrr17y7Ws40Xyx4FOCt8jD03G+jEafpuVJnPiDmaZQXJEpEfekGOvhKGOCtBnT5uatjKEuVWuDA=',
'student'
);

/* --- 21 --- Carl - password: greatwall */

INSERT INTO users (user_id, username, email, password, salt, role) VALUES
(1031,
'chollisportier', 
'carltherb@gmail.com',
'FjZDm+sndmsdEDwNtfr6NA==',
'kidcasB0te7i0jK0fmRIGHSm0mYhdLTaiGkEAiEvLp7dAEHWnuT8n/5bd2V/mqjstQ198iImm1xCmEFu+BHyOz1Mf7vm4LILcrr17y7Ws40Xyx4FOCt8jD03G+jEafpuVJnPiDmaZQXJEpEfekGOvhKGOCtBnT5uatjKEuVWuDA=',
'student'
);

/* --- 22 --- Madeline - password: greatwall */

INSERT INTO users (user_id, username, email, password, salt, role) VALUES
(1032,
'muribes', 
'madelineuribes@gmail.com',
'FjZDm+sndmsdEDwNtfr6NA==',
'kidcasB0te7i0jK0fmRIGHSm0mYhdLTaiGkEAiEvLp7dAEHWnuT8n/5bd2V/mqjstQ198iImm1xCmEFu+BHyOz1Mf7vm4LILcrr17y7Ws40Xyx4FOCt8jD03G+jEafpuVJnPiDmaZQXJEpEfekGOvhKGOCtBnT5uatjKEuVWuDA=',
'student'
);


INSERT INTO student (student_id, student_first_name, student_last_name, student_email, student_linkedin_url, student_img_url)
VALUES (2001,
'Matt',
'Stuart', 
'mstuart85@gmail.com',
'https://linkedin.com/in/mattstuart85',
'https://media.licdn.com/dms/image/C4E03AQE1BPSfnqNibA/profile-displayphoto-shrink_200_200/0?e=1582156800&v=beta&t=9YIeBVyHp03hg3ur_3w3aFjSLBOODmW3Uoc34oB2vck'
);

INSERT INTO student (student_id, student_first_name, student_last_name, student_email, student_linkedin_url, student_img_url)
VALUES (2002,
'Kirsten',
'Lund',
'kirsten.d.lund@gmail.com',
'https://linkedin.com/in/klund',
'https://media.licdn.com/dms/image/C4E03AQH2a6DY-9msLQ/profile-displayphoto-shrink_200_200/0?e=1582156800&v=beta&t=bXwaBZ6hb_rNWCvZEHndKgAMWNudoCDu0AR0qOeWdr8'
);

INSERT INTO student (student_id, student_first_name, student_last_name, student_email, student_linkedin_url, student_img_url)
VALUES (2003,
'Guan',
'He',
'heguanelvis@gmail.com',
'https://linkedin.com/in/guan-he',
'https://media.licdn.com/dms/image/C5603AQFoc7d6lI89sQ/profile-displayphoto-shrink_200_200/0?e=1582156800&v=beta&t=PV-Pf3bCluZcBkxXLdOPZRzVZYilEnKgY4xHhuI3BXc'
);

INSERT INTO student (student_id, student_first_name, student_last_name, student_email, student_linkedin_url, student_img_url)
VALUES (2004,
'Alicia',
'Filippis',
'aliciafilippis@gmail.com',
'https://linkedin.com/in/alicia-filippis',
'https://media.licdn.com/dms/image/C4E03AQEBHywLsORZlg/profile-displayphoto-shrink_200_200/0?e=1582156800&v=beta&t=qckXJt3bAAXWi9jWTQAX_1McObIp5OLx18aqbzNguo8'
);

INSERT INTO student (student_id, student_first_name, student_last_name, student_email, student_linkedin_url, student_img_url)
VALUES (2005,
'Kelly',
'Flood',
'kellyflood@gmail.com',
'https://linkedin.com/in/kelly-flood',
'https://media.licdn.com/dms/image/C4D03AQEaNpnu8wEzbw/profile-displayphoto-shrink_200_200/0?e=1582156800&v=beta&t=8AaM-loG2_ybyUT8qqdnGUKQoUWF63PNrQIQ_79fqfg'
);

INSERT INTO student (student_id, student_first_name, student_last_name, student_email, student_linkedin_url, student_img_url)
VALUES (2006,
'Chris',
'Nichols',
'ChrisNichols@gmail.com',
'https://linkedin.com/in/christophernichols',
'https://media.licdn.com/dms/image/C4E03AQGEib3NY4db9w/profile-displayphoto-shrink_200_200/0?e=1582156800&v=beta&t=yEu54YQfPZoLxeoyGKei_jjF5RmCCIUnDLkgpN2rL7k'
);

INSERT INTO student (student_id, student_first_name, student_last_name, student_email, student_linkedin_url, student_img_url)
VALUES (2007,
'Jackie',
'Gordin',
'jackiegordin@gmail.com',
'https://linkedin.com/in/jacquelinegordin',
'https://media.licdn.com/dms/image/C4E03AQFeveuQNIBnTw/profile-displayphoto-shrink_200_200/0?e=1582156800&v=beta&t=E11fKCXHB0pF2sP-D61Uah25x9fm48BoRURWl91Emqw'
);

INSERT INTO student (student_id, student_first_name, student_last_name, student_email, student_linkedin_url, student_img_url)
VALUES (2008,
'Nathan',
'Newcomb',
'nathannewcomb@gmail.com',
'https://linkedin.com/in/nathannewcomb',
'https://media.licdn.com/dms/image/C4E03AQFzh-SG8s9jsg/profile-displayphoto-shrink_200_200/0?e=1582156800&v=beta&t=B5nGriFAGtZ0dsDseTAgBTxVPKO1cncubXIdAbcBQ_Q'
);

INSERT INTO student (student_id, student_first_name, student_last_name, student_email, student_linkedin_url, student_img_url)
VALUES (2009,
'Chris',
'Day',
'chrisday@gmail.com',
'https://linkedin.com/in/chrismontyday',
'https://media.licdn.com/dms/image/C4E03AQHux5Eokst8tw/profile-displayphoto-shrink_200_200/0?e=1582156800&v=beta&t=KViZ3KAiXRlckBknI_mVL1xSirjvj5uvWMTdYSGZzrI'
);

INSERT INTO student (student_id, student_first_name, student_last_name, student_email, student_linkedin_url, student_img_url)
VALUES (2010,
'John-Paul',
'Ahme',
'johnpaulahme@gmail.com',
'https://linkedin.com/in/ahme',
'https://media.licdn.com/dms/image/C5603AQEErMhg5NBD9g/profile-displayphoto-shrink_200_200/0?e=1582156800&v=beta&t=0A5Au8a4a70KDmsfFGxbwPxxKfMlPZHSe5FroZuFR8k'
);

INSERT INTO student (student_id, student_first_name, student_last_name, student_email, student_linkedin_url, student_img_url)
VALUES (2011,
'Austin',
'Grant',
'imdjaustin@gmail.com',
'https://linkedin.com/in/austinmgrant',
'https://media.licdn.com/dms/image/C4E03AQEevt09l7w3Lw/profile-displayphoto-shrink_200_200/0?e=1582156800&v=beta&t=byy506nmZ8Yt9cSDV7wnTheaV_zg-dJp_SIksiYbexk'
);

INSERT INTO student (student_id, student_first_name, student_last_name, student_email, student_linkedin_url, student_img_url)
VALUES (2012,
'Max',
'Evans',
'maxevans@gmail.com',
'https://linkedin.com/in/max-evans523',
'https://media.licdn.com/dms/image/C4E03AQFS0eK29-ezLA/profile-displayphoto-shrink_200_200/0?e=1582156800&v=beta&t=l2zugtzhDXWcPw5Jju2EPxamo-5L2wnbvEEU6WPgmvA'
);

INSERT INTO student (student_id, student_first_name, student_last_name, student_email, student_linkedin_url, student_img_url)
VALUES (2013,
'Tom',
'Bryson',
'tommybryson@gmail.com',
'https://linkedin.com/in/tombrysontech',
'https://media.licdn.com/dms/image/C5603AQHafFHl_ks0Ew/profile-displayphoto-shrink_200_200/0?e=1582156800&v=beta&t=iO8_yDUybrCrfKxveXM5Y4qC-JOo-3VpixyjKsogSMc'
);

INSERT INTO student (student_id, student_first_name, student_last_name, student_email, student_linkedin_url, student_img_url)
VALUES (2014,
'Shawn',
'Miller',
'shawnmiller16@gmail.com',
'https://linkedin.com/in/s-tj-miller',
'https://media.licdn.com/dms/image/C4E03AQF0xHALwFVCbA/profile-displayphoto-shrink_200_200/0?e=1582156800&v=beta&t=rEUF9L5B0SSQRUX0nTQrF-9rowW_Q8AzDYyQik2o3JE'
);

INSERT INTO student (student_id, student_first_name, student_last_name, student_email, student_linkedin_url, student_img_url)
VALUES (2015,
'Tom',
'Phillips',
'longhairtom@gmail.com',
'https://linkedin.com/in/tomphillipsmusic',
'https://media.licdn.com/dms/image/C4D03AQFONakgKYEXEA/profile-displayphoto-shrink_200_200/0?e=1582156800&v=beta&t=GDj6GFoSSztZcf9Mrgb7JmyiWD-la8WDTRAp4h1ktas'
);

INSERT INTO student (student_id, student_first_name, student_last_name, student_email, student_linkedin_url, student_img_url)
VALUES (2016,
'Amyre',
'Vincent',
'amyrevincent@gmail.com',
'https://linkedin.com/in/amyre-vincent',
'https://media.licdn.com/dms/image/C4E03AQHHxWg9vUMMkA/profile-displayphoto-shrink_200_200/0?e=1582156800&v=beta&t=K9n-OuAyAMl7LIBxaI3Gx7MQGnIEEfxgWpPWkb35V5E'
);

INSERT INTO student (student_id, student_first_name, student_last_name, student_email, student_linkedin_url, student_img_url)
VALUES (2017,
'Ryan',
'Mangahas',
'bigryanm@gmail.com',
'https://linkedin.com/in/ryanmangahas',
'https://media.licdn.com/dms/image/C4E03AQF43FRfcBITdQ/profile-displayphoto-shrink_200_200/0?e=1582156800&v=beta&t=5QD2CESewN8UEX5oHyI8zG6h2ZlYGhDX7qfqEobw7cI'
);

INSERT INTO student (student_id, student_first_name, student_last_name, student_email, student_linkedin_url, student_img_url)
VALUES (2018,
'Audrey',
'Lambright',
'audreyl@gmail.com',
'https://linkedin.com/in/audreylambright',
'https://media.licdn.com/dms/image/C4E03AQGuaIHffy7RSQ/profile-displayphoto-shrink_200_200/0?e=1582156800&v=beta&t=oB_8rEBpXMzKonFf-N2xXCH36hNk24RYmCF3AJ2G5D4'
);

INSERT INTO student (student_id, student_first_name, student_last_name, student_email, student_linkedin_url, student_img_url)
VALUES (2019,
'Zach',
'Mendelson',
'floridagatorssuck@gmail.com',
'https://linkedin.com/in/zach-mendelson',
'https://media.licdn.com/dms/image/C4D03AQF_2-E8wgfUJg/profile-displayphoto-shrink_200_200/0?e=1582156800&v=beta&t=czyusuA_ZDPpaytBIfurla3UP2bXupSWmymgq6xyYFs'
);

INSERT INTO student (student_id, student_first_name, student_last_name, student_email, student_linkedin_url, student_img_url)
VALUES (2020,
'Damar',
'Adams',
'bigDAdams@gmail.com',
'https://linkedin.com/in/damar-k-adams',
'https://media.licdn.com/dms/image/C4E03AQHeq_Clpysnjg/profile-displayphoto-shrink_200_200/0?e=1582156800&v=beta&t=ASWfm7bkpgK52Oiph2T51fz-xt_q78TjWA-qfnmSlJE'
);

INSERT INTO student (student_id, student_first_name, student_last_name, student_email, student_linkedin_url, student_img_url)
VALUES (2021,
'Carl',
'Portis-Hollier',
'carltherb@gmail.com',
'https://linkedin.com/in/carlportishollier',
'https://media.licdn.com/dms/image/C4E03AQG89j-t-_sMjg/profile-displayphoto-shrink_200_200/0?e=1582156800&v=beta&t=VzzaKMyTZddqf3tLsuBd33G-au6OcrtYaePJAoo1DVE'
);

INSERT INTO student (student_id, student_first_name, student_last_name, student_email, student_linkedin_url, student_img_url)
VALUES (2022,
'Madeline',
'Uribes',
'madelineuribes@gmail.com',
'https://linkedin.com/in/madeline-uribes',
'https://media.licdn.com/dms/image/C4E03AQHQDoainmZR5A/profile-displayphoto-shrink_200_200/0?e=1582156800&v=beta&t=tD_cIHDS5RnM_XbGjX-rG4PcFd4FoMXRcrgJeSqVTrU'
);


INSERT INTO student_user (user_id, student_id)
VALUES (1011, 2001);

INSERT INTO student_user (user_id, student_id)
VALUES (1012, 2002);

INSERT INTO student_user (user_id, student_id)
VALUES (1013, 2003);

INSERT INTO student_user (user_id, student_id)
VALUES (1014, 2004);

INSERT INTO student_user (user_id, student_id)
VALUES (1015, 2005);

INSERT INTO student_user (user_id, student_id)
VALUES (1016, 2006);

INSERT INTO student_user (user_id, student_id)
VALUES (1017, 2007);

INSERT INTO student_user (user_id, student_id)
VALUES (1018, 2008);

INSERT INTO student_user (user_id, student_id)
VALUES (1019, 2009);

INSERT INTO student_user (user_id, student_id)
VALUES (1020, 2010);

INSERT INTO student_user (user_id, student_id)
VALUES (1021, 2011);

INSERT INTO student_user (user_id, student_id)
VALUES (1022, 2012);

INSERT INTO student_user (user_id, student_id)
VALUES (1023, 2013);

INSERT INTO student_user (user_id, student_id)
VALUES (1024, 2014);

INSERT INTO student_user (user_id, student_id)
VALUES (1025, 2015);

INSERT INTO student_user (user_id, student_id)
VALUES (1026, 2016);

INSERT INTO student_user (user_id, student_id)
VALUES (1027, 2017);

INSERT INTO student_user (user_id, student_id)
VALUES (1028, 2018);

INSERT INTO student_user (user_id, student_id)
VALUES (1029, 2019);

INSERT INTO student_user (user_id, student_id)
VALUES (1030, 2020);

INSERT INTO student_user (user_id, student_id)
VALUES (1031, 2021);

INSERT INTO student_user (user_id, student_id)
VALUES (1032, 2022);



/* --- 1 --- Matt ------------- */

INSERT INTO ranking (student_id, employer_id, ranking) 
VALUES (2001, 2001, 1);

INSERT INTO ranking (student_id, employer_id, ranking) 
VALUES (2001, 2002, 2);

INSERT INTO ranking (student_id, employer_id, ranking) 
VALUES (2001, 2006, 3);

INSERT INTO ranking (student_id, employer_id, ranking) 
VALUES (2001, 2005, 4);


/* --- 2 --- Kirsten ------------- */

INSERT INTO ranking (student_id, employer_id, ranking) 
VALUES (2002, 2008, 1);

INSERT INTO ranking (student_id, employer_id, ranking) 
VALUES (2002, 2003, 2);

INSERT INTO ranking (student_id, employer_id, ranking) 
VALUES (2002, 2001, 3);

INSERT INTO ranking (student_id, employer_id, ranking) 
VALUES (2002, 2005, 4);

/* --- 3 --- Guan ------------- */

INSERT INTO ranking (student_id, employer_id, ranking) 
VALUES (2003, 2007, 1);

INSERT INTO ranking (student_id, employer_id, ranking) 
VALUES (2003, 2001, 2);

INSERT INTO ranking (student_id, employer_id, ranking) 
VALUES (2003, 2002, 3);

INSERT INTO ranking (student_id, employer_id, ranking) 
VALUES (2003, 2003, 4);

/* --- 4 --- Alicia ------------- */

INSERT INTO ranking (student_id, employer_id, ranking) 
VALUES (2004, 2007, 1);

INSERT INTO ranking (student_id, employer_id, ranking) 
VALUES (2004, 2010, 2);

INSERT INTO ranking (student_id, employer_id, ranking) 
VALUES (2004, 2005, 3);

INSERT INTO ranking (student_id, employer_id, ranking) 
VALUES (2004, 2008, 4);

/* --- 5 --- Kelly ------------- */

INSERT INTO ranking (student_id, employer_id, ranking) 
VALUES (2005, 2009, 1);

INSERT INTO ranking (student_id, employer_id, ranking) 
VALUES (2005, 2001, 2);

INSERT INTO ranking (student_id, employer_id, ranking) 
VALUES (2005, 2002, 3);

INSERT INTO ranking (student_id, employer_id, ranking) 
VALUES (2005, 2008, 4);

/* --- 6--- Chris N. ------------- */

INSERT INTO ranking (student_id, employer_id, ranking) 
VALUES (2006, 2008, 1);

INSERT INTO ranking (student_id, employer_id, ranking) 
VALUES (2006, 2007, 2);

INSERT INTO ranking (student_id, employer_id, ranking) 
VALUES (2006, 2009, 3);

INSERT INTO ranking (student_id, employer_id, ranking) 
VALUES (2006, 2003, 4);

/* --- 7 --- Jackie ------------- */

INSERT INTO ranking (student_id, employer_id, ranking) 
VALUES (2007, 2003, 1);

INSERT INTO ranking (student_id, employer_id, ranking) 
VALUES (2007, 2009, 2);

INSERT INTO ranking (student_id, employer_id, ranking) 
VALUES (2007, 2001, 3);

INSERT INTO ranking (student_id, employer_id, ranking) 
VALUES (2007, 2008, 4);

/* --- 8 --- Nathan ------------- */

INSERT INTO ranking (student_id, employer_id, ranking) 
VALUES (2008, 2001, 1);

INSERT INTO ranking (student_id, employer_id, ranking) 
VALUES (2008, 2008, 2);

INSERT INTO ranking (student_id, employer_id, ranking) 
VALUES (2008, 2010, 3);

INSERT INTO ranking (student_id, employer_id, ranking) 
VALUES (2008, 2002, 4);

/* --- 9--- Chris D. ------------- */

INSERT INTO ranking (student_id, employer_id, ranking) 
VALUES (2009, 2005, 1);

INSERT INTO ranking (student_id, employer_id, ranking) 
VALUES (2009, 2002, 2);

INSERT INTO ranking (student_id, employer_id, ranking) 
VALUES (2009, 2001, 3);

INSERT INTO ranking (student_id, employer_id, ranking) 
VALUES (2009, 2010, 4);

/* --- 10 --- John-Paul ------------- */

INSERT INTO ranking (student_id, employer_id, ranking) 
VALUES (2010, 2001, 1);

INSERT INTO ranking (student_id, employer_id, ranking) 
VALUES (2010, 2009, 2);

INSERT INTO ranking (student_id, employer_id, ranking) 
VALUES (2010, 2003, 3);

INSERT INTO ranking (student_id, employer_id, ranking) 
VALUES (2010, 2005, 4);

/* --- 11 --- Austin ------------- */

INSERT INTO ranking (student_id, employer_id, ranking) 
VALUES (2011, 2008, 1);

INSERT INTO ranking (student_id, employer_id, ranking) 
VALUES (2011, 2001, 2);

INSERT INTO ranking (student_id, employer_id, ranking) 
VALUES (2011, 2010, 3);

INSERT INTO ranking (student_id, employer_id, ranking) 
VALUES (2011, 2005, 4);

/* --- 12 --- Max ------------- */

INSERT INTO ranking (student_id, employer_id, ranking) 
VALUES (2012, 2002, 1);

INSERT INTO ranking (student_id, employer_id, ranking) 
VALUES (2012, 2001, 2);

INSERT INTO ranking (student_id, employer_id, ranking) 
VALUES (2012, 2007, 3);

INSERT INTO ranking (student_id, employer_id, ranking) 
VALUES (2012, 2008, 4);

/* --- 13 --- Tom B. ------------- */

INSERT INTO ranking (student_id, employer_id, ranking) 
VALUES (2013, 2007, 1);

INSERT INTO ranking (student_id, employer_id, ranking) 
VALUES (2013, 2010, 2);

INSERT INTO ranking (student_id, employer_id, ranking) 
VALUES (2013, 2002, 3);

INSERT INTO ranking (student_id, employer_id, ranking) 
VALUES (2013, 2001, 4);

/* --- 14 --- Shawn ------------- */

INSERT INTO ranking (student_id, employer_id, ranking) 
VALUES (2014, 2001, 1);

INSERT INTO ranking (student_id, employer_id, ranking) 
VALUES (2014, 2002, 2);

INSERT INTO ranking (student_id, employer_id, ranking) 
VALUES (2014, 2006, 3);

INSERT INTO ranking (student_id, employer_id, ranking) 
VALUES (2014, 2007, 4);

/* --- 15--- Tom P. ------------- */

INSERT INTO ranking (student_id, employer_id, ranking) 
VALUES (2015, 2002, 1);

INSERT INTO ranking (student_id, employer_id, ranking) 
VALUES (2015, 2001, 2);

INSERT INTO ranking (student_id, employer_id, ranking) 
VALUES (2015, 2007, 3);

INSERT INTO ranking (student_id, employer_id, ranking) 
VALUES (2015, 2004, 4);

/* --- 16 --- Amyre ------------- */

INSERT INTO ranking (student_id, employer_id, ranking) 
VALUES (2016, 2001, 1);

INSERT INTO ranking (student_id, employer_id, ranking) 
VALUES (2016, 2007, 2);

INSERT INTO ranking (student_id, employer_id, ranking) 
VALUES (2016, 2005, 3);

INSERT INTO ranking (student_id, employer_id, ranking) 
VALUES (2016, 2006, 4);

/* --- 17 --- Ryan ------------- */

INSERT INTO ranking (student_id, employer_id, ranking) 
VALUES (2017, 2007, 1);

INSERT INTO ranking (student_id, employer_id, ranking) 
VALUES (2017, 2008, 2);

INSERT INTO ranking (student_id, employer_id, ranking) 
VALUES (2017, 2001, 3);

INSERT INTO ranking (student_id, employer_id, ranking) 
VALUES (2017, 2009, 4);

/* --- 18 --- Audrey ------------- */

INSERT INTO ranking (student_id, employer_id, ranking) 
VALUES (2018, 2003, 1);

INSERT INTO ranking (student_id, employer_id, ranking) 
VALUES (2018, 2001, 2);

INSERT INTO ranking (student_id, employer_id, ranking) 
VALUES (2018, 2005, 3);

INSERT INTO ranking (student_id, employer_id, ranking) 
VALUES (2018, 2007, 4);

/* --- 19 --- Zach ------------- */

INSERT INTO ranking (student_id, employer_id, ranking) 
VALUES (2019, 2001, 1);

INSERT INTO ranking (student_id, employer_id, ranking) 
VALUES (2019, 2008, 2);

INSERT INTO ranking (student_id, employer_id, ranking) 
VALUES (2019, 2004, 3);

INSERT INTO ranking (student_id, employer_id, ranking) 
VALUES (2019, 2005, 4);

/* ---  20 ---  -----Damar-------- */

INSERT INTO ranking (student_id, employer_id, ranking) 
VALUES (2020, 2007, 1);

INSERT INTO ranking (student_id, employer_id, ranking) 
VALUES (2020, 2010, 2);

INSERT INTO ranking (student_id, employer_id, ranking) 
VALUES (2020, 2008, 3);

INSERT INTO ranking (student_id, employer_id, ranking) 
VALUES (2020, 2005, 4);

/* --- 21--- Carl ------------- */

INSERT INTO ranking (student_id, employer_id, ranking) 
VALUES (2021, 2009, 1);

INSERT INTO ranking (student_id, employer_id, ranking) 
VALUES (2021, 2001, 2);

INSERT INTO ranking (student_id, employer_id, ranking) 
VALUES (2021, 2005, 3);

INSERT INTO ranking (student_id, employer_id, ranking) 
VALUES (2021, 2010, 4);

/* --- 22 ---  -----Madeline-------- */

INSERT INTO ranking (student_id, employer_id, ranking) 
VALUES (2022, 2001, 1);

INSERT INTO ranking (student_id, employer_id, ranking) 
VALUES (2022, 2007, 2);

INSERT INTO ranking (student_id, employer_id, ranking) 
VALUES (2022, 2003, 3);

INSERT INTO ranking (student_id, employer_id, ranking) 
VALUES (2022, 2010, 4);

/*---Binford---*/

INSERT INTO schedule (student_id, employer_id, appointment_datetime)
VALUES (2012, 2002, 1), (2015, 2002, 2), (2009, 2002, 3), (2001, 2002, 4), (2003, 2002, 6), (2014, 2002, 7), (2005, 2002, 8), (2021, 2002, 9), (2012, 2002, 10);

INSERT INTO schedule (student_id, employer_id, appointment_datetime)
VALUES (2016, 2001, 1), (2022, 2001, 2), (2001, 2001, 3), (2008, 2001, 4), (2014, 2001, 6), (2019, 2001, 7), (2018, 2001, 8), (2011, 2001, 1), (2021, 2001, 10);

INSERT INTO schedule (student_id, employer_id, appointment_datetime)
VALUES (2018, 2003, 1), (2007, 2003, 2), (2022, 2003, 3), (2002, 2003, 4), (2003, 2003, 7);

INSERT INTO schedule (student_id, employer_id, appointment_datetime)
VALUES (2021, 2004, 1), (2005, 2004, 2), (2007, 2004, 3), (2010, 2004, 4), (2006, 2004, 6), (2017, 2004, 7);

INSERT INTO schedule (student_id, employer_id, appointment_datetime)
VALUES (2011, 2008, 1), (2006, 2008, 2), (2002, 2008, 3), (2017, 2008, 4), (2008, 2008, 6), (2020, 2008, 7), (2019, 2008, 8), (2010, 2008, 9), (2004, 2008, 10);

/*---Spacely Sprockets*/
INSERT INTO schedule (student_id, employer_id, appointment_datetime)
VALUES  (2013, 2010, 1), (2004, 2010, 2), (2008, 2010, 3), (2009, 2010, 4), (2022, 2010, 6), (2011, 2010, 7);

/*---Wayne Enterprises*/
INSERT INTO schedule (student_id, employer_id, appointment_datetime)
VALUES (2009,  2005, 1), (2016,  2005, 2), (2018, 2005, 3), (2004, 2005, 4), (2021, 2005, 6), (2011, 2005, 7), (2020, 2005, 8), (2019, 2005, 9);

/*---Hooli---*/
INSERT INTO schedule (student_id, employer_id, appointment_datetime)  
VALUES (2004, 2007, 1), (2020, 2007, 2), (2003, 2007, 3), (2017, 2007, 4), (2013, 2007, 6), (2016, 2007, 7), (2006, 2007, 8), (2022, 2007, 9), (2012, 2007, 10);

/*---Acme---*/
INSERT INTO schedule (student_id, employer_id, appointment_datetime) 
VALUES (2005, 2006, 1), (2002, 2006, 2), (2001, 2006, 3), (2014, 2006, 4), (2016, 2006, 6), (2022, 2006, 7), (2013, 2006, 8), (2015, 2006, 9);

/*---Lex Corp---*/
INSERT INTO schedule (student_id, employer_id, appointment_datetime) 
VALUES (2017, 2004, 1), (2015, 2004, 2), (2019, 2004, 3), (2018, 2004, 4), (2007, 2004, 6), (2010, 2004, 7), (2005, 2004, 8), (2012, 2004, 9), (2008, 2004, 10); 