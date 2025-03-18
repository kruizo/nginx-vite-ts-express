require('dotenv').config();

module.exports = {
    port: process.env.PORT,
    db: {
        username: process.env.DB_USER,
        password: process.env.DB_PASS,
        host: process.env.DB
        
    }
}

