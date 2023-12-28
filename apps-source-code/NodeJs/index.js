
const express = require('express');

const app = express();
app.use(express.json());

//[2,3,5,6]

app.post('/numbers', async (req, res) => {
  try {
    const { numbers } = req.body;

    const apiUrl = 'http://python-app:5000/sort';

    const response = await fetch(apiUrl, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({ numbers }),
    });

    const responseData = await response.json();

    res.json(responseData);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

app.get('/', async (req, res) => {
  try {
    console.log("Welcome")
    res.json({meaasge: "Hello from Arun"})
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Internal Server Error' });
  }
});


app.listen(3000, () => {
  console.log(`Node.js Service listening at http://localhost:3000`);
});

