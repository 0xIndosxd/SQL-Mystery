/* Jan 15, 2018 <-- Crime incident */

SELECT * FROM crime_scene_report
WHERE date = 20180115
AND city = 'SQL City'
AND type = 'murder';

/* Security footage shows that there were 2 witnesses. The first witness lives at the last house on "Northwestern Dr". Thesecond witness, named Annabel, lives somewhere on "Franklin Ave".*/

/*
Witness 1 = Last house on "Northwester Dr"
Witness 2 = Annebl, Somewhere in "Franklin Ave"
*/


/* WITNESS 1 */
SELECT * FROM person
WHERE address_street_name = 'Northwestern Dr'
ORDER BY address_number DESC
LIMIT 1;

/* 14887 │ Morty Schapiro │ 118009     │ 4919           │ Northwestern Dr     │ 111564949 */

SELECT * FROM interview
WHERE person_id = (
    SELECT id FROM person
    WHERE address_street_name = 'Northwestern Dr'
    ORDER BY address_number DESC
    LIMIT 1
);

/* Transcript
┌───────────┬──────────────────────────────────────────────────────────────┐
│ person_id │                          transcript                          │
├───────────┼──────────────────────────────────────────────────────────────┤
│ 14887     │ I heard a gunshot and then saw a man run out. He had a "Get  │
│           │ Fit Now Gym" bag. The membership number on the bag started w │
│           │ ith "48Z". Only gold members have those bags. The man got in │
│           │ to a car with a plate that included "H42W".                  │
└───────────┴──────────────────────────────────────────────────────────────┘
Keyword:
- Membership Number "48Z"
- Golden member
- License plate "H42W"
*/

/* Membership Number "48Z%" */
SELECT * FROM get_fit_now_check_in
WHERE membership_id LIKE '48Z%';
/* Multiple Subject */

/* Golden Member */
SELECT * FROM get_fit_now_member
WHERE membership_status = 'gold';
/* A lot of suspect there buddy */

/* License plate "H42W" */
SELECT * FROM drivers_license
WHERE plate_number LIKE '%H42W%';
/* 3 Suspect */




/* SUBQUERY */
/* Connect the membership to get person id*/
SELECT person_id FROM get_fit_now_member
WHERE membership_status = 'gold'
AND id IN
(
    SELECT membership_id FROM get_fit_now_check_in
    WHERE membership_id LIKE '48Z%'
);
/* Two suspect */

/* License ID from plate id */
SELECT id FROM drivers_license
WHERE plate_number LIKE '%H42W%';





/* CONNECTING THE STRING WITH 3 QUERY */
SELECT * FROM person
WHERE id IN
(
    SELECT person_id FROM get_fit_now_member
    WHERE membership_status = 'gold'
    AND id IN
    (
        SELECT membership_id FROM get_fit_now_check_in
        WHERE membership_id LIKE '48Z%'
    )
)
AND license_id IN
(
    SELECT id FROM drivers_license
    WHERE plate_number LIKE '%H42W%'
);

/*
┌───────┬───────────────┬────────────┬────────────────┬───────────────────────┬───────────┐
│  id   │     name      │ license_id │ address_number │  address_street_name  │    ssn    │
├───────┼───────────────┼────────────┼────────────────┼───────────────────────┼───────────┤
│ 67318 │ Jeremy Bowers │ 423327     │ 530            │ Washington Pl, Apt 3A │ 871539279 │
└───────┴───────────────┴────────────┴────────────────┴───────────────────────┴───────────┘

CASE CLOSED
*/

INSERT INTO solution VALUES (1, 'Jeremy Bowers');




/* WITNESS 2 */
SELECT * FROM person
WHERE name LIKE 'Annabel%'
/* AND address_street_name = 'Franklin Ave'; */

/*
┌───────┬────────────────┬────────────┬────────────────┬─────────────────────┬───────────┐
│  id   │      name      │ license_id │ address_number │ address_street_name │    ssn    │
├───────┼────────────────┼────────────┼────────────────┼─────────────────────┼───────────┤
│ 16371 │ Annabel Miller │ 490173     │ 103            │ Franklin Ave        │ 318771143 │
└───────┴────────────────┴────────────┴────────────────┴─────────────────────┴───────────┘
*/

/* Transcript interview */
SELECT * FROM interview
WHERE person_id =
(
    SELECT id FROM person
    WHERE name LIKE 'Annabel%'
);

