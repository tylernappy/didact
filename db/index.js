'use strict';

module.exports = {
  //
  debugger
  const Pool  = require('pg')
  const connectionString = process.env.DATABASE_URL || 'postgres://localhost/didact';
  const pool = new Pool({
      connectionString: connectionString,
    })

    pool.query('SELECT NOW()', (err, res) => {
      console.log(err, res)
      pool.end()
    })

    const client = new Client({
      connectionString: connectionString,
    })
    client.connect()

    client.query('SELECT NOW()', (err, res) => {
      console.log(err, res)
      client.end()
    })
  //
}
