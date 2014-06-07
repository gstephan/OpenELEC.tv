<?php
	// Create connection
  $sql = mysqli_connect("localhost","root","123","test");

	// Check connection
  if (mysqli_connect_errno()) {
    echo "Failed to connect to MySQL: " . mysqli_connect_error();
  }

	/* print server version */
	printf("Server version: %s\n", $sql->server_info);
	echo "<p>";

	$query = "SHOW TABLES FROM information_schema";
	$result = $sql->query($query);     
	if (!$result) {
	  printf("Query failed: %s\n", $mysqli->error);
	  exit;
	}      
	
	while($row = $result->fetch_assoc()){
		print_r($row);
	  echo $row['username'] . '<br />';
	}
	
	while($row = $result->fetch_row()) {
	  $rows[]=$row;
	}
	$result->close();
	$sql->close();




	$connect=mysql_connect("localhost","root","123") or die("Unable to Connect");
	//$connect=mysql_connect("127.0.0.1:3306","root","123") or die("Unable to Connect");
	mysql_select_db("information_schema") or die("Could not open the db");
	$showtablequery="SHOW TABLES FROM information_schema";
	
	$query_result=mysql_query($showtablequery);
	
	while($showtablerow = mysql_fetch_array($query_result)) {
		echo $showtablerow[0]." ";
		echo "<p>";
	} 
?>
