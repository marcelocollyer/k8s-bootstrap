const express = require('express');
const axios = require('axios');

const app = express();
const port = process.env.PORT || 80;

const microserviceBUrl = 'http://microservice-b:80';
const microserviceId = 'Microservice-a v2'

app.get('/', async (req, res) => {
    try {
        console.log(`${microserviceId}. calling Microservice B`);
        const response = await axios.get(microserviceBUrl);
        res.send(`${microserviceId}. Response from Microservice B: ${response.data}`);
    } catch (error) {
        res.status(500).send(`${microserviceId}. Failed to fetch data from Microservice B`);
    }
});

app.listen(port, () => {
    console.log(`${microserviceId} listening on port ${port}`);
});
