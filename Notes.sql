/* Jan 15, 2018 <-- Crime incident */

SELECT * FROM crime_scene_report
WHERE date = 20180115;

/* Security footage shows that there were 2 witnesses. The first witness lives at the last house on "Northwestern Dr". Thesecond witness, named Annabel, lives somewhere on "FranklinAve".*/


SELECT * FROM person
WHERE address_street_name = 'Northwestern Dr'
ORDER BY address_number DESC;

SELECT * FROM crime_scene_report
WHERE city = 'FranklinAve';