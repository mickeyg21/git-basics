<link href="css/bootstrap.min.css" rel="stylesheet" />
<!--- set global parameters --->
<!--- <style type="text/css">
p {
	padding-bottom: 20px;
}
</style> --->




 <cfparam name="url.search" type="string" default="">
<cfparam name="results" type="boolean" default="False">
<cfparam name="valid" type="boolean" default="True"> 

<!--- if form is submitted, include validation page --->
<cfif isDefined('form.gosearch')>
	<cfinclude template="lookup.cfm">
</cfif>

<cfoutput>
<div class="container-fluid">
<div class = "row well">
<div class="col-md-4 well>  
<h3 class="heading">Vendor Name/Code Search</h3> 
<form role="form" name="vendor" action="index.cfm?search=vendor" method="post">
		<!--- <div class="form-group"> --->
			<label for="vsvenname">Search Vendor Name / Code</label>
			<input class="form-control" name="vsvenname" id="vsvenname" type="text" maxlength="10" placeholder="Enter Vendor Name or Number" <cfif isDefined('form.vsvenname')>value="#form.vsvenname#"</cfif>>
		<!-- end form group -->
		<!--- <div class="form-group"> --->
			<input class="form-control" type="hidden" name="gosearch" value="go">
			<input class="btn btn-primary pull-right" id="submit" type="Submit" name="search" value="Search"></br></br>
		
	</form>
  </div>
</div>
</div>
<cfif IsDefined('url.vsvencode')>
<!---do nothing--->
<cfelse>
<cfset url.vsvencode = "">
</cfif> 
 
 <cfform action="po_action.cfm" method = "post" >
	
<!--- <table> --->
<div class = "row well">
   <div class="col-md-4 well col-md-8">
	
 <h3 class="heading">Purchase Order Search Form </br>(Advantage 3 Only)</h3> 

<table class= "table-condensed table-responsive table-hover">
	<tr>
		 <td>Vendor Code:</td>
		 
 <cfif '#url.vsvencode#' is ""> 
		<td><cfinput type="Text" id="vencode" class="form-control sm" placeholder="optional (eg. hom6045500)" name="vencode" message="You must enter a Vendor Code."  size="12"  maxlength="12"></td><td><i><font size="-1"></font></i></td>
		<cfelse>

		<!---If Vencode is not spaces, populate the value with the url.vsvencode.  this saves the user from having to key it in--->

		
		<td><input type="Text" id="vencode" placeholder="optional (eg. hom6045500)"name="vencode" value="#vsvencode#" size="12" maxlength="10"></td>
		
</cfif>
		
		
			
	</tr>
	
	<!---This is the vendor address indicator input--->
		
	<!---This is the Invoice number input--->
	
	<!---This is the Purchase Order Input--->
	
	
	<TR>
  		<TD>PO Type:</TD>
		<TD><select name="POType" class="form-control responsive">
				<option value="all" selected class="well-sm">All
				<option value="CT">CT
				<option value="CTM">CTM
				<option value="PO">PO
				<option value="DO">DO
				<option value="DOM">DOM
				<option value="CBDL">CBDL
			</SELECT>
		</TD>
		<td></td>
  	</TR>
	
	
	<tr>
		<td>Doc Dept Code:</td>
		<td><input type="Text" name="dept" class="form-control well-sm" placeholder="optional (eg. 7400)" size="4" maxlength="4" ></td>
		<td></td>
	</tr>
	
	
	
	<!---This is the Payment Voucher Input--->
	
	<tr>
		<td>DOC ID:</td>
		<td><input type="text" name="doc_id" class="form-control" placeholder="optional (eg. 07110503309)" size="20" maxlength="20"></td>
<td></td>
	</tr>
	
	<tr>
		<td>Comm. Description <strong>OR</strong> Code:</td>
		<td><input type="Text" class="form-control" placeholder="optional (eg. computer or 91829)" name="CommDescription"  size="30" maxlength="30" ></td>
<td></td>
	</tr>
	
	
	
	<tr>
		<td>Master Agreement (MA):</td>
		<td><input type="Text" class="form-control" placeholder="optional (eg. S030396)" name="MA"  size="14"maxlength="14" ></td>
<td></td>
	</tr>
	
	<tr>
		<td>Budget Fiscal Year:</td>
		<td><input type="Text" name="BFY" class="form-control" placeholder="optional (eg. 2007)"   size="4"maxlength="4" ></td>
<td></td>
	</tr>
	
</table>


<!---This is where the date range starts--->


	
	<table>
			
	<tr>
		<tr>Purchase Order Date Range:</tr>
		<br />
		
<tr>
	<label>Date From</label><div class="input-group date" id="dp_start"><input class="form-control " name="FromDate" placeholder=" Enter mm/dd/yyyy" type="text" maxlength="10"> 
		<span class="input-group-addon"><i class="splashy-calendar_day_up"></i></span>
			</div> <!-- end input-group -->
			<span class="help-block"></span>
		
			<label>Date To</label>
			<div class="input-group date" id="dp_end"><input class="form-control" name="ToDate" placeholder="Enter mm/dd/yyyy" type="text" maxlength="10"><span class="input-group-addon"><i class="splashy-calendar_day_down"></i></span>
			</div>	</tr>
		
</table>



<table>

<tr>
  	<b><TR>Purchase Order Status</tr></b>
	<td><CFINPUT type = "Radio" name = "status" value="open" checked="Yes">Open Purchase Orders&nbsp;
	    <CFINPUT type = "Radio" name = "status" value ="closed">Closed Purchase Orders&nbsp;
  	   <cfinput type="Radio" name="status" value="all" >All Purchase Orders</td>
</TR>

<tr>
<td>
<input class="btn btn-primary pull-right"type="submit" value="Search" onClick="this.form.submit();this.disabled='true';this.value='Please wait while your request is processed';">
</td>
<td>&nbsp</td>
</tr>
	
</table>
	
</cfform>
 </div>
</div></div>
<cfif results and valid> 

<div class="col-md-5"> 
  
    <h3>Search Results (Please select from the Vendor ID below)
			 <!--- not working yet --->
			<!--- <div class="btn-group pull-right">
				<a class="btn btn-warning btn-xs" href="##">EXCEL</a>
				<a class="btn btn-warning btn-xs" href="##">PDF</a>
				<a class="btn btn-warning btn-xs" href="##">EMAIL</a>
			</div>  --->
		</h3>
	<!--- include search results --->

<cfinclude template="search_results.cfm"> 

	
<!-- end col 9 -->
</cfif>  
</div></div>
</cfoutput>
</div>
