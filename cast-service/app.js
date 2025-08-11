const express = require('express');
const app = express();
const port = 8080;

app.get('/', (req, res) => {
  res.send('Cast service is running');
});

app.listen(port, () => {
  console.log(`Cast service listening at http://localhost:${port}`);
});
