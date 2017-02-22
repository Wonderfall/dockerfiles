const CONFIG = {
  baseURI: '<CONTEXT_PATH>',
  dbCleanInterval: 1000 * 60 * 60,
  dbPath: '/flood-db/',
  floodServerPort: 3000,
  maxHistoryStates: 30,
  pollInterval: 1000 * 5,
  secret: '<FLOOD_SECRET>',
  scgi: {
    host: 'localhost',
    port: 5000,
    socket: true,
    socketPath: '/tmp/rtorrent.sock'
  }
};

module.exports = CONFIG;
