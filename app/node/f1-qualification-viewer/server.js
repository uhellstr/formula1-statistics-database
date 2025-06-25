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



app.listen(PORT, () => {

  console.log(`Server running at http://localhost:${PORT}`);

});