/*
┌───────────┬──────────────────────────────────────────────────────────────┐
│ person_id │                          transcript                          │
├───────────┼──────────────────────────────────────────────────────────────┤
│ 16371     │ I saw the murder happen, and I recognized the killer from my │
│           │  gym when I was working out last week on January the 9th.    │
└───────────┴──────────────────────────────────────────────────────────────┘
*/

/* Selecting person with check in register at January 9th 2018 */
SELECT * FROM person
WHERE id IN
(
    SELECT person_id FROM get_fit_now_member
    WHERE id IN
    (
        SELECT membership_id FROM get_fit_now_check_in
        WHERE check_in_date = 20180109
    )
);

/* Comparing with incident */
/* Select person with check in register when the crime happens */
SELECT * FROM person
WHERE id IN
(
    SELECT person_id FROM get_fit_now_member
    WHERE id IN
    (
        SELECT membership_id FROM get_fit_now_check_in
        WHERE check_in_date = 20180115
    )
);
/* Data unclear */


/* Checking "Jeremy Bowers" Facebook */
SELECT * FROM facebook_event_checkin
WHERE person_id =
(
    SELECT id FROM person
    WHERE name = 'Jeremy Bowers'
);

/*
┌───────────┬──────────┬────────────────────────┬──────────┐
│ person_id │ event_id │       event_name       │   date   │
├───────────┼──────────┼────────────────────────┼──────────┤
│ 67318     │ 4719     │ The Funky Grooves Tour │ 20180115 │       SUPSICIOUS Same date as the incident
│ 67318     │ 1143     │ SQL Symphony Concert   │ 20171206 │
└───────────┴──────────┴────────────────────────┴──────────┘
*/

/* Who are at the event */
SELECT * FROM person
WHERE id IN 
(
    SELECT person_id FROM facebook_event_checkin
    WHERE event_id = 4719
);


/* IT DIDNT HAPPEND IN THE GYM IT HAPPENS IN THE EVENT 
ALL WITNESS AND KILLER ARE IN THE EVENT
*/

/* Interview of Jeremy Bowers the killer */
SELECT * FROM interview
WHERE person_id =
(
    SELECT id FROM person
    WHERE name = 'Jeremy Bowers'
);
/*
┌───────────┬──────────────────────────────────────────────────────────────┐
│ person_id │                          transcript                          │
├───────────┼──────────────────────────────────────────────────────────────┤
│ 67318     │ I was hired by a woman with a lot of money. I don't know her │
│           │  name but I know she's around 5'5" (65") or 5'7" (67"). She  │
│           │ has red hair and she drives a Tesla Model S. I know that she │
│           │  attended the SQL Symphony Concert 3 times in December 2017. │
└───────────┴──────────────────────────────────────────────────────────────┘
*/


/* Checking license characteristic */
SELECT id FROM drivers_license
WHERE 
(height = 65 OR height = 66 OR height = 67)
AND gender = 'female'
AND hair_color = 'red'
AND car_make = 'Tesla'
AND car_model = 'Model S';

/* Result 3 suspect */
SELECT * FROM person
WHERE license_id IN
(
    SELECT id FROM drivers_license
    WHERE 
    (height = 65  OR height = 66 OR height = 67)
    AND gender = 'female'
    AND hair_color = 'red'
    AND car_make = 'Tesla'
    AND car_model = 'Model S'
);

/* People who attend the concert 3 times */
SELECT person_id FROM facebook_event_checkin
GROUP BY person_id
HAVING COUNT(*) = 3;


/* Mix query together */
SELECT * FROM person
WHERE license_id IN
(
    SELECT id FROM drivers_license
    WHERE 
    (height = 65  OR height = 66 OR height = 67)
    AND gender = 'female'
    AND hair_color = 'red'
    AND car_make = 'Tesla'
    AND car_model = 'Model S'
)
AND id IN 
(
    SELECT person_id FROM facebook_event_checkin
    GROUP BY person_id
    HAVING COUNT(*) = 3
);

/* CASE CLOSED */
/*
┌───────┬──────────────────┬────────────┬────────────────┬─────────────────────┬───────────┐
│  id   │       name       │ license_id │ address_number │ address_street_name │    ssn    │
├───────┼──────────────────┼────────────┼────────────────┼─────────────────────┼───────────┤
│ 99716 │ Miranda Priestly │ 202298     │ 1883           │ Golden Ave          │ 987756388 │
└───────┴──────────────────┴────────────┴────────────────┴─────────────────────┴───────────┘
*/


INSERT INTO solution VALUES (1, 'Miranda Priestly');