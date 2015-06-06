<?php
	$formatType = 'text/json';
	$execString = "python interHandle.py ";
	
	if (isset($_GET['service'])) {
		$execString .= " {$_GET['service']}";
	}
	$output = exec($execString);
	
	header("Access-Control-Allow-Origin: *");
	header("Content-Type: {$formatType}");
	echo "{$output}";
?>
