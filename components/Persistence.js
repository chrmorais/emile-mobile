.import QtQuick.LocalStorage 2.0 as Storage

var debug = 1;

function getDatabase() {
    return Storage.LocalStorage.openDatabaseSync("Emile Mobile", "1.0", "HelloAppDatabase", 999999999)
}

function set(setting, value) {
    var result = ""
    try {
        getDatabase().transaction(function(tx) {
            tx.executeSql('CREATE TABLE IF NOT EXISTS settings(setting TEXT UNIQUE, value TEXT)')
            var rs = tx.executeSql('INSERT OR REPLACE INTO settings VALUES (?,?);', [setting,value])
            if (rs.rowsAffected > 0)
                result = "OK"
            else
                result = "Error"
        });
    } catch (e) {
        if (debug) {
            console.log("Database error!")
            console.log(e)
        }
    }
    return result
}

function get(setting, default_value) {
    var result = ""
    try {
        getDatabase().transaction(function(tx) {
            var rs = tx.executeSql('SELECT value FROM settings WHERE setting=?;', [setting])
            if (rs.rows.length > 0)
                result = rs.rows.item(0).value
            else
                result = default_value
        })
    } catch (e) {
        if (debug) {
            console.log("Database error!")
            console.log(e)
        }
        if (default_value)
            result = default_value
        else
            result = ""
    }
    return result
}
