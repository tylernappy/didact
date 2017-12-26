'use strict';

const createApp = require('./app.js');

const config = {
  port: process.env.PORT || 3000,
  statsd: {
    host: process.env.STATSD_PORT_8125_UDP_ADDR || '127.0.0.1',
    port: process.env.STATSD_PORT_8125_UDP_PORT || '8125'
  }
};

const app = createApp(config.port, config.statsd);
app.listen(config.port);
console.log(`App serving on port ${config.port}`);
