const express = require('express');
const app = express();
const port = 3000;

app.get('/', (req, res) => {
  res.send('Movie service is running');
});

app.listen(port, () => {
  console.log(`Movie service listening at http://localhost:${port}`);
});
