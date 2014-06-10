component excludeFromHelp=true {

	function init(){
		// RIAForge errors if I try to get it's WSDL, so I'm using HTTP calls instead
		variables.httpService = new http(
			url="http://www.riaforge.org/boltapi/api.cfc?returnFormat=JSON",
			method="post"
		);
		
		variables.genericErrorMessage = "Could not query RIAForge.org!";

		return this;
	}

	function getCategories(){
		var categories = [];
		variables.httpService.clearParams();
		variables.httpService.addParam(type="url", name="method", value="getCategories");

		try{
			var httpResult = variables.httpService.send().getPrefix();
			
			if(httpResult.status_code == 200){
				categories = deserializeJSON(httpResult.filecontent).DATA;
			}else{
				categories = [["0",variables.genericErrorMessage],["0",httpResult.statuscode]];
			}
		}catch (any e){
			categories = [["0",variables.genericErrorMessage],["0",e.message]];
		}

		return categories;
	}
	
	function getProject(required numeric id){
		var project = {};
		variables.httpService.clearParams();
		variables.httpService.addParam(type="url", name="method", value="getProject");
		variables.httpService.addParam(type="url", name="id", value="#id#");

		try{
			var httpResult = variables.httpService.send().getPrefix();
			
			if(httpResult.status_code == 200){
				httpResult = deserializeJSON(httpResult.filecontent);
				var data = httpResult.DATA;
				var columns = httpResult.COLUMNS;
				
				for(var i=1; i <= arrayLen(columns); i++){
					project[columns[i]] = data[i];
				}
			}else{
				project = {
					id = 0,
					name = "Error",
					shortDescription = httpResult.statusCode
				};
			}
		}catch (any e){
			project = {
				id = 0,
				name = "Error",
				shortDescription = variables.genericErrorMessage
			};
		}

		return project;
	}
	
	function getProjects(required numeric categoryid){
		var projects = [];
		variables.httpService.clearParams();
		variables.httpService.addParam(type="url", name="method", value="getProject");
		variables.httpService.addParam(type="url", name="categoryid", value="#categoryid#");

		try{
			var httpResult = variables.httpService.send().getPrefix();
			
			if(httpResult.status_code == 200){
				httpResult = deserializeJSON(httpResult.filecontent);
				var data = httpResult.DATA;
				
				for(var i=1; i <= arrayLen(data); i++){
					projects[i] = {
						id				 = data[i][1],
						name			 = data[i][2],
						shortDescription = data[i][3],
						author			 = data[i][4],
						userid			 = data[i][5],
						version			 = data[i][6],
						urlName			 = data[i][7],
						total			 = data[i][8]
					};
				}
			}else{
				project = {
					id = 0,
					name = "Error",
					shortDescription = httpResult.statusCode
				}
			}
		}catch (any e){
			categories = [["0",variables.genericErrorMessage],["0",e.message]];
		}
	}
}