<?php
// DB connection info

/*$host = "localhost\sqlexpress";
$user = "PHP";
$pwd = "Toto1234$*";
$db = "registration";*/
$host = "tcp:ipssi-vsts-demo-sql.database.windows.net,1433";
$user = "maxime";
$pwd = "Toto1234$*";
$db = "IPSSI-VSTS-DEMO-SQL-DB";
try{
    $conn = new PDO( "sqlsrv:Server= $host ; Database = $db ", $user, $pwd);
    $conn->setAttribute( PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION );
    $sql = "CREATE TABLE registration_tbl(
    id INT NOT NULL IDENTITY(1,1) 
    PRIMARY KEY(id),
    name VARCHAR(30),
    email VARCHAR(30),
    date DATE)";
    $conn->query($sql);
}
catch(Exception $e){
    die(print_r($e));
}
echo "<h3>Table created.</h3>";
?>