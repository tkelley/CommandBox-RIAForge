/**
 * This command shows you all of the valid RIAForge categories you can use when filtering records using the "riaforge show" command.
 **/
component extends="commandbox.system.BaseCommand" aliases="" excludeFromHelp=false {
	
	property name="RIAForge" inject="commandbox.commands.riaforge.riaforge";
	
	function init(){
		return super.init( argumentCollection = arguments );
	}
	
	// Lazy RiaForge categories.
	function getRIAForgeCategories(){
		// Get and cache a list of valid RIAForge categories
		if(!structKeyExists( variables, 'RIAForgeCategories') OR variables.RIAForgeCategories[1][1] == 0) {
			variables.RIAForgeCategories = RIAForge.getCategories();			
		}
		
		return variables.RIAForgeCategories;
	}
	
	function run(){
		print.line()
			.blackOnWhiteLine('Category')
			.line();

		var categories = getRIAForgeCategories();
		
		for(var i=1; i <= arrayLen(categories); i++) {
			print.boldText(categories[i][2])
				.line();
		}
	}

}