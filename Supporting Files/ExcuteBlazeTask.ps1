
 param (
    [string]$apikey="b9107809a101b8b788e9964f",
    [string]$apisecret="24da75ad1302cfb986fe84846288e3c9aecb61742a269f0927db60b286aedbf4f9c28df6",
    [string]$harborId="5ed4c39b0bab192260527833" ,
	[string]$shipId="5ed4e8156fcfa37686051d63", 
	[int]$secondstowait=10 
    )

try
{ 
	$CreateTestResponse="";
	$BasicAuthKey  =  $apikey  +":" +$apisecret;
	$BasicAuth = [System.Text.Encoding]::UTF8.GetBytes($BasicAuthKey);
	$AuthorizationKey = "Basic "+ [System.Convert]::ToBase64String($BasicAuth) ;
	$hdrs = @{};
	$hdrs.Add("Authorization",$AuthorizationKey);
	 
               $TestDeatilURL = 'https://a.blazemeter.com/api/v4/private-locations/'+$harborId;
           try {				 
				
				$StartTestResponse = Invoke-RestMethod $TestDeatilURL -Method GET -ContentType 'application/json' -Headers $hdrs;
                if($StartTestResponse -ne "")
			    {

			  # Write-Host "Got response"
				$data2 = $StartTestResponse | ConvertTo-Json  -Depth 4;
				$jsonObj2 = $data2 | ConvertFrom-Json;
				$resultObj2 = $jsonObj2.result | ConvertTo-Json -Depth 4;
				$resultObj2 = $resultObj2 | ConvertFrom-Json;
				$shipObj = $resultObj2.ships | ConvertTo-Json -Depth 4
				$shipJSONObj = $shipObj | ConvertFrom-Json;
				$shipJSONObj2 = $shipJSONObj | ConvertTo-Json -Depth 4;
				Write-Host $shipJSONObj2.id
				$parsed = $shipJSONObj2 | convertfrom-json;
                # Write-Host $shipJSONObj2.id
			    $AgentAvailable='false';
				foreach($line in $parsed){
				   if($line.id -eq $shipId -and $line.state -eq "idlee")
				   {					   
						Write-Host "Agent Available"
						$AgentAvailable='true';
				   }
				  
				}			
			   }
			   if($AgentAvailable -eq 'false')
			   {
				    Start-Sleep -s $secondstowait
					Write-Host "Wait for Agent done"
					
					#check one more time Agent is available
				  $StartTestResponse = Invoke-RestMethod $TestDeatilURL -Method GET -ContentType 'application/json' -Headers $hdrs;
                  if($StartTestResponse -ne "")
			      {

			  # Write-Host "Got response"
							$data2 = $StartTestResponse | ConvertTo-Json  -Depth 4;
							$jsonObj2 = $data2 | ConvertFrom-Json;
							$resultObj2 = $jsonObj2.result | ConvertTo-Json -Depth 4;
							$resultObj2 = $resultObj2 | ConvertFrom-Json;
							$shipObj = $resultObj2.ships | ConvertTo-Json -Depth 4
							$shipJSONObj = $shipObj | ConvertFrom-Json;
							$shipJSONObj2 = $shipJSONObj | ConvertTo-Json -Depth 4;
							Write-Host $shipJSONObj2.id
							$parsed = $shipJSONObj2 | convertfrom-json;
							# Write-Host $shipJSONObj2.id
							$AgentAvailable='false';
							foreach($line in $parsed){
							   if($line.id -eq $shipId -and $line.state -eq "idlee")
							   {					   
									Write-Host "Agent Available"
									$AgentAvailable='true';
							   }
							   else
							   {
								   Write-Host "Agent still seems busy...please come after sometime";
								   Exit 1;
							   }
							  
							}			
						   }
					#Exit 1; 
			   }
		    }				
				catch
				{	
				}
				
}
catch
{
	                 $statuscode = $_.Exception.Response.StatusCode.value__ ;					
					if($statuscode -eq '401')
					{
					  Write-Host "Test Result: Unauthorized. Please check API Key and API Secret."; 
					  Write-Host "##vso[task.complete result=Failed;]DONE";		
					  exit 1;	
					 					
					}
					else
					{					    
					    Write-Host "Unable to start the test. For more details check below error details."
						Write-Host "Error Code:" $_.Exception.Response.StatusCode.value__ 
					    Write-Host "Error Details:" $_.ErrorDetails.Message;
						Write-Host "##vso[task.complete result=Failed;]DONE";		
                        exit 1;
					}
					Write-Host "Error Code:" $_.Exception.Response.StatusCode.value__ 
					Write-Host "Error Details:" $_.ErrorDetails.Message; exit;
}
	


