/**
 * Created by vipul on 4/23/2016.
 */

var Sequelize = require('sequelize');

var sequelize = new Sequelize('DBFiverr', 'worknet', 'work123', {
    host: 'localhost',
    dialect: "mssql", // or 'sqlite', 'postgres', 'mariadb'
    port:    1433, // or 5432 (for postgres)
    dialectOptions: {
        instanceName: 'SQLEXPRESS'
    }
});
sequelize
    .authenticate()
    .then(function(err) {
        console.log('Connection has been established successfully.');
        //var query = "exec dbo.sp_insert_person 'vipul.sarin@google.com','abcde','Vipul','Sarin'";
       //var query = "select [dbo].[udf_authenticate]('abc@bcd.com','pass')";
       //var query = "exec dbo.sp_retrieve_new_requests 'mayteh.kendall@yahoo.com',3"
        /*sequelize.query(query, { type: sequelize.QueryTypes.SELECT})
            .then(function(users) {
            })*/

    }, function (err) {
        console.log('Unable to connect to the database:', err);
    });


exports.getSequelize = sequelize;