const express = require('express');

const axios = require('axios');

const app = express();

const PORT = 3000;



app.use(express.static('public'));



app.get('/qualifying', async (req, res) => {

  const season = req.query.season || '2025';

  const race = req.query.race || '1';



  try {

    const response = await axios.post('http://127.0.0.1:8008', {

      statements: [

        `SELECT season as SEASON
                ,round as RACE
                ,driver_id as DRIVER
                ,constructor_name as CONSTRUCTOR
                ,best_qual_time as QUALIFICATION_TIME
                ,formatted_diff as TIME_DIFF
         FROM V_QUALIFICATION_TIME_DIFF
         WHERE season = '${season}' AND round = '${race}';`
      ]

    });



    const rows = response.data[0].results.rows;

    const columns = response.data[0].results.columns;



    res.json({ columns, rows });

  } catch (error) {

    console.error(error.message);

    res.status(500).send('Error querying libSQL');

  }

});

app.get('/raceresults', async (req, res) => {
  const season = req.query.season || '2025';
  const race = req.query.race || '1';

  try {
    const response = await axios.post('http://127.0.0.1:8008', {
      statements: [`
        SELECT season AS SEASON,
               round AS ROUND,
               race_name AS RACE_NAME,
               race_date AS RACE_DATE,
               position AS POSITION,
               points AS POINTS,
               grid AS GRID,
               laps AS LAPS,
               status AS STATUS,
               driver_first_name || ' ' || driver_last_name AS DRIVER,
               driver_nationality AS DRIVER_NATIONALITY,
               constructor_name AS CONSTRUCTOR,
               race_time AS RACE_TIME
        FROM F1_RACERESULTS
        WHERE season = '${season}' AND round = '${race}'
        ORDER BY position;
      `]
    });

    const rows = response.data[0].results.rows;
    const columns = response.data[0].results.columns;

    res.json({ columns, rows });
  } catch (error) {
    console.error(error.message);
    res.status(500).send('Error querying race results');
  }
});

app.listen(PORT, () => {

  console.log(`Server running at http://localhost:${PORT}`);

});

