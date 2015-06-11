<?php
	$formatType = 'text/json';
	$execString = "python interHandle.py ";
	
	if (isset($_GET['service'])) {
		$execString .= " {$_GET['service']}";
		$output = exec($execString);
	} else {
		$formatType = 'text/html';
		$output = '
		<h1>Orlando Citygram API</h1>
		<p>Hi. My job is to take data streams from the Orlando public data portal and format them to be Citygram compliant. Here is a list of service urls that are publically supported:</p>
		<p>
			<a href="http://orlando-citygram-api.azurewebsites.net/?service=landmarks">http://orlando-citygram-api.azurewebsites.net/?service=landmarks</a><br>
			<a href="http://orlando-citygram-api.azurewebsites.net/?service=police">http://orlando-citygram-api.azurewebsites.net/?service=police</a>
		</p>
		<p>This is a project by <a href="http://codefororlando.com">Code For Orlando</a>. For any issues, contact Michael duPont at <a href="mailto:michael@mdupont.com">michael@mdupont.com</a></p>
		';
	}
	
	header("Access-Control-Allow-Origin: *");
	header("Content-Type: {$formatType}");
	echo "{$output}";
?>
